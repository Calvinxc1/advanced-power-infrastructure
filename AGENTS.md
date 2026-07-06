# AGENTS.md

Repository policy entrypoint. Active repo-local governance lives under `.governance/`.
This mod workspace must not contain a top-level `lab-governance/` tree; that tree belongs only in the source `ai-governance` repository.

Precedence:
`AGENTS.md` is the entrypoint. Loaded canon governance under `.governance/` is the base layer. Loaded local governance from `.governance/local/index.yaml` overrides the base layer for this repository. Explicit task overrides in `.governance/overrides/*` override both base and local governance for the declared one-shot operation only.

If ambiguity remains, ask before acting. Override-governance rules are non-overridable unless a process file explicitly says otherwise.

Always load:
- `.governance/policies/universal.yaml`

Load additional policy only via:
- `.governance/task-map.yaml`
- `.governance/kind-routes.yaml` when present on a kind branch
- `.governance/local/index.yaml` for repo-local governance when present
