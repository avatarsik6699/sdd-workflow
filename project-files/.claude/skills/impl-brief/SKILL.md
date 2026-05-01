---
name: impl-brief
description: Generate a concrete implementation plan for phase tasks. Reads contracts from PHASE_XX.md and existing code patterns, then writes to the Implementation Plan section(s) of PHASE_XX_NOTES.md. Never overwrites Decisions & Notes.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[phase] [task-id | group | --force]"
---

You are running the SDD `impl-brief` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/impl-brief.md](../../../docs/playbooks/impl-brief.md). That file is the source of truth for scope resolution, overwrite rules, and the final report format.

If `$ARGUMENTS` is empty, ask: "Which phase and task? e.g. /impl-brief 01 B3 or /impl-brief 01 backend"
