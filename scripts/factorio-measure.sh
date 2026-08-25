#!/usr/bin/env bash
# Runs the headless measurement harness and prints its AERM records.
#
# The heat-chain fields this mod tiers -- specific_heat, max_transfer,
# min_temperature_gradient -- are undocumented by Wube, so their behaviour has
# to be measured rather than read. See issues #11 and #14.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

ticks="${AER_MEASURE_TICKS:-700}"
factorio_bin="${FACTORIO_BIN:-}"

if [[ -z "$factorio_bin" ]]; then
  if command -v factorio >/dev/null 2>&1; then
    factorio_bin="$(command -v factorio)"
  elif [[ -x "$HOME/Games/steam/steamapps/common/Factorio/bin/x64/factorio" ]]; then
    factorio_bin="$HOME/Games/steam/steamapps/common/Factorio/bin/x64/factorio"
  else
    echo "Factorio executable not found. Set FACTORIO_BIN." >&2
    exit 127
  fi
fi

mod_name="$(python3 -c 'import json; print(json.load(open("src/info.json", encoding="utf-8"))["name"])')"
mods_dir="$(mktemp -d)"
save_dir="$(mktemp -d)"
trap 'rm -rf "$mods_dir" "$save_dir"' EXIT

ln -s "$repo_root/src" "$mods_dir/$mod_name"
cp -r "$repo_root/tests/harness/aer-measure" "$mods_dir/aer-measure"

"$factorio_bin" --mod-directory "$mods_dir" --create "$save_dir/measure.zip" >/dev/null 2>&1
"$factorio_bin" --mod-directory "$mods_dir" --benchmark "$save_dir/measure.zip" \
  --benchmark-ticks "$ticks" 2>&1 | sed -n 's/.*\(AERM[ _].*\)$/\1/p'
