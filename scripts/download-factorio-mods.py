#!/usr/bin/env python3
"""Download the complete Factorio Mod Portal dependency closure for a mod."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
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
    )


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

    return max(compatible, key=lambda release: version_parts(release.version))


class DependencyResolver:
    def __init__(
        self,
        factorio_version: str,
        fetch_metadata: Callable[[str], Mapping[str, object]],
        builtin_mods: frozenset[str] = BUILTIN_MODS,
    ) -> None:
        self.factorio_version = factorio_version
        self.fetch_metadata = fetch_metadata
        self.builtin_mods = builtin_mods
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
        for declaration in dependencies:
            dependency = parse_dependency(declaration)
            if dependency is None or dependency.name in self.builtin_mods:
                continue
            self.constraints[dependency.name].append(dependency)
            self._resolve_mod(dependency.name)

        return [self.releases[name] for name in sorted(self.releases)]

    def _resolve_mod(self, name: str) -> None:
        metadata = self.fetch_metadata(name)
        release = select_release(
            name,
            metadata,
            self.factorio_version,
            self.constraints[name],
        )
        self.releases[name] = release


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

    def download(self, release: Release, mods_dir: Path) -> Path:
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


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mods-dir", required=True, type=Path)
    parser.add_argument("--from-info", required=True, type=Path)
    parser.add_argument("--username", default=os.environ.get("FACTORIO_MOD_PORTAL_USERNAME"))
    parser.add_argument("--token", default=os.environ.get("FACTORIO_MOD_PORTAL_TOKEN"))
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not args.username or not args.token:
        raise DownloadError(
            "FACTORIO_MOD_PORTAL_USERNAME and FACTORIO_MOD_PORTAL_TOKEN are required"
        )

    try:
        root_info = json.loads(args.from_info.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise DownloadError(f"Cannot read {args.from_info}: {error}") from error
    if not isinstance(root_info, Mapping):
        raise DownloadError(f"{args.from_info} must contain a JSON object")

    args.mods_dir.mkdir(parents=True, exist_ok=True)
    client = ModPortalClient(args.username, args.token)
    releases = DependencyResolver(
        str(root_info.get("factorio_version", "")), client.fetch_metadata
    ).resolve(root_info)
    for release in releases:
        client.download(release, args.mods_dir)
        print(f"Downloaded {release.name} {release.version}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except DownloadError as error:
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(1)
