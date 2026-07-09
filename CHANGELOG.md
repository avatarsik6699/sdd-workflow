# Changelog

## [Unreleased]

### Changed

- Second simplification pass, targeting per-project document bloat: 6 skills instead of 7
  (`spec-init`, `spec-sync`, `phase-init`, `impl-assist`, `phase-gate`, `context-update`).
  `/impl-assist [XX] review` now handles Architect Review Notes, replacing the separate
  `impl-review-notes` skill.
- Merged `STATE.md`, `CONTEXT.md`, `CHANGELOG.md`, and `DECISIONS.md` into a single per-project
  `docs/STATE.md` (Phase Status + Current Contract + append-only Project Log). `spec-sync` and
  `context-update` now touch one file instead of three.
- `workflow-init` gained a migration step that detects the old four-file shape (or legacy
  `PHASE_*_NOTES.md` files) in an already-integrated project and offers to fold them into the new
  `STATE.md` losslessly, rather than leaving them orphaned on upgrade.
- Simplified the workflow to agent-only coding: `spec-init`, `spec-sync`, `phase-init`,
  `impl-assist`, `phase-gate`, and `context-update`.
- Replaced the public documentation site layer with a compact README and canonical playbooks only.

### Removed

- `docs/PHASE_XX_NOTES.md` — the unbounded, mandatory per-task agent execution-memory file.
  Replaced by an optional, short **Implementation Notes** section directly in `PHASE_XX.md`,
  written only when something isn't already visible from the code or commit history.
- `docs/CONTEXT.md`, `docs/CHANGELOG.md`, `docs/DECISIONS.md`, and `docs/PHASE_NOTES_TEMPLATE.md`
  as separate shipped templates (merged into `docs/STATE.md`, see above).
- `impl-review-notes` skill and playbook (merged into `impl-assist`).
- Unused planning/sync workflows and their wrappers.
- Public site scaffolding, examples, link-check automation, and repository governance files that
  are not needed for the workflow bundle.

## [0.1.0] - 2026-04-26

### Added

- Initial public baseline for `sdd-workflow` with canonical playbooks, project-file payload, and
  `/workflow-init` bootstrap wrappers for Claude Code and Codex.

[Unreleased]: https://github.com/avatarsik6699/sdd-workflow/compare/v0.1.0...main
[0.1.0]: https://github.com/avatarsik6699/sdd-workflow/releases/tag/v0.1.0
