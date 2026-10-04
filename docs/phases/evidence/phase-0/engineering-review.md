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

**Section status:** Superseded by Run 2 (re-verification at C2).

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

### Run 2 — 2026-10-03 (re-verification at C2)

**Section status:** Superseded by Run 3 (re-verification at C4).

- **Reviewer:** main Claude Code session (implementer; not independent)
- **Baseline:** C2 `b40505dc0402c17b5acc5cf5033ef0ee0c8d9421` (parent C1 `a6d58ce0f9d66cd3d14271ad0a0c642174220f14`); clean working tree; `working_tree_content_hash` `26d12208e1ef83c070432c296b27cbb9af75cf87f52a23c5d8710363276c5e36`; `commit_count` 2; no remotes
- **Inputs:** the repository at C2; deterministic suite at 2026-10-03T23:41:52Z (`verification-record.md` Run 2); acceptance-record checks; contradiction sweep (`contradiction-review.md` Run 2)
- **Timestamp (UTC):** 2026-10-03T23:44Z

#### 3.7 Status of Run 1 findings

| ID | Run 2 status | Evidence |
| -- | ------------ | -------- |
| L1-SE-1 (Medium) | Open | Unchanged: `scripts/verify-phase.sh` embedded program; result branches still untested |
| L1-SE-2 (Low) | Open | `scripts/verify-phase.sh` machinery pseudo-ID unchanged |
| L1-SE-3 (Low) | Open (known) | Guardrail hook pattern unchanged |
| L1-AR-1 (Low) | Open | `CLAUDE.md:68` unchanged |
| L1-AR-2 (Low) | Open | `scripts/verify-phase.sh:51` unchanged |
| L1-SEC-1 (Medium) | Open | `VER-P0-CI-EXEC`, `VER-P0-REPO-PROTECTION` still BLOCKED |
| L1-SEC-2 (Medium) | Open — owner decision pending | Source: gitleaks-action v3.0.0 README ("required for organizations, not required for user accounts"), fetched 2026-10-03 |
| L1-SEC-3 (Low) | Open | `.claude/settings.json` unchanged |
| L1-AI-1 (Low) | Open (recorded dependency DEP-001) | `docs/decisions/decision-register.md` §5 |
| L1-AI-2 (Low) | Open | `docs/ai/` absent |
| L1-DOC-1 (Medium) | **Resolved** | Acceptance recorded in C2 (ACC-002–ACC-007, each referencing C1); `VER-P0-ACCEPT-001` PASS |

#### 3.8 New findings

| ID | Severity | Finding | Evidence | Recommendation | Required before completion |
| -- | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-R2-1 | High (for completion) | The CI detection criterion cannot be met as written. P0-AC-021 / Task 0.20 require a real CI run that detects a deliberately introduced test secret, but synthetic credentials are "never committed", the local pre-commit hook rejects such a commit, and the hook-bypass flag is prohibited. | Phase 0 document P0-AC-021 (line 1113) and Task 0.20; `docs/security/secret-incident-response.md:34`; `VER-P0-PRECOMMIT-POS` | Owner decision on how CI detection is demonstrated (for example a throwaway repository, a CI-side runtime positive control, or a reworded criterion). | Yes |
| L1-R2-2 | Medium | `VER-P0-REPO-PROTECTION` requires the `gh` CLI to inspect host settings; `gh` is not installed, so the check stays BLOCKED even after a remote exists. | `scripts/verify-phase.sh:642`; `command -v gh` empty | Install and authenticate `gh`, or decide an alternative inspection method (governance change). | Yes |
| L1-R2-3 | Medium | Phase 0 can reach `Complete` with every Layer 2 review BLOCKED, because the completion rule inherits the Verification-entry conditions. With the current tool contract, no independent review can run. | Phase 0 document Exit Criteria; `independent-review.md`; phases README §26 | Owner decision whether `Complete` requires an independent review. | Owner decision |
| L1-R2-4 | Low | The Phase 0 document's Final Verification section is still a placeholder although the phase is in `Verification`. Editing it does not invalidate ACC-007 (acceptance-register §2). | Phase 0 document line 1236 | Update under a separately authorized change. | No |
| L1-R2-5 | Low | 13 working-copy text files are CRLF and 43 LF (`core.autocrlf=true`; `.gitattributes` covers only `*.sh`). Committed content is LF and Git reports no change, but `working_tree_content_hash` hashes working-copy bytes, so the hash depends on the checkout's line-ending state and is not comparable across differently configured checkouts. | `git ls-files --eol`; `scripts/checks/repo_snapshot.py` | Compare snapshots only within one checkout (as done), or decide a repository line-ending policy later. | No |
| L1-R2-6 | Info | The five accepted governance documents and ACC-007's Phase 0 content now require fresh acceptance for any substantive change; remediation of open findings in those files must be planned with that in mind. | `docs/architecture/acceptance-register.md` §2 | — | No |

