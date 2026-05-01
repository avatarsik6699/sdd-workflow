# [PROJECT_NAME] — Claude Code adapter

**Start here:** read [`AGENTS.md`](AGENTS.md). It is the source of truth for all process rules — scope lock, gates, library lookup, git workflow, permission-denied handling, spec-sync protocol, CONTEXT.md version rules, and phase lifecycle.

This file only adds Claude-specific items.

## Slash commands (Claude Code skills)

| Command | When to use | Wraps playbook |
|---------|-------------|----------------|
| `/spec-init [--new\|--continue] [project brief]` | Draft, reset, or continue `docs/SPEC.md` from high-level requirements | [docs/playbooks/spec-init.md](docs/playbooks/spec-init.md) |
| `/phase-init [N]` | Scaffold the next `docs/PHASE_XX.md` from SPEC | [docs/playbooks/phase-init.md](docs/playbooks/phase-init.md) |
| `/impl-brief [N] [ID\|group]` | Before implementing: generate a concrete Implementation Plan per task in `docs/PHASE_N_NOTES.md` | [docs/playbooks/impl-brief.md](docs/playbooks/impl-brief.md) |
| `/impl-assist [N] [ID\|group]` | Have the agent implement uncompleted tasks (reads plan from `PHASE_N_NOTES.md`) | [docs/playbooks/impl-assist.md](docs/playbooks/impl-assist.md) |
| `/phase-gate [N]` | Validate a phase before committing | [docs/playbooks/phase-gate.md](docs/playbooks/phase-gate.md) |
| `/spec-sync [description]` | Immediately after editing `docs/SPEC.md` | [docs/playbooks/spec-sync.md](docs/playbooks/spec-sync.md) |
| `/context-update [N]` | After the gate passes | [docs/playbooks/context-update.md](docs/playbooks/context-update.md) |

Skill wrappers live in `.claude/skills/` and are intentionally thin — they just point at the playbooks in `docs/playbooks/`.

## MCP

`Context7` is wired in `.mcp.json` at the project root (Claude Code) and in `plugins/sdd-workflow/.mcp.json` (Codex). Per `AGENTS.md § Library Documentation Lookup`, prefer the MCP server when available; fall back to the `ctx7` CLI otherwise.
