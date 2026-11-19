# work — Canonical Playbook

Implement one or more uncompleted items from a change file through a deterministic agent-only
cycle: confirm the right branch, read the change contract, explore the codebase, implement,
verify with the domain's mandated tooling and the Fast Gate, and update the change file only after
the code satisfies the item's contract. An "item" is either a **Backlog task** (`B1`, `F2`, …) or
an **Architect Review Note** (`R1`, `R2`, …) — both go through the same loop, just with a different
source location and a different checkbox to flip. Findings the architect reports mid-session are
appended to the Backlog, not fixed off-list.

This document is the single source of truth for the `work` workflow.

In an integrated project, runtime wrappers under `.claude/skills/work/SKILL.md` (Claude Code),
`.agents/skills/work/SKILL.md` (generic agent), and `plugins/sdd-workflow/{commands,skills}/work/...`
(Codex) point here. The wrappers are thin stubs — every workflow detail lives in this file.

## Input

```text
/work [NN]                 — full change (all unchecked Backlog tasks)
/work [NN] [ID]             — single Backlog task, e.g. B3
/work [NN] [group]          — Backlog group, e.g. backend | frontend | infra | data
/work [NN] review           — all unchecked Architect Review Notes
/work [NN] R[N]              — one Architect Review Note by generated ID, e.g. R2
/work [NN] ... --force       — revisit even if checked/resolved
```

- `NN` — zero-padded change number
- `ID` — Backlog task identifier, e.g. `B3`, `F1`
- Group names resolve by prefix: `backend` -> `B*`, `frontend` -> `F*`, `infra` -> `I*`,
  `data` -> `D*`, `other` -> `T*`
- `review` — targets all unchecked items in § Architect Review Notes instead of § Backlog
- `R[N]` — targets one Architect Review Note by ordinal, counted top to bottom after ignoring the
  default `No architect review issues recorded` line
- `--force` — include checked/resolved items and re-verify/rework them if needed

## Required reads

- `docs/changes/NN-slug.md` — Backlog checklist, Architect Review Notes, Files, dependencies,
  Gate Checks override, existing Implementation Notes
- `docs/SPEC.md` §3–§4 (and others as relevant) — the actual contract; the change file only
  points here, it doesn't duplicate it
- For UI work, `docs/SPEC.md` §5 (including §5.3), the relevant design sources, and any change
  file references or UI acceptance criteria
- `docs/STACK.md` — Fast Gate table, Required Tooling table, stack conventions
- `docs/KNOWN_GOTCHAS.md` — project pitfalls
- Relevant source files and git history — verify current implementation before editing; recent
  commits and diffs are the record of *how* prior work was done, so read them instead of expecting
  a separate execution-memory file

## Procedure

### 1. Branch check

- If the current branch is not `feature/NN-slug` for the target change: switch to it, creating it
  from `main` first if it doesn't exist yet. Do this before any other step — don't wait to be told.
- If switching would discard uncommitted work on the current branch, stop and ask.

### 2. Validate input and resolve the target source

- If no change number, ask: "Which change? e.g. /work 01 or /work 01 B3"
- Normalize the change number to two digits.
- If `docs/changes/NN-slug.md` does not exist, stop and report the missing file.
- Resolve the item source:
  - Argument is `review` or `R[N]` (or absent but explicitly targeting review) → source is
    § Architect Review Notes. Ignore the default checked line. Assign stable in-run IDs by
    checkbox order: `R1`, `R2`, …. Default target set: unchecked notes only; a specific `R[N]`
    narrows to one.
  - Otherwise → source is § Backlog. Resolve the target task list from the optional ID/group
    argument. Default to all unchecked tasks.
- `--force` widens the default target set to include checked/resolved items.
- If there are no target items in the resolved source, report that and stop.

### 3. Backlog append (mid-session findings)

Before or during implementation, if the architect's chat message (not the command arguments)
describes a finding, bug, or follow-up rather than an instruction about the current item:

1. Classify it: fix, enhancement, or new task.
2. Decompose it into one or more concrete items if it isn't already scoped small.
3. Append each as a new item to § Backlog in the active change file, in the appropriate group,
   with the next unused ID in that group — never insert into the middle of the ID sequence. If
   the addition affects UI, record the expectation under Design and UI Acceptance with its
   Backlog ID. Add the section if needed.
