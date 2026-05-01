---
name: impl-brief
description: Generate a concrete implementation plan for phase tasks. Reads contracts from PHASE_XX.md and existing code patterns, writes to Implementation Plan sections of PHASE_XX_NOTES.md. Use when a developer needs a detailed plan before starting implementation.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/PHASE_*_NOTES.md'
    - 'docs/CONTEXT.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "impl brief"
      - "implementation brief"
      - "implementation plan"
      - "plan for task"
      - "how to implement"
    allOf:
      - [impl, brief]
      - [implementation, plan]
    anyOf:
      - "task"
      - "phase"
      - "implement"
    noneOf: []
    minScore: 5
retrieval:
  aliases:
    - sdd impl brief
    - generate implementation plan
  intents:
    - generate a concrete implementation plan for a phase task
    - populate PHASE_XX_NOTES.md with implementation details
  entities:
    - PHASE_XX_NOTES.md
    - PHASE_XX.md
---

# impl-brief

Execute the canonical playbook in [docs/playbooks/impl-brief.md](../../../../docs/playbooks/impl-brief.md). That file is the source of truth for scope resolution, overwrite rules, and the final report format.
