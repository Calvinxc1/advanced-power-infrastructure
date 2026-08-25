# Advanced Power Infrastructure

Advanced Power Infrastructure expands Factorio 2.1 power progression with additional tiers for boilers, steam engines, steam turbines, heat exchangers, heat pipes, nuclear reactors, fusion power, solar panels, and accumulators.

Space Age is optional. The mod loads and plays on base Factorio 2.1, and Space Age adds the holmium, foundation, solar, accumulator, and fusion tiers on top.

## Nuclear heat is the centrepiece

Nuclear power here does not behave the way vanilla nuclear does, and the differences are the point of the mod rather than a side effect of adding tiers.

**Distance costs temperature.** Heat cools as it travels along a heat pipe, and cools faster the harder the run is working. A reactor cannot feed an arbitrarily long arm at full strength, so where you put exchangers matters as much as how many you build.

**Heat pipe tier is a requirement, not an option.** Each tier carries heat only up to its matching reactor's ceiling, so a single leftover lower-tier heat pipe throttles an entire run. Tiers are tinted and every heat pipe states its carrying temperature, throughput, and loss per tile in its tooltip.

**Heat exchangers taper rather than cutting out.** Every tier works from 300 degrees up to its own optimal, producing cooler steam instead of none, so a row that dips below optimal loses part of its output rather than all of it.

**The reactor neighbour bonus is paid per heat connection.** A reactor has three connections a side. Two placed flush line up all three and are worth the full bonus; sliding one along the shared edge earns a partial bonus rather than nothing, so a reactor row can be threaded around terrain.

**A pipe carries only so much heat at once**, and the margin tightens with tier — a limit on how wide a run can be, where temperature loss limits how long.

Opening a reactor shows a panel with its base output, adjacent reactors, aligned connections, bonus, live output, and core temperature. Little of this is visible in a tooltip otherwise, so there is a guide covering how the heat chain behaves and how to lay it out:

https://github.com/Calvinxc1/advanced-power-infrastructure/blob/main/docs/nuclear-heat-guide.md

## Without Space Age

The ladders stop where Space Age materials begin: boilers and steam engines at rubber-lined, steam turbines and heat exchangers at reinforced, heat pipes and nuclear reactors at mk2. Solar panels, accumulators, and fusion are Space Age only, since every tier of those is built from holmium, lithium, quantum processors, or Space Age's own fusion buildings.

The surviving reinforced tiers substitute refined concrete and low-density structure for tungsten plate and carbon fiber, and are gated on production and utility science instead of metallurgic and agricultural science.

## Scope and companions

Advanced Power Infrastructure covers generation and storage only. Electric grid infrastructure is handled by the optional Advanced Energy Grid companion, and pipes, pumps, and general fluid infrastructure by the optional Advanced Fluid Infrastructure companion. Each mod works on its own; the staged progression is designed with all three installed.

## Changes to base game entities

The mod adjusts several base game prototypes deliberately, so that vanilla machines are tier 1 of a ladder rather than stranded beside it:

- The vanilla heat exchanger and heat pipe take this mod's tier 1 values, including the heat pipe's carrying ceiling and per-tile loss. Anything else built on base game heat pipes, Space Age heating towers included, is affected by the same change.
- The vanilla steam turbine produces 5.56 MW rather than 5.82 MW, so one heat exchanger feeds exactly 1.8 turbines at every tier.
- Every reactor tier, vanilla included, has the engine's own neighbour bonus switched off, because the mod pays a per-connection bonus in its place.

## Common questions

**Do I need Space Age?**

No. The mod loads and plays on base Factorio 2.1. Space Age adds the holmium, foundation, solar, accumulator, and fusion tiers on top; without it the ladders stop earlier, as described above.

**Can I add this to a save already in progress?**

Yes, and no migration is needed. Be aware that it changes how nuclear heat behaves, so an existing reactor block will not perform the way it did before — see the next question.

**My nuclear power dropped after installing or updating. What happened?**

Heat now loses temperature as it travels along a heat pipe, and loses more the harder the run is working. The far end of a long exchanger run arrives cooler than it used to, so those exchangers make cooler steam and their turbines produce less. Nothing errors and nothing stops.

The fix is almost always to split exchangers across several shorter runs rather than one long one. Load costs more temperature than length does, so many short spokes beat a few long ones for the same tile count.

**My heat network will not go above a certain temperature.**

Look for a heat pipe you forgot to upgrade. Each tier carries heat only up to its own ceiling — 625, 812.5, 1000, and 1250 degrees — and a heat pipe is a node in the network like any other, so the lowest tier anywhere in a run caps the entire run. One leftover tier 1 pipe holds an mk3 network at 625, well under that tier's 800 optimal.

There is no error for this. The tiers are tinted so the odd one out can be spotted, and every heat pipe states its ceiling in its tooltip.

**Why is my steam cooler than the exchanger's optimal temperature?**

Heat exchangers work from 300 degrees up to their optimal rather than switching on at a single point. Below optimal they still run, producing steam at whatever temperature the heat network is actually at, and turbines scale with it. That is deliberate: a network that dips loses part of its output instead of all of it.

**Do I have to rebuild my reactor blocks?**

No. Reactors placed flush against each other are worth exactly what they were before. The bonus is now paid per aligned heat connection rather than per neighbour, which only changes things if reactors are offset — and an offset block now earns a partial bonus where vanilla gave it nothing.

**Why is my steam turbine producing less than 5.82 MW?**

The vanilla steam turbine is 5.56 MW here, so that one heat exchanger feeds exactly 1.8 turbines at every tier. The ratio learned at the first tier then stays true all the way up.

**Why do I suddenly need pumps?**

Only with Advanced Fluid Infrastructure installed. Every building in this mod is then held to a 24 tile pipeline extent regardless of tier, so upgrading a building buys output rather than reach and pumps stay part of the layout. Without that mod, pipeline extent is untouched.

**Is the top tier supposed to be less efficient?**

Yes. Measured on a 2x2 block at each tier, a well-built steel block runs at 100% of rated turbine output and an mk4 block at about 88%. Higher tiers produce far more power, but reach less far and demand more care in placement. A bigger reactor is meant to be a harder problem, not just a bigger number.

**Does it conflict with other power mods?**

It changes a few base game prototypes deliberately, listed above. The one that reaches outside this mod is the vanilla heat pipe, which now carries heat to a lower ceiling and loses more per tile, so anything else built on base game heat pipes is affected — Space Age heating towers included. Higher pipe tiers restore and exceed the vanilla ceiling.

## Status

This is an early 0.x public release. The mod loads and the core progression is implemented, but balance values, long-running save upgrade paths, and broad compatibility with other power mods should still be treated as experimental.
