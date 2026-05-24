# impl-assist — Canonical Playbook

Implement one or more uncompleted tasks from a phase through a deterministic agent-only cycle:
read the phase contract, explore the codebase, record execution memory, implement, verify, and
update the Scope checklist only after the code satisfies the task contract.

This document is the single source of truth for the `impl-assist` workflow.

In an integrated project, runtime wrappers under `.claude/skills/impl-assist/SKILL.md` (Claude
Code) and `plugins/sdd-workflow/{commands,skills}/impl-assist/...` (Codex) point here. The wrappers
are thin stubs — every workflow detail lives in this file.

## Input

```text
/impl-assist [XX]                 — full phase (all unchecked tasks)
/impl-assist [XX] [ID]            — single task, e.g. B3
/impl-assist [XX] [group]         — group, e.g. backend | frontend | infra | data
/impl-assist [XX] [ID] --force    — revisit even if checkbox is checked
```

- `XX` — zero-padded phase number
- `ID` — task identifier from the Scope checklist, e.g. `B3`, `F1`
- Group names resolve by prefix: `backend` -> `B*`, `frontend` -> `F*`, `infra` -> `I*`,
  `data` -> `D*`, `other` -> `T*`
- `--force` — include checked tasks and re-verify/rework them if needed

## Required reads

- `docs/PHASE_XX.md` — scope checklist, contracts, files, dependencies, gate notes
- `docs/PHASE_XX_NOTES.md` — agent-owned execution memory for this phase
- `docs/CONTEXT.md` — current technical contract
- `docs/STACK.md` — stack conventions, command rules, file layout, gate commands
- `docs/KNOWN_GOTCHAS.md` — project pitfalls
- Relevant source files — verify current implementation before editing

## Procedure

### 1. Validate input

- If no phase number, ask: "Which phase? e.g. /impl-assist 01 or /impl-assist 01 B3"
- Normalize the phase number to two digits.
- If `docs/PHASE_XX.md` does not exist, stop and report the missing file.
- If `docs/PHASE_XX_NOTES.md` does not exist, create it from `docs/PHASE_NOTES_TEMPLATE.md` and
  generate one task block per Scope item.
- Resolve the target task list from the optional ID/group argument. Default to all unchecked tasks.

### 2. Dependency check

For each target task, read its `Depends on:` field from `docs/PHASE_XX.md`.

- If a dependency task is unchecked and not part of the current target list, skip the dependent
  task and report it as blocked.
- Do not silently add dependency tasks to the queue. The implementation scope must stay explicit.
- Implement target tasks in dependency order when dependencies are included in the same run.

### 3. Prepare execution memory

For every target task, ensure `docs/PHASE_XX_NOTES.md` has this block:

```markdown
## B1 — task name

**Status:** open
**Depends on:** —

### Contract Snapshot

### Exploration

### Plan

### Implementation Log

### Verification

### Residual Risks
```

Rules for this file:

- It is agent-owned execution memory, not a human review document.
- Update it before and after code changes so future agent sessions can resume safely.
- Preserve existing useful execution history; append concise updates rather than erasing context.
- Never write speculative claims. Record only inspected files, actual edits, commands run, and
  explicit residual risks.

### 4. Verify current implementation

Before planning code changes for a task:

1. Read the task contract from `docs/PHASE_XX.md`: scope item, dependencies, files, and relevant
   Contracts subsections.
2. Read any existing task block in `docs/PHASE_XX_NOTES.md`.
3. Inspect the relevant source files and tests.
4. Decide the current state:
   - `implemented` — contract is satisfied in code; skip unless `--force`.
   - `partial` — some implementation exists but misses contract details.
   - `not-started` — required code/tests are absent.
   - `blocked` — cannot proceed without clarification or missing dependency.

Record a concise `### Contract Snapshot` and `### Exploration` entry before editing code.

### 5. Safety check

Stop and ask for architect confirmation before implementation if the task requires changing any of:

- `docs/SPEC.md` behavior
- persistent data schema beyond the phase contract
- public API request/response contract beyond the phase contract
- auth, authorization, secrets, or security behavior
- cross-phase architecture assumptions

Do not run `spec-sync`, `context-update`, or `phase-gate` automatically from this workflow.

### 6. Plan

For each task that is `partial` or `not-started`, write `### Plan` before editing code:

- **Done when:** concrete completion condition
- **Files:** exact paths expected to change
- **Steps:** short ordered implementation steps
- **Checks:** focused commands/tests to run

The plan must stay inside the active phase contract. Do not implement future phase scope.

### 7. Implement

For each planned task:

- Apply the smallest complete implementation that satisfies the contract.
- Match existing project conventions and patterns observed during exploration.
- Add or update focused tests when behavior is testable at reasonable cost.
- If a non-obvious pitfall is discovered, update `docs/KNOWN_GOTCHAS.md`.
- Record `### Implementation Log` with files changed and any intentional deviation from the plan.

### 8. Verify and mark complete

After implementing each task:

1. Re-read the changed files and confirm the task contract is satisfied.
2. Run the focused checks listed in `### Plan` when available.
3. Record `### Verification` with command results. If a check was not run, record the reason.
4. Record `### Residual Risks`; write `None` if none are known.
5. Change the task status in `docs/PHASE_XX_NOTES.md` to `implemented`, `blocked`, or `skipped`.
6. Check off the matching Scope item in `docs/PHASE_XX.md` only after verification succeeds or the
   task is explicitly already implemented.

Do not run the full phase gate. That is `/phase-gate`.

### 9. Report

```text
## impl-assist complete

Phase: PHASE_[XX]
Scope: [resolved task list]

Implemented:
  [ID] — [task name]: checked off in docs/PHASE_[XX].md

Skipped:
  [ID] — already implemented

Blocked:
  [ID] — [reason]

Checks:
  [command] — PASS
  [command] — not run ([reason])

Next: manually verify the product, add any findings to Architect Review Notes, then run
`/impl-review-notes [XX]` or `/phase-gate [XX]`.
```

## Rules

- Treat `docs/PHASE_XX.md` as the source of truth for what to build.
- Treat `docs/PHASE_XX_NOTES.md` as agent-owned execution memory.
- Verify by reading actual code. A checked checkbox is a hint, not proof.
- Do not wait for human approval after writing a plan unless the safety check triggers or the
  phase explicitly requires confirmation.
- Do not broaden scope beyond the active phase contract.
- Do not run `/phase-gate`, `/context-update`, or `/spec-sync`.
- Do not commit automatically.
- Follow all rules in `AGENTS.md` and stack-specific rules in `docs/STACK.md`.

## Done when

- Every targeted task is implemented, skipped as already implemented, or reported as blocked.
- Implemented tasks have Scope checkboxes checked in `docs/PHASE_XX.md`.
- `docs/PHASE_XX_NOTES.md` records contract snapshot, exploration, plan, implementation log,
  verification, and residual risks for each targeted task.
- The final report lists checks run and remaining manual next steps.
