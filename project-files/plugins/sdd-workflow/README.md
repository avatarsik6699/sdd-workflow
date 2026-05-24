# SDD Workflow Codex Plugin

This plugin exposes the project-local SDD workflow to Codex as native slash commands and skills.
All workflow logic lives in `docs/playbooks/`; plugin files are thin wrappers.

## Commands

- `/spec-init` — draft or refresh `docs/SPEC.md`
- `/spec-sync` — propagate approved spec changes
- `/phase-init` — scaffold a phase contract and agent execution memory
- `/impl-assist` — implement scoped phase tasks through the agent execution loop
- `/impl-review-notes` — fix unchecked Architect Review Notes
- `/phase-gate` — validate automated checks and unresolved review notes
- `/context-update` — finalize completed phase memory

## Hooks

The plugin-local [`hooks.json`](./hooks.json) is a reference policy for the workflow bundle. Current
Codex plugin manifests do not load hooks directly; if your workspace uses project-scoped Codex hook
config, point it at this file.

The active hook covers `PreToolUse` for `Bash` and blocks dangerous commands via
[`scripts/block-dangerous-bash.sh`](./scripts/block-dangerous-bash.sh).

## Docs MCPs

The plugin declares project-local docs MCP servers in [`.mcp.json`](./.mcp.json):

- `context7` for third-party library/framework docs
- `openaiDeveloperDocs` for OpenAI platform/developer docs

See [`AGENTS.md`](../../AGENTS.md) at the project root for the full agent contract.

## Restart requirement

After adding or changing plugin files, restart Codex in this workspace so the plugin, slash
commands, and marketplace entry are reloaded.
