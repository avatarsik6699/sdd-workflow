# Skills catalog

## Bootstrap

### `/workflow-init`

- Purpose: copy workflow assets into a target repository.
- Input: path to target project.
- Output: docs templates, wrappers, hooks, and stack gate placeholders.

## Core operating loop (inside integrated project)

### `/spec-init`

- Purpose: draft or refresh `docs/SPEC.md`.
- Use when: you start new scope or need to rewrite the contract.

### `/phase-init`

- Purpose: scaffold `docs/PHASE_XX.md` from current SPEC.
- Use when: you are preparing the next implementation slice.

### `/phase-gate`

- Purpose: run configured checks and completion criteria.
- Use when: phase is implemented and must be validated.

### `/context-update`

- Purpose: sync STATE/CONTEXT/CHANGELOG after a passed gate.
- Use when: phase is complete and ready for merge.

### `/spec-sync`

- Purpose: propagate SPEC changes into downstream docs.
- Use when: requirements changed mid-implementation.
