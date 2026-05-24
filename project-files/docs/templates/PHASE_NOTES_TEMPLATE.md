# PHASE [XX] — Agent Execution Memory

<!--
  WHAT to build -> docs/PHASE_[XX].md
  HOW it was built -> this file

  This file is agent-owned execution memory. It is not intended for human review or manual edits.
  The agent updates it during /impl-assist and /impl-review-notes so future sessions can resume
  without reconstructing context from chat history.

  Sync rule: task IDs (B1, F1, I1, D1, T1) must match the Scope checklist in PHASE_[XX].md.
  To mark a removed task: prefix its heading with ~~, e.g. ## ~~B3~~ (removed). Do not delete
  historical execution memory unless the phase file explicitly removes the task.
-->

_Phase:_ `[XX]` · _Generated:_ `[DATE]`

---

<!-- Repeat the block below for each task ID from PHASE_[XX].md § Scope -->

## B1 — task name

**Status:** open
**Depends on:** —

### Contract Snapshot

<!-- Agent records the relevant PHASE_[XX].md contract before implementation. -->

### Exploration

<!-- Agent records inspected files, existing patterns, constraints, and risks. -->

### Plan

<!-- Agent records Done when / Files / Steps / Checks before editing code. -->

### Implementation Log

<!-- Agent records actual files changed and intentional deviations from the plan. -->

### Verification

<!-- Agent records checks run, results, and reasons for any skipped checks. -->

### Residual Risks

None

---

<!-- /impl-review-notes appends this section when Architect Review Notes need fixes.

## Review Notes Fixes

### R1 — short note title

**Status:** open
**Source:** `docs/PHASE_[XX].md` § Architect Review Notes

#### Source Note

#### Safety Check

#### Exploration

#### Plan

#### Implementation Log

#### Verification

#### Residual Risks
-->
