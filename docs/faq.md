# FAQ

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
