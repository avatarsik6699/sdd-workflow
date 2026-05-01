# phase-init — Canonical Playbook

Scaffold a new `docs/PHASE_XX.md` from `docs/PHASE_TEMPLATE.md` using `docs/SPEC.md`, and append the phase row to `docs/STATE.md`.

This document is the single source of truth for the `phase-init` workflow.

In an integrated project, runtime wrappers under `.claude/skills/<skill>/SKILL.md` (Claude Code)
and `plugins/sdd-workflow/{commands,skills}/<skill>...` (Codex) point here. The wrappers are
thin stubs — every workflow detail lives in this file.

## Input

- Target phase number (e.g. `02`).

## Required reads

- `docs/PHASE_TEMPLATE.md`
- `docs/PHASE_NOTES_TEMPLATE.md`
- `docs/CONTEXT.md` — note current `_meta.version` and `phase_completed`
- `docs/STATE.md` — find the previous phase status
- `docs/SPEC.md` — read all sections, especially §3 (data model), §4 (API/backend), §5 (frontend), §6 (infra), §8 (phases plan)

## Procedure

### 1. Validate input

- If no phase number was provided, ask: "Which phase number? e.g. /phase-init 02".
- Normalize to two digits: `2` → `02`, `10` → `10`.
- If `docs/PHASE_XX.md` already exists, warn and wait for confirmation before overwriting.

### 2. Confirm previous phase is complete

Look up `PHASE_[XX-1]` in `docs/STATE.md`:

- `✅ done` → proceed.
- Anything else → warn: "PHASE_[XX-1] is not marked done (status: [status]). Starting the next phase before completing the previous one may cause context drift. Proceed anyway?" Wait for confirmation.
- Creating `PHASE_01` (no predecessor) → skip this check.

### 3. Request phase design assets (optional)

If the phase scope includes any frontend UI work, ask:

> "Are there Figma screenshots for any screens in Phase [XX]? Attach them now, or type 'skip'."

If screenshots are provided:

- For each screenshot, note the screen name and what it depicts (layout, key components, interactions).
- Add a `## Design References` section to the phase doc (placed after `## Phase Goal`, before `## Scope`) listing each screen with a one-line description.
- Use the screenshots to make the `### Frontend` scope checkboxes more concrete (specific component names, layout decisions visible in the design).

If skipped: omit the `## Design References` section from the phase doc entirely.

### 4. Extract scope and contracts from `docs/SPEC.md`

**Scope** (from §8): phase title and all scope items. After extracting items, assign task IDs:

1. Group items into: Backend, Frontend, Infra, Data, or ungrouped (Other).
2. Assign IDs sequentially within each group: `B1`, `B2`… for Backend; `F1`, `F2`… for Frontend;
   `I1`… for Infra; `D1`… for Data; `T1`… for ungrouped items.
3. Detect logical dependencies within the phase: migrations before models, models before routes,
   routes before tests. Express as `_Depends on:_ B1` or `—` for none.
4. Format each item: `- [ ] \`B2\` [description] — _Depends on:_ \`B1\``

IDs are stable once assigned. Never renumber. If a task is removed later, mark it `~~BN~~ (removed)`.

**New DB tables / columns** (from §3): tables first introduced in this phase, matched against the scope description. Paste verbatim blocks. Do not include tables that already existed.

**New API endpoints** (from §4.2): endpoint rows belonging to this phase. Include the full row — method, path, auth, description.

**New TypeScript types and stores** (from §3 + §5): derive types from new tables (map snake_case → camelCase; UUID → `string`; TIMESTAMPTZ → `string`; omit `hashed_password` and other sensitive columns from response types). From §5.2 identify stores first set up in this phase.

**Files** (from §4.1 + §5.1 + §5.2 + §6): explicit list of files to be created or modified, grouped as backend, frontend, infrastructure.

**Env vars**: env vars introduced for the first time in this phase, mapped to example values and required/optional.

If a section yields nothing for this phase, write `None` — never leave a subsection blank or as a generic TODO.

### 5. Create `docs/PHASE_XX.md`

Copy `docs/PHASE_TEMPLATE.md` and substitute placeholders:

| Placeholder | Value |
|-------------|-------|
| `[XX]` | Zero-padded phase number |
| `[Phase Title]` | From SPEC.md §8 |
| `v0.[XX].0` | Tag |
| `PHASE_[XX-1]` | Previous phase |
| `[VERSION]` | Current `_meta.version` from `docs/CONTEXT.md` |
| Scope checkboxes | Items from §8 with task IDs assigned in step 4: `- [ ] \`B1\` [item] — _Depends on:_ —` |
| Files | Explicit list from step 3 |
| Contracts | Extracted sections from step 3 |
| Atomic Commit Message | `feat(phase-[XX]): [phase title lowercased] — [2–4 key deliverables]`, under 72 chars |

Use `[TODO: verify]` only for details genuinely absent from SPEC.md (e.g. a smoke-test response body example). Do not invent data.

### 6. Create `docs/PHASE_XX_NOTES.md`

Copy `docs/PHASE_NOTES_TEMPLATE.md` and generate one task block per Scope item assigned in step 4:

```markdown
## [ID] — [task description]
**Depends on:** [IDs or —]

### Implementation Plan
<!-- Run `/impl-brief [XX] [ID]` to generate. -->

### Decisions & Notes
<!-- Human writes here. Never overwritten by agent. -->
```

Save as `docs/PHASE_[XX]_NOTES.md`. Update the `_Generated:` date. Leave all sections empty —
this is a stub. The Implementation Plans are populated later by `/impl-brief`.

### 7. Append the phase row to `docs/STATE.md`

Add to the Phase Status table:

```
| PHASE_[XX] | ⏳ pending | v0.[XX].0 | ⬜ | — | [Phase Title] |
```

### 8. Report

```
## phase-init complete

Created: docs/PHASE_[XX].md
Created: docs/PHASE_[XX]_NOTES.md (stub — run /impl-brief [XX] to populate Implementation Plans)
STATE.md: PHASE_[XX] row added (⏳ pending)

Scope tasks assigned:
- Backend:  [B1, B2, … or "none"]
- Frontend: [F1, F2, … or "none"]
- Infra:    [I1, … or "none"]
- Data:     [D1, … or "none"]
- Other:    [T1, … or "none"]

Contracts filled from SPEC.md:
- DB tables: [list or "none"]
- Endpoints: [count] rows
- TS types: [list or "none"]
- Stores: [list or "none"]
- Env vars: [count]
- Files: [count]

Before implementation, verify any remaining [TODO: verify] markers and the Gate Checks smoke-test expected response.
Run /impl-brief [XX] (or /impl-brief [XX] [ID]) to generate concrete Implementation Plans.

CONTEXT.md version at time of init: [version]
```

## Rules

- Never modify `docs/SPEC.md` or `docs/CONTEXT.md`.
- Extract contracts from SPEC.md — do not invent or leave blank.
- Do not commit.

## Done when

- `docs/PHASE_XX.md` exists and is filled from `docs/SPEC.md` with task IDs in Scope.
- `docs/PHASE_XX_NOTES.md` exists as a stub with one block per Scope task.
- `docs/STATE.md` contains the new pending row.
