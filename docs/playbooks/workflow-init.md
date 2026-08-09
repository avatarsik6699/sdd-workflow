# workflow-init — Canonical Playbook

Integrate the SDD workflow into a target project (new or existing). This skill runs **once per
project**, from a freshly cloned `sdd-workflow` checkout. After it succeeds, the workflow is part
of the target project and the cloned repo can be deleted.

This document is the single source of truth for the `workflow-init` workflow. The workflow is
specialized for **web applications** (frontend + backend + database) — see `docs/SPEC.md`'s
section structure and `docs/STACK.md`'s stack table.

## Inputs

- `$ARGUMENTS` — absolute or relative path to the target project directory. If empty, ask the user.

## Required reads

- `project-files/` (this repo) — the exact tree to copy
- target project root (after `$ARGUMENTS` is resolved) — to detect existing files, legacy
  doc shapes, and infer stack signals

## Procedure

### 1. Resolve the target

1. If `$ARGUMENTS` is empty, ask: "Where should I install the SDD workflow? Provide an absolute or
   relative path to the target project root."
2. Resolve the path. If it does not exist, ask the user whether to create it (assume "no" by
   default — never `mkdir` over a typo). If the path exists but is the same as this `sdd-workflow`
   checkout, refuse and ask for a different target.
3. Establish that the target is a sane project root: it should already be a git repo (or the user
   confirms they want one initialized). If `.git/` is missing and the user wants one,
   `git init -b main` inside the target.

### 2. Detect project state

Read the top of the target directory and classify:

- **empty** — no source files, may have only `.git/`. Greenfield case. `stack_known` is
  determined in step 4 preamble.
- **existing** — has at least one of: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`,
  `pom.xml`, `build.gradle*`, `Gemfile`, `composer.json`, source directories with code.
  `stack_known` is always `true`.
- **partially initialized** — already has `AGENTS.md`, `docs/SPEC.md`, or `.claude/skills/` from a
  previous run. Treat as **upgrade**. `stack_known` is always `true`.

Record what was detected. Decisions later branch on this.

Independently of the classification above, also check the target root itself (not `docs/`) for a
draft/seed spec file: look for `DRAFT_SPEC.md` first; if absent, fall back to a single unambiguous
match of `*DRAFT*SPEC*.md` or `*SPEC*DRAFT*.md`. Record the found path, or `none`. This supports
the common staging layout where the architect drops a draft brief next to the cloned
`sdd-workflow` checkout, one level above `docs/` — e.g. `<target>/DRAFT_SPEC.md` — before running
this skill. The recorded path (or its absence) is used in step 9's next-steps text.

### 3. Detect and offer migration of legacy per-project docs (upgrade only)

Only relevant when step 2 classified the target as **partially initialized**. Two legacy shapes
may be present; check for both, oldest first, since a project could in principle need both folds
applied in sequence.

**3a. Pre-merge four-file shape → merged `STATE.md`** (oldest generation)

An older version shipped four separate files (`STATE.md`, `CONTEXT.md`, `CHANGELOG.md`,
`DECISIONS.md`) plus a `docs/PHASE_XX_NOTES.md` twin per phase file, where a later generation
shipped one merged `docs/STATE.md` (§ Phase Status + § Current Contract + § Project Log). The
current generation drops `STATE.md`/`PHASE_XX.md` entirely (see 3b) — but a project may still be
on this oldest shape, so fold it into the merged `STATE.md` shape first, then let 3b carry it
forward into `changes/`.

1. Check the target's `docs/` for any of: `CONTEXT.md`, `CHANGELOG.md`, `DECISIONS.md`, an
   existing `STATE.md` that lacks a `## Current Contract` or `## Project Log` heading (i.e. still
   the old shape), or any `PHASE_*_NOTES.md` files.
2. If none found: skip to 3b.
3. If found: report exactly what was detected, then ask:

   > "This project was set up with an older version of the workflow. It keeps `CONTEXT.md` /
   > `CHANGELOG.md` / `DECISIONS.md` separate from `STATE.md`[, and has PHASE_XX_NOTES.md files].
   > A later version merges the first four into one `docs/STATE.md`. I can fold their content into
   > that format now — nothing is deleted, only `STATE.md` is rewritten — before migrating
   > everything to the current `changes/` format. Proceed? (yes / skip)"

