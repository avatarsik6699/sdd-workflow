---
name: impl-assist
description: Implement phase tasks through the agent execution loop. Explores code, records PHASE_XX_NOTES.md execution memory, plans, implements, verifies, and updates the Scope checklist.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[phase] [task-id | group | --force]"
---

You are running the SDD `impl-assist` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/impl-assist.md](../../../docs/playbooks/impl-assist.md). That file is the source of truth for dependency checks, execution memory, implementation, verification, and the final report format.

If `$ARGUMENTS` is empty, ask: "Which phase? e.g. /impl-assist 01 or /impl-assist 01 B3"
