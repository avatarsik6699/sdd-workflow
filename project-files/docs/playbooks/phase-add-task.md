# phase-add-task — Canonical Playbook

Add an unplanned task to an in-progress phase. The user provides only a brief description;
the skill handles everything else: task ID assignment, contract derivation, scope and
`PHASE_XX_NOTES.md` updates, codebase exploration, and implementation planning.

This document is the single source of truth for the `phase-add-task` workflow.

In an integrated project, runtime wrappers under `.claude/skills/phase-add-task/SKILL.md`
(Claude Code) and `plugins/sdd-workflow/{commands,skills}/phase-add-task/…` (Codex) point
here. The wrappers are thin stubs — every workflow detail lives in this file.

## Input

```
/phase-add-task XX "brief description"
/phase-add-task XX "brief description" --group backend|frontend|infra|data
/phase-add-task XX "brief description" --skip-explore
/phase-add-task XX "brief description" --skip-brief
```

- `XX` — zero-padded phase number (e.g. `01`)
- `"brief description"` — one sentence describing what the task should do;
  the skill infers group, contracts, and dependencies from it
- `--group` — force assignment to a specific group instead of inferring
- `--skip-explore` — skip the `phase-explore` step (use for trivially simple additive tasks)
- `--skip-brief` — skip the `impl-brief` step (use when you intend to plan manually)

## Required reads

- `docs/PHASE_XX.md` — existing scope, contracts, files list
- `docs/SPEC.md` — full specification; used to check whether the new task is already implied
- `docs/CONTEXT.md` — current active models, endpoints, db schema
- `docs/STACK.md` — stack conventions, naming, file layout
- `docs/KNOWN_GOTCHAS.md` — known pitfalls to surface in the impl plan

## Procedure

### 1. Validate input

- If no phase number: ask "Which phase? e.g. /phase-add-task 01 \"add filter by status\""
- If no description: ask "Describe the new task in one sentence."
- Normalize phase number to two digits.
- If `docs/PHASE_XX.md` does not exist: stop — "docs/PHASE_[XX].md not found. Run /phase-init [XX] first."
- If `docs/PHASE_XX_NOTES.md` does not exist: stop — "docs/PHASE_[XX]_NOTES.md not found. Run /phase-init [XX] first."

### 2. Read context

Read all required files listed above. Pay special attention to:
- The existing Scope checklist in `docs/PHASE_XX.md` — determines the next available ID.
- `docs/SPEC.md §8` — check if the described task is already covered by an existing scope item.
  If it is, warn: "This looks like it's already covered by [ID] '[description]' in PHASE_[XX].md.
  Proceed anyway?" Wait for confirmation.
- The `## Contracts` section — determines whether new contracts must be added.

### 3. Infer task group

If `--group` was not passed, classify the description into one of the standard groups:

| Group | Keywords / signals |
|-------|--------------------|
| Backend | route, endpoint, API, service, model, query, migration, job, worker |
| Frontend | component, page, screen, form, store, UI, view, modal, table, filter |
| Infra | env var, Docker, CI, script, config, deploy, secret, cron |
| Data | migration, table, column, index, seed, schema |

If the description spans multiple groups (e.g. "add endpoint + frontend form"), split into two
tasks with sequential IDs and ask the user to confirm the split before proceeding.

### 4. Assign task ID

Find the highest existing ID in the target group from `docs/PHASE_XX.md § Scope`.
Assign the next integer: if `B3` is the highest, assign `B4`. If the group has no tasks yet,
start at `1` (e.g. `D1`).

**ID stability rule**: existing IDs are never renumbered. If a task was marked
`~~BN~~ (removed)`, skip that number and continue the sequence.

### 5. Determine dependencies

Scan the existing Scope checklist for uncompleted tasks (`- [ ]`) whose output this new task
logically requires. Common patterns:
- A Frontend task that renders data from a new Backend endpoint → depends on that endpoint task.
- A task that queries a new DB table → depends on the Data migration task.

Express as `_Depends on:_ B2, D1` or `—` for none.
If unclear, default to `—` and note in the report that dependencies were not inferred.

