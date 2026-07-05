#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mod_name="$(
  python3 - <<'PY' "$repo_root/src/info.json"
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    print(json.load(f)["name"])
PY
)"
mods_dir="${FACTORIO_MODS_DIR:-$HOME/.factorio/mods}"
factorio_bin="${FACTORIO_BIN:-}"

if [[ -z "$factorio_bin" ]]; then
  if command -v factorio >/dev/null 2>&1; then
    factorio_bin="$(command -v factorio)"
  elif [[ -x "$HOME/Games/steam/steamapps/common/Factorio/bin/x64/factorio" ]]; then
    factorio_bin="$HOME/Games/steam/steamapps/common/Factorio/bin/x64/factorio"
  else
    cat >&2 <<MSG
Factorio executable not found.

Set FACTORIO_BIN to your Factorio executable, for example:
  FACTORIO_BIN="/path/to/factorio/bin/x64/factorio" ./scripts/factorio-validate.sh
MSG
    exit 127
  fi
fi

if [[ ! -x "$factorio_bin" ]]; then
  echo "FACTORIO_BIN is not executable: $factorio_bin" >&2
  exit 127
fi

if [[ ! -d "$mods_dir" ]]; then
  echo "Factorio mods directory not found: $mods_dir" >&2
  exit 1
fi

expected_link="$mods_dir/$mod_name"
if [[ ! -e "$expected_link" ]]; then
  echo "Expected mod entry does not exist: $expected_link" >&2
  echo "Create it with:" >&2
  echo "  ln -s \"$repo_root/src\" \"$expected_link\"" >&2
  exit 1
fi

resolved="$(readlink -f "$expected_link")"
if [[ "$resolved" != "$repo_root/src" ]]; then
  echo "Unexpected mod entry target: $expected_link -> $resolved" >&2
  echo "Expected: $repo_root/src" >&2
  exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
config_dir="$tmp_dir/config"
write_dir="$tmp_dir/write"
mkdir -p "$config_dir" "$write_dir"

cat >"$config_dir/config.ini" <<EOF
[path]
read-data=$(cd "$(dirname "$factorio_bin")/../.." && pwd)/data
write-data=$write_dir

[general]
locale=en
EOF

save_path="$tmp_dir/${mod_name}-validation.zip"
log_path="$tmp_dir/factorio-validation.log"

echo "Factorio: $factorio_bin"
echo "Mods:     $mods_dir"
echo "Mod:      $expected_link -> $resolved"
echo "Config:   $config_dir/config.ini"
echo "Save:     $save_path"
echo

set +e
"$factorio_bin" \
  --config "$config_dir/config.ini" \
  --mod-directory "$mods_dir" \
  --create "$save_path" \
  --disable-audio \
  >"$log_path" 2>&1
status=$?
set -e

cat "$log_path"

if [[ $status -ne 0 ]]; then
  echo "Factorio validation failed with exit code $status" >&2
  exit "$status"
fi

if [[ ! -f "$save_path" ]]; then
  echo "Factorio validation did not produce expected save: $save_path" >&2
  exit 1
fi

echo "Factorio validation passed."
