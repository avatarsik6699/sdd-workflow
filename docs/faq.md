# FAQ

## I see many skill files in the repo but only `/workflow-init` shows up as a command — why?

The 9 workflow skills (`/spec-init`, `/phase-init`, `/phase-explore`, etc.) live in
`project-files/.claude/skills/`. That directory is a template tree, not an active skills
directory — its contents are copied into a target project by `/workflow-init`. Once installed,
open an agent session inside your target project and all 9 skills will be available there.

From the `sdd-workflow` repo itself, only `.claude/skills/workflow-init/SKILL.md` is registered,
so only `/workflow-init` loads.

## The `/workflow-init` slash command doesn't appear in my AI interface — what do I do?

Slash commands auto-load only when the agent runtime reads `SKILL.md` files at session start.
This happens reliably in Claude Code CLI but may not happen in chat interfaces (claude.ai,
Cursor, Copilot, etc.).

Use the bootstrap prompt instead. With `/tmp/sdd-workflow` as your working directory, paste:

```
Read docs/playbooks/workflow-init.md and execute the workflow-init procedure.
Target project path: /absolute/path/to/your-project
```

This reads the canonical playbook directly and produces the same result.

## Is this tied to one stack?

No. The workflow is stack-agnostic and ships only markdown docs, wrappers, and shell hooks.

## Does this repository provide a CLI?

No. The workflow is invoked through agent skills/commands.

## Where does workflow logic live?

In `docs/playbooks/*.md` only. Wrappers must remain thin pointers.

## How do integrated projects upgrade?

Re-run `/workflow-init` from a fresh clone or a release tag. Versioned workflow files are overwritten safely.

## What should I do if requirements changed during a phase?

Update SPEC first, run `/spec-sync`, then continue phase planning and implementation.

## Where do I configure project-specific checks?

Inside the integrated project, in `docs/STACK.md#gate-commands`.
