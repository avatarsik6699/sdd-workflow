# sdd-workflow

Spec-Driven Development workflow bundle for deterministic agent-only coding, specialized for
**web applications** (frontend + backend + database).

The repository has no CLI, runtime, package manager, or build manifest. It ships markdown
playbooks, agent rules, templates, and thin Claude/Codex/generic-agent wrappers that can be copied
into any target project.

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
1. Architect provides a brief (chat text or a draft file, e.g. docs/DRAFT_SPEC.md)
2. /plan ["brief" | path/to/draft.md]  -> draft/refresh docs/SPEC.md, scaffold
                                          docs/changes/NN-slug.md, create feature/NN-slug
3. architect approves docs/SPEC.md (first time / on pivots only)
4. /work NN                            -> agent implements Backlog items, absorbing any
                                          findings the architect reports mid-session,
                                          running the Fast Gate per item
5. architect manually verifies product behavior
6. add unchecked Architect Review Notes if fixes are needed
7. /work NN review                     -> agent fixes review notes; repeat 5-7 until clean
8. /ship NN                            -> Full Gate; on PASS: merge feature branch to main,
                                          archive the change
9. /ship NN --release                  -> Release Gate; push origin/main; verify the deploy via gh
```

## Commands shipped to target projects

- `/plan` — draft/refresh `docs/SPEC.md` and scaffold a new `docs/changes/NN-slug.md` with its
  feature branch (also runs a self-driving design flow when no design references exist)
- `/work` — implement Backlog tasks (default) or fix Architect Review Notes
  (`/work [XX] review`), absorbing mid-session findings into the Backlog and running the Fast Gate
- `/ship` — run the Full Gate, merge to `main`, archive the change, and (with `--release`) push
  and verify the deploy via `gh`

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
git tag -a v0.3.0 -m "sdd-workflow v0.3.0"
git push origin v0.3.0
```

Integrated projects upgrade by re-running `/workflow-init` from a fresh clone of the desired tag —
`/workflow-init` detects and offers to migrate older doc shapes (including the previous
`STATE.md` + `PHASE_XX.md` generation) into the current `docs/changes/` + `docs/changes/archive/`
layout.

## License

MIT
