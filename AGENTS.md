# Agent rules for working on the sdd-workflow repository itself

This file is for AI agents (Claude Code, Codex, others) editing **this repo**, not for projects
that have integrated the workflow. The agent rules shipped to those projects live in
[`project-files/AGENTS.md`](project-files/AGENTS.md). Do not confuse the two.

## Repo purpose

`sdd-workflow` is a stack-agnostic workflow bundle:

- canonical playbooks (`docs/playbooks/`)
- universal agent rules and skill wrappers (`project-files/`)
- a single bootstrap skill (`/workflow-init`) that copies the bundle into any target project

There is no CLI, no language runtime, no test suite. All artefacts are markdown, JSON, or shell.

## Source of truth

| Concern | Authoritative file |
|---------|--------------------|
| Workflow procedure (any integrated-project skill) | `docs/playbooks/<name>.md` |
| Agent rules shipped to integrated projects | `project-files/AGENTS.md` |
| Doc scaffolds shipped to integrated projects | `project-files/docs/templates/<name>.md` |
| Claude Code wrapper for an integrated-project skill | `project-files/.claude/skills/<name>/SKILL.md` |
| Codex wrapper for an integrated-project skill | `project-files/plugins/sdd-workflow/{commands,skills}/<name>...` |
| Bootstrap skill (run from this repo) | `.claude/skills/workflow-init/SKILL.md`, `plugins/sdd-workflow/...`, `docs/playbooks/workflow-init.md` |

The wrappers are thin pointers to the playbooks. **Never duplicate workflow logic in a wrapper.**
If you find logic in a wrapper, push it to the playbook and shrink the wrapper back to a stub.

## Don't run derived-project skills against this repo

`/spec-init`, `/phase-init`, `/phase-gate`, `/spec-sync`, `/context-update`, `/impl-brief`,
`/impl-assist`, `/project-sync` are intended for integrated projects. Do not invoke them against
this repo's `docs/`. The only skill that runs from here is `/workflow-init`, and it must be run
with a target path pointing **outside** this repo.

## Editing rules

1. **Edit the playbook, not the wrapper.** When changing a workflow procedure, change
   `docs/playbooks/<name>.md`. Then mirror the file to `project-files/docs/playbooks/<name>.md` so
   integrated projects can pick it up. The wrappers under `.claude/skills/` and
   `plugins/sdd-workflow/` should not need updates unless the *interface* of the skill changes
   (frontmatter, argument hint).
2. **Keep `project-files/AGENTS.md` stack-agnostic.** Anything specific to a stack (Playwright,
   Docker, pnpm, FastAPI, Spring) belongs in `project-files/docs/templates/STACK.md`, not in
   `AGENTS.md`. If a stack assumption sneaks in, push it back to STACK.
3. **Do not invent or rename document files.** The doc set shipped to projects is fixed:
   `SPEC.md`, `STATE.md`, `CHANGELOG.md`, `CONTEXT.md`, `STACK.md`, `PHASE_TEMPLATE.md`,
   `PHASE_XX.md`, `KNOWN_GOTCHAS.md`, `DECISIONS.md`. Adding a new one means updating
   `workflow-init.md`, the doc-roles table in `AGENTS.md`, and possibly all five other playbooks.
   Don't do it lightly.
4. **No code dependencies.** This repo must remain installable by `git clone` alone. Do not add a
   `package.json`, `pyproject.toml`, `Cargo.toml`, or any build manifest.

## Library docs lookup

When changes touch tools or technologies (e.g. you're updating a snippet that uses Context7, MCP,
or a specific runtime), look up current docs via:

1. Context7 MCP if available
2. `npx ctx7@latest library "<name>"` then `docs /org/project "<question>"`
3. Official documentation

Do not rely on training data alone for tool versions and CLI flags.

## Git workflow

- Work in branches: `feat/<topic>`, `fix/<topic>`, `chore/<topic>`.
- Exception for sole maintainer: direct commits/pushes to `main` are allowed for small, low-risk changes
  (for example docs, diagrams, or release metadata) when faster turnaround is needed.
  Use branch + PR flow for larger or risky changes.
- Conventional commits: `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`, `refactor: ...`.
- Never `--force` push, never `git reset --hard` without explicit user instruction.
- Tag releases as `vX.Y.Z` on `main` after merge.

## Releases

This repo has a single version line. Cut a release by tagging `main`:

```bash
git tag -a v1.0.0 -m "sdd-workflow v1.0.0"
git push origin v1.0.0
```

Integrated projects upgrade by re-running `/workflow-init` from a fresh clone of the new tag — the
skill is idempotent and only overwrites versioned files (wrappers, playbooks).

## What lives where (file map)

```
sdd-workflow/
├── docs/
│   ├── playbooks/           # CANONICAL workflow procedures (9 files)
│   └── CONTRIBUTING.md
├── project-files/           # Source for everything /workflow-init copies into a target project
│   ├── AGENTS.md
│   ├── CLAUDE.md
│   ├── .mcp.json
│   ├── .claude/skills/<8>/SKILL.md
│   ├── plugins/sdd-workflow/
│   ├── docs/playbooks/<9>.md  (mirror of docs/playbooks/)
│   └── docs/templates/<8 doc scaffolds>
├── .claude/skills/workflow-init/SKILL.md
├── plugins/sdd-workflow/      # Bootstrap-only Codex plugin (just /workflow-init)
├── scripts/block-dangerous-bash.sh
├── README.md
├── AGENTS.md (this file)
└── CLAUDE.md
```
