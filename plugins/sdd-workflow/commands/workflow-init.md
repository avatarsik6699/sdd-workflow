---
description: Integrate the SDD workflow into a target project (new or existing). Usage: /workflow-init [path-to-target-project]
---

# /workflow-init

Execute the canonical playbook: [docs/playbooks/workflow-init.md](../../../docs/playbooks/workflow-init.md).

The matching skill lives at [skills/workflow-init/SKILL.md](../skills/workflow-init/SKILL.md).

If the target path is missing from the command arguments, ask the user for it before proceeding. Do not commit. Do not run gate commands. Idempotent on re-run.