#### 3.9 Summary

- High: 1 (L1-R2-1, completion-blocking). Medium: 5 open (L1-SE-1, L1-SEC-1, L1-SEC-2, L1-R2-2, L1-R2-3). Low: 9. Info: 1. Resolved since Run 1: L1-DOC-1.
- No finding requires a consequential architectural decision; L1-R2-1, L1-R2-2, and L1-R2-3 require owner governance decisions before completion.

### Run 3 — 2026-10-04 (re-verification at C4)

**Section status:** Superseded by Run 4 (fresh verification at C7).

- **Reviewer:** main Claude Code session (implementer; not independent)
- **Baseline:** C4 `8b833081f257eb82af26fd0991697f1e518f6287` (C3 `5d89f3cf…`, C2 `b40505dc…`, C1 `a6d58ce0…`); working tree differs from C4 only by the four uncommitted Run 2 evidence records; `working_tree_content_hash` `fee107c5232037cf97f331b31d20d0de3d82761422b8da16a6ad6c17be1924b8`; `commit_count` 4; no remotes
- **Inputs:** the repository at C4; deterministic suite at 2026-10-04T00:41:15Z (`verification-record.md` Run 3); acceptance/version checks; contradiction sweep (`contradiction-review.md` Run 3)
- **Timestamp (UTC):** 2026-10-04T00:43Z

#### 3.10 Status of earlier findings

| ID | Run 3 status | Evidence |
| -- | ------------ | -------- |
| L1-SE-1 (Medium) | Open | Embedded checks still lack branch tests |
| L1-SE-2 (Low) | Open | Machinery pseudo-ID unchanged |
| L1-SE-3 (Low) | Open (known) | Guardrail hook pattern unchanged |
| L1-AR-1 (Low) | Open | `CLAUDE.md:68` unchanged |
| L1-AR-2 (Low) | Open | `scripts/verify-phase.sh:51` unchanged |
| L1-SEC-1 (Medium) | Open | `VER-P0-CI-EXEC`, `VER-P0-REPO-PROTECTION` BLOCKED |
| L1-SEC-2 (Medium) | Open — owner decision pending | gitleaks-action v3.0.0 README: `GITLEAKS_LICENSE` "required for organizations, not required for user accounts" |
| L1-SEC-3 (Low) | Open | `.claude/settings.json` unchanged |
| L1-AI-1 (Low) | Open (DEP-001) | decision register §5 |
| L1-AI-2 (Low) | Open | `docs/ai/` absent |
| L1-R2-1 (High) | **Resolved** | C3: P0-AC-021 and Task 0.20 Tests define objective CI evidence; CI positive-control job added; ACC-008. Operational CI remains unexecuted. |
| L1-R2-2 (Medium) | Open | Repository-protection check still requires `gh`; not installed |
| L1-R2-3 (Medium) | **Resolved** | C3: P0-AC-025 admits the permitted BLOCKED state; ACC-008 |
| L1-R2-4 (Low) | Open (deferred by owner to the completion record) | Phase 0 document line 1236 |
| L1-R2-5 (Low) | Open (owner: no change now) | line-ending state |
| L1-R2-6 (Info) | Applies | ACC-008 was required by this rule |

#### 3.11 New findings

