---
name: work
description: Implement Backlog tasks (default) or fix Architect Review Notes (review). Confirms the feature branch, absorbs mid-session findings into the Backlog, enforces required tooling, and runs the Fast Gate. Use when the architect wants the AI to implement scoped work or fix reported issues.
metadata:
  priority: 6
  pathPatterns:
    - 'docs/changes/*.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "implement the backlog"
      - "work on the change"
      - "fix review notes"
      - "implement task"
    allOf:
      - [implement, task]
    anyOf:
      - "backlog"
      - "review notes"
      - "change file"
    noneOf: []
    minScore: 6
retrieval:
  aliases:
    - sdd work
    - impl loop
  intents:
    - implement backlog task
    - fix architect review note
  entities:
    - docs/changes
    - STACK.md
---

# work

Execute the canonical playbook in [docs/playbooks/work.md](../../../../docs/playbooks/work.md).
That file is the source of truth for the branch check, task-source resolution (Backlog vs.
`review`), Backlog-append handling, dependency/safety checks, required-tooling enforcement, and
the Fast Gate.
