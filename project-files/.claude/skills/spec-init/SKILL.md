---
name: spec-init
description: Initialize or refresh docs/SPEC.md from a high-level project brief. Runs critical completeness/consistency checks and asks focused clarification questions until the spec is implementation-ready.
allowed-tools: Read, Write, Edit, Glob
argument-hint: "[--new | --continue] [optional project brief]"
---

You are running the SDD `spec-init` workflow.

**Project brief**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/spec-init.md](../../../docs/playbooks/spec-init.md). That file is the source of truth for steps, validation checks, clarification loop rules, and final report format.

If `$ARGUMENTS` is empty, ask the architect for a concise project brief before drafting `docs/SPEC.md`.
If no mode flag is present in `$ARGUMENTS`, follow the canonical playbook auto-mode rule.
