---
name: ship
description: Run the Full Gate for a change; on PASS, commit, merge its feature branch into main, and archive the change file. With `--release`, also run the Release Gate, push origin/main, and verify the deploy via gh.
allowed-tools: Bash, Read
argument-hint: "[change number] [--release]"
---

You are running the SDD `ship` workflow.

**Arguments**: $ARGUMENTS

Execute the canonical playbook in [docs/playbooks/ship.md](../../../docs/playbooks/ship.md). The
executable commands live in `docs/STACK.md`'s Full Gate and Release Gate tables; do not duplicate
them here.

Do not edit code in this workflow — only run gate commands, and on PASS perform the commit, merge,
archive, and (with `--release`) push/deploy-verification steps described in the playbook.

If `$ARGUMENTS` is empty, infer the change number from the current `feature/NN-slug` branch; if
that fails, ask: "Which change should I ship? (e.g. /ship 01)"
