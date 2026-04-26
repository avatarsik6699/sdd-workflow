# workflow-init in 60 seconds

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
# Run in your agent session:
/workflow-init /path/to/target-project
cd /path/to/target-project
```

After bootstrap, run:

1. `/spec-init "describe feature set"`
2. `/phase-init 01`
3. Implement phase scope
4. `/phase-gate 01`
5. `/context-update 01`
