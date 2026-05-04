# phase-explore — Canonical Playbook

Explore the codebase in the context of one or more phase tasks and record findings in the
`### Exploration` section(s) of `docs/PHASE_XX_NOTES.md`.

This is an **optional** step that runs between `/phase-init` and `/impl-brief` for tasks that
are non-trivial, touch unfamiliar code areas, or involve cross-cutting concerns. For simple
additive tasks (add one endpoint or field with a clear existing analogue) it can be skipped.

This document is the single source of truth for the `phase-explore` workflow.

In an integrated project, runtime wrappers under `.claude/skills/phase-explore/SKILL.md` (Claude Code)
and `plugins/sdd-workflow/{commands,skills}/phase-explore/…` (Codex) point here. The wrappers are
thin stubs — every workflow detail lives in this file.

## Input

```
/phase-explore [XX]                  — full phase (all tasks)
/phase-explore [XX] [ID]             — single task, e.g. B3
/phase-explore [XX] [group]          — group, e.g. backend | frontend | infra | data
/phase-explore [XX] [ID] --force     — overwrite existing Exploration even if present
/phase-explore [XX] [group] --force  — overwrite group
```

- `XX` — zero-padded phase number (e.g. `01`)
- `ID` — task identifier from the Scope checklist (e.g. `B3`, `F1`)
- Group names resolve to all tasks with the matching prefix: `backend`→`B*`, `frontend`→`F*`,
  `infra`→`I*`, `data`→`D*`
- `--force` — overwrite `### Exploration` even if it already has content

## Required reads

- `docs/PHASE_XX.md` — scope checklist, contracts (data model, endpoints, types, env vars), files list
- `docs/PHASE_XX_NOTES.md` — existing Exploration sections; used for the skip check
- `docs/CONTEXT.md` — current active models, endpoints, db schema
- `docs/STACK.md` — project layout, naming conventions, stack-specific patterns
- `docs/KNOWN_GOTCHAS.md` — known pitfalls relevant to the task domain
- Relevant source files — read actual code to discover patterns, invariants, constraints

## Procedure

### 1. Validate input

- If no phase number provided, ask: "Which phase and task? e.g. /phase-explore 01 B3 or /phase-explore 01 backend"
- Normalize phase number to two digits: `2` → `02`, `10` → `10`.
- If `docs/PHASE_XX_NOTES.md` does not exist, stop: "docs/PHASE_[XX]_NOTES.md not found. Run /phase-init [XX] first."
- Resolve target task list from the input scope argument (see Input section above).

### 2. Skip check

For each target task: if `### Exploration` already has non-empty content AND `--force` was not
passed — mark as SKIPPED and do not overwrite. Log the skip in the report.

### 3. Explore codebase

For each non-skipped task:

**a. Read scope and contracts.** Extract the task description and `Depends on:` chain from
`docs/PHASE_XX.md § Scope`. Extract contracts (schemas, endpoints, types, env vars) that apply
to this task. Note any files explicitly listed in `docs/PHASE_XX.md § Files`.

**b. Identify relevant source files.** Based on the task domain and contracts, identify which
existing files are most likely to be involved:

- Files listed in `docs/PHASE_XX.md § Files` for this task
- Files referenced by active models/endpoints in `docs/CONTEXT.md`
- Files in the domain area of the task (e.g. billing task → billing module)
- Files implementing analogous patterns in adjacent resources

**c. Read those files.** Scan for the following four categories:

1. **Relevant patterns** — existing implementations (routes, models, services, components,
   stores) whose structure the new task should copy or extend. Capture exact file paths and
   line ranges.

2. **Constraints discovered** — invariants, DB constraints, middleware assumptions, enum values,
   or special-case logic present in code but not described in the spec. These are facts the
   Implementation Plan must respect.

3. **Spec/contract gaps** — discrepancies between what `PHASE_XX.md` says and what the codebase
   reveals. Examples: spec omits pagination but all similar endpoints use it; a required env var
   is missing from Contracts; a column type conflicts with an existing foreign key.

4. **Risk areas** — complex logic touched by this task, broad file impact, migration risks,
   test coverage gaps in affected modules.

**d. Determine verdict:**

- `ready` — no blockers found; `/impl-brief` can produce a sound plan without further input.
- `needs-clarification: [specific question]` — found an issue requiring a human decision
  before a plan can be written. State the question precisely and concisely.

### 4. Write to PHASE_XX_NOTES.md

Using surgical edits (not full-file rewrite): replace the empty `### Exploration` content
(or overwrite if `--force`) for each target task. Preserve all other file content unchanged,
including any existing `### Implementation Plan` and `### Decisions & Notes` entries.

Write the following structure into the `### Exploration` section:

```markdown
_Explored:_ `YYYY-MM-DD` · _Verdict:_ `ready`

**Relevant patterns found:**
- `path/to/file.ext:LNN` — [description of pattern and how it applies]

**Constraints discovered:**
- [constraint present in code but not captured in spec]

**Spec/contract gaps:**
- [discrepancy between PHASE_XX.md and the actual codebase]

**Risk areas:**
- [risk or test coverage gap]
```

Use `—` for any sub-section where nothing was found. Keep entries concise — one line per
finding. If verdict is `needs-clarification`, write:
`_Verdict:_ \`needs-clarification: [question]\``

### 5. Report

```
## phase-explore complete

Phase: PHASE_[XX]
Scope: [resolved task list]

Written:
  [ID] — [task name]: docs/PHASE_[XX]_NOTES.md § Exploration ✅
    Verdict: ready

Skipped (already has content — use --force to overwrite):
  [ID] — [task name]

[If any needs-clarification verdicts:]
⚠ Open questions — resolve before running /impl-brief:
  [ID]: [question]

Next: run `/impl-brief [XX] [ID]` to generate Implementation Plans.
(Skip any tasks with needs-clarification verdict until resolved.)
```

## Rules

- Never write to `### Implementation Plan` or `### Decisions & Notes`.
- Never modify `docs/PHASE_XX.md`, `docs/SPEC.md`, `docs/CONTEXT.md`, or `docs/STATE.md`.
- Do not generate an Implementation Plan — that is `/impl-brief`'s responsibility.
- Do not commit.
- If verdict is `needs-clarification`: record it in the Exploration section, surface it in
  the report, and stop — do not proceed to planning or implementation.

## Done when

- `### Exploration` section for each targeted (non-skipped) task has content.
- Each written exploration has a verdict (`ready` or `needs-clarification: [question]`).
- The report lists all written and skipped tasks and surfaces any open clarification questions.
