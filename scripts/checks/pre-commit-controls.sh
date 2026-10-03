#!/usr/bin/env bash
#
# Sentinel AI — pre-commit negative and positive controls.
#
# Emits records:  RECORD|<VER ID>|<RESULT>|<PROCESS ACTION>|<detail>
#   VER-P0-PRECOMMIT-NEG  clean temporary repository: copied count == source count,
#                         staged count > 0, `pre-commit run` exits 0, clean commit succeeds
#   VER-P0-PRECOMMIT-POS  secret temporary repository: `pre-commit run gitleaks` != 0,
#                         `pre-commit run` != 0, `git commit` rejected, commit count 0
#
# Every Git mutation happens in throwaway repositories created with mktemp outside the
# project ([TEMP REPO <path>]). The project repository is only read. --no-verify is
# never used. Temporary material is removed on exit.
#
# Exit: 0 = no FAIL; 1 = any FAIL (including FAIL with process action STOP).

set -u

REPO="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "RECORD|VER-P0-PRECOMMIT-NEG|FAIL|CONTINUE|not inside a Git repository"
  echo "RECORD|VER-P0-PRECOMMIT-POS|FAIL|CONTINUE|not inside a Git repository"
  exit 1
}

# Portable pre-commit lookup: PATH -> .venv/bin -> .venv/Scripts -> python -m pre_commit.
PRE_COMMIT=()
if command -v pre-commit >/dev/null 2>&1; then
  PRE_COMMIT=("$(command -v pre-commit)")
elif [[ -x "$REPO/.venv/bin/pre-commit" ]]; then
  PRE_COMMIT=("$REPO/.venv/bin/pre-commit")
elif [[ -x "$REPO/.venv/Scripts/pre-commit.exe" ]]; then
  PRE_COMMIT=("$REPO/.venv/Scripts/pre-commit.exe")
elif [[ -x "$REPO/.venv/Scripts/pre-commit" ]]; then
  PRE_COMMIT=("$REPO/.venv/Scripts/pre-commit")
else
  for py in python3 python; do
    if command -v "$py" >/dev/null 2>&1 && "$py" -m pre_commit --version >/dev/null 2>&1; then
      PRE_COMMIT=("$(command -v "$py")" -m pre_commit)
      break
    fi
  done
fi

