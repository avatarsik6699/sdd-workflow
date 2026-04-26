# context-update — Canonical Playbook

Synchronize `docs/CONTEXT.md`, `docs/STATE.md`, and `docs/CHANGELOG.md` with the reality of what was built in a completed phase.

This document is the single source of truth for the `context-update` workflow. Runtime wrappers point here.

## Input

- Target phase number (e.g. `01`).

## Required reads

- `docs/PHASE_XX.md` — focus on the **Contracts** section
- `docs/CONTEXT.md` — note `_meta.version`
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

### 3. Determine version bump

- **No bump**: all subsections `None` (docs-only phase).
- **Patch** (`v1.0` → `v1.1`): additive only — new tables, endpoints, types, or env vars; nothing removed or renamed.
- **Minor** (`v1.1` → `v1.2`): breaking — renamed endpoints, removed fields, changed request/response shape, column type changes.

State which bump applies and why before editing.

### 4. Update `docs/CONTEXT.md`

Surgical edits:

1. Increment `_meta.version` (if bump).
2. Update `captured_at` to today (`YYYY-MM-DD`).
3. Set `phase_completed` to the phase number (e.g. `"01"`).
4. Set `phase_in_progress` to next phase number or `null`.
5. **Append** to `core_models` — do NOT remove existing.
6. **Append** to `endpoints_active` — do NOT remove existing.
7. **Append** to `db_schema.tables`.
8. Update `db_schema.current_head` to the latest alembic revision name (if backend-bearing).
9. **Append** to `env_config.keys`.
10. Update `notes`: one sentence, "Phase XX complete. [What was added]."

### 5. Prepend to `docs/CHANGELOG.md` (only if version bumped)

```markdown
## [new version] — [YYYY-MM-DD] — Phase [XX] complete

**Type**: phase-completion
**Author**: AI (context-update)
**Triggered by**: PHASE_[XX] gate passed and committed

### Changes
- [what was built / added]

### Affected Phases
- None (additive change)

### Contract Updates
- `CONTEXT.md` bumped from `vX.Y` to `vX.Z`
- [new tables, endpoints, env vars]

### Notes
[Notable decisions made during this phase.]
```

If no version bump: no CHANGELOG entry.

### 6. Update `docs/STATE.md`

1. Change the `PHASE_[XX]` row status to `✅ done`.
2. Change its Gate column from `⬜` to `✅`.
3. Add a Change Log row: `| [YYYY-MM-DD] | PHASE_[XX] completed — CONTEXT.md bumped to vX.Z |` (or `— no bump` if applicable).

### 7. Report

```
## context-update complete — PHASE_[XX]

CONTEXT.md:  bumped vX.Y → vX.Z / no bump — [reason]
STATE.md:    PHASE_[XX] marked ✅ done
CHANGELOG.md: entry added / no entry needed

Next: /phase-init [XX+1] to scaffold the next phase.
```

## Rules

- Never remove existing entries from CONTEXT.md arrays — append only.
- If the Contracts section is incomplete, stop and ask the architect to fill it in.
- Do not commit.
- `_meta.version` in CONTEXT.md is the source of truth; CHANGELOG entries derive from it.

## Done when

- `CONTEXT.md` matches what was built.
- `STATE.md` marks the phase done.
- `CHANGELOG.md` reflects the bump (if any).
