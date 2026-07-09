# Governance Initialization

Purpose: give a new agent enough procedure to initialize governance before doing substantive work.

This document is a setup guide, not a replacement for policy. The operative contract remains the repository or workspace governance files the agent loads during initialization.

## Startup Order

1. Find the workspace governance entrypoint.

   Start with `AGENTS.md` at the workspace root. If no workspace-local `AGENTS.md` exists, ask Jason or the orchestrating agent where governance is mounted before doing substantive work.

2. Load the always-load policy.

   Follow the entrypoint exactly. In this governance system, the normal always-load file is `.governance/policies/universal.yaml` for an active workspace copy, or `lab-governance/policies/universal.yaml` when initializing from the generalized lab governance source.

3. Load task-specific policy through the task map.

   Use `.governance/task-map.yaml` in an active workspace copy. Use `lab-governance/task-map.yaml` only when bootstrapping from the generalized source or maintaining generalized governance itself.

   If the task asks the agent to join, monitor, coordinate in, or close an Althing or other live agent room, select the `live_agent_coordination` route before joining the room.

4. Load local governance when present.

   If `.governance/local/index.yaml` exists, read it after the base lab/canon governance. Treat it as the workspace-owned pointer into local governance. The lab governance contract prescribes only this pointer file and not the internal structure of `.governance/local/`.

   Local governance is the layer above the base lab/canon governance for that workspace. Explicit task overrides are the top layer and may override both base and local governance only for the declared one-shot operation.

5. Check branch or kind routing.

   If the active governance branch has a `.governance/kind-routes.yaml` file, load it after the task map. Trunk-general governance does not require a kind-routes file.

6. Prompt for the canonical agent name.

   Ask Jason or the orchestrating agent for the agent's Jason-settled canonical name before version reconciliation or substantive work. Use a direct prompt:

   ```text
   What canonical agent name should I use for this workspace?
   ```

   If `.governance/local/status.yaml`, a legacy self-stamp, or a legacy registry row already names a canonical agent, report that value and ask Jason to confirm or correct it. Do not infer the canonical name from the repository name, hostname, model backend, task role, or prior chat label.

7. Check local governance status.

   Read `.governance/local/status.yaml` when present. This is the universal local status path for a governed workspace. It records the agent's canonical name, kind, active governance branch, current active canon version, current generalized canon version, source, and locally attested status.

   If the file is missing during initialization or update, create it from `lab-governance/templates/local-status.yaml`. Fill only locally attested values and use `null` for unknowns. Legacy self-stamps such as `.governance/local/version-stamp.yaml` may be used as input, but the local status file is the authoritative portable report.

8. Apply the startup version rule.

   If current governance version equals target, continue silently. If current is behind target, report only:

   ```text
   Current: <version>
   Target: <version>
   Update before proceeding? yes/no
   ```

   Then wait for Jason's answer before substantive work.

   If Jason answers yes, use `lab-governance/templates/governance-bootstrap-prompt.md` from the ai-governance repository as the canonical bootstrap/update prompt. Follow that prompt for source branch selection, local governance update, local status update, and reconciliation reporting.

9. Declare loaded governance if action will follow.

   Before edits, connector actions, or other substantive work, state the intended action, affected files or systems, expected risk tier, and validation plan unless Jason's latest message already clearly authorized immediate execution.

## Althing And Live Room Join Checklist

Before joining an Althing or other live agent room:

- Load the `live_agent_coordination` route and the room transport's available connector boundaries.
- Know the room identifier, canonical agent name, assigned or expected role when one was provided, and any Jason-designated runner, closer, or liaison.
- Announce presence in one line after joining.
- Check current presence if the transport supports it.
- Participate in the preliminary coordination exchange before substantive room work begins.
- Keep cursor-aware polling active while the room remains active.
- Do not leave until suspended, closed out, or dismissed by name.

## Installing Governance Into A New Workspace

Use this sequence when an agent workspace does not yet have a local governance copy.

1. Identify the intended agent kind and source branch.

   First ask for the workspace's canonical agent name. If local status or a legacy registry row already exists, use it only as candidate evidence and ask Jason to confirm or correct the name before choosing a governance branch or kind.

2. Copy the branch-local governance picture into the workspace.

   A governed workspace should have a local `.governance/` tree and an `AGENTS.md` entrypoint. Do not point ordinary workspace agents directly at this repository's `.governance/` tree unless Jason explicitly chooses a centralized mount model for that workspace.

3. Preserve the entrypoint contract.

   `AGENTS.md` should stay thin. It should name the active governance directory, precedence order, always-load file, and routing files.

4. Create or update the local status file.

   Ensure `.governance/local/status.yaml` exists. Start from `lab-governance/templates/local-status.yaml`. Fill only locally attested values. Use `null` rather than invented data.

5. Create or preserve the local governance index.

   Ensure `.governance/local/index.yaml` exists. Start from `lab-governance/templates/local-index.yaml` if needed. The index is a loose pointer into local governance; do not prescribe the rest of `.governance/local/` from lab governance.

6. Reconcile local status with source governance state.

   Compare local status with the selected source branch descriptor and any legacy self-stamp. If records disagree, do not silently choose one. Mark the local status as `behind`, `drifted`, or `unknown` as appropriate, then route the decision to Jason through the active human liaison.

7. Confirm no secrets were introduced.

   Governance files may contain paths, branch names, canon versions, and provenance references. They must not contain tokens, API keys, private credentials, or recoverable secrets.

## Minimum Files For A Governed Workspace

The normal local workspace shape is:

```text
AGENTS.md
.governance/README.md
.governance/task-map.yaml
.governance/branch-descriptor.yaml
.governance/policies/universal.yaml
.governance/policies/*.yaml
.governance/processes/*.yaml
.governance/overrides/*.yaml
.governance/local/index.yaml
.governance/local/status.yaml
```

Kind branches may add:

```text
.governance/kind-routes.yaml
```

This `ai-governance` repository also maintains:

```text
lab-governance/
agent-registry/
canon-version-log/
```

Ordinary downstream repositories should not infer that they need to maintain those generalized governance maintenance trees locally.

`agent-registry/` is retained as a legacy central seed and historical audit aid. It is not the authoritative live status mechanism for governed workspaces.

## Acceptance Checklist

Governance is initialized when all of the following are true:

- The agent knows which governance entrypoint governs the workspace.
- The agent has asked for, confirmed, or explicitly reported as missing its Jason-settled canonical name.
- The agent has loaded `AGENTS.md` and the always-load policy.
- Additional policy was loaded only through the task map and any kind route.
- Local governance was loaded through `.governance/local/index.yaml` when present.
- The agent has checked `.governance/local/status.yaml` and reconciled it against source governance state when possible.
- Any version mismatch was reported using the minimal startup version rule.
- The agent can name the active canon version it believes it is consuming, or can clearly state that the value is unknown.
- The agent has not written secrets into governance files.
- Jason remains the final arbiter for unresolved human-owned decisions.

## Failure Modes

Stop and ask before substantive work when:

- No governance entrypoint can be found.
- The Jason-settled canonical agent name is missing or disputed.
- The active branch, kind, or target canon version is ambiguous.
- Local status, legacy self-stamp, and source governance state disagree.
- A policy conflict changes whether the agent may act.
- The requested task depends on accepting a draft governance rule as ratified.

When blocked, report the exact missing fact or conflict. Do not continue by treating silence, draft text, or execution permission as acceptance.
