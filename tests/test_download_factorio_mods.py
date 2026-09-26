from __future__ import annotations

import importlib.util
import hashlib
import sys
import tempfile
import unittest
from pathlib import Path
from urllib.parse import parse_qs, urlsplit


SCRIPT_PATH = Path(__file__).parents[1] / "scripts" / "download-factorio-mods.py"
SPEC = importlib.util.spec_from_file_location("download_factorio_mods", SCRIPT_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def release(name: str, version: str, dependencies: list[str] | None = None) -> dict[str, object]:
    return {
        "version": version,
        "file_name": f"{name}_{version}.zip",
        "download_url": f"/download/{name}_{version}.zip",
        "sha1": "0" * 40,
        "info_json": {
            "factorio_version": "2.1",
            "dependencies": dependencies or [],
        },
    }


def metadata(name: str, releases: list[dict[str, object]]) -> dict[str, object]:
    return {"name": name, "releases": releases}


class DependencyParsingTests(unittest.TestCase):
    def test_includes_required_recommended_optional_and_hidden_optional(self) -> None:
        declarations = ["required >= 1.0.0", "+ recommended", "? optional", "(?) hidden"]
        self.assertEqual(
            [MODULE.parse_dependency(value).name for value in declarations],
            ["required", "recommended", "optional", "hidden"],
        )

    def test_ignores_incompatible_and_no_load_order_declarations(self) -> None:
        self.assertIsNone(MODULE.parse_dependency("! incompatible"))
        self.assertIsNone(MODULE.parse_dependency("~ load-order-only"))


class DependencyResolverTests(unittest.TestCase):
    def test_resolves_every_directly_declared_dependency_kind(self) -> None:
        catalog = {
            "required": metadata("required", [release("required", "1.0.0", ["transitive"])]),
            "recommended": metadata("recommended", [release("recommended", "1.0.0")]),
            "optional": metadata("optional", [release("optional", "1.0.0")]),
            "hidden": metadata("hidden", [release("hidden", "1.0.0")]),
        }
        resolver = MODULE.DependencyResolver("2.1", catalog.__getitem__)

        resolved = resolver.resolve(
            {
                "name": "local-mod",
                "dependencies": [
                    "base >= 2.1.0",
                    "required >= 1.0.0",
                    "+ recommended",
                    "? optional",
                    "(?) hidden",
                ],
            }
        )

        self.assertEqual(
            [item.name for item in resolved],
            ["hidden", "optional", "recommended", "required"],
        )

    def test_does_not_recurse_into_a_dependencys_own_dependencies(self) -> None:
        # Only what the mod under test declares directly gets resolved. A
        # downloaded dependency's own optional/recommended/hidden-optional
        # dependencies are deliberately not pulled in, since that graph can
        # reach arbitrarily far across the Mod Portal (e.g. a hidden-optional
        # compatibility shim several hops away with no compatible release).
        # "second" is intentionally absent from the catalog: if the resolver
        # tried to recurse into it, this test would fail with a KeyError.
        catalog = {
            "first": metadata("first", [release("first", "1.0.0", ["? second"])]),
        }
        resolver = MODULE.DependencyResolver("2.1", catalog.__getitem__)

        resolved = resolver.resolve({"name": "local-mod", "dependencies": ["? first"]})

        self.assertEqual([item.name for item in resolved], ["first"])

    def test_selects_latest_release_matching_dependency_constraint(self) -> None:
        catalog = {
            "dependency": metadata(
                "dependency",
                [release("dependency", "1.0.0"), release("dependency", "2.0.0")],
            )
        }
        resolver = MODULE.DependencyResolver("2.1", catalog.__getitem__)
        resolved = resolver.resolve(
            {"name": "local-mod", "dependencies": ["dependency < 2.0.0"]}
        )

        self.assertEqual(resolved[0].version, "1.0.0")


class DownloadTests(unittest.TestCase):
    def test_download_uses_authenticated_query_and_verifies_sha1(self) -> None:
        payload = b"mod archive"
        observed_urls: list[str] = []

        class Response:
            def __init__(self) -> None:
                self.offset = 0

            def __enter__(self) -> "Response":
                return self

            def __exit__(self, *_: object) -> None:
                return None

            def read(self, size: int) -> bytes:
                chunk = payload[self.offset : self.offset + size]
                self.offset += len(chunk)
                return chunk

        original_urlopen = MODULE.urlopen
        try:
            def fake_urlopen(request: object, timeout: int) -> Response:
                observed_urls.append(request.full_url)
                self.assertEqual(timeout, 60)
                return Response()

            MODULE.urlopen = fake_urlopen
            release_to_download = MODULE.Release(
                name="dependency",
                version="1.0.0",
                file_name="dependency_1.0.0.zip",
                download_url="/download/dependency_1.0.0.zip",
                sha1=hashlib.sha1(payload).hexdigest(),
                dependencies=(),
            )
            with tempfile.TemporaryDirectory() as directory:
                destination = MODULE.ModPortalClient("user", "token").download(
                    release_to_download, Path(directory)
                )
                self.assertEqual(destination.read_bytes(), payload)
        finally:
            MODULE.urlopen = original_urlopen

        query = parse_qs(urlsplit(observed_urls[0]).query)
        self.assertEqual(query, {"username": ["user"], "token": ["token"]})


class UnloadableOptionalDependencyTests(unittest.TestCase):
    """An optional dependency that could not load in the run is skipped."""

    def resolve(self, catalog: dict[str, object], dependencies: list[str]) -> list[str]:
        resolver = MODULE.DependencyResolver("2.1", catalog.__getitem__)
        return [item.name for item in resolver.resolve({"name": "local-mod", "dependencies": dependencies})]

    def test_optional_with_unmet_hard_requirements_is_skipped(self) -> None:
        # Krastorio 2 without flib and its assets aborts the load before this
        # mod's own code runs.
        catalog = {"overhaul": metadata("overhaul", [release("overhaul", "1.0.0", ["library", "~ assets"])])}
        self.assertEqual(self.resolve(catalog, ["base", "? overhaul"]), [])

    def test_optional_incompatible_with_a_builtin_is_skipped(self) -> None:
        catalog = {"no-expansion": metadata("no-expansion", [release("no-expansion", "1.0.0", ["! space-age"])])}
        self.assertEqual(self.resolve(catalog, ["base", "? no-expansion"]), [])

    def test_requirement_declared_alongside_is_available(self) -> None:
        catalog = {
            "overhaul": metadata("overhaul", [release("overhaul", "1.0.0", ["library"])]),
            "library": metadata("library", [release("library", "1.0.0")]),
        }
        self.assertEqual(self.resolve(catalog, ["? overhaul", "library"]), ["library", "overhaul"])

    def test_required_dependency_is_never_skipped(self) -> None:
        catalog = {"hard": metadata("hard", [release("hard", "1.0.0", ["unlisted"])])}
        self.assertEqual(self.resolve(catalog, ["hard"]), ["hard"])


class FollowRequirementsTests(unittest.TestCase):
    def test_hard_requirements_are_followed_but_optional_ones_are_not(self) -> None:
        # "shim" is absent from the catalog: following it would raise KeyError.
        catalog = {
            "overhaul": metadata("overhaul", [release("overhaul", "1.0.0", ["library", "~ assets", "? shim"])]),
            "library": metadata("library", [release("library", "1.0.0", ["base >= 2.1.0"])]),
            "assets": metadata("assets", [release("assets", "1.0.0")]),
        }
        resolver = MODULE.DependencyResolver("2.1", catalog.__getitem__, follow_requirements=True)
        resolved = resolver.resolve({"name": "cli", "dependencies": ["overhaul"]})
        self.assertEqual([item.name for item in resolved], ["assets", "library", "overhaul"])


class RunningVersionSelectionTests(unittest.TestCase):
    RELEASES = [
        release("overhaul", "2.1.2", ["base >= 2.1.0"]),
        release("overhaul", "2.1.3", ["base >= 2.1.20"]),
    ]

    def select(self, running: str | None) -> str:
        return MODULE.select_release("overhaul", metadata("overhaul", self.RELEASES), "2.1", [], running).version

    def test_newest_when_the_installed_factorio_loads_it(self) -> None:
        self.assertEqual(self.select("2.1.20"), "2.1.3")

    def test_walks_back_when_the_newest_needs_a_newer_base(self) -> None:
        # The CI image at 2.1.9 cannot load Krastorio2 2.1.3.
        self.assertEqual(self.select("2.1.9"), "2.1.2")

    def test_unknown_factorio_version_takes_the_newest(self) -> None:
        self.assertEqual(self.select(None), "2.1.3")

    def test_nothing_loadable_is_an_error(self) -> None:
        with self.assertRaises(MODULE.DownloadError):
            self.select("2.0.0")


class CacheTests(unittest.TestCase):
    def test_cached_archive_is_linked_without_downloading(self) -> None:
        payload = b"cached archive"
        cached_release = MODULE.Release(
            name="dependency",
            version="1.0.0",
            file_name="dependency_1.0.0.zip",
            download_url="/download/dependency_1.0.0.zip",
            sha1=hashlib.sha1(payload).hexdigest(),
            dependencies=(),
        )
        original_urlopen = MODULE.urlopen
        try:
            def fail_urlopen(*_: object, **__: object) -> None:
                raise AssertionError("a cached archive must not be downloaded again")

            MODULE.urlopen = fail_urlopen
            with tempfile.TemporaryDirectory() as directory:
                cache_dir, mods_dir = Path(directory) / "cache", Path(directory) / "mods"
                cache_dir.mkdir()
                mods_dir.mkdir()
                (cache_dir / cached_release.file_name).write_bytes(payload)
                destination = MODULE.ModPortalClient("user", "token").download(
                    cached_release, mods_dir, cache_dir
                )
                self.assertTrue(destination.is_symlink())
                self.assertEqual(destination.read_bytes(), payload)
        finally:
            MODULE.urlopen = original_urlopen


if __name__ == "__main__":
    unittest.main()
