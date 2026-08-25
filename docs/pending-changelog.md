# Pending changelog

Release notes earned by work already merged to `dev`, held here until a release
branch is cut.

`src/changelog.txt` is validated against the Factorio changelog format on every
pull request, and that format has no way to express an unreleased entry: every
section must open with a literal `Version: X.Y.Z`. Committing a placeholder
version there would either fail the gate or commit the project to a version
number before anyone has decided what the release contains. So the entry is
drafted here instead, in the exact body format `src/changelog.txt` uses, and
moved across when the version is known.

## When cutting a release branch

1. Decide the version and set it in `src/info.json`.
2. Paste the block below into the top of `src/changelog.txt` under a new
   `Version:` / `Date:` header, keeping the 99-dash separator convention.
3. Empty the block below back to "Nothing pending."
4. Run `./scripts/validate-changelog.py src/changelog.txt` before opening the
   release pull request.

Categories must come from the recognised set the validator enforces. Keep the
bullets player-facing: what changed in play, what breaks, what a player has to
do differently. Internal implementation detail belongs in commit messages.

## Pending entry

Content below is at least a minor bump under
[semantic-versioning.md](semantic-versioning.md) — it changes gameplay
behaviour and base-game prototypes, but adds no breaking migration.

```text
  Major Features:
    - Reworked the nuclear heat chain. Heat exchangers now run across a temperature band instead of switching on and off at a single point: every tier works from 300 degrees up to its own optimal, and between those two the steam leaves at whatever temperature the heat network is actually at. Turbines taper with it, so a row that dips below optimal loses part of its output rather than all of it.
    - Made distance cost temperature. Heat now cools as it travels along a pipe, and cools faster the harder the run is working, so a reactor block can no longer feed an arbitrarily long arm at full strength. Useful reach also shrinks as tiers rise: roughly 25 tiles at the steel tier down to 9 at mk4, before load is taken into account.
    - Made heat pipe tier a requirement rather than an option. Each pipe tier now carries heat only up to the ceiling of the reactor tier it belongs to, so a single leftover lower-tier pipe throttles an entire run to its own maximum. There is no error when this happens, so the pipe tiers now carry distinct tints and their limits are stated in their tooltips.
  Gui:
    - Added a heat output panel to the reactor window, showing base output, adjacent reactor count, neighbour bonus, current output, and core temperature. A reactor's real output depends on what is built beside it, and nothing in game reported it.
  Ease of use:
    - Added the optimal heat temperature to every heat exchanger tooltip. The game reports the temperature an exchanger stops working at, but never the one it needs to reach full output.
    - Added carrying temperature, throughput, and heat loss per tile to every heat pipe tooltip.
    - Added a note to reactor tooltips stating what each adjacent reactor contributes.
  Balancing:
    - Raised the number of heat exchangers and turbines a reactor block needs at every tier above steel, while shrinking the distance heat will travel. Higher tiers are now harder to lay out rather than simply larger: a 2x2 block needs about 48 exchangers at the steel tier and about 72 at mk4.
    - Held one heat exchanger to 1.8 steam turbines at every tier, so the ratio learned at the steel tier stays true all the way up.
    - Held heat exchangers and steam turbines to a 64 tile pipeline extent at every tier, so upgrading them never removes the need for pumps.
    - Lowered reactor and heat pipe temperature ceilings to sit just above the exchanger tier they feed, rather than at roughly double it.
    - Reduced the base game steam turbine from 5.82 MW to 5.56 MW so that one heat exchanger feeds exactly 1.8 turbines at every tier.
    - Gave the base game heat exchanger and heat pipe this mod's tier 1 values, which they already carried for tint, pipeline extent, and upgrade path.
  Bugfixes:
    - Fixed heat pipe tier tints never being applied to placed pipes. All four tiers rendered identically on the ground, which matters now that a lower-tier pipe silently caps a run.
  Compatibility:
    - The base game heat pipe now carries heat to a lower maximum and loses more temperature per tile than in vanilla, as tier 1 of this mod's ladder. Anything else built on base game heat pipes, including Space Age heating towers, is affected by the same change. Higher pipe tiers restore and exceed the vanilla ceiling.
```
