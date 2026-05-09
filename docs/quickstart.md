# Quickstart

## 1. Bootstrap the workflow into your project

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
```

Open an AI agent session with `/tmp/sdd-workflow` as the working directory, then choose one of these options:

**Option A — slash command** (Claude Code CLI or Codex with the plugin loaded)

```
/workflow-init /absolute/path/to/target-project
```

**Option B — bootstrap prompt** (any AI: claude.ai chat, Cursor, Copilot, etc.)

```
Read docs/playbooks/workflow-init.md and execute the workflow-init procedure.
Target project path: /absolute/path/to/target-project
```

> The `/workflow-init` slash command auto-loads only when the agent runtime reads
> `.claude/skills/workflow-init/SKILL.md` at session start. The bootstrap prompt achieves the
> same result in any AI that has filesystem access to the cloned repo.

## 2. Enter your target project

```bash
cd /path/to/target-project
```

## 3. Run the operating loop

### Required steps (every phase)

1. `/spec-init "describe required capabilities"` — draft `docs/SPEC.md`
2. `/phase-init 01` — scaffold `docs/PHASE_01.md` + `docs/PHASE_01_NOTES.md` with task IDs
3. **Implement the scope** (see implementation paths below)
4. `/phase-gate 01` — validate automated checks + architect review notes
5. `/context-update 01` — mark phase done, sync CONTEXT.md and CHANGELOG.md

### Optional: before-implementation planning

Before step 3, explore the codebase per task and generate concrete plans:

```
/phase-explore 01        # explore all tasks (records patterns, constraints, risks)
/phase-explore 01 B3     # single task
/impl-brief 01           # generate implementation plans for all tasks in phase 01
/impl-brief 01 B3        # single task
/impl-brief 01 backend   # all backend tasks
```

`/phase-explore` runs before `/impl-brief` for non-trivial tasks. Plans are written to
`docs/PHASE_01_NOTES.md § Implementation Plan` and can be reviewed before any code is written.

### Optional: add unplanned tasks mid-phase

When you discover a task that was not in the original scope, describe it in one sentence:

```
/phase-add-task 01 "add filter by status to the user list endpoint"
```

The skill assigns the next task ID, derives any new contracts (DB columns, endpoints, types),
updates `PHASE_01.md` and `PHASE_01_NOTES.md`, then runs explore + impl-brief automatically.

### Optional: agent-assisted implementation

Instead of implementing manually, let the agent do it:

```
/impl-assist 01          # implement all unchecked tasks
/impl-assist 01 B3       # implement single task
```

The agent reads the Implementation Plan, verifies by actual code (not checkbox), commits per task, and checks off the Scope checklist.

### Optional: GitHub board sync

Sync task checkboxes to GitHub Issues and a Projects v2 Kanban board:

```
/project-sync --setup    # run once to create the board
/project-sync            # sync all phases
/project-sync --dry-run  # preview without applying
```

## 4. Repeat by phase

- Keep each phase small and reviewable.
- Update SPEC first when requirements change, then run `/spec-sync "[what changed]"`.
- Merge only when gate checks are green and all architect review notes are checked off.

## Implementation paths

| Mode | Steps |
| ---- | ----- |
| **Agent-driven** | `/phase-explore 01` → `/impl-brief 01` → review plans → `/impl-assist 01` |
| **Human-driven** | implement against scope checklist; check off tasks |
| **Hybrid** | agent: `/impl-brief 01 [ID]` → `/impl-assist 01 [ID]`; human: work directly |
| **Mid-phase discovery** | `/phase-add-task 01 "description"` → implement or `/impl-assist 01 [ID]` |

## Typical session

```text
/workflow-init /tmp/acme-app
/spec-init "B2B dashboard with billing and RBAC"
/phase-init 01
/phase-explore 01 backend   # optional: explore before planning
/impl-brief 01
# review plans in docs/PHASE_01_NOTES.md
/impl-assist 01 backend
# implement frontend tasks yourself, check off as you go
/phase-add-task 01 "add CSV export to user list"  # optional: unplanned task discovered mid-phase
/phase-gate 01
/context-update 01
/project-sync           # optional: push to GitHub board
```
