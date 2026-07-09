# context-update — Canonical Playbook

Synchronize `docs/STATE.md` (Current Contract, Phase Status, Project Log) with the reality of what was built in a completed phase.

This document is the single source of truth for the `context-update` workflow. Runtime wrappers point here.

## Input

- Target phase number (e.g. `01`).

## Required reads

- `docs/PHASE_XX.md` — focus on the **Contracts** section
- `docs/STATE.md` — current Phase Status, Current Contract, and Project Log

## Procedure

### 1. Confirm the phase is ready

Check `docs/STATE.md` § Phase Status:

- `⏳ pending` → warn: "Phase XX has not started yet. Are you sure gate checks passed?" and wait.
- `✅ done` → warn: "Phase XX is already marked done. Re-running will overwrite — confirm?" and wait.
- `🔄 in-progress` or gate just passed → proceed.

### 2. Extract contracts from `docs/PHASE_XX.md`

From the **Contracts** section, extract:

- New DB tables / columns
- New API endpoints
- New TypeScript types / Pinia stores
- New env vars (key names only)

If every Contracts subsection is `None`: no version bump needed. Skip to step 4 (Phase Status update).

### 3. Update `docs/STATE.md` § Current Contract and § Project Log

If contracts changed:

1. In § Current Contract: set `Phase completed` to the phase number (e.g. `"01"`) and `Phase in
   progress` to the next phase number or `—`.
2. **Append** to `Core Models` — do NOT remove existing.
3. **Append** to `Active Endpoints` — do NOT remove existing.
4. **Append** to `DB Schema` tables; update the current migration head (if backend-bearing).
5. **Append** to `Env Config`.
6. Prepend a Project Log entry above the previous newest entry:

   ```markdown
   ## [YYYY-MM-DD] — Phase [XX] complete

   **Type**: phase-completion
   **Author**: AI (context-update)
   **Triggered by**: PHASE_[XX] gate passed and committed

   ### Changes / Decision
   - [what was built / added]

   ### Affected Phases / Consequences
   - None (additive change)
   ```

If no contracts changed: skip both edits — do not log a no-op phase completion.

### 4. Update `docs/STATE.md` § Phase Status

1. Change the `PHASE_[XX]` row status to `✅ done`.
2. Change its Gate column from `⬜` to `✅`.

### 5. Report

```
## context-update complete — PHASE_[XX]

STATE.md: Current Contract appended / no change — [reason]
STATE.md: PHASE_[XX] marked ✅ done
STATE.md: Project Log entry added / no entry needed

Next: /phase-init [XX+1] to scaffold the next phase.
```

## Rules

- Never remove existing entries from § Current Contract — append only.
- If the Contracts section is incomplete, stop and ask the architect to fill it in.
- Do not commit.

## Done when

- `docs/STATE.md` § Current Contract matches what was built.
- `docs/STATE.md` § Phase Status marks the phase done.
- `docs/STATE.md` § Project Log reflects the completion (if contracts changed).
