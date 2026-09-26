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
# Each is loaded a second time with Advanced Fluid Infrastructure, which hands
# its steel tier to Krastorio 2's steel pipes and pumps: every pipe and pump
# ingredient and prerequisite this mod names has to follow it. AFI comes from
# the checkout at API_FLUID_INFRASTRUCTURE_DIR (its repository root) when that
# is set, so its unreleased integration is exercised, and from the Mod Portal
# otherwise.
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

fluid_name="advanced-fluid-infrastructure"
fluid_dir="${API_FLUID_INFRASTRUCTURE_DIR:-}"
if [[ -n "$fluid_dir" && ! -f "$fluid_dir/src/info.json" ]]; then
  echo "API_FLUID_INFRASTRUCTURE_DIR has no src/info.json: $fluid_dir" >&2
  exit 1
fi

# label | Space Age (on/off) | overhaul mods, space separated | with AFI (yes/no)
loads=(
  "Krastorio 2 Spaced Out|on|Krastorio2-spaced-out|no"
  "Krastorio 2|off|Krastorio2|no"
  "Space Exploration|off|space-exploration|no"
  "Space Exploration with Krastorio 2|off|space-exploration Krastorio2|no"
  "Krastorio 2 Spaced Out with AFI|on|Krastorio2-spaced-out|yes"
  "Krastorio 2 with AFI|off|Krastorio2|yes"
  "Space Exploration with AFI|off|space-exploration|yes"
  "Space Exploration with Krastorio 2 and AFI|off|space-exploration Krastorio2|yes"
)

for load in "${loads[@]}"; do
  IFS="|" read -r label space_age overhauls with_fluid <<<"$load"
  echo
  echo "=== $label (Space Age $space_age)"

  mods_dir="$work_dir/mods-${label// /-}"
  mkdir -p "$mods_dir"
  mod_args=()
  for overhaul in $overhauls; do
    mod_args+=(--mod "$overhaul")
  done
  expected="$overhauls"
  if [[ "$with_fluid" == "yes" ]]; then
    expected="$expected $fluid_name"
    if [[ -z "$fluid_dir" ]]; then
      mod_args+=(--mod "$fluid_name")
    fi
  fi
  "$repo_root/scripts/download-factorio-mods.py" \
    --mods-dir "$mods_dir" \
    --cache-dir "$cache_dir" \
    "${mod_args[@]}"

  ln -s "$repo_root/src" "$mods_dir/$mod_name"
  if [[ "$with_fluid" == "yes" && -n "$fluid_dir" ]]; then
    ln -s "$fluid_dir/src" "$mods_dir/$fluid_name"
  fi
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
  for loaded in $expected "$fixture_name" "$mod_name"; do
    if ! grep -q "Checksum of $loaded:" "$log_path"; then
      echo "$label: $loaded did not load." >&2
      exit 1
    fi
  done
  echo "=== $label: passed"
done
