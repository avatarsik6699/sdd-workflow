---
description: Initialize or refresh SPEC.md from a high-level project brief with iterative validation and clarification. Usage: /spec-init [--new|--continue] "project description"
---

# /spec-init

Execute the canonical playbook: [docs/playbooks/spec-init.md](../../../docs/playbooks/spec-init.md).

The matching skill lives at [skills/spec-init/SKILL.md](../skills/spec-init/SKILL.md).

If command arguments are empty, ask the architect for a concise project brief before proceeding.
If no mode flag is provided, follow the canonical playbook default (`auto->new` for placeholder SPEC, otherwise `auto->continue`).
