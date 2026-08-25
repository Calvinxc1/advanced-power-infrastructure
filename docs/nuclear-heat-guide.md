# Nuclear heat, and how to lay it out

Nuclear power in this mod does not work the way vanilla nuclear works. The
differences are deliberate, but they are not obvious from the tooltips, and a
layout that would be fine in vanilla can quietly produce half the power it
should here.

This is the reference for what changed and how to build around it.

## The short version

1. **Distance costs temperature.** Heat gets colder the further it travels down
   a pipe. There is a limit to how far from a reactor you can usefully put a
   heat exchanger.
2. **Cooler heat still works, it just produces cooler steam.** Nothing shuts
   off until the heat drops below 300°C. Between 300 and optimal you get
   proportionally less power rather than none.
3. **Load makes distance worse.** The more exchangers on one pipe run, the
   faster the temperature falls along it. Several short spokes beat one long
   one.
4. **A single low-tier pipe throttles an entire run.** Pipe tiers now cap the
   temperature they can carry, matched to the reactor tier they belong to.

If you only read one thing: **keep exchangers close to the reactor, and split
them across several short runs rather than one long one.**

## Why your steam might be cold

A heat exchanger has three temperatures that matter.

| | Steel (mk1) | mk2 | mk3 | mk4 |
| --- | ---: | ---: | ---: | ---: |
| Stops working below | 300 | 300 | 300 | 300 |
| **Optimal** | **500** | **650** | **800** | **1000** |
| Reactor ceiling | 625 | 812.5 | 1000 | 1250 |

At or above optimal, the exchanger produces steam at its optimal temperature
and its matching turbine runs at 100%.

**Below optimal, the steam comes out at whatever temperature the heat network is
at.** A network sitting at 400°C feeds a steel exchanger 400°C steam, and a
steam turbine wanting 500°C runs at about 79%. Nothing warns you. The row keeps
running, quieter than it should.

Below 300°C the exchanger stops entirely.

This is why an over-long pipe run is expensive rather than merely
disappointing: the exchanger at the far end still draws its full heat, and
converts it into steam worth less than it cost.

## How far heat travels

Heat loses temperature every tile of pipe it crosses. How much depends on the
pipe tier and on how hard the run is working.

**At light load**, the loss per tile is fixed:

| Pipe tier | Loss per tile | Reach before steam drops below optimal |
| --- | ---: | ---: |
| Steel (mk1) | 5.0 | 25 tiles |
| mk2 | 10.2 | 16 tiles |
| mk3 | 16.7 | 12 tiles |
| mk4 | 27.8 | 9 tiles |

Yes, higher tiers reach *less* far. A bigger reactor is meant to be a harder
design problem, not just a bigger number. It still produces far more power.

**Under real load, the loss per tile is higher than the table**, because moving
heat down a pipe needs a temperature difference to drive it. The more heat
flowing, the steeper the fall.

A worked example, measured in game on a steel pipe run 13 tiles long:

| Exchangers on the run | Heat flowing | Loss per tile | Temperature at the end |
| ---: | ---: | ---: | ---: |
| 8 | 80 MW | 7.7 | 525°C |
| 4 | 40 MW | 6.2 | 544°C |

Same pipe, same length, same tier. Halving the exchangers on the run bought
19°C at the far end.

**This is the single most useful thing to know.** Splitting 48 exchangers across
twelve short spokes instead of four long ones is worth about 35°C at the far
end, for the same tile count and the same pipe.

## Pipe tiers are not optional

Each pipe tier can only carry heat up to its own maximum:

| Pipe tier | Carries up to |
| --- | ---: |
| Steel (mk1) | 625°C |
| mk2 | 812.5°C |
| mk3 | 1000°C |
| mk4 | 1250°C |

A heat pipe is part of the heat network, so **the lowest-tier pipe anywhere in a
run caps that whole run.** One leftover steel pipe in an mk3 network holds the
entire thing to 625°C, well under the mk3 exchanger's 800°C optimal, and every
exchanger downstream produces cold steam.

There is no error message for this. If a run is underperforming for no visible
reason, look for a pipe you forgot to upgrade.

Every heat pipe now states its own numbers in its tooltip -- what it carries,
what it moves, and what it costs you per tile -- so a suspect pipe can be
checked directly.

The tiers are also tinted, so you can spot the odd one out without checking each
pipe individually:

| Pipe tier | Colour |
| --- | --- |
| Steel (mk1) | vanilla, untinted |
| mk2 | dark |
| mk3 | green |
| mk4 | light blue |

The same colours are used on the crafting menu icons, so a pipe looks in the
world like it looked when you picked it.

The heat glow is deliberately left untinted on every tier, so it still reads as
temperature rather than as tier.

## Upgrading has a cost

Replacing a heat pipe replaces the entity, and the replacement starts cold. An
upgrade drops that section of network to ambient temperature and it has to heat
back up.