| ID | Severity | Finding | Evidence | Recommendation | Required before completion |
| -- | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-R3-1 | Medium | `VER-P0-ACCEPT-001` matches register entries by document path only. It cannot detect that a document changed after its accepted version; the acceptance-to-version relationship is verified only by orchestration (Run 3 confirmed it for ACC-001 to ACC-008). | `scripts/verify-phase.sh` (`check_accept`, `parse_register`) | Extend the check to compare each entry's accepted commit with the current content under the register §2 rules, in a separately governed change. | No (orchestration check performed) |
| L1-R3-2 | Low | `VER-P0-CI-CONFIG` evaluates only the last step per action name: `fetch-depth` is read from the last `actions/checkout` step and `GITLEAKS_VERSION` only from the `gitleaks-action` step. The positive-control job's checkout ordering and its own `GITLEAKS_VERSION` are not checked against DR-P0-001. | `scripts/verify-phase.sh` (`check_ci_config`); `.github/workflows/security.yml` | Make the check job-aware in a separately governed change. | No |
| L1-R3-3 | Low | "Substantive content change" (register §2) is not defined for whitespace-only reformatting. During C3 preparation an external format-on-save re-padded tables in the accepted Phase 0 document; the owner treated it as unauthorized and the reviewed content was restored before committing (implementation evidence). | `docs/architecture/acceptance-register.md` §2; C3 history | Owner decision whether whitespace-only formatting of accepted documents requires fresh acceptance. | No |
| L1-R3-4 | Low | The Run 2 and Run 3 evidence records exist only as uncommitted working-tree changes; they are not yet preserved in repository history. | `git status` | Commit the evidence under a separate authorization. | Before the completion record |
| L1-R3-5 | Info | `VER-P0-CI-EXEC` still passes on an orchestration attestation (`--ci-run-detected yes`); P0-AC-021 is now objective, so the attestation must be based on reading the positive-control and history-scan job logs. | `scripts/verify-phase.sh` (`check_ci_exec`) | Record the job-log evidence with the CI run URL. | At the CI stage |
| L1-R3-6 | Info | The CI positive-control job downloads Gitleaks from the official release at run time; integrity is pinned by SHA-256, availability depends on the release host. | `.github/workflows/security.yml` | None now. | No |
| L1-R3-7 | Low | Tasks 0.1, 0.2, 0.3, 0.4, 0.6, 0.12 and 0.21 say content "is assessed by the review layers" (Task 0.1 cites P0-AC-024 and P0-AC-025); Tasks 0.2–0.6, 0.12, 0.16, 0.17, 0.21 and 0.22 cite "review records" as evidence. With all Layer 2 reviewers permissibly BLOCKED, only Layer 1 (non-independent) has assessed that content. Not a contradiction after the P0-AC-025 amendment, but the wording overstates the assessment performed. | Phase 0 document (for example line 106) | Clarify in a future governed revision of the Phase 0 document. | No |

#### 3.12 Summary

- High: 0. Medium open: 5 (L1-SE-1, L1-SEC-1, L1-SEC-2, L1-R2-2, L1-R3-1). Low open: 12. Info: 3. Resolved since Run 2: L1-R2-1, L1-R2-3.
- No finding requires a consequential architectural decision. No governance contradiction remains; L1-R3-3 is an undefined-term ambiguity and L1-R3-7 a wording overstatement.

#### 3.13 Correction note and owner dispositions (recorded 2026-10-04, after the Run 3 S2 snapshot)

**Correction note.** The L1-R3-7 row in §3.11 was corrected while Run 3 was still being written, before `VER-P0-REVERIFY-003` and the Run 3 S2 snapshot, so both evaluated the corrected text. Only the task list changed; the rest of the row is unchanged.

- Before: `Tasks 0.1–0.6, 0.12, 0.16, 0.21 and 0.22 say content is "assessed by the review layers (P0-AC-024, P0-AC-025)".`
- After: `Tasks 0.1, 0.2, 0.3, 0.4, 0.6, 0.12 and 0.21 say content "is assessed by the review layers" (Task 0.1 cites P0-AC-024 and P0-AC-025); Tasks 0.2–0.6, 0.12, 0.16, 0.17, 0.21 and 0.22 cite "review records" as evidence.`

**Owner dispositions.**

| ID | Disposition | Basis |
| -- | ----------- | ----- |
| L1-SEC-2 | **Closed** for the current Phase 0 scope | Owner decision: the repository is personally owned through the owner's personal GitHub account, not a GitHub organization. The pinned gitleaks-action README (v3.0.0, `e0c47f4f8be36e29cdc102c57e68cb5cbf0e8d1e`) states that `GITLEAKS_LICENSE` is "Only required for Organizations, not personal accounts". No licence secret and no workflow change are required. A later transfer to an organization would be a new decision. |
| L1-R3-1 | **Deferred** | Owner disposition: manual acceptance/version validation (Run 3 R3.2) remains the compensating measure for this verification cycle. Verification tooling unchanged. |
| L1-R3-2 | **Deferred** | Owner disposition: the limitation does not block Phase 0 completion. Verification tooling unchanged. |

### Run 4 — 2026-10-04 (fresh verification at C7)

- **Reviewer:** main Claude Code session (implementer; not independent)
- **Baseline:**
  - C7 `b71fd858cf0530f9aae31770cd58171017d70426` (C6 `b80a40af…`, C5 `24d1c635…`, C4 `8b833081…`, C3 `5d89f3cf…`, C2 `b40505dc…`, C1 `a6d58ce0…`)
  - clean working tree; `working_tree_content_hash` `7e31b10f1712bbfe96eb73874755bc929c1b2405385c7f19de3ddac943f72398`
  - `commit_count` 7; no remotes
- **Inputs:**
  - the repository at C7;
  - the deterministic suite at 2026-10-04T02:09:08Z (`verification-record.md` Run 4);
  - acceptance/version and evidence checks (`verification-record.md` R4.2);
  - the contradiction sweep (`contradiction-review.md` Run 4);
  - the pinned gitleaks-action README (`gitleaks/gitleaks-action@e0c47f4f8be36e29cdc102c57e68cb5cbf0e8d1e`), fetched read-only.
