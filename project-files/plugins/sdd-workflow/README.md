# SDD Workflow Codex Plugin

This plugin makes the project's SDD workflow visible to Codex as native:

- skills under `skills/`
- slash commands under `commands/`
- project-local MCP expectations via `.mcp.json`
- a reference Codex hook config in `hooks.json`

## What this adds

- `/spec-init`
- `/phase-init`
- `/phase-gate`
- `/context-update`
- `/spec-sync`
- `/impl-brief` — generate a concrete implementation plan for phase tasks (optional)
- `/impl-assist` — implement uncompleted phase tasks (optional)

The plugin mirrors the Claude Code wrappers in `.claude/skills/`. Both runtimes point at the same canonical playbooks under `docs/playbooks/`.

## Hooks

The plugin-local [`hooks.json`](./hooks.json) is a reference policy for the workflow bundle. Current Codex plugin manifests do not load hooks directly — if your workspace uses project-scoped Codex hook config, point it at this file.

The active hook only covers `PreToolUse` for `Bash` (it blocks dangerous commands via [`scripts/block-dangerous-bash.sh`](./scripts/block-dangerous-bash.sh)). Codex currently does not emit `Write`, `Edit`, or `MultiEdit` for `PostToolUse`, so format-on-write hooks cannot be implemented through the current hooks API.

## Docs MCPs

The plugin declares project-local docs MCP servers in [`.mcp.json`](./.mcp.json):

- `context7` (third-party library/framework docs)
- `openaiDeveloperDocs` (OpenAI platform/developer docs)

Codex can also use global MCP entries, which remain the most reliable option when `context7-mcp` is not on PATH.

Recommended docs lookup order:

1. `context7` via MCP for third-party library/framework docs
2. `openaiDeveloperDocs` via MCP for OpenAI platform/API docs
3. `ctx7` CLI fallback
4. Official docs only when MCP/CLI are unavailable

See [`AGENTS.md`](../../AGENTS.md) at the project root for the full agent contract.

## Restart requirement

After adding or changing plugin files, restart Codex in this workspace so the plugin, slash commands, and marketplace entry are reloaded.
