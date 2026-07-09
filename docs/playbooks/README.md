# SDD Workflow Playbooks

These playbooks are the canonical source of truth for the workflow. Runtime wrappers under
`.claude/skills/` and `plugins/sdd-workflow/` must stay thin and point here.

## Bootstrap

- [workflow-init.md](./workflow-init.md) — integrate the workflow into a target project

## Integrated-project workflow

- [spec-init.md](./spec-init.md) — draft or refresh `docs/SPEC.md`
- [spec-sync.md](./spec-sync.md) — propagate approved spec changes into `docs/STATE.md`
- [phase-init.md](./phase-init.md) — scaffold `docs/PHASE_XX.md` from `docs/SPEC.md`
- [impl-assist.md](./impl-assist.md) — implement Scope tasks (default) or fix Architect Review
  Notes (`/impl-assist XX review`) through the same agent execution loop
- [phase-gate.md](./phase-gate.md) — validate gate commands and unresolved review notes
- [context-update.md](./context-update.md) — finalize phase context in `docs/STATE.md` after the gate passes
