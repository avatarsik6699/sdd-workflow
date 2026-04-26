---
name: workflow-init
description: Integrate the SDD workflow into a target project (new or existing). Copies AGENTS.md, CLAUDE.md, skill wrappers, plugins/sdd-workflow/, playbooks, and seeded doc scaffolds. Asks for stack commands and writes docs/STACK.md.
metadata:
  priority: 7
  pathPatterns:
    - 'project-files/**'
    - 'docs/playbooks/workflow-init.md'
  promptSignals:
    phrases:
      - "workflow init"
      - "integrate sdd"
      - "bootstrap workflow"
      - "install sdd workflow"
    allOf:
      - [workflow, init]
      - [integrate, sdd]
    anyOf:
      - "bootstrap"
      - "install"
      - "scaffold workflow"
    noneOf: []
    minScore: 6
retrieval:
  aliases:
    - sdd workflow init
    - install sdd-workflow
  intents:
    - bootstrap SDD workflow into a project
    - integrate workflow into existing project
  entities:
    - AGENTS.md
    - STACK.md
    - SDD workflow
---

# workflow-init

Execute the canonical playbook in [docs/playbooks/workflow-init.md](../../../../docs/playbooks/workflow-init.md). That file is the source of truth for detection rules, conflict policy, file map, placeholder substitution, and the final report format.

Do not commit. Do not run gate commands. Idempotent on re-run.
