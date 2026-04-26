# FAQ

## Is this tied to one tech stack?

No. The workflow is stack-agnostic and ships only docs, wrappers, and shell hooks.

## Does this repository provide a CLI?

No. The workflow is invoked through agent skills.

## Where should workflow logic live?

In `docs/playbooks/*.md` only. Wrappers should stay thin and point to playbooks.

## How do integrated projects upgrade?

Re-run `/workflow-init` from a fresh clone or tag. Versioned workflow files are overwritten; project docs remain intact.
