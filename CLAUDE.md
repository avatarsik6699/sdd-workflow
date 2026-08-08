# Claude Code adapter — `sdd-workflow` repository

**Start here:** read [`AGENTS.md`](AGENTS.md). It is the source of truth for working on this repo.

## Scope reminder

This repo is the workflow bundle. Do not run integrated-project skills against this repo's `docs/`.
Only `/workflow-init <target-path>` runs from here, and the target must be outside this repo.

## Skills shipped from this repo

| Skill | Canonical playbook |
|-------|--------------------|
| `/workflow-init` | [`docs/playbooks/workflow-init.md`](docs/playbooks/workflow-init.md) |
| `/plan` (integrated projects) | [`docs/playbooks/plan.md`](docs/playbooks/plan.md) — draft/refresh SPEC.md, scaffold a change |
| `/work` (integrated projects) | [`docs/playbooks/work.md`](docs/playbooks/work.md) — implement Backlog tasks or fix Architect Review Notes (`/work [XX] review`) |
| `/ship` (integrated projects) | [`docs/playbooks/ship.md`](docs/playbooks/ship.md) — Full Gate, merge, archive, and (`--release`) push + deploy verification |

Wrappers under `.claude/skills/`, `project-files/.claude/skills/`, `project-files/.agents/skills/`,
and `project-files/plugins/sdd-workflow/` are intentionally thin. Change workflow behavior in the
playbooks, then mirror them into `project-files/docs/playbooks/`.
