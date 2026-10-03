#!/usr/bin/env bash
#
# Sentinel AI — deterministic phase verification.
#
# Usage:
#   scripts/verify-phase.sh <phase-id> [--baseline SNAPSHOT.json] [--json-out PATH]
#                           [--ci-run-url URL] [--ci-run-detected yes|no]
#
# Contract (Phase 0 document; docs/phases/README.md):
#   - Results are only PASS | FAIL | BLOCKED | NOT APPLICABLE.
#     Each record also carries a process action: CONTINUE | STOP. STOP is never a result.
#   - Classification per check:
#       applicability false            -> NOT APPLICABLE (reason recorded)
#       prerequisite false             -> BLOCKED (missing prerequisite recorded)
#       otherwise execute              -> PASS or FAIL
#     Any error, crash, malformed input, or missing required file -> FAIL.
#   - This script never writes into the repository. --json-out must point outside it.
#   - Review checks (VER-P0-REVIEW-*) are evaluated by verification orchestration, not here.
#   - Exit codes: 0 = run completed with no FAIL and no STOP; 1 = any FAIL, STOP,
#     machinery defect, or usage error. Exit 0 alone does not establish phase eligibility.
#
# Runs the embedded Python program with the first Python interpreter found.

set -u

REPO="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "verify-phase: FAIL — not inside a Git repository" >&2
  exit 1
}

PYTHON=""
for candidate in "$REPO/.venv/bin/python" "$REPO/.venv/Scripts/python.exe" python3 python; do
  if command -v "$candidate" >/dev/null 2>&1 && "$candidate" -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)" >/dev/null 2>&1; then
    PYTHON="$(command -v "$candidate")"
    break
  fi
done

if [[ -z "$PYTHON" ]]; then
  echo "verify-phase: FAIL — no Python 3.9+ interpreter found (required verification machinery)" >&2
  exit 1
fi

PROGRAM="$(cat <<'PY'
import datetime, glob, json, os, re, shutil, subprocess, sys

# ---------------------------------------------------------------------------
# Single authoritative definition (Phase 0 document, Exit Criteria, condition 3).
# BLOCKED on any other check keeps the phase In Progress.
# ---------------------------------------------------------------------------
TRANSITION_PERMITTED_BLOCKED = frozenset({
    "VER-P0-CI-EXEC",
    "VER-P0-REPO-PROTECTION",
    "VER-P0-ACCEPT-001",
    "VER-P0-REVIEW-L2-RUNTIME-architecture-reviewer",
    "VER-P0-REVIEW-L2-RUNTIME-security-reviewer",
    "VER-P0-REVIEW-L2-RUNTIME-ai-engineering-reviewer",
    "VER-P0-REVIEW-L2-RUNTIME-verification-reviewer",
    "VER-P0-REVIEW-L2-RUNTIME-documentation-reviewer",
})

RESULTS = ("PASS", "FAIL", "BLOCKED", "NOT APPLICABLE")

# Pinned CI action commits (verified against the upstream tags before pinning).
EXPECTED_ACTIONS = {
    "actions/checkout": "3d3c42e5aac5ba805825da76410c181273ba90b1",
    "gitleaks/gitleaks-action": "e0c47f4f8be36e29cdc102c57e68cb5cbf0e8d1e",
}

REVIEWERS = (
    "architecture-reviewer",
    "security-reviewer",
    "ai-engineering-reviewer",
    "verification-reviewer",
    "documentation-reviewer",
)

AUTHORITY_STATUSES = {"Draft", "Proposed", "Accepted", "Superseded"}
ADR_STATUSES = {"Proposed", "Accepted", "Rejected", "Superseded"}
PHASE_STATUSES = {"Not Started", "In Progress", "Verification", "Complete", "Blocked"}
RECORD_STATUSES = {"Pending", "Recorded", "Superseded"}
PERMITTED_TRANSITIONS = {
    ("—", "Not Started"),
    ("Not Started", "In Progress"),
    ("In Progress", "Blocked"),
    ("Blocked", "In Progress"),
    ("In Progress", "Verification"),
    ("Verification", "Complete"),
    ("Verification", "In Progress"),
}
TASK_SECTIONS = [
    "Objective", "Inputs", "Implementation", "Tests", "Security",
    "Observability", "Documentation", "Acceptance Criteria", "Verification Evidence",
]
SKILL_SECTIONS = [
    "Purpose", "Invocation", "Inputs", "Authority Sources", "Procedure",
    "Constraints", "Verification", "Stopping Conditions", "Output",
]
CLAUDE_SECTIONS = [
    "Project", "Repository Structure", "Authority", "Commands",
    "Critical Architecture Invariants", "Verification",
]
VERSION_PATTERN = re.compile(r"canonical-specification-v\d+\.\d+")
# Side-effecting Skills that must be user-invoked only.
USER_INVOKED_ONLY_SKILLS = ("adr", "commit")


