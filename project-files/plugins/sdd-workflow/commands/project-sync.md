---
description: Sync phase task checkboxes to GitHub Issues + GitHub Projects Kanban board. Idempotent. Usage: /project-sync [XX] [--dry-run] [--setup]
---

# /project-sync

Execute the canonical playbook: [docs/playbooks/project-sync.md](../../../docs/playbooks/project-sync.md).

The matching skill lives at [skills/project-sync/SKILL.md](../skills/project-sync/SKILL.md).

Parse $ARGUMENTS:
- No args → sync all phases
- A two-digit number (e.g. `01`) → sync that phase only
- `--setup` → run initial GitHub Project creation and write config to `docs/STACK.md`
- `--dry-run` → print diff, apply nothing
- Combinations allowed: e.g. `01 --dry-run`
