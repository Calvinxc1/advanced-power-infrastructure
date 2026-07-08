# Advanced Power Infrastructure

## Purpose

This project expands Factorio 2.0 and Space Age power generation and storage infrastructure with additional progression for boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, fusion power, solar panels, and accumulators.

## What Works

Implemented so far:

- Basic functionality for upgraded power infrastructure is in place, including additional tiers for boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, solar panels, and accumulators.
- Steam engine and steam turbine progression uses one item per tier.
- Core mod structure has been refactored into system-oriented prototype folders with shallow lifecycle entrypoints in `data.lua`, `data-updates.lua`, and `data-final-fixes.lua`.
- The current power footprint balance benchmark is documented in [docs/power-footprint-benchmark.md](docs/power-footprint-benchmark.md).
- Fluid pipe and pump infrastructure is owned by the required Advanced Fluid Infrastructure dependency; this mod only keeps the power-generation fluidbox tuning that belongs to boilers, steam engines, steam turbines, heat exchangers, reactors, and fusion power.
- Electric grid infrastructure is owned by the required Advanced Energy Grid dependency.

Specific changes compared to the original repository (`DanielWinks/Factorio-Advanced-Electric`):

- Ported mod metadata to Factorio 2.0 (`factorio_version` updated from `0.16` to `2.0`).
- Updated technologies toward 2.0/Space Age progression by using newer science pack dependencies (for example `electromagnetic-science-pack`, `cryogenic-science-pack`, and other modern pack chains) instead of the original 0.16-era pack requirements.
- Updated recipe definitions to newer typed ingredient/result entries (`{ type = "item", name = "...", amount = N }`) instead of older positional tuple/result patterns.
- Split electric grid infrastructure into Advanced Energy Grid.

## Remaining Work

Work still needed for a full re-implementation of the original mod behavior:

- Complete feature-parity verification against the original content for every entity/item/recipe/technology tier and ensure no legacy behavior was dropped during the 2.0 port.
- Rebalance all costs, stats, and unlock timing for Factorio 2.0 + Space Age progression (current values are functional but still experimental).
- Validate all upgrade paths and replace groups in long-running saves, including migration behavior between versions.
- Expand compatibility testing with common power-related mod combinations.
- Perform full in-game QA across early, mid, and late game to confirm expected power network behavior, technology flow, and recipe availability.

## Current Release

The current mod version is `0.1.0`. Public release is pending under the Advanced Power Infrastructure name.

## Continuous Integration

Pull requests run `.gitea/workflows/validate.yml`, which executes the same `./scripts/validate.sh` check used locally.

The Gitea runner must have:

- Factorio installed and available on `PATH` as `factorio`, at `$HOME/Games/steam/steamapps/common/Factorio/bin/x64/factorio`, or through `FACTORIO_BIN`.
- A Factorio mods directory at `$HOME/.factorio/mods` or through `FACTORIO_MODS_DIR`.
- Required mod dependencies, including Advanced Fluid Infrastructure and Advanced Energy Grid, available in that mods directory.
