# [PROJECT_NAME] — Claude Code adapter

**Start here:** read [`AGENTS.md`](AGENTS.md). It is the source of truth for scope lock, gates,
library lookup, git workflow, permission-denied handling, spec-sync protocol, and the phase
lifecycle.

This file only lists Claude-specific command wrappers.

## Slash commands

| Command | When to use | Wraps playbook |
|---------|-------------|----------------|
| `/spec-init [--new\|--continue] [project brief]` | Draft, reset, or continue `docs/SPEC.md` | [docs/playbooks/spec-init.md](docs/playbooks/spec-init.md) |
| `/spec-sync [description]` | Immediately after editing `docs/SPEC.md` | [docs/playbooks/spec-sync.md](docs/playbooks/spec-sync.md) |
| `/phase-init [N]` | Scaffold `docs/PHASE_XX.md` and agent execution memory | [docs/playbooks/phase-init.md](docs/playbooks/phase-init.md) |
| `/impl-assist [N] [ID\|group]` | Agent implements scoped phase tasks | [docs/playbooks/impl-assist.md](docs/playbooks/impl-assist.md) |
| `/impl-review-notes [N] [R#]` | Agent fixes unchecked Architect Review Notes | [docs/playbooks/impl-review-notes.md](docs/playbooks/impl-review-notes.md) |
| `/phase-gate [N]` | Validate automated checks and unresolved review notes | [docs/playbooks/phase-gate.md](docs/playbooks/phase-gate.md) |
| `/context-update [N]` | Finalize completed phase memory | [docs/playbooks/context-update.md](docs/playbooks/context-update.md) |

Skill wrappers live in `.claude/skills/` and are intentionally thin.

## MCP

`Context7` is wired in `.mcp.json` at the project root and in
`plugins/sdd-workflow/.mcp.json` for Codex. Per `AGENTS.md § Library Documentation Lookup`, prefer
MCP documentation lookup when available.
