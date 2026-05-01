# workflow-init — Canonical Playbook

Integrate the SDD workflow into a target project (new or existing). This skill runs **once per
project**, from a freshly cloned `sdd-workflow` checkout. After it succeeds, the workflow is part
of the target project and the cloned repo can be deleted.

This document is the single source of truth for the `workflow-init` workflow.

## Inputs

- `$ARGUMENTS` — absolute or relative path to the target project directory. If empty, ask the user.

## Required reads

- `project-files/` (this repo) — the exact tree to copy
- target project root (after `$ARGUMENTS` is resolved) — to detect existing files and infer stack signals

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
  determined in step 3 preamble.
- **existing** — has at least one of: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`,
  `pom.xml`, `build.gradle*`, `Gemfile`, `composer.json`, source directories with code.
  `stack_known` is always `true`.
- **partially initialized** — already has `AGENTS.md`, `docs/SPEC.md`, or `.claude/skills/` from a
  previous run. Treat as **upgrade**. `stack_known` is always `true`.

Record what was detected. Decisions later branch on this.

### 3. Gather project metadata (interactive)

Ask the user for:

1. **Project name** — used for `[PROJECT_NAME]` placeholders in `AGENTS.md`, `CLAUDE.md`, `SPEC.md`,
   `STATE.md`. If the target directory has an obvious name, propose it as the default.
2. **One-line description** (optional) — for the SPEC seed.
3. **Owner / architect name** — for `[OWNER]` placeholders.
4. **Stack signals** — before asking these, if the project state is **empty**, ask:

   > "Do you know your tech stack already? Answer **yes** to provide gate commands now, or
   > **no** to skip — you can fill `docs/STACK.md` after `/spec-init` determines the stack."

   Record the answer as `stack_known`. If the answer is **no**, skip the rest of item 4 and
   proceed to item 5.

   If `stack_known` is **yes** (or the project is **existing** / **partially initialized**), ask
   the rows that apply — infer from project state where possible:
   - infrastructure / bootstrap command
   - migrations command (or `n/a`)
   - backend / unit tests command
   - frontend prep / build command (or `n/a`)
   - frontend type-check command (or `n/a`)
   - frontend unit tests command (or `n/a`)
   - e2e lint command (or `n/a`)
   - e2e command (or `n/a`)
   - smoke command
   - optional helper script path (e.g. `./scripts/phase-gate.sh`)
5. **Container / OS notes** worth recording in `KNOWN_GOTCHAS.md`. If unsure, skip.

Do not ask all of these in one wall of text — group by area, accept "skip" / `n/a` per row.

### 4. Plan the file copy

For each artefact under `project-files/`, decide one of:

- **create** — file does not exist in target, copy from `project-files/`
- **skip** — file already exists in target and is identical to source
- **conflict** — file exists in target but differs

For conflicts, default policy:

- For `AGENTS.md`, `CLAUDE.md`: rename existing to `<file>.bak`, then write new.
- For `docs/SPEC.md`, `docs/STATE.md`, `docs/CONTEXT.md`, `docs/CHANGELOG.md`,
  `docs/KNOWN_GOTCHAS.md`, `docs/DECISIONS.md`, `docs/STACK.md`, `docs/PHASE_TEMPLATE.md`: do **not**
  overwrite. Leave the existing file. Report a warning.
- For `docs/playbooks/<name>.md`: overwrite (these are versioned with the workflow).
- For `.claude/skills/<name>/SKILL.md` and `plugins/sdd-workflow/...`: overwrite (wrappers).
- For `scripts/*` and `.mcp.json`: skip if already present.

Show the user a planned action list **before** writing anything. Wait for `proceed` (or accept the
default if the user confirms in plain language). On `cancel`, abort.

### 5. Apply the copy

Walk the `project-files/` tree and execute the planned actions. Substitute placeholders inline
(`[PROJECT_NAME]`, `[OWNER]`, `[DOMAIN]`, `[DATE]`, `[STACK_STATUS]`) with the values gathered in
step 3 — use today's date for `[DATE]`. Make the substitution literal (search-and-replace), not
regex-creative.

Resolve `[STACK_STATUS]`:
- `stack_known` is **true** → substitute `CONFIGURED`
- `stack_known` is **false** → substitute `TBD — fill Gate Commands before running /phase-gate`

Files to copy from `project-files/` to the target root, preserving structure:

- `AGENTS.md` → `AGENTS.md`
- `CLAUDE.md` → `CLAUDE.md`
- `.mcp.json` → `.mcp.json`
- `.claude/skills/<5 skills>/SKILL.md` → `.claude/skills/<5 skills>/SKILL.md`
- `plugins/sdd-workflow/` → `plugins/sdd-workflow/` (commands, skills, hooks.json, .mcp.json,
  .codex-plugin/, scripts/, README.md)
- `docs/playbooks/<6 playbooks>.md` → `docs/playbooks/<6 playbooks>.md` (includes `workflow-init.md`
  for future-self reference)
- `docs/templates/SPEC.md` → `docs/SPEC.md` (only if missing)
- `docs/templates/STATE.md` → `docs/STATE.md` (only if missing)
- `docs/templates/CHANGELOG.md` → `docs/CHANGELOG.md` (only if missing)
- `docs/templates/CONTEXT.md` → `docs/CONTEXT.md` (only if missing)
- `docs/templates/PHASE_TEMPLATE.md` → `docs/PHASE_TEMPLATE.md` (only if missing)
- `docs/templates/STACK.md` → `docs/STACK.md` (only if missing — if existing, leave it and tell the
  user where to merge gate commands)
- `docs/templates/KNOWN_GOTCHAS.md` → `docs/KNOWN_GOTCHAS.md` (only if missing)
- `docs/templates/DECISIONS.md` → `docs/DECISIONS.md` (only if missing)

### 6. Fill `docs/STACK.md` from gathered commands

If `stack_known` is **false**: leave all Gate Commands rows as template placeholders — do not fill
or replace them. The `[STACK_STATUS]` substitution in step 5 already inserted the TBD warning
banner. Print:

```
docs/STACK.md has been left as a template.
Fill the ## Gate Commands section before running /phase-gate.
```

Then skip the rest of this step.

If `docs/STACK.md` was just created (step 5) and `stack_known` is **true**, substitute the
gate-command rows under `## Gate Commands` with what the user entered in step 3. Leave
`[bracketed placeholders]` for any row the user said `n/a` to, but mark the row's **Command**
column with `n/a` so phase-gate reports it as `SKIPPED — n/a in STACK.md`.

If `docs/STACK.md` already existed, do **not** edit it. Print a clear message:

> `docs/STACK.md` already exists. Verify it has a `## Gate Commands` section with the rows expected
> by `docs/playbooks/phase-gate.md`. Missing rows will be reported as SKIPPED.

### 7. Stamp metadata

- In `docs/STATE.md`, fill the `Change Log` table's first row date with today.
- In `docs/CHANGELOG.md`, fill `[DATE]` and `[OWNER]` in the seed entry.
- In `docs/CONTEXT.md`, fill `captured_at` with today's date.

### 8. Final report

Produce a short report with:

- Files created (count)
- Files preserved as `.bak` (list)
- Files skipped because they already existed (list)
- Files left unchanged that the user should review (e.g. existing `STACK.md`)
- The exact next-step commands. Use the appropriate variant:

  **Stack configured** (`stack_known = true`):
  ```text
  Next steps:
    1. Review docs/STACK.md and ensure every Gate Commands row is correct.
    2. Run /spec-init "[your project brief]" to draft docs/SPEC.md.
    3. Run /phase-init 01 once SPEC.md is approved.
  ```

  **Stack deferred** (`stack_known = false`):
  ```text
  Next steps:
    1. Run /spec-init "[your idea]" to draft docs/SPEC.md.
    2. Once you've chosen your stack, fill docs/STACK.md → ## Gate Commands.
    3. Review and approve docs/SPEC.md.
    4. Run /phase-init 01 to scaffold the first phase.
  ```

## Rules

- Do not delete or overwrite user-authored content unless the conflict policy in step 4 allows it.
- Do not run any of the gate commands during init. This skill is a copy + scaffold operation.
- Do not commit. The user reviews and commits.
- Idempotency: a second run on the same target should add nothing and report `0 files created`.
- If the target is the `sdd-workflow` checkout itself, refuse — never bootstrap onto the source.

## Done when

- The target project has `AGENTS.md`, `CLAUDE.md`, `.claude/skills/<5>`, `plugins/sdd-workflow/`,
  `docs/playbooks/<6>`, and seeded `docs/{SPEC,STATE,CHANGELOG,CONTEXT,STACK,KNOWN_GOTCHAS,
  DECISIONS,PHASE_TEMPLATE}.md`.
- `docs/STACK.md` either has user-supplied gate commands or is flagged for the user to fill in.
- The user has the exact "next steps" list and knows the cloned `sdd-workflow` checkout can be
  deleted.
