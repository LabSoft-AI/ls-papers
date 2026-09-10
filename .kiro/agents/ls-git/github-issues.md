# GitHub Issues — ls-papers

Convention for issues in the `ls-papers` repo.

## Language

Issues are written in **Serbian (Cyrillic)** per LabSoft convention. Titles,
descriptions, and acceptance criteria in Serbian Cyrillic. Only technical tags
(`[FEAT]`, `[BUG]`, labels) and code/command names stay in English.

## Format

```text
[TYPE] Кратак опис

## 📋 Опис
Јасан опис.

## 🎯 Проблем/Циљ
Шта решавамо.

## 💡 Предложено решење
Како.

## ✅ Acceptance Criteria
- [ ] Критеријум 1
- [ ] Критеријум 2

## 🏷️ Labels
- Type: [enhancement|bug|documentation|infrastructure|question]
- Priority: [priority/high|priority/medium|priority/low]
```

## Types

- `[FEAT]` — new content or feature (new paper, chapter, tooling)
- `[BUG]` — something is wrong (build fails, wrong citation)
- `[DOCS]` — documentation
- `[INFRA]` — CI, hosting, build tooling
- `[QUESTION]` — question

## Create via API

```bash
gh api repos/LabSoft-AI/ls-papers/issues \
  -f title="[FEAT] Наслов" \
  -f body="## 📋 Опис\n..." \
  -f 'assignees[]=Username' \
  -f 'labels[]=enhancement'
```

## Best Practices

- One issue = one paper/feature/fix. Split large work.
- Write testable acceptance criteria (paper builds, section complete, etc.).
- Reference related issues (`LabSoft-AI/world#1789` for the parent plan).
