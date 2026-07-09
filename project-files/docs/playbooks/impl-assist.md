# impl-assist — Canonical Playbook

Implement one or more uncompleted items from a phase through a deterministic agent-only cycle:
read the phase contract, explore the codebase, implement, verify, and update the phase file only
after the code satisfies the item's contract. An "item" is either a **Scope task** (`B1`, `F2`,
…) or an **Architect Review Note** (`R1`, `R2`, …) — both go through the same loop, just with a
different source location and a different checkbox to flip.

This document is the single source of truth for the `impl-assist` workflow.

In an integrated project, runtime wrappers under `.claude/skills/impl-assist/SKILL.md` (Claude
Code) and `plugins/sdd-workflow/{commands,skills}/impl-assist/...` (Codex) point here. The wrappers
are thin stubs — every workflow detail lives in this file.

## Input

```text
/impl-assist [XX]                 — full phase (all unchecked Scope tasks)
/impl-assist [XX] [ID]            — single Scope task, e.g. B3
/impl-assist [XX] [group]         — Scope group, e.g. backend | frontend | infra | data
/impl-assist [XX] review          — all unchecked Architect Review Notes
/impl-assist [XX] R[N]            — one Architect Review Note by generated ID, e.g. R2
/impl-assist [XX] ... --force     — revisit even if checked/resolved
```

- `XX` — zero-padded phase number
- `ID` — Scope task identifier, e.g. `B3`, `F1`
- Group names resolve by prefix: `backend` -> `B*`, `frontend` -> `F*`, `infra` -> `I*`,
  `data` -> `D*`, `other` -> `T*`
- `review` — targets all unchecked items in § Architect Review Notes instead of § Scope
- `R[N]` — targets one Architect Review Note by ordinal, counted top to bottom after ignoring the
  default `No architect review issues recorded` line
- `--force` — include checked/resolved items and re-verify/rework them if needed

## Required reads

- `docs/PHASE_XX.md` — Scope checklist, Architect Review Notes, contracts, files, dependencies,
  gate notes, existing Implementation Notes
- `docs/STATE.md` § Current Contract — current technical contract
- `docs/STACK.md` — stack conventions, command rules, file layout, gate commands
- `docs/KNOWN_GOTCHAS.md` — project pitfalls
- Relevant source files and git history — verify current implementation before editing; recent
  commits and diffs are the record of *how* prior work was done, so read them instead of expecting
  a separate execution-memory file

## Procedure

### 1. Validate input and resolve the target source

- If no phase number, ask: "Which phase? e.g. /impl-assist 01 or /impl-assist 01 B3"
- Normalize the phase number to two digits.
- If `docs/PHASE_XX.md` does not exist, stop and report the missing file.
- Resolve the item source:
  - Argument is `review` or `R[N]` (or absent but explicitly targeting review) → source is
    § Architect Review Notes. Ignore the default checked line. Assign stable in-run IDs by
    checkbox order: `R1`, `R2`, …. Default target set: unchecked notes only; a specific `R[N]`
    narrows to one.
  - Otherwise → source is § Scope. Resolve the target task list from the optional ID/group
    argument. Default to all unchecked tasks.
- `--force` widens the default target set to include checked/resolved items.
- If there are no target items in the resolved source, report that and stop.

### 2. Dependency check (Scope tasks only)

For each target Scope task, read its `Depends on:` field from `docs/PHASE_XX.md`.

- If a dependency task is unchecked and not part of the current target list, skip the dependent
  task and report it as blocked.
- Do not silently add dependency tasks to the queue. The implementation scope must stay explicit.
- Implement target tasks in dependency order when dependencies are included in the same run.

Architect Review Notes have no dependency field — skip this step for review-note targets.

### 3. Safety check

For each target item, decide whether it requires changing any of:

- `docs/SPEC.md` behavior
- persistent data schema beyond the phase contract
- public API request/response contract beyond the phase contract
- auth, authorization, secrets, or security behavior
- cross-phase architecture assumptions

If yes, stop before implementation and report:

```text
Needs architect confirmation before implementation:
[ID] — [task or note text]
Reason: [schema/API/security/spec-level contract impact]
```

