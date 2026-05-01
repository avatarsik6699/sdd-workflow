---
name: project-sync
description: Sync phase task checkboxes from docs/PHASE_XX.md to GitHub Issues and a GitHub Projects v2 Kanban board. Idempotent — diffing on sync marker in issue body. Supports --setup, --dry-run, and per-phase targeting.
metadata:
  priority: 6
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/STATE.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "project sync"
      - "sync to github"
      - "sync kanban"
      - "sync board"
      - "github board"
      - "github project"
    allOf:
      - [sync, github]
    anyOf:
      - "kanban"
      - "board"
      - "issues"
    noneOf: []
    minScore: 5
retrieval:
  aliases:
    - sync tasks to github
    - update kanban board
    - push phase tasks to github projects
  intents:
    - mirror markdown task state to GitHub Projects board
    - keep github issues in sync with phase files
  entities:
    - PHASE_XX.md
    - GitHub Projects
    - GitHub Issues
---

# project-sync

Execute the canonical playbook in [docs/playbooks/project-sync.md](../../../../docs/playbooks/project-sync.md). That file is the source of truth for all steps, the idempotency mechanism, the full lifecycle operations, and the report format.
