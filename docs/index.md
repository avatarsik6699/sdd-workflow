# sdd-workflow

A stack-agnostic Spec-Driven Development workflow you can apply to existing or new projects.

## Workflow map

```mermaid
flowchart TD
  A[workflow-init] --> B[spec-init]
  B --> C[phase-init]
  C --> D[Implementation]
  D --> E[phase-gate]
  E --> F[context-update]
  F --> G{More scope?}
  G -- Yes --> C
  G -- No --> H[Release tag]
```

## What this gives you

- Five reusable SDD skills inside target projects
- Canonical playbooks in plain Markdown
- Agent-agnostic wrappers for Claude Code and Codex
- Fixed documentation contract for SPEC/STATE/CONTEXT/CHANGELOG and phase files

Start with [Quickstart](quickstart.md).
