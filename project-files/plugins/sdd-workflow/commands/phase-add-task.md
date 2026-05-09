---
description: Add an unplanned task to an in-progress phase. Provide a brief description; the skill assigns an ID, derives contracts, updates scope and notes, then runs explore + impl-brief automatically. Usage: /phase-add-task [XX] "description" [--group backend|frontend|infra|data] [--skip-explore] [--skip-brief]
---

# /phase-add-task

Execute the canonical playbook: [docs/playbooks/phase-add-task.md](../../../docs/playbooks/phase-add-task.md).

The matching skill lives at [skills/phase-add-task/SKILL.md](../skills/phase-add-task/SKILL.md).

If arguments are empty, ask: "Which phase and what should the new task do? e.g. /phase-add-task 01 \"add filter by status to user list\""
