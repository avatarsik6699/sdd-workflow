---
name: plan
description: Draft or refresh docs/SPEC.md from a brief (chat text or a draft file), then scaffold a new docs/changes/NN-slug.md with a Backlog and switch to its feature branch. Runs the self-driving design flow when no design references exist.
allowed-tools: Read, Write, Edit, Glob, Bash
argument-hint: "[--new | --continue] [brief text | path/to/draft.md]"
---

You are running the SDD `plan` workflow.

**Brief**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/plan.md](../../../docs/playbooks/plan.md). That
file is the source of truth for spec drafting/validation, the design flow, Backlog scaffolding, and
the git-flow branch step.

If `$ARGUMENTS` looks like a file path, read that file as the source brief instead of asking for
one in chat. If `$ARGUMENTS` is empty and no file is implied, ask the architect for a concise
brief before drafting `docs/SPEC.md`. If no mode flag is present, follow the canonical playbook's
auto-mode rule.
