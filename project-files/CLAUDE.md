# [PROJECT_NAME] — Claude Code adapter

**Start here:** read [`AGENTS.md`](AGENTS.md). It is the source of truth for core rules, gates,
library lookup, git workflow, permission-denied handling, and the change lifecycle.

This file only lists Claude-specific command wrappers.

## Slash commands

| Command | When to use | Wraps playbook |
|---------|-------------|----------------|
| `/plan ["brief" \| path/to/draft.md] [--new\|--continue]` | Draft/refresh `docs/SPEC.md` and scaffold a new `docs/changes/NN-slug.md` with its feature branch | [docs/playbooks/plan.md](docs/playbooks/plan.md) |
| `/work [NN] [ID\|group]` | Agent implements Backlog items, absorbing mid-session findings, running the Fast Gate | [docs/playbooks/work.md](docs/playbooks/work.md) |
| `/work [NN] review [R#]` | Agent fixes unchecked Architect Review Notes | [docs/playbooks/work.md](docs/playbooks/work.md) |
| `/ship [NN] [--release]` | Full Gate; on PASS merge to `main` and archive; with `--release`, push and verify deploy | [docs/playbooks/ship.md](docs/playbooks/ship.md) |

Skill wrappers live in `.claude/skills/` and are intentionally thin.

## MCP

`Context7` is wired in `.mcp.json` at the project root and in
`plugins/sdd-workflow/.mcp.json` for Codex. Per `AGENTS.md § Library Documentation Lookup`, prefer
MCP documentation lookup when available.
