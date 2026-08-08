---
name: workflow-init
description: Integrate the SDD workflow into a target project (new or existing). Copies AGENTS.md, CLAUDE.md, skill wrappers, plugins/sdd-workflow/, playbooks, and seeded doc scaffolds into the target. Asks for stack commands and writes docs/STACK.md.
---

<!-- Migrated and adapted from the matching Claude Code skill. -->

You are running the `workflow-init` workflow.

**Target path**: the arguments supplied in the user's request

Execute the canonical playbook in [docs/playbooks/workflow-init.md](../../../docs/playbooks/workflow-init.md). That file is the source of truth for detection rules, conflict policy, file map, placeholder substitution, and the final report format.

If `the arguments supplied in the user's request` is empty, ask: "Where should I install the SDD workflow? Provide an absolute or relative path to the target project root."

Do not commit. Do not run gate commands. Idempotent on re-run.
