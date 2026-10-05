# Sentinel AI — Phase 0 Contradiction Review

**File:** `docs/phases/evidence/phase-0/contradiction-review.md`  
**Phase:** P0 (Task 0.24)  
**Record status:** Recorded

This record holds the Phase 0 documentation and architecture contradiction review. It never states or implies the Phase 0 lifecycle status.

## 1. Scope

Compare the canonical specification, product documents, architecture documents, ADR governance, phase governance, security documents, and Claude Code governance for:

- contradictory authority;
- duplicated normative requirements;
- ambiguous terms;
- incompatible status definitions;
- conflicting dependency semantics;
- hidden architecture decisions;
- incorrect Claude Code responsibilities.

## 2. Required Fields per Finding

- finding ID;
- severity;
- file;
- exact issue;
- authority involved;
- evidence (file and line);
- classification: confirmed / false positive / duplicate / unresolved / requires decision;
- remediation and whether it is already authorized.

## 3. Runs

### Run 1 — 2026-10-03

**Section status:** Superseded by Run 2 (re-verification at C2).

- **Reviewer:** main Claude Code session (not independent)
- **Baseline:** S1″ (`working_tree_content_hash` `9a8f9830ef6c94bcbe3ccb78869353cc44cc75c449fbf0b2bb9b95d564d78bc2`)
- **Method:** `[REAL REPO]` read-only `grep` sweep plus the deterministic checks of verification run 1 (`VER-P0-STATUS-*`, `VER-P0-VERSIONREF-001`, `VER-P0-LIFECYCLE-001`, `VER-P0-TEMPLATE-001`)

| Check | Command / method | Observed |
| ----- | ---------------- | -------- |
| Undefined status strings (`Accepted baseline`, `Accepted Phase 0 baseline`, `Verification artifact`, `Historical — Superseded`) | `grep -rnE` over `docs`, `CLAUDE.md`, `README.md`, `.claude` | none |
| Old ADR path `docs/decisions/ADR-` | `grep -rn` over docs, CLAUDE.md, README.md, `.claude`, `scripts` | none |
| References to removed artifacts (`verify-on-stop`, `docs/security/phase-0-verification`) | `grep -rnE` | none |
| Hard-coded canonical version outside versioned documents | `grep -rnE 'canonical-specification-v[0-9]+\.[0-9]+'` excluding the canonical directory and acceptance register | only the Phase 0 document Task 0.7 (lines 332–333), which specifically concerns v0.3 and the historical records — permitted |
| Frontend/LLM boundary narrowing (`internal LLM infrastructure`) | `grep -rn` | none |
| Duplicated secret-incident procedure | `grep` for numbered revoke steps | only `docs/security/secret-incident-response.md` |
| Status models by category | `VER-P0-STATUS-DOC-001`, `-ADR-001`, `-PHASE-001`, `-RECORD-001` | PASS / NOT APPLICABLE / PASS / PASS |
| Phase lifecycle and dependency semantics | `VER-P0-LIFECYCLE-001`; `docs/phases/README.md` §11a, §12 | PASS; consistent with canonical §26–§27 |

| ID      | Severity | Issue | Authority | Evidence | Classification | Remediation |
| ------- | -------- | ----- | --------- | -------- | -------------- | ----------- |
| CR-1    | Low      | Next.js summary in `CLAUDE.md` omits "internal domain persistence" (Rule is complete) | canonical §6 | `CLAUDE.md:68` | confirmed (non-blocking duplicate summary) | Wording alignment; not authorized in this stage |
| CR-2    | Low      | Phase-transition BLOCKED set defined in a script constant rather than a governance document | `docs/phases/README.md`; Phase 0 Exit Criteria | `scripts/verify-phase.sh:51` | confirmed (as designed by the approved plan) | Future governance revision; not authorized in this stage |
| CR-3    | Info     | Roadmap and lifecycle duplicated in the canonical specification | documentation-authority §4 | `docs/decisions/decision-register.md` DGI-001 | duplicate (already recorded) | Deferred by owner decision |

No high-severity contradiction was found.

### Run 2 — 2026-10-03 (re-verification at C2)

**Section status:** Superseded by Run 3 (re-verification at C4).

