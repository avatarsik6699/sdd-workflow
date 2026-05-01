# sdd-workflow

[English](README.md) | [Русский](README.ru.md)

[![Lint](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/lint.yml/badge.svg)](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/lint.yml)
[![Links](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/links.yml/badge.svg)](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/links.yml)
[![Release](https://img.shields.io/github/v/release/avatarsik6699/sdd-workflow)](https://github.com/avatarsik6699/sdd-workflow/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://avatarsik6699.github.io/sdd-workflow/)

A clean, stack-agnostic Spec-Driven Development workflow that drops into any repository.
It defines a documentation contract, a repeatable phase loop, and clear gate criteria so teams can move from requirements to implementation with predictable checkpoints.

![sdd-workflow preview](preview.png)

## Getting started

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
# Run in your agent session:
/workflow-init /path/to/your-project
cd /path/to/your-project
```

Initialize the workflow in your target project once, then run this delivery loop for each phase:

1. `/spec-init` — draft or refresh `docs/SPEC.md`
2. `/phase-init 01` — scaffold `docs/PHASE_01.md` + per-task `docs/PHASE_01_NOTES.md`
3. *(optional)* `/impl-brief 01` — generate concrete per-task implementation plans
4. Implement the scoped phase (manually, via agent, or hybrid)
5. *(optional)* `/impl-assist 01` — let the agent implement unchecked tasks
6. `/phase-gate 01` — run checks and validate architect review notes
7. `/context-update 01` — finalize the phase and sync context documents
8. *(optional)* `/project-sync` — mirror task statuses to GitHub Issues + Projects Kanban board

## Workflow map

![Workflow diagram](docs/assets/workflow.png)

## What you get

- Canonical playbooks in `docs/playbooks/` that define each workflow skill and the expected procedure.
- Bootstrap and integrated-project wrappers for Claude Code and Codex, so teams can apply the same process in different agent environments.
- A fixed documentation contract (`SPEC.md`, `STATE.md`, `CONTEXT.md`, `CHANGELOG.md`, `PHASE_XX.md`, `PHASE_XX_NOTES.md`) that keeps planning, execution, and project memory in sync.
- Optional GitHub integration: `/project-sync` keeps a GitHub Projects v2 Kanban board in sync with your phase task checkboxes — no manual board updates needed.
- No CLI, no runtime dependency, and no build manifest: the workflow ships as portable documentation and wrappers.

## How the workflow is used

In a target repository, the first step (`/workflow-init`) installs the workflow files and skill wrappers.
After that, each phase follows the same pattern: define scope from SPEC, optionally generate per-task implementation plans, implement only that scope (manually or via agent), run a gate review, and update context documents.
This structure keeps scope controlled and gives contributors a consistent way to understand project status over time.

## Where to read

- Docs site (EN): <https://avatarsik6699.github.io/sdd-workflow/>
- Docs site (RU): appears at `/ru/` on the same domain after the first bilingual Pages deploy
- Quickstart page: [docs/quickstart.md](docs/quickstart.md)
- Skills catalog: [docs/skills.md](docs/skills.md)
- FAQ: [docs/faq.md](docs/faq.md)
- Playbooks: [docs/playbooks/](docs/playbooks/)
- Contributing: [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)

## Repo map

- [docs/playbooks/](docs/playbooks/) — canonical workflow procedures.
- [project-files/](project-files/) — exact tree copied into target projects.
- [.claude/skills/workflow-init/](.claude/skills/workflow-init/) — bootstrap wrapper for this repo.
- [plugins/sdd-workflow/](plugins/sdd-workflow/) — bootstrap plugin for Codex.
- [AGENTS.md](AGENTS.md) — rules for working on this repository.

## License

MIT
