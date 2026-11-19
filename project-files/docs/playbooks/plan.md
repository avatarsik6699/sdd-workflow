# plan — Canonical Playbook

Create or refresh `docs/SPEC.md` from a brief (chat text or a draft file), then scaffold exactly
one `docs/changes/NN-slug.md` from `docs/CHANGE_TEMPLATE.md` with a Backlog derived from the spec,
and switch to its feature branch.

This document is the single source of truth for the `plan` workflow.

In an integrated project, runtime wrappers under `.claude/skills/plan/SKILL.md` (Claude Code),
`.agents/skills/plan/SKILL.md` (generic agent), and `plugins/sdd-workflow/{commands,skills}/plan/...`
(Codex) point here. The wrappers are thin stubs — every workflow detail lives in this file.

## Input

- Optional free-form product brief (one paragraph to several pages).
- Optional file path (e.g. `/plan docs/DRAFT_SPEC.md`) — read the file as the primary source brief
  instead of asking for one in chat.
- Optional mode flag: `--new` (rewrite `docs/SPEC.md` end-to-end) or `--continue` (extend/refine
  the existing spec). If omitted: default to `new` when `docs/SPEC.md` is still mostly template
  placeholders, otherwise `continue`.

## Required reads

- `docs/SPEC.md`
- `docs/STACK.md`
- `docs/KNOWN_GOTCHAS.md` (if present)
- `docs/changes/` and `docs/changes/archive/` (existing change files, to pick the next `NN` and
  confirm nothing with the same slug already exists)
- The file at the given path, if one was passed as input

## Procedure

### 1. Determine the brief source and mode

- If a file path is given, read it in full and treat it as the source brief. Do not ask the
  architect to repeat it in chat.
- Otherwise use the chat-provided brief, or ask for one if none was given.
- Parse `--new` / `--continue`; if both given, stop and ask for exactly one. Resolve the default
  per the Input section otherwise. Record the chosen mode in the final report.
- Preserve explicit user wording for domain constraints and business rules — do not silently
  reinterpret strict requirements.

### 2. Build or refresh `docs/SPEC.md`

Only run this step if `docs/SPEC.md` doesn't exist yet, or the brief signals a spec-level change
(new domain area, changed contract, changed NFRs). A brief that only describes the next unit of
work against an already-adequate spec can skip this step. Apply step 3 independently for UI work.

- In `new` mode: rewrite the full document end-to-end.
- In `continue` mode: keep unaffected sections stable; modify only sections touched by the brief.

Target coverage (see `docs/SPEC.md`'s own section numbering):
1. Project Overview and Goals
2. Domain Context
3. Data Model
4. API/Backend Contract
5. Frontend/Client Contract (see step 3 for §5.3 Design System)
6. Auth & Access Model
7. Infrastructure and Deploy/CI
8. Non-Functional Requirements — start from the pre-seeded web checklist in the template
   (security headers/CORS, a11y target, Core Web Vitals budget, observability, backup/restore);
   don't leave a row blank, mark it `n/a` with a one-line reason if it doesn't apply
9. Roadmap (high-level milestones only — no task-level detail; that lives in change files)
10. Out of Scope
11. Open Questions

Rules:
- Replace placeholders and `[TODO]` markers with concrete content whenever the brief allows.
- Keep uncertain items explicit with `[NEEDS_CLARIFICATION: ...]` markers.
- Do not invent external constraints (compliance, SLOs, integrations) unless stated or inferred
  with high confidence from the brief.

### 3. Design flow (§5.3 Design System)

Apply this step when drafting the frontend contract or planning a change to visible or interactive
UI, including in `continue` mode.

- In an existing project, read §5.3 and inspect the relevant theme or token definitions, shared
  components, and representative screens. Use the established design as the starting point.
- If the brief includes design references, identify the relevant routes, components, layout, and
  interactions. Use them to inform §5.1 (Pages) and §5.2 (Components) when those contracts change.
  Link reusable references from §5.3 and change-specific references from the change file.
  Resolve material conflicts between a reference and the established design before implementation.
- If a project needs its first visual direction and the brief and references leave it open,
  propose 1–2 directions grounded in the domain and audience. Use the `frontend-design` skill
  when available and work from lightweight references. Ask up to five focused preference
  questions as needed (e.g. tone, default theme, density). Record the chosen direction and
  enough rules for the first UI tasks in §5.3.
- Keep §5.3 short. Record the established or chosen visual direction and link to the available
  sources that define the theme, tokens, and shared components. Record project-specific rules for
  choosing and composing components, with examples where useful. Put planned changes to shared
  design rules or components in the Backlog. Give dependent UI tasks the corresponding dependencies.

### 4. Run critical validation checks (spec-level, when step 2 ran)

1. **Completeness** — every required section has actionable, implementation-relevant content.
2. **Testability** — requirements are measurable (avoid vague terms like "fast"/"secure" without
   criteria).
3. **Consistency** — no conflicts between sections (auth model vs endpoint access, roadmap vs
   architecture).
4. **Contract readiness** — enough detail to derive a change file's Backlog (data model, endpoints,
   frontend modules, env vars).
