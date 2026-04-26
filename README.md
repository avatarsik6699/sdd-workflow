# sdd-workflow

A stack-agnostic Spec-Driven Development workflow you can drop into any project — new or
existing. No CLI, no Python, no templates, no language runtime. Just markdown playbooks, agent
skill wrappers, and a single bootstrap skill.

## What you get

- 5 SDD skills in your project: `/spec-init`, `/phase-init`, `/phase-gate`, `/spec-sync`, `/context-update`
- A universal `AGENTS.md` (model-agnostic; reused by Claude Code, Codex, and any other agent)
- Wrappers for both Claude Code (`.claude/skills/`) and Codex (`plugins/sdd-workflow/`)
- Document scaffolds (`docs/SPEC.md`, `docs/STATE.md`, `docs/STACK.md`, `docs/CONTEXT.md`,
  `docs/CHANGELOG.md`, `docs/PHASE_TEMPLATE.md`, `docs/KNOWN_GOTCHAS.md`, `docs/DECISIONS.md`)
- An MCP config that wires Context7 for library lookups
- A safety hook (`scripts/block-dangerous-bash.sh`) for both runtimes

## Install

```bash
# 1. Clone this repo somewhere convenient (sibling to your project, /tmp, anywhere).
git clone https://github.com/<you>/sdd-workflow.git ~/tmp/sdd-workflow
cd ~/tmp/sdd-workflow

# 2. Open your agent in this directory and run the bootstrap skill, pointing at the target project.
#    Claude Code:
#      /workflow-init /path/to/your-project
#    Codex:
#      /workflow-init /path/to/your-project

# 3. The skill copies AGENTS.md, CLAUDE.md, .claude/skills/, plugins/sdd-workflow/,
#    docs/playbooks/, and seeded doc scaffolds into the target. It asks you for the
#    project name, owner, and the gate commands for your stack, then writes docs/STACK.md.

# 4. After it succeeds, you can delete the cloned sdd-workflow checkout — the workflow now
#    lives inside your project.
cd /path/to/your-project
# Open your agent here. The 5 SDD skills are now discoverable.
```

## Usage in the integrated project

Once `/workflow-init` has run, the project follows the standard SDD loop:

```
1. /spec-init "describe what you are building"
   → drafts and validates docs/SPEC.md

2. /phase-init 01
   → scaffolds docs/PHASE_01.md from SPEC.md

3. (architect fills Contracts + Files in PHASE_01.md, AI implements scope on feat/phase-01)

4. /phase-gate 01
   → runs the commands declared in docs/STACK.md#gate-commands and reports PASS/FAIL

5. /context-update 01
   → updates docs/CONTEXT.md, docs/STATE.md, docs/CHANGELOG.md

6. git commit + PR + merge to develop, tag v0.1.0

7. /phase-init 02 → repeat
```

If `docs/SPEC.md` changes mid-flight, run `/spec-sync "what changed"` to propagate the change to
CHANGELOG, STATE, CONTEXT, and any affected phase files before continuing.

## Why this is split out from project templates

This repo intentionally ships only the workflow. There are no FastAPI / Nuxt / React / Spring
snapshots here, no `sdd init` Python CLI, no `templates/<id>/source/` directories. That keeps the
workflow:

- **Cloneable into any stack** — Go, Rust, TypeScript, Python, anything.
- **Cheap to update** — re-run `/workflow-init` against the new clone; the skill overwrites only
  versioned wrappers and playbooks, never your `SPEC.md` or `STATE.md`.
- **Easy to read** — about 20 markdown files; no build step, no test suite to maintain.

For stack-specific scaffolds (FastAPI + Nuxt, FastAPI + React Router, etc.), see the separate
`sdd-template` repository or maintain your own internal templates.

## File map

- [docs/playbooks/](docs/playbooks/) — canonical workflow procedures (6 files)
- [docs/playbooks/workflow-init.md](docs/playbooks/workflow-init.md) — what `/workflow-init` does
- [project-files/](project-files/) — exact tree copied into target projects
- [project-files/AGENTS.md](project-files/AGENTS.md) — universal agent rules shipped to projects
- [.claude/skills/workflow-init/](.claude/skills/workflow-init/) — Claude Code bootstrap wrapper
- [plugins/sdd-workflow/](plugins/sdd-workflow/) — Codex bootstrap plugin
- [AGENTS.md](AGENTS.md) — rules for working on this repo (not for integrated projects)
- [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) — how to extend or modify the workflow

## License

MIT
