# project-sync — Canonical Playbook

Mirror the current state of all `docs/PHASE_XX.md` task checkboxes to GitHub Issues and a GitHub
Projects v2 Kanban board. Idempotent — safe to run on every commit or on demand.

This document is the single source of truth for the `project-sync` workflow.

In an integrated project, runtime wrappers under `.claude/skills/project-sync/SKILL.md` (Claude
Code) and `plugins/sdd-workflow/{commands,skills}/project-sync/…` (Codex) point here. The wrappers
are thin stubs — every workflow detail lives in this file.

## Input

```
/project-sync                   — sync all phases to the GitHub board
/project-sync [XX]              — sync single phase (two-digit, e.g. 01)
/project-sync --dry-run         — print diff without applying any changes
/project-sync --setup           — create GitHub Project + columns + sdd-workflow label; write config to docs/STACK.md
/project-sync [XX] --dry-run    — dry-run for a single phase
```

- `XX` — zero-padded phase number (e.g. `01`). If omitted, all discovered `docs/PHASE_XX.md` files
  are processed.
- `--dry-run` — compute and print the full change queue but do not call any GitHub write API.
- `--setup` — one-time initialisation: creates a GitHub Project, status columns, and the
  `sdd-workflow` label; writes config to `docs/STACK.md § GitHub Project`. Must be run before the
  first sync.

## Source of truth

The markdown files are always the source of truth. The GitHub board is a read-only view.
Writing back from GitHub to markdown (e.g. issue closed on GitHub → uncheck box) is out of scope
to avoid two-source-of-truth problems.

## Required reads

- `docs/PHASE_XX.md` (all, or specified) — task checkboxes and phase status
- `docs/STATE.md` — phase status cross-check (informational only)
- `docs/STACK.md § GitHub Project` — project number and field IDs written by `--setup`

## Idempotency mechanism

Every GitHub Issue created by this workflow has a hidden marker in its body:

```
<!-- sdd-sync: PHASE_01/B1 -->
```

On every run the workflow fetches all issues labelled `sdd-workflow`, parses their markers, builds
a lookup map `(PHASE_XX/KEY) → {issue_number, state, project_item_id}`, diffs against current
markdown state, and applies only the delta.

## Task key derivation

- If a scope item contains an explicit bracket ID (e.g. `**[B1]**`, `[F2]`, `[I3]`): use that as
  the key verbatim (e.g. `B1`, `F2`).
- Otherwise: derive a positional key `T01`, `T02`, … (sequential index within `## Scope`, 1-based,
  zero-padded to two digits).
- Key format in the marker: `PHASE_XX/B1` or `PHASE_XX/T01`.

## Status → Project column mapping

| Markdown state | Project column |
|----------------|----------------|
| task `[ ]`, phase `⏳ pending` | Todo |
| task `[ ]`, phase `🔄 in-progress` | In Progress |
| task `[ ]`, phase `⚠️ NEEDS_REVIEW` | Needs Review |
| task `[ ]`, phase `❌ blocked` | Blocked |
| task `[x]` (any phase status) | Done |

## Full lifecycle operations

| Trigger | Operation |
|---------|-----------|
| Task in markdown, no matching issue | Create issue + add to project + set column |
| Task title changed (same key) | Update issue title |
| Task `[ ]`, matching issue is closed (not `sdd-removed`) | Reopen issue + set column |
| Task `[x]`, matching issue is open | Close issue + set column to Done |
| Issue column differs from expected | Set column |
| Task removed from `## Scope` | Close issue + add label `sdd-removed` |
| No change | No-op |

## Procedure

### Step 1 — Prerequisite check

1. If `--setup` flag is present: run the **Setup sub-procedure** (§ below), then stop.
2. Check `gh auth status`. If not authenticated, stop:
   > "Not authenticated. Run `gh auth login` first, then re-run `/project-sync`."
3. Confirm remote is GitHub: `git remote get-url origin`. Extract `<owner>/<repo>`. If the remote
   is not a github.com URL, stop with a clear message.
4. Read `docs/STACK.md § GitHub Project`. If the section does not exist, stop:
   > "GitHub Project not configured. Run `/project-sync --setup` first."
5. Extract from the section: `project_number`, `status_field_id`, and option IDs for each column
   (Todo, In Progress, Needs Review, Blocked, Done).

### Step 2 — Parse markdown state

1. Discover phase files: `docs/PHASE_XX.md` matching the pattern (all, or only the specified `XX`).
2. For each phase file extract:
   - `phase_number` — from filename (e.g. `01`)
   - `phase_title` — from the `# PHASE XX — …` header line
   - `phase_status` — from the `Status` row of `## Phase Metadata` table (emoji + word)
   - `scope_items[]` — every `- [ ]` or `- [x]` line under `## Scope`:
     - `key` — explicit `[ID]` from the line if present, else `T<NN>` (positional)
     - `title` — text of the checkbox item, stripped of the ID prefix
     - `checked` — `true` if `[x]` or `[X]`, `false` if `[ ]`

### Step 3 — Fetch GitHub state

1. Run:
   ```bash
   gh issue list --repo <owner>/<repo> --label sdd-workflow --state all --limit 500 \
     --json number,title,state,body,labels
   ```
2. For each issue, parse `<!-- sdd-sync: PHASE_XX/KEY -->` from the body.
3. Build lookup map: `(PHASE_XX/KEY) → {number, state}`.
4. To get `project_item_id` for column updates: query the project's items via
   `gh project item-list <project_number> --owner <owner> --format json --limit 500` and join on
   issue URL.

### Step 4 — Compute diff

For each scope item in each phase file:

