---
name: ship
description: Run the Full Gate for a change; on PASS, commit, merge to main, and archive the change file. With --release, also run the Release Gate, push origin/main, and verify the deploy via gh. Use when the architect wants to close out a change or release it.
metadata:
  priority: 6
  pathPatterns:
    - 'docs/changes/*.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "ship the change"
      - "run the gate"
      - "merge to main"
      - "release to production"
    allOf:
      - [ship, gate]
    anyOf:
      - "full gate"
      - "release gate"
      - "deploy"
    noneOf: []
    minScore: 6
retrieval:
  aliases:
    - sdd ship
    - phase gate
  intents:
    - run full gate and merge
    - release to production
  entities:
    - docs/changes/archive
    - STACK.md
---

# ship

Execute the canonical playbook in [docs/playbooks/ship.md](../../../../docs/playbooks/ship.md).
The executable commands live in `docs/STACK.md`'s Full Gate and Release Gate tables; do not
duplicate them here.
