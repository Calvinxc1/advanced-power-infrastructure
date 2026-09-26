#!/usr/bin/env python3
"""Download the complete Factorio Mod Portal dependency closure for a mod."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, Iterable, Mapping
from urllib.error import HTTPError, URLError
from urllib.parse import parse_qsl, quote, urlencode, urljoin, urlsplit, urlunsplit
from urllib.request import Request, urlopen


PORTAL_URL = "https://mods.factorio.com"
BUILTIN_MODS = frozenset({"base", "elevated-rails", "quality", "recycler", "space-age"})
DEPENDENCY_PATTERN = re.compile(
    r"^\s*(?P<prefix>\(\?\)|\?|\+|!|~)?\s*"
    r"(?P<name>[A-Za-z0-9_-]+)"
    r"(?:\s*(?P<operator>>=|<=|=|>|<)\s*(?P<version>[0-9][0-9.]*)\s*)?$"
)


class DownloadError(RuntimeError):
    """Raised when the dependency closure cannot be downloaded safely."""


@dataclass(frozen=True)
class Dependency:
    name: str
    operator: str | None = None
    version: str | None = None
    optional: bool = False


@dataclass(frozen=True)
class Release:
    name: str
    version: str
    file_name: str
    download_url: str
    sha1: str
    dependencies: tuple[str, ...]


def parse_dependency(value: str) -> Dependency | None:
    """Parse dependencies that should be installed for full-modlist validation.

    Required dependencies have no prefix. Recommended (`+`), optional (`?`), and
    hidden optional (`(?)`) dependencies are deliberately included. Incompatible
    (`!`) and no-load-order (`~`) declarations are not installable dependencies.
    """

    match = DEPENDENCY_PATTERN.fullmatch(value)
    if not match:
        raise DownloadError(f"Unsupported dependency declaration: {value!r}")

    if match.group("prefix") in {"!", "~"}:
        return None

    return Dependency(
        name=match.group("name"),
        operator=match.group("operator"),
        version=match.group("version"),
        optional=match.group("prefix") in {"?", "(?)"},
    )


def required_dependencies(release: Release) -> list[Dependency]:
    """The mods a release cannot load without: required and `~` declarations."""

    required = []
    for declaration in release.dependencies:
        match = DEPENDENCY_PATTERN.fullmatch(declaration)
        if not match or match.group("prefix") not in {None, "~"}:
            continue
        required.append(
            Dependency(
                name=match.group("name"),
                operator=match.group("operator"),
                version=match.group("version"),
            )
        )
    return required


def incompatible_builtin(release: Release) -> str | None:
    """The built-in mod a release declares itself incompatible with, if any.

    Validation always enables the built-ins it can see, so Space Exploration,
    which declares `! space-age`, can never load in a Space Age run.
    """

    for declaration in release.dependencies:
        match = DEPENDENCY_PATTERN.fullmatch(declaration)
        if match and match.group("prefix") == "!" and match.group("name") in BUILTIN_MODS:
            return match.group("name")
    return None


def running_factorio_version() -> str | None:
    """The version of the Factorio these downloads are for.

    FACTORIO_VERSION when set (the CI image exports it), else the binary's own
    report. None when neither is available.
    """

    declared = os.environ.get("FACTORIO_VERSION")
    if declared:
        return declared.strip()

    binary = os.environ.get("FACTORIO_BIN") or shutil.which("factorio")
    if not binary or not os.access(binary, os.X_OK):
        return None
    try:
        output = subprocess.run(
            [binary, "--version"], capture_output=True, text=True, timeout=60, check=True
        ).stdout
    except (OSError, subprocess.SubprocessError):
        return None
    match = re.search(r"Version:\s*([0-9][0-9.]*)", output)
    return match.group(1) if match else None


def loads_on(release: Release, factorio_version: str | None) -> bool:
    """Whether the running Factorio satisfies the release's `base` constraint."""

    if factorio_version is None:
        return True
    for declaration in release.dependencies:
        dependency = parse_dependency(declaration)
        if dependency is not None and dependency.name == "base":
            return satisfies(factorio_version, dependency)
    return True


