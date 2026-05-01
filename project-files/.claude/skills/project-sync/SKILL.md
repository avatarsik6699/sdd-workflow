---
name: project-sync
description: Sync all phase tasks from docs/PHASE_XX.md to GitHub Issues and the GitHub Projects Kanban board. Idempotent — safe to run repeatedly. Requires gh CLI and a prior /project-sync --setup run.
allowed-tools: Read, Bash
argument-hint: "[XX] [--dry-run] [--setup]"
---

You are running the SDD `project-sync` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook at [docs/playbooks/project-sync.md](../../../docs/playbooks/project-sync.md). That file is the source of truth for all steps, rules, and the final report format.

If $ARGUMENTS is empty, sync all phases (without --setup).
