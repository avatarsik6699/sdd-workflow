# Claude Code adapter — `sdd-workflow` repository

**Start here:** read [`AGENTS.md`](AGENTS.md). It is the source of truth for working on this repo.

## Scope reminder

This repo is the workflow bundle. Do not run integrated-project skills against this repo's `docs/`.
Only `/workflow-init <target-path>` runs from here, and the target must be outside this repo.

## Skills shipped from this repo

| Skill | Canonical playbook |
|-------|--------------------|
| `/workflow-init` | [`docs/playbooks/workflow-init.md`](docs/playbooks/workflow-init.md) |
| `/spec-init` (integrated projects) | [`docs/playbooks/spec-init.md`](docs/playbooks/spec-init.md) |
| `/spec-sync` (integrated projects) | [`docs/playbooks/spec-sync.md`](docs/playbooks/spec-sync.md) |
| `/phase-init` (integrated projects) | [`docs/playbooks/phase-init.md`](docs/playbooks/phase-init.md) |
| `/impl-assist` (integrated projects) | [`docs/playbooks/impl-assist.md`](docs/playbooks/impl-assist.md) — also handles Architect Review Notes via `/impl-assist [XX] review` |
| `/phase-gate` (integrated projects) | [`docs/playbooks/phase-gate.md`](docs/playbooks/phase-gate.md) |
| `/context-update` (integrated projects) | [`docs/playbooks/context-update.md`](docs/playbooks/context-update.md) |

Wrappers under `.claude/skills/` and `project-files/.claude/skills/` are intentionally thin.
Change workflow behavior in the playbooks, then mirror them into `project-files/docs/playbooks/`.
