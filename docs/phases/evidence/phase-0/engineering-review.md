# Sentinel AI — Phase 0 Engineering Review (Layer 1)

**File:** `docs/phases/evidence/phase-0/engineering-review.md`  
**Phase:** P0 (Task 0.25)  
**Record status:** Recorded

This record holds the Layer 1 five-perspective review performed by the main Claude Code session. It is **not** an independent review; the independent review is recorded in `independent-review.md`. It never states or implies the Phase 0 lifecycle status.

## 1. Perspectives

1. Software engineering
2. Architecture
3. Security
4. AI engineering
5. Documentation / governance

## 2. Required Fields per Perspective

- perspective;
- reviewer (main session);
- UTC timestamp;
- findings, each with severity, evidence (file and line), recommendation, and whether remediation is required before Phase 0 completion.

PASS for the review check (`VER-P0-REVIEW-L1`) means that the review was successfully performed with the required integrity/evidence conditions. It does not mean that the reviewer found no issues.

## 3. Runs

### Run 1 — 2026-10-03

- **Reviewer:** main Claude Code session (implementer; not independent)
- **Baseline:** S1″ (2026-10-03T19:56:01Z), `working_tree_content_hash` `9a8f9830ef6c94bcbe3ccb78869353cc44cc75c449fbf0b2bb9b95d564d78bc2`, `commit_count` 0, no remotes
- **Inputs:** the repository at S1″; deterministic verification run 1 (`verification-record.md`, Run 1); contradiction sweep (`contradiction-review.md`, Run 1)
- **Timestamp (UTC):** 2026-10-03T20:17Z — written between verification run 1 completion (20:16:05Z start) and the Layer 2 pre-flight (20:18:04Z). Correction: the first write of this record stated 20:20Z in error; corrected before the record was finalized.

Severity scale: **High** blocks the Verification transition; **Medium** must be resolved or explicitly accepted before Complete; **Low** non-blocking.

#### 3.1 Software engineering

| ID     | Severity | Finding | Evidence | Recommendation | Required before completion |
| ------ | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-SE-1 | Medium  | The verification checks are implemented as a Python program embedded in a Bash heredoc. The FAIL and BLOCKED branches (for example the `VER-P0-ACCEPT-001` inconsistency paths) have no automated tests; run 1 exercised only the current repository state. | `scripts/verify-phase.sh` (embedded program) | When Phase 1 defines the toolchain, extract the checks into a tested module with fixture-based tests for each result branch. | No |
| L1-SE-2 | Low     | Machinery errors are recorded under a pseudo-ID that is not in the declared verification table. | `scripts/verify-phase.sh:776` | Map machinery errors to the VER ID of the failing check. | No |
| L1-SE-3 | Low     | The guardrail hook's pattern matching denies any shell command whose text contains `--no-verify`, including commands that only write documentation. This was observed during Rev. 13.1 implementation (implementation evidence, not a verification result). | `.claude/hooks/block-dangerous-command.sh` (`--no-verify` rule) | Accept as a known bounded false positive; documentation edits use the file-edit tool. | No |

#### 3.2 Architecture

| ID     | Severity | Finding | Evidence | Recommendation | Required before completion |
| ------ | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-AR-1 | Low     | The architecture invariant summary in `CLAUDE.md` omits "internal domain persistence" from the Next.js prohibition. The complete wording is in the Rule. | `CLAUDE.md:68`; `.claude/rules/architecture.md:25-28` | Align the summary wording with the Rule. | No |
| L1-AR-2 | Low     | `TRANSITION_PERMITTED_BLOCKED`, a phase-governance rule, is defined as a constant in a script rather than in a governance document (as the approved plan specified). | `scripts/verify-phase.sh:51`; Phase 0 document, Exit Criteria condition 3 | Consider moving the definition into the Phase 0 document with the script reading it, in a later governance revision. | No |
| L1-AR-3 | Info    | No contradiction between the architecture documents and the current canonical specification was found. The context diagram routes clients to the FastAPI boundary; topology is labelled as an implementation-level convention; DEP-001 is recorded as an open dependency. | `docs/architecture/context.md` §4; `docs/architecture/system-architecture.md` §2; `docs/decisions/decision-register.md` §5 | None. | No |