On a large array this is not quick. A full 2x2 block starting from cold, with
nothing drawing:

| Tier | To optimal | To full ceiling |
| --- | ---: | ---: |
| Steel (mk1) | ~4 minutes | ~5 minutes |
| mk2 | ~6 minutes | ~8 minutes |
| mk3 | ~8 minutes | ~10 minutes |
| mk4 | ~10 minutes | ~12 minutes |

And that is the optimistic case. Exchangers start drawing the moment the network
passes 300 degrees, and they consume the heat that would otherwise be raising
it. A block whose exchangers can draw everything its reactors produce warms
very slowly indeed once past 300, because almost nothing is left over.

What rescues it is steam backpressure: an exchanger whose output has nowhere to
go stops drawing. So a network warms fastest when turbine demand is satisfied,
and slowest when every exchanger is free to run flat out.

Upgrade during a lull, upgrade a section at a time, and expect a cold start to
take a while.

## A worked layout

A 2x2 reactor block. Each reactor has two neighbours, so each produces three
times its base output: **480 MW total** for the steel tier.

At 10 MW per steel exchanger, that supports **48 exchangers**. Reaching all 48
from one block takes some care.

Higher tiers need considerably more: a mk2 block supports 58, mk3 supports 67,
mk4 supports 72. Exchanger draw deliberately grows more slowly than reactor
output, so a bigger reactor is a bigger placement problem and not simply a
bigger number.

A layout that does it:

- Four spokes of **8 exchangers**, one from each reactor's outer face
- Eight spokes of **4 exchangers**, two from each reactor's remaining faces
- Runs 13 tiles long
- 86 steel steam turbines

Measured results: reactors settle at 624.8°C, the 8-exchanger spokes end at
525°C, the 4-exchanger spokes end at 544°C. Every exchanger is at or above its
500°C optimal, and the block runs at full output.

Note the shape of the answer. It is not one big run. It is many small ones,
because load is what costs you temperature.

## Reactor output is not what the tooltip says

A reactor's listed heat output is its **standalone** figure. Each adjacent
reactor adds another 100% of it, so a reactor in a 2x2 block -- two neighbours
-- produces three times its listed output.

That is why a 2x2 block of steel reactors makes 480 MW rather than 160 MW.

Opening a reactor shows a panel with its base output, how many neighbours it
has, and what it is actually producing right now.

## Things that will catch you out

**Steam of different temperatures mixes.** Two steam sources at different
temperatures feeding one pipe network average out, weighted by volume. Putting
1000°C steam and 500°C steam in the same pipes gives you 750°C steam
everywhere — which is below optimal for the hot tier and wasted on the cold
one, since a turbine consumes steam at the same rate regardless and discards
anything above its own optimal.

**Keep one steam tier per pipe network.** There is no warning for this either.
The fluid is still steam and the pipes still connect.

**That includes fuel boilers.** A coal or holmium boiler plumbed into the same
header as your heat exchangers is just another steam source at its own fixed
temperature, and it drags the whole header toward that temperature by however
much steam it is contributing. It costs you nothing in energy — the blend is
weighted by volume, so nothing is gained or lost — but a boiler feeding a
turbine tier built for 650°C steam is quietly holding that tier below its
optimal.

**Pipeline extent still applies, at every tier.** Heat exchangers and steam
turbines are held to a 64 tile pipeline extent regardless of tier, so upgrading
them never removes the need for pumps. Long steam runs need pumps, and a pump
has a throughput limit of its own -- a steel pump will not feed an unlimited
number of turbines. Expect pumps to be part of the layout, not a fix for one.

**Check your power poles.** An array of this size can exceed the throughput of
the pole tier carrying it.

## Reference

| | Steel (mk1) | mk2 | mk3 | mk4 |
| --- | ---: | ---: | ---: | ---: |
| Reactor heat output | 40 MW | 80 MW | 120 MW | 160 MW |
| Reactor in a 2x2 block | 120 MW | 240 MW | 360 MW | 480 MW |
| Reactor / pipe ceiling | 625 | 812.5 | 1000 | 1250 |
| Exchanger optimal | 500 | 650 | 800 | 1000 |
| Exchanger stops below | 300 | 300 | 300 | 300 |
| Exchanger draw | 10 MW | 16.5 MW | 21.5 MW | 26.5 MW |
| Pipe loss per tile, light load | 5.0 | 10.2 | 16.7 | 27.8 |
| Pipe reach at light load | 25t | 16t | 12t | 9t |
| Pipe throughput | 1 GW | 1.4 GW | 1.7 GW | 1.9 GW |
| Turbine optimal | 500 | 650 | 800 | 1000 |
| Turbines per 2x2 block | 86 | 105 | 121 | 130 |
| Turbine rated output | 5.56 MW | 9.17 MW | 11.94 MW | 14.73 MW |
| Turbines per exchanger | 1.8 | 1.8 | 1.8 | 1.8 |
