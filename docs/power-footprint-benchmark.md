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

The Pipeline Extent column is now `24` on every row: pipeline extent is no
longer part of this mod's progression, and every building it owns carries the
same 24 tiles regardless of tier. The Fluid Support column still names the
material tier, which governs recipe cost and output rather than reach.

> **The Nuclear rows predate the heat-chain rework** and describe setups that no
> longer exist. Exchanger draw, turbine output, reactor ceilings and pipe losses
> all moved. They should be regenerated before being used as a baseline. The
> per-tier efficiency benchmark below is current.

| Power Line | Tier | Fluid Support | Pipeline Extent | Setup Used | Output | Support Counts | Raw Tiles |
|---|---:|---|---:|---|---:|---|---:|
| Solar | T1 | none | n/a | stock day/night cycle | `~2000MW` continuous | `47620` panels, `40001` accumulators | `588584` |
| Solar | T1 | none | n/a | 50/50 day/night split | `~2000MW` continuous | `66667` panels, `83334` accumulators | `933339` |
| Solar | T2 | none | n/a | stock day/night cycle, `4x` output/storage | `~2000MW` continuous | `11905` panels, `10001` accumulators | `147149` |
| Solar | T2 | none | n/a | 50/50 day/night split, `4x` output/storage | `~2000MW` continuous | `16667` panels, `20834` accumulators | `233339` |
| Solar | T3 | none | n/a | stock day/night cycle, `8x` output/storage | `~2000MW` continuous | `5953` panels, `5001` accumulators | `73581` |
| Solar | T3 | none | n/a | 50/50 day/night split, `8x` output/storage | `~2000MW` continuous | `8334` panels, `10417` accumulators | `116674` |
| Steam | T1 | Iron | `24` | iron boilers + iron steam engines | `~2000MW` | `1112` boilers, `2223` engines | `40017` |
| Steam | T2 | Steel | `24` | steel boilers + steel steam engines | `~2000MW` | `607` boilers, `1270` engines | `22692` |
| Steam | T3 | Rubber-lined | `24` | rubber-lined boilers + rubber-lined steam engines | `~2000MW` | `348` boilers, `758` engines | `13458` |
| Steam | T4 | Reinforced | `24` | holmium-lined boilers + holmium steam engines | `~2000MW` | `214` boilers, `498` engines | `8754` |
| Nuclear | T1 | Steel | `24` | `4x` 2x2 reactor blocks, `16` reactors | `1920MW` | `192` exchangers, `330` turbines | `6502` |
| Nuclear | T2 | Rubber-lined | `24` | `9` reactors in line | `2000MW` | `112` exchangers, `219` turbines | `4182` |
| Nuclear | T3 | Reinforced | `24` | `6` reactors in line | `1920MW` | `77` exchangers, `146` turbines | `2802` |
| Nuclear | T4 | Foundation | `24` | `1x` 2x2 reactor block, `4` reactors | `1920MW` | `60` exchangers, `102` turbines | `1990` |
| Fusion | T1 | Steel | `24` | `20` reactors, `40` generators | `2000MW` | no exchanger/turbine layer | `1320` |
| Fusion | T2 | Foundation | `24` | `8` reactors, `16` generators | `2000MW` | no exchanger/turbine layer | `528` |

The fusion benchmark uses gross generator output. Net output is lower because fusion reactors consume electric power as an input.


## Nuclear heat chain efficiency by tier

Measured in game, run to steady state at each tier, on the same block shape
throughout. This is a different question from the footprint table above: not how
much space a target output takes, but how much of a tier's rated output a
realistic layout actually delivers.

### Method

- A **2x2 reactor block** at every tier.
- Two kinds of exchanger run, both fed from the block:
  - **Double runs** — a heat pipe with exchangers on both sides, so a depth of 5
    means five ranks, two columns and ten exchangers on that run.
  - **Single runs** — one column of exchangers along the pipe, so a depth of 5
    means five exchangers.
- **Four double runs** (eight columns) and **four single runs** per block.
- Exchanger-to-turbine ratios deliberately **slightly undermatched**, so that
  turbine output reports the heat chain's efficiency rather than being capped by
  turbine count.
- Each tier run until temperatures stopped moving.
- Efficiency is measured as electricity actually available from the turbines
  against their rated output at optimal steam.

### Results

| Tier | Optimal | Double run depth | Far-end temp | Single run depth | Far-end temp | First exchanger below optimal | Turbine output | Efficiency |
| ---: | ---: | ---: | ---: | ---: | ---: | --- | --- | ---: |
| mk1 | 500 | 4 | 522.36 | 4 | 541.51 | none | at rated | **100%** |
| mk2 | 650 | 5 | 610.05 | 4 | 671.75 | 4th double, none single | 9.00 / 9.17 MW | **98.1%** |
| mk3 | 800 | 5 | 707.39 | 6 | 667.59 | 3rd double, 4th single | 11.40 / 11.94 MW | **95.5%** |
| mk4 | 1000 | 6 | 694.24 | 6 | 719.75 | 3rd double, 3rd single | 12.90 / 14.73 MW | **87.6%** |

Far-end temperature is the settled figure at the end of the run; exchangers
closer to the reactor sit hotter, which is why mk4 delivers 87.6% rather than
the ~69% the far-end figure alone would imply.

### The layout tested is the designed one

Worth stating, because it is what makes the efficiencies above meaningful: these
readings come from a block carrying the exchanger count the tier is designed
around, not an arbitrary one.

| Tier | Double runs | Single runs | Exchangers built | Design figure | Difference |
| ---: | --- | --- | ---: | ---: | ---: |
| mk1 | 4 runs x 4 deep x 2 = 32 | 4 x 4 = 16 | **48** | 48 | none |
| mk2 | 4 runs x 5 deep x 2 = 40 | 4 x 4 = 16 | **56** | 58 | -2 |
| mk3 | 4 runs x 5 deep x 2 = 40 | 4 x 6 = 24 | **64** | 67 | -3 |
| mk4 | 4 runs x 6 deep x 2 = 48 | 4 x 6 = 24 | **72** | 72 | none |

mk1 and mk4 land exactly on the figure the tier is built for. mk2 and mk3 sit
two and three exchangers under it, which is the deliberate undermatch: it keeps
turbine output reporting the heat chain's efficiency rather than being capped by
the number of exchangers fed.

### What it shows

**Efficiency degrades with tier, deliberately.** 100 → 98.1 → 95.5 → 87.6%.
Upgrading a tier buys substantially more power and costs efficiency unless the
layout is reworked for it. That is the design: a higher tier is a harder
placement problem, not simply a bigger number.

**Reach shrinks with tier.** The first exchanger to fall below optimal moves
inward as tiers rise -- nothing at mk1, the fourth at mk2, the third by mk4 --
so the same spoke that ran at full output one tier down no longer does.

**Load costs more than length.** At every tier the double runs fall further than
the single runs at equal depth, because twice the exchangers draw twice the heat
through the same pipe. The mk3 row is the exception only because the single runs
were built two ranks deeper there.

**mk1 is the only tier that runs at 100%**, and it does so with headroom: both
run types finish above the 500 optimal.

### Corroboration

The mk1 figures independently confirm the worked example in
[nuclear-heat-guide.md](nuclear-heat-guide.md), measured in a separate session:
522.36 and 541.51 here against 525 and 544 there, with the gap between run types
at 19.15 degrees against a stated 19. The rated turbine outputs used as the
denominator -- 9.17, 11.94 and 14.73 MW -- match a `--dump-data` of the built
mod exactly.
