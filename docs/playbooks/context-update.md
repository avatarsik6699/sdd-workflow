# context-update — Canonical Playbook

Synchronize `docs/CONTEXT.md`, `docs/STATE.md`, and `docs/CHANGELOG.md` with the reality of what was built in a completed phase.

This document is the single source of truth for the `context-update` workflow. Runtime wrappers point here.

## Input

- Target phase number (e.g. `01`).

## Required reads

- `docs/PHASE_XX.md` — focus on the **Contracts** section
- `docs/CONTEXT.md` — current contracts (models, endpoints, schema, env vars)
- `docs/STATE.md` — current phase statuses
- `docs/CHANGELOG.md`

## Procedure

### 1. Confirm the phase is ready

Check `docs/STATE.md`:

- `⏳ pending` → warn: "Phase XX has not started yet. Are you sure gate checks passed?" and wait.
- `✅ done` → warn: "Phase XX is already marked done. Re-running will overwrite — confirm?" and wait.
- `🔄 in-progress` or gate just passed → proceed.

### 2. Extract contracts from `docs/PHASE_XX.md`

From the **Contracts** section, extract:

- New DB tables / columns
- New API endpoints
- New TypeScript types / Pinia stores
- New env vars (key names only)

If every Contracts subsection is `None`: no version bump needed. Skip to step 6 (STATE.md update).

### 3. Determine if contracts changed

- If every Contracts subsection is `None`: no contracts changed → skip steps 4 and 5; go directly
  to step 6 (STATE.md update).
- Otherwise: contracts changed → proceed with steps 4 and 5.

### 4. Update `docs/CONTEXT.md`

Surgical edits:

1. Set `phase_completed` to the phase number (e.g. `"01"`).
2. Set `phase_in_progress` to next phase number or `null`.
3. **Append** to `core_models` — do NOT remove existing.
4. **Append** to `endpoints_active` — do NOT remove existing.
5. **Append** to `db_schema.tables`.
6. Update `db_schema.current_head` to the latest alembic revision name (if backend-bearing).
7. **Append** to `env_config.keys`.
8. Update `notes`: one sentence, "Phase XX complete. [What was added]."

### 5. Prepend to `docs/CHANGELOG.md` (only if contracts changed)

```markdown
## [YYYY-MM-DD] — Phase [XX] complete

**Type**: phase-completion
**Author**: AI (context-update)
**Triggered by**: PHASE_[XX] gate passed and committed

### Changes
- [what was built / added]

### Affected Phases
- None (additive change)

### Contract Updates
- [new tables, endpoints, env vars]

### Notes
[Notable decisions made during this phase.]
```

If no contracts changed: no CHANGELOG entry.

### 6. Update `docs/STATE.md`

1. Change the `PHASE_[XX]` row status to `✅ done`.
2. Change its Gate column from `⬜` to `✅`.

### 7. Report

```
## context-update complete — PHASE_[XX]

CONTEXT.md:  contracts appended / no change — [reason]
STATE.md:    PHASE_[XX] marked ✅ done
CHANGELOG.md: entry added / no entry needed

Next: /phase-init [XX+1] to scaffold the next phase.
```

## Rules

- Never remove existing entries from CONTEXT.md arrays — append only.
- If the Contracts section is incomplete, stop and ask the architect to fill it in.
- Do not commit.

## Done when

- `CONTEXT.md` matches what was built.
- `STATE.md` marks the phase done.
- `CHANGELOG.md` reflects the bump (if any).
