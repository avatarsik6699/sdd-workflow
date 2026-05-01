# Skills catalog

## Bootstrap

### `/workflow-init`

- Purpose: copy workflow assets into a target repository.
- Input: path to target project.
- Output: docs templates, wrappers, hooks, and stack gate placeholders.

## Core operating loop (inside integrated project)

### `/spec-init`

- Purpose: draft or refresh `docs/SPEC.md`.
- Flags: `--new` (rewrite), `--continue` (extend); auto-detected if omitted.
- Use when: you start new scope or need to rewrite the contract.

### `/phase-init`

- Purpose: scaffold `docs/PHASE_XX.md` + `docs/PHASE_XX_NOTES.md` from current SPEC.
- Assigns task IDs (`B1`, `F1`, `I1`, `D1`…) with `Depends on:` chains.
- Use when: you are preparing the next implementation slice.

### `/phase-gate`

- Purpose: run configured checks and completion criteria (commands from `docs/STACK.md`).
- Use when: phase is implemented and must be validated before commit.

### `/context-update`

- Purpose: sync `CONTEXT.md` / `STATE.md` / `CHANGELOG.md` after a passed gate.
- Use when: phase is complete and ready for merge.

### `/spec-sync`

- Purpose: propagate SPEC changes into downstream docs.
- Use when: requirements changed mid-implementation.

## Implementation helpers (optional)

### `/impl-brief`

- Purpose: generate a concrete implementation plan for one or more tasks and write it to
  the `### Implementation Plan` section(s) of `docs/PHASE_XX_NOTES.md`.
- Input:
  - `/impl-brief [XX]` — full phase (all tasks)
  - `/impl-brief [XX] [ID]` — single task, e.g. `B3`
  - `/impl-brief [XX] [group]` — group prefix: `backend`, `frontend`, `infra`, `data`
  - `--force` — overwrite existing plan
- Output: filled `### Implementation Plan` blocks with: *Done when*, *Follows pattern*,
  file list, code signatures, migration SQL (if relevant), step-by-step order.
- Use when: before starting a task — gives you or the agent a precise, code-level roadmap.
- Rules: never touches `### Decisions & Notes`; never modifies `PHASE_XX.md` or `SPEC.md`.

### `/impl-assist`

- Purpose: implement one or more uncompleted tasks from a phase, verify completion by
  reading actual code (not checkbox state), check off completed tasks.
- Input:
  - `/impl-assist [XX]` — full phase (all unchecked tasks)
  - `/impl-assist [XX] [ID]` — single task
  - `/impl-assist [XX] [group]` — group prefix
  - `--force` — implement even if checkbox is already checked
- Output: committed code per task, updated Scope checkboxes in `PHASE_XX.md`.
- Use when: you want the agent to implement tasks (reads the plan from `PHASE_XX_NOTES.md`).
- Rules: honours `### Decisions & Notes` over `### Implementation Plan` when they conflict;
  respects `Depends on:` order; never writes to `### Decisions & Notes`.

## GitHub integration (optional)

### `/project-sync`

- Purpose: mirror `docs/PHASE_XX.md` task checkboxes to GitHub Issues and a GitHub
  Projects v2 Kanban board. Idempotent — safe to run on every commit or on demand.
- Input:
  - `/project-sync` — sync all phases
  - `/project-sync [XX]` — sync single phase
  - `/project-sync --dry-run` — preview changes without applying
  - `/project-sync --setup` — one-time setup: create GitHub Project, columns, label; write config to `docs/STACK.md`
- Requires: `gh` CLI authenticated, GitHub remote, prior `--setup` run.
- Rules: markdown is always the source of truth; never modifies phase files; never
  hard-deletes issues (closes + labels `sdd-removed` instead).
