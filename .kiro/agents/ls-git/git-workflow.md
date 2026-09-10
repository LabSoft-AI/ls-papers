# Git Workflow — ls-papers

Branching and commit conventions for the `ls-papers` repo.

## Branch Strategy

- **`main`** — stable, buildable papers
- **`feature/*`** — new content or features
- **`fix/*`** — corrections
- **`chore/*`** — maintenance

### Branch Naming

```bash
feature/luka-master-intro
fix/ieee-citation-format
chore/update-pandoc-makefile
```

Rules: lowercase with hyphens, short but descriptive, no issue numbers in
branch names (use commits instead).

## Commit Convention

[Conventional Commits](https://www.conventionalcommits.org/) with issue
reference and mandatory scope:

```
#<issue-number> <type>(<scope>): <description>
```

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New content/feature | `#3 feat(luka-master): add methodology chapter` |
| `fix` | Correction | `#5 fix(shared): correct IEEE csl author format` |
| `docs` | Docs | `#8 docs(readme): add pandoc setup steps` |
| `chore` | Maintenance | `#12 chore(shared): bump pandoc-crossref` |
| `ci` | CI changes | `#6 ci(build): cache TeX Live` |

Scope is mandatory, lowercase with hyphens. Usually the paper folder name,
or `shared` / `template` / `ci` / `readme`.

### Issue Closing Policy

Do NOT use auto-close keywords (`Closes`, `Fixes`, `Resolves`). Close issues
manually after the work is verified (paper builds, content reviewed).

## Pull Request Process

```bash
# 1. Create GitHub issue
# 2. Branch from latest main
git checkout main && git pull origin main && git checkout -b feature/<name>

# 3. Work and commit
git add <files>
git commit -m "#<issue> feat(<scope>): description"

# 4. Push and open PR
git push -u origin feature/<name>
gh pr create --title "#<issue> [FEAT] Title" --body "..."

# 5. Merge after CI green
gh pr merge <N> --squash --delete-branch --admin
```

## Build Verification

Before pushing, verify the paper builds:
```bash
make paper=<folder>          # build one paper (pdf/docx/odt)
```

CI also builds on every push. Do not commit build output (`public/` is
gitignored).
