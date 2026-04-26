# sdd-workflow

A practical Spec-Driven Development workflow you can plug into an existing repository in minutes.

![Workflow diagram](assets/workflow.png){ .hero-image }

## Start fast

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
/workflow-init /path/to/target-project
cd /path/to/target-project
```

Then repeat this cycle:

1. `/spec-init`
2. `/phase-init 01`
3. Implement phase scope
4. `/phase-gate 01`
5. `/context-update 01`

## What this repository provides

- Canonical playbooks (`docs/playbooks/`) with workflow rules.
- Ready wrappers for Claude Code and Codex.
- Documentation contract templates for SPEC, STATE, CONTEXT, CHANGELOG, and phases.
- Git clone only workflow assets: no CLI package, no runtime lock-in.

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
