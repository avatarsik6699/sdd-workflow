# sdd-workflow

Практичный workflow Spec-Driven Development, который можно подключить к существующему репозиторию за несколько минут.

![Схема workflow](assets/workflow.png){ .hero-image }

## Быстрый старт

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
/workflow-init /path/to/target-project
cd /path/to/target-project
```

Дальше повторяйте цикл:

1. `/spec-init`
2. `/phase-init 01`
3. Реализация scope фазы
4. `/phase-gate 01`
5. `/context-update 01`

## Что даёт этот репозиторий

- Канонические playbooks (`docs/playbooks/`) с правилами процесса.
- Готовые обёртки для Claude Code и Codex.
- Шаблоны контрактной документации: SPEC, STATE, CONTEXT, CHANGELOG и фазы.
- Только workflow-ассеты через `git clone`: без CLI-пакета и без привязки к runtime.

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
