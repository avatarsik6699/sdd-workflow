---
name: phase-gate
description: Run the full SDD gate for a phase using the commands declared in docs/STACK.md plus the phase's Gate Checks. Verifies architect review notes are resolved. Use when the user asks whether a phase is ready to commit.
metadata:
  priority: 5
  pathPatterns:
    - 'docs/PHASE_*.md'
    - 'docs/STATE.md'
    - 'docs/STACK.md'
  promptSignals:
    phrases:
      - "phase gate"
      - "run gate checks"
      - "ready to commit"
      - "check phase readiness"
    allOf:
      - [phase, gate]
      - [gate, checks]
    anyOf:
      - "tests"
      - "typecheck"
      - "smoke"
    noneOf: []
    minScore: 6
retrieval:
  aliases:
    - sdd gate
    - phase verification
  intents:
    - verify a phase before commit
    - run project gate checks
  entities:
    - STACK.md
    - PHASE.md
---

# phase-gate

Execute the canonical playbook in [docs/playbooks/phase-gate.md](../../../../docs/playbooks/phase-gate.md). The executable commands live in `docs/STACK.md#gate-commands`.

Read-only: do not edit code, do not commit. Do not return PASS while unchecked architect review notes remain.
