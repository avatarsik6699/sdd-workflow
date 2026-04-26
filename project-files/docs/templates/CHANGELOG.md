# CHANGELOG — Spec & Architecture History

> Records changes to `docs/SPEC.md` and `docs/CONTEXT.md`. This is **NOT** a git commit log.
> Purpose: capture *why* the contract changed and which phases were affected.
> Format: newest entry at top.

---

## v1.0 — [DATE] — Initial Setup

**Type**: initial-setup
**Author**: [OWNER]
**Triggered by**: Project initialization with SDD workflow

### Changes
- `SPEC.md` created: project goals, roles, data model, API/contract, phase plan
- `CONTEXT.md` v1.0 created: initial stack snapshot
- `STACK.md` populated with build/test/run commands

### Affected Phases
- None (initial state)

### Contract Updates
- `CONTEXT.md` initialized at `v1.0`

---

<!--
ENTRY TEMPLATE — copy this block when adding a new entry:

## [CONTEXT_VERSION] — [YYYY-MM-DD] — [Short Title]

**Type**: spec-change | arch-decision | breaking-change | phase-completion | addendum
**Author**: [name / AI skill]
**Triggered by**: [What caused this? User request, bug discovery, new requirement, etc.]

### Changes
- [bullet: what specifically changed in SPEC.md or the architecture]

### Affected Phases
- PHASE_XX — [why it is affected]

### Contract Updates
- `CONTEXT.md` bumped from `vX.Y` to `vX.Z`
- [list schema / endpoint / type changes]

### Notes
[Trade-offs, decisions, context not captured elsewhere]

-->
