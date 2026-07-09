---
name: impl-assist
description: Implement Scope tasks (default) or fix Architect Review Notes (`review` argument) through the same agent execution loop. Explores code, plans, implements, verifies, and updates the matching checklist in PHASE_XX.md.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[phase] [task-id | group | review [R#] | --force]"
---

You are running the SDD `impl-assist` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/impl-assist.md](../../../docs/playbooks/impl-assist.md). That file is the source of truth for task-source resolution (Scope vs. `review`), dependency/safety checks, implementation, verification, and the final report format.

If `$ARGUMENTS` is empty, ask: "Which phase? e.g. /impl-assist 01, /impl-assist 01 B3, or /impl-assist 01 review"
