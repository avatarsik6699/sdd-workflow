# Architecture

```mermaid
flowchart LR
  A[docs/playbooks] --> B[project-files/docs/playbooks]
  B --> C[project-files/.claude/skills]
  B --> D[project-files/plugins/sdd-workflow]
  E[.claude/skills/workflow-init] --> F[Bootstrap from this repository]
  D --> G[Integrated project commands and skills]
```

## Relationship model

- `docs/playbooks/` is canonical for workflow procedures.
- `project-files/` is the distributable payload copied into target projects.
- Root wrappers expose bootstrap from this repository only.
- Integrated projects run the five derived skills after bootstrap.
