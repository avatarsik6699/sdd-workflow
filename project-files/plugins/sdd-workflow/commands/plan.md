---
description: Draft or refresh SPEC.md from a brief (chat text or a draft file), scaffold a new change with a Backlog, and switch to its feature branch. Usage: /plan [--new|--continue] "brief" | path/to/draft.md
---

# /plan

Execute the canonical playbook: [docs/playbooks/plan.md](../../../docs/playbooks/plan.md).

The matching skill lives at [skills/plan/SKILL.md](../skills/plan/SKILL.md).

If the argument looks like a file path, read it as the source brief. If no brief and no file is
given, ask the architect for a concise brief before proceeding. If no mode flag is provided, follow
the canonical playbook default (`auto->new` for placeholder SPEC, otherwise `auto->continue`).
