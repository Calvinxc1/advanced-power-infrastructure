# Repo-Local Governance Copy

This directory is this repository's active local governance copy.

Agents working in this repository load and follow this directory the same way they would use `.governance/` in any other repository. `AGENTS.md` points here for the active local policy contract.

Committed governance files under `.governance/` are ratified by existence. Status fields may still describe operational role, such as `active`, but they are not a separate ratification gate. Draft local-governance proposals must stay outside this active local governance tree until Jason ratifies them.

Use `task-map.yaml` as the explicit loading contract. It may define reusable route groups, but agents should still load only the groups and direct files named by selected routes instead of scanning policy folders.

This directory intentionally duplicates governance rules that may also appear in the source `ai-governance` repository's `lab-governance/` tree. This mod workspace does not maintain a top-level `lab-governance/` directory. Drift is allowed when it is visible and intentional:

- `.governance/` governs this repository's work.
- `lab-governance/` is the generalized rule set maintained in the source governance repository for propagation to other agents and repositories.

Use `local/` for explicit repo-local deviations from the generalized rule set. The universal local policy pointer is `local/index.yaml`; the universal local governance status report is `local/status.yaml`. Everything else under `local/` is workspace-owned unless explicitly routed by that local pointer. Use `records/` for repo-local alignment notes or operational metadata. If a local rule should become general lab governance, raise it against the source governance repository rather than creating a local `lab-governance/` tree.

Kind branches may add `.governance/templates/` for branch-specific local setup shapes. On the Factorio modding branch, `templates/factorio-local-overlay.yaml` records workspace-local mod facts such as namespace, dependency stack, upstream source, release target, and validation availability.
