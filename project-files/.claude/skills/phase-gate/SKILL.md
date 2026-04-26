---
name: phase-gate
description: Run all gate checks for the current phase before committing. Executes the sequence declared in docs/STACK.md#gate-commands plus the phase's Gate Checks, then verifies architect review notes. Reports PASS or FAIL.
allowed-tools: Bash, Read
argument-hint: "[phase number, e.g. 01]"
---

You are running the SDD `phase-gate` workflow.

**Target phase**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/phase-gate.md](../../../docs/playbooks/phase-gate.md). The executable commands live in `docs/STACK.md#gate-commands`; do not duplicate them here.

Read-only: do not edit code, do not commit.

If `$ARGUMENTS` is empty and `docs/STATE.md` has no `🔄 in-progress` phase, ask: "Which phase number should I check? (e.g. /phase-gate 01)"
