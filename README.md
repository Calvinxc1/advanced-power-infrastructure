# Advanced Power Infrastructure

## Purpose

This project expands Factorio 2.0 and Space Age power infrastructure with additional progression for electric poles, boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, fusion power, solar panels, and accumulators.

## What Works

Implemented so far:

- Basic functionality for upgraded power infrastructure is in place, including additional tiers for boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, and electric poles.
- Steam engine and steam turbine progression uses one item per tier; generator priority control is delegated to Power Overload infrastructure.
- Core mod structure has been refactored into system-oriented prototype folders (`electric`, `power`, `fluid`) with shallow lifecycle entrypoints in `data.lua`, `data-updates.lua`, and `data-final-fixes.lua`.
- The current power footprint balance benchmark is documented in [docs/power-footprint-benchmark.md](docs/power-footprint-benchmark.md).
- The current fluid infrastructure benchmark is documented in [docs/fluid-infrastructure-benchmark.md](docs/fluid-infrastructure-benchmark.md).

Specific changes compared to the original repository (`DanielWinks/Factorio-Advanced-Electric`):

- Ported mod metadata to Factorio 2.0 (`factorio_version` updated from `0.16` to `2.0`).
- Updated technologies toward 2.0/Space Age progression by using newer science pack dependencies (for example `electromagnetic-science-pack`, `cryogenic-science-pack`, and other modern pack chains) instead of the original 0.16-era pack requirements.
- Updated recipe definitions to newer typed ingredient/result entries (`{ type = "item", name = "...", amount = N }`) instead of older positional tuple/result patterns.
- Added Power Overload integration for huge pole progression and made Power Overload a required dependency.

## Remaining Work

Work still needed for a full re-implementation of the original mod behavior:

- Complete feature-parity verification against the original content for every entity/item/recipe/technology tier and ensure no legacy behavior was dropped during the 2.0 port.
- Rebalance all costs, stats, and unlock timing for Factorio 2.0 + Space Age progression (current values are functional but still experimental).
- Validate all upgrade paths and replace groups in long-running saves, including migration behavior between versions.
- Expand compatibility testing with common power-related mod combinations beyond the basic Power Overload guard logic.
- Revisit Power Overload runtime tracking for Advanced Power Infrastructure huge pole upgrades; the new `aer_huge-electric-pole-*` tiers are not currently registered in Power Overload's hardcoded overload-capacity table.
- Perform full in-game QA across early, mid, and late game to confirm expected power network behavior, technology flow, and recipe availability.

## Current Release

The current public release is pending under the Advanced Power Infrastructure name.
