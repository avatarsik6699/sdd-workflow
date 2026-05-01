# impl-assist — Canonical Playbook

Implement one or more uncompleted tasks from a phase, verify completion by reading actual code
(not just checkbox state), and update the Scope checklist in `docs/PHASE_XX.md`.

This document is the single source of truth for the `impl-assist` workflow.

In an integrated project, runtime wrappers under `.claude/skills/impl-assist/SKILL.md` (Claude Code)
and `plugins/sdd-workflow/{commands,skills}/impl-assist/…` (Codex) point here. The wrappers are
thin stubs — every workflow detail lives in this file.

## Input

```
/impl-assist [XX]                 — full phase (all unchecked tasks)
/impl-assist [XX] [ID]            — single task, e.g. B3
/impl-assist [XX] [group]         — group, e.g. backend | frontend | infra | data
/impl-assist [XX] [ID] --force    — implement even if checkbox is checked
```

- `XX` — zero-padded phase number
- `ID` — task identifier from the Scope checklist (e.g. `B3`, `F1`)
- Group names resolve to prefix: `backend`→`B*`, `frontend`→`F*`, `infra`→`I*`, `data`→`D*`
- `--force` — implement even if the checkbox is checked (useful for re-implementation)

## Required reads

- `docs/PHASE_XX.md` — scope checklist, contracts, `Depends on:` fields
- `docs/PHASE_XX_NOTES.md` — Implementation Plan and Decisions & Notes for each task
- `docs/CONTEXT.md` — current code state
- `docs/STACK.md` — stack conventions, test commands, file layout
- `docs/KNOWN_GOTCHAS.md` — project pitfalls
- Relevant source files — to verify current implementation state

## Procedure

### 1. Validate input

- If no phase number, ask: "Which phase? e.g. /impl-assist 01 B3"
- Normalize phase number to two digits.
- Resolve target task list from the input scope argument.

### 2. Dependency check

For each target task: read its `Depends on:` field from `docs/PHASE_XX.md`.
- If any declared dependency task is **unchecked** in the Scope checklist AND not in the current
  target list: report the blocking dependency and skip the dependent task.
  ```
  ⚠ B3 blocked — depends on B2 (unchecked). Run /impl-assist [XX] B2 first, or include B2 in scope.
  ```
- Do not add dependency tasks to the implementation queue automatically — make it explicit.

### 3. Completion verification

For each target task (in dependency order — dependencies first):

**Do not trust the checkbox alone.** Verify actual code state:
- Identify the files declared or implied by the Implementation Plan in `docs/PHASE_XX_NOTES.md`.
- If no Implementation Plan exists for this task, generate one inline using the same logic as
  `impl-brief` (read contracts, context, existing code) before proceeding.
- Read each relevant file. Check whether the contracts from `docs/PHASE_XX.md` are concretely
  implemented: required functions/routes/components exist, schemas match, tests exist.
- Determine status:
  - **Implemented**: contracts satisfied in code → skip (unless `--force`).
  - **Skeleton/partial**: file exists but implementation is incomplete → implement remaining parts.
  - **Not started**: file absent or contract not implemented → implement in full.

### 4. Read Decisions & Notes

Before writing any code for a task: read its `### Decisions & Notes` section in
`docs/PHASE_XX_NOTES.md`. If the human has documented decisions (alternative approaches chosen,
constraints, deviations from the plan), honour those decisions over the Implementation Plan.

### 5. Implement

For each task requiring implementation (skeleton or not-started status):
- Follow the Implementation Plan from `docs/PHASE_XX_NOTES.md` (adjusted for Decisions & Notes).
- Match the project's naming conventions, import style, and patterns observed in existing code.
- Write tests alongside implementation code — do not treat them as a separate task.
- After implementing each individual task: check off its checkbox in `docs/PHASE_XX.md`
  (`- [ ]` → `- [x]`).
- Commit atomically per task following the Atomic Commits rule in `AGENTS.md`:
  `feat|fix|chore(phase-[XX]): [task ID] [short description]`

### 6. Post-implementation check

After all target tasks are implemented:
- Re-read the implemented files and confirm the contracts from `docs/PHASE_XX.md` are satisfied.
- If any contract is unsatisfied, fix it before reporting success.

### 7. Report

```
## impl-assist complete

Phase: PHASE_[XX]
Scope: [resolved task list]

Implemented:
  [ID] — [task name]: ✅ committed as [commit hash]

Skipped (already implemented):
  [ID] — [task name]

Blocked (dependency unchecked):
  [ID] — [task name]: depends on [dep ID]

Next: run `/phase-gate [XX]` to validate the full phase.
```

## Rules

- Never write to `### Decisions & Notes` sections in `docs/PHASE_XX_NOTES.md`.
- Verify by code, not by checkbox. A checked box is a hint, not proof.
- Honour `### Decisions & Notes` over `### Implementation Plan` when they conflict.
- Do not implement tasks whose declared dependencies are unchecked (unless `--force`).
- Do not run gate — that is a separate step.
- Follow all rules in `AGENTS.md` (no hardcoded secrets, no push to main, atomic commits).

## Done when

- All targeted tasks are either implemented (and committed) or explicitly reported as skipped/blocked.
- All implemented tasks have their checkboxes checked in `docs/PHASE_XX.md`.
- The report clearly lists every task outcome.
