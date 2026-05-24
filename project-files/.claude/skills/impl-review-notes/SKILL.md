---
name: impl-review-notes
description: Fix unchecked Architect Review Notes for a phase. Records source note, safety check, exploration, plan, implementation log, verification, and residual risks in PHASE_XX_NOTES.md.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[phase] [note-number | R[n] | --force]"
---

You are running the SDD `impl-review-notes` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/impl-review-notes.md](../../../docs/playbooks/impl-review-notes.md). That file is the source of truth for review-note resolution, metadata format, safety checks, and the final report.

If `$ARGUMENTS` is empty, ask: "Which phase? e.g. /impl-review-notes 01"