- **Reviewer:** main Claude Code session (not independent)
- **Baseline:** C2 `b40505dc0402c17b5acc5cf5033ef0ee0c8d9421`, clean working tree (`working_tree_content_hash` `26d12208e1ef83c070432c296b27cbb9af75cf87f52a23c5d8710363276c5e36`)
- **Method:** `[REAL REPO]` read-only `grep` sweep plus deterministic checks of verification Run 2

| Check | Observed |
| ----- | -------- |
| Undefined status strings | none outside this record's own Run 1 method text (self-reference) |
| Old ADR path `docs/decisions/ADR-` | none outside this record's own Run 1 method text (self-reference) |
| Hard-coded canonical version outside versioned documents and the register | only Phase 0 document Task 0.7 (lines 332–333), which concerns v0.3 specifically — permitted |
| Duplicated secret-incident procedure | only `docs/security/secret-incident-response.md` |
| Documents claiming `Accepted` | v0.3 plus the five governed documents; each backed by an acceptance-register entry (`VER-P0-STATUS-DOC-001` and `VER-P0-ACCEPT-001` PASS) |
| Status models, lifecycle, template, version references | `VER-P0-STATUS-*`, `-LIFECYCLE-001`, `-TEMPLATE-001`, `-VERSIONREF-001`: PASS / NOT APPLICABLE (ADR) |

| ID   | Severity | Issue | Authority | Evidence | Classification | Remediation |
| ---- | -------- | ----- | --------- | -------- | -------------- | ----------- |
| CR-1 | Low  | Next.js summary in `CLAUDE.md` omits "internal domain persistence" | canonical §6 | `CLAUDE.md:68` | confirmed, unchanged from Run 1 | Not authorized in this stage |
| CR-2 | Low  | Phase-transition BLOCKED set defined in a script constant | Phase 0 Exit Criteria | `scripts/verify-phase.sh:51` | confirmed, unchanged | Not authorized in this stage |
| CR-3 | Info | Roadmap and lifecycle duplicated in the canonical specification | documentation-authority §4 | decision register DGI-001 | duplicate (recorded) | Deferred by owner decision |
| CR-4 | High (completion) | CI detection criterion contradicts the never-commit rule for synthetic credentials and the local hook | Phase 0 Task 0.20 / P0-AC-021; secret-incident-response §3 | Phase 0 document line 1113; `docs/security/secret-incident-response.md:34` | requires decision | Owner decision (see `engineering-review.md` L1-R2-1) |
| CR-5 | Medium | Repository-protection check depends on the `gh` CLI, which is unavailable | Phase 0 Task 0.17/0.20 | `scripts/verify-phase.sh:642` | requires decision | Owner decision (L1-R2-2) |

No contradiction among the governing documents was introduced by C2.

### Run 3 — 2026-10-04 (re-verification at C4)

**Section status:** Superseded by Run 4 (fresh verification at C7).