1. Compute `target_column` from the status mapping table above.
2. Look up `(PHASE_XX/KEY)` in the GitHub map:
   - **Not found** → QUEUE `create`
   - **Found, title differs** → QUEUE `update-title`
   - **Found, issue closed (not `sdd-removed`) + task unchecked** → QUEUE `reopen`
   - **Found, issue open + task checked** → QUEUE `close`
   - **Found, open + unchecked, column differs from target** → QUEUE `set-column`
   - **Otherwise** → no-op

For each GitHub issue whose `(PHASE_XX/KEY)` is NOT present in any parsed phase file:

- If issue does NOT already have label `sdd-removed` → QUEUE `archive`

### Step 5 — Dry-run check

If `--dry-run` was passed: print the full diff queue (all queued operations with their type,
phase, key, and title). Print a summary count per operation type. Stop. Do not call any write API.

### Step 6 — Apply changes

Execute queued operations in this order: `create` → `update-title` → `archive` → `close` →
`reopen` → `set-column`.

**create**

```bash
gh issue create \
  --repo <owner>/<repo> \
  --title "[PHASE_XX][KEY] <title>" \
  --body "<!-- sdd-sync: PHASE_XX/KEY -->
**Phase:** PHASE_XX — <phase_title>
**Task ID:** KEY

---
_Synced from \`docs/PHASE_XX.md\` by \`/project-sync\`_" \
  --label sdd-workflow \
  --label phase-XX
```

Then add to project and set column:

```bash
gh project item-add <project_number> --owner <owner> --url <issue_url>
gh project item-edit --project-id <project_id> --id <item_id> \
  --field-id <status_field_id> --single-select-option-id <target_option_id>
```

**update-title**

```bash
gh issue edit <number> --repo <owner>/<repo> --title "[PHASE_XX][KEY] <new_title>"
```

**archive** (task removed from scope)

```bash
gh issue edit <number> --repo <owner>/<repo> --add-label sdd-removed
gh issue close <number> --repo <owner>/<repo>
```

**close** (task completed in markdown)

```bash
gh issue close <number> --repo <owner>/<repo>
gh project item-edit ... --single-select-option-id <done_option_id>
```

**reopen** (task unchecked in markdown, issue was closed)

```bash
gh issue reopen <number> --repo <owner>/<repo>
gh project item-edit ... --single-select-option-id <target_option_id>
```

**set-column** (column out of sync)

```bash
gh project item-edit --project-id <project_id> --id <item_id> \
  --field-id <status_field_id> --single-select-option-id <target_option_id>
```

### Step 7 — Report

```
## project-sync complete

Phase(s): PHASE_01, PHASE_02
GitHub repo: <owner>/<repo>  |  Project: #<N>

Created:   3 issues
Updated:   1 issue title
Closed:    2 issues (done)
Reopened:  0
Archived:  1 issue (removed from scope)
Column:    4 issues re-placed
No-op:     12 issues

Next: view board at https://github.com/orgs/<owner>/projects/<N>
  or run `/project-sync --dry-run` to preview future changes.
```

---

## Setup sub-procedure (`--setup`)

Run once per project before the first `/project-sync`.

1. Check `docs/STACK.md` for an existing `## GitHub Project` section. If found, ask the user
   to confirm overwrite before continuing.
2. Determine `<owner>` from `git remote get-url origin`.
3. Create the GitHub Project:
   ```bash
   gh project create --owner <owner> --title "<ProjectName> Board" --format json
   ```
   Capture `project_number` and `project_id` from output.
4. Add a single-select Status field with five options — **Todo**, **In Progress**,
   **Needs Review**, **Blocked**, **Done** — using the GraphQL mutation
   `addProjectV2SingleSelectField` via `gh api graphql`.
5. Fetch the field ID and option IDs:
   ```bash
   gh project field-list <project_number> --owner <owner> --format json
   ```
6. Create the `sdd-workflow` label if it does not exist:
   ```bash
   gh label create sdd-workflow --color 0075ca --repo <owner>/<repo>
   ```
7. Append (or replace) `## GitHub Project` section in `docs/STACK.md`:
   ```markdown
   ## GitHub Project

   | Key | Value |
   |-----|-------|
   | Project number | `<N>` |
   | Project ID | `<PVT_xxx>` |
   | Status field ID | `<PVTSSF_xxx>` |
   | Option: Todo | `<opt-id-todo>` |
   | Option: In Progress | `<opt-id-inprogress>` |
   | Option: Needs Review | `<opt-id-needsreview>` |
   | Option: Blocked | `<opt-id-blocked>` |
   | Option: Done | `<opt-id-done>` |
   ```
8. Report: "Setup complete. Run `/project-sync` to perform the first sync."

---

## Rules

- Never modify any `docs/PHASE_XX.md` or other markdown file.
- Never hard-delete GitHub Issues — only close + label `sdd-removed`.
- `--dry-run` must not call any write API. All reads are allowed.
- If any `gh` command fails (network, auth, rate limit): stop immediately. Print the failed
  command and the error. Do not silently swallow errors or skip remaining items.
- Cap issue body at 2 000 characters. Truncate with `…(see docs/PHASE_XX.md)` if needed.
- If `docs/STACK.md` has no `## GitHub Project` section and `--setup` was not passed: stop with
  the prescribed message from Step 1. Do not create the section automatically.
- Issues labelled `sdd-removed` are never reopened by the sync, even if a task with the same
  key reappears (treat as a new task → create a new issue).

## Done when

- `--setup`: `docs/STACK.md § GitHub Project` exists with all field IDs filled.
- Sync: all scope items from targeted phase files have a corresponding open or closed GitHub Issue
  with the correct sync marker, title, column placement, and open/closed state.
- The report lists created, updated, closed, reopened, archived, column-changed, and no-op counts.
