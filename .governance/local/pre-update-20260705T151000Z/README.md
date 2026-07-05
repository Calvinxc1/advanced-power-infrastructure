# .governance

This directory contains the active local governance copy for this workspace.

It was updated from Jason's `ai-governance` repository, `coding-agent` branch, source commit `e7312d8d33db228f89ce62af66f32b8e9b8ec7f5`.

Layout:

- `branch-descriptor.yaml`: branch, kind, and canon-version descriptor.
- `kind-routes.yaml`: coding-agent-specific route map.
- `task-map.yaml`: task or session routing to additional policy files.
- `policies/`: standing policy files.
- `processes/`: meta-governance and operating process files.
- `overrides/`: temporary exception log and schema.
- `templates/`: reusable setup and update templates.
- `local/`: local-only stamps, attestations, and preserved pre-update governance files.

Previous local governance files were preserved under `.governance/local/pre-update-20260704T232133Z`.
