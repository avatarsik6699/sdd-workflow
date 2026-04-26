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

1. `/spec-init "describe required capabilities"`
2. `/phase-init 01`
3. Implement `PHASE_01` scope
4. `/phase-gate 01`
5. `/context-update 01`

## 4. Repeat by phase

- Keep each phase small and reviewable.
- Update SPEC first when requirements change (`/spec-sync`).
- Merge only when gate checks are green.

## Typical session

```text
/workflow-init /tmp/acme-app
/spec-init "B2B dashboard with billing and RBAC"
/phase-init 01
# implement
/phase-gate 01
/context-update 01
```