if [[ ${#PRE_COMMIT[@]} -eq 0 ]]; then
  echo "RECORD|VER-P0-PRECOMMIT-NEG|BLOCKED|CONTINUE|prerequisite unavailable: pre-commit not installed"
  echo "RECORD|VER-P0-PRECOMMIT-POS|BLOCKED|CONTINUE|prerequisite unavailable: pre-commit not installed"
  exit 0
fi

PYTHON=""
for candidate in python3 python "$REPO/.venv/bin/python" "$REPO/.venv/Scripts/python.exe"; do
  if command -v "$candidate" >/dev/null 2>&1 && "$candidate" -c "import sys" >/dev/null 2>&1; then
    PYTHON="$(command -v "$candidate")"
    break
  fi
done

TMP="$(mktemp -d 2>/dev/null)" || {
  echo "RECORD|VER-P0-PRECOMMIT-NEG|FAIL|CONTINUE|cannot create temporary directory"
  echo "RECORD|VER-P0-PRECOMMIT-POS|FAIL|STOP|cannot create temporary directory"
  exit 1
}
trap 'rm -rf "$TMP"' EXIT INT TERM

case "$TMP" in
  "$REPO"|"$REPO"/*)
    echo "RECORD|VER-P0-PRECOMMIT-NEG|FAIL|STOP|temporary directory is inside the repository"
    echo "RECORD|VER-P0-PRECOMMIT-POS|FAIL|STOP|temporary directory is inside the repository"
    exit 1
    ;;
esac

echo "INFO|pre-commit=${PRE_COMMIT[*]}|version=$("${PRE_COMMIT[@]}" --version 2>/dev/null)"

init_temp_repo() {
  local dir="$1"
  git init -q "$dir" &&
    git -C "$dir" config user.email "verification@example.invalid" &&
    git -C "$dir" config user.name "Sentinel Verification"
}

commit_count() {
  git -C "$1" rev-list --all --count 2>/dev/null || echo 0
}

# ---------------------------------------------------------------------------
# Negative control: clean copy of the project's non-ignored files.
# ---------------------------------------------------------------------------
CLEAN="$TMP/clean-repo"
neg_detail=""
neg_ok=1

if ! init_temp_repo "$CLEAN"; then
  neg_ok=0
  neg_detail="[TEMP REPO $CLEAN] git init failed"
else
  source_count=0
  copied_count=0
  while IFS= read -r -d '' path; do
    source_count=$((source_count + 1))
    [[ -f "$REPO/$path" ]] || continue
    mkdir -p "$CLEAN/$(dirname -- "$path")" &&
      cp -p -- "$REPO/$path" "$CLEAN/$path" &&
      copied_count=$((copied_count + 1))
  done < <(git -C "$REPO" ls-files -z --cached --others --exclude-standard)

  (cd "$CLEAN" && "${PRE_COMMIT[@]}" install >/dev/null 2>&1)
  install_rc=$?
  git -C "$CLEAN" add -A
  staged_count="$(git -C "$CLEAN" diff --cached --name-only -z | tr -cd '\0' | wc -c | tr -d ' ')"

  (cd "$CLEAN" && "${PRE_COMMIT[@]}" run >"$TMP/neg-run.log" 2>&1)
  run_rc=$?

  (cd "$CLEAN" && git commit -q -m "Sentinel pre-commit negative control" >"$TMP/neg-commit.log" 2>&1)
  commit_rc=$?
  neg_commits="$(commit_count "$CLEAN")"

  neg_detail="[TEMP REPO $CLEAN] source=$source_count copied=$copied_count staged=$staged_count install_rc=$install_rc run_rc=$run_rc commit_rc=$commit_rc commits=$neg_commits"
  if [[ $source_count -eq 0 || $copied_count -ne $source_count || $staged_count -ne $copied_count ||
        $install_rc -ne 0 || $run_rc -ne 0 || $commit_rc -ne 0 || "$neg_commits" != "1" ]]; then
    neg_ok=0
  fi
fi

if [[ $neg_ok -eq 1 ]]; then
  echo "RECORD|VER-P0-PRECOMMIT-NEG|PASS|CONTINUE|$neg_detail"
else
  echo "RECORD|VER-P0-PRECOMMIT-NEG|FAIL|CONTINUE|$neg_detail"
  [[ -f "$TMP/neg-run.log" ]] && sed 's/^/INFO|neg-run|/' "$TMP/neg-run.log" | tail -n 20
fi

# ---------------------------------------------------------------------------
# Positive control: runtime-generated synthetic secret in a separate repository.
# ---------------------------------------------------------------------------
SECRET="$TMP/secret-repo"
pos_ok=1
pos_action=CONTINUE

if [[ -z "$PYTHON" ]]; then
  echo "RECORD|VER-P0-PRECOMMIT-POS|BLOCKED|CONTINUE|prerequisite unavailable: python not executable (token generation)"
  [[ $neg_ok -eq 1 ]] && exit 0
  exit 1
fi

if ! init_temp_repo "$SECRET"; then
  echo "RECORD|VER-P0-PRECOMMIT-POS|FAIL|CONTINUE|[TEMP REPO $SECRET] git init failed"
  exit 1
fi

cp -p -- "$REPO/.pre-commit-config.yaml" "$SECRET/" && cp -p -- "$REPO/.gitleaks.toml" "$SECRET/" || {
  echo "RECORD|VER-P0-PRECOMMIT-POS|FAIL|CONTINUE|required configuration files missing"
  exit 1
}

seed="sentinel-ai/phase-0/gitleaks-positive-control/v1"
body="$(printf '%s' "$seed" | "$PYTHON" -c 'import hashlib,sys;print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest()[:36])')"
prefix="ghp"
printf 'export SENTINEL_TEST_TOKEN="%s_%s"\n' "$prefix" "$body" > "$SECRET/fixture.env"
unset body

(cd "$SECRET" && "${PRE_COMMIT[@]}" install >/dev/null 2>&1)
pos_install_rc=$?
git -C "$SECRET" add -A

(cd "$SECRET" && "${PRE_COMMIT[@]}" run gitleaks >"$TMP/pos-gitleaks.log" 2>&1)
hook_rc=$?
(cd "$SECRET" && "${PRE_COMMIT[@]}" run >"$TMP/pos-all.log" 2>&1)
all_rc=$?
(cd "$SECRET" && git commit -q -m "Sentinel pre-commit positive control" >"$TMP/pos-commit.log" 2>&1)
pos_commit_rc=$?
pos_commits="$(commit_count "$SECRET")"

pos_detail="[TEMP REPO $SECRET] install_rc=$pos_install_rc gitleaks_hook_rc=$hook_rc all_hooks_rc=$all_rc commit_rc=$pos_commit_rc commits=$pos_commits"

if [[ "$pos_commits" != "0" || $pos_commit_rc -eq 0 ]]; then
  pos_ok=0
  pos_action=STOP
  pos_detail="$pos_detail; secret commit was accepted"
elif [[ $pos_install_rc -ne 0 || $hook_rc -eq 0 || $all_rc -eq 0 ]]; then
  pos_ok=0
fi

if [[ $pos_ok -eq 1 ]]; then
  echo "RECORD|VER-P0-PRECOMMIT-POS|PASS|CONTINUE|$pos_detail"
else
  echo "RECORD|VER-P0-PRECOMMIT-POS|FAIL|$pos_action|$pos_detail"
fi

[[ $neg_ok -eq 1 && $pos_ok -eq 1 ]] && exit 0
exit 1
