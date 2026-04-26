---
name: context-update
description: Update docs/CONTEXT.md after a phase is completed. Reads the phase Contracts section, bumps the version if schema/API/types changed, updates STATE.md and CHANGELOG.md.
allowed-tools: Read, Write, Edit, Glob
argument-hint: "[phase number, e.g. 01]"
---

You are running the SDD `context-update` workflow.

**Target phase**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/context-update.md](../../../docs/playbooks/context-update.md). That file is the source of truth for all steps, the version-bump rules, and the final report format.

Do not commit — the architect reviews and commits.
