# sdd-workflow

A practical Spec-Driven Development workflow for teams that want clear scope control, predictable delivery phases, and durable project context.

![Workflow diagram](assets/workflow.png){ .hero-image }

## Getting started

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
/workflow-init /path/to/target-project
cd /path/to/target-project
```

Initialize once, then repeat this cycle for each delivery phase:

1. `/spec-init`
2. `/phase-init 01`
3. Implement phase scope
4. `/phase-gate 01`
5. `/context-update 01`

## What this repository provides

- Canonical playbooks (`docs/playbooks/`) that define how each workflow step should be performed.
- Ready wrappers for Claude Code and Codex so the same process can run in different agent environments.
- Documentation contract templates for SPEC, STATE, CONTEXT, CHANGELOG, and phase files to keep planning and execution aligned.
- Git-clone-only workflow assets with no CLI package and no runtime lock-in.

This repository is intentionally documentation-first: implementation guidance lives in playbooks, while wrappers stay thin and interface-focused.

## Where to go next

- [Quickstart](quickstart.md)
- [Skills Catalog](skills.md)
- [FAQ](faq.md)
- [Playbooks Overview](playbooks/README.md)

## Quick answers

### Is this a CLI tool?

No. Commands are agent skills/wrappers, and logic lives in Markdown playbooks.

### Can I use it with my current stack?

Yes. The workflow is stack-agnostic. Gate commands are configured in `docs/STACK.md` inside the integrated project.
