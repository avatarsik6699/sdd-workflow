# Rules of operation of the AI agent during [PROJECT_NAME] development

This workflow is specialized for **web applications** (frontend + backend + database) — it is not
a general-purpose SDD framework. These rules are the contract any AI agent (Claude Code, Codex,
others) must follow when working on this project. Stack-specific commands, file layout, and
tooling live in [`docs/STACK.md`](docs/STACK.md).

## Core Rules

1. **Backlog Lock**: Do only what is specified in the active `docs/changes/*.md`'s Backlog, plus
   whatever the architect reports mid-session (see Rule 6). Do not assume future changes.
2. **Agent-Only Implementation**: Code changes happen through `/work` (Backlog tasks by default, or
   Architect Review Notes via `/work [XX] review`). Humans define intent, scope, and review notes;
   agents implement.
3. **No Guessing**: If a requirement is genuinely ambiguous and risky, ask a concise question
   instead of inventing behavior.
4. **Gates First**: `/work` runs the Fast Gate after every item; `/ship` runs the Full Gate before
   merging. Automated green is not enough if `Architect Review Notes` has unchecked items.
5. **Security**: No hardcoded secrets. Use `.env`, environment variables, and typed settings
   appropriate to the stack. `/ship`'s Full Gate includes a secrets scan and dependency audit —
   don't treat those as optional.
6. **Open Backlog**: When the architect reports a finding, bug, or follow-up in chat mid-session,
   append it to the active change's Backlog with a new ID before acting on it — never fix it
   off-list. See `docs/playbooks/work.md` § Backlog append.
7. **Required Tooling**: Domain-mandated tools (Playwright/chrome-devtools MCP for frontend UI,
   LSP for TypeScript/Python, design skills for design decisions) are not optional judgment calls —
   see `docs/STACK.md` § Required Tooling and use them before checking an item off.

## Stack Conventions

Before writing code, running commands, or reasoning about project layout, read
[`docs/STACK.md`](docs/STACK.md). It is the source of truth for concrete technologies, setup
commands, gate commands (Fast/Full/Release), required tooling, and per-module style guides.

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

- `docs/SPEC.md`'s own git history — the record of spec-level decisions (there is no separate
  decision log file; diff `docs/SPEC.md` to see what changed and when).
- Each `docs/changes/*.md` (and, once shipped, `docs/changes/archive/*.md`) § Implementation Notes
  — non-obvious deviations for that unit of work.
- `docs/KNOWN_GOTCHAS.md` — recurring pitfalls, symptoms, and fixes.

There is no separate contract-mirror file to keep in sync. The codebase is the source of truth for
what currently exists; `docs/changes/archive/` is the source of truth for what's already shipped.

## Filesystem Permission Failures

On `EACCES`, `EPERM`, "Permission denied", or "Read-only file system" errors: stop immediately.
Do not `sudo`, `chmod -R 777`, delete-and-recreate elsewhere, or silently skip the step.

Post the relevant handoff message from `docs/KNOWN_GOTCHAS.md` if one exists, then wait. On the
keyword `continue`, retry once. If the same error repeats, stop and ask the user to confirm the
fix. If no gotcha entry exists, ask how to proceed and add the resolution to `KNOWN_GOTCHAS.md`.

## Git Workflow

1. `/plan` creates and switches to `feature/NN-slug` for the change it scaffolds. `/work` checks
   the current branch first and switches (creating if needed) before doing anything else — the
   architect should not need to say "switch to the feature branch" in chat.
2. Never use destructive git commands or force-push without explicit instruction.
3. Use conventional commits: `feat|fix|chore|docs|test|refactor(scope): description`.
4. `/ship` runs the Full Gate, and on PASS commits outstanding work, merges `feature/NN-slug` into
   local `main`, and archives the change file. Do not merge or push outside of `/ship`.
5. `/ship --release` additionally pushes `main` to `origin/main` and verifies the resulting
   deploy via `gh` — only after the Full Gate (and Release Gate) pass. Do not push to `origin/main`
   any other way without explicit instruction.

## Workflow Playbooks

The SDD workflows are defined in `docs/playbooks/`:

- [`plan`](docs/playbooks/plan.md) — draft/refresh `docs/SPEC.md` and scaffold a new
  `docs/changes/NN-slug.md` with its feature branch
- [`work`](docs/playbooks/work.md) — implement Backlog tasks (default) or fix Architect Review
  Notes (`/work [XX] review`) through the agent execution loop, absorbing mid-session findings and
  running the Fast Gate
- [`ship`](docs/playbooks/ship.md) — run the Full Gate, merge to `main`, archive the change, and
  (with `--release`) push and verify the deploy

Runtime wrappers are thin stubs. Workflow logic belongs in the playbooks.

## Change Lifecycle

```text
1. Architect provides a brief (chat text or a draft file, e.g. docs/DRAFT_SPEC.md)
2. /plan ["brief" | path/to/draft.md]  -> draft/refresh docs/SPEC.md, scaffold
                                          docs/changes/NN-slug.md, create feature/NN-slug
3. Architect approves docs/SPEC.md (first time / on pivots only)
4. /work NN                            -> agent implements Backlog items, absorbing any
                                          findings the architect reports mid-session
5. Architect manually verifies product behavior
6. Architect adds unchecked items to Architect Review Notes if fixes are needed
7. /work NN review                     -> agent fixes review notes; repeat 5-7 until clean
8. /ship NN                            -> Full Gate; on PASS: merge to main, archive the change
9. /ship NN --release                  -> Release Gate; push origin/main; verify deploy via gh
```

## Implementation Notes

`docs/changes/NN-slug.md` § Implementation Notes is a short, optional, agent-maintained bullet
list — not a mandatory execution log. The agent adds an entry only when something isn't already
visible from the code or commit history: an intentional deviation from the plan, a residual risk,
a rejected alternative. Git history and the diff are the record of *how* work was done; this
section exists only for what git can't tell you.

## Document Roles

| File | Role | Change cadence |
|------|------|----------------|
| `docs/SPEC.md` | Strategic product and system intent | Rarely; architect-approved |
| `docs/changes/NN-slug.md` | Active unit of work: Backlog, files, gate overrides, review notes, implementation notes | Continuously while active |
| `docs/changes/archive/NN-slug.md` | Completed unit of work, kept as history | Written once, by `/ship` |
| `docs/STACK.md` | Stack-specific commands, Fast/Full/Release gate tables, required tooling | When tooling changes |
| `docs/KNOWN_GOTCHAS.md` | Recurring pitfall log | When new traps are discovered |
