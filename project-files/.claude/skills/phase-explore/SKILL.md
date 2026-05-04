---
name: phase-explore
description: Explore the codebase in the context of phase tasks. Reads source files, records patterns/constraints/risks/spec-gaps in ### Exploration sections of PHASE_XX_NOTES.md, and emits a verdict (ready or needs-clarification). Optional step between /phase-init and /impl-brief for non-trivial tasks.
allowed-tools: Read, Glob, Bash
argument-hint: "[phase] [task-id | group | --force]"
---

You are running the SDD `phase-explore` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/phase-explore.md](../../../docs/playbooks/phase-explore.md). That file is the source of truth for scope resolution, exploration format, skip rules, and the final report.

If `$ARGUMENTS` is empty, ask: "Which phase and task? e.g. /phase-explore 01 B3 or /phase-explore 01 backend"
