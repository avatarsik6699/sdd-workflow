# Architecture

```mermaid
flowchart LR
  A[docs/playbooks] --> B[project-files/docs/playbooks]
  B --> C[project-files/.claude/skills]
  B --> D[project-files/plugins/sdd-workflow]
  E[.claude/skills/workflow-init] --> F[Bootstrap in this repo]
  D --> G[Integrated project commands/skills]
```

## Relationship model

- `docs/playbooks/` is canonical for workflow procedures.
- `project-files/` is the distributable payload copied into target projects.
- Root `.claude/skills/workflow-init` and `plugins/sdd-workflow/` expose bootstrap from this repository itself.
- Integrated projects execute only the five derived skills, not this repo-local bootstrap wrappers.
