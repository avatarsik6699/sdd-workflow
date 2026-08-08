# SDD Workflow Codex Plugin

This plugin exposes the project-local SDD workflow to Codex as native slash commands and skills.
All workflow logic lives in `docs/playbooks/`; plugin files are thin wrappers.

## Commands

- `/plan` — draft/refresh `docs/SPEC.md` and scaffold a new `docs/changes/NN-slug.md` with its
  feature branch
- `/work` — implement Backlog tasks (default) or fix unchecked Architect Review Notes
  (`/work [XX] review`) through the same agent execution loop, absorbing mid-session findings and
  running the Fast Gate
- `/ship` — run the Full Gate, merge to `main`, archive the change, and (with `--release`) push
  and verify the deploy

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