4. If the user agrees, build the merged `docs/STATE.md` losslessly from the existing files:
   - Old `STATE.md` § Phase Status table → new § Phase Status, unchanged.
   - `CONTEXT.md` JSON fields → new § Current Contract: `core_models` → Core Models,
     `endpoints_active` → Active Endpoints, `db_schema` → DB Schema (incl. `current_head`),
     `ui_pages_active` → UI Pages, `env_config.keys` → Env Config, `db_seeds` → DB Seeds,
     `phase_completed` / `phase_in_progress` → the two summary fields at the top of the section.
   - `CHANGELOG.md` entries → new § Project Log entries, preserving date and content; map the
     original `Type` field directly (`spec-change`, `phase-completion`) or to `feedback` if it
     doesn't match a known type.
   - `DECISIONS.md` ADRs → new § Project Log entries with `Type: decision`, one entry per ADR.
   - Old `STATE.md` "Expert Feedback Log" entries → new § Project Log entries with
     `Type: feedback`.
   - Old `STATE.md` "Rollback Notes" → new § Project Log entries with `Type: rollback`.
   - Merge all of the above into one newest-first § Project Log. This is a lossless fold — every
     existing entry must appear in the result, not a summary.
5. Write the merged result to `docs/STATE.md` (overwrite — the user explicitly agreed to this).
6. Do not fold `PHASE_*_NOTES.md` content anywhere (it was agent-owned execution memory, not
   project history, and has no home in the new shape). Leave those files untouched.
7. Leave `docs/CONTEXT.md`, `docs/CHANGELOG.md`, `docs/DECISIONS.md`, and any
   `docs/PHASE_*_NOTES.md` on disk. Never delete project files automatically. List them in the
   final report (step 9) as safe to delete once the user has spot-checked the result.
8. If the user says "skip" here: leave every legacy file untouched, do not create or overwrite
   `STATE.md`, note it in the final report, and still proceed to 3b (3b operates on whatever
   `STATE.md`/`PHASE_XX.md` shape currently exists, merged or not).

**3b. `STATE.md` + `PHASE_XX.md` shape → `changes/` + `changes/archive/`** (previous generation)

The previous generation tracked work as `docs/PHASE_XX.md` files with statuses mirrored in
`docs/STATE.md` § Phase Status. The current generation has no `STATE.md`: completed work lives in
`docs/changes/archive/`, active work in `docs/changes/`, and the codebase/git history is the
record of what exists — nothing is hand-mirrored.

1. Check the target for `docs/STATE.md` and any `docs/PHASE_XX.md` files (post-3a shape, or
   already current if 3a found nothing).
2. If none found: skip to step 4.
3. If found: report what was detected, then ask:

   > "This project tracks work as PHASE_XX.md files with a STATE.md status table. The current
   > version replaces that with docs/changes/ (active) and docs/changes/archive/ (done) — no
   > hand-maintained contract mirror. I can convert your phase files now. Proceed? (yes / skip)"

4. If the user agrees, for each `docs/PHASE_XX.md`, read its `STATE.md` § Phase Status row and its
   own Contracts section, then:
   - **`✅ done`** → convert to `docs/changes/archive/XX-<slug>.md`, where `<slug>` is derived from
     the phase title (kebab-case). Map: `Scope` → `Backlog` (keep IDs, dependencies, and
     strikethrough-removed markers exactly as they are); `Files` → `Files` unchanged;
     `Implementation Notes` → `Implementation Notes` unchanged; drop the old `Contracts` section
     entirely (replace with the one-line "see `docs/SPEC.md`" pointer per the current
     `CHANGE_TEMPLATE.md` shape) since it duplicated the codebase and the current template no
     longer carries it.
   - **`🔄 in-progress`** (or, if none is in-progress, the single oldest `⏳ pending`) → convert to
     the new active `docs/changes/XX-<slug>.md` using the same field mapping. If more than one
     phase is ambiguously "next," ask which one should become the active change; the rest become
     archived-as-pending (still moved to `archive/` with a note that they were never started, so
     the project isn't left with orphaned `PHASE_XX.md` files).
   - **`⚠️ NEEDS_REVIEW`** → convert and archive as above, but prepend a note at the top of the
     resulting file: "⚠️ Was NEEDS_REVIEW at migration time — re-check against the current
     `docs/SPEC.md` before assuming this is settled." (The old `spec-sync` banner-patching
     mechanism no longer exists in the current workflow, so this state can't be re-derived
     automatically.)
5. Create `docs/changes/` and `docs/changes/archive/` if they don't already exist.
6. Never delete `docs/STATE.md`, the original `docs/PHASE_XX.md` files, or `docs/PHASE_TEMPLATE.md`
   automatically. List them in the final report as safe to delete once the user has spot-checked
   the converted `changes/` files.
