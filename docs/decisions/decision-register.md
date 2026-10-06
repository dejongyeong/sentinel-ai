# Sentinel AI — Decision Register

**File:** `docs/decisions/decision-register.md`  
**Status:** Proposed  
**Owner:** Engineering  
**Authority:** Record of phase-level tooling selections, phase-level owner decisions and deferrals, deferred architectural decisions, architectural dependencies, and deferred governance improvements that are not ADRs. Designated by `docs/architecture/documentation-authority.md` §4 ("Non-ADR decision and deferral record") and `docs/decisions/README.md` §3a.

## 1. Purpose

This register records phase-level tooling selections and owner decisions and deferrals that are within the authority of the accepted product, architecture and governance model, together with deferred architectural decisions, open architectural dependencies, and deferred governance improvements.

Its authority as the record for these subjects comes from the accepted governance and documentation model: `docs/architecture/documentation-authority.md` §4 and `docs/decisions/README.md` §3a. It is a recording mechanism. It records decisions made by the Project Owner; it does not create them, and it does not create, override or supersede architectural decisions, accepted requirements, or the current Accepted canonical specification. It does not replace ADRs.

A consequential architectural decision is recorded only by an ADR, not here.

It does not record human acceptance; acceptance of documents is recorded only in `docs/architecture/acceptance-register.md`.

Individual entries carry no independent architectural authority. Where an entry records an owner-confirmed enforcement disposition (for example a Phase 1 import rule), the entry cites the accepted source authority from which the rule derives.

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

## 6. Phase 1 Owner Decisions and Deferrals

Owner decisions and deferrals for Phase 1 (Repository & Engineering Foundation). They are recorded under §1. The IDs correspond to the Phase 1 planning identifiers OD-01 to OD-11. Each entry records a decision or deferral made by the Project Owner and cites the accepted authority it operates within; it creates no architectural authority. Phase 1 tooling selections are recorded separately when made.

| ID | Subject | Decision | Decided by | Decision date | Outcome | Authority basis | Phase | Affects |
| -- | ------- | -------- | ---------- | ------------- | ------- | --------------- | ----- | ------- |
| P1-OD-01 | Recording mechanism for Phase 1 selections and owner decisions | Decided | Project Owner | 2026-10-05 | This register records Phase 1 tooling selections and owner decisions and deferrals. The mechanism became governed through `docs/decisions/README.md` §3a (ACC-011) and §1 of this register (commit `3a7a193e896b929a154480ec0b7f5605a6d4c306`) | `docs/architecture/documentation-authority.md` §4; `docs/decisions/README.md` §3a; canonical specification §30 | P1 | All Phase 1 selections and decision records |
| P1-OD-02 | Dependency edges Domains → Platform, API → Platform, API → Domains | Deferred | Project Owner | 2026-10-05 | Not decided and not enforced in Phase 1. Resolution gate: before the first phase whose implementation depends on these edges. When decided, the ADR requirement in `docs/decisions/README.md` §2 applies (ADR-0003 reserved) | Canonical specification §4, §7–§9 (edges not settled) | P1 | Phase 1 import-rule enforcement set |
| P1-OD-03 | Location of shared TypeScript packages and any generated client | Deferred | Project Owner | 2026-10-05 | No shared TypeScript package in Phase 1; TypeScript configuration stays local to `apps/web`. Resolution gate: when a shared package or client location is first needed | `docs/architecture/system-architecture.md` §2 (topology owner) | P1 | Phase 1 repository structure |
| P1-OD-04 | Timing of TypeScript API-client derivation | Decided | Project Owner | 2026-10-05 | Client derivation is implemented in P3, not Phase 1. FastAPI/OpenAPI remains the API contract authority throughout | Canonical specification §5 | P1 | Client-derivation work in Phase 1 (not applicable) |
| P1-OD-05 | Task runner | Decided | Project Owner | 2026-10-05 | No task runner in Phase 1; root scripts are used. Not a permanent rejection; may be reconsidered when repository complexity justifies it | Phase 0 document, Out of Scope (toolchain assigned to Phase 1; ACC-008) | P1 | Phase 1 workspace configuration |
| P1-OD-06 | Quality checks in CI | Decided | Project Owner | 2026-10-05 | Lint, format verification, type checking and tests run in CI during Phase 1. They are not made required branch-protection status checks; repository protection is unchanged | Canonical specification §22; existing security CI (`.github/workflows/security.yml`) | P1 | Phase 1 CI configuration |
| P1-OD-07 | Dependency vulnerability scanning | Decided | Project Owner | 2026-10-05 | Dependency vulnerability scanning is introduced in Phase 1 using the selected package-management tooling. P19 remains responsible for broader security hardening | Canonical specification §21 | P1 | Phase 1 dependency and supply-chain controls |
| P1-OD-08 | Line-ending normalization | Decided | Project Owner | 2026-10-05 | `.gitattributes` is extended only for the new Phase 1 source and configuration file types. Phase 0 artefacts are not renormalized | L1-R2-5 (accepted residual, Phase 0 Completion Decision record CD.6) | P1 | Phase 1 root configuration |
| P1-OD-09 | Content acceptance of the Phase 1 planning document | Decided | Project Owner | 2026-10-05 | No separate acceptance-register content acceptance is required before Phase 1 enters `In Progress`, and the acceptance register is not amended for this purpose. The Project Owner's explicit approval of the planning baseline is the basis for the `Not Started` → `In Progress` transition, under the existing lifecycle rules | `docs/architecture/acceptance-register.md` §1–§2; `docs/phases/README.md` §11a | P1 | Entry of Phase 1 into `In Progress` |
| P1-OD-10 | Evidence-publication stopping rule | Decided | Project Owner | 2026-10-05 | The Phase 0 evidence-publication stopping rule is adopted: a designated terminal evidence-publication commit's own CI run is reported, not recorded. The rule is stated explicitly before Phase 1 evidence publication begins | Phase 0 evidence-publication practice (terminal commit `beac056cf65dd151a6a3f0c3e35ec5b98fdae730`) | P1 | Phase 1 verification and evidence recording |
| P1-OD-11 | Frontend API consumption | Decided | Project Owner | 2026-10-05 | No frontend API calls in Phase 1. No proxy, backend-for-frontend or other new trust boundary is introduced | Canonical specification §5, §6 | P1 | Phase 1 Next.js shell |

## 7. Phase 1 Enforcement Dispositions

Owner-confirmed enforcement dispositions for Phase 1. Each is enforcement of the accepted dependency direction in canonical specification §4. It is not a new architectural decision, and the entry carries no independent architectural authority.

| ID | Rule enforced | Decision | Decided by | Decision date | Source authority | Phase | Affects |
| -- | ------------- | -------- | ---------- | ------------- | ---------------- | ----- | ------- |
| P1-ED-01 | Platform does not import API | Decided | Project Owner | 2026-10-05 | Canonical specification §4 (dependency direction); §9 | P1 | Phase 1 Python import-rule enforcement |
| P1-ED-02 | Application does not import API | Decided | Project Owner | 2026-10-05 | Canonical specification §4 (dependency direction) | P1 | Phase 1 Python import-rule enforcement |
| P1-ED-03 | Domains import neither Application nor API | Decided | Project Owner | 2026-10-05 | Canonical specification §4 (dependency direction) | P1 | Phase 1 Python import-rule enforcement |
