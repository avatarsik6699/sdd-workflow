# Rules of operation of the AI agent during [PROJECT_NAME] development

These rules are stack-agnostic. They are the contract any AI agent (Claude Code, Codex, others)
must follow when working on this project. Stack-specific commands, file layout, and tooling live in
[`docs/STACK.md`](docs/STACK.md).

## Core Rules

1. **Scope Lock**: Do only what is specified in the active `docs/PHASE_XX.md`. Do not assume future
   phases.
2. **Agent-Only Implementation**: Code changes happen through `/impl-assist` or
   `/impl-review-notes`. Humans define intent, scope, and review notes; agents implement.
3. **No Guessing**: If a requirement is genuinely ambiguous and risky, ask a concise question
   instead of inventing behavior.
4. **Gates First**: Before a phase closes, run `/phase-gate`. Automated green is not enough if
   `Architect Review Notes` has unchecked items.
5. **Security**: No hardcoded secrets. Use `.env`, environment variables, and typed settings
   appropriate to the stack.
6. **Context Sync**: After a phase completes, run `/context-update` to refresh `docs/CONTEXT.md`,
   `docs/STATE.md`, and `docs/CHANGELOG.md`.

## Stack Conventions

Before writing code, running commands, or reasoning about project layout, read
[`docs/STACK.md`](docs/STACK.md). It is the source of truth for concrete technologies, setup
commands, test tooling, and per-module style guides.

If a stack convention is missing from `STACK.md`, do not invent it. Ask the user, then update
`STACK.md` so the answer is durable.

## Library Documentation Lookup

Before writing or reviewing code that uses any external library, framework, SDK, CLI tool, or cloud
service, consult up-to-date documentation in this preference order:

1. `Context7` via MCP, if the runtime exposes it
2. For OpenAI products specifically, the official OpenAI developer docs MCP server
3. `ctx7` CLI: `npx ctx7@latest library "<name>"` then
   `npx ctx7@latest docs /org/project "<question>"`
4. Official library docs / primary-source API references

Rules:

- Use the official library name with correct punctuation (`Next.js`, not `nextjs`).
- Do not rely on training-data knowledge alone.
- Skip only for pure refactoring, business-logic debugging, code review of existing code, or
  general programming concepts not tied to a specific library.
- Cap at 3 `ctx7` calls per question. If unclear, ask rather than guessing.
- Never include secrets in documentation queries.

## Repo Memory Files

Keep lightweight long-lived project memory in `docs/`:

- `docs/DECISIONS.md` — ADR-style technical decisions
- `docs/KNOWN_GOTCHAS.md` — recurring pitfalls, symptoms, and fixes

Consult and update these files as part of normal development.

## Filesystem Permission Failures

On `EACCES`, `EPERM`, "Permission denied", or "Read-only file system" errors: stop immediately.
Do not `sudo`, `chmod -R 777`, delete-and-recreate elsewhere, or silently skip the step.

Post the relevant handoff message from `docs/KNOWN_GOTCHAS.md` if one exists, then wait. On the
keyword `continue`, retry once. If the same error repeats, stop and ask the user to confirm the
fix. If no gotcha entry exists, ask how to proceed and add the resolution to `KNOWN_GOTCHAS.md`.

## Git Workflow

1. Work on `feat/phase-N` branches unless the user explicitly directs otherwise.
2. Never use destructive git commands or force-push without explicit instruction.
3. Use conventional commits: `feat|fix|chore|docs|test|refactor(scope): description`.
4. Run `/phase-gate` before committing phase work. Do not commit on gate failure.
5. After a phase branch merges, tag the phase if the project uses phase tags.

## Spec Change Sync Protocol

When `docs/SPEC.md` changes:

1. Run `/spec-sync` immediately with a brief description.
2. Review the generated changes before continuing implementation.
3. Do not implement any phase marked `NEEDS_REVIEW` until resolved.

## Workflow Playbooks

The SDD workflows are defined in `docs/playbooks/`:

- [`spec-init`](docs/playbooks/spec-init.md) — draft or refresh `docs/SPEC.md`
- [`spec-sync`](docs/playbooks/spec-sync.md) — propagate an approved spec change
- [`phase-init`](docs/playbooks/phase-init.md) — scaffold `docs/PHASE_XX.md` and
  `docs/PHASE_XX_NOTES.md`
- [`impl-assist`](docs/playbooks/impl-assist.md) — implement scoped phase tasks through the agent
  execution loop
- [`impl-review-notes`](docs/playbooks/impl-review-notes.md) — fix unchecked Architect Review Notes
- [`phase-gate`](docs/playbooks/phase-gate.md) — validate a phase before closing it
- [`context-update`](docs/playbooks/context-update.md) — finalize completed phase memory

Runtime wrappers are thin stubs. Workflow logic belongs in the playbooks.

## Phase Lifecycle

```text
1.  Architect provides or updates project intent
2.  /spec-init                  -> draft or refresh docs/SPEC.md
3.  Architect approves SPEC.md
4.  /phase-init N               -> create docs/PHASE_N.md + docs/PHASE_N_NOTES.md
5.  /impl-assist N              -> agent implements all scoped tasks
6.  Architect manually verifies product behavior
7.  Architect adds unchecked items to Architect Review Notes if fixes are needed
8.  /impl-review-notes N        -> agent fixes review notes
9.  Repeat 6-8 until manual verification is clean
10. /phase-gate N               -> automated checks + unresolved review-note check
11. /context-update N           -> update CONTEXT, STATE, CHANGELOG
12. Commit / PR / tag according to project git policy
```

## Agent Execution Memory

`docs/PHASE_XX_NOTES.md` is agent-owned execution memory. Humans are not expected to read or edit
it. The agent must keep it current during `/impl-assist` and `/impl-review-notes`:

- `Contract Snapshot` — the relevant task contract from `PHASE_XX.md`
- `Exploration` — files inspected, existing patterns, constraints, risks
- `Plan` — done-when, files, steps, checks before editing
- `Implementation Log` — actual changes and deviations
- `Verification` — commands/checks run and results
- `Residual Risks` — known remaining risks or `None`

## Document Roles

| File | Role | Change cadence |
|------|------|----------------|
| `docs/SPEC.md` | Strategic product and system intent | Rarely; architect-approved |
| `docs/PHASE_XX.md` | Human-facing phase contract: scope, files, contracts, gate checks, review notes | Per phase |
| `docs/PHASE_XX_NOTES.md` | Agent-owned execution memory | During agent implementation |
| `docs/STACK.md` | Stack-specific commands, layout, and conventions | When tooling changes |
| `docs/CONTEXT.md` | Technical contract after completed phases | After `/context-update` |
| `docs/STATE.md` | Operational phase tracker | During phase lifecycle |
| `docs/CHANGELOG.md` | Contract/spec history | On spec or context changes |
| `docs/DECISIONS.md` | ADR log | On architectural decisions |
| `docs/KNOWN_GOTCHAS.md` | Recurring pitfall log | When new traps are discovered |
