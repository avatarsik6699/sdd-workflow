# SDD Workflow Playbooks

These playbooks are the canonical source of truth for the workflow. Runtime wrappers under
`.claude/skills/` and `plugins/sdd-workflow/` must stay thin and point here.

## Bootstrap

- [workflow-init.md](./workflow-init.md) — integrate the workflow into a target project

## Integrated-project workflow

- [spec-init.md](./spec-init.md) — draft or refresh `docs/SPEC.md`
- [spec-sync.md](./spec-sync.md) — propagate approved spec changes into project memory
- [phase-init.md](./phase-init.md) — scaffold `docs/PHASE_XX.md` and agent execution memory
- [impl-assist.md](./impl-assist.md) — implement phase tasks through the agent execution loop
- [impl-review-notes.md](./impl-review-notes.md) — fix unchecked Architect Review Notes
- [phase-gate.md](./phase-gate.md) — validate gate commands and unresolved review notes
- [context-update.md](./context-update.md) — finalize phase context after the gate passes
