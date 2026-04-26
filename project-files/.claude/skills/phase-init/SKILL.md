---
name: phase-init
description: Scaffold a new PHASE_XX.md from PHASE_TEMPLATE.md. Fills metadata, scope, Contracts, and Files by extracting data from SPEC.md. Adds the phase row to STATE.md.
allowed-tools: Read, Write, Glob
argument-hint: "[phase number, e.g. 02]"
---

You are running the SDD `phase-init` workflow.

**Target phase**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/phase-init.md](../../../docs/playbooks/phase-init.md). That file is the source of truth for all steps, inputs, rules, and the final report format.

If `$ARGUMENTS` is empty, ask: "Which phase number? Usage: /phase-init 02".