def version_parts(value: str) -> tuple[int, ...]:
    if not re.fullmatch(r"[0-9]+(?:\.[0-9]+)*", value):
        raise DownloadError(f"Unsupported mod version: {value!r}")
    return tuple(int(part) for part in value.split("."))


def compare_versions(left: str, right: str) -> int:
    left_parts = version_parts(left)
    right_parts = version_parts(right)
    length = max(len(left_parts), len(right_parts))
    left_normalized = left_parts + (0,) * (length - len(left_parts))
    right_normalized = right_parts + (0,) * (length - len(right_parts))
    return (left_normalized > right_normalized) - (left_normalized < right_normalized)


def satisfies(version: str, dependency: Dependency) -> bool:
    if dependency.operator is None or dependency.version is None:
        return True

    comparison = compare_versions(version, dependency.version)
    return {
        "=": comparison == 0,
        ">": comparison > 0,
        ">=": comparison >= 0,
        "<": comparison < 0,
        "<=": comparison <= 0,
    }[dependency.operator]


def release_from_api(name: str, raw: Mapping[str, object]) -> Release:
    info_json = raw.get("info_json")
    if not isinstance(info_json, Mapping):
        raise DownloadError(f"Release metadata for {name!r} is missing info_json")

    dependencies = info_json.get("dependencies", [])
    if not isinstance(dependencies, list) or not all(isinstance(item, str) for item in dependencies):
        raise DownloadError(f"Release metadata for {name!r} has invalid dependencies")

    fields = ("version", "file_name", "download_url", "sha1")
    if not all(isinstance(raw.get(field), str) and raw[field] for field in fields):
        raise DownloadError(f"Release metadata for {name!r} is incomplete")

    return Release(
        name=name,
        version=str(raw["version"]),
        file_name=str(raw["file_name"]),
        download_url=str(raw["download_url"]),
        sha1=str(raw["sha1"]),
        dependencies=tuple(dependencies),
    )


def select_release(
    name: str,
    metadata: Mapping[str, object],
    factorio_version: str,
    constraints: Iterable[Dependency],
    running_version: str | None = None,
) -> Release:
    releases = metadata.get("releases")
    if not isinstance(releases, list):
        raise DownloadError(f"Mod Portal metadata for {name!r} has no releases")

    compatible: list[Release] = []
    for raw in releases:
        if not isinstance(raw, Mapping):
            continue
        info_json = raw.get("info_json")
        if not isinstance(info_json, Mapping) or info_json.get("factorio_version") != factorio_version:
            continue
        release = release_from_api(name, raw)
        if all(satisfies(release.version, dependency) for dependency in constraints):
            compatible.append(release)

    if not compatible:
        requested = ", ".join(
            f"{dependency.operator or ''}{dependency.version or ''}" for dependency in constraints
        ) or "any version"
        raise DownloadError(
            f"No Factorio {factorio_version} release of {name!r} satisfies {requested}"
        )

    # A release's factorio_version names a series ("2.1"), not a patch level,
    # so the newest can still need a newer base than the Factorio installed --
    # which then refuses the whole mod list. Walk back to one that loads, and
    # say so, so image drift stays visible.
    compatible.sort(key=lambda release: version_parts(release.version), reverse=True)
    newest = compatible[0]
    for candidate in compatible:
        if loads_on(candidate, running_version):
            if candidate is not newest:
                print(
                    f"{name}: newest {factorio_version} release {newest.version} does not load on "
                    f"Factorio {running_version}; using {candidate.version} instead. "
                    "Update the CI image to test against the current release.",
                    file=sys.stderr,
                )
            return candidate
    raise DownloadError(
        f"No Factorio {factorio_version} release of {name!r} loads on Factorio {running_version}"
    )


