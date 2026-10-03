#!/usr/bin/env bash
#
# Sentinel AI — Claude Code PreToolUse guardrail (Bash and PowerShell tools).
#
# Layer 1 of the layered security model (docs/architecture/security-architecture.md §6).
# This is a bounded guardrail, not a security boundary and not a shell parser.
#
# Behaviour:
#   - Reads the PreToolUse JSON payload from stdin. No jq dependency: the
#     tool_input "command" string is extracted with sed and minimally unescaped.
#   - Empty input, or input without a readable "command" field, exits 2 (blocks the
#     call) and reports a configuration problem, so a broken invocation fails closed
#     instead of silently allowing.
#   - A matched destructive or control-bypassing command produces a "deny" decision.
#   - Anything else exits 0 with no output (normal permission flow applies).
#
# Blocked categories:
#   1. Recursive deletion (rm -r…, Remove-Item -Recurse and aliases) of protected
#      roots: .git, .claude, docs, /, ~, $HOME, ., .., *.
#   2. Git history rewriting or destructive Git operations: forced push, reset --hard,
#      clean -f, filter-branch, filter-repo.
#   3. Hook bypass: --no-verify.

set -u

input="$(cat 2>/dev/null)" || input=""

if [[ -z "${input//[[:space:]]/}" ]]; then
  echo "Sentinel guardrail: hook received no input; Claude Code hook configuration problem. Blocking." >&2
  exit 2
fi

deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Sentinel guardrail: %s. Review and run manually if intended."}}\n' "$1"
  exit 0
}

# Extract the JSON string value of "command" (escaped characters preserved).
raw_command="$(printf '%s' "$input" | tr -d '\r' | tr '\n' ' ' |
  sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')"

if [[ -z "$raw_command" ]]; then
  echo "Sentinel guardrail: no readable tool_input.command in hook input; Claude Code hook configuration problem. Blocking." >&2
  exit 2
fi

# Minimal JSON unescaping: \\ -> / (Windows paths), \" -> ", \n and \t -> separators.
payload="$(printf '%s' "$raw_command" |
  sed -e 's/\\\\/\//g' -e 's/\\"/"/g' -e 's/\\n/;/g' -e 's/\\t/ /g')"

# Lower-case copy for case-insensitive PowerShell matching.
lower="$(printf '%s' "$payload" | tr '[:upper:]' '[:lower:]')"

# 3. Hook bypass.
if printf '%s' "$lower" | grep -Eq -- '--no-verify'; then
  deny "--no-verify bypasses commit hooks"
fi

# Split into command segments on ; & | so targets are matched per command.
segments="$(printf '%s' "$lower" | tr ';&|' '\n\n\n')"

protected_target='(^|[[:space:]"'"'"'=(])(\./)?(\.git|\.claude|docs)(/|[[:space:]"'"'"')]|$)|[[:space:]](/|~|~/|\$home|\$env:userprofile|\*|\.|\.\.|\./)([[:space:]"'"'"')]|$)'

while IFS= read -r seg; do
  [[ -z "$seg" ]] && continue

  # 1a. rm with a recursive flag.
  if printf '%s' "$seg" | grep -Eq '(^|[[:space:]"(])rm[[:space:]]' &&
     printf '%s' "$seg" | grep -Eq '[[:space:]](-[a-z]*r[a-z]*|--recursive)([[:space:]]|$)' &&
     printf '%s' "$seg" | grep -Eq "$protected_target"; then
    deny "recursive deletion of a protected path"
  fi

  # 1b. Remove-Item and aliases with -Recurse (or an unambiguous abbreviation).
  if printf '%s' "$seg" | grep -Eq '(^|[[:space:]"(])(remove-item|ri|del|erase|rd|rmdir)[[:space:]]' &&
     printf '%s' "$seg" | grep -Eq '[[:space:]]-r(e|ec|ecu|ecur|ecurs|ecurse)?([[:space:]:]|$)' &&
     printf '%s' "$seg" | grep -Eq "$protected_target"; then
    deny "recursive deletion of a protected path"
  fi

  # 2. Destructive Git operations.
  if printf '%s' "$seg" | grep -Eq '(^|[[:space:]"(])git[[:space:]]+push[[:space:]].*(--force|--force-with-lease|[[:space:]]-f([[:space:]]|$))'; then
    deny "forced push rewrites remote history"
  fi
  if printf '%s' "$seg" | grep -Eq '(^|[[:space:]"(])git[[:space:]]+reset[[:space:]]+--hard'; then
    deny "git reset --hard discards work"
  fi
  if printf '%s' "$seg" | grep -Eq '(^|[[:space:]"(])git[[:space:]]+clean[[:space:]]+(-[a-z]*f|--force)'; then
    deny "git clean -f deletes untracked files"
  fi
  if printf '%s' "$seg" | grep -Eq '(^|[[:space:]"(])git[[:space:]]+filter-(branch|repo)'; then
    deny "history rewriting must not be automated"
  fi
done <<< "$segments"

exit 0
