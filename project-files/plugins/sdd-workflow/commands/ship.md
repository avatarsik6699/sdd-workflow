---
description: Run the Full Gate; on PASS merge the feature branch to main and archive the change. With --release, also run the Release Gate, push, and verify the deploy. Usage: /ship [change] [--release]
---

# /ship

Execute the canonical playbook: [docs/playbooks/ship.md](../../../docs/playbooks/ship.md).

The matching skill lives at [skills/ship/SKILL.md](../skills/ship/SKILL.md).

Do not commit or merge outside of what this playbook's Full Gate PASS path describes.
