# Phase Gate

Purpose: run the validation checks for the current phase and produce an honest PASS or FAIL report
that includes unresolved architect review notes.

This playbook is stack-agnostic. The actual commands for bootstrap, migrations, tests, type-check,
lint, e2e, and smoke live in **`docs/STACK.md`** under the `Gate Commands` section. That file is
written or extended by `/workflow-init` when the workflow is integrated into a project, and edited
by hand whenever the stack changes.

## Inputs

- Target phase number, or infer it from `docs/STATE.md`.

## Required reads

- `docs/PHASE_XX.md` — the phase under gate
- `docs/STACK.md` (`Gate Commands` section) — the only source of executable commands
- `docs/STATE.md` — only if no phase number was given on the call

## Procedure

1. Identify the target phase file. If a number was given, open `docs/PHASE_XX.md`. Otherwise read
   `docs/STATE.md` and select the latest phase whose status is `IN_PROGRESS`.
2. Read the phase file's `Gate Checks` section. Treat it as the per-phase contract: every check
   listed there must produce a status in the final report.
3. Read the phase file's `Architect Review Notes` section and count unchecked items. Unchecked
   items block PASS regardless of automated results.
4. Read `docs/STACK.md#gate-commands` and treat it as the human-readable command source for the
   standard gate steps below. If a command is not defined for a given step, mark that step as
   `SKIPPED — no command in STACK.md` rather than guessing.
5. Ensure a project `.env` (or equivalent secrets file declared by `STACK.md`) exists so any
   container-based commands use the same credentials the app uses.
6. If the project has a helper script (`scripts/phase-gate.sh` or any path declared in
   `STACK.md#gate-commands`), prefer it. Otherwise execute the steps below directly.
7. Run the **bootstrap / infrastructure** command from `STACK.md` (e.g. starting Docker services).
   Wait until services report ready before continuing.
8. Run the **migrations** command from `STACK.md`.
9. Run the **backend tests** command from `STACK.md`.
10. Run the **frontend prep** command from `STACK.md` (if the project has a frontend).
11. Run the **frontend type-check** command from `STACK.md`.
12. Run the **frontend unit tests** command from `STACK.md`.
13. Run the **e2e lint / determinism check** command from `STACK.md` (if defined). It must fail on
    any policy violation (e.g. committed `waitForTimeout` calls when Playwright is in use).
14. Run the **e2e** command from `STACK.md` (if defined).
15. Run the **smoke** command from `STACK.md`, unless the phase file declares a phase-specific
    smoke override under `Gate Checks`.
16. Produce a table report with one row per check, plus a row for `Architect Review Notes`. Return
    overall PASS only if (a) every executed step is green and (b) there are no unchecked architect
    review items.

## Rules

- Do not edit files.
- Do not commit.
- Do not stop at the first failure — show the full picture so the architect sees every failing
  check at once.
- Do bring up the full stack yourself when bootstrap is required; the gate verifies the real
  end-to-end environment, not isolated unit tests.
- Do not treat unchecked architect review notes as informational; they block PASS until resolved.
- If the stack changes (new framework, new test runner, new container layout), update
  `docs/STACK.md`, never this playbook.

## Preferred command

If the project ships a helper:

```bash
./scripts/phase-gate.sh [XX]
```

If no helper exists, follow the procedure above manually using the commands declared in
`docs/STACK.md#gate-commands`.

## Done when

- Every required check has a reported status (PASS / FAIL / SKIPPED).
- The output clearly states overall PASS or FAIL.
- Any unchecked architect review notes are listed explicitly in the report.
