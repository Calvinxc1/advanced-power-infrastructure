# Governance Init Seed Prompt

Use this prompt when starting a new agent that needs to initialize governance.

```text
Before doing substantive work, initialize governance for this workspace.

Start by reading AGENTS.md at the workspace root. Follow its precedence order, always-load policy, task-map routing, and any kind-route instructions. If this workspace does not yet have local governance, use the setup guide at .governance/governance-init.md from the ai-governance repository to install or verify the local governance copy before acting.

Check the local self-stamp if one exists. Check the central registry if available. If current governance version equals target, continue silently. If current is behind target, report only:

Current: <version>
Target: <version>
Update before proceeding? yes/no

Then wait for Jason's answer before substantive work.

Do not write secrets into governance files. Do not treat draft text, silence, or execution permission as acceptance. When initialization is complete, state the loaded entrypoint, active governance source, active canon version or unknown value, and any unresolved drift.
```
