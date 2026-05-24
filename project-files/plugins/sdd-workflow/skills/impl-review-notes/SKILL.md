---
name: impl-review-notes
description: Fix unchecked Architect Review Notes for a phase. Records source note, safety check, exploration, plan, implementation log, verification, and residual risks in PHASE_XX_NOTES.md.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/PHASE_*_NOTES.md'
    - 'docs/CONTEXT.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "impl review notes"
      - "fix review notes"
      - "architect review notes"
      - "resolve review notes"
    allOf:
      - [review, notes]
      - [architect, review]
    anyOf:
      - "fix"
      - "resolve"
      - "phase"
    noneOf: []
    minScore: 5
retrieval:
  aliases:
    - sdd impl review notes
    - fix architect review notes
  intents:
    - fix unchecked Architect Review Notes
    - resolve post-implementation manual verification findings
  entities:
    - Architect Review Notes
    - PHASE_XX.md
    - PHASE_XX_NOTES.md
---

# impl-review-notes

Execute the canonical playbook in [docs/playbooks/impl-review-notes.md](../../../../docs/playbooks/impl-review-notes.md). That file is the source of truth for review-note resolution, metadata format, safety checks, and the final report.
