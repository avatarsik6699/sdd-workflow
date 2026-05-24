# sdd-workflow

Compact Spec-Driven Development workflow bundle for deterministic agent-only coding.

The repository has no CLI, runtime, package manager, or build manifest. It ships markdown
playbooks, agent rules, templates, and thin Claude/Codex wrappers that can be copied into any
target project.

## Install into a project

Clone this repository, open an agent session in the clone, then run:

```text
/workflow-init /absolute/path/to/your-project
```

For runtimes without slash-command support, use the canonical playbook directly:

```text
Read docs/playbooks/workflow-init.md and execute the workflow-init procedure.
Target project path: /absolute/path/to/your-project
```

After installation, work from the target project repository.

## Agent-only lifecycle

```text
1. /spec-init                         -> draft or refresh docs/SPEC.md
2. architect approves SPEC.md
3. /phase-init 01                     -> create phase contract and execution memory
4. /impl-assist 01                    -> agent implements scoped phase tasks
5. architect manually verifies product behavior
6. add unchecked Architect Review Notes if fixes are needed
7. /impl-review-notes 01              -> agent fixes review notes
8. repeat manual verification/fixes until clean
9. /phase-gate 01                     -> run gate checks
10. /context-update 01                -> finalize project memory
```

## Commands shipped to target projects

- `/spec-init`
- `/spec-sync`
- `/phase-init`
- `/impl-assist`
- `/impl-review-notes`
- `/phase-gate`
- `/context-update`

From this source repository, only `/workflow-init` is intended to run.

## Repository map

- `docs/playbooks/` — canonical workflow procedures.
- `project-files/` — exact tree copied into target projects by `/workflow-init`.
- `.claude/skills/workflow-init/` — bootstrap wrapper for Claude Code.
- `plugins/sdd-workflow/` — bootstrap wrapper for Codex.
- `scripts/` — shared safety scripts.
- `AGENTS.md` — rules for editing this repository.

## Release

This repo has a single version line. Tag `main` for releases:

```bash
git tag -a v1.0.0 -m "sdd-workflow v1.0.0"
git push origin v1.0.0
```

Integrated projects upgrade by re-running `/workflow-init` from a fresh clone of the desired tag.

## License

MIT
