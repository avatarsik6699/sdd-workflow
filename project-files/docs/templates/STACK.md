# Stack Guide

> **Source of truth for this project's concrete technologies, tools, and conventions.**
>
> The SDD pipeline (`plan` / `work` / `ship`) is specialized for web applications but stack-neutral
> within that: this file is where it learns what to actually run. `docs/playbooks/work.md` reads
> the [Fast Gate](#fast-gate) and [Required Tooling](#required-tooling) tables verbatim;
> `docs/playbooks/ship.md` reads [Full Gate](#full-gate) and [Release Gate](#release-gate) verbatim.
> Keep these tables accurate.
>
> **Stack status:** [STACK_STATUS]

---

## Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React + TanStack Start + TanStack Query + `openapi-typescript` (API type generation) — default; replace if this project differs |
| Backend | [backend varies per project, may be polyglot — describe here, e.g. Python/FastAPI] |
| Database | [e.g. PostgreSQL — default suggestion] |
| Cache | [e.g. Redis / —] |
| Infra | Docker + Nginx — default; replace if this project differs |
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
# pnpm install && pnpm dev
```

---

## Fast Gate

Run by `/work` after each Backlog item or Architect Review Note, scoped to the touched area only —
not the full suite. Fill every row that applies; mark `n/a` for rows that don't (e.g. no frontend
→ frontend rows are `n/a`). Reported as `SKIPPED — n/a in STACK.md` otherwise.

| Check | Command | Preconditions / notes |
|-------|---------|-----------------------|
| Lint | `[command]` or `n/a` | |
| Type-check (affected) | `[command]` or `n/a` | |
| Targeted / affected unit tests | `[command]` or `n/a` | |
| LSP diagnostics | `[available: yes/no]` | informational — enforced via Required Tooling, not a shell command |
| API type regen (`openapi-typescript` or equivalent) | `[command]` or `n/a` | run when the API surface changed |

---

## Full Gate

Run once by `/ship`, before merging a change's feature branch into `main`. Do not run this per
task — it's expensive by design; that's why it's separated from the Fast Gate.

| Check | Command | Preconditions / notes |
|-------|---------|-----------------------|
| Infrastructure / bootstrap | `[command to start services]` | [e.g. needs `.env`, all services healthy] |
| Migrations | `[command]` or `n/a` | [e.g. run inside backend container] |
| Backend test suite | `[command]` | |
| Frontend build | `[command]` or `n/a` | |
| Frontend unit tests | `[command]` or `n/a` | |
| E2E lint / determinism | `[command]` or `n/a` | [e.g. fail on `waitForTimeout`] |
| E2E (Playwright) | `[command]` or `n/a` | |
| Smoke | `[command]` | [change files may override] |
| SAST (e.g. Semgrep) | `[command]` or `n/a` | |
| Secrets scan (e.g. Gitleaks) | `[command]` or `n/a` | |
| Dependency audit (e.g. Trivy / `npm audit` / `pip-audit`) | `[command]` or `n/a` | |
| Accessibility audit (e.g. axe / Lighthouse CI) | `[command]` or `n/a` | |
| Performance budget (e.g. Lighthouse CI, Core Web Vitals) | `[command]` or `n/a` | thresholds: LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1 (adjust per project) |

If the project ships a helper script, declare it:

```bash
# ./scripts/ship.sh [XX]
```

---

## Release Gate

Run only by `/ship --release`, after the Full Gate has passed and the change is merged locally —
before pushing to `origin/main`.

| Check | Command | Preconditions / notes |
|-------|---------|-----------------------|
| Container image scan (e.g. Trivy) | `[command]` or `n/a` | |
| Health-check / zero-downtime deploy verification | `[command or endpoint]` | e.g. poll a `/health` endpoint post-deploy |
| `gh` authenticated for this repo | `[yes/no]` | required for `/ship --release` to confirm CI/deploy status |

---

## Required Tooling

Mandatory tools/skills per domain — `/work` enforces these before checking an item off; a mandated
tool that isn't available must be reported as skipped with a reason, never silently omitted.

| Domain | Required tool/skill | When | Available in this project |
|--------|----------------------|------|-----------------------------|
| Frontend UI change | Playwright MCP / chrome-devtools MCP (screenshot + console check) | after implementing, before checking off | `[yes/no]` |
| TypeScript / Python change | LSP diagnostics | after implementing, before checking off | `[yes/no]` |
| New/changed API surface | `openapi-typescript` (or equivalent) regen + frontend re-typecheck | after backend contract change | `[yes/no]` |
| Architecture-level decision | architecture skill | during planning | `[yes/no]` |
| Frontend design decision | `frontend-design` skill | during `/plan` §5.3 and design Backlog items | `[yes/no]` |
| Backend/API design decision | `backend-design` skill | during `/plan` §4 and backend-architecture Backlog items | `[yes/no]` |

Mark a row `no` (not available) rather than leaving it blank — an unmarked row is otherwise
ambiguous between "not asked" and "not needed."

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
├── docs/
│   ├── SPEC.md              # vision/contract anchor
│   ├── STACK.md              # this file
│   ├── KNOWN_GOTCHAS.md      # recurring pitfalls
│   ├── CHANGE_TEMPLATE.md    # template for new changes
│   ├── changes/              # active units of work
│   │   └── archive/          # completed units of work
│   └── playbooks/            # plan.md / work.md / ship.md / workflow-init.md
├── .claude/skills/            # Claude Code skill wrappers (plan, work, ship)
├── .agents/skills/             # generic-agent skill wrappers (plan, work, ship)
├── plugins/sdd-workflow/       # Codex plugin (skills, commands, MCP, hooks)
├── [your source dirs]
└── AGENTS.md / CLAUDE.md       # AI agent rules
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
