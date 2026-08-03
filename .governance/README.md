# Workspace Governance Layout

This directory contains this workspace's active governance rule set.

These files are the policy and process contract loaded by agents working in this repository.

This stable `/main` endpoint branch uses an enforcement-first governance model. High-stakes recurring failures should map to hard gates, cheap default paths, or detectors; prose-only fixes are tracked debt unless Jason accepts the residual risk. Bootstrap and update instructions live on literal branch `main` and require an explicit target policy line before selecting the mapped `/main` endpoint for the target agent kind.

All governance in this repository lives under `.governance/`, including canonical policy, processes, templates, and local metadata.

The `enforcement-redesign/trunk/main` branch carries the experimental general contract for every agent kind. Secondary kind branches carry complete branch-local pictures after `enforcement-redesign/trunk/main` is merged down into them. Core content is intentionally duplicated across kind branches so an agent can read one branch and have the complete contract.

Layout:

- `AGENTS.md`: thin entrypoint with precedence, always-load policy, and routing pointer.
- `.governance/governance-init.md`: setup guide for initializing governance in a new or unverified agent workspace.
- `.governance/task-map.yaml`: task or session routing to additional policy files.
- `.governance/policies/`: standing domain policies in YAML.
- `.governance/processes/`: meta-governance and operating processes.
- `.governance/skills/`: loadable skill sources.
- `.governance/overrides/`: temporary exception log and its schema.
- `.governance/templates/`: reusable setup templates.
- `.governance/local/`: workspace-owned status, workflow facts, and local overrides.

Kind branches add `.governance/branch-descriptor.yaml` and `.governance/kind-routes.yaml`. The policy-line trunk does not carry those files, so policy-line trunk merge-downs do not overwrite kind orientation or kind-specific routing.
