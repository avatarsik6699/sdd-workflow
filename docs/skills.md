# Skills catalog

## `/workflow-init`

- Purpose: copy workflow assets into a target project
- Input: target project path
- Output: seeded docs, skill wrappers, hooks, and stack-specific gate command hints

## `/spec-init`

- Purpose: draft and validate `docs/SPEC.md`
- Typical use: first step in new product scope

## `/phase-init`

- Purpose: scaffold `docs/PHASE_XX.md` from `SPEC.md`
- Typical use: before implementation starts for each phase

## `/phase-gate`

- Purpose: execute stack gate commands and validate completion criteria
- Typical use: before merge/tag

## `/spec-sync`

- Purpose: propagate SPEC deltas to STATE/CONTEXT/CHANGELOG and phase docs
- Typical use: when requirements change mid-flight

## `/context-update`

- Purpose: reconcile docs after phase completion
- Typical use: after successful gate and before PR merge
