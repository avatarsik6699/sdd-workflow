# Agent rules for working on the sdd-workflow repository itself

This file is for agents editing **this repo**, not for projects that have integrated the workflow.
The rules shipped to integrated projects live in [`project-files/AGENTS.md`](project-files/AGENTS.md).

## Repo purpose

`sdd-workflow` is a compact, stack-agnostic workflow bundle for agent-only coding:

- canonical playbooks in `docs/playbooks/`
- universal agent rules, templates, and wrappers in `project-files/`
- a single bootstrap skill, `/workflow-init`, that copies the bundle into a target project

There is no CLI, language runtime, package manager, docs site, or test suite. Artefacts are
markdown, JSON, or shell.

## Source of truth

| Concern | Authoritative file |
|---------|--------------------|
| Workflow procedure | `docs/playbooks/<name>.md` |
| Agent rules shipped to projects | `project-files/AGENTS.md` |
| Doc scaffolds shipped to projects | `project-files/docs/templates/<name>.md` |
| Claude wrapper for an integrated-project skill | `project-files/.claude/skills/<name>/SKILL.md` |
| Codex wrapper for an integrated-project skill | `project-files/plugins/sdd-workflow/{commands,skills}/<name>...` |
| Bootstrap skill | `.claude/skills/workflow-init/SKILL.md`, `plugins/sdd-workflow/...`, `docs/playbooks/workflow-init.md` |

Wrappers are thin pointers to playbooks. Never duplicate workflow logic in a wrapper.

## Do not run derived-project skills against this repo

`/spec-init`, `/spec-sync`, `/phase-init`, `/impl-assist`, `/impl-review-notes`, `/phase-gate`, and
`/context-update` are intended for integrated projects. Do not invoke them against this repo's
`docs/`. The only skill that runs from here is `/workflow-init`, and its target path must be
outside this repo.

## Editing rules

1. **Edit the playbook, not the wrapper.** When changing workflow behavior, edit
   `docs/playbooks/<name>.md`, then mirror it to `project-files/docs/playbooks/<name>.md`.
2. **Keep integrated-project rules stack-agnostic.** Stack-specific assumptions belong in
   `project-files/docs/templates/STACK.md`, not `project-files/AGENTS.md`.
3. **Do not invent document files.** The shipped doc set is fixed: `SPEC.md`, `STATE.md`,
   `CHANGELOG.md`, `CONTEXT.md`, `STACK.md`, `PHASE_TEMPLATE.md`, `PHASE_XX.md`,
   `PHASE_XX_NOTES.md`, `KNOWN_GOTCHAS.md`, `DECISIONS.md`.
4. **No code dependencies.** The repo must remain installable by `git clone` alone. Do not add a
   `package.json`, `pyproject.toml`, `Cargo.toml`, or other build manifest.
5. **No docs site.** Do not reintroduce hosted documentation, marketing docs, or generated
   documentation assets.

## Library docs lookup

When changes touch tools or technologies such as Context7, MCP, Claude Code, Codex plugins, or a
specific runtime, look up current docs via:

1. Context7 MCP if available
2. `npx ctx7@latest library "<name>"` then `docs /org/project "<question>"`
3. Official documentation

Do not rely on training data alone for tool versions and CLI flags.

## Git workflow

- Work in branches: `feat/<topic>`, `fix/<topic>`, `chore/<topic>`.
- Direct commits to `main` are acceptable for small low-risk maintainer changes.
- Use conventional commits.
- Never force-push or run destructive git commands without explicit instruction.
- Tag releases as `vX.Y.Z` on `main`.

## What lives where

```text
sdd-workflow/
├── docs/playbooks/                     # canonical workflow procedures
├── project-files/                      # source tree copied by /workflow-init
│   ├── AGENTS.md
│   ├── CLAUDE.md
│   ├── .claude/skills/<7>/SKILL.md
│   ├── plugins/sdd-workflow/
│   ├── docs/playbooks/<8>.md
│   └── docs/templates/
├── .claude/skills/workflow-init/
├── plugins/sdd-workflow/               # bootstrap-only Codex plugin
├── scripts/
├── README.md
├── AGENTS.md
└── CLAUDE.md
```
