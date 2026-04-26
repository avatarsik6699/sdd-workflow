# PHASE [XX] — [Phase Title]

<!-- TOKEN BUDGET: keep this file under 10,000 tokens. Be concise. -->

## Phase Metadata

| Field | Value |
|-------|-------|
| Phase | `[XX]` |
| Title | [Phase Title] |
| Status | `⏳ pending` |
| Tag | `v0.[XX].0` |
| Depends on | PHASE_[XX-1] gate passing |
| CONTEXT.md version | `[VERSION — snapshot at time of writing, e.g. v1.1]` |

---

## Phase Goal

<!-- 2–4 sentences: what does this phase deliver and why does it matter?
     Link to a SPEC.md section if relevant. -->

---

## Design References

<!-- Optional. Populated by /phase-init when design assets (Figma, mockups, screenshots) are provided.
     Remove this section entirely if no design assets exist for this phase.
     Format: `Screen name — brief description (key components, interactions)` -->

<!-- none provided -->

---

## Scope

<!-- Group tasks by area (Backend / Frontend / Infra / Data, etc.) or list flat — match what fits
     this project. Each item is one checkbox. -->

- [ ] [task]

<!-- Test execution is governed by `## Gate Checks` below + docs/STACK.md § Gate Commands.
     Do not duplicate that list here. -->

---

## Files

### Create / modify
~~~
[list files relative to repo root]
~~~

### Do NOT touch
- [List files / directories out of scope for this phase]

---

## Contracts

> This section is the source of truth for `/context-update`. Fill it in **before** handing to AI.

### New persistent data (tables / collections / files)

None
<!-- Replace with concrete schema when this phase introduces any. -->

### New API endpoints / RPC methods / events

None
<!-- Replace with a table when this phase introduces any:
| Method | Path / Topic | Auth | Response / Payload |
|--------|--------------|------|---------------------|
| `GET` | `/api/v1/[path]` | JWT | `{"field": type}` |
-->

### New types / models / shared interfaces

None

### New env vars

None
<!-- Replace with a table when this phase introduces any:
| Key | Example value | Required |
|-----|---------------|----------|
| `VAR_NAME` | `value` | yes |
-->

---

## Gate Checks

Run `/phase-gate [XX]` before committing.

`/phase-gate` returns full PASS only when:
- Automated checks are green
- All architect review items below are resolved (checked off)

Use the commands in [docs/STACK.md](./STACK.md#gate-commands) as the source of truth for:
- infrastructure / bootstrap
- migrations (if applicable)
- backend / unit tests
- frontend prep, type-check, unit tests (if a frontend exists)
- e2e (if an e2e suite exists)
- the default smoke check

If this phase needs a custom smoke target or other phase-specific note, record it here:

```bash
# Optional phase-specific smoke override
# curl -s http://localhost:8000/api/v1/[your-endpoint]
# expected: [describe expected response]
```

---

## Architect Review Notes

Use this section after manual verification. Add one checkbox item per issue the architect wants
fixed before the phase can close. Leave the item unchecked while it is still open. Check it off
only after the fix is implemented and re-verified.
If manual verification found nothing, keep the default checked line below.

- [x] No architect review issues recorded

---

## Atomic Commit Message

```
feat(phase-[XX]): [short description — what was built, not how]
```

---

## Post-Phase Checklist

- [ ] All automated gate checks green
- [ ] All architect review notes resolved
- [ ] `docs/CONTEXT.md` updated — run `/context-update [XX]`
- [ ] `docs/STATE.md` phase row updated to `✅ done`
- [ ] `docs/CHANGELOG.md` entry added (if CONTEXT.md version bumped)
- [ ] Committed atomically on `feat/phase-[XX]` branch
- [ ] Tag created after merge to develop: `git tag -a v0.[XX].0 -m "Phase [XX]: [title]"`