class DependencyResolver:
    def __init__(
        self,
        factorio_version: str,
        fetch_metadata: Callable[[str], Mapping[str, object]],
        builtin_mods: frozenset[str] = BUILTIN_MODS,
        follow_requirements: bool = False,
        running_version: str | None = None,
    ) -> None:
        self.factorio_version = factorio_version
        self.fetch_metadata = fetch_metadata
        self.builtin_mods = builtin_mods
        self.follow_requirements = follow_requirements
        self.running_version = running_version
        self.constraints: dict[str, list[Dependency]] = defaultdict(list)
        self.releases: dict[str, Release] = {}

    def resolve(self, root_info: Mapping[str, object]) -> list[Release]:
        name = root_info.get("name")
        dependencies = root_info.get("dependencies", [])
        if not isinstance(name, str) or not name:
            raise DownloadError("--from-info must contain a non-empty mod name")
        if not isinstance(dependencies, list) or not all(isinstance(item, str) for item in dependencies):
            raise DownloadError("--from-info has invalid dependencies")

        # Only the dependencies declared directly on the mod under test are
        # resolved. Deliberately not recursive: a downloaded dependency's own
        # optional/recommended/hidden-optional dependencies are not pulled
        # in, since that can reach arbitrarily far into the Mod Portal graph
        # (e.g. a hidden-optional compatibility shim for a mod nobody has,
        # several hops away, with no Factorio-version-compatible release).
        #
        # With follow_requirements, each dependency's own hard requirements
        # are resolved as well, recursively; that is how an overhaul such as
        # Krastorio 2 is brought in with the mods it cannot load without.
        #
        # Without it, an optional dependency that could not load in this run
        # is skipped rather than downloaded: one with hard requirements the
        # closure does not include (it would abort the load), or one
        # incompatible with a built-in the run enables. Declaring it is a
        # load-order statement about real games, not a claim it can be
        # exercised here.
        parsed = [parse_dependency(declaration) for declaration in dependencies]
        declared = {dependency.name for dependency in parsed if dependency is not None}
        available = set(self.builtin_mods) | declared | {name}
        for dependency in parsed:
            if dependency is None or dependency.name in self.builtin_mods:
                continue
            self.constraints[dependency.name].append(dependency)
            if dependency.optional and not self.follow_requirements:
                release = self._select(dependency.name)
                reason = self._unloadable_reason(release, available)
                if reason is not None:
                    print(f"Skipped optional dependency {dependency.name}: it {reason}")
                    continue
            self._resolve_mod(dependency.name)

        return [self.releases[name] for name in sorted(self.releases)]

    def _select(self, name: str) -> Release:
        return select_release(
            name,
            self.fetch_metadata(name),
            self.factorio_version,
            self.constraints[name],
            self.running_version,
        )

    def _unloadable_reason(self, release: Release, available: set[str]) -> str | None:
        builtin = incompatible_builtin(release)
        if builtin is not None:
            return f"is incompatible with {builtin}"
        missing = sorted(
            dependency.name
            for dependency in required_dependencies(release)
            if dependency.name not in available
        )
        if missing:
            return "requires " + ", ".join(missing) + ", which this closure does not download"
        return None

    def _resolve_mod(self, name: str) -> None:
        if name in self.releases:
            return
        release = self._select(name)
        self.releases[name] = release
        if self.follow_requirements:
            for dependency in required_dependencies(release):
                if dependency.name in self.builtin_mods:
                    continue
                self.constraints[dependency.name].append(dependency)
                self._resolve_mod(dependency.name)