7. If the user says "skip": leave everything untouched and note in the final report that the
   project remains on the `STATE.md`/`PHASE_XX.md` shape (the new `plan`/`work`/`ship` skills
   expect `docs/changes/`, so the project should not mix the two shapes going forward).

### 4. Gather project metadata (interactive)

Ask the user for:

1. **Project name** — used for `[PROJECT_NAME]` placeholders in `AGENTS.md`, `CLAUDE.md`,
   `SPEC.md`. If the target directory has an obvious name, propose it as the default.
2. **One-line description** (optional) — for the SPEC seed.
3. **Owner / architect name** — for `[OWNER]` placeholders.
4. **Stack signals** — before asking these, if the project state is **empty**, ask:

   > "Do you know your tech stack already? Answer **yes** to provide gate commands now, or
   > **no** to skip — you can fill `docs/STACK.md` after `/plan` determines the stack."

   Record the answer as `stack_known`. If the answer is **no**, skip the rest of item 4 and
   proceed to item 5.

   If `stack_known` is **yes** (or the project is **existing** / **partially initialized**):

   - Offer the built-in **frontend default** as a starting point: "React + TanStack Start +
     TanStack Query + `openapi-typescript` (API type generation) + Docker + Nginx — use this as
     your frontend default? (yes / no, describe your own)". If accepted, pre-fill the frontend
     rows of `docs/STACK.md`'s Stack table and Gate Commands with the matching conventions
     (Vite/TanStack build, typecheck, unit test, and `openapi-typescript` regen commands); the
     user can still edit rows afterward.
   - Ask the **backend** stack freely, with no default offered — backend stacks vary per project
     and are sometimes polyglot. Record language(s)/framework(s) as given.
   - Ask the DB (default suggestion: Postgres, editable) and infra (default suggestion:
     Docker + Nginx, editable).
   - Ask for the gate command rows, split by tier — group by area, accept "skip"/`n/a` per row:
     - **Fast Gate** (run per task in `/work`): lint, type-check, targeted/affected unit tests,
       LSP diagnostics availability (yes/no — informational, not a command), API type regen
       command (e.g. `openapi-typescript` invocation) if applicable.
     - **Full Gate** (run once per `/ship`): infrastructure/bootstrap, migrations, backend test
       suite, frontend build, frontend unit tests, e2e determinism/lint check, e2e suite, smoke,
       SAST command (e.g. Semgrep), secrets-scan command (e.g. Gitleaks), dependency-audit command
       (e.g. Trivy / `npm audit` / `pip-audit`), accessibility-audit command (e.g. axe/Lighthouse
       CI), performance-budget command (e.g. Lighthouse CI with Core Web Vitals thresholds).
     - **Release Gate** (run only on `/ship --release`): container image scan command (e.g.
       Trivy), deploy/health-check verification command or endpoint, and whether `gh` is
       authenticated for this repo (yes/no — informational).
     - Optional helper script path for the Full Gate (e.g. `./scripts/ship.sh`).
5. **Required tooling availability** — ask which of the following are set up in this environment,
   to fill `docs/STACK.md`'s Required Tooling table honestly rather than assuming: Playwright MCP
   and/or chrome-devtools MCP (frontend visual verification), an LSP server for the project's
   languages, a `frontend-design` skill, a `backend-design` skill, an architecture skill. Any
   answered "no" gets recorded as "not available — do not enforce" rather than left silently
   assumed.
6. **Container / OS notes** worth recording in `KNOWN_GOTCHAS.md`. If unsure, skip.

Do not ask all of these in one wall of text — group by area, accept "skip" / `n/a` per row.

### 5. Plan the file copy

For each artefact under `project-files/`, decide one of:

- **create** — file does not exist in target, copy from `project-files/`
- **skip** — file already exists in target and is identical to source
- **conflict** — file exists in target but differs

For conflicts, default policy:

- For `AGENTS.md`, `CLAUDE.md`: rename existing to `<file>.bak`, then write new.
- For `docs/SPEC.md`, `docs/KNOWN_GOTCHAS.md`, `docs/STACK.md`, `docs/CHANGE_TEMPLATE.md`: do
  **not** overwrite. Leave the existing file. Report a warning.
- For `docs/playbooks/<name>.md`: overwrite (these are versioned with the workflow).
- For `.claude/skills/<name>/SKILL.md`, `.agents/skills/<name>/SKILL.md`, and
  `plugins/sdd-workflow/...`: overwrite (wrappers).