### 6. Derive contracts

Read the task description and determine whether any of the following need to be added to
`docs/PHASE_XX.md § Contracts`. Use `docs/SPEC.md` and `docs/CONTEXT.md` as primary sources
for field names, types, and conventions. Do not invent — derive from spec or existing patterns.

| New contract | Where to add |
|---|---|
| New DB table or column | `§ New persistent data` |
| New API endpoint | `§ New API endpoints` |
| New TypeScript / shared type | `§ New types / models / shared interfaces` |
| New env var | `§ New env vars` |
| New files to create or modify | `§ Files › Create / modify` |

If the new contracts are substantial (e.g. a new table with 5+ columns or a new API
resource), add a warning in the report: "These contracts are significant. Consider running
`/spec-sync` to propagate them to `docs/SPEC.md`."

If no contracts are needed (purely internal refactor, style change, test addition), skip
this step.

### 7. Update `docs/PHASE_XX.md`

Using surgical edits (never full-file rewrite):

**a. Add the task to `## Scope`** under the correct group heading:

```markdown
- [ ] `[ID]` [task description] — _Depends on:_ [IDs or —]
```

If the group heading does not yet exist in the Scope section, add it.

**b. Add contracts to `## Contracts`** (if step 6 produced any). Append to the relevant
sub-section. Do not remove or reformat existing contract entries.

**c. Add files to `## Files § Create / modify`** if new files were identified.

### 8. Add stub to `docs/PHASE_XX_NOTES.md`

Append the following block at the end of the file (after the last existing task block):

```markdown
## [ID] — [task description]
**Depends on:** [IDs or —]

### Exploration
<!-- Run `/phase-explore [XX] [ID]` to populate. -->

### Implementation Plan
<!-- Run `/impl-brief [XX] [ID]` to generate. -->

### Decisions & Notes
<!-- Document implementation decisions, deviations from plan, and lessons learned. -->
```

### 9. Run phase-explore (unless --skip-explore)

Execute the `phase-explore` playbook for the newly added task ID. This populates the
`### Exploration` section and determines whether impl-brief can produce a sound plan.

If the exploration verdict is `needs-clarification`: surface the open question in the report
and stop — do not proceed to step 10 until resolved.

### 10. Run impl-brief (unless --skip-brief)

Execute the `impl-brief` playbook for the newly added task ID. This populates the
`### Implementation Plan` section with: *Done when*, *Follows pattern*, file list,
code signatures, migration SQL (if relevant), and step-by-step order.

### 11. Report

```
## phase-add-task complete

Phase: PHASE_[XX]
Added: `[ID]` — [task description]
Group: [Backend | Frontend | Infra | Data]
Depends on: [IDs or —]

Contracts added to PHASE_[XX].md:
  - [what was added, or "none"]

Files added to PHASE_[XX].md § Files:
  - [list, or "none"]

Exploration: [✅ ready | ⚠ needs-clarification: [question] | ⏭ skipped (--skip-explore)]
Implementation Plan: [✅ written | ⏭ skipped (--skip-brief)]

[If contracts are significant:]
⚠ Significant contracts added. Consider running `/spec-sync` to propagate to SPEC.md.

Next: implement `[ID]` or run `/impl-assist [XX] [ID]` to have the agent implement.
```

## Rules

- Never modify `docs/SPEC.md` or `docs/CONTEXT.md`.
- Never renumber existing task IDs. Mark removed tasks as `~~BN~~ (removed)`.
- Never write to `### Decisions & Notes` sections.
- Do not commit.
- If the description is too vague to infer group or contracts, ask one focused clarifying
  question before proceeding. Do not guess and produce a wrong task.

## Done when

- `docs/PHASE_XX.md` has the new task in `## Scope` and any derived contracts in `## Contracts`.
- `docs/PHASE_XX_NOTES.md` has a stub block for the new task ID.
- `### Exploration` is populated (or skipped with `--skip-explore`).
- `### Implementation Plan` is populated (or skipped with `--skip-brief`).
- The report lists the new ID, group, dependencies, and any contract additions.
