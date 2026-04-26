# Workflow Playbooks

These files are the **canonical source of truth** for the SDD workflow procedures.

There are two audiences:

1. **The `sdd-workflow` repo itself.** Only one playbook is reachable from here:
   [workflow-init.md](./workflow-init.md). It describes how an agent integrates this workflow into
   a target project. The other five playbooks are shipped to the target project by `workflow-init`
   and become reachable there.
2. **An integrated project.** After `/workflow-init` has run, the target project gets a copy of all
   six playbooks under `docs/playbooks/`, plus thin wrapper skills/commands under `.claude/skills/`
   and `plugins/sdd-workflow/`. Those wrappers do not contain workflow logic — they point here.

To change a workflow, edit only the playbook file. The wrappers stay one-line stubs.

## Playbooks

- [workflow-init.md](./workflow-init.md) — integrate the SDD workflow into a target project (new or existing)
- [spec-init.md](./spec-init.md) — draft or refresh `docs/SPEC.md` from a product brief
- [phase-init.md](./phase-init.md) — scaffold a new `docs/PHASE_XX.md`
- [phase-gate.md](./phase-gate.md) — validate a phase before commit (commands live in `docs/STACK.md`)
- [spec-sync.md](./spec-sync.md) — propagate a `docs/SPEC.md` change
- [context-update.md](./context-update.md) — finalize a completed phase

## Stack-specific commands

`phase-gate` reads its commands from `docs/STACK.md#gate-commands` in the integrated project.
There is no global manifest, no CLI helper, and no template registry. When a project's stack
changes, edit `docs/STACK.md` — the playbook stays untouched.
