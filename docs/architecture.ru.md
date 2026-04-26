# Архитектура

```mermaid
flowchart LR
  A[docs/playbooks] --> B[project-files/docs/playbooks]
  B --> C[project-files/.claude/skills]
  B --> D[project-files/plugins/sdd-workflow]
  E[.claude/skills/workflow-init] --> F[Bootstrap из этого репозитория]
  D --> G[Команды и навыки интегрированного проекта]
```

## Модель связей

- `docs/playbooks/` — канонический источник процедур workflow.
- `project-files/` — дистрибутив, который копируется в целевой проект.
- Root-обёртки используются только для bootstrap из этого репозитория.
- После bootstrap в интегрированном проекте работают пять производных навыков.
