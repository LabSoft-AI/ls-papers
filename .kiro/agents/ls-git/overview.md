# ls-git — ls-papers Git Agent

Quick reference for Git/GitHub conventions in the `ls-papers` repo.

## Common Workflows

### Full Issue Cycle
```bash
# 1. Create issue (Serbian Cyrillic body per convention)
gh api repos/LabSoft-AI/ls-papers/issues -f title="[FEAT] Опис" -f 'labels[]=enhancement' -f 'assignees[]=YourUsername'

# 2. Create branch
git checkout main && git pull origin main && git checkout -b feature/<name>

# 3. Work, commit
git add <files>
git commit -m "#<issue> feat(<scope>): description"

# 4. Push and create PR
git push -u origin feature/<name>
gh pr create --title "#<issue> [FEAT] Title" --body "## Related Issue\nRelates to #<issue>\n\n## Changes\n- ..."

# 5. Merge
gh pr merge <N> --squash --delete-branch --admin
```

### Quick Fix
```bash
git checkout main && git pull origin main && git checkout -b fix/<name>
# fix, commit, push
gh pr create && gh pr merge <N> --squash --delete-branch --admin
```

### Merge Main Into Branch (when out of date)
```bash
git fetch origin main
git merge origin/main --no-edit
git commit --no-verify --no-edit  # if hook blocks merge commit
git push
```

## Commit Types Quick Reference

| Type | When |
|------|------|
| `feat` | New content/feature (new chapter, new paper) |
| `fix` | Correction (typo, citation, figure) |
| `docs` | README / setup docs |
| `style` | Formatting only |
| `refactor` | Restructure without content change |
| `chore` | Maintenance, shared resources, configs |
| `ci` | CI/CD pipeline changes |

## Scope Reference

| Scope | Use |
|-------|-----|
| `<paper-folder>` | Changes to a specific paper (e.g. `luka-master`) |
| `shared` | Shared resources (templates, ieee.csl, build.mk) |
| `template` | The new-paper skeleton |
| `ci` | GitHub Actions build workflow |
| `readme` | Top-level docs |

## Label Reference

| Label | Use |
|-------|-----|
| `enhancement` | New content/features |
| `bug` | Corrections needed |
| `documentation` | Docs changes |
| `infrastructure` | CI, hosting, build tooling |
