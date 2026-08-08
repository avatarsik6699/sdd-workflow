---
name: work
description: Implement Backlog tasks (default) or fix Architect Review Notes (`review` argument) through the agent execution loop. Confirms the feature branch, absorbs mid-session findings into the Backlog, enforces required tooling, and runs the Fast Gate before checking items off.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[change] [task-id | group | review [R#] | --force]"
---

You are running the SDD `work` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/work.md](../../../docs/playbooks/work.md). That
file is the source of truth for the branch check, task-source resolution (Backlog vs. `review`),
Backlog-append handling, dependency/safety checks, required-tooling enforcement, the Fast Gate, and
the final report format.

If `$ARGUMENTS` is empty, ask: "Which change? e.g. /work 01, /work 01 B3, or /work 01 review"
