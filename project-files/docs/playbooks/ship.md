# ship — Canonical Playbook

Run the Full Gate for a change, and on PASS merge its feature branch into `main` and archive the
change file. With `--release`, additionally run the Release Gate and push to `origin/main`,
confirming the resulting deploy via `gh`.

This document is the single source of truth for the `ship` workflow. It replaces the old
`phase-gate` + `context-update` pair: there is no Current Contract/Phase Status/Project Log left
to synchronize after archival, since the archive folder and git history are the record.

In an integrated project, runtime wrappers under `.claude/skills/ship/SKILL.md` (Claude Code),
`.agents/skills/ship/SKILL.md` (generic agent), and `plugins/sdd-workflow/{commands,skills}/ship/...`
(Codex) point here. The wrappers are thin stubs — every workflow detail lives in this file.

## Input

```text
/ship [NN]              — run the Full Gate; merge to main and archive on PASS
/ship [NN] --release     — also run the Release Gate, push main, and verify the deploy
```

- `NN` — zero-padded change number. If omitted, infer it from the current `feature/NN-slug` branch.

## Required reads

- `docs/changes/NN-slug.md` — the change under gate (Backlog, Files, Gate Checks override,
  Architect Review Notes)
- `docs/STACK.md` — Full Gate table, Release Gate table (`--release` only)
- Current git branch / `docs/changes/` directory, if `NN` wasn't given

## Procedure

### 1. Identify the target

- If `NN` was given, open `docs/changes/NN-slug.md`. Otherwise resolve `NN` from the current
  `feature/NN-slug` branch name; if the branch doesn't follow that pattern, ask which change.
- Confirm the branch is `feature/NN-slug` for that change; if not, stop and ask before proceeding
  (do not gate or merge the wrong branch).

### 2. Run the Full Gate

1. Read the change file's `Gate Checks` section for any phase/change-specific override (e.g. a
   custom smoke-test expectation) and treat it as an addition to, not a replacement of, the
   standard rows.
2. Read the change file's `Architect Review Notes` and count unchecked items. Unchecked items
   block PASS regardless of automated results.
3. Read `docs/STACK.md`'s **Full Gate** table and treat it as the command source. If a command is
   not defined for a row, mark that row `SKIPPED — no command in STACK.md` rather than guessing.
4. Ensure a project `.env` (or equivalent secrets file declared by `STACK.md`) exists so
   container-based commands use the same credentials the app uses.
5. If the project declares a helper script (`scripts/ship.sh` or any path in
   `STACK.md#gate-commands`), prefer it. Otherwise execute the rows below directly.
6. Bring up the full stack if bootstrap is required (e.g. start Docker services); wait for
   readiness before continuing.
7. Run, in order, whichever of these rows are defined in `docs/STACK.md`'s Full Gate table:
   migrations, backend test suite, frontend build, frontend type-check, frontend test suite,
   e2e determinism/lint check, e2e suite, smoke, **SAST** (e.g. Semgrep), **secrets scan** (e.g.
   Gitleaks), **dependency audit** (e.g. Trivy/`npm audit`/`pip-audit`), **accessibility audit**
   (e.g. axe/Lighthouse CI), **performance budget** (e.g. Lighthouse CI Core Web Vitals
   thresholds).
8. Do not stop at the first failure — run every defined row so the architect sees the full
   picture at once.
9. Produce a table report: one row per check, plus a row for Architect Review Notes. Overall PASS
   only if every executed row is green and there are no unchecked review notes.

### 3. On FAIL

Report the full table and stop. Do not commit, merge, or archive.

### 4. On PASS — merge and archive

1. Commit any outstanding changes on `feature/NN-slug` using the change file's Commit Message.
2. Merge `feature/NN-slug` into local `main` (fast-forward if possible, otherwise a normal merge
   commit — never rewrite history).
3. Move `docs/changes/NN-slug.md` to `docs/changes/archive/NN-slug.md`.
4. Report PASS, the merge result, and the archive path.

### 5. `--release` only — Release Gate and deploy

Run this only after step 4 succeeds.

1. Read `docs/STACK.md`'s **Release Gate** table and run its rows (e.g. container image scan,
   health-check/zero-downtime deploy verification). `n/a`/`SKIPPED` rows follow the same honesty
   rule as the Full Gate.
2. On PASS: push local `main` to `origin/main`.
3. Use `gh` to find the resulting CI/CD run for the pushed commit and confirm it completed
   successfully; if the project has a deploy step, confirm the deployment reports healthy
   (e.g. a `gh run watch`, a deployment status check, or the project's declared health endpoint).
   Report the live status — "pushed" alone is not sufficient.
4. On Release Gate FAIL: report and stop before pushing. The local merge from step 4 already
   happened and is not undone.

### 6. Report

```
## ship complete — change [NN]

Full Gate:
  [row] — PASS
  [row] — SKIPPED ([reason])
Architect Review Notes: [count] unresolved

Result: PASS / FAIL
Merged: feature/[NN]-slug -> main (fast-forward / merge commit)
Archived: docs/changes/archive/[NN]-slug.md

--release:
Release Gate:
  [row] — PASS / SKIPPED
Pushed: origin/main @ [sha]
Deploy status: [live status via gh, or "not applicable"]
```

## Rules

- Do not edit code files in this workflow.
- Do not stop at the first Full/Release Gate failure — show the full picture.
- Do bring up the full stack yourself when bootstrap is required; the gate verifies the real
  end-to-end environment, not isolated unit tests.
- Do not treat unchecked architect review notes as informational; they block PASS until resolved.
- Never force-push, rewrite history, or delete branches without explicit confirmation.
- Only push to `origin/main` when `--release` was passed and the Full Gate already passed.
- If the stack changes (new framework, new test runner, new container layout, new security
  scanner), update `docs/STACK.md`, never this playbook.

## Done when

- Every Full Gate row (and, with `--release`, every Release Gate row) has a reported status.
- The output clearly states overall PASS or FAIL.
- On PASS: the branch is merged to local `main` and the change file is archived.
- With `--release` and Release Gate PASS: `main` is pushed and the deploy status is confirmed, not
  assumed.
