# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Hardening baseline across repository policy and governance files:
  `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `CITATION.cff`, `VERSION`.
- GitHub community and contribution assets:
  `.github/CONTRIBUTING.md`, issue templates, PR template, `CODEOWNERS`, and `FUNDING.yml`.
- CI and automation workflows:
  `lint.yml` (markdownlint + shellcheck), `links.yml` (lychee), `test.yml` (bats detection/run),
  `release.yml` (release-drafter + changelog-based GitHub releases), and `pages.yml`.
- Dependency automation via `.github/dependabot.yml` for GitHub Actions.
- Repository quality configs:
  `.editorconfig`, `.markdownlint.jsonc`, `.markdownlint-cli2.jsonc`, `.pre-commit-config.yaml`, `lychee.toml`.
- Documentation site scaffolding with MkDocs Material (`mkdocs.yml`) and new pages:
  `docs/index.md`, `docs/quickstart.md`, `docs/skills.md`, `docs/glossary.md`, `docs/faq.md`.
- Additional repo documentation:
  `docs/architecture.md`, `docs/roadmap.md`, `docs/compatibility.md`, and `examples/minimal-sdd-project/README.md`.
- README hardening updates (badges, quickstart, docs link, audience fit sections).

## [0.1.0] - 2026-04-26

### Added

- Initial public baseline for `sdd-workflow` with canonical playbooks, project-file payload,
  and `/workflow-init` bootstrap wrappers for Claude Code and Codex.

[Unreleased]: https://github.com/avatarsik6699/sdd-workflow/compare/v0.1.0...main
[0.1.0]: https://github.com/avatarsik6699/sdd-workflow/releases/tag/v0.1.0
