#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

python3 - <<'PY'
import json
from pathlib import Path

json.load(open("src/info.json", encoding="utf-8"))

try:
    import yaml
except ImportError:
    pass
else:
    for path in sorted(Path(".governance").rglob("*.yaml")):
        yaml.safe_load(path.read_text(encoding="utf-8"))
PY

for file in $(rg --files -g '*.lua' src); do
  luac -p "$file"
done

./scripts/factorio-validate.sh
