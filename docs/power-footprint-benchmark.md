# Power Footprint Benchmark

This benchmark compares raw placed-entity footprint at a gross target near 2 GW.

Assumptions:

- Raw tiles include only core placed power entities.
- Steam counts include boilers and steam engines.
- Nuclear counts include reactors, heat exchangers, and steam turbines.
- Fusion counts include fusion reactors and fusion generators.
- Raw tiles exclude pipes, heat pipes, pumps, belts, inserters, substations, spacing, fuel handling, and walkways.
- Steam boiler output includes the boiler effectivity values currently set by this mod.
- Stock-cycle solar uses vanilla Nauvis solar math: `60kW` peak panels, `42kW` effective average per panel, and the standard `25` panels to `21` accumulators continuous-output ratio.
- 50/50 solar assumes panels run at full output for half the cycle and zero output for half the cycle, with enough accumulator capacity to carry the full target output through the dark half.
- Solar tiers assume matching solar-panel output and accumulator-capacity multipliers.
- Fusion T2 assumes both Promethium Fusion Reactor and Promethium Fusion Generator researches are complete.

| Power Line | Tier | Fluid Support | Pipeline Extent | Setup Used | Output | Support Counts | Raw Tiles |
|---|---:|---|---:|---|---:|---|---:|
| Solar | T1 | none | n/a | stock day/night cycle | `~2000MW` continuous | `47620` panels, `40001` accumulators | `588584` |
| Solar | T1 | none | n/a | 50/50 day/night split | `~2000MW` continuous | `66667` panels, `83334` accumulators | `933339` |
| Solar | T2 | none | n/a | stock day/night cycle, `4x` output/storage | `~2000MW` continuous | `11905` panels, `10001` accumulators | `147149` |
| Solar | T2 | none | n/a | 50/50 day/night split, `4x` output/storage | `~2000MW` continuous | `16667` panels, `20834` accumulators | `233339` |
| Solar | T3 | none | n/a | stock day/night cycle, `8x` output/storage | `~2000MW` continuous | `5953` panels, `5001` accumulators | `73581` |
| Solar | T3 | none | n/a | 50/50 day/night split, `8x` output/storage | `~2000MW` continuous | `8334` panels, `10417` accumulators | `116674` |
| Steam | T1 | Iron | `24` | iron boilers + iron steam engines | `~2000MW` | `1112` boilers, `2223` engines | `40017` |
| Steam | T2 | Steel | `64` | steel boilers + steel steam engines | `~2000MW` | `607` boilers, `1270` engines | `22692` |
| Steam | T3 | Rubber-lined | `96` | rubber-lined boilers + rubber-lined steam engines | `~2000MW` | `348` boilers, `758` engines | `13458` |
| Steam | T4 | Reinforced | `192` | holmium-lined boilers + holmium steam engines | `~2000MW` | `214` boilers, `498` engines | `8754` |
| Nuclear | T1 | Steel | `64` | `4x` 2x2 reactor blocks, `16` reactors | `1920MW` | `192` exchangers, `330` turbines | `6502` |
| Nuclear | T2 | Rubber-lined | `96` | `9` reactors in line | `2000MW` | `112` exchangers, `219` turbines | `4182` |
| Nuclear | T3 | Reinforced | `192` | `6` reactors in line | `1920MW` | `77` exchangers, `146` turbines | `2802` |
| Nuclear | T4 | Foundation | `512` | `1x` 2x2 reactor block, `4` reactors | `1920MW` | `60` exchangers, `102` turbines | `1990` |
| Fusion | T1 | Steel | `64` | `20` reactors, `40` generators | `2000MW` | no exchanger/turbine layer | `1320` |
| Fusion | T2 | Foundation | `512` | `8` reactors, `16` generators | `2000MW` | no exchanger/turbine layer | `528` |

The fusion benchmark uses gross generator output. Net output is lower because fusion reactors consume electric power as an input.