#### 3.3 Security

| ID      | Severity | Finding | Evidence | Recommendation | Required before completion |
| ------- | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-SEC-1 | Medium  | CI execution and repository protection are unverified (no remote). CI scanning alone is detective, not preventive. | Verification run 1: `VER-P0-CI-EXEC` BLOCKED, `VER-P0-REPO-PROTECTION` BLOCKED; `docs/architecture/security-architecture.md` §6 | Satisfy the external prerequisite sequence (commit, remote, push, CI run), then configure required status checks. | Yes (existing completion gate) |
| L1-SEC-2 | Medium  | `gitleaks-action` requires a `GITLEAKS_LICENSE` secret when the repository is owned by an organization. This is not documented; the first CI run would fail on an organization-owned repository. | `.github/workflows/security.yml` (no `GITLEAKS_LICENSE`); upstream action README | Document the requirement and decide the repository owner type before the first CI run. | Before `VER-P0-CI-EXEC` can pass |
| L1-SEC-3 | Low     | The `Read` deny rules cover `.env` but not variants such as `.env.local`. | `.claude/settings.json:28-29` | Consider adding variant patterns that do not block `.env.example`. | No |
| L1-SEC-4 | Info    | Positive controls passed: synthetic `ghp_` token detected by rule `github-pat`, absent from the repository; secret commit rejected in the temporary repository. | Verification run 1: `VER-P0-GITLEAKS-POS`, `VER-P0-PRECOMMIT-POS` | None. | No |

#### 3.4 AI engineering

| ID     | Severity | Finding | Evidence | Recommendation | Required before completion |
| ------ | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-AI-1 | Low     | REQ-PLATFORM-007 depends on an undefined consequential-change classification. This is correctly recorded as open dependency DEP-001 and is not defined in Phase 0. | `docs/product/requirements.md` REQ-PLATFORM-007; `docs/decisions/decision-register.md` §5 | Resolve DEP-001 before the first phase that implements consequential AI-generated remediation. | No |
| L1-AI-2 | Low     | `documentation-authority.md` and `ai-architecture.md` §7 name `docs/ai/` as the AI evaluation authority, but the directory does not exist. | `docs/architecture/documentation-authority.md` §4; `docs/architecture/ai-architecture.md` §7 | Create when AI evaluation work begins; no placeholder now. | No |

#### 3.5 Documentation / governance

| ID      | Severity | Finding | Evidence | Recommendation | Required before completion |
| ------- | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-DOC-1 | Medium  | All six acceptance-gate items are genuinely pending: no owner acceptance is recorded for documentation-authority, the canonical README, phases README, decisions README, the acceptance register, or the Phase 0 document content. Governance documents are `Proposed` while operative, as decided. | Verification run 1: `VER-P0-ACCEPT-001` BLOCKED | Owner records acceptance entries in `docs/architecture/acceptance-register.md` when satisfied. | Yes (existing completion gate) |
| L1-DOC-2 | Info    | Contradiction sweep found no stale status strings, old ADR paths, removed-artifact references, duplicated incident procedures, or hard-coded canonical versions in generic governance files. | `contradiction-review.md`, Run 1 | None. | No |

#### 3.6 Summary

- High: 0. Medium: 4 (L1-SE-1, L1-SEC-1, L1-SEC-2, L1-DOC-1). Low: 7. Info: 3.
- L1-SEC-1 and L1-DOC-1 correspond to existing completion gates already reported as BLOCKED by deterministic checks.
- No finding requires a consequential architectural, product, or security decision during this verification stage.
