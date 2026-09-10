# Pull Requests — ls-papers

Convention for PRs in the `ls-papers` repo.

## Title Format

```
#<issue-number> [TYPE] Brief descriptive title
```

Examples:
- `#3 [FEAT] Luka master — introduction chapter`
- `#5 [FIX] Correct IEEE citation format in shared csl`

## Description Template

```markdown
## Related Issue
Relates to #<issue>

## Changes
- Change 1
- Change 2

## Testing
- [ ] Paper builds locally (make paper=<folder>)
- [ ] PDF/DOCX/ODT output correct
```

**Use `Relates to` (not `Closes`)** so the issue stays open until the work is
verified. Close manually after verification.

## Process

1. Push branch: `git push -u origin feature/<name>`
2. Create PR: `gh pr create --title "..." --body "..."`
3. Wait for CI (build) to pass
4. Request review only after CI is green
5. Merge: `gh pr merge <N> --squash --delete-branch --admin`

## Best Practices

- Keep PRs focused (one paper section or one feature).
- Do not commit build output (`public/`).
- Verify the paper builds before requesting review.
