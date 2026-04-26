# Stack Guide

> **Source of truth for this project's concrete technologies, tools, and conventions.**
>
> The SDD pipeline (phases, gates, skills, contracts) is stack-agnostic. This file is the only
> place where the workflow learns what to actually run. The `phase-gate` playbook reads
> [`Gate Commands`](#gate-commands) below verbatim — keep that table accurate.

---

## Stack

| Layer | Technology |
|-------|-----------|
| Backend | [e.g. FastAPI / Express / Spring Boot — fill in] |
| Frontend | [e.g. Nuxt 4 / Next.js / React Router / —] |
| Database | [e.g. PostgreSQL 18 / MySQL / SQLite / —] |
| Cache | [e.g. Redis / —] |
| Infra | [e.g. Docker Compose / Kubernetes / bare metal] |
| Package managers | [e.g. uv (backend), pnpm (frontend)] |
| CI | [e.g. GitHub Actions / GitLab CI / —] |

---

## Prerequisites

```bash
# Examples — replace with the actual versions this project requires
# docker --version
# node --version
# python --version
```

---

## Initial setup

```bash
# How a developer brings the stack up the first time.
# Examples:
# docker compose up --build
# uv sync
# cd frontend && pnpm install && pnpm dev
```

---

## Gate Commands

This section is the human-readable command source for the [`phase-gate`](playbooks/phase-gate.md)
workflow. Fill every row that applies to this project. Mark `n/a` for rows that do not apply
(e.g. no frontend → frontend rows are `n/a`). The phase-gate playbook will report `SKIPPED — n/a in
STACK.md` for those.

| Gate check | Command | Preconditions / notes |
|------------|---------|-----------------------|
| Infrastructure / bootstrap | `[command to start services]` | [e.g. needs `.env`, all services healthy] |
| Migrations | `[command to apply migrations]` | [e.g. run inside backend container] |
| Backend / unit tests | `[command]` | [working dir, env requirements] |
| Frontend prep | `[command]` or `n/a` | [e.g. `pnpm nuxt prepare`; required before typecheck] |
| Frontend type-check | `[command]` or `n/a` | |
| Frontend unit tests | `[command]` or `n/a` | |
| E2E lint / determinism | `[command]` or `n/a` | [e.g. fail on `waitForTimeout`] |
| E2E | `[command]` or `n/a` | |
| Smoke | `[command]` | [phase files may override] |

If the project ships a helper script, declare it:

```bash
# ./scripts/phase-gate.sh [XX]
```

---

## Testing

### Backend

```bash
# [test command + notes]
```

### Frontend (if applicable)

```bash
# [unit / typecheck / e2e commands]
```

---

## Project structure

```
.
├── docs/                   # SPEC, CONTEXT, STATE, CHANGELOG, PHASE_XX, STACK (this file), playbooks
├── .claude/skills/         # Claude Code skill wrappers (5 SDD skills)
├── plugins/sdd-workflow/   # Codex plugin (skills, commands, MCP, hooks)
├── [your source dirs]
└── AGENTS.md / CLAUDE.md   # AI agent rules
```

---

## Common operations

```bash
# Start the stack
# [command]

# Stop everything
# [command]

# Add a new migration / schema change
# [command]

# Format / lint
# [command]
```
