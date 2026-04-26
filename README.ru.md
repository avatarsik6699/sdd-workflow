# sdd-workflow

[English](README.md) | [Русский](README.ru.md)

[![Lint](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/lint.yml/badge.svg)](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/lint.yml)
[![Links](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/links.yml/badge.svg)](https://github.com/avatarsik6699/sdd-workflow/actions/workflows/links.yml)
[![Release](https://img.shields.io/github/v/release/avatarsik6699/sdd-workflow)](https://github.com/avatarsik6699/sdd-workflow/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://avatarsik6699.github.io/sdd-workflow/)

Чистый, стек-агностичный workflow Spec-Driven Development, который можно подключить в любой репозиторий.
Он задаёт единый контракт документации, повторяемый цикл фаз и прозрачные критерии проверки, чтобы команда двигалась от требований к реализации без потери контекста.

![Превью sdd-workflow](preview.png)

## Начало работы

```bash
git clone https://github.com/avatarsik6699/sdd-workflow.git /tmp/sdd-workflow
cd /tmp/sdd-workflow
# Запускать в сессии агента:
/workflow-init /path/to/your-project
cd /path/to/your-project
```

Инициализируйте workflow в целевом проекте один раз, затем используйте этот цикл для каждой фазы:

1. `/spec-init`
2. `/phase-init 01`
3. Реализация scope фазы
4. `/phase-gate 01`
5. `/context-update 01`

## Схема процесса

![Схема workflow](docs/assets/workflow.png)

## Что вы получаете

- Канонические playbooks в `docs/playbooks/`, где описана процедура для каждого шага workflow.
- Обёртки для Claude Code и Codex (bootstrap и для интегрированного проекта), чтобы использовать один и тот же процесс в разных агентных средах.
- Фиксированный контракт документации (`SPEC.md`, `STATE.md`, `CONTEXT.md`, `CHANGELOG.md`, `PHASE_XX.md`), синхронизирующий план, реализацию и историю решений.
- Без CLI, без runtime-зависимостей и без build-манифеста: workflow поставляется как переносимый набор документации и обёрток.

## Как применяется workflow

В целевом репозитории первый шаг (`/workflow-init`) добавляет все необходимые файлы и skill-обёртки.
Дальше каждая фаза проходит одинаково: уточнение scope из SPEC, реализация только согласованного объёма, gate-проверка и обновление контекстных документов.
Такой цикл помогает удерживать границы задач и делает текущее состояние проекта понятным для всей команды.

## Где читать документацию

- Docs site (EN): <https://avatarsik6699.github.io/sdd-workflow/>
- Docs site (RU): <https://avatarsik6699.github.io/sdd-workflow/ru/>
- Быстрый старт: [docs/quickstart.md](docs/quickstart.md)
- FAQ: [docs/faq.md](docs/faq.md)
- Playbooks: [docs/playbooks/](docs/playbooks/)
- Руководство по вкладу: [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)

## Карта репозитория

- [docs/playbooks/](docs/playbooks/) — канонические процедуры workflow.
- [project-files/](project-files/) — дерево, копируемое в целевой проект.
- [.claude/skills/workflow-init/](.claude/skills/workflow-init/) — bootstrap-обёртка для этого репозитория.
- [plugins/sdd-workflow/](plugins/sdd-workflow/) — bootstrap-плагин для Codex.
- [AGENTS.md](AGENTS.md) — правила работы с этим репозиторием.

## Лицензия

MIT
