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
| mk2 | 7.2 | 22.5 tiles |
| mk3 | 10.0 | 20 tiles |
| mk4 | 14.3 | 17.5 tiles |

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

The tiers are tinted, so you can spot the odd one out without checking each
pipe individually:

| Pipe tier | Appearance |
| --- | --- |
| Steel (mk1) | vanilla, untinted |
| mk2 | darker grey |
| mk3 | pale green |
| mk4 | pale blue-white |

The heat glow is deliberately left untinted on every tier, so it still reads as
temperature rather than as tier.

## Upgrading has a cost

Replacing a heat pipe replaces the entity, and the replacement starts cold. An
upgrade drops that section of network to ambient temperature and it has to heat
back up.

On a large array this is not quick. A cold start to optimal takes several
minutes, and longer if exchangers are drawing while it warms, because they are
consuming the heat that would otherwise be warming the network.

Upgrade during a lull, or upgrade a section at a time.

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
- 84 steel steam turbines

Measured results: reactors settle at 624.8°C, the 8-exchanger spokes end at
525°C, the 4-exchanger spokes end at 544°C. Every exchanger is at or above its
500°C optimal, and the block runs at full output.

Note the shape of the answer. It is not one big run. It is many small ones,
because load is what costs you temperature.

## Things that will catch you out

**Steam of different temperatures mixes.** Two steam sources at different
temperatures feeding one pipe network average out, weighted by volume. Putting
1000°C steam and 500°C steam in the same pipes gives you 750°C steam
everywhere — which is below optimal for the hot tier and wasted on the cold
one, since a turbine consumes steam at the same rate regardless and discards
anything above its own optimal.

**Keep one steam tier per pipe network.** There is no warning for this either.
The fluid is still steam and the pipes still connect.

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
| Pipe loss per tile, light load | 5.0 | 7.2 | 10.0 | 14.3 |
| Pipe reach at light load | 25t | 22.5t | 20t | 17.5t |
| Pipe throughput | 1 GW | 1.4 GW | 1.7 GW | 1.9 GW |
| Turbine optimal | 500 | 650 | 800 | 1000 |
| Turbines per 2x2 block | 82 | 105 | 127 | 150 |
| Turbine rated output | 5.82 MW | 9.14 MW | 11.30 MW | 12.77 MW |
