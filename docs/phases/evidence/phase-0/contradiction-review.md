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
