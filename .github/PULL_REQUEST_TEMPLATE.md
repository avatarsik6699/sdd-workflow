## Summary

- What changed?
- Why was this needed?

## Scope

- [ ] Playbook update (`docs/playbooks/*`) mirrored into `project-files/docs/playbooks/*`
- [ ] Wrapper interface changed (only if command/skill contract changed)
- [ ] Docs/templates updated (stack-agnostic rules preserved)

## Validation

- [ ] `markdownlint-cli2 "**/*.md"`
- [ ] `shellcheck scripts/*.sh project-files/plugins/sdd-workflow/scripts/*.sh`
- [ ] `lychee --config lychee.toml "**/*.md"`

## Checklist

- [ ] CHANGELOG updated (if user-visible)
- [ ] No stack-specific assumptions added to `project-files/AGENTS.md`
- [ ] No new runtime/build dependencies introduced
