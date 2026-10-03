#!/usr/bin/env bash
#
# Sentinel AI — Claude Code guardrail tests.
#
# Emits:  RECORD|VER-P0-HOOKS-001|<RESULT>|<PROCESS ACTION>|<detail>
#
# PASS requires:
#   - .claude/settings.json parses as JSON, contains the required permission deny rules,
#     registers the PreToolUse hook for Bash|PowerShell, and has no Stop hook;
#   - every deny fixture produces a "deny" decision;
#   - every allow fixture exits 0 without a decision;
#   - empty input and input without a command field exit 2 (fail closed).
#
# Guardrails are layer 1 of the layered security model; they are not a security boundary.
# This script only reads the repository.
#
# Exit: 0 = PASS (or BLOCKED); 1 = FAIL.

set -u

REPO="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "RECORD|VER-P0-HOOKS-001|FAIL|CONTINUE|not inside a Git repository"
  exit 1
}

HOOK="$REPO/.claude/hooks/block-dangerous-command.sh"
SETTINGS="$REPO/.claude/settings.json"

PYTHON=""
for candidate in python3 python "$REPO/.venv/bin/python" "$REPO/.venv/Scripts/python.exe"; do
  if command -v "$candidate" >/dev/null 2>&1 && "$candidate" -c "import sys" >/dev/null 2>&1; then
    PYTHON="$(command -v "$candidate")"
    break
  fi
done

failures=()

if [[ ! -f "$HOOK" ]]; then
  failures+=("hook script missing")
fi

# --- settings.json -----------------------------------------------------------
if [[ -z "$PYTHON" ]]; then
  failures+=("python unavailable to validate settings.json")
elif [[ ! -f "$SETTINGS" ]]; then
  failures+=("settings.json missing")
else
  settings_report="$("$PYTHON" - "$SETTINGS" <<'PY'
import json, sys
problems = []
try:
    with open(sys.argv[1], encoding="utf-8") as handle:
        data = json.load(handle)
except Exception as exc:
    print(f"settings.json does not parse: {type(exc).__name__}")
    sys.exit(0)
deny = set((data.get("permissions") or {}).get("deny") or [])
required = {
    "Bash(*--no-verify*)", "PowerShell(*--no-verify*)",
    "Bash(git reset --hard*)", "PowerShell(git reset --hard*)",
    "Bash(git push --force*)", "PowerShell(git push --force*)",
    "Bash(git clean -*f*)", "PowerShell(git clean -*f*)",
    "Bash(git filter-branch*)", "Bash(git filter-repo*)",
    "PowerShell(git filter-branch*)", "PowerShell(git filter-repo*)",
    "Bash(rm -rf .git*)", "Bash(rm -rf .claude*)", "Bash(rm -rf docs*)",
    "Read(./.env)",
}
for rule in sorted(required - deny):
    problems.append(f"missing deny rule {rule}")
hooks = data.get("hooks") or {}
if "Stop" in hooks:
    problems.append("Stop hook present")
pre = hooks.get("PreToolUse") or []
if not any(
    entry.get("matcher") == "Bash|PowerShell"
    and any("block-dangerous-command.sh" in h.get("command", "") and "${CLAUDE_PROJECT_DIR}" in h.get("command", "")
            for h in entry.get("hooks", []))
    for entry in pre
):
    problems.append("PreToolUse Bash|PowerShell guardrail hook not registered via ${CLAUDE_PROJECT_DIR}")
print("; ".join(problems))
PY
)"
  [[ -n "$settings_report" ]] && failures+=("$settings_report")
fi

# --- hook fixtures -----------------------------------------------------------
# Each fixture: tool name and the JSON-escaped command string.
run_hook() {
  printf '%s' "$1" | CLAUDE_PROJECT_DIR="$REPO" bash "$HOOK" 2>/dev/null
}

payload() {
  printf '{"session_id":"guardrail-test","cwd":"/tmp/docs","hook_event_name":"PreToolUse","tool_name":"%s","tool_input":{"command":"%s"}}' "$1" "$2"
}

deny_fixtures=(
  'Bash|rm -rf .git'
  'Bash|rm -fr docs'
  'Bash|rm -r -f ./.claude'
  'Bash|rm --recursive --force docs/architecture'
  'Bash|cd /tmp && rm -rf ~'
  'Bash|rm -rf /'
  'Bash|git push --force origin main'
  'Bash|git push origin main -f'
  'Bash|git reset --hard HEAD~1'
  'Bash|git clean -fdx'
  'Bash|git filter-repo --path secrets.txt --invert-paths'
  'Bash|git commit -m wip --no-verify'
  'PowerShell|Remove-Item -Recurse -Force .claude'
  'PowerShell|Remove-Item docs -Recurse'
  'PowerShell|rd .git -r'
  'PowerShell|Remove-Item -Recurse .\\docs'
  'PowerShell|git push --force-with-lease origin main'
)

allow_fixtures=(
  'Bash|rm -rf node_modules'
  'Bash|rm -rf /tmp/sentinel-scratch'
  'Bash|rm -rf node_modules && ls docs'
  'Bash|git status'
  'Bash|git push origin main'
  'Bash|ls docs/architecture'
  'PowerShell|Remove-Item tmp.txt'
  'PowerShell|Get-ChildItem docs -Recurse'
)

if [[ -f "$HOOK" ]]; then
  for fixture in "${deny_fixtures[@]}"; do
    tool="${fixture%%|*}"
    cmd="${fixture#*|}"
    out="$(run_hook "$(payload "$tool" "$cmd")")"
    rc=$?
    if [[ $rc -ne 0 || "$out" != *'"permissionDecision":"deny"'* ]]; then
      failures+=("expected deny: [$tool] $cmd (rc=$rc)")
    fi
  done

  for fixture in "${allow_fixtures[@]}"; do
    tool="${fixture%%|*}"
    cmd="${fixture#*|}"
    out="$(run_hook "$(payload "$tool" "$cmd")")"
    rc=$?
    if [[ $rc -ne 0 || -n "$out" ]]; then
      failures+=("expected allow: [$tool] $cmd (rc=$rc)")
    fi
  done

  run_hook "" >/dev/null
  rc=$?
  [[ $rc -eq 2 ]] || failures+=("empty input: expected exit 2, got $rc")

  run_hook '{"tool_name":"Bash","tool_input":{}}' >/dev/null
  rc=$?
  [[ $rc -eq 2 ]] || failures+=("missing command field: expected exit 2, got $rc")
fi

total=$(( ${#deny_fixtures[@]} + ${#allow_fixtures[@]} + 2 ))

if [[ ${#failures[@]} -eq 0 ]]; then
  echo "RECORD|VER-P0-HOOKS-001|PASS|CONTINUE|settings valid; $total hook fixtures behaved as expected"
  exit 0
fi

detail="$(printf '%s; ' "${failures[@]}")"
echo "RECORD|VER-P0-HOOKS-001|FAIL|CONTINUE|${detail%; }"
exit 1
