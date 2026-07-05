# .governance

This directory contains the repository's governance corpus.

## Layout

- `policies/`: standing repository policies grouped by domain, stored as YAML.
- `task-map.yaml`: task-to-policy routing map for selective loading.
- `processes/`: governance-process rules such as override handling and policy maintenance, stored as YAML.
- `overrides/`: structured override records and the schema governing those records.

## Project Fit

This repository is a personal Factorio mod for porting Advanced Power Infrastructure to Factorio 2.0 and Space Age. Governance should keep changes deliberate, reversible, and easy to validate without adding heavyweight process.

## Critical References

- `https://github.com/Calvinxc1/argo-data-interpolation/tree/dev`: primary external reference for governance structure and maintenance patterns. Reference this repository when changing governance layout, policy routing, override handling, changelog conventions, or AI-agent policy expectations. Adapt the pattern to this Factorio mod; do not import research, notebook, Python packaging, or application-specific rules unless they are directly applicable.

## Guidance

- Keep standing policy in `policies/`.
- Keep task routing in `task-map.yaml`.
- Keep meta-governance and maintenance rules in `processes/`.
- Keep temporary exception records and their data definitions in `overrides/`.
- When policy structure changes, update `AGENTS.md` and this directory together.
