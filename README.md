# Advanced Power Infrastructure

## Purpose

This project expands Factorio 2.0 and Space Age power generation and storage infrastructure with additional progression for boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, fusion power, solar panels, and accumulators.

## Features

- Additional tiers for boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, solar panels, and accumulators.
- Promethium-tier fusion reactor and fusion generator upgrades.
- One item per steam engine and steam turbine tier.
- System-oriented prototype folders with shallow lifecycle entrypoints in `data.lua`, `data-updates.lua`, and `data-final-fixes.lua`.
- The current power footprint balance benchmark is documented in [docs/power-footprint-benchmark.md](docs/power-footprint-benchmark.md).
- Fluid pipe and pump infrastructure is owned by the optional Advanced Fluid Infrastructure dependency. When it is present, this mod keeps power-generation fluidbox tuning in parity with that dependency; when it is absent, this mod uses standalone power recipes and technology gates without adding AFI-style pipe-length progression.
- Electric grid infrastructure is owned by the optional Advanced Energy Grid dependency.

Specific changes compared to the original repository (`DanielWinks/Factorio-Advanced-Electric`):

- Ported mod metadata to Factorio 2.0 (`factorio_version` updated from `0.16` to `2.0`).
- Updated technologies toward 2.0/Space Age progression by using newer science pack dependencies (for example `electromagnetic-science-pack`, `cryogenic-science-pack`, and other modern pack chains) instead of the original 0.16-era pack requirements.
- Updated recipe definitions to newer typed ingredient/result entries (`{ type = "item", name = "...", amount = N }`) instead of older positional tuple/result patterns.
- Split electric grid infrastructure into Advanced Energy Grid.

## Release Status

The current mod version is `0.1.0`. This is an early public release candidate under the Advanced Power Infrastructure name.

The mod loads successfully in standalone mode and with its optional Advanced Fluid Infrastructure and Advanced Energy Grid integrations. Balance values, long-running save upgrade paths, and broad compatibility with other power mods are still being validated during the 0.1.x series.

## License

Advanced Power Infrastructure is distributed under the GNU General Public License version 3. See [LICENSE](LICENSE).

This project is a renamed and substantially updated continuation of `DanielWinks/Factorio-Advanced-Electric`, which was also released under GPLv3. Local changes include the Factorio 2.0 and Space Age port, renamed prototype namespace, dependency split, optional Advanced Fluid Infrastructure and Advanced Energy Grid integrations, and expanded power-generation progression.

## Continuous Integration

Pull requests run `.gitea/workflows/validate.yml`, which executes the same `./scripts/validate.sh` check used locally.

The Gitea runner must have:

- Factorio installed and available on `PATH` as `factorio`, at `$HOME/Games/steam/steamapps/common/Factorio/bin/x64/factorio`, or through `FACTORIO_BIN`.
- A Factorio mods directory at `$HOME/.factorio/mods` or through `FACTORIO_MODS_DIR`.
- Optional mod dependencies, including Advanced Fluid Infrastructure and Advanced Energy Grid, available in that mods directory when validating optional integration behavior.
