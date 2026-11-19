---
name: plan
description: Draft or refresh docs/SPEC.md from a brief, scaffold a change with a Backlog, and switch to its feature branch. Use project design rules and define acceptance criteria for UI work.
---

<!-- Migrated and adapted from the matching Claude Code skill. -->

You are running the SDD `plan` workflow.

**Brief**: the arguments supplied in the user's request

Execute the canonical playbook in [docs/playbooks/plan.md](../../../docs/playbooks/plan.md). That
file is the source of truth for spec drafting/validation, the design flow, Backlog scaffolding, and
the git-flow branch step.

If the arguments look like a file path, read that file as the source brief instead of asking for
one in chat. If no brief and no file is implied, ask the architect for a concise brief before
drafting `docs/SPEC.md`. If no mode flag is present, follow the canonical playbook's auto-mode
rule.
