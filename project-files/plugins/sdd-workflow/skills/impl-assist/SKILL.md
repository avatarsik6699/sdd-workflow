---
name: impl-assist
description: Implement phase tasks through the agent execution loop. Explores code, records PHASE_XX_NOTES.md execution memory, plans, implements, verifies, and updates the Scope checklist.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/PHASE_*_NOTES.md'
    - 'docs/CONTEXT.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "impl assist"
      - "implement task"
      - "complete task"
      - "finish implementation"
      - "implement remaining"
      - "agent execution"
    allOf:
      - [impl, assist]
      - [implement, task]
    anyOf:
      - "task"
      - "phase"
      - "unchecked"
    noneOf: []
    minScore: 5
retrieval:
  aliases:
    - sdd impl assist
    - implement phase task
  intents:
    - implement phase tasks through the agent execution loop
    - have agent complete remaining implementation
  entities:
    - PHASE_XX.md
    - PHASE_XX_NOTES.md
---

# impl-assist

Execute the canonical playbook in [docs/playbooks/impl-assist.md](../../../../docs/playbooks/impl-assist.md). That file is the source of truth for dependency checks, execution memory, implementation, verification, and the final report format.