4. Only ask the architect when it's genuinely ambiguous whether the new item should block or
   follow the items currently in progress; otherwise queue it after the current target set.

Do not fix a reported finding silently without adding it to the Backlog first — the checklist must
stay the accurate record of what happened.

### 4. Dependency check (Backlog tasks only)

For each target Backlog task, read its `Depends on:` field.

- If a dependency task is unchecked and not part of the current target list, skip the dependent
  task and report it as blocked.
- Do not silently add dependency tasks to the queue. The implementation scope must stay explicit.
- Implement target tasks in dependency order when dependencies are included in the same run.

Architect Review Notes have no dependency field — skip this step for review-note targets.

### 5. Safety check

For each target item, decide whether it requires changing any of:

- `docs/SPEC.md` behavior
- persistent data schema beyond the change's contract
- public API request/response contract beyond the change's contract
- auth, authorization, secrets, or security behavior
- cross-change architecture assumptions

If yes, stop before implementation and report:

```text
Needs architect confirmation before implementation:
[ID] — [task or note text]
Reason: [schema/API/security/spec-level contract impact]
```

Do not run `/ship` automatically from this workflow.

### 6. Explore

Before planning code changes for an item:

1. Read the item's contract: for a Backlog task, the item line, dependencies, files, and the
   relevant `docs/SPEC.md` sections it points to; for a Review Note, the note text and the
   original Backlog/SPEC context it relates to.
2. Inspect the relevant source files, tests, and recent git history for that area.
   For UI work, identify the existing components, tokens, and layout or interaction patterns
   that apply. For a project without a documented convention, use the nearest relevant screen
   and its implementation as the starting point. If the item has no applicable UI criteria,
   derive focused checks from its Backlog entry or review note and any relevant references,
   including older Design References entries. For a Backlog item, record those criteria under
   Design and UI Acceptance with its ID.
3. Decide the current state:
   - `implemented` — contract/fix is already satisfied in code. For a selected UI item, go to
     steps 9–10 to verify the existing UI. If verification exposes an in-scope implementation gap,
     treat the item as `partial` and continue at step 7. For other items, skip unless `--force`
     was passed.
   - `partial` — some implementation exists but misses contract details.
   - `not-started` — required code/tests are absent (Backlog tasks only).
   - `blocked` — cannot proceed without clarification or missing dependency.
   - For Review Notes specifically: if the issue cannot be verified or needs a product/architecture
     decision, set the verdict to `needs-clarification: [specific question]` and do not plan or
     implement that note.

### 7. Plan

For each item that is `partial`, `not-started`, or a verified Review Note, write a short plan
before editing code:

- **Done when:** concrete completion condition
- **Files:** exact paths expected to change
- **Steps:** short ordered implementation steps
- **Checks:** which Fast Gate rows apply, plus any focused test commands. For UI work, identify
  the applicable design sources and the screen, states, and viewports or themes to verify.
- **Required tooling:** which row(s) of `docs/STACK.md`'s Required Tooling table apply to this
  item's domain (e.g. the project browser tool for UI work or LSP for TypeScript/Python)
- When introducing JavaScript syntax or built-ins with version-dependent support, apply
  the project's `AGENTS.md` § Native JavaScript and Web APIs. Include the affected execution
  targets and focused compatibility checks in **Checks**.

The plan must stay inside the active change's contract (for Backlog tasks) or narrowly inside the
targeted note (for Review Notes) — do not use a review-note fix to broaden scope.

### 8. Implement

For each planned item:

- Apply the smallest complete implementation that satisfies the contract or resolves the note.
- Match existing project conventions and patterns observed during exploration.
- For UI work, reuse applicable shared components and tokens and select tokens by their documented
  purpose. Include updates to affected design guidance in the same change when the agreed scope
  introduces or changes a shared rule. When updating a UI library, check the affected token and
  component references and representative screens.
- Add or update focused tests when behavior is testable at reasonable cost.
- If a non-obvious pitfall is discovered, update `docs/KNOWN_GOTCHAS.md`.
- If — and only if — something isn't already visible from the code or commit history (an
  intentional deviation from the plan, a residual risk, a rejected alternative), add one short
  bullet to `docs/changes/NN-slug.md` § Implementation Notes. Do not write routine implementation
  narration there.

