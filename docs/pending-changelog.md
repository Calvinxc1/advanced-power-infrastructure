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

```
  Compatibility:
    - Added support for Krastorio 2, Krastorio 2 Spaced Out, and Space Exploration.
    - Under Krastorio 2 the steam and nuclear tiers run at Krastorio 2's energy scale: its 250 MW reactor, 50 MW heat exchanger and 10 MW turbine are the first rung, and every tier above keeps its multiplier over them. Temperatures stay this mod's (500, 650, 800 and 1000 degree exchangers with a 300 degree working floor), and heat pipes and reactors scale with the exchangers, so every reach figure in the nuclear heat guide is unchanged.
    - Under Krastorio 2 with Space Age, the holmium and cryogenic solar panels and accumulators keep their 4x and 8x over Krastorio 2's stronger vanilla panel and accumulator (400 and 800 kW, 40 and 80 MJ).
    - Krastorio 2 no longer switches the engine's reactor neighbour bonus back on, which had paid reactors twice.
    - Space Exploration no longer resets the steel heat pipe's heat transfer, and its own high-temperature chain (antimatter reactor, big heat exchanger, naquium heat pipe) is left as Space Exploration's.
  Bugfixes:
    - The steel boiler technology now requires advanced material processing, which unlocks the steel furnace it is built from.
    - With Space Age, the reinforced steam turbine and mk3 heat exchanger technologies now require carbon fiber, which their recipes use.
    - Steam made by another mod's boiler on the same header as this mod's heat exchangers is no longer rewritten to the exchangers' temperature.
```
