# Advanced Power Infrastructure

Advanced Power Infrastructure is a Factorio 2.1 + Space Age mod that expands power generation and storage progression from early steam through late-game nuclear, fusion, solar, and accumulator upgrades.

## Requirements

- Factorio 2.1.
- Space Age.

## Features

- Additional boiler, steam engine, steam turbine, heat exchanger, heat pipe, and nuclear reactor tiers.
- Promethium-tier fusion reactor and fusion generator upgrades.
- Holmium and cryogenic solar panel and accumulator upgrades.
- Power-focused progression that uses Space Age materials and science packs.
- Optional integration with Advanced Fluid Infrastructure for power-machine pipeline extent descriptions.
- Optional companion scope split with Advanced Energy Grid for electric grid infrastructure.

## Scope

This mod owns power generation and storage: boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, fusion power, solar panels, accumulators, recipes, technologies, and related balance data.

Electric poles, substations, and long-distance transmission belong in Advanced Energy Grid. Pipes, pipe-to-ground entities, pumps, offshore pumps, and general fluid infrastructure belong in Advanced Fluid Infrastructure. Those companion mods are optional; Advanced Power Infrastructure remains loadable on its own with Space Age.

## Status

The current mod version is `0.2.1`. This is an early public release for Factorio 2.1. The mod loads successfully in standalone mode, and the core progression is implemented. Balance values, long-running save upgrade paths, and broad compatibility with other power mods should still be treated as experimental during the 0.2.x series.

The current power footprint balance benchmark is documented in [docs/power-footprint-benchmark.md](docs/power-footprint-benchmark.md).

## Installation

Install the released mod through the Factorio Mod Portal when available. Release packages are also attached to repository releases as `{mod-name}_{version}.zip`.

For local development, keep the repository layout intact and run validation from the repository root:

```sh
./scripts/validate.sh
```

Build a local release package with:

```sh
./scripts/package.sh
```

The package is written to `dist/` as `{mod-name}_{version}.zip`.

Release packaging and automated deployment are documented in [docs/release-process.md](docs/release-process.md). Versioning policy is documented in [docs/semantic-versioning.md](docs/semantic-versioning.md).

## Provenance

Advanced Power Infrastructure is a renamed and substantially updated continuation of `DanielWinks/Factorio-Advanced-Electric`, which was released under GPLv3. Local changes include the Factorio 2.1 and Space Age port, the `aer_` prototype namespace, the split into optional companion infrastructure mods, and expanded power-generation progression.

## License

Advanced Power Infrastructure is distributed under the GNU General Public License version 3. See [LICENSE](LICENSE).

## AI Disclosure

This mod is developed with substantial AI assistance. AI tools have contributed to code implementation, documentation, validation workflow setup, release automation, compatibility review, and generated artwork.

AI-assisted work in this repository is governed through the policy files under `.governance/`. Those policies are intended to keep AI contributions reviewable, scoped to the task at hand, and aligned with the repository's validation and release process.
