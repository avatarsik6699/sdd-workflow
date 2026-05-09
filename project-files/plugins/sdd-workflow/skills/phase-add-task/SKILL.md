---
name: phase-add-task
description: Add an unplanned task to an in-progress phase. Accepts a brief description, assigns the next task ID, derives contracts, updates PHASE_XX.md scope and PHASE_XX_NOTES.md, then runs phase-explore and impl-brief automatically.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/PHASE_*_NOTES.md'
    - 'docs/SPEC.md'
    - 'docs/CONTEXT.md'
  promptSignals:
    phrases:
      - "add task to phase"
      - "new task mid-phase"
      - "unplanned task"
      - "add subtask"
      - "phase add task"
    allOf:
      - [phase, add]
    anyOf:
      - "new task"
      - "unplanned"
      - "mid-phase"
    noneOf: []
    minScore: 5
retrieval:
  aliases:
    - sdd phase add task
    - add unplanned task to phase
  intents:
    - add a new unplanned task to an in-progress phase
    - register a discovered task and generate its implementation plan
  entities:
    - PHASE_XX.md
    - PHASE_XX_NOTES.md
---

# phase-add-task

Execute the canonical playbook in [docs/playbooks/phase-add-task.md](../../../../docs/playbooks/phase-add-task.md). That file is the source of truth for group inference, ID assignment, contract derivation, and the final report.
