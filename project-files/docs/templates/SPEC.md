# TECHNICAL SPECIFICATION (SPEC.md): `[PROJECT_NAME]`

> **For AI agent**: Read this file in full before starting any change. Confirm understanding of
> constraints before running `/plan` or `/work`. When this file changes in a way that affects an
> active `docs/changes/*.md`, note it in that change's Implementation Notes rather than
> hand-syncing a separate contract file — there isn't one.

## Metadata

| Field | Value |
|-------|-------|
| Document Version | `v1.0` |
| Date | `[DATE]` |
| Architect / Owner | `[OWNER]` |
| Stack | See [docs/STACK.md](./STACK.md) |
| Domain | `[DOMAIN — brief description of the subject area]` |

---

## 1. Project Overview and Goals

### 1.1 Problem
<!-- What problem does this project solve? What happens without it? -->

### 1.2 Goal and Success Metrics
<!-- What must be achieved? Which metrics confirm success? -->
- ...

### 1.3 Project Boundaries
| Included | Excluded |
|----------|----------|
| ... | ... |

---

## 2. Domain Context

### 2.1 Roles and Permissions
| Role | Capabilities | Restrictions |
|------|-------------|--------------|
| `Admin` | ... | ... |
| `Architect` | ... | ... |
| `AI_Agent` | Implements changes via `/work`, runs gates via `/ship` | No direct push to `main` outside `/ship` |

### 2.2 Key Entities
<!-- List core entities and their relationships -->
`Entity1 → Entity2 → Entity3`

---

## 3. Data Model

```text
<!-- Describe persistent data: tables, collections, documents, files. -->
entity_name(id, field1, field2, created_at)
```

---

## 4. API / Backend Contract

<!-- List the externally-visible interface: HTTP endpoints, RPC methods, message topics. -->

| Verb / Method | Path / Topic | Auth | Response / Payload |
|---------------|--------------|------|---------------------|
| ... | ... | ... | ... |

---

## 5. Frontend / Client Contract

<!-- Pages, screens, or anything the human user touches. If this project has no frontend, delete
     this section and §5.3. -->

### 5.1 Pages
| Page | Route | Purpose |
|------|-------|---------|
| ... | ... | ... |

### 5.2 Components / Stores
| Component / Store | Purpose | Notes |
|--------------------|---------|-------|
| ... | ... | ... |

### 5.3 Design System

<!-- Never leave this blank. If screenshots/references exist, list them here with a one-line note
     each. If not, `/plan` derives a direction via the `frontend-design` skill and records it here:
     typography, palette, layout patterns, tone, light/dark default. Later design change requests
     become Backlog items in the active change file, not a rewrite of this section. -->

---

## 6. Auth & Access Model

<!-- Authentication method, session/token handling, authorization model (RBAC/ABAC/ownership
     checks), and how §2.1 roles map to enforcement points. Kept separate from §4 because auth
     bugs and auth review are frequent enough to warrant their own contract surface. -->

---

## 7. Infrastructure and Deploy/CI

### 7.1 Infrastructure
<!-- Services, runtimes, deployment targets. Reference docs/STACK.md for concrete commands. -->

### 7.2 Deploy / CI
<!-- What "shipping to production" means for this project: pipeline stages, environments,
     rollback strategy, and what `/ship --release` is expected to verify after pushing. -->

---

## 8. Non-Functional Requirements

<!-- Standard web-app checklist — fill each row concretely or mark `n/a` with a one-line reason.
     Do not leave a row blank. -->

| Concern | Requirement |
|---------|-------------|
| Security headers / CORS | ... |
| Accessibility target | e.g. WCAG 2.2 AA |
| Performance budget | e.g. LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1 |
| Observability | logging/metrics/tracing expectations |
| Backup / restore | ... |
| Other (compliance, SLOs) | ... |

---

## 9. Roadmap

<!-- High-level milestones only. Detailed task-level scope lives in docs/changes/*.md, not here —
     this is a map of "what comes next," not a duplicate of the Backlog. -->

| Milestone | Goal | Key Outputs |
|-----------|------|-------------|
| `M1` | [goal] | [outputs] |
| `M2` | ... | ... |

---

## 10. Out of Scope

<!-- Explicit list of things this project will NOT do. -->

---

## 11. Open Questions

<!-- Anything the architect has not yet decided. /plan pushes here when it cannot infer an answer. -->
