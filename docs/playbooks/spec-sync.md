# spec-sync — Canonical Playbook

Propagate `docs/SPEC.md` changes across operational documents and affected phase files.

This document is the single source of truth for the `spec-sync` workflow. Runtime wrappers point here.

## Input

- A brief description of what changed in `docs/SPEC.md`.

## Required reads

- `docs/SPEC.md` (updated)
- `docs/CONTEXT.md` — note `_meta.version`
- `docs/STATE.md` — current phase statuses
- `docs/CHANGELOG.md`
- All `docs/PHASE_*.md` files

If a recent SPEC.md diff is available (`git diff HEAD -- docs/SPEC.md`), inspect it before making decisions.

## Procedure

### 1. Impact analysis

Identify which domains changed:

| Domain | Signal | Affects |
|--------|--------|---------|
| Data model (§3) | table/column added, removed, renamed, retyped | `CONTEXT.md` `core_models` / `db_schema`, phase files touching those tables |
| API endpoints (§4.2) | endpoint added, renamed, removed | `CONTEXT.md` `endpoints_active`, phase files implementing those routes |
| Frontend (§5) | pages/stores/components changed | phase files building those |
| Non-functional reqs (§7) | performance, security, coverage | Gate checks of affected phase files |
| Phase plan (§8) | phase reordered or scope changed | specific phase files and STATE.md ordering |

For each changed domain, list affected phase files with precise reasons. **False-positive rule**: if unsure whether a phase is affected, mark it `⚠️ NEEDS_REVIEW`. A false positive is safer than a missed dependency.

### 2. Determine version bump

- Additive contract change (new tables / endpoints / types / env vars): **patch bump** (`v1.1` → `v1.2`).
- Breaking contract change (renamed, removed, retyped): **minor bump** (`v1.2` → `v2.0`).
- No contract change (docs-only, non-functional only): **no bump** — use current version in the CHANGELOG entry heading.

### 3. Prepend to `docs/CHANGELOG.md`

Immediately after the `# CHANGELOG` heading and its intro lines, before any previous entry:

```markdown
## [new or current CONTEXT version] — [YYYY-MM-DD] — [Short Title]

**Type**: spec-change
**Author**: AI (spec-sync)
**Triggered by**: [what changed in SPEC.md]

### Changes
- [specific section and what changed]

### Affected Phases
- PHASE_XX — [precise reason]
- (or: None — change has no impact on existing phases)

### Contract Updates
- `CONTEXT.md` bumped from `vX.Y` to `vX.Z` (if applicable)
- [renamed endpoints, new tables, etc.]
- (or: No contract change — docs-only)

### Notes
[Any relevant trade-offs, decisions, or context.]
```

### 4. Update `docs/CONTEXT.md` (only if contract changed)

1. Increment `_meta.version` per step 2.
2. Update `captured_at` to today (`YYYY-MM-DD`).
3. Edit only the sections that changed: `core_models`, `endpoints_active`, `db_schema.tables`, `env_config.keys`.
4. Update `notes` with one sentence about the spec change.

If no contract change: leave CONTEXT.md untouched; note "no contract change" in the CHANGELOG entry.

### 5. Mark affected phases in `docs/STATE.md`

For each affected phase:

1. Change its status to `⚠️ NEEDS_REVIEW`.
2. Add an Active Blockers row: `PHASE_XX [YYYY-MM-DD]: needs review after spec change — [brief reason]. Resolve before implementing.`

Do NOT flip `✅ done` phases unless their contracts are *directly* broken (e.g. an endpoint they implemented was renamed).

### 6. Patch affected `docs/PHASE_XX.md` files

For each affected phase:

1. Insert a warning banner immediately after the Phase Metadata table:

   ```markdown
   > ⚠️ **NEEDS_REVIEW** — Spec changed on [YYYY-MM-DD].
   > Check [specific SPEC.md section] against the updated `docs/SPEC.md`.
   > Re-validate the **Contracts** section before implementation.
   ```

2. If the change is clear-cut and unambiguous (e.g. endpoint renamed `/users` → `/api/v1/users`), apply the surgical edit to the Contracts section.

3. Do NOT rewrite phase files. Surgical edits only. Preserve existing content.

### 7. Report

```
## spec-sync complete

CHANGELOG.md: new entry added (v[old] → v[new] / no bump)
CONTEXT.md:   [bumped to vX.Z / unchanged] — [reason]
STATE.md:     phases marked ⚠️ NEEDS_REVIEW — [list / none]
PHASE files patched: [list / none]
Unaffected phases:   [list / none]

Next:
1. Review these changes before committing.
2. Resolve each NEEDS_REVIEW phase (update Contracts, remove ⚠️ banner).
3. Do not implement any NEEDS_REVIEW phase until resolved.
```

## Rules

- Never delete existing CHANGELOG entries.
- Never remove endpoints / models from CONTEXT.md unless SPEC explicitly removes them.
- Never rewrite a phase file from scratch.
- Do not commit.
- If the change description is empty and no diff is available, ask the architect what changed before proceeding.

## Done when

- Impacted docs are synchronized.
- Affected phases are marked for review.
- Unchanged phases remain untouched.
