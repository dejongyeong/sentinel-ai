# Sentinel AI — Decision Register

**File:** `docs/decisions/decision-register.md`  
**Status:** Proposed  
**Owner:** Engineering  
**Authority:** Record of phase-level tooling selections, deferred decisions, architectural dependencies, and deferred governance improvements that are not ADRs (see `docs/decisions/README.md`)

## 1. Purpose

This register records:

- phase-level selections that the canonical specification assigns to a phase but that are not consequential architectural decisions requiring an ADR;
- deferred architectural decisions and the phase in which each is expected to be decided;
- open architectural dependencies that requirements or later phases depend on;
- known governance limitations deferred to a later intentional revision.

It does not record human acceptance; acceptance is recorded only in `docs/architecture/acceptance-register.md`.

A consequential architectural decision is recorded by an ADR, not here.

## 2. Phase 0 Selections

### DR-P0-001 — Initial Gitleaks version

| Field            | Value                                                                                                                                                         |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Status           | Proposed                                                                                                                                                      |
| Authority        | Canonical specification (current Accepted version) §31: "Phase 0 additionally selects: initial Gitleaks version"                                              |
| Candidate        | Gitleaks `8.30.1` (`.pre-commit-config.yaml` rev `v8.30.1`; CI `GITLEAKS_VERSION: "8.30.1"`)                                                                  |
| Rationale        | Supported release with the default ruleset including `github-pat`; same version in pre-commit and CI keeps local and CI detection behaviour aligned.            |
| Selection basis  | The candidate is acceptable only if the positive control `VER-P0-GITLEAKS-POS` passes. Being the latest release is not a selection criterion.                 |
| Evidence         | Pending — `docs/phases/evidence/phase-0/verification-record.md` (`VER-P0-GITLEAKS-NEG`, `VER-P0-GITLEAKS-POS`). No result has been recorded.                    |
| If the control fails | The candidate is not selected. No rule, allowlist, or configuration change is made to force detection. Another supported version is evaluated only with owner authorization. |
| Completion gate  | No. Recorded and technically verified; not a Phase 0 acceptance gate.                                                                                         |

### DR-P0-002 — Initial pre-commit hook set

| Field           | Value                                                                                                                                         |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Status          | Proposed                                                                                                                                      |
| Authority       | Canonical specification (current Accepted version) §31: "Phase 0 additionally selects: initial pre-commit hook set"                          |
| Candidate       | One hook: `gitleaks` from `https://github.com/gitleaks/gitleaks` at rev `v8.30.1`                                                             |
| Rationale       | Phase 0 contains no application code; secret detection is the only commit-boundary control Phase 0 requires. Formatter, linter, and type-check hooks belong to Phase 1, which owns the toolchain decision. |
| Evidence        | Pending — `VER-P0-PRECOMMIT-NEG`, `VER-P0-PRECOMMIT-POS` in the Phase 0 verification record. No result has been recorded.                      |
| Completion gate | No. Recorded and technically verified; not a Phase 0 acceptance gate.                                                                         |

## 3. Deferred Architectural Decisions

Source: canonical specification (current Accepted version) §31. The specification is authoritative for this list. No authority currently designates the phase for each decision; the candidate phase column is a non-binding planning reference only.

| ID          | Decision                    | Candidate roadmap phase (non-binding) / mechanism | Status          |
| ----------- | --------------------------- | ------------------------------------------ | --------------- |
| DEF-001     | Queue technology            | P6 Background Processing — ADR             | Not yet decided |
| DEF-002     | Authentication mechanism    | P4 Identity, Authentication & Authorization — ADR | Not yet decided |
| DEF-003     | Object storage              | P12 Findings & Evidence — ADR              | Not yet decided |
| DEF-004     | Evidence retention          | P12 Findings & Evidence — ADR              | Not yet decided |
| DEF-005     | Browser isolation           | P10 Accessibility Engine — ADR             | Not yet decided |
| DEF-006     | LLM providers               | P8 AI Platform Foundation — ADR            | Not yet decided |
| DEF-007     | Embedding provider/model    | P9 RAG & Retrieval — ADR                   | Not yet decided |
| DEF-008     | Notification provider       | P15 Continuous Monitoring & Compliance — ADR | Not yet decided |
| DEF-009     | Data Quality connectors     | P16 Data Quality Sentinel — ADR            | Not yet decided |
| DEF-010     | Incident signal sources     | P17 Incident Sentinel — ADR                | Not yet decided |
| DEF-011     | Cloud provider              | P21 Cloud Deployment — ADR                 | Not yet decided |

The candidate phase is the roadmap phase whose scope appears to first require the decision. It is not a designation and not a decision; the designated phase is confirmed when the relevant phase document is created. Deferred means no accepted decision exists; it does not permit a phase or Claude Code to choose one silently.

## 4. Deferred Governance Improvements

### DGI-001 — Roadmap and phase lifecycle duplicated in the canonical specification

| Field      | Value                                                                                                                                                                         |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Issue      | The canonical specification (v0.3 §26–§28, §32) restates the phase lifecycle and the P0–P24 roadmap, which are owned by `docs/phases/README.md` and `docs/product/roadmap.md`. |
| Current risk | Low while the texts agree; drift risk if either changes.                                                                                                                    |
| Decision   | Do not modify v0.3 for this cleanup. Do not create a new canonical version solely for it.                                                                                     |
| Deferred to | The next intentional canonical specification revision, which should make `docs/product/roadmap.md` authoritative for the roadmap and reference it rather than duplicate it.  |

## 5. Architectural Dependencies

An architectural dependency is an architectural definition that a requirement or later phase depends on but that has not yet been made. It is not a decision and does not define the dependent concept.

### DEP-001 — Consequential-change classification

| Field        | Value                                                                                                                                                                                                                                                                                       |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Dependents   | REQ-PLATFORM-007 and AC-PLATFORM-004 (`docs/product/`) depend on a classification of which AI-generated changes are consequential.                                                                                                                                                          |
| Requirement  | The consequential-change classification must be defined in `docs/architecture/ai-architecture.md`, or, if establishing the classification itself constitutes a consequential architectural decision under ADR governance, through an Accepted ADR referenced by the AI architecture. This must happen before the first phase that implements consequential AI-generated remediation begins implementation. |
| Status       | Open. The classification is not defined here, and no phase is designated.                                                                                                                                                                                                                   |