- **Reviewer:** main Claude Code session (not independent)
- **Baseline:** C4 `8b833081f257eb82af26fd0991697f1e518f6287` plus the uncommitted Run 2 evidence records (`working_tree_content_hash` `fee107c5232037cf97f331b31d20d0de3d82761422b8da16a6ad6c17be1924b8`)
- **Method:** `[REAL REPO]` read-only `grep` sweep (excluding the evidence records' own method text), deterministic checks of verification Run 3, and acceptance/version checks

| Check | Observed |
| ----- | -------- |
| Undefined status strings | none |
| Old ADR path `docs/decisions/ADR-` | none |
| Hard-coded canonical version outside versioned documents and the register | only Phase 0 document Task 0.7 (lines 332–333) — permitted |
| Duplicated secret-incident procedure | only `docs/security/secret-incident-response.md` |
| Documents claiming `Accepted` | v0.3 plus the five governed documents; each backed by a register entry whose version relationship holds (Run 3 acceptance checks) |
| CI criterion vs never-commit rule | P0-AC-021 and Task 0.20 Tests now require a runtime fixture outside the checkout; no requirement to commit a secret |
| Exit criteria vs P0-AC-025 | consistent: both admit a permitted BLOCKED Layer 2 reviewer |

| ID   | Severity | Issue | Classification | Remediation |
| ---- | -------- | ----- | -------------- | ----------- |
| CR-1 | Low | `CLAUDE.md:68` Next.js summary omits "internal domain persistence" | confirmed, unchanged | Not authorized in this stage |
| CR-2 | Low | Phase-transition BLOCKED set defined in a script constant | confirmed, unchanged | Not authorized in this stage |
| CR-3 | Info | Roadmap and lifecycle duplicated in the canonical specification (DGI-001) | duplicate (recorded) | Deferred by owner decision |
| CR-4 | — | CI detection criterion vs never-commit rule | **resolved** in C3 (accepted by ACC-008) | — |
| CR-5 | Medium | Repository-protection check depends on the unavailable `gh` CLI | confirmed, unchanged; requires decision | Owner decision (L1-R2-2) |
| CR-6 | Low | "Substantive content change" undefined for whitespace-only reformatting | ambiguity; requires decision | Owner decision (L1-R3-3) |
| CR-7 | Low | Tasks say content is assessed by both review layers although Layer 2 is permissibly BLOCKED | wording overstatement | Future governed revision (L1-R3-7) |

No governance contradiction remains among the governing documents at C4.

### Run 4 — 2026-10-04 (fresh verification at C7)

**Section status:** Superseded by Run 6 (verification at C9).

- **Reviewer:** main Claude Code session (not independent)
- **Baseline:** C7 `b71fd858cf0530f9aae31770cd58171017d70426`, clean working tree (`working_tree_content_hash` `7e31b10f1712bbfe96eb73874755bc929c1b2405385c7f19de3ddac943f72398`)
- **Method:**
  - `[REAL REPO]` read-only `git grep` sweeps, excluding the evidence records, for:
    - acceptance-entry references outside the register;
    - competing definitions of substantive, whitespace-only or reformatting changes;
    - licence and organization-ownership statements;
  - deterministic checks of verification Run 4;
  - acceptance/version checks (`verification-record.md` R4.2).

| Check | Observed |
| ----- | -------- |
| `ACC-0nn` references outside the register and evidence records | none |
| Rules defining substantive, whitespace-only or reformatting changes outside the register | none; `documentation-authority.md` §23 delegates the rule to register §2 |
| Licence or organization-ownership statements outside the evidence records | none |
| Documents claiming `Accepted` | v0.3 plus the five governed documents. Each is backed by a register entry whose version relationship holds (Run 4 acceptance checks); the register itself is now covered by ACC-009 @ C5. |
| Generic version references and status models | `VER-P0-VERSIONREF-001`, `VER-P0-STATUS-DOC-001`, `VER-P0-STATUS-PHASE-001`, `VER-P0-STATUS-RECORD-001` PASS (Run 4) |

| ID   | Severity | Issue | Classification | Remediation |
| ---- | -------- | ----- | -------------- | ----------- |
| CR-1 | Low | `CLAUDE.md:68` Next.js summary omits "internal domain persistence" | confirmed, unchanged | Not authorized in this stage |
| CR-2 | Low | Phase-transition BLOCKED set defined in a script constant | confirmed, unchanged | Not authorized in this stage |
| CR-3 | Info | Roadmap and lifecycle duplicated in the canonical specification (DGI-001) | duplicate (recorded) | Deferred by owner decision |
| CR-4 | — | CI detection criterion vs never-commit rule | resolved in C3 (accepted by ACC-008) | — |
| CR-5 | Medium | Repository-protection check depends on the unavailable `gh` CLI | confirmed, unchanged | Owner decision (L1-R2-2) |
| CR-6 | — | "Substantive content change" undefined for whitespace-only reformatting | **resolved** in C5 (accepted by ACC-009) | — |
| CR-7 | Low | Tasks say content is assessed by both review layers although Layer 2 is permissibly BLOCKED | wording overstatement, unchanged | Future governed revision (L1-R3-7) |

No governance contradiction remains among the governing documents at C7.

### Run 6 — 2026-10-04 (verification at C9)

**Section status:** Superseded by Run 13 (final verification at C14).

- **Reviewer:** main Claude Code session (not independent)
- **Baseline:** C9 `1b90511756e66620c00c87e14943324529d2922f`, clean working tree (`working_tree_content_hash` `e56e7da2db09c1e179a695b3a4e555e12a7347bded1d79ba7635ffe15efe02e6`)
- **Method:**
  - deterministic checks of verification Run 6;
  - acceptance/version and commit-scope checks (`verification-record.md` R6.2);
  - a consistency check of the C9 workflow change against `docs/architecture/security-architecture.md` §6 and P0-AC-020 to P0-AC-022.
- No new `git grep` sweep was run. The governing documents are unchanged since the Run 4 sweep, because C8 changed only evidence records and C9 only `.github/workflows/security.yml`.

| Check | Observed |
| ----- | -------- |
| Governing documents changed since Run 4 | none (C8: evidence records only; C9: `.github/workflows/security.yml` only) |
| Documents claiming `Accepted` | v0.3 plus the five governed documents; each is backed by a register entry whose version relationship holds (Run 6 acceptance checks) |
| `security-architecture.md` §6 layer 3 control ("`.github/workflows/security.yml` (Gitleaks action)") vs C9 | consistent: the pinned Gitleaks action remains; C9 adds a fail-closed full-history scan step to the same job |
| P0-AC-020 (pinned SHAs, permissions, triggers, fetch depth, Gitleaks version) vs C9 | consistent: `VER-P0-CI-CONFIG` PASS (Run 6) |
| P0-AC-022 (protection requires the CI security check) vs C9 | consistent: the job name `Secret scanning` is unchanged |
| Generic version references and status models | `VER-P0-VERSIONREF-001`, `VER-P0-STATUS-DOC-001`, `VER-P0-STATUS-PHASE-001`, `VER-P0-STATUS-RECORD-001` PASS (Run 6) |

| ID   | Severity | Issue | Classification | Remediation |
| ---- | -------- | ----- | -------------- | ----------- |
| CR-1 | Low | `CLAUDE.md:68` Next.js summary omits "internal domain persistence" | confirmed, unchanged | Not authorized in this stage |
| CR-2 | Low | Phase-transition BLOCKED set defined in a script constant | confirmed, unchanged | Not authorized in this stage |
| CR-3 | Info | Roadmap and lifecycle duplicated in the canonical specification (DGI-001) | duplicate (recorded) | Deferred by owner decision |
| CR-4 | — | CI detection criterion vs never-commit rule | resolved in C3 (accepted by ACC-008) | — |
| CR-5 | Medium | Repository-protection check depends on the unavailable `gh` CLI | confirmed, unchanged | Owner decision (L1-R2-2) |
| CR-6 | — | "Substantive content change" undefined for whitespace-only reformatting | resolved in C5 (accepted by ACC-009) | — |
| CR-7 | Low | Tasks say content is assessed by both review layers although Layer 2 is permissibly BLOCKED | wording overstatement, unchanged | Future governed revision (L1-R3-7) |

No governance contradiction remains among the governing documents at C9.

### Run 13 — 2026-10-04 (final verification at C14)

- **Reviewer:** main Claude Code session (not independent)
- **Baseline:** C14 `d2570ad8f14b0863b3643fca36c8f107a2bdb406`, plus the uncommitted evidence notes R6.9, R6.10 and §3.20 (`working_tree_content_hash` `db235af7c8504e1330da607e251a16074023778892365827e1f85b41149a3616`)
- **Method:** a fresh `[REAL REPO]` read-only sweep at 2026-10-04T17:18:22Z, covering every governing file changed since C9. The files changed since C9 are:
  - `acceptance-register.md`;
  - `documentation-authority.md`;
  - `security-architecture.md`;
  - the Phase 0 document;
  - the four evidence records.

| Sweep | Command (abridged) | Result |
| ----- | ------------------ | ------ |
| S1 status values | `git grep -hE '^\*\*Status:\*\*' -- docs CLAUDE.md ':!docs/phases/evidence'` | 7 `Accepted` (six documents plus v0.3's internal line), 2 `Historical`, 16 `Proposed`; no undefined values |
| S2 old ADR path | `git grep -n 'docs/decisions/ADR-'` | 0 |
| S3 version references | ``git grep -nE 'canonical-specification-v[0-9]\|\bv0\.[0-9]\b'`` outside `canonical-specification/`, the register and the evidence records | Only version-specific references remain: decision register DGI-001 (lines 73, 75); Phase 0 Task 0.7 inputs (lines 327, 332, 333); the historical v0.1/v0.2 note (line 1190). `documentation-authority.md` has 0 prose version identifiers. |
| S4 incident procedure | headings matching incident/secret-exposure response | only `docs/security/secret-incident-response.md` |
| S5 Accepted claims | `**Status:** Accepted` vs register | six documents, each backed by ACC entries whose version relationship holds (`verification-record.md` R13.2) |
| S6 stale remote statements | `git grep -niE 'no remote\|not configured\|has no remote'` outside the evidence records | Phase 0 document line 1195 only (L1-R13-1); the security-architecture §6 Layer 4 line now reads "configured on main …" |
| S7 phase-status statements in evidence | R6.10 patterns A and B | The twelve corrected statements (R6.9, R6.10), the excluded Run 1 §3.7 and eligibility lines, and self-references inside the correction notes (`verification-record.md` lines 787 and 803 in R6.10; `engineering-review.md` line 311 in §3.20). No other hits. |
| S9 phase document | `## Status` value vs latest Status History row | consistent (`VER-P0-LIFECYCLE-001` PASS) |

| ID | Severity | Issue | Classification | Remediation |
| -- | -------- | ----- | -------------- | ----------- |
| CR-1 | Low | `CLAUDE.md:68` Next.js summary omits "internal domain persistence" | confirmed, unchanged | Not authorized in this stage |
| CR-2 | Low | Phase-transition BLOCKED set defined in a script constant | confirmed, unchanged | Not authorized in this stage |
| CR-3 | Info | Roadmap and lifecycle duplicated in the canonical specification (DGI-001) | duplicate (recorded) | Deferred by owner decision |
| CR-4 | — | CI detection criterion vs never-commit rule | resolved in C3 (ACC-008) | — |
| CR-5 | — | Repository-protection check depends on the `gh` CLI | **resolved**: `gh` available and authenticated; check PASS (`verification-record.md` R13.4) | — |
| CR-6 | — | "Substantive content change" undefined for whitespace-only reformatting | resolved in C5 (ACC-009) | — |
| CR-7 | Low | Tasks say content is assessed by both review layers | wording overstatement, unchanged | Future governed revision (L1-R3-7) |
| CR-8 | Low | Phase 0 Known Limitations (line 1195) states no remote, contradicting the recorded CI and protection evidence | stale statement in an accepted document | Owner: leave unchanged; Final Verification records resolution (L1-R13-1) |
| CR-9 | — | Evidence records stated the phase lifecycle status, contrary to P0-AC-005 | **resolved by recorded correction**: `verification-record.md` R6.9 and R6.10; `engineering-review.md` §3.20 | — |

No unresolved governance contradiction remains among the governing documents at C14. CR-8 is disposed of by owner determination.

### Run 15 — 2026-10-05 (verification at C14)

**Section status:** Recorded.

**Earlier sections (R15-L2-DOC-1).** The Run 13 section of this record is superseded by this Run 15 section as the current contradiction review. Its content is preserved as recorded.

- **Reviewer:** main Claude Code session (not independent).
- **Baseline:** R15-S1 (2026-10-05T11:26:41Z): C14 `d2570ad8f14b0863b3643fca36c8f107a2bdb406` plus the uncommitted evidence through `verification-record.md` R14.12 and the Phase 0 document's lifecycle record; `working_tree_content_hash` `4b67ddd020aac77690066e0e8d9f5f441a346019b5c534ad7da80869bb1da708`.
- **Method:** a fresh `[REAL REPO]` read-only sweep at 2026-10-05T11:29:11Z, using `grep -r` over the working tree. Unlike the Run 13 sweep, which used `git grep` outside the evidence records, S2 here also searched the evidence records. Each hit was classified by reading the line.

| Sweep | Command (abridged) | Result |
| ----- | ------------------ | ------ |
| S1 status values | `grep -rhE '^\*\*Status:\*\*' docs CLAUDE.md --exclude-dir=evidence` | 7 `Accepted`, 2 `Historical`, 16 `Proposed`; no undefined values. The Phase 0 document's `## Status` value is a phase-model value and matches its latest Status History row (`VER-P0-LIFECYCLE-001` PASS) |
| S2 old ADR path | `grep -rn 'docs/decisions/ADR-'` over the repository | 4 hits, all in this record's own method text (lines 45, 72, 99, 199); 0 elsewhere |
| S3 version references | `grep -rnE 'canonical-specification-v[0-9]\|\bv0\.[0-9]\b'` outside `canonical-specification/`, the register and the evidence records | Only the version-specific references: decision register DGI-001 (lines 73, 75); Phase 0 Task 0.7 inputs (lines 327, 332, 333); the historical v0.1/v0.2 note (line 1190) |
| S4 incident procedure | headings matching incident/secret-exposure response | only `docs/security/secret-incident-response.md` |
| S5 Accepted claims | files with `**Status:** Accepted` | six documents, each backed by an ACC entry whose version relationship holds (`verification-record.md` R15.2) |
| S6 stale remote statements | `grep -rniE 'no remote\|not configured\|has no remote'` outside the evidence records | Phase 0 document line 1195 only (CR-8, L1-R13-1) |
| S7 phase-status statements in evidence | R6.10 patterns A and B over the four evidence records | Every hit classified: the twelve corrected statements (R6.9, R6.10, §3.20); Run 1 §3.7 (excluded by owner determination); transition-eligibility and transition descriptions (for example `verification-record.md` 273, 386, 524, 711, 927); governing-basis quotations and cross-references in R14.9 and R14.12 (1118–1161); quotations inside correction notes (`engineering-review.md` 313, 407); and verbatim reviewer text in `independent-review.md`, classified under `verification-record.md` R13.10 item 2. One stale present-tense statement about the Status History (`verification-record.md` line 1120) is corrected by R15.10 (R15-L2-DOC-2). No other hits |
| S8 lifecycle transitions | Phase 0 Status History vs `docs/phases/README.md` §11a (lines 266–268) | every row is a permitted transition |
| S9 lifecycle placeholders | `To be completed` in the Phase 0 document | Final Verification (line 1239) and Completion Decision (line 1243) placeholders, expected before completion |

| ID | Severity | File | Issue | Authority | Evidence | Classification | Remediation |
| -- | -------- | ---- | ----- | --------- | -------- | -------------- | ----------- |
| CR-1 | Low | `CLAUDE.md` | Next.js summary omits "internal domain persistence" | canonical v0.3 §6 | `CLAUDE.md:68` | confirmed, unchanged | Not authorized in this stage |
| CR-2 | Low | `scripts/verify-phase.sh` | Phase-transition BLOCKED set defined in a script constant | Phase 0 document, Exit Criteria | Phase 0 document line 1129 | confirmed, unchanged | Not authorized in this stage |
| CR-3 | Info | canonical specification | Roadmap and lifecycle duplicated (DGI-001) | decision register DGI-001 | `decision-register.md:73-75` | duplicate (recorded) | Deferred by owner decision |
| CR-4 | — | — | CI detection criterion vs never-commit rule | — | — | resolved in C3 (ACC-008) | — |
| CR-5 | — | — | Repository-protection check depends on `gh` | — | `verification-record.md` R13.4, R15.3 | resolved | — |
| CR-6 | — | — | "Substantive content change" undefined for whitespace-only reformatting | — | — | resolved in C5 (ACC-009) | — |
| CR-7 | Low | Phase 0 document | Tasks say content is assessed by both review layers | Phase 0 document | task wording (L1-R3-7) | wording overstatement, unchanged | Future governed revision |
| CR-8 | Low | Phase 0 document | Known Limitations (line 1195) states no remote, contradicting recorded CI and protection evidence | Phase 0 document; `verification-record.md` R6.3, R15.3 | Phase 0 document line 1195 | stale statement in an accepted document | Owner: leave unchanged; the Final Verification records resolution (L1-R13-1) |
| CR-9 | — | evidence records | Evidence records stated the phase lifecycle status (P0-AC-005) | P0-AC-005 | `verification-record.md` R6.9, R6.10; `engineering-review.md` §3.20; R13.10 item 2 | resolved by recorded correction and classification; S7 re-run above finds no other statement | — |

No unresolved governance contradiction remains among the governing documents in the Run 15 baseline. CR-8 is disposed of by owner determination.
