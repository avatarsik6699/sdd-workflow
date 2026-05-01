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

### Обязательные шаги (каждая фаза)

1. `/spec-init "опишите необходимые возможности"` — создаёт `docs/SPEC.md`
2. `/phase-init 01` — генерирует `docs/PHASE_01.md` + `docs/PHASE_01_NOTES.md` с task ID
3. **Реализуйте scope** (пути реализации — см. ниже)
4. `/phase-gate 01` — автоматические проверки + architect review notes
5. `/context-update 01` — фаза помечается done, версия CONTEXT.md обновляется

### Опционально: планирование перед реализацией

Перед шагом 3 сгенерируйте конкретные планы по задачам:

```
/impl-brief 01           # все задачи в фазе 01
/impl-brief 01 B3        # одна задача
/impl-brief 01 backend   # все backend-задачи
```

Планы записываются в `docs/PHASE_01_NOTES.md § Implementation Plan` — их можно изучить до написания кода.

### Опционально: реализация силами агента

Вместо ручной реализации — поручите агенту:

```
/impl-assist 01          # реализовать все невыполненные задачи
/impl-assist 01 B3       # реализовать одну задачу
```

Агент читает Implementation Plan, проверяет фактический код (а не чекбокс), фиксирует каждую задачу и отмечает её в списке scope.

### Опционально: синхронизация с GitHub

Синхронизируйте чекбоксы задач с GitHub Issues и Kanban-доской Projects v2:

```
/project-sync --setup    # выполнить один раз, чтобы создать доску
/project-sync            # синхронизировать все фазы
/project-sync --dry-run  # предпросмотр без применения
```

## 4. Повторяйте по фазам

- Делайте фазы небольшими и удобными для ревью.
- При изменении требований сначала обновляйте SPEC, затем выполняйте `/spec-sync "[что изменилось]"`.
- Сливайте только после зелёных gate-проверок и когда все пункты architect review notes отмечены.

## Пути реализации

| Режим | Шаги |
| ----- | ---- |
| **Агент** | `/impl-brief 01` → проверить планы → `/impl-assist 01` |
| **Человек** | реализовать по списку scope, отмечать задачи |
| **Гибрид** | агент: `/impl-brief 01 [ID]` → `/impl-assist 01 [ID]`; человек: работает напрямую |

## Типичная сессия

```text
/workflow-init /tmp/acme-app
/spec-init "B2B dashboard with billing and RBAC"
/phase-init 01
/impl-brief 01
# просмотр планов в docs/PHASE_01_NOTES.md
/impl-assist 01 backend
# реализовать frontend самостоятельно, отмечать задачи по ходу
/phase-gate 01
/context-update 01
/project-sync           # опционально: отправить в GitHub-доску
```
