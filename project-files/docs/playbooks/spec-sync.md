# spec-sync — Canonical Playbook

Propagate `docs/SPEC.md` changes across operational documents and affected phase files.

This document is the single source of truth for the `spec-sync` workflow. Runtime wrappers point here.

## Input

- A brief description of what changed in `docs/SPEC.md`.

## Required reads

- `docs/SPEC.md` (updated)
- `docs/STATE.md` — current phase statuses, Current Contract, and Project Log
- All `docs/PHASE_*.md` files

If a recent SPEC.md diff is available (`git diff HEAD -- docs/SPEC.md`), inspect it before making decisions.

## Procedure

### 1. Impact analysis

Identify which domains changed:

| Domain | Signal | Affects |
|--------|--------|---------|
| Data model (§3) | table/column added, removed, renamed, retyped | `STATE.md` § Current Contract (`DB Schema`), phase files touching those tables |
| API endpoints (§4.2) | endpoint added, renamed, removed | `STATE.md` § Current Contract (`Active Endpoints`), phase files implementing those routes |
| Frontend (§5) | pages/stores/components changed | phase files building those |
| Non-functional reqs (§7) | performance, security, coverage | Gate checks of affected phase files |
| Phase plan (§8) | phase reordered or scope changed | specific phase files and `STATE.md` § Phase Status ordering |

For each changed domain, list affected phase files with precise reasons. **False-positive rule**: if unsure whether a phase is affected, mark it `⚠️ NEEDS_REVIEW`. A false positive is safer than a missed dependency.

### 2. Determine if contracts changed

- **Contracts changed**: new / renamed / removed tables, endpoints, types, or env vars → proceed
  with steps 3 and 4.
- **No contract change** (docs-only, non-functional only): skip steps 3 and 4 and note "no
  contract change" in the report.

### 3. Update `docs/STATE.md` § Current Contract (only if contracts changed)

1. Edit only the affected subsections: `Core Models`, `Active Endpoints`, `DB Schema`, `Env Config`.
2. Never remove an entry unless SPEC explicitly removes it.

### 4. Prepend a Project Log entry to `docs/STATE.md` (only if contracts changed)

Immediately above the previous newest entry in § Project Log:

```markdown
## [YYYY-MM-DD] — [Short Title]

**Type**: spec-change
**Author**: AI (spec-sync)
**Triggered by**: [what changed in SPEC.md]

### Changes / Decision
- [specific section and what changed]

### Affected Phases / Consequences
- PHASE_XX — [precise reason]
- (or: None — change has no impact on existing phases)
```

If no contract change: skip this entry entirely — do not log docs-only edits.

### 5. Mark affected phases in `docs/STATE.md` § Phase Status

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

STATE.md:     Current Contract updated / unchanged — [reason]
STATE.md:     Project Log entry added / no entry needed — [reason]
STATE.md:     phases marked ⚠️ NEEDS_REVIEW — [list / none]
PHASE files patched: [list / none]
Unaffected phases:   [list / none]

Next:
1. Review these changes before committing.
2. Resolve each NEEDS_REVIEW phase (update Contracts, remove ⚠️ banner).
3. Do not implement any NEEDS_REVIEW phase until resolved.
```

## Rules

- Never delete existing Project Log entries.
- Never remove endpoints / models from `STATE.md` § Current Contract unless SPEC explicitly removes them.
- Never rewrite a phase file from scratch.
- Do not commit.
- If the change description is empty and no diff is available, ask the architect what changed before proceeding.

## Done when

- `docs/STATE.md` is synchronized (Current Contract, Project Log, Phase Status).
- Affected phases are marked for review.
- Unchanged phases remain untouched.