5. **Risk coverage** — security/privacy, failure modes, operational constraints addressed.
6. **Roadmap viability** — milestones are incremental and buildable.

For each failed check, add a concrete issue to a temporary gap list, then ask focused clarification
questions (max 5 per round, grouped by theme), update `docs/SPEC.md`, and re-validate. Repeat until
no critical gaps remain, or the architect defers with an explicit `[NEEDS_CLARIFICATION: ...]`
marker.

### 5. Scaffold `docs/changes/NN-slug.md`

- Pick the next `NN` (two digits) by scanning `docs/changes/` and `docs/changes/archive/` for the
  highest existing number and incrementing.
- Derive a short kebab-case `slug` from the unit of work's title.
- Copy `docs/CHANGE_TEMPLATE.md` to `docs/changes/NN-slug.md` and fill it from the brief/spec:
  - **Backlog**: group items into Backend/Frontend/Infra/Data/Other, assign IDs sequentially per
    group (`B1`, `F1`, `I1`, `D1`, `T1`…), detect dependency ordering (migrations before models,
    models before routes, routes before tests), and format each as
    `- [ ] B2 [description] — _Depends on:_ B1` (or `—` if none). IDs are stable once assigned —
    never renumber; a removed item becomes `~~BN~~ (removed)`, never deleted outright.
  - **Files**: explicit create/modify list grouped as backend, frontend, infrastructure, plus any
    "do NOT touch" paths.
  - **Contracts**: link to the relevant SPEC sections and the Files list. Include §5 for UI work.
    Keep schema, endpoint, and type details in their source documents.
  - **Design and UI Acceptance**: for UI work, link to the applicable rules and references.
    Record checkable expectations for the layout, interaction, relevant states (e.g. loading or
    error), and supported viewports or themes affected by the change. Link the criteria to the
    corresponding Backlog IDs. If the project's template uses the older Design References
    section, carry relevant references into Design and UI Acceptance in the new change file.
    Omit this section when the change has no UI impact.
  - Leave Architect Review Notes at its default (`No architect review issues recorded`) and
    Implementation Notes empty.
  - Fill the Commit Message placeholder: `feat(change-[NN]): [title] — [2–4 key deliverables]`,
    under 72 chars.

If a subsection yields nothing, write `None` — never leave it blank or a generic TODO.

### 6. Git-flow: create the feature branch

- If not already on `feature/NN-slug`: create it from `main` and switch to it.
- If `main` has uncommitted changes that would be carried onto the new branch, warn and confirm
  before switching.

### 7. Report

```
## plan complete

SPEC.md: updated / unchanged — [reason]
Mode: [new | continue | auto->new | auto->continue]
Source brief: [chat / file: <path>]
Design: existing baseline / from references / new direction / n/a
Validation: PASS / PASS with deferred clarifications

Created: docs/changes/NN-slug.md
Branch: feature/NN-slug (created / switched to)

Backlog assigned:
- Backend:  [B1, B2, … or "none"]
- Frontend: [F1, F2, … or "none"]
- Infra:    [I1, … or "none"]
- Data:     [D1, … or "none"]
- Other:    [T1, … or "none"]

Deferred clarifications:
- [list or "none"]

Next: run /work [NN] (or /work [NN] [ID]) to implement Backlog items.
```

## Rules

- Never write to `docs/changes/archive/` from this workflow.
- Extract contracts by reference, not by hand-copying schema/endpoint text into the change file.
- Do not commit.
- Do not run the gate.

## Done when

- `docs/SPEC.md` is concrete, internally consistent, and buildable (or unchanged if this run
  didn't need to touch it).
- Exactly one new `docs/changes/NN-slug.md` exists with a Backlog assigned stable IDs.
- For UI work, §5.3 identifies the available design sources and the change file has checkable UI
  acceptance criteria.
- The feature branch for that change exists and is checked out.
