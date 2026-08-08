# CHANGE [XX] — [Change Title]

<!-- TOKEN BUDGET: keep this file under 10,000 tokens. Be concise. -->

## Change Metadata

| Field | Value |
|-------|-------|
| Change | `[XX]` |
| Slug | `[slug]` |
| Title | [Change Title] |
| Status | `active` |
| Branch | `feature/[XX]-[slug]` |

---

## Goal

<!-- 2–4 sentences: what does this change deliver and why does it matter?
     Link to a SPEC.md section if relevant. -->

---

## Design References

<!-- Optional. Populated by /plan when design assets (Figma, mockups, screenshots) are provided.
     Remove this section entirely if no design assets exist for this change.
     Format: `Screen name — brief description (key components, interactions)` -->

<!-- none provided -->

---

## Backlog

<!-- This list is OPEN, not a fixed scope: /work appends new items here when the architect reports
     findings/fixes/follow-ups mid-session — it does not fix them off-list.
     Group items by area (Backend / Frontend / Infra / Data, etc.).
     ID scheme: B=Backend · F=Frontend · I=Infra · D=Data · T=other (ungrouped)
     Each item: `ID` description — _Depends on:_ ID, ID or —
     IDs are stable after assignment — never renumber. Mark removed items as ~~BN~~ (removed).
     New items always take the next unused ID in their group, appended at the end. -->

### Backend
- [ ] `B1` [task] — _Depends on:_ —

### Frontend
- [ ] `F1` [task] — _Depends on:_ —

### Infra
- [ ] `I1` [task] — _Depends on:_ —

<!-- Test execution is governed by `docs/STACK.md`'s Fast Gate (per task) and Full Gate (per ship).
     Do not duplicate that list here. -->

---

## Files

### Create / modify
~~~
[list files relative to repo root]
~~~

### Do NOT touch
- [List files / directories out of scope for this change]

---

## Contracts

See `docs/SPEC.md` §3–§4 (and §5–§7 where relevant) and the Files list above. Do not hand-copy the
schema, endpoints, types, or env vars into this file — the codebase and `SPEC.md` are the source
of truth; this file only tracks what to build and what's left.

---

## Gate Checks

> Fast Gate runs per task in `/work`; Full Gate and (with `--release`) Release Gate run once in
> `/ship`. Both are defined in [docs/STACK.md](./STACK.md) — this section only records
> change-specific overrides.

If this change needs a custom smoke target or other change-specific note, record it here:

```bash
# Optional change-specific smoke override
# curl -s http://localhost:8000/api/v1/[your-endpoint]
# expected: [describe expected response]
```

---

## Architect Review Notes

Use this section after manual product, UX, API, or workflow verification. This is the human-facing
channel for post-implementation fixes.

Add one unchecked checkbox per issue the agent must fix before the change can ship. Keep each item
independently fixable and describe observed behavior plus expected behavior. If the fix may change
SPEC/API/schema/security behavior, say so explicitly in the note.

The agent resolves these items through `/work [XX] review`. Leave an item unchecked while it is
still open. Check it off only after the fix is implemented and re-verified. If manual verification
found nothing, keep the default checked line below.

- [x] No architect review issues recorded

---

## Implementation Notes

<!-- Optional. The agent adds a short bullet here only when something isn't already visible from
     the code or commit history: an intentional deviation from the plan, a residual risk, a
     rejected alternative. Leave empty when nothing needs recording — this is not a mandatory
     per-task log. -->

None

---

## Commit Message

```
feat(change-[XX]): [short description — what was built, not how]
```
