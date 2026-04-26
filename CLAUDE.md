# Claude Code adapter — `sdd-workflow` repository

**Start here:** read [`AGENTS.md`](AGENTS.md). It is the source of truth for working on this repo.

This file adds only Claude-specific notes.

## Scope reminder

This repo IS the workflow bundle. Do not run `/spec-init`, `/phase-init`, `/phase-gate`,
`/spec-sync`, or `/context-update` against this repo's `docs/` — those skills are shipped to
integrated projects. The only skill that runs from here is `/workflow-init <target-path>`, and the
target must be **outside** this repo.

## Skills shipped from this repo

| Skill | Canonical playbook |
|-------|--------------------|
| `/workflow-init` | [`docs/playbooks/workflow-init.md`](docs/playbooks/workflow-init.md) |
| `/spec-init` (in integrated projects) | [`docs/playbooks/spec-init.md`](docs/playbooks/spec-init.md) |
| `/phase-init` (in integrated projects) | [`docs/playbooks/phase-init.md`](docs/playbooks/phase-init.md) |
| `/phase-gate` (in integrated projects) | [`docs/playbooks/phase-gate.md`](docs/playbooks/phase-gate.md) |
| `/spec-sync` (in integrated projects) | [`docs/playbooks/spec-sync.md`](docs/playbooks/spec-sync.md) |
| `/context-update` (in integrated projects) | [`docs/playbooks/context-update.md`](docs/playbooks/context-update.md) |

Wrappers under `.claude/skills/` and `project-files/.claude/skills/` are intentionally thin —
they just point at the playbooks above. To change workflow behavior, edit the playbook, never the
wrapper.