- For `scripts/*` and `.mcp.json`: skip if already present.
- `docs/changes/` and `docs/changes/archive/`: create as empty directories if missing (add a
  `.gitkeep` so they're tracked); never touch their contents if they already exist.

Show the user a planned action list **before** writing anything. Wait for `proceed` (or accept the
default if the user confirms in plain language). On `cancel`, abort.

### 6. Apply the copy

Walk the `project-files/` tree and execute the planned actions. Substitute placeholders inline
(`[PROJECT_NAME]`, `[OWNER]`, `[DOMAIN]`, `[DATE]`, `[STACK_STATUS]`) with the values gathered in
step 4 — use today's date for `[DATE]`. Make the substitution literal (search-and-replace), not
regex-creative.

Resolve `[STACK_STATUS]`:
- `stack_known` is **true** → substitute `CONFIGURED`
- `stack_known` is **false** → substitute `TBD — fill Gate Commands before running /ship`

Files to copy from `project-files/` to the target root, preserving structure:

- `AGENTS.md` → `AGENTS.md`
- `CLAUDE.md` → `CLAUDE.md`
- `.mcp.json` → `.mcp.json`
- `.claude/skills/<3 skills>/SKILL.md` → `.claude/skills/<3 skills>/SKILL.md` (plan, work, ship)
- `.agents/skills/<3 skills>/SKILL.md` → `.agents/skills/<3 skills>/SKILL.md` (plan, work, ship)
- `plugins/sdd-workflow/` → `plugins/sdd-workflow/` (commands, skills, hooks.json, .mcp.json,
  .codex-plugin/, scripts/, README.md)
- `docs/playbooks/<4 playbooks>.md` → `docs/playbooks/<4 playbooks>.md` (plan, work, ship, and
  `workflow-init.md` for future-self reference)
- `docs/templates/SPEC.md` → `docs/SPEC.md` (only if missing)
- `docs/templates/CHANGE_TEMPLATE.md` → `docs/CHANGE_TEMPLATE.md` (only if missing)
- `docs/templates/STACK.md` → `docs/STACK.md` (only if missing — if existing, leave it and tell the
  user where to merge gate commands)
- `docs/templates/KNOWN_GOTCHAS.md` → `docs/KNOWN_GOTCHAS.md` (only if missing)
- `docs/changes/.gitkeep`, `docs/changes/archive/.gitkeep` → create the directories (only if
  missing)

### 7. Fill `docs/STACK.md` from gathered commands

If `stack_known` is **false**: leave all Gate Commands rows as template placeholders — do not fill
or replace them. The `[STACK_STATUS]` substitution in step 6 already inserted the TBD warning
banner. Print:

```
docs/STACK.md has been left as a template.
Fill the Fast Gate / Full Gate / Release Gate tables before running /ship.
```

Then skip the rest of this step.

If `docs/STACK.md` was just created (step 6) and `stack_known` is **true**:

- Substitute the Stack table with the frontend default (if accepted) plus the given backend/DB/infra.
- Substitute the Fast Gate, Full Gate, and Release Gate rows with what the user entered in step 4.
  Leave `[bracketed placeholders]` for any row the user said `n/a` to, but mark the row's
  **Command** column with `n/a` so `/work`/`/ship` report it as `SKIPPED — n/a in STACK.md`.
- Fill the Required Tooling table from the availability answers in step 4 item 5 — mark
  unavailable tools as "not available — do not enforce" rather than leaving the row implying it's
  mandatory.

If `docs/STACK.md` already existed, do **not** edit it. Print a clear message:

> `docs/STACK.md` already exists. Verify it has Fast Gate / Full Gate / Release Gate tables and a
> Required Tooling table matching the shape expected by `docs/playbooks/work.md` and `ship.md`.
> Missing rows will be reported as SKIPPED.

### 8. Stamp metadata

- Nothing to stamp beyond the placeholder substitution in step 6 — there is no `STATE.md` seed
  entry in the current generation.

### 8a. Offer to remove the source checkout

Only run this step if step 6 completed without errors, and the current working directory (the
`sdd-workflow` checkout this skill is running from) is not the target and not inside the part of
the target's tree being preserved — i.e. it's the disposable clone used only to bootstrap.

Ask explicitly:

> "The workflow has been copied into `<target>`. This checkout at `<cwd>` is no longer needed —
> delete it now? (yes / no)"

- On **yes**: delete the checkout directory, then note in the final report that it was deleted.
- On **no** or no clear answer: leave it untouched; the final report keeps the existing
  "can be deleted" note.

This does not weaken the "never delete automatically" rule below — that rule protects
target-project content. This step only ever acts on the skill's own disposable source clone, and
only after an explicit per-run yes, never silently.

### 9. Final report

Produce a short report with:

- Files created (count)
- Files preserved as `.bak` (list)
- Files skipped because they already existed (list)
- Files left unchanged that the user should review (e.g. existing `STACK.md`)
- If step 3a ran: confirmation that `docs/STATE.md` was rewritten, plus the exact list of legacy
  files (`docs/CONTEXT.md`, `docs/CHANGELOG.md`, `docs/DECISIONS.md`, `docs/PHASE_*_NOTES.md`)
  that are now safe to delete once the user has spot-checked the merged `STATE.md`.
- If step 3b ran: the list of `docs/changes/archive/*.md` created from done phases, the one active
  `docs/changes/*.md` created from the in-progress/next phase, any `⚠️ NEEDS_REVIEW` phases that
  need a manual re-check, and confirmation that `docs/STATE.md` / old `docs/PHASE_XX.md` /
  `docs/PHASE_TEMPLATE.md` are now safe to delete once spot-checked.
- Whether the source checkout was deleted per step 8a, or left in place.
- The exact next-step commands. Substitute the `/plan` line's argument with the draft-spec path
  found in step 2, if one was found; otherwise use the generic wording shown below. Use the
  appropriate stack variant:

  **Stack configured** (`stack_known = true`), draft found:
  ```text
  Next steps:
    1. Review docs/STACK.md and ensure every Fast Gate / Full Gate / Release Gate row is correct,
       and the Required Tooling table matches what's actually available in this environment.
    2. Run /plan <found-draft-path> to draft docs/SPEC.md and scaffold the first change.
  ```

  **Stack configured** (`stack_known = true`), no draft found:
  ```text
  Next steps:
    1. Review docs/STACK.md and ensure every Fast Gate / Full Gate / Release Gate row is correct,
       and the Required Tooling table matches what's actually available in this environment.
    2. Run /plan "[your project brief]" (or /plan docs/DRAFT_SPEC.md if you have a draft file) to
       draft docs/SPEC.md and scaffold the first change.
  ```

  **Stack deferred** (`stack_known = false`), draft found:
  ```text
  Next steps:
    1. Run /plan <found-draft-path> to draft docs/SPEC.md and scaffold the first change.
    2. Once you've chosen your stack, fill docs/STACK.md's Fast/Full/Release Gate tables and
       Required Tooling table.
    3. Review and approve docs/SPEC.md.
  ```

  **Stack deferred** (`stack_known = false`), no draft found:
  ```text
  Next steps:
    1. Run /plan "[your idea]" to draft docs/SPEC.md and scaffold the first change.
    2. Once you've chosen your stack, fill docs/STACK.md's Fast/Full/Release Gate tables and
       Required Tooling table.
    3. Review and approve docs/SPEC.md.
  ```

## Rules

- Do not delete or overwrite user-authored content unless the conflict policy in step 5, or a
  migration the user explicitly approved in step 3, allows it.
- Never delete a file automatically — flag legacy files for manual deletion only. The sole
  exception is the skill's own source checkout (step 8a), which may be deleted only after an
  explicit per-run "yes" — never silently, and never any target-project content.
- Do not run any gate commands during init. This skill is a copy + scaffold operation.
- Do not commit. The user reviews and commits.
- Idempotency: a second run on the same target should add nothing and report `0 files created`.
- If the target is the `sdd-workflow` checkout itself, refuse — never bootstrap onto the source.

## Done when

- The target project has `AGENTS.md`, `CLAUDE.md`, `.claude/skills/<3>`, `.agents/skills/<3>`,
  `plugins/sdd-workflow/`, `docs/playbooks/<4>`, and seeded
  `docs/{SPEC,STACK,KNOWN_GOTCHAS,CHANGE_TEMPLATE}.md` plus empty `docs/changes/`/
  `docs/changes/archive/` directories.
- `docs/STACK.md` either has user-supplied Fast/Full/Release Gate commands and a filled Required
  Tooling table, or is flagged for the user to fill in.
- If a legacy doc shape was detected (four-file, or `STATE.md`+`PHASE_XX.md`), the user was
  offered a migration and knows which legacy files remain to be deleted by hand.
- The user was explicitly asked (step 8a) whether to delete the source checkout, and it was
  deleted or left per their answer.
- The user has the exact "next steps" list, with the `/plan` command pointing at the detected
  draft-spec path when one was found at the target root.