Do not run `spec-sync`, `context-update`, or `phase-gate` automatically from this workflow.

### 4. Explore

Before planning code changes for an item:

1. Read the item's contract: for a Scope task, the scope line, dependencies, files, and relevant
   Contracts subsections; for a Review Note, the note text and the phase's original Scope/Contracts
   context it relates to.
2. Inspect the relevant source files, tests, and recent git history for that area.
3. Decide the current state:
   - `implemented` — contract/fix is already satisfied in code; skip unless `--force`.
   - `partial` — some implementation exists but misses contract details.
   - `not-started` — required code/tests are absent (Scope tasks only).
   - `blocked` — cannot proceed without clarification or missing dependency.
   - For Review Notes specifically: if the issue cannot be verified or needs a product/architecture
     decision, set the verdict to `needs-clarification: [specific question]` and do not plan or
     implement that note.

### 5. Plan

For each item that is `partial`, `not-started`, or a verified Review Note, write a short plan
before editing code:

- **Done when:** concrete completion condition
- **Files:** exact paths expected to change
- **Steps:** short ordered implementation steps
- **Checks:** focused commands/tests to run

The plan must stay inside the active phase contract (for Scope tasks) or narrowly inside the
targeted note (for Review Notes) — do not use a review-note fix to broaden scope.

### 6. Implement

For each planned item:

- Apply the smallest complete implementation that satisfies the contract or resolves the note.
- Match existing project conventions and patterns observed during exploration.
- Add or update focused tests when behavior is testable at reasonable cost.
- If a non-obvious pitfall is discovered, update `docs/KNOWN_GOTCHAS.md`.
- If — and only if — something isn't already visible from the code or commit history (an
  intentional deviation from the plan, a residual risk, a rejected alternative), add one short
  bullet to `docs/PHASE_XX.md` § Implementation Notes. Do not write routine implementation
  narration there; the diff and the commit message already cover "what changed."

### 7. Verify and mark complete

After implementing each item:

1. Re-read the changed files and confirm the contract/note is satisfied.
2. Run the focused checks listed in the plan when available.
3. Report the commands run and their results; if a check was not run, state the reason.
4. Mark the item:
   - Scope task → check off the matching item in `docs/PHASE_XX.md` § Scope.
   - Review Note → check off the matching item in `docs/PHASE_XX.md` § Architect Review Notes.

Only check off an item after verification succeeds, the fix is re-verified, or the task is
explicitly already implemented.

Do not run the full phase gate. That is `/phase-gate`.

### 8. Report

```text
## impl-assist complete

Phase: PHASE_[XX]
Source: scope | review
Scope: [resolved item list]

Done:
  [ID] — [task/note name]: checked off in docs/PHASE_[XX].md

Skipped:
  [ID] — already implemented / already resolved

Blocked:
  [ID] — [reason]

Needs clarification:
  [ID] — [question]

Checks:
  [command] — PASS
  [command] — not run ([reason])

Next: manually verify the product, add any findings to Architect Review Notes, then run
`/impl-assist [XX] review` or `/phase-gate [XX]`.
```

## Rules

- Treat `docs/PHASE_XX.md` as the source of truth for what to build and what to fix.
- Verify by reading actual code and recent git history. A checked checkbox is a hint, not proof.
- Do not wait for human approval after writing a plan unless the safety check triggers or the
  phase explicitly requires confirmation.
- Do not broaden scope beyond the active phase contract or the targeted review note.
- Do not run `/phase-gate`, `/context-update`, or `/spec-sync`.
- Do not commit automatically.
- Do not classify a Review Note as a new task, bug, chore, or scope item.
- Follow all rules in `AGENTS.md` and stack-specific rules in `docs/STACK.md`.

## Done when

- Every targeted item is implemented/fixed, skipped as already done, or reported as blocked/needs
  clarification.
- Done Scope tasks have their checkboxes checked in `docs/PHASE_XX.md` § Scope.
- Fixed Review Notes have their checkboxes checked in `docs/PHASE_XX.md` § Architect Review Notes.
- `docs/PHASE_XX.md` § Implementation Notes records any genuinely non-obvious deviation or risk —
  and nothing else.
- The final report lists checks run and remaining manual next steps.
