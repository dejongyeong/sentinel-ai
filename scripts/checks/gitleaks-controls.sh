#!/usr/bin/env bash
#
# Sentinel AI — Gitleaks negative and positive controls.
#
# Emits records:  RECORD|<VER ID>|<RESULT>|<PROCESS ACTION>|<detail>
#   VER-P0-GITLEAKS-NEG  clean scans exit 0 before and after the positive control
#   VER-P0-GITLEAKS-POS  synthetic token detected (exit != 0), JSON report parses,
#                        RuleID "github-pat" present, token occurs 0 times in the repo
#
# All test material lives in a temporary directory outside the repository and is
# removed on exit. The synthetic token is generated at runtime from a fixed seed;
# the complete value never appears in this file or in the repository.
# No Gitleaks rule, allowlist, or configuration is modified.
#
# Exit: 0 = no FAIL; 1 = any FAIL (including FAIL with process action STOP).

set -u

REPO="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "RECORD|VER-P0-GITLEAKS-NEG|FAIL|CONTINUE|not inside a Git repository"
  echo "RECORD|VER-P0-GITLEAKS-POS|FAIL|CONTINUE|not inside a Git repository"
  exit 1
}

CONFIG="$REPO/.gitleaks.toml"

find_python() {
  local candidate
  for candidate in python3 python "$REPO/.venv/bin/python" "$REPO/.venv/Scripts/python.exe"; do
    if command -v "$candidate" >/dev/null 2>&1 && "$candidate" -c "import sys" >/dev/null 2>&1; then
      command -v "$candidate"
      return 0
    fi
  done
  return 1
}

GITLEAKS="$(command -v gitleaks 2>/dev/null || command -v gitleaks.exe 2>/dev/null || true)"
PYTHON="$(find_python || true)"

if [[ -z "$GITLEAKS" || -z "$PYTHON" ]]; then
  missing=""
  [[ -z "$GITLEAKS" ]] && missing="gitleaks not executable"
  [[ -z "$PYTHON" ]] && missing="${missing:+$missing; }python not executable"
  echo "RECORD|VER-P0-GITLEAKS-NEG|BLOCKED|CONTINUE|prerequisite unavailable: $missing"
  echo "RECORD|VER-P0-GITLEAKS-POS|BLOCKED|CONTINUE|prerequisite unavailable: $missing"
  exit 0
fi

if [[ ! -f "$CONFIG" ]]; then
  echo "RECORD|VER-P0-GITLEAKS-NEG|FAIL|CONTINUE|required file missing: .gitleaks.toml"
  echo "RECORD|VER-P0-GITLEAKS-POS|FAIL|STOP|required file missing: .gitleaks.toml"
  exit 1
fi

TMP="$(mktemp -d 2>/dev/null)" || {
  echo "RECORD|VER-P0-GITLEAKS-NEG|FAIL|CONTINUE|cannot create temporary directory"
  echo "RECORD|VER-P0-GITLEAKS-POS|FAIL|STOP|cannot create temporary directory"
  exit 1
}
trap 'rm -rf "$TMP"' EXIT INT TERM

case "$TMP" in
  "$REPO"|"$REPO"/*)
    echo "RECORD|VER-P0-GITLEAKS-NEG|FAIL|STOP|temporary directory is inside the repository: $TMP"
    echo "RECORD|VER-P0-GITLEAKS-POS|FAIL|STOP|temporary directory is inside the repository"
    exit 1
    ;;
esac

version="$("$GITLEAKS" version 2>/dev/null | head -n 1)"
echo "INFO|gitleaks=$GITLEAKS|version=${version:-unknown}|temp=[TEMP DIR $TMP]"

mkdir -p "$TMP/clean" "$TMP/positive"
printf 'Sentinel AI negative control.\nThis file contains no credentials.\n' > "$TMP/clean/control.txt"

scan_clean() {
  "$GITLEAKS" dir "$TMP/clean" --config "$CONFIG" --redact --no-banner --log-level error >/dev/null 2>&1
}

# Negative control A.
scan_clean
neg_a=$?

# Deterministic synthetic token, generated at runtime.
seed="sentinel-ai/phase-0/gitleaks-positive-control/v1"
body="$(printf '%s' "$seed" | "$PYTHON" -c 'import hashlib,sys;print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest()[:36])')"
prefix="ghp"
token="${prefix}_${body}"
printf 'export SENTINEL_TEST_TOKEN="%s"\n' "$token" > "$TMP/positive/fixture.env"

# Positive control.
"$GITLEAKS" dir "$TMP/positive" --config "$CONFIG" --redact --no-banner --log-level error \
  --report-format json --report-path "$TMP/report.json" >/dev/null 2>&1
pos_exit=$?

rule_check="$("$PYTHON" - "$TMP/report.json" <<'PY'
import json, sys
try:
    with open(sys.argv[1], encoding="utf-8") as handle:
        findings = json.load(handle)
except Exception as exc:  # parse failure is a FAIL for this control
    print(f"PARSE_ERROR:{type(exc).__name__}")
    sys.exit(0)
if not isinstance(findings, list):
    print("PARSE_ERROR:not-a-list")
    sys.exit(0)
rules = sorted({str(item.get("RuleID")) for item in findings if isinstance(item, dict)})
print("RULES:" + ",".join(rules))
PY
)"

# Negative control B.
scan_clean
neg_b=$?

# Token must occur nowhere in the repository's canonical file set.
occurrences="$(SENTINEL_TOKEN="$token" "$PYTHON" - "$REPO" <<'PY'
import os, subprocess, sys
repo = sys.argv[1]
token = os.environ["SENTINEL_TOKEN"].encode()
listing = subprocess.run(
    ["git", "-C", repo, "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
    stdout=subprocess.PIPE, check=True,
).stdout
count = 0
for raw in filter(None, listing.split(b"\0")):
    try:
        with open(os.path.join(repo, os.fsdecode(raw)), "rb") as handle:
            if token in handle.read():
                count += 1
    except FileNotFoundError:
        pass
print(count)
PY
)" || occurrences="ERROR"

unset token body

# Records.
if [[ $neg_a -eq 0 && $neg_b -eq 0 ]]; then
  echo "RECORD|VER-P0-GITLEAKS-NEG|PASS|CONTINUE|clean scan exit codes: before=$neg_a after=$neg_b"
  neg_result=PASS
else
  echo "RECORD|VER-P0-GITLEAKS-NEG|FAIL|CONTINUE|clean scan exit codes: before=$neg_a after=$neg_b (expected 0)"
  neg_result=FAIL
fi

pos_detail="positive scan exit=$pos_exit; report=$rule_check; repo occurrences=$occurrences"
if [[ $pos_exit -ne 0 && "$rule_check" == RULES:* && ",${rule_check#RULES:}," == *",github-pat,"* && "$occurrences" == "0" ]]; then
  echo "RECORD|VER-P0-GITLEAKS-POS|PASS|CONTINUE|$pos_detail"
  pos_result=PASS
else
  echo "RECORD|VER-P0-GITLEAKS-POS|FAIL|STOP|$pos_detail"
  pos_result=FAIL
fi

[[ "$neg_result" == PASS && "$pos_result" == PASS ]] && exit 0
exit 1
