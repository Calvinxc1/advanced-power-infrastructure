# Advanced Power Infrastructure

Advanced Power Infrastructure is a Factorio 2.1 mod that expands power generation and storage progression from early steam through late-game nuclear upgrades. Space Age is optional and adds the holmium, foundation, solar, accumulator, and fusion tiers on top.

## Requirements

- Factorio 2.1.
- Optional Space Age integration, which adds the holmium, foundation, solar, accumulator, and fusion tiers.

## Features

- Additional boiler, steam engine, steam turbine, heat exchanger, heat pipe, and nuclear reactor tiers.
- Promethium-tier fusion reactor and fusion generator upgrades (Space Age).
- Holmium and cryogenic solar panel and accumulator upgrades (Space Age).

### Without Space Age

The ladders stop where Space Age materials begin. Boilers and steam engines keep their steel and rubber-lined tiers; steam turbines and heat exchangers keep their rubber-lined and reinforced tiers; heat pipes and nuclear reactors keep their mk2 tier. Solar, accumulators, and fusion are Space Age only, since every tier of those is built from holmium, lithium, quantum processors, or Space Age's own fusion buildings.

The surviving reinforced tiers substitute refined concrete and low-density structure for tungsten plate and carbon fiber, and are gated on production and utility science instead of metallurgic and agricultural science. This matches the substitution Advanced Fluid Infrastructure already makes for its own reinforced tier, so the two mods' ladders stay aligned in a base-game load.
- Power-focused progression that uses Space Age materials and science packs.
- Optional integration with Advanced Fluid Infrastructure for power-machine pipeline extent descriptions.
- Optional companion scope split with Advanced Energy Grid for electric grid infrastructure.

## Scope

This mod owns power generation and storage: boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, fusion power, solar panels, accumulators, recipes, technologies, and related balance data.

Electric poles, substations, and long-distance transmission belong in Advanced Energy Grid. Pipes, pipe-to-ground entities, pumps, offshore pumps, and general fluid infrastructure belong in Advanced Fluid Infrastructure. Those companion mods are optional; Advanced Power Infrastructure remains loadable on its own with Space Age.

Advanced Power Infrastructure, Advanced Energy Grid, and Advanced Fluid Infrastructure are designed to be played together as a set. Each mod loads and works fine on its own, but the staged progression is designed with all three installed together.

Nuclear heat does not behave the way vanilla nuclear heat does here: distance costs temperature, each pipe tier caps the heat it will carry, and heat exchangers taper their output instead of cutting out. None of that is visible in a tooltip, and a layout that would be fine in vanilla can quietly produce well under what it should. [docs/nuclear-heat-guide.md](docs/nuclear-heat-guide.md) is the player reference for building around it.

## Status

The current mod version is `0.3.0`. This is an early public release for Factorio 2.1. The mod loads successfully in standalone mode, and the core progression is implemented. Balance values, long-running save upgrade paths, and broad compatibility with other power mods should still be treated as experimental during the 0.x series.

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
