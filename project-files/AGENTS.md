# Rules of operation of the AI agent during [PROJECT_NAME] development

These rules are stack-agnostic. They are the contract any AI agent (Claude Code, Codex, others)
must follow when working on this project. Anything specific to this project's technologies
(test runners, package managers, container tooling, frontend conventions, e2e rules) lives in
[`docs/STACK.md`](docs/STACK.md).

## Core Rules

1. **Scope Lock**: Do only what is specified in the active `docs/PHASE_XX.md`. Do not assume future phases.
2. **No Guessing**: If a requirement is genuinely ambiguous and risky, ask a concise terminal question instead of inventing behavior.
3. **Gates First**: Before each commit, run the `phase-gate` workflow for the current phase. Commit only if the report is PASS. Automated green is not enough if `Architect Review Notes` still has unchecked items.
4. **Atomic Commits**: `feat|fix|chore|docs|test|refactor(scope): description`. One commit = one logical task.
5. **Security**: No hardcoded secrets. Use `.env`, environment variables, and typed settings appropriate to the stack.
6. **Context Sync**: After each phase completes, run the `context-update` workflow to refresh `docs/CONTEXT.md`, `docs/STATE.md`, and `docs/CHANGELOG.md`.
7. **Output Discipline**: First the plan → wait for architect `✅` → code → tests → commit. Do not skip steps.

## Stack Conventions

Before writing code, running commands, or reasoning about project layout, read **[docs/STACK.md](docs/STACK.md)**. It is the single source of truth for this project's concrete technologies, directory structure, setup commands, test tooling, and per-module style guides. When a user question depends on stack specifics (test commands, file locations, migration tool, e2e framework), consult `STACK.md` first.

If a stack convention is missing from `STACK.md`, do not invent it — ask the user, then update `STACK.md` so the answer is durable.

## Library Documentation Lookup

Before writing or reviewing code that uses any external library, framework, SDK, CLI tool, or cloud service, consult up-to-date documentation in this preference order:

1. `Context7` via MCP, if the runtime exposes it
2. For OpenAI products specifically, the official OpenAI developer docs MCP server
3. `ctx7` CLI: `npx ctx7@latest library "<name>"` then `npx ctx7@latest docs /org/project "<question>"`
4. Official library docs / primary-source API references

Rules:

- Use the official library name with correct punctuation (`Next.js`, not `nextjs`).
- Do NOT rely on training-data knowledge alone — library APIs drift between minor versions.
- Skip only for: pure refactoring, business-logic debugging, code review of existing code, or general programming concepts not tied to a specific library.
- Cap at 3 `ctx7` calls per question. If unclear, ask the user rather than guessing.
- Never include secrets (API keys, passwords) in queries.
- If quota or auth fails, suggest `npx ctx7@latest login` or setting `CONTEXT7_API_KEY`.

Stale library knowledge is the #1 source of rework. Treat documentation lookup as required, not optional.

## Repo Memory Files

Keep lightweight long-lived project memory in `docs/` so future sessions recover context without reconstructing it from chat history:

- `docs/DECISIONS.md` — ADR-style technical decisions
- `docs/KNOWN_GOTCHAS.md` — recurring pitfalls, symptoms, and fixes

Consult and update these files as part of normal development. Keep them concise and current.

## Filesystem Permission Failures

On `EACCES`, `EPERM`, "Permission denied", or "Read-only file system" errors: **stop immediately**. Do NOT `sudo`, `chmod -R 777`, delete-and-recreate the file elsewhere, or silently skip the step.

Post the relevant handoff message from `docs/KNOWN_GOTCHAS.md` (if a matching entry exists) with the real `<path>` and `<cmd>`, then wait. On the keyword `continue`, retry the failed operation once. If it fails a second time with the same error, stop again and ask the user to confirm the fix — do not loop a third time. If no matching gotcha entry exists yet, ask the user how to proceed and add the resolution to `KNOWN_GOTCHAS.md` so future sessions handle it without intervention.

## Git Workflow

1. **Branch Rule**: Work only in `feat/phase-N` branches. Never push directly to `main` or `develop`.
   ```bash
   git checkout -b feat/phase-01
   ```
