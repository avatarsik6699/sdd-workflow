# sdd-workflow

[![Lint](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/lint.yml/badge.svg)](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/lint.yml)
[![Links](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/links.yml/badge.svg)](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/links.yml)
[![Release](https://img.shields.io/github/v/release/avatarsik6699/sdd-workflow)](https://github.com/avatarsik6699/sdd-workflow/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://avatarsik6699.github.io/sdd-workflow/)

A stack-agnostic Spec-Driven Development workflow you can drop into any project.
No CLI, no language runtime, no build manifest.

## Quickstart

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
# In your agent session:
/workflow-init /path/to/your-project
cd /path/to/your-project
```

After bootstrap, run `/spec-init`, `/phase-init`, `/phase-gate`, and `/context-update` in sequence.

## Demo run

```text
$ /workflow-init /tmp/acme-app
[workflow-init] copied AGENTS.md, CLAUDE.md, wrappers, playbooks, templates
[workflow-init] wrote docs/STACK.md with gate command placeholders
[workflow-init] complete
```

## Documentation

- GitHub Pages: <https://avatarsik6699.github.io/sdd-workflow/>
- Playbooks: [docs/playbooks/](docs/playbooks/)
- Contribution guide: [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)

## Who is this for?

- Teams that want a repeatable SDD loop without adopting a framework-specific template.
- Projects that need agent-agnostic workflow files (Claude Code, Codex, and others).

## Who is this NOT for?

- Teams expecting a project scaffolder, runtime CLI, or full starter boilerplate.
- Repositories that need framework-specific generators bundled in the workflow itself.

## File map

- [docs/playbooks/](docs/playbooks/) — canonical workflow procedures (6 files)
- [project-files/](project-files/) — exact tree copied into target projects
- [.claude/skills/workflow-init/](.claude/skills/workflow-init/) — Claude bootstrap wrapper
- [plugins/sdd-workflow/](plugins/sdd-workflow/) — Codex bootstrap plugin
- [AGENTS.md](AGENTS.md) — rules for working on this repo

## License

MIT