- **Timestamp (UTC):** 2026-10-04T02:10Z

#### 3.14 Status of earlier findings

Run 3 rows and the §3.13 dispositions are historical and unchanged. This table records their status at C7.

| ID | Run 4 status | Evidence |
| -- | ------------ | -------- |
| L1-SE-1 (Medium) | Open | `scripts/` unchanged since C1 |
| L1-SE-2 (Low) | Open | `scripts/` unchanged since C1 |
| L1-SE-3 (Low) | Open (known) | `.claude/` unchanged since C1 |
| L1-AR-1 (Low) | Open | `CLAUDE.md` unchanged since C1 |
| L1-AR-2 (Low) | Open | `scripts/verify-phase.sh` unchanged since C1 |
| L1-SEC-1 (Medium) | Open | `VER-P0-CI-EXEC`, `VER-P0-REPO-PROTECTION` BLOCKED |
| L1-SEC-2 (Medium) | **Closed** for the current Phase 0 scope (owner disposition, §3.13) | The workflow contains no `GITLEAKS_LICENSE` reference. At the pinned README, both quotations used in this record appear verbatim: "required for organizations, not required for user accounts" (§3.10) and "Only required for Organizations, not personal accounts" (§3.13). See L1-R4-1. |
| L1-SEC-3 (Low) | Open | `.claude/settings.json` unchanged since C1 |
| L1-AI-1 (Low) | Open (DEP-001) | decision register unchanged |
| L1-AI-2 (Low) | Open | `docs/ai/` absent |
| L1-R2-2 (Medium) | Open | Repository-protection check still requires `gh`; not installed |
| L1-R2-4 (Low) | Open (deferred by owner to the completion record) | Phase 0 document unchanged since C3 |
| L1-R2-5 (Low) | Open (owner: no change now) | line-ending state |
| L1-R2-6 (Info) | Applies | ACC-009 was required by this rule |
| L1-R3-1 (Medium) | Open — **deferred** by owner (§3.13) | Tooling unchanged; compensating manual version check performed (`verification-record.md` R4.2) |
| L1-R3-2 (Low) | Open — **deferred** by owner (§3.13) | Tooling unchanged |
| L1-R3-3 (Low) | **Resolved** | C5 adds the whitespace-only-reformatting rule to register §2; ACC-009 accepts the register at C5 |
| L1-R3-4 (Low) | **Resolved** | C7 commits the Run 2 and Run 3 evidence records |
| L1-R3-5 (Info) | Applies | `scripts/verify-phase.sh` unchanged |
| L1-R3-6 (Info) | Applies | `.github/workflows/security.yml` unchanged since C3 |
| L1-R3-7 (Low) | Open | Phase 0 document unchanged since C3 |

#### 3.15 New findings

| ID | Severity | Finding | Evidence | Recommendation | Required before completion |
| -- | -------- | ------- | -------- | -------------- | -------------------------- |
| L1-R4-1 | Info | The L1-SEC-2 closure rests on the owner's statement that the repository is personally owned through the owner's personal GitHub account. With no remote configured, ownership cannot be verified locally. | `git remote -v` empty | Confirm the repository owner type when the remote is created. | Yes, at the remote stage |
| L1-R4-2 | Low | `verification-record.md` Run 3 (R3.5, R3.7) still shows L1-SEC-2 as open and L1-R3-3 and L1-R3-4 as pending. The later owner dispositions are recorded only in `engineering-review.md` §3.13, and `verification-record.md` Run 3 has no cross-reference to them. As a historical record of Run 3 it is accurate. | `verification-record.md` R3.5; `engineering-review.md` §3.13 | None to Run 3 (historical records are not rewritten). Run 4 (R4.5) records the current state. | No |
| L1-R4-3 | Info | Run 4 was performed with the repository read-only, so its evidence was not written during the run. It was recorded afterwards under a separate owner authorization. | `verification-record.md` Run 4 recording note and R4.8 | None. | No |

#### 3.16 Summary

- High: 0.
- Medium open: 4 (L1-SE-1, L1-SEC-1, L1-R2-2, L1-R3-1); L1-R3-1 is deferred.
- Low open: 12 (L1-SE-2, L1-SE-3, L1-AR-1, L1-AR-2, L1-SEC-3, L1-AI-1, L1-AI-2, L1-R2-4, L1-R2-5, L1-R3-2, L1-R3-7, L1-R4-2); L1-R3-2 is deferred.
- Info: 5 (L1-R2-6, L1-R3-5, L1-R3-6, L1-R4-1, L1-R4-3).
- Resolved since Run 3: L1-R3-3, L1-R3-4. Closed by owner disposition: L1-SEC-2.
- No finding requires a consequential architectural decision. No governance contradiction remains.