### 9. Required-tooling enforcement

Before verifying and checking off an item, consult `docs/STACK.md`'s Required Tooling table for
the item's domain and confirm the mandated tool/skill was actually used:

- Frontend UI change → use the browser tool declared in `docs/STACK.md` or the project's
  documented fallback. Compare the rendered UI with the relevant design rules and the item's
  acceptance criteria. Exercise the affected interactions and states at the applicable viewport
  sizes and themes. Capture representative screenshots and check the console for new
  errors/warnings.
- TypeScript/Python change → run an LSP diagnostics pass on the changed files.
- New/changed API surface → regenerate types (`openapi-typescript` or the project's declared
  equivalent) and re-typecheck the frontend consumer.
- Architecture-level decision → the architecture skill must have been consulted during planning.
- Frontend design decision → consult the `frontend-design` skill when available.
- Backend/API design decision → the `backend-design` skill, if available in this environment.

This is not optional or "if convenient." If a mandated tool genuinely isn't available in this
environment, report it explicitly as skipped with the reason — do not check off the item silently
as if the tool had run.

### 10. Verify and mark complete (Fast Gate)

For each implemented item being verified:

1. Re-read the changed files and confirm the contract/note is satisfied.
2. Run the `docs/STACK.md` **Fast Gate** rows relevant to the touched area (lint, type-check,
   targeted/affected unit tests, LSP diagnostics, API type regen, and the configured design system
   audit for relevant UI work) and the item's focused compatibility checks. Report
   `n/a`/`SKIPPED` rows as such.
3. Report the commands run and their results, including any execution targets left unverified.
   For UI work, also report the route or screen, states, viewports or themes checked, and screenshot
   links when available. Leave or reopen a UI item's checkbox when an applicable check fails or
   acceptance criteria still need verification.
   State the reason for any skipped check.
4. Mark the item:
   - Backlog task → check off the matching item in `docs/changes/NN-slug.md` § Backlog.
   - Review Note → check off the matching item in `docs/changes/NN-slug.md` § Architect Review
     Notes.

Only check off an item after verification succeeds or a non-UI item is explicitly already
implemented.

Do not run the Full Gate or merge/archive. That is `/ship`.

### 11. Report

```text
## work complete

Change: docs/changes/NN-slug.md
Branch: feature/NN-slug
Source: backlog | review
Scope: [resolved item list]

Backlog additions this session:
  [ID] — [item] (from architect finding)

Done:
  [ID] — [task/note name]: checked off, tooling used: [list]

Skipped:
  [ID] — already implemented / already resolved

Blocked:
  [ID] — [reason]

Needs clarification:
  [ID] — [question]

Fast Gate:
  [row] — PASS
  [row] — FAIL ([reason])
  [row] — SKIPPED ([reason])

UI verification (when applicable):
  [ID] — [route/screen, states, viewports/themes, result, screenshot links if available]

Next: manually verify the product, add any findings to Architect Review Notes or let /work absorb
them next session, then run `/work [NN] review` or `/ship [NN]` when the change is complete.
```

## Rules

- Treat `docs/changes/NN-slug.md` as the source of truth for what to build and what to fix.
- Verify by reading actual code and recent git history. A checked checkbox is a hint, not proof.
- Do not wait for human approval after writing a plan unless the safety check triggers or the
  change explicitly requires confirmation.
- Do not broaden scope beyond the active change's contract or the targeted review note.
- Do not run `/ship`.
- Do not commit automatically.
- Do not classify a Review Note as a new Backlog task, bug, chore, or scope item.
- Follow all rules in `AGENTS.md` and stack-specific rules in `docs/STACK.md`.

## Done when

- Every targeted item is implemented/fixed, skipped as already done, or reported as blocked/needs
  clarification.
- Done Backlog tasks have their checkboxes checked in `docs/changes/NN-slug.md` § Backlog.
- Fixed Review Notes have their checkboxes checked in § Architect Review Notes.
- Any mid-session architect findings are recorded as new Backlog items, not silently fixed.
- Required tooling for each done item's domain was used, or explicitly reported as skipped with a
  reason.
- The final report lists Fast Gate results and remaining manual next steps.
