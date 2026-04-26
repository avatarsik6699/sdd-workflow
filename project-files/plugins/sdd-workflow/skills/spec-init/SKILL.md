---
name: spec-init
description: Initialize, reset, or continue SPEC.md from a high-level product brief (`--new` / `--continue`). Use when the architect wants the AI to draft a complete, validated spec and iteratively close gaps with clarification questions.
metadata:
  priority: 6
  pathPatterns:
    - 'docs/SPEC.md'
    - 'docs/STACK.md'
    - 'docs/PHASE_*.md'
  promptSignals:
    phrases:
      - "spec init"
      - "initialize spec"
      - "draft spec"
      - "bootstrap spec"
      - "create spec from description"
    allOf:
      - [spec, init]
      - [spec, draft]
    anyOf:
      - "specification"
      - "project brief"
      - "requirements"
    noneOf: []
    minScore: 6
retrieval:
  aliases:
    - sdd spec init
    - spec bootstrap
  intents:
    - draft project spec from brief
    - validate spec completeness
  entities:
    - SPEC.md
    - STACK.md
---

# spec-init

Execute the canonical playbook in [docs/playbooks/spec-init.md](../../../../docs/playbooks/spec-init.md). That file is the source of truth for drafting steps, critical validation checks, and clarification-loop rules.
