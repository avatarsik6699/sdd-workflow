---
name: context-update
description: Synchronize docs/STATE.md (Current Contract, Phase Status, Project Log) after a completed phase. Use when a phase has landed and the contract docs must reflect reality.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/STATE.md'
  promptSignals:
    phrases:
      - "context update"
      - "update context"
      - "sync context"
      - "phase complete"
    allOf:
      - [context, update]
      - [sync, context]
    anyOf:
      - "changelog"
      - "state"
      - "contract"
    noneOf: []
    minScore: 6
retrieval:
  aliases:
    - update context md
    - sync docs after phase
  intents:
    - update contract docs after implementation
    - mark a phase done
  entities:
    - STATE.md
    - PHASE_XX.md
---

# context-update

Execute the canonical playbook in [docs/playbooks/context-update.md](../../../../docs/playbooks/context-update.md). That file is the source of truth for the version-bump rules and the final report format.
