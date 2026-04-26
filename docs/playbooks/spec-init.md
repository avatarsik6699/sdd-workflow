# spec-init — Canonical Playbook

Create or refresh `docs/SPEC.md` from a high-level product brief, then run strict completeness and consistency checks with iterative clarifications until no critical gaps remain.

This document is the single source of truth for the `spec-init` workflow. Runtime wrappers point here.

## Input

- Optional free-form product brief (one paragraph to several pages).
- Optional mode flag in command arguments:
  - `--new`: start a new spec cycle and rewrite `docs/SPEC.md` end-to-end from the new brief.
  - `--continue`: extend/refine the existing spec as a continuation.

## Required reads

- `docs/SPEC.md`
- `docs/STACK.md`
- `docs/KNOWN_GOTCHAS.md` (if present)
- Existing phase files under `docs/PHASE_*.md` (if any)

## Procedure

### 1. Determine mode (`--new` vs `--continue`)

- Parse command arguments for `--new` / `--continue`.
- If both flags are present, stop and ask for exactly one mode.
- If no mode flag is provided:
  - If `docs/SPEC.md` is still mostly template placeholders, default to `new`.
  - Otherwise default to `continue` (safer non-destructive behavior).
- Record the chosen mode in the final report.

Mode intent:

- **new**: treat as a fresh planning cycle (major reset/re-baseline). Rewrite all sections to match the new brief.
- **continue**: preserve validated existing sections and update only impacted scope/contracts/phases from the new delta brief.

### 2. Capture or confirm the source brief

- If command arguments include a brief, use it as the initial source.
- If no brief is provided, ask the architect for a concise product brief before editing `docs/SPEC.md`.
- Preserve explicit user wording for domain constraints and business rules. Do not silently reinterpret strict requirements.

### 3. Request design assets (new mode, UI in scope)

Skip this step when mode is `continue` unless the brief explicitly introduces new screens.

Ask:

> "Do you have Figma screenshots for key screens (login, dashboard, main flows)? Attach them now and I'll use them to fill §5. If not, type 'skip'."

If screenshots are provided:

- For each screenshot, identify: the screen name, page route, key visible components, layout structure, and any notable interactions.
- Use this information to populate §5.1 (Pages) and §5.2 (Components) with concrete names and structure rather than generic placeholders.
- Add a `### 5.3 Design References` subsection listing each screen with a one-line note on what it depicts. Do not transcribe the screenshot in prose — capture only what is structurally useful for implementation.
- Do not invent screens not shown in the screenshots.

If skipped: fill §5 from the brief alone and leave `### 5.3 Design References` with a `<!-- none provided -->` comment.

### 4. Build the first complete SPEC draft

Update `docs/SPEC.md` so each section is concretely filled from the brief.

- In `new` mode: rewrite the full document end-to-end.
- In `continue` mode: keep unaffected sections stable; modify only sections touched by the new brief.

Target coverage:

- Product context, goals, and non-goals
- User roles/personas and core journeys
- Domain model and entities
- Backend/API scope and contracts
- Frontend scope and UX structure
- Infrastructure and operations assumptions
- Non-functional requirements (security, performance, observability, reliability)
- Phase plan with clear deliverables per phase

Rules:

- Replace placeholders and `[TODO]` markers with concrete content whenever the brief allows.
- Keep uncertain items explicit with `[NEEDS_CLARIFICATION: ...]` markers.
- Do not invent external constraints (compliance, SLOs, integrations) unless stated or inferred with high confidence from the brief.

### 5. Run critical validation checks

Validate the draft against this checklist:

1. **Completeness**: every required section has actionable, implementation-relevant content.
2. **Testability**: requirements are measurable or verifiable (avoid vague terms like "fast", "secure", "user-friendly" without criteria).
3. **Consistency**: no conflicts between sections (e.g., auth model vs endpoint access, phase scope vs architecture).
4. **Contract readiness**: enough detail exists to derive phase contracts (data model, endpoints, frontend modules, env vars).
5. **Risk coverage**: security/privacy, failure modes, and operational constraints are explicitly addressed.
6. **Phase viability**: phase sequence is incremental and buildable; each phase has a clear outcome and boundary.

For each failed check, add a concrete issue to a temporary gap list.

### 6. Ask focused clarification questions

If the gap list is non-empty:

- Ask only high-impact unresolved questions (max 5 per round).
- Group by theme (product, domain, API, frontend, infra, NFR).
- Use direct, answerable prompts. Prefer one expected answer per question.

After receiving answers:

- Update `docs/SPEC.md`.
- Re-run validation (step 5).
- Repeat until all critical gaps are resolved.

If the architect cannot answer now, keep explicit `[NEEDS_CLARIFICATION: ...]` markers and flag the related phases as blocked in the report.

### 7. Finalize and normalize the document

- Remove stale placeholders and contradictory statements.
- Keep wording concise and implementation-ready.
- Ensure phase numbering/order is coherent (`PHASE_01`, `PHASE_02`, ...).
- If phase files already exist and the updated SPEC changes scope/contracts, remind architect to run `spec-sync` immediately after `spec-init`.
- If all previously planned phases were already completed and mode is `continue`, ensure the phase plan clearly indicates newly added follow-up phases (for example new `PHASE_0X` entries).

### 8. Report

```
## spec-init complete

SPEC.md: updated
Mode: [new | continue | auto->new | auto->continue]
Source brief: [provided in arguments / provided via follow-up questions]
Validation: PASS / PASS with deferred clarifications
Clarification rounds: [count]

Resolved gaps:
- [list]

Deferred clarifications:
- [list or "none"]

Next:
1. Review and approve docs/SPEC.md.
2. If SPEC changed after phase docs already existed, run /spec-sync "[summary]".
3. Run /phase-init 01 (or next phase) once SPEC is approved.
```

## Rules

- Do not edit `docs/CONTEXT.md`, `docs/STATE.md`, or `docs/CHANGELOG.md` in this workflow.
- Do not scaffold phase files here. `phase-init` owns phase scaffolding.
- Do not commit.

## Done when

- `docs/SPEC.md` is concrete, internally consistent, and phase-plannable.
- Critical missing points are resolved, or explicitly marked as deferred clarifications.
