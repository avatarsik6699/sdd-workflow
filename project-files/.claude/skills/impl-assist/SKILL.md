---
name: impl-assist
description: Implement uncompleted phase tasks. Verifies completion by reading actual code (not just checkbox state), respects Decisions & Notes, checks dependencies, and updates the Scope checklist when done.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[phase] [task-id | group | --force]"
---

You are running the SDD `impl-assist` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/impl-assist.md](../../../docs/playbooks/impl-assist.md). That file is the source of truth for dependency checks, completion verification, and the final report format.

If `$ARGUMENTS` is empty, ask: "Which phase and task? e.g. /impl-assist 01 B3 or /impl-assist 01 backend"
