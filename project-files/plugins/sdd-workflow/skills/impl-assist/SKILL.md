---
name: impl-assist
description: Implement Scope tasks (default) or fix Architect Review Notes (`review` argument) through the same agent execution loop. Explores code, plans, implements, verifies, and updates the matching checklist in PHASE_XX.md.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/STATE.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "impl assist"
      - "implement task"
      - "complete task"
      - "finish implementation"
      - "implement remaining"
      - "agent execution"
      - "fix review notes"
      - "architect review notes"
    allOf:
      - [impl, assist]
      - [implement, task]
    anyOf:
      - "task"
      - "phase"
      - "unchecked"
      - "review notes"
    noneOf: []
    minScore: 5
retrieval:
  aliases:
    - sdd impl assist
    - implement phase task
    - fix architect review notes
  intents:
    - implement phase tasks through the agent execution loop
    - have agent complete remaining implementation
    - fix unchecked Architect Review Notes
  entities:
    - PHASE_XX.md
    - Architect Review Notes
---

# impl-assist

Execute the canonical playbook in [docs/playbooks/impl-assist.md](../../../../docs/playbooks/impl-assist.md). That file is the source of truth for task-source resolution (Scope vs. `review`), dependency/safety checks, implementation, verification, and the final report format.
