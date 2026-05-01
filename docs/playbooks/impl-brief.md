# impl-brief — Canonical Playbook

Generate a concrete implementation plan for one or more tasks in a phase and write it to the
`### Implementation Plan` section(s) of `docs/PHASE_XX_NOTES.md`.

This document is the single source of truth for the `impl-brief` workflow.

In an integrated project, runtime wrappers under `.claude/skills/impl-brief/SKILL.md` (Claude Code)
and `plugins/sdd-workflow/{commands,skills}/impl-brief/…` (Codex) point here. The wrappers are
thin stubs — every workflow detail lives in this file.

## Input

```
/impl-brief [XX]                 — full phase (all tasks)
/impl-brief [XX] [ID]            — single task, e.g. B3
/impl-brief [XX] [group]         — group, e.g. backend | frontend | infra | data
/impl-brief [XX] [ID] --force    — overwrite existing Implementation Plan
/impl-brief [XX] [group] --force — overwrite group
```

- `XX` — zero-padded phase number (e.g. `01`)
- `ID` — task identifier from the Scope checklist (e.g. `B3`, `F1`)
- Group names resolve to all tasks with the matching prefix: `backend`→`B*`, `frontend`→`F*`,
  `infra`→`I*`, `data`→`D*`
- `--force` — overwrite `### Implementation Plan` even if it already has content

## Required reads

- `docs/PHASE_XX.md` — scope checklist, contracts (data model, endpoints, types, env vars)
- `docs/PHASE_XX_NOTES.md` — existing content; used to detect which sections to skip
- `docs/CONTEXT.md` — current code state (active models, endpoints, db schema)
- `docs/STACK.md` — stack conventions, file layout, package managers
- `docs/KNOWN_GOTCHAS.md` — project pitfalls relevant to the target tasks
- Relevant existing source files — to match naming conventions, import styles, and patterns

## Procedure

### 1. Validate input

- If no phase number, ask: "Which phase? e.g. /impl-brief 01 B3"
- Normalize phase number to two digits.
- If `docs/PHASE_XX_NOTES.md` does not exist: create it from `docs/PHASE_NOTES_TEMPLATE.md`
  with stubs for all tasks in `docs/PHASE_XX.md` § Scope, then proceed.
- Resolve target task list from the input scope argument (see Input section above).

### 2. Read context

For each target task:
- Extract the task description and `Depends on:` field from `docs/PHASE_XX.md` § Scope.
- Extract relevant contracts from `docs/PHASE_XX.md` (schemas, endpoints, types, env vars) that
  apply to this task.
- Read `docs/CONTEXT.md` for active models, endpoints, and db schema head.
- Read relevant source files to infer: directory layout, naming conventions, import patterns,
  existing base classes or utility functions to reuse.
- Scan `docs/KNOWN_GOTCHAS.md` for entries whose symptoms match this task's domain.

### 3. Skip check

For each target task: if `### Implementation Plan` already has non-empty content AND `--force` was
not passed — mark as SKIPPED and do not overwrite. Log the skip in the report.

### 4. Generate Implementation Plan

For each non-skipped target task, write a concrete plan to `### Implementation Plan`. The plan must
include:

- **Done when:** one or two concrete, testable sentences stating what must be true for this task
  to be considered complete. Derive from the task's contracts in PHASE_XX.md and test conventions
  in STACK.md. Examples: specific endpoint response codes and shapes, a named test that passes,
  a DB column that exists with its type.
- **Follows pattern:** path to an existing file (and optionally function/component) whose structure
  should be copied verbatim. Write "—" if no analogous implementation exists yet. Derive from the
  source file scan in step 2.
- **Files**: exact paths (relative to repo root) to create or modify
- **Code structure**: function/class/component signatures in the project's language, matching
  existing naming conventions from source files
- **Migration SQL** (if the task involves a DB change): full `CREATE TABLE` / `ALTER TABLE`
  statement, matching the migration tool conventions from `docs/STACK.md`
- **Step-by-step order**: numbered steps, honouring the `Depends on:` chain within the task
- **Gotcha callouts**: inline note if `KNOWN_GOTCHAS.md` has a relevant entry

Do **not** write to `### Decisions & Notes`. That section belongs to the human.

### 5. Write to PHASE_XX_NOTES.md

Using surgical edits (not full-file rewrite): replace the empty `### Implementation Plan` content
(or overwrite if `--force`) for each target task. Preserve all other file content unchanged,
including any existing `### Decisions & Notes` entries.

### 6. Report

```
## impl-brief complete

Phase: PHASE_[XX]
Scope: [resolved task list]

Written:
  [ID] — [task name]: docs/PHASE_[XX]_NOTES.md § Implementation Plan ✅

Skipped (already has content — use --force to overwrite):
  [ID] — [task name]

Next: implement the tasks or run `/impl-assist [XX] [ID]` to have the agent implement.
```

## Rules

- Never write to `### Decisions & Notes` sections.
- Never modify `docs/PHASE_XX.md`, `docs/SPEC.md`, or `docs/CONTEXT.md`.
- Do not commit.
- If a task's `Depends on:` references another task with an empty Implementation Plan, generate
  the dependency's plan first (in dependency order), then the requested task.

## Done when

- `docs/PHASE_XX_NOTES.md` exists.
- Each targeted `### Implementation Plan` section has concrete, actionable content.
- The report lists all written and skipped tasks.
