---
name: phase-add-task
description: Add an unplanned task to an in-progress phase. Accepts a brief description, assigns the next task ID, derives contracts, updates PHASE_XX.md and PHASE_XX_NOTES.md, then runs phase-explore and impl-brief automatically.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[phase] \"brief task description\" [--group backend|frontend|infra|data] [--skip-explore] [--skip-brief]"
---

You are running the SDD `phase-add-task` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/phase-add-task.md](../../../docs/playbooks/phase-add-task.md). That file is the source of truth for group inference, ID assignment, contract derivation, and the final report.

If `$ARGUMENTS` is empty, ask: "Which phase and what should the new task do? e.g. /phase-add-task 01 \"add filter by status to user list\""
