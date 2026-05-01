# Quickstart

## 1. Bootstrap the workflow into your project

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
/workflow-init /path/to/target-project
```

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
5. `/context-update 01` — mark phase done, bump CONTEXT.md version

### Optional: before-implementation planning

Before step 3, generate concrete per-task plans:

```
/impl-brief 01           # all tasks in phase 01
/impl-brief 01 B3        # single task
/impl-brief 01 backend   # all backend tasks
```

Plans are written to `docs/PHASE_01_NOTES.md § Implementation Plan` and can be reviewed before any code is written.

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
| **Agent-driven** | `/impl-brief 01` → review plans → `/impl-assist 01` |
| **Human-driven** | implement against scope checklist; check off tasks |
| **Hybrid** | agent: `/impl-brief 01 [ID]` → `/impl-assist 01 [ID]`; human: work directly |

## Typical session

```text
/workflow-init /tmp/acme-app
/spec-init "B2B dashboard with billing and RBAC"
/phase-init 01
/impl-brief 01
# review plans in docs/PHASE_01_NOTES.md
/impl-assist 01 backend
# implement frontend tasks yourself, check off as you go
/phase-gate 01
/context-update 01
/project-sync           # optional: push to GitHub board
```