class ModPortalClient:
    def __init__(self, username: str, token: str) -> None:
        self.username = username
        self.token = token

    def fetch_metadata(self, name: str) -> Mapping[str, object]:
        url = f"{PORTAL_URL}/api/mods/{quote(name, safe='')}/full"
        try:
            with urlopen(Request(url, headers={"User-Agent": "advanced-power-infrastructure-ci"}), timeout=30) as response:
                result = json.load(response)
        except HTTPError as error:
            raise DownloadError(f"Mod Portal metadata request for {name!r} failed: HTTP {error.code}") from error
        except URLError as error:
            raise DownloadError(f"Mod Portal metadata request for {name!r} failed: {error.reason}") from error

        if not isinstance(result, Mapping):
            raise DownloadError(f"Mod Portal metadata for {name!r} is not an object")
        return result

    def download(self, release: Release, mods_dir: Path, cache_dir: Path | None = None) -> Path:
        # With a cache, the archive is fetched into (or found in) the cache
        # and linked into mods_dir, so mods directories built from
        # overlapping closures share one download of each release.
        if cache_dir is not None and cache_dir.resolve() != mods_dir.resolve():
            cached = cache_dir / release.file_name
            if not (cached.exists() and file_sha1(cached) == release.sha1.lower()):
                self.download(release, cache_dir)
            destination = mods_dir / release.file_name
            if not destination.exists():
                destination.symlink_to(cached.resolve())
            return destination

        parsed = urlsplit(release.download_url)
        if parsed.scheme or parsed.netloc or not parsed.path.startswith("/download"):
            raise DownloadError(f"Mod Portal returned an unsafe download path for {release.name!r}")
        if Path(release.file_name).name != release.file_name or not release.file_name.endswith(".zip"):
            raise DownloadError(f"Mod Portal returned an unsafe file name for {release.name!r}")

        query = dict(parse_qsl(parsed.query, keep_blank_values=True))
        query.update({"username": self.username, "token": self.token})
        url = urljoin(PORTAL_URL, urlunsplit(("", "", parsed.path, urlencode(query), "")))
        destination = mods_dir / release.file_name
        temporary_path: Path | None = None

        try:
            with urlopen(Request(url, headers={"User-Agent": "advanced-power-infrastructure-ci"}), timeout=60) as response:
                with tempfile.NamedTemporaryFile(dir=mods_dir, delete=False) as temporary:
                    temporary_path = Path(temporary.name)
                    digest = hashlib.sha1()
                    while chunk := response.read(1024 * 1024):
                        digest.update(chunk)
                        temporary.write(chunk)
            if digest.hexdigest().lower() != release.sha1.lower():
                raise DownloadError(f"SHA-1 mismatch while downloading {release.name!r}")
            temporary_path.replace(destination)
            temporary_path = None
        except HTTPError as error:
            raise DownloadError(f"Mod download for {release.name!r} failed: HTTP {error.code}") from error
        except URLError as error:
            raise DownloadError(f"Mod download for {release.name!r} failed: {error.reason}") from error
        finally:
            if temporary_path is not None:
                temporary_path.unlink(missing_ok=True)

        return destination


def file_sha1(path: Path) -> str:
    digest = hashlib.sha1()
    with path.open("rb") as handle:
        while chunk := handle.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest().lower()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mods-dir", required=True, type=Path)
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--from-info", type=Path)
    source.add_argument(
        "--mod",
        action="append",
        help="Mod Portal name to download with its hard requirements; repeatable.",
    )
    parser.add_argument("--factorio-version", default="2.1", help="Series for --mod (default 2.1).")
    parser.add_argument(
        "--cache-dir",
        type=Path,
        help="Keep archives here and link them into --mods-dir, reusing any already present.",
    )
    parser.add_argument("--username", default=os.environ.get("FACTORIO_MOD_PORTAL_USERNAME"))
    parser.add_argument("--token", default=os.environ.get("FACTORIO_MOD_PORTAL_TOKEN"))
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not args.username or not args.token:
        raise DownloadError(
            "FACTORIO_MOD_PORTAL_USERNAME and FACTORIO_MOD_PORTAL_TOKEN are required"
        )

    if args.mod:
        root_info = {
            "name": "overhaul-validation",
            "factorio_version": args.factorio_version,
            "dependencies": args.mod,
        }
    else:
        try:
            root_info = json.loads(args.from_info.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as error:
            raise DownloadError(f"Cannot read {args.from_info}: {error}") from error
        if not isinstance(root_info, Mapping):
            raise DownloadError(f"{args.from_info} must contain a JSON object")

    args.mods_dir.mkdir(parents=True, exist_ok=True)
    if args.cache_dir:
        args.cache_dir.mkdir(parents=True, exist_ok=True)
    client = ModPortalClient(args.username, args.token)
    releases = DependencyResolver(
        str(root_info.get("factorio_version", "")),
        client.fetch_metadata,
        follow_requirements=bool(args.mod),
        running_version=running_factorio_version(),
    ).resolve(root_info)
    for release in releases:
        client.download(release, args.mods_dir, args.cache_dir)
        print(f"Downloaded {release.name} {release.version}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except DownloadError as error:
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(1)
