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

Nothing pending.
