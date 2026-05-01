---
name: impl-assist
description: Implement uncompleted phase tasks. Verifies completion by reading actual code, respects human Decisions & Notes, checks task dependencies, implements remaining work, and updates the Scope checklist. Use when a developer wants the agent to complete or fill in tasks.
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
    - implement uncompleted phase tasks
    - have agent complete remaining implementation
  entities:
    - PHASE_XX.md
    - PHASE_XX_NOTES.md
---

# impl-assist

Execute the canonical playbook in [docs/playbooks/impl-assist.md](../../../../docs/playbooks/impl-assist.md). That file is the source of truth for dependency checks, completion verification, and the final report format.