2. **No Destructive Git**: Never use `--force`, `git push --force`, `git rebase` on shared branches, or `git reset --hard` without explicit user instruction.
3. **Conventional Commits**: `type(scope): description`, types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`.
   Example: `feat(phase-01): foundation — auth, db schema, API skeleton`.
4. **Gate Before Commit**: Run the `phase-gate` workflow first. Never commit on ❌ FAIL.
5. **Tagging**: After a phase branch merges to `develop`:
   ```bash
   git tag -a v0.N.0 -m "Phase N: [title]"
   ```

## Spec Change Sync Protocol

When `docs/SPEC.md` is modified:

1. **Run immediately**: the `spec-sync` workflow with a brief description of what changed.
2. It will: add a `docs/CHANGELOG.md` entry, increment `docs/CONTEXT.md` `_meta.version` if DB/API/types changed, mark affected phases as `⚠️ NEEDS_REVIEW` in `docs/STATE.md`, and add warning banners to affected `docs/PHASE_XX.md` files.
3. **Review** all changes before committing.
4. **Do not implement** any phase marked `⚠️ NEEDS_REVIEW` until resolved.

## CONTEXT.md Version Rules

- **Format**: `vMAJOR.MINOR` (e.g. `v1.2`).
- **Patch bump** (`v1.0` → `v1.1`): additive only — new endpoints, models, env vars.
- **Minor bump** (`v1.1` → `v1.2`): breaking — renamed/removed endpoints, schema or type changes.
- **No bump**: docs-only phase, zero contract changes.
- Always update `captured_at` when the version changes.
- `CONTEXT.md` is the Single Source of Truth for AI — never let it fall more than one phase behind.

## Workflow Playbooks

The SDD workflows are defined in `docs/playbooks/`:

- [`workflow-init`](docs/playbooks/workflow-init.md) — integrate the workflow into a project (only relevant when bootstrapping)
- [`spec-init`](docs/playbooks/spec-init.md) — draft or refresh `docs/SPEC.md` from a project brief
- [`phase-init`](docs/playbooks/phase-init.md) — scaffold a new `docs/PHASE_XX.md` + `docs/PHASE_XX_NOTES.md`
- [`phase-gate`](docs/playbooks/phase-gate.md) — validate a phase before commit (stack commands in [docs/STACK.md](docs/STACK.md#gate-commands))
- [`spec-sync`](docs/playbooks/spec-sync.md) — propagate a `docs/SPEC.md` change
- [`context-update`](docs/playbooks/context-update.md) — finalize a completed phase
- [`impl-brief`](docs/playbooks/impl-brief.md) — generate a concrete implementation plan for phase tasks (optional)
- [`impl-assist`](docs/playbooks/impl-assist.md) — implement uncompleted phase tasks (optional)
- [`project-sync`](docs/playbooks/project-sync.md) — sync phase tasks to GitHub Issues + GitHub Projects board (optional; requires `gh` CLI and a GitHub remote)

Different runtimes expose them differently:

- **Claude Code**: slash commands (`/spec-init`, `/phase-init`, `/phase-gate`, `/spec-sync`, `/context-update`, `/impl-brief`, `/impl-assist`, `/project-sync`) defined under `.claude/skills/`.
- **Codex**: slash commands defined under `plugins/sdd-workflow/`.
- **Other runtimes**: follow the markdown procedure in `docs/playbooks/` manually.

The runtime wrappers are thin stubs — all workflow logic lives in `docs/playbooks/`.

## Phase Lifecycle

```
1.  Architect provides project brief
2.  spec-init         → drafts/resets/continues docs/SPEC.md (`--new` or `--continue`)
3.  phase-init N      → creates docs/PHASE_N.md scaffold
4.  Architect fills Contracts + Files sections
5.  Implement scope on feat/phase-N branch:
    - Human developer works against the Scope checklist in PHASE_N.md
    - Optional: `/impl-brief N [task-id|group]`  → generates Implementation Plan in PHASE_N_NOTES.md
    - Optional: `/impl-assist N [task-id|group]` → agent implements uncompleted tasks
6.  phase-gate N      → automated baseline
7.  Architect manual verification → add unchecked items to Architect Review Notes
8.  phase-gate N      → ✅ PASS only when all automated checks green AND review notes all checked off
9.  git commit        → feat(phase-N): [description]
10. context-update N  → updates CONTEXT, STATE, CHANGELOG
11. PR to develop     → human review → merge
12. git tag -a v0.N.0 -m "Phase N: [title]"
13. phase-init N+1    → repeat
```

### Implementation Path Guide

**a. Agent-driven** — let the agent plan and implement:

1. `/impl-brief N` (or `/impl-brief N [ID]` per task) — generates Implementation Plan
2. Review the plans in `docs/PHASE_N_NOTES.md`
3. `/impl-assist N` — agent implements all unchecked tasks and checks them off

**b. Human-driven** — implement everything yourself:

1. Optionally run `/impl-brief N [ID]` to get a reference plan before you start
2. Implement each task against the Scope checklist in `docs/PHASE_N.md`
3. Check off each task (`- [x]`) when done

**c. Hybrid** — split tasks between human and agent:

- For tasks the **agent** implements: `/impl-brief N [ID]` → review → `/impl-assist N [ID]`
- For tasks **you** implement: work against the checklist; check off when done
- Honour `Depends on:` order — a dependency task must be complete before its dependent starts

**File ownership in `docs/PHASE_N_NOTES.md`:**

| Section | Owner | Agent behaviour |
|---------|-------|-----------------|
| `### Implementation Plan` | Agent (impl-brief) | Written once; re-run with `--force` to overwrite |
| `### Decisions & Notes` | Human only | Never read or written by any agent |

`impl-assist` verifies completion by reading actual code — a checked checkbox is a hint, not
proof. Running impl-assist on an already-implemented task is safe; it will skip.

## Document Roles

| File | Role | Change cadence |
|------|------|----------------|
| `docs/SPEC.md` | Strategic brief: goals, roles, domain rules, non-functional reqs | Rarely — architect only |
| `docs/CONTEXT.md` | Living technical contract: DB schema, endpoints, types, env vars | After each phase via `context-update` |
| `docs/STATE.md` | Operational tracker: phase statuses, blockers, feedback | Continuously |
| `docs/CHANGELOG.md` | History of spec/architecture changes | On every SPEC.md or CONTEXT.md change |
| `docs/PHASE_XX.md` | Mini-spec: scope checklist (with task IDs), files, contracts, gate checks | Created per phase via `phase-init` |
| `docs/PHASE_XX_NOTES.md` | Per-task implementation guide: how each task was built, decisions made | During and after implementation |
| `docs/STACK.md` | Stack-specific setup, commands, layout, Gate Commands dispatch | When the stack changes |
| `docs/DECISIONS.md` | ADR log | On each architecturally meaningful decision |
| `docs/KNOWN_GOTCHAS.md` | Recurring pitfall log | When a new trap is discovered |
