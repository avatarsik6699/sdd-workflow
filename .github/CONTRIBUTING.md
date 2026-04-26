# Contributing to sdd-workflow

This repo ships a stack-agnostic SDD workflow. Everything is markdown, JSON, or shell. There is no
build step, no language runtime, no CLI.

## What lives where

- `docs/playbooks/` — canonical workflow procedures. The single source of truth for every skill.
- `project-files/` — exact files copied into a target project when `/workflow-init` runs. Subtree:
  - `project-files/AGENTS.md` — universal agent rules (stack-agnostic)
  - `project-files/CLAUDE.md` — Claude wrapper pointing at AGENTS.md
  - `project-files/.claude/skills/<name>/SKILL.md` — Claude Code skill wrappers (5 skills)
  - `project-files/plugins/sdd-workflow/` — Codex plugin layout (commands, skills, hooks, MCP)
  - `project-files/.mcp.json` — Claude Code MCP config
  - `project-files/docs/playbooks/` — playbook copies the project will read at runtime
  - `project-files/docs/templates/` — document scaffolds (SPEC.md, STATE.md, STACK.md, …)
- `.claude/skills/workflow-init/` and `plugins/sdd-workflow/` (root) — bootstrap discovery for the
  *one* skill that runs from this repo: `/workflow-init`.
- `scripts/` — bash helpers used both by this repo and by integrated projects.

## When you change a playbook

1. Edit the file under `docs/playbooks/<name>.md`.
2. Mirror the change into `project-files/docs/playbooks/<name>.md` so integrated projects pick it
   up on their next `/workflow-init` upgrade. (Run `scripts/sync-wrappers.sh` to verify both copies
   agree.)
3. The skill wrappers under `project-files/.claude/skills/` and `project-files/plugins/sdd-workflow/`
   should not need changes — they only carry `description` frontmatter and a one-line pointer to
   the playbook.

## When you change AGENTS.md

`project-files/AGENTS.md` is universal. Anything stack-specific (Playwright, Docker, pnpm, etc.)
belongs in `docs/STACK.md` of the integrated project, not in `AGENTS.md`. If you find yourself
adding a stack assumption to `AGENTS.md`, push it into the `STACK.md` template instead.

## Adding a new skill

1. Write the playbook at `docs/playbooks/<name>.md`.
2. Add a copy to `project-files/docs/playbooks/<name>.md`.
3. Add Claude Code wrapper at `project-files/.claude/skills/<name>/SKILL.md`.
4. Add Codex wrappers at `project-files/plugins/sdd-workflow/{commands,skills}/<name>...`.
5. Add a row in `project-files/AGENTS.md` under `Workflow Playbooks`.
6. Update `/workflow-init` if the new skill needs project-time setup.

## Tests

There is no automated test suite. Verify changes by running `/workflow-init` against a throwaway
directory and checking that the generated project has the expected files and that the five skills
work end-to-end.
