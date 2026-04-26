# TECHNICAL SPECIFICATION (SPEC.md): `[PROJECT_NAME]`

> **For AI agent**: Read this file in full before starting any phase.
> Confirm understanding of constraints and the phased development model.
> When this file changes, run `/spec-sync [description of change]` immediately.

## Metadata

| Field | Value |
|-------|-------|
| Document Version | `v1.0` |
| Date | `[DATE]` |
| Architect / Owner | `[OWNER]` |
| Contract Version | `v1.0` (see `docs/CONTEXT.md`) |
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
| `AI_Agent` | Implements phases, runs gate checks | No push to main/develop |

### 2.2 Key Entities
<!-- List core entities and their relationships -->
`Entity1 → Entity2 → Entity3`

---

## 3. Data Model

```text
<!-- Describe persistent data: tables, collections, documents, files — whatever is appropriate to the stack. -->
entity_name(id, field1, field2, created_at)
```

---

## 4. API / Backend Contract

<!-- List the externally-visible interface: HTTP endpoints, RPC methods, message topics, CLI commands.
     Format depends on the stack. Pick what fits. -->

| Verb / Method | Path / Topic | Auth | Response / Payload |
|---------------|--------------|------|---------------------|
| ... | ... | ... | ... |

---

## 5. Frontend / Client Contract

<!-- Pages, screens, CLI surfaces, or anything the human user touches.
     If this project has no frontend, delete this section. -->

| Surface | Purpose | Notes |
|---------|---------|-------|
| ... | ... | ... |

---

## 6. Infrastructure

<!-- Services, runtimes, deployment targets. Reference docs/STACK.md for concrete commands. -->

---

## 7. Non-Functional Requirements

<!-- Performance, security, observability, compliance, accessibility. -->

---

## 8. Phased Delivery Plan

| Phase | Title | Goal | Key Outputs |
|-------|-------|------|-------------|
| `01` | [phase title] | [goal] | [outputs] |
| `02` | ... | ... | ... |

---

## 9. Out of Scope

<!-- Explicit list of things this project will NOT do. -->

---

## 10. Open Questions

<!-- Anything the architect has not yet decided. /spec-init pushes here when it cannot infer an answer. -->
