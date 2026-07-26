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
    def test_recursively_resolves_every_supported_dependency_kind(self) -> None:
        catalog = {
            "required": metadata("required", [release("required", "1.0.0", ["transitive"])]),
            "recommended": metadata("recommended", [release("recommended", "1.0.0")]),
            "optional": metadata("optional", [release("optional", "1.0.0")]),
            "hidden": metadata("hidden", [release("hidden", "1.0.0")]),
            "transitive": metadata("transitive", [release("transitive", "1.0.0")]),
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
            ["hidden", "optional", "recommended", "required", "transitive"],
        )

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

    def test_circular_dependency_is_an_error_even_when_optional(self) -> None:
        catalog = {
            "first": metadata("first", [release("first", "1.0.0", ["? second"])]),
            "second": metadata("second", [release("second", "1.0.0", ["(?) first"])]),
        }
        resolver = MODULE.DependencyResolver("2.1", catalog.__getitem__)

        with self.assertRaisesRegex(MODULE.DownloadError, "Circular Factorio mod dependency"):
            resolver.resolve({"name": "local-mod", "dependencies": ["? first"]})


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


if __name__ == "__main__":
    unittest.main()
