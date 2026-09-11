#!/usr/bin/env bash
# check-commit-msg.sh — validate commit message format for ls-papers.
#
# Required format:
#   #<issue> <type>(<scope>): <description>
#
# - type: feat|fix|docs|style|refactor|test|chore|ci
# - scope: MANDATORY, lowercase with hyphens, NO commas
# - Merge/revert commits are allowed to bypass this check.
#
# Examples:
#   #3 feat(luka-master): add introduction chapter
#   #7 ci(build): add PDF artifact upload
#
# Used as a pre-commit "commit-msg" stage hook; receives the commit message
# file path as $1.

set -euo pipefail

msg_file="${1:?commit message file path required}"
# The subject is the first non-blank line of the message. We must NOT strip lines
# starting with '#', because our format begins with '#<issue>'. Git's own comment
# lines (added by the editor) always appear AFTER the subject/body, so taking the
# first non-blank line is safe.
subject="$(sed '/^[[:space:]]*$/d' "$msg_file" | head -1 || true)"

# Allow merge/revert commits to bypass (they are auto-generated).
if printf '%s' "$subject" | grep -qE '^(Merge|Revert) '; then
  exit 0
fi

# #<issue> <type>(<scope>): <description>
#   issue : one or more digits
#   type  : allowed set
#   scope : lowercase letters/digits/hyphens, no commas
pattern='^#[0-9]+ (feat|fix|docs|style|refactor|test|chore|ci)\([a-z0-9-]+\): .+'

if printf '%s' "$subject" | grep -qE "$pattern"; then
  exit 0
fi

cat >&2 <<EOF
✗ Invalid commit message format.

  Got:      $subject

  Expected: #<issue> <type>(<scope>): <description>
    type    one of: feat, fix, docs, style, refactor, test, chore, ci
    scope   mandatory, lowercase-with-hyphens, no commas
            (split into separate commits if you need multiple scopes)

  Examples:
    #3 feat(luka-master): add introduction chapter
    #7 ci(build): add PDF artifact upload
EOF
exit 1
