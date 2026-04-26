# sdd-workflow

Практичный workflow Spec-Driven Development для команд, которым нужны чёткие границы scope, предсказуемые этапы поставки и сохраняемый контекст проекта.

![Схема workflow](assets/workflow.png){ .hero-image }

## Начало работы

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
/workflow-init /path/to/target-project
cd /path/to/target-project
```

Инициализация выполняется один раз, затем для каждой фазы повторяется цикл:

1. `/spec-init`
2. `/phase-init 01`
3. Реализация scope фазы
4. `/phase-gate 01`
5. `/context-update 01`

## Что даёт этот репозиторий

- Канонические playbooks (`docs/playbooks/`), где зафиксированы процедуры каждого шага workflow.
- Готовые обёртки для Claude Code и Codex, позволяющие запускать один и тот же процесс в разных агентных средах.
- Шаблоны контрактной документации: SPEC, STATE, CONTEXT, CHANGELOG и фазовые файлы, чтобы синхронизировать планирование и реализацию.
- Workflow-ассеты, которые доставляются через `git clone`, без CLI-пакета и без привязки к runtime.

Репозиторий намеренно построен как documentation-first: процедурная логика хранится в playbooks, а обёртки остаются тонким интерфейсным слоем.

## Куда идти дальше

- [Быстрый старт](quickstart.md)
- [Каталог навыков](skills.md)
- [FAQ](faq.md)
- [Обзор плейбуков](playbooks/README.md)

## Быстрые ответы

### Это CLI-инструмент?

Нет. Команды работают как навыки/обёртки агента, а логика хранится в Markdown-плейбуках.

### Подойдёт ли для моего стека?

Да. Workflow стек-агностичен. Gate-команды задаются в `docs/STACK.md` уже в интегрированном проекте.
