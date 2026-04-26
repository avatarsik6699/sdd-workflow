# Repo hardening checklist

Трекер задач по доведению репозитория до «production-ready» состояния.
Отмечай галочкой по мере выполнения. Каждая секция упорядочена по приоритету: верх — максимум пользы за минимум усилий.

**Легенда:** `[ ]` — не начато · `[~]` — в работе · `[x]` — готово · `[-]` — решили не делать (пиши причину рядом)

**Прогресс:** 56 / 60

---

## 1. Корневые файлы-сигналы

- [x] `LICENSE` — выбрать лицензию (MIT / Apache-2.0 / BSD)
- [x] `CHANGELOG.md` — формат [Keep a Changelog](https://keepachangelog.com/)
- [x] `CODE_OF_CONDUCT.md` — Contributor Covenant
- [x] `SECURITY.md` — политика раскрытия уязвимостей
- [x] `SUPPORT.md` — куда обращаться за помощью
- [x] `CITATION.cff` — академические ссылки *(опционально)*
- [x] `CODEOWNERS` (`.github/CODEOWNERS`) — авто-ревьюеры по путям
- [x] Перенести `docs/CONTRIBUTING.md` → `.github/CONTRIBUTING.md` (или дублировать), чтобы GitHub подхватывал в UI

## 2. Папка `.github/`

### Шаблоны

- [x] `.github/ISSUE_TEMPLATE/bug_report.yml`
- [x] `.github/ISSUE_TEMPLATE/feature_request.yml`
- [x] `.github/ISSUE_TEMPLATE/question.yml`
- [x] `.github/ISSUE_TEMPLATE/config.yml` — отключить blank issues, дать ссылки на Discussions
- [x] `.github/PULL_REQUEST_TEMPLATE.md`
- [x] `.github/FUNDING.yml` *(опционально)*

### Автоматизация зависимостей

- [x] `.github/dependabot.yml` — обновления для GitHub Actions
- [-] (альтернатива) Renovate config — не нужен при включенном Dependabot

### CI workflows (`.github/workflows/`)

- [x] `lint.yml` — markdownlint
- [x] `lint.yml` — shellcheck для `scripts/`
- [x] `links.yml` — проверка битых ссылок (lychee)
- [x] `test.yml` — тесты скриптов (bats-core), если появятся
- [x] `release.yml` — теги/релизы (release-please или release-drafter)
- [x] `pages.yml` — деплой GitHub Pages

## 3. GitHub Pages (документация)

- [x] Выбрать генератор: MkDocs Material / Docusaurus / Starlight / VitePress
- [x] Создать конфиг (`mkdocs.yml` или аналог) с навигацией
- [x] Настроить тему и поиск
- [x] Подключить плагины: git-revision-date, mermaid, include-markdown
- [x] Лендинг-страница с диаграммой workflow (Mermaid)
- [x] Каталог skills с карточками и примерами
- [x] Quickstart «`workflow-init` за 60 секунд»
- [x] Глоссарий терминов SDD
- [x] FAQ
- [x] Включить Pages в Settings → Pages → Source: GitHub Actions
- [-] Кастомный домен *(опционально)* — отложено до публикации

## 4. README

- [x] Бейджи: CI status, license, latest release, docs link
- [x] Скриншот / GIF / asciinema с прогоном основных команд
- [x] Quickstart блок (3–5 команд до результата)
- [x] Ссылка на Pages-сайт
- [x] Раздел «Who is this for?» / «Who is this NOT for?»

## 5. Качество кода и автоматизация

- [x] `.editorconfig`
- [x] `.markdownlint.jsonc` + правила
- [x] `.pre-commit-config.yaml` (markdownlint, shellcheck, end-of-file-fixer, trailing-whitespace, check-merge-conflict)
- [x] `lychee.toml` — конфиг проверки ссылок
- [x] shellcheck-чистые скрипты в `scripts/`

## 6. Релизы и версионирование

- [x] Первый семантический тег (`v0.1.0`)
- [x] GitHub Releases с автозаполнением из CHANGELOG
- [x] release-please или release-drafter настроен
- [x] Файл `VERSION` или поле в манифесте, который копируется в `project-files/` при `workflow-init`
- [x] Документ «Compatibility / supported Claude Code versions» (`docs/compatibility.md`)

## 7. Настройки репозитория на GitHub

- [x] Description заполнено
- [x] Topics: `claude-code`, `agent-workflows`, `sdd`, `playbooks`, `spec-driven-development`
- [-] Social preview image (1280×640 PNG) — требуется действие в GitHub UI
- [x] Включить Discussions
- [x] Включить Private vulnerability reporting
- [x] Branch protection на `main`: require PR, require status checks
- [-] Pin важных issues/discussions (Roadmap, FAQ) — требуется действие в GitHub UI
- [x] Auto-delete head branches после merge

## 8. Доп. документация для этого репо

- [x] `docs/architecture.md` — связка `plugins/` ↔ `project-files/` ↔ `.claude/skills/` ↔ `docs/playbooks/` со схемой
- [x] `docs/roadmap.md` — что планируется
- [x] `docs/compatibility.md` — поддерживаемые версии Claude Code
- [x] `examples/` — мини-проект с уже влитым workflow для демо

---

## Журнал изменений по чек-листу

Краткие пометки, что и когда сделано, чтобы видеть динамику.

- `2026-04-26` — создан этот файл.
- `2026-04-26` — выполнены локальные шаги hardening: governance-файлы, `.github` templates/workflows, quality-конфиги, docs-site каркас, README, release/versioning.
- `2026-04-26` — отмечены шаги, требующие ручной настройки через GitHub UI.
- `2026-04-26` — выполнены GitHub-настройки через `gh api`: Pages (GitHub Actions), description/homepage/topics, Discussions, private vulnerability reporting, branch protection, auto-delete branch on merge.
