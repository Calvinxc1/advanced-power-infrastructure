#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

python3 - <<'PY' "$repo_root/src" "$repo_root/dist"
import json
import re
import sys
import zipfile
from pathlib import Path

src_dir = Path(sys.argv[1])
dist_dir = Path(sys.argv[2])

with (src_dir / "info.json").open(encoding="utf-8") as f:
    info = json.load(f)

name = info["name"]
version = info["version"]

if not re.fullmatch(r"[A-Za-z0-9_-]+", name):
    raise SystemExit(f"Invalid mod name for packaging: {name}")

if not re.fullmatch(r"\d+\.\d+\.\d+", version):
    raise SystemExit(f"Invalid Factorio mod version: {version}")

package_name = f"{name}_{version}"
zip_path = dist_dir / f"{package_name}.zip"
dist_dir.mkdir(parents=True, exist_ok=True)

if zip_path.exists():
    zip_path.unlink()

with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    archived_paths = set()
    for path in sorted(src_dir.rglob("*")):
        if path.is_dir():
            continue
        relative = path.relative_to(src_dir)
        archive_path = Path(package_name) / relative
        archive.write(path, archive_path)
        archived_paths.add(archive_path)

    license_path = src_dir.parent / "LICENSE"
    license_archive_path = Path(package_name) / "LICENSE"
    if license_path.exists() and license_archive_path not in archived_paths:
        archive.write(license_path, license_archive_path)

print(zip_path)
PY