class Run:
    def __init__(self, repo, python, args):
        self.repo = repo
        self.python = python
        self.args = args
        self.records = []
        self.stopped = False
        self.state = {}

    def path(self, rel):
        return os.path.join(self.repo, rel)

    def read(self, rel):
        with open(self.path(rel), encoding="utf-8") as handle:
            return handle.read()

    def record(self, ver, result, detail, action="CONTINUE", command="[REAL REPO] in-process inspection", exit_code="n/a"):
        assert result in RESULTS
        rec = {
            "ver": ver,
            "result": result,
            "process_action": action,
            "timestamp_utc": utcnow(),
            "commit_count": self.state.get("commit_count"),
            "porcelain_hash": self.state.get("porcelain_hash"),
            "working_tree_content_hash": self.state.get("working_tree_content_hash"),
            "remotes": self.state.get("remotes"),
            "command": command,
            "exit_code": exit_code,
            "detail": detail,
        }
        self.records.append(rec)
        print(f"{ver} | {result} | {action} | exit={exit_code} | {command} | {detail}")
        sys.stdout.flush()
        if action == "STOP":
            self.stopped = True


def utcnow():
    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def git(repo, *args):
    return subprocess.run(["git", "-C", repo, *args], stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def status_of(text, label="Status"):
    match = re.search(r"^\*\*" + re.escape(label) + r":\*\*\s*(.+?)\s*$", text, re.M)
    return match.group(1).strip().strip("`").strip() if match else None


def phase_status_of(text):
    match = re.search(r"^## Status\s*\n+\s*`?([^`\n]+?)`?\s*$", text, re.M)
    return match.group(1).strip() if match else None


def rel_paths(repo, pattern):
    return sorted(os.path.relpath(p, repo).replace(os.sep, "/") for p in glob.glob(os.path.join(repo, pattern), recursive=True))


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

REQUIRED_FILES = [
    "CLAUDE.md", "README.md",
    "docs/architecture/documentation-authority.md",
    "docs/architecture/acceptance-register.md",
    "docs/architecture/canonical-specification/README.md",
    "docs/architecture/context.md", "docs/architecture/system-architecture.md",
    "docs/architecture/application-architecture.md", "docs/architecture/data-architecture.md",
    "docs/architecture/ai-architecture.md", "docs/architecture/security-architecture.md",
    "docs/product/product-scope.md", "docs/product/requirements.md",
    "docs/product/user-stories.md", "docs/product/acceptance-criteria.md", "docs/product/roadmap.md",
    "docs/decisions/README.md", "docs/decisions/decision-register.md",
    "docs/phases/README.md", "docs/phases/phase-0-product-and-secure-engineering-foundation.md",
    "docs/phases/evidence/phase-0/verification-record.md",
    "docs/phases/evidence/phase-0/contradiction-review.md",
    "docs/phases/evidence/phase-0/engineering-review.md",
    "docs/phases/evidence/phase-0/independent-review.md",
    "docs/security/security-baseline.md", "docs/security/secret-incident-response.md",
    "docs/operations/developer-workflow.md", "docs/operations/claude-code-prompt-standard.md",
    ".gitignore", ".gitleaks.toml", ".pre-commit-config.yaml", ".github/workflows/security.yml",
    ".claude/settings.json", ".claude/hooks/block-dangerous-command.sh",
    ".claude/rules/architecture.md", ".claude/rules/security.md", ".claude/rules/documentation.md",
    ".claude/skills/phase-verification/SKILL.md", ".claude/skills/architecture-review/SKILL.md",
    ".claude/skills/documentation-review/SKILL.md",
    ".claude/skills/adr/SKILL.md", ".claude/skills/commit/SKILL.md",
    *[f".claude/agents/{name}.md" for name in REVIEWERS],
    "scripts/verify-phase.sh", "scripts/checks/repo_snapshot.py",
    "scripts/checks/gitleaks-controls.sh", "scripts/checks/pre-commit-controls.sh",
    "scripts/checks/claude-guardrails.sh",
]

PHASE0_DOC = "docs/phases/phase-0-product-and-secure-engineering-foundation.md"
REGISTER = "docs/architecture/acceptance-register.md"
GATE_STATUS_ITEMS = [
    "docs/architecture/documentation-authority.md",
    "docs/architecture/canonical-specification/README.md",
    "docs/phases/README.md",
    "docs/decisions/README.md",
    "docs/architecture/acceptance-register.md",
]
EVIDENCE_FILES = {
    "docs/phases/evidence/phase-0/verification-record.md",
    "docs/phases/evidence/phase-0/contradiction-review.md",
    "docs/phases/evidence/phase-0/engineering-review.md",
    "docs/phases/evidence/phase-0/independent-review.md",
}


def check_docs(run):
    missing = [p for p in REQUIRED_FILES if not os.path.isfile(run.path(p))]
    if missing:
        run.record("VER-P0-DOCS-001", "FAIL", "missing: " + ", ".join(missing))
    else:
        run.record("VER-P0-DOCS-001", "PASS", f"{len(REQUIRED_FILES)} required files present")


def authority_docs(run):
    docs = rel_paths(run.repo, "docs/**/*.md")
    return [d for d in docs
            if not re.match(r"docs/phases/phase-[^/]+\.md$", d)
            and not d.startswith("docs/phases/evidence/")
            and not re.match(r"docs/decisions/adr/ADR-[^/]+\.md$", d)]


def parse_register(run):
    """Return (entries, error). entries: list of dicts with document, type."""
    if not os.path.isfile(run.path(REGISTER)):
        return None, "acceptance register missing"
    try:
        text = run.read(REGISTER)
    except (OSError, UnicodeDecodeError) as exc:
        return None, f"acceptance register unreadable: {type(exc).__name__}"
    lines = [l for l in text.splitlines() if l.strip().startswith("|")]
    header_idx = next((i for i, l in enumerate(lines) if "Document / version" in l and "Type" in l), None)
    if header_idx is None:
        return None, "acceptance register malformed: entries table header not found"
    header = [c.strip() for c in lines[header_idx].strip().strip("|").split("|")]
    try:
        doc_col, type_col = header.index("Document / version"), header.index("Type")
    except ValueError:
        return None, "acceptance register malformed: required columns missing"
    entries = []
    for row in lines[header_idx + 2:]:
        cells = [c.strip() for c in row.strip().strip("|").split("|")]
        if len(cells) != len(header):
            return None, "acceptance register malformed: row column count mismatch"
        doc_match = re.search(r"`([^`]+)`", cells[doc_col])
        etype = cells[type_col]
        if not doc_match or etype not in ("status", "content"):
            return None, "acceptance register malformed: invalid document or type cell"
        entries.append({"document": doc_match.group(1), "type": etype})
    return entries, None


def check_status_doc(run):
    entries, err = parse_register(run)
    problems = []
    for doc in authority_docs(run):
        status = status_of(run.read(doc))
        is_canonical_version = re.match(r"docs/architecture/canonical-specification/canonical-specification-v[^/]+\.md$", doc)
        allowed = AUTHORITY_STATUSES | ({"Historical"} if is_canonical_version else set())
        if status is None:
            problems.append(f"{doc}: no status")
        elif status not in allowed:
            problems.append(f"{doc}: status '{status}' not in its model")
        elif status == "Accepted":
            if err:
                problems.append(f"{doc}: claims Accepted but register unusable ({err})")
            elif not any(e["document"] == doc and e["type"] == "status" for e in entries):
                problems.append(f"{doc}: claims Accepted without a status register entry")
    if problems:
        run.record("VER-P0-STATUS-DOC-001", "FAIL", "; ".join(problems))
    else:
        run.record("VER-P0-STATUS-DOC-001", "PASS", f"{len(authority_docs(run))} authority documents conform")


def check_status_adr(run):
    adrs = rel_paths(run.repo, "docs/decisions/adr/ADR-*.md")
    if not adrs:
        run.record("VER-P0-STATUS-ADR-001", "NOT APPLICABLE", "applicability false: no ADR files (docs/decisions/adr/ADR-*.md) exist")
        return
    bad = [f"{a}: '{status_of(run.read(a))}'" for a in adrs if status_of(run.read(a)) not in ADR_STATUSES]
    run.record("VER-P0-STATUS-ADR-001", "FAIL" if bad else "PASS", "; ".join(bad) if bad else f"{len(adrs)} ADRs conform")


def check_status_phase(run):
    phases = rel_paths(run.repo, "docs/phases/phase-*.md")
    bad = []
    for p in phases:
        status = phase_status_of(run.read(p))
        if status not in PHASE_STATUSES:
            bad.append(f"{p}: '{status}'")
    if not phases:
        bad.append("no phase documents found")
    run.record("VER-P0-STATUS-PHASE-001", "FAIL" if bad else "PASS", "; ".join(bad) if bad else f"{len(phases)} phase documents conform")


def check_status_record(run):
    records = rel_paths(run.repo, "docs/phases/evidence/**/*.md")
    bad = []
    phase_claim = re.compile(r"(?im)^\*\*(phase\s+)?status:\*\*|phase\s+(lifecycle\s+)?status\s*[:=]\s*`?(not started|in progress|verification|complete|blocked)")
    for r in records:
        text = run.read(r)
        status = status_of(text, "Record status")
        if status not in RECORD_STATUSES:
            bad.append(f"{r}: record status '{status}'")
        if phase_claim.search(text):
            bad.append(f"{r}: states a phase status")
    if not records:
        bad.append("no evidence records found")
    run.record("VER-P0-STATUS-RECORD-001", "FAIL" if bad else "PASS", "; ".join(bad) if bad else f"{len(records)} evidence records conform")


def history_rows(text):
    section = re.search(r"^### Status History\s*\n(.*?)(?=^### |\Z)", text, re.M | re.S)
    if not section:
        return None
    rows = []
    for line in section.group(1).splitlines():
        if not line.strip().startswith("|"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 3 or cells[0] in ("Date",) or set(cells[0]) <= set("-: "):
            continue
        rows.append((cells[1], cells[2]))
    return rows


def check_lifecycle(run):
    problems = []
    for p in rel_paths(run.repo, "docs/phases/phase-*.md"):
        text = run.read(p)
        status = phase_status_of(text)
        rows = history_rows(text)
        if not rows:
            problems.append(f"{p}: no status history")
            continue
        prev_new = "—"
        for prev, new in rows:
            if prev != prev_new:
                problems.append(f"{p}: history row '{prev} -> {new}' does not follow '{prev_new}'")
            if (prev, new) not in PERMITTED_TRANSITIONS:
                problems.append(f"{p}: transition '{prev} -> {new}' not permitted")
            prev_new = new
        if rows[-1][1] != status:
            problems.append(f"{p}: status '{status}' != latest history '{rows[-1][1]}'")
    run.record("VER-P0-LIFECYCLE-001", "FAIL" if problems else "PASS", "; ".join(problems) if problems else "status matches history; all transitions permitted")


def check_accept(run):
    entries, err = parse_register(run)
    phase_text = run.read(PHASE0_DOC) if os.path.isfile(run.path(PHASE0_DOC)) else ""
    inconsistent, pending = [], []
    if err:
        inconsistent.append(err)
    else:
        for doc in GATE_STATUS_ITEMS:
            status = status_of(run.read(doc)) if os.path.isfile(run.path(doc)) else None
            doc_entries = [e for e in entries if e["document"] == doc]
            if status is None:
                inconsistent.append(f"{doc}: missing or has no status")
            elif not doc_entries:
                (inconsistent if status == "Accepted" else pending).append(
                    f"{doc}: claims Accepted without entry" if status == "Accepted" else doc)
            elif any(e["type"] != "status" for e in doc_entries):
                inconsistent.append(f"{doc}: register entry has wrong type")
            elif status != "Accepted":
                inconsistent.append(f"{doc}: status entry present but status is '{status}'")
        phase_entries = [e for e in entries if e["document"] == PHASE0_DOC]
        phase_status = phase_status_of(phase_text)
        if phase_status == "Accepted":
            inconsistent.append(f"{PHASE0_DOC}: uses Accepted as lifecycle status")
        if not phase_entries:
            pending.append(f"{PHASE0_DOC} (content)")
        elif any(e["type"] != "content" for e in phase_entries):
            inconsistent.append(f"{PHASE0_DOC}: register entry has wrong type")
    # Prerequisite: no gate item is genuinely pending. Genuinely pending requires a valid
    # register and no inconsistency anywhere in the gate (Phase 0 document, Exit Criteria).
    genuinely_pending = pending if (not err and not inconsistent) else []
    if genuinely_pending:
        run.record("VER-P0-ACCEPT-001", "BLOCKED", "prerequisite false: owner acceptance not yet recorded for: " + ", ".join(genuinely_pending))
    elif inconsistent:
        extra = f"; also lacking entries: {', '.join(pending)}" if pending else ""
        run.record("VER-P0-ACCEPT-001", "FAIL", "; ".join(inconsistent) + extra)
    else:
        run.record("VER-P0-ACCEPT-001", "PASS", "all six acceptance-gate conditions hold")


def check_template(run):
    text = run.read(PHASE0_DOC)
    blocks = re.split(r"^### (Task [^\n]+)\n", text, flags=re.M)
    problems, count = [], 0
    for i in range(1, len(blocks), 2):
        count += 1
        name, body = blocks[i].strip(), re.split(r"^## ", blocks[i + 1], flags=re.M)[0]
        headings = re.findall(r"^#### (.+?)\s*$", body, re.M)
        if headings != TASK_SECTIONS:
            problems.append(f"{name}: sections {headings}")
    if count == 0:
        problems.append("no tasks found")
    run.record("VER-P0-TEMPLATE-001", "FAIL" if problems else "PASS", "; ".join(problems) if problems else f"{count} tasks have all nine sections in order")


def check_versionref(run):
    files = ["CLAUDE.md", "docs/architecture/documentation-authority.md", "docs/phases/README.md", "docs/decisions/README.md"]
    files += rel_paths(run.repo, ".claude/**/*.md") + [".claude/settings.json"]
    hits = [f for f in files if os.path.isfile(run.path(f)) and VERSION_PATTERN.search(run.read(f))]
    run.record("VER-P0-VERSIONREF-001", "FAIL" if hits else "PASS", ("hard-coded version in: " + ", ".join(hits)) if hits else f"{len(files)} generic governance files resolve the version through the canonical README")


def check_claude(run):
    text = run.read("CLAUDE.md")
    lines = text.count("\n") + (0 if text.endswith("\n") else 1)
    headings = set(re.findall(r"^## (.+?)\s*$", text, re.M))
    problems = []
    if lines > 200:
        problems.append(f"{lines} lines (> 200)")
    missing = [s for s in CLAUDE_SECTIONS if s not in headings]
    if missing:
        problems.append("missing sections: " + ", ".join(missing))
    if VERSION_PATTERN.search(text):
        problems.append("hard-coded canonical version")
    run.record("VER-P0-CLAUDE-001", "FAIL" if problems else "PASS", "; ".join(problems) if problems else f"{lines} lines; required sections present; no hard-coded version")


def frontmatter(text):
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---", 4)
    if end == -1:
        return None
    fields = {}
    for line in text[4:end].splitlines():
        match = re.match(r"^([A-Za-z_][\w-]*):\s*(.*)$", line)
        if match:
            fields[match.group(1)] = match.group(2).strip()
    return fields


def check_skills(run):
    problems = []
    skills = rel_paths(run.repo, ".claude/skills/*/SKILL.md")
    for s in skills:
        text = run.read(s)
        fm = frontmatter(text)
        if not fm or not fm.get("name") or not fm.get("description"):
            problems.append(f"{s}: invalid frontmatter")
        headings = set(re.findall(r"^## (.+?)\s*$", text, re.M))
        missing = [h for h in SKILL_SECTIONS if h not in headings]
        if missing:
            problems.append(f"{s}: missing sections {missing}")
        skill_name = s.split("/")[-2]
        if skill_name in USER_INVOKED_ONLY_SKILLS and (fm or {}).get("disable-model-invocation", "").lower() != "true":
            problems.append(f"{s}: side-effecting Skill must declare disable-model-invocation: true")
    if not skills:
        problems.append("no skills found")
    for name in USER_INVOKED_ONLY_SKILLS:
        if f".claude/skills/{name}/SKILL.md" not in skills:
            problems.append(f".claude/skills/{name}/SKILL.md missing")
    run.record("VER-P0-SKILLS-001", "FAIL" if problems else "PASS", "; ".join(problems) if problems else f"{len(skills)} skills conform")


def check_agents(run):
    problems = []
    allowed = {"Read", "Grep", "Glob"}
    required_disallowed = {"Write", "Edit", "NotebookEdit", "Bash", "PowerShell"}
    for name in REVIEWERS:
        rel = f".claude/agents/{name}.md"
        if not os.path.isfile(run.path(rel)):
            problems.append(f"{rel}: missing")
            continue
        text = run.read(rel)
        fm = frontmatter(text) or {}
        tools = {t.strip() for t in fm.get("tools", "").split(",") if t.strip()}
        disallowed = {t.strip() for t in fm.get("disallowedTools", "").split(",") if t.strip()}
        if fm.get("name") != name:
            problems.append(f"{rel}: name mismatch")
        if not tools or not tools <= allowed:
            problems.append(f"{rel}: tools {sorted(tools)} not within Read/Grep/Glob")
        if not required_disallowed <= disallowed:
            problems.append(f"{rel}: disallowedTools missing {sorted(required_disallowed - disallowed)}")
        headings = set(re.findall(r"^## (.+?)\s*$", text, re.M))
        for h in ("Role", "Scope", "Read-only Constraints"):
            if h not in headings:
                problems.append(f"{rel}: missing section {h}")
        if "Do not modify" not in text:
            problems.append(f"{rel}: no explicit prohibition on modifying the repository")
    run.record("VER-P0-AGENTS-CONFIG-001", "FAIL" if problems else "PASS", "; ".join(problems) if problems else f"{len(REVIEWERS)} reviewer agents conform")


def bash_path():
    candidate = os.environ.get("SENTINEL_BASH")
    if candidate and os.path.isfile(candidate):
        return candidate
    return shutil.which("bash")


def run_control(run, script, ver_ids):
    """Run a control script and import its RECORD lines."""
    bash = bash_path()
    proc = subprocess.run([bash, run.path(script)], cwd=run.repo, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out = proc.stdout.decode("utf-8", "replace")
    seen = set()
    for line in out.splitlines():
        if line.startswith("RECORD|"):
            parts = line.split("|", 4)
            if len(parts) == 5 and parts[1] in ver_ids and parts[2] in RESULTS and parts[3] in ("CONTINUE", "STOP"):
                run.record(parts[1], parts[2], parts[4], action=parts[3], command=f"[REAL REPO read-only; TEMP material] bash {script}", exit_code=proc.returncode)
                seen.add(parts[1])
        elif line.startswith("INFO|"):
            print("  " + line)
    for ver in ver_ids:
        if ver not in seen:
            run.record(ver, "FAIL", f"control script produced no valid record (exit {proc.returncode})", command=f"bash {script}", exit_code=proc.returncode)


def check_hooks(run):
    if not bash_path():
        run.record("VER-P0-HOOKS-001", "BLOCKED", "prerequisite false: bash is not executable")
        return
    run_control(run, "scripts/checks/claude-guardrails.sh", ["VER-P0-HOOKS-001"])


def check_format(run):
    reasons = []
    if os.path.isfile(run.path("package.json")) and "prettier" in run.read("package.json"):
        reasons.append("package.json declares prettier")
    if glob.glob(run.path(".prettierrc*")) or glob.glob(run.path("prettier.config.*")):
        reasons.append("prettier configuration file present")
    pc = run.read(".pre-commit-config.yaml") if os.path.isfile(run.path(".pre-commit-config.yaml")) else ""
    if re.search(r"prettier|black|ruff-format|\bformat\b", pc):
        reasons.append(".pre-commit-config.yaml declares a formatter hook")
    if not reasons:
        run.record("VER-P0-FORMAT-001", "NOT APPLICABLE", "Phase 0 formatter contract not established; formatter selection belongs to Phase 1 (checked: package.json, .prettierrc*, prettier.config.*, .pre-commit-config.yaml)")
        return
    if "package.json declares prettier" in reasons and shutil.which("pnpm"):
        proc = subprocess.run(["pnpm", "exec", "prettier", "--check", "**/*.{md,yml,yaml,json}"], cwd=run.repo, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        run.record("VER-P0-FORMAT-001", "PASS" if proc.returncode == 0 else "FAIL", f"declared formatter exit {proc.returncode}", command="[REAL REPO] pnpm exec prettier --check", exit_code=proc.returncode)
    else:
        run.record("VER-P0-FORMAT-001", "FAIL", "formatter contract present (" + "; ".join(reasons) + ") but no declared runner is executable by this script")


def check_gitleaks_controls(run):
    gitleaks = shutil.which("gitleaks") or shutil.which("gitleaks.exe")
    if not gitleaks:
        for ver in ("VER-P0-GITLEAKS-NEG", "VER-P0-GITLEAKS-POS"):
            run.record(ver, "BLOCKED", "prerequisite false: gitleaks is not executable")
        return
    run_control(run, "scripts/checks/gitleaks-controls.sh", ["VER-P0-GITLEAKS-NEG", "VER-P0-GITLEAKS-POS"])


def check_gitleaks_history(run):
    if not run.state.get("commit_count"):
        run.record("VER-P0-GITLEAKS-HISTORY", "NOT APPLICABLE", "applicability false: commit_count == 0")
        return
    gitleaks = shutil.which("gitleaks") or shutil.which("gitleaks.exe")
    if not gitleaks:
        run.record("VER-P0-GITLEAKS-HISTORY", "BLOCKED", "prerequisite false: gitleaks is not executable")
        return
    proc = subprocess.run([gitleaks, "git", run.repo, "--redact", "--no-banner", "--log-level", "error"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    run.record("VER-P0-GITLEAKS-HISTORY", "PASS" if proc.returncode == 0 else "FAIL", f"gitleaks git exit {proc.returncode}", command="[REAL REPO] gitleaks git --redact", exit_code=proc.returncode)


def check_precommit(run):
    run_control(run, "scripts/checks/pre-commit-controls.sh", ["VER-P0-PRECOMMIT-NEG", "VER-P0-PRECOMMIT-POS"])


def check_ci_config(run):
    try:
        import yaml  # PyYAML
    except ImportError:
        run.record("VER-P0-CI-CONFIG", "FAIL", f"YAML parser (PyYAML) unavailable in {sys.executable}; required verification machinery")
        return
    problems = []
    try:
        wf = yaml.safe_load(run.read(".github/workflows/security.yml"))
        pc = yaml.safe_load(run.read(".pre-commit-config.yaml"))
    except Exception as exc:
        run.record("VER-P0-CI-CONFIG", "FAIL", f"YAML does not parse: {type(exc).__name__}")
        return
    triggers = wf.get("on", wf.get(True)) or {}
    if "pull_request" not in triggers:
        problems.append("no pull_request trigger")
    if "main" not in ((triggers.get("push") or {}).get("branches") or []):
        problems.append("no push trigger for main")
    if wf.get("permissions") != {"contents": "read", "pull-requests": "read"}:
        problems.append(f"permissions {wf.get('permissions')} != contents: read, pull-requests: read")
    steps = [s for job in (wf.get("jobs") or {}).values() for s in (job.get("steps") or [])]
    uses = {}
    for s in steps:
        if "uses" in s:
            name, _, ref = s["uses"].partition("@")
            uses[name] = (ref, s)
    for action, sha in EXPECTED_ACTIONS.items():
        ref = uses.get(action, (None, None))[0]
        if ref != sha:
            problems.append(f"{action} pinned to '{ref}', expected {sha}")
    unpinned = [n for n, (ref, _) in uses.items() if not re.fullmatch(r"[0-9a-f]{40}", ref or "")]
    if unpinned:
        problems.append("not pinned to a full commit SHA: " + ", ".join(unpinned))
    checkout = uses.get("actions/checkout", (None, {}))[1] or {}
    if (checkout.get("with") or {}).get("fetch-depth") != 0:
        problems.append("checkout fetch-depth is not 0")
    leaks = uses.get("gitleaks/gitleaks-action", (None, {}))[1] or {}
    ci_version = str((leaks.get("env") or {}).get("GITLEAKS_VERSION"))
    revs = [r.get("rev") for r in (pc.get("repos") or []) if "gitleaks" in str(r.get("repo"))]
    if not revs or revs[0].lstrip("v") != ci_version:
        problems.append(f"GITLEAKS_VERSION {ci_version} != pre-commit rev {revs}")
    run.record("VER-P0-CI-CONFIG", "FAIL" if problems else "PASS", "; ".join(problems) if problems else "static configuration conforms (not operational verification)", command="[REAL REPO] static YAML inspection")


def check_ci_exec(run):
    missing = []
    if not run.state.get("remotes"):
        missing.append("no remote repository configured")
    if not run.args.get("ci_run_url"):
        missing.append("no CI run URL supplied (--ci-run-url)")
    if missing:
        run.record("VER-P0-CI-EXEC", "BLOCKED", "prerequisite false: " + "; ".join(missing))
        return
    detected = run.args.get("ci_run_detected") == "yes"
    run.record("VER-P0-CI-EXEC", "PASS" if detected else "FAIL",
               f"run {run.args['ci_run_url']}: detection demonstrated={detected}", command="[REMOTE HOST] CI run evidence")


def check_repo_protection(run):
    missing = []
    if not run.state.get("remotes"):
        missing.append("no remote repository configured")
    gh = shutil.which("gh")
    if not gh:
        missing.append("repository host settings not inspectable (gh CLI unavailable)")
    if missing:
        run.record("VER-P0-REPO-PROTECTION", "BLOCKED", "prerequisite false: " + "; ".join(missing))
        return
    proc = subprocess.run([gh, "api", "repos/{owner}/{repo}/branches/main/protection/required_status_checks"], cwd=run.repo, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc.returncode != 0:
        run.record("VER-P0-REPO-PROTECTION", "FAIL", "required status checks not readable or not configured for main", command="[REMOTE HOST] gh api (read-only)", exit_code=proc.returncode)
        return
    try:
        data = json.loads(proc.stdout.decode())
        contexts = set(data.get("contexts") or []) | {c.get("context") for c in data.get("checks") or []}
    except Exception:
        contexts = set()
    ok = "Secret scanning" in contexts
    run.record("VER-P0-REPO-PROTECTION", "PASS" if ok else "FAIL", f"required contexts: {sorted(c for c in contexts if c)}", command="[REMOTE HOST] gh api (read-only)", exit_code=proc.returncode)


def check_git_safety(run):
    baseline_path = run.args.get("baseline")
    if not baseline_path:
        run.record("VER-P0-GIT-SAFETY-001", "FAIL", "baseline snapshot not supplied (--baseline); cannot evaluate")
        return
    try:
        with open(baseline_path, encoding="utf-8") as handle:
            baseline = json.load(handle)
    except Exception as exc:
        run.record("VER-P0-GIT-SAFETY-001", "FAIL", f"baseline snapshot unreadable: {type(exc).__name__}")
        return
    current = run.state.get("snapshot") or {}
    b_files, c_files = baseline.get("files") or {}, current.get("files") or {}
    changed = sorted(set(b_files) ^ set(c_files) | {p for p in set(b_files) & set(c_files) if b_files[p] != c_files[p]})
    outside = [p for p in changed if p not in EVIDENCE_FILES]
    problems = []
    if baseline.get("commit_count") != current.get("commit_count"):
        problems.append(f"commit_count {baseline.get('commit_count')} -> {current.get('commit_count')}")
    if baseline.get("remotes") != current.get("remotes"):
        problems.append("remotes changed")
    if outside:
        problems.append("changes outside the evidence-file exception: " + ", ".join(outside))
    detail = (f"commit_count={current.get('commit_count')} remotes_unchanged={baseline.get('remotes') == current.get('remotes')} "
              f"changed_since_baseline={changed or 'none'}; command-label and --no-verify conditions are attested by orchestration")
    if problems:
        run.record("VER-P0-GIT-SAFETY-001", "FAIL", "; ".join(problems), action="STOP")
    else:
        run.record("VER-P0-GIT-SAFETY-001", "PASS", detail)


CHECKS = [
    check_docs, check_status_doc, check_status_adr, check_status_phase, check_status_record,
    check_lifecycle, check_accept, check_template, check_versionref, check_claude,
    check_skills, check_agents, check_format, check_hooks, check_gitleaks_controls,
    check_gitleaks_history, check_precommit, check_ci_config, check_ci_exec,
    check_repo_protection,
]


def capture_state(run):
    proc = subprocess.run([run.python, run.path("scripts/checks/repo_snapshot.py"), "capture", "--repo", run.repo],
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc.returncode != 0:
        raise RuntimeError("repo_snapshot.py capture failed: " + proc.stderr.decode("utf-8", "replace").strip())
    snap = json.loads(proc.stdout.decode("utf-8"))
    run.state = {
        "snapshot": snap,
        "commit_count": snap["commit_count"],
        "porcelain_hash": snap["porcelain_hash"],
        "working_tree_content_hash": snap["working_tree_content_hash"],
        "remotes": snap["remotes"],
    }


def main(argv):
    if not argv or argv[0].startswith("-"):
        print("usage: verify-phase.sh <phase-id> [--baseline SNAPSHOT.json] [--json-out PATH] [--ci-run-url URL] [--ci-run-detected yes|no]", file=sys.stderr)
        return 1
    phase, rest = argv[0], argv[1:]
    args = {}
    keys = {"--baseline": "baseline", "--json-out": "json_out", "--ci-run-url": "ci_run_url", "--ci-run-detected": "ci_run_detected"}
    while rest:
        if rest[0] not in keys or len(rest) < 2:
            print(f"verify-phase: unknown or incomplete option {rest[0]}", file=sys.stderr)
            return 1
        args[keys[rest[0]]] = rest[1]
        rest = rest[2:]

    repo = os.environ["SENTINEL_REPO"]
    run = Run(repo, sys.executable, args)

    if args.get("json_out"):
        target = os.path.normcase(os.path.abspath(args["json_out"]))
        root = os.path.normcase(os.path.abspath(repo))
        try:
            inside = os.path.commonpath([target, root]) == root
        except ValueError:  # different drives
            inside = False
        if inside:
            print("verify-phase: --json-out must be outside the repository", file=sys.stderr)
            return 1

    if phase != "phase-0":
        print(f"verify-phase: FAIL — no verification table is defined for '{phase}'", file=sys.stderr)
        return 1

    # Evidence location is declared by docs/phases/README.md (§25a).
    readme = run.read("docs/phases/README.md")
    match = re.search(r"^Verification record path:\s*(\S+)\s*$", readme, re.M)
    evidence = match.group(1).replace("{phase}", phase) if match else None

    print("=" * 72)
    print(f"Sentinel AI phase verification — {phase}")
    print("=" * 72)
    try:
        capture_state(run)
    except Exception as exc:
        print(f"verify-phase: FAIL — {exc}", file=sys.stderr)
        return 1
    print(f"timestamp_utc={utcnow()}")
    print(f"repo={repo}")
    print(f"commit_count={run.state['commit_count']} head={run.state['snapshot']['head']}")
    print(f"porcelain_hash={run.state['porcelain_hash']}")
    print(f"working_tree_content_hash={run.state['working_tree_content_hash']}")
    print(f"remotes={run.state['remotes'] or 'none'}")
    print(f"evidence_location={evidence or 'NOT DECLARED'}")
    print("-" * 72)

    if not evidence:
        run.record("VER-P0-DOCS-001", "FAIL", "docs/phases/README.md does not declare the verification record path")

    for check in CHECKS:
        if run.stopped:
            break
        try:
            check(run)
        except Exception as exc:  # machinery defect is a FAIL for that check
            run.record(f"VER-P0-MACHINERY ({check.__name__})", "FAIL", f"verification machinery error: {type(exc).__name__}: {exc}")

    if not run.stopped:
        try:
            capture_state(run)
            check_git_safety(run)
        except Exception as exc:
            run.record("VER-P0-GIT-SAFETY-001", "FAIL", f"verification machinery error: {exc}")

    counts = {r: sum(1 for rec in run.records if rec["result"] == r) for r in RESULTS}
    illegal_blocked = sorted(rec["ver"] for rec in run.records if rec["result"] == "BLOCKED" and rec["ver"] not in TRANSITION_PERMITTED_BLOCKED)
    na_without_reason = [rec["ver"] for rec in run.records if rec["result"] == "NOT APPLICABLE" and not rec["detail"]]
    conditions_met = counts["FAIL"] == 0 and not run.stopped and not illegal_blocked and not na_without_reason

    print("-" * 72)
    print("Summary: " + ", ".join(f"{r}={counts[r]}" for r in RESULTS))
    print(f"process_action={'STOP' if run.stopped else 'CONTINUE'}")
    if illegal_blocked:
        print("BLOCKED outside TRANSITION_PERMITTED_BLOCKED: " + ", ".join(illegal_blocked))
    print(f"D1_SCRIPT_CONDITIONS={'met' if conditions_met else 'not-met'}")
    print("Review checks (VER-P0-REVIEW-*) are evaluated by verification orchestration, not by this script.")
    print("Exit 0 does not by itself establish eligibility for the Verification phase status.")

    if args.get("json_out"):
        with open(args["json_out"], "w", encoding="utf-8") as handle:
            json.dump({"phase": phase, "records": run.records, "counts": counts,
                       "process_action": "STOP" if run.stopped else "CONTINUE",
                       "d1_script_conditions": "met" if conditions_met else "not-met"}, handle, indent=2)

    return 0 if counts["FAIL"] == 0 and not run.stopped else 1


sys.exit(main(sys.argv[1:]))
PY
)"

# Interpreter path for control scripts, in the form the Python process can open
# (Windows path under Git Bash, unchanged elsewhere).
BASH_FOR_PYTHON="$(cygpath -w "$BASH" 2>/dev/null || printf '%s' "$BASH")"

# The program is passed on standard input (avoids command-line length limits).
SENTINEL_REPO="$REPO" SENTINEL_BASH="$BASH_FOR_PYTHON" "$PYTHON" - "$@" <<<"$PROGRAM"
