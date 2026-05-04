---
name: phase-explore
description: Explore the codebase in the context of phase tasks before planning. Reads actual source files, records patterns/constraints/risks in ### Exploration sections of PHASE_XX_NOTES.md, and emits a verdict (ready or needs-clarification). Run before /impl-brief for non-trivial tasks.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/PHASE_*_NOTES.md'
    - 'docs/CONTEXT.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "phase explore"
      - "explore codebase"
      - "explore before planning"
      - "explore tasks"
    allOf:
      - [phase, explore]
    anyOf:
      - "exploration"
      - "codebase"
      - "patterns"
    noneOf: []
    minScore: 5
retrieval:
  aliases:
    - sdd phase explore
    - explore phase tasks
  intents:
    - explore the codebase context before writing an implementation plan
    - populate PHASE_XX_NOTES.md with exploration findings and verdict
  entities:
    - PHASE_XX_NOTES.md
    - PHASE_XX.md
---

# phase-explore

Execute the canonical playbook in [docs/playbooks/phase-explore.md](../../../../docs/playbooks/phase-explore.md). That file is the source of truth for scope resolution, exploration format, skip rules, and the final report.
