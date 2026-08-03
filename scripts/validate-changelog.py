#!/usr/bin/env python3
"""Validate a Factorio changelog.txt against the documented format:
https://lua-api.factorio.com/latest/auxiliary/changelog-format.html
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

SEPARATOR = "-" * 99
VERSION_PATTERN = re.compile(r"^Version: (\d+\.\d+\.\d+)$")
CATEGORY_PATTERN = re.compile(r"^  ([A-Za-z ]+):$")
ENTRY_PATTERN = re.compile(r"^    - (.*)$")
CONTINUATION_PATTERN = re.compile(r"^      (.*)$")

RECOGNIZED_CATEGORIES = {
    "Major Features", "Features", "Minor Features", "Graphics", "Sounds",
    "Optimizations", "Balancing", "Combat Balancing", "Circuit Network",
    "Changes", "Bugfixes", "Modding", "Scripting", "Gui", "Control",
    "Translation", "Debug", "Ease of use", "Info", "Locale", "Compatibility",
}


def validate(text: str) -> list[str]:
    errors: list[str] = []
    lines = text.split("\n")
    if lines and lines[-1] == "":
        lines = lines[:-1]

    for i, line in enumerate(lines, 1):
        if "\t" in line:
            errors.append(f"line {i}: contains a tab character")
        if line != line.rstrip():
            errors.append(f"line {i}: trailing whitespace")

    if not lines or lines[0] != SEPARATOR:
        errors.append(f"line 1: file must start with a {len(SEPARATOR)}-dash separator")
        return errors

    versions_seen: dict[str, int] = {}
    i = 0
    n = len(lines)
    while i < n:
        if lines[i] != SEPARATOR:
            errors.append(f"line {i + 1}: expected a {len(SEPARATOR)}-dash separator, got {lines[i]!r}")
            i += 1
            continue
        sep_line = i + 1
        i += 1
        if i >= n:
            errors.append(f"line {sep_line}: separator not followed by a Version line")
            break

        match = VERSION_PATTERN.match(lines[i])
        if not match:
            errors.append(f"line {i + 1}: expected 'Version: X.Y.Z', got {lines[i]!r}")
        else:
            version = match.group(1)
            if version == "0.0.0":
                errors.append(f"line {i + 1}: version 0.0.0 is not valid")
            if version in versions_seen:
                errors.append(
                    f"line {i + 1}: duplicate version {version!r} "
                    f"(first seen at line {versions_seen[version]})"
                )
            else:
                versions_seen[version] = i + 1
        i += 1

        date_lines = 0
        while i < n and lines[i].startswith("Date:"):
            date_lines += 1
            i += 1
        if date_lines > 1:
            errors.append(f"line {i}: more than one Date line in this version section")

        current_category: str | None = None
        seen_entries: set[str] = set()
        while i < n and lines[i] != SEPARATOR:
            line = lines[i]
            if line == "":
                i += 1
                continue

            category_match = CATEGORY_PATTERN.match(line)
            if category_match:
                current_category = category_match.group(1)
                if current_category not in RECOGNIZED_CATEGORIES:
                    errors.append(
                        f"line {i + 1}: category {current_category!r} is not a recognized "
                        f"Factorio changelog category"
                    )
                seen_entries = set()
                i += 1
                continue

            entry_match = ENTRY_PATTERN.match(line)
            if entry_match:
                if current_category is None:
                    errors.append(f"line {i + 1}: entry appears before any category line")
                entry_text = entry_match.group(1)
                if entry_text in seen_entries:
                    errors.append(
                        f"line {i + 1}: duplicate entry within category "
                        f"{current_category!r}: {entry_text!r}"
                    )
                seen_entries.add(entry_text)
                i += 1
                while i < n and CONTINUATION_PATTERN.match(lines[i]):
                    i += 1
                continue

            if line.startswith("  ") and not line.startswith("    "):
                errors.append(
                    f"line {i + 1}: looks like a category line but is missing its "
                    f"trailing colon, has the wrong indentation, or contains characters "
                    f"outside A-Z/a-z/space: {line!r}"
                )
                i += 1
                continue

            errors.append(f"line {i + 1}: does not match any valid changelog line format: {line!r}")
            i += 1

    return errors


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: validate-changelog.py <path-to-changelog.txt>", file=sys.stderr)
        return 2

    path = Path(sys.argv[1])
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as error:
        print(f"error: could not read {path}: {error}", file=sys.stderr)
        return 1

    errors = validate(text)
    if errors:
        print(f"{path}: {len(errors)} changelog format problem(s):", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    print(f"{path}: OK, matches https://lua-api.factorio.com/latest/auxiliary/changelog-format.html")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
