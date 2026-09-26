#!/usr/bin/env bash
# Loads the mod alongside each overhaul it adapts to, with the heat-chain
# invariant assertions (tests/fixtures/api-energy-scale-test), so the Krastorio
# 2 and Space Exploration integration is exercised rather than only declared.
#
#   Krastorio 2 Spaced Out   Space Age on   (Spaced Out requires it and K2)
#   Krastorio 2              Space Age off
#   Space Exploration        Space Age off  (SE declares ! space-age)
#   SE with Krastorio 2      Space Age off
#
# The declared-dependency validation cannot reach these: it skips optional
# dependencies that bring hard requirements of their own. Here each load names
# its overhaul and downloads that mod's hard requirements with it.
#
# Every load starts from an empty mods directory. Archives are kept in
# API_OVERHAUL_CACHE_DIR (a temporary directory by default) and linked into
# each one, so a mod several loads share is downloaded once.
#
# Needs FACTORIO_MOD_PORTAL_USERNAME and FACTORIO_MOD_PORTAL_TOKEN, and a
# Factorio executable as for scripts/factorio-validate.sh.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mod_name="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1],encoding="utf-8"))["name"])' "$repo_root/src/info.json")"
fixture_name="api-energy-scale-test"
fixture_dir="$repo_root/tests/fixtures/$fixture_name"

if [[ -z "${FACTORIO_MOD_PORTAL_USERNAME:-}" || -z "${FACTORIO_MOD_PORTAL_TOKEN:-}" ]]; then
  echo "FACTORIO_MOD_PORTAL_USERNAME and FACTORIO_MOD_PORTAL_TOKEN must both be set to validate the overhauls." >&2
  exit 1
fi

temp_base="${RUNNER_TEMP:-${TMPDIR:-/tmp}}"
work_dir="$(mktemp -d "$temp_base/api-overhauls.XXXXXX")"
trap 'rm -rf -- "$work_dir"' EXIT
cache_dir="${API_OVERHAUL_CACHE_DIR:-$work_dir/cache}"

# label | Space Age (on/off) | overhaul mods, space separated
loads=(
  "Krastorio 2 Spaced Out|on|Krastorio2-spaced-out"
  "Krastorio 2|off|Krastorio2"
  "Space Exploration|off|space-exploration"
  "Space Exploration with Krastorio 2|off|space-exploration Krastorio2"
)

for load in "${loads[@]}"; do
  IFS="|" read -r label space_age overhauls <<<"$load"
  echo
  echo "=== $label (Space Age $space_age)"

  mods_dir="$work_dir/mods-${label// /-}"
  mkdir -p "$mods_dir"
  mod_args=()
  for overhaul in $overhauls; do
    mod_args+=(--mod "$overhaul")
  done
  "$repo_root/scripts/download-factorio-mods.py" \
    --mods-dir "$mods_dir" \
    --cache-dir "$cache_dir" \
    "${mod_args[@]}"

  ln -s "$repo_root/src" "$mods_dir/$mod_name"
  ln -s "$fixture_dir" "$mods_dir/$fixture_name"

  log_path="$work_dir/${label// /-}.log"
  if [[ "$space_age" == "on" ]]; then
    FACTORIO_MODS_DIR="$mods_dir" API_REQUIRE_FACTORIO=1 \
      "$repo_root/scripts/factorio-validate.sh" | tee "$log_path"
  else
    API_BASE_GAME_EXTRA_MODS_DIR="$mods_dir" API_REQUIRE_FACTORIO=1 \
      "$repo_root/scripts/factorio-validate-base-game.sh" | tee "$log_path"
  fi

  # A load that passes without the overhaul, the assertions, or this mod in
  # it proves nothing, so each must show up in the log.
  for loaded in $overhauls "$fixture_name" "$mod_name"; do
    if ! grep -q "Checksum of $loaded:" "$log_path"; then
      echo "$label: $loaded did not load." >&2
      exit 1
    fi
  done
  echo "=== $label: passed"
done
