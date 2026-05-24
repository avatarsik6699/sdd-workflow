# impl-review-notes — Canonical Playbook

Fix unchecked items from `docs/PHASE_XX.md` § `Architect Review Notes` using the same deterministic
agent execution discipline as normal phase tasks. This workflow is for post-implementation manual
verification findings, not for broadening phase scope.

This document is the single source of truth for the `impl-review-notes` workflow.

In an integrated project, runtime wrappers under `.claude/skills/impl-review-notes/SKILL.md`
(Claude Code) and `plugins/sdd-workflow/{commands,skills}/impl-review-notes/...` (Codex) point
here. The wrappers are thin stubs — every workflow detail lives in this file.

## Input

```text
/impl-review-notes [XX]              — all unchecked review notes
/impl-review-notes [XX] [N]          — one review note by ordinal, e.g. 2
/impl-review-notes [XX] R[N]         — one review note by generated ID, e.g. R2
/impl-review-notes [XX] --force      — revisit checked notes too
```

- `XX` — zero-padded phase number
- `N` / `R[N]` — ordinal of a checkbox item in `Architect Review Notes`, counted top to bottom
  after ignoring the default `No architect review issues recorded` line
- `--force` — include checked notes; do not uncheck or rewrite them unless a real fix is applied

## Required reads

- `docs/PHASE_XX.md` — Architect Review Notes, scope, files, contracts, gate notes
- `docs/PHASE_XX_NOTES.md` — existing task memory and `Review Notes Fixes`
- `docs/CONTEXT.md` — current technical contract
- `docs/STACK.md` — stack conventions, command rules, file layout
- `docs/KNOWN_GOTCHAS.md` — project pitfalls
- Relevant source files — verify the reported issue and the implemented fix

## Procedure

### 1. Validate input

- If no phase number, ask: "Which phase? e.g. /impl-review-notes 01"
- Normalize the phase number to two digits.
- If `docs/PHASE_XX.md` does not exist, stop and report the missing file.
- If `docs/PHASE_XX_NOTES.md` does not exist, create it from `docs/PHASE_NOTES_TEMPLATE.md`
  before writing review-note metadata.

### 2. Resolve review notes

Read `docs/PHASE_XX.md` § `Architect Review Notes`.

- Ignore the default checked line: `No architect review issues recorded`.
- Assign stable in-run IDs by checkbox order: `R1`, `R2`, `R3`, ...
- Default target set: unchecked notes only.
- If a specific `N` / `R[N]` is supplied, target only that note.
- If `--force` is supplied, checked notes may be targeted too.
- If there are no target notes, report that no open architect review notes were found.

### 3. Safety check

For each target note, decide whether the requested fix appears to change any of:

- `docs/SPEC.md` behavior
- persistent data schema
- API request/response contract
- auth, authorization, secrets, or security behavior
- cross-phase architectural assumptions

If yes, stop before implementation and report:

```text
Needs architect confirmation before implementation:
R[N] — [note text]
Reason: [schema/API/security/spec-level contract impact]
```

Do not run `spec-sync`, `context-update`, `phase-gate`, migrations, or API generation
automatically. The architect decides those steps manually.

### 4. Prepare metadata section

Ensure `docs/PHASE_XX_NOTES.md` contains a top-level section:

```markdown
---

## Review Notes Fixes
```

For each targeted note, ensure a block exists:

```markdown
### R1 — short note title

**Status:** open
**Source:** `docs/PHASE_XX.md` § Architect Review Notes

#### Source Note

#### Safety Check

#### Exploration

#### Plan

#### Implementation Log

#### Verification

#### Residual Risks
```

Use surgical edits. Preserve existing task execution memory.

### 5. Explore

For each target note:

- Reproduce or verify the issue by reading relevant code and, when cheap and appropriate, running
  the smallest focused check.
- Identify source files likely to be edited.
- Record concise findings in `#### Exploration`:

```markdown
_Explored:_ YYYY-MM-DD · _Verdict:_ ready

**Relevant code:**
- `path/to/file.ext:LNN` — why it matters

**Observed issue:**
- specific bug or mismatch found

**Risk areas:**
- test gap, fragile path, or `None`
```

If the issue cannot be verified or needs a product/architecture decision, set the verdict to
`needs-clarification: [specific question]`, report it, and do not plan or implement that note.

### 6. Plan

For each note with `ready` verdict, write `#### Plan` before editing code:

- **Done when:** concrete condition that proves the note is fixed
- **Files:** exact paths to modify
- **Steps:** short ordered implementation steps
- **Checks:** focused checks or tests to run, if any

Do not use this workflow to broaden scope beyond the review note.

### 7. Implement

For each planned note:

- Apply the smallest code/docs/test change that resolves the review note.
- Follow existing project conventions and the relevant normal task memory when the fix belongs to
  a previously implemented Scope task.
- Add or update focused tests when the issue is behavioral and testable at reasonable cost.
- If a non-obvious pitfall is discovered, update `docs/KNOWN_GOTCHAS.md`.
- Record `#### Implementation Log`, `#### Verification`, and `#### Residual Risks`.

Do not commit automatically. Do not create or switch branches automatically.

### 8. Mark note resolved

After implementing and verifying a note:

- Change its checkbox in `docs/PHASE_XX.md` from `- [ ]` to `- [x]`.
- Update the matching `Review Notes Fixes` block status from `open` to `fixed`.

Only check off a note after the fix exists and focused verification has passed or has been
explicitly documented as not run with a reason.

### 9. Report

```text
## impl-review-notes complete

Phase: PHASE_[XX]
Scope: [R1, R3]

Fixed:
  R1 — [note title]: checked off in docs/PHASE_[XX].md

Skipped:
  R2 — already checked / no target selected

Needs clarification:
  R3 — [question]

Checks:
  [command] — PASS
  [command] — not run ([reason])

Next: run `/phase-gate [XX]` when manual verification is complete.
```

## Rules

- Source of truth for review fixes is `Architect Review Notes` in `docs/PHASE_XX.md`.
- Do not classify the note as a new task, bug, chore, or scope item.
- Do not run `phase-gate`, `spec-sync`, or `context-update` automatically.
- Do not commit automatically.
- Keep fixes narrow to the targeted review note.
- Stop for architect confirmation before changing schema/API/security/spec-level behavior.

## Done when

- Each targeted note is fixed, skipped, or reported as needing clarification.
- Fixed notes are checked off in `docs/PHASE_XX.md`.
- `docs/PHASE_XX_NOTES.md` records source note, safety check, exploration, plan, implementation
  log, verification, and residual risks for every targeted review note.
- The final report lists checks run and any manual next steps.
