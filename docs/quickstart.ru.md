# Быстрый старт

## 1. Подключите workflow к проекту

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
/workflow-init /path/to/target-project
```

## 2. Перейдите в целевой проект

```bash
cd /path/to/target-project
```

## 3. Запустите рабочий цикл

1. `/spec-init "опишите необходимые возможности"`
2. `/phase-init 01`
3. Реализуйте scope `PHASE_01`
4. `/phase-gate 01`
5. `/context-update 01`

## 4. Повторяйте по фазам

- Делайте фазы небольшими и удобными для ревью.
- При изменении требований сначала обновляйте SPEC (`/spec-sync`).
- Сливайте только после зелёных gate-проверок.

## Типичная сессия

```text
/workflow-init /tmp/acme-app
/spec-init "B2B dashboard with billing and RBAC"
/phase-init 01
# implement
/phase-gate 01
/context-update 01
```
