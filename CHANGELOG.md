# Changelog

## [Unreleased]

### Changed

- Simplified the workflow to agent-only coding: `spec-init`, `spec-sync`, `phase-init`,
  `impl-assist`, `impl-review-notes`, `phase-gate`, and `context-update`.
- Reworked phase notes into agent-owned execution memory.
- Replaced the public documentation site layer with a compact README and canonical playbooks only.

### Added

- `impl-review-notes` workflow for fixing unchecked Architect Review Notes after manual
  verification.

### Removed

- Unused planning/sync workflows and their wrappers.
- Public site scaffolding, examples, link-check automation, and repository governance files that
  are not needed for the workflow bundle.

## [0.1.0] - 2026-04-26

### Added

- Initial public baseline for `sdd-workflow` with canonical playbooks, project-file payload, and
  `/workflow-init` bootstrap wrappers for Claude Code and Codex.

[Unreleased]: https://github.com/avatarsik6699/sdd-workflow/compare/v0.1.0...main
[0.1.0]: https://github.com/avatarsik6699/sdd-workflow/releases/tag/v0.1.0
