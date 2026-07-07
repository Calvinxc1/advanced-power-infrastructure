# Lab Governance Layout

This directory contains the lab-wide governance rule set maintained by this repository.

These files are the general policy and process contract intended to propagate to the rest of the lab and to specialized agent branches.

This directory is not the active local governance entrypoint for agents working in this repository. That role belongs to `.governance/`. The two trees intentionally duplicate governance rules and may drift when the distinction is visible and intentional.

The trunk branch carries the general contract for every agent kind. Kind branches carry complete branch-local pictures after trunk is merged down into them. Core content is intentionally duplicated across kind branches so an agent can read one branch and have the complete contract.

Layout:

- `AGENTS.md`: thin entrypoint with precedence, always-load policy, and routing pointer.
- `.governance/governance-init.md`: setup guide for initializing governance in a new or unverified agent workspace.
- `.governance/task-map.yaml`: task or session routing to the additional policy files that should be loaded. Route groups provide reusable subroutes; selected routes, not folder names, remain the explicit loading contract.
- `.governance/policies/`: standing domain policies in YAML.
- `.governance/processes/`: meta-governance and operating processes.
- `.governance/overrides/`: temporary exception log and its schema.
- `.governance/templates/`: reusable setup templates, including the local governance status template, loose local index template, legacy self-stamp template, and canonical governance bootstrap prompt.
- `.governance/templates/governance-bootstrap-prompt.md`: canonical prompt for first-time governance initialization and governed-agent updates.
- `.governance/templates/kind-branch-migration-checklist.md`: version-agnostic checklist for adopting a target kind branch without hard-coding a particular canon version.
- `.governance/templates/local-index.yaml`: loose pointer template for `.governance/local/index.yaml`; the local directory's internal structure remains workspace-owned.
- `.governance/templates/local-status.yaml`: local status template for `.governance/local/status.yaml`; this is metadata, not a local policy body.
- Kind branches may add branch-specific templates; the Factorio modding branch includes `.governance/templates/factorio-local-overlay.yaml` for workspace-local mod facts.

Kind branches add `.governance/branch-descriptor.yaml` and `.governance/kind-routes.yaml`. Trunk does not carry those files, so trunk merge-downs do not overwrite kind orientation or kind-specific routing.
