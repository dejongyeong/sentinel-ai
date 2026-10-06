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

## 8. Phase 1 Toolchain Selections

Toolchain selections for Phase 1 (Repository & Engineering Foundation), made by the Project Owner under P1-OD-01 and recorded under §1. The IDs correspond to the Phase 1 planning identifiers S-01 to S-18. Each entry records a selection and its version and pinning policy; it creates no architectural authority and no consequential architectural decision. Working evidence is produced by the consuming task's verification check and recorded in the Phase 1 evidence, not here. A change to a recorded version, including a patch change, is recorded here before it is applied.

S-02 and S-16 have no entry. S-02 (task runner) is not applicable under P1-OD-05. S-16 (OpenAPI-to-TypeScript client generator) is not applicable under P1-OD-04.

### P1-S-01 — JavaScript package and workspace manager

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | pnpm `11.28.4` |
| Version and pinning | Exact version in the root `package.json` `packageManager` field, with the registry sha512 hash |
| Rationale | Strict, non-flat `node_modules`; workspace and lockfile support; the version 11 line is mature and still patched |
| Rejected alternatives | pnpm `12.9.1` (new major); npm |
| Authority basis | Phase 0 document, Out of Scope (package manager assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.5, 1.15 |
| Evidence | Pending — `VER-P1-BOOTSTRAP-001`, `VER-P1-DEPS-001` |
| Notes | On 2026-10-06 the registry `latest-11` dist-tag pointed to `11.28.2`; `11.28.4` (published 2026-10-03, not deprecated) is selected. Task 1.15 settles the discrepancy |

### P1-S-03 — Node.js version

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | Node.js `24.21.0` (LTS line 24) |
| Version and pinning | Exact version in `.node-version`; root `package.json` `engines` `>=24.21.0 <25` |
| Rationale | LTS line; within the declared engine ranges of the selected JavaScript tools |
| Rejected alternatives | Node.js 26 (not LTS at the decision date) |
| Authority basis | Phase 0 document, Out of Scope (ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.5, 1.16 |
| Evidence | Pending — `VER-P1-BOOTSTRAP-001` |

### P1-S-04 — TypeScript version and compiler baseline

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | TypeScript `6.0.3`; compiler baseline `strict`, `noUncheckedIndexedAccess`, `noEmit`, `isolatedModules` |
| Version and pinning | Exact; configuration local to `apps/web` (P1-OD-03) |
| Rationale | Next.js `16.3.8` installs `typescript@^6.0.0` by default |
| Rejected alternatives | TypeScript `7.0.2` |
| Authority basis | Phase 0 document, Out of Scope (type checker assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.8, 1.12 |
| Evidence | Pending — `VER-P1-WEB-SHELL-001`, `VER-P1-TYPECHECK-001` |

### P1-S-05 — Next.js and React

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | `next` `16.3.8`; `react`, `react-dom`, `@types/react`, `@types/react-dom` `19.3.0`; `@types/node` `24.19.1` |
| Version and pinning | Exact; `react`, `react-dom` and their type packages change together; Next.js telemetry disabled |
| Rationale | Current major; declared peer ranges satisfied; no frontend API calls in Phase 1 (P1-OD-11) |
| Rejected alternatives | Next.js 15.x |
| Authority basis | Canonical specification §5, §6; P1-OD-01; P1-OD-11 |
| Phase | P1 |
| Consumed by | Task 1.8 |
| Evidence | Pending — `VER-P1-WEB-SHELL-001`, `VER-P1-API-CONTRACT-001` |

### P1-S-06 — TypeScript and JavaScript linting and formatting

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | `@biomejs/biome` `2.5.15`, for linting and formatting of `apps/web` |
| Version and pinning | Exact; scoped to `apps/web`; no Biome configuration at the repository root; no Prettier, ESLint or `eslint-config-next` |
| Rationale | ESLint 9 reached end-of-life on 2026-08-06; ESLint 10 conflicts with the declared peer ranges of plugins required by `eslint-config-next` `16.3.8`; Biome provides linting and formatting in one tool, with React-oriented and accessibility-oriented rules, without that dependency chain |
| Rejected alternatives | ESLint 9 with `eslint-config-next` (end-of-life); ESLint 10 with `eslint-config-next` (peer conflicts); Prettier |
| Authority basis | Phase 0 document, Out of Scope (formatter and linter assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.10, 1.11 |
| Evidence | Pending — `VER-P1-LINT-001`, `VER-P1-FORMAT-001` |
| Notes | Biome's accessibility rules are an engineering-time lint guardrail. They are not the project's accessibility auditing capability, which remains the responsibility of the Accessibility Sentinel. Placement keeps `VER-P0-FORMAT-001` not applicable; the Phase 0 verifier is not modified for this selection |

### P1-S-07 — TypeScript test runner

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | `vitest` `5.0.3`; `vite` `8.3.2`; `jsdom` `30.1.2`; `@testing-library/react` `16.3.3`; `@testing-library/dom` `10.4.2` |
| Version and pinning | Exact |
| Rationale | `vite` `8.3.2` satisfies Vitest's declared peer range; `jsdom` supports the selected Node.js version |
| Rejected alternatives | Jest 30 |
| Authority basis | Phase 0 document, Out of Scope (test runner assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Task 1.13 |
| Evidence | Pending — `VER-P1-TEST-001`, `VER-P1-WEB-SHELL-001` |
| Notes | Whether `@vitejs/plugin-react` is required is established in task 1.13; it is added only through a recorded change to this entry |

### P1-S-08 — Python version

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | Python `3.14.8` |
| Version and pinning | `.python-version` `3.14.8`; `requires-python` `>=3.14,<3.15` |
| Rationale | Supported until 2030-10-31; all selected Python tools require Python 3.10 or later |
| Rejected alternatives | Python 3.13 |
| Authority basis | Phase 0 document, Out of Scope (ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Task 1.5 |
| Evidence | Pending — `VER-P1-BOOTSTRAP-001`, `VER-P1-P0-REGRESSION-001` |

### P1-S-09 — Python project and dependency manager

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | uv `0.12.23` |
| Version and pinning | `[tool.uv] required-version = "==0.12.23"`; `uv.lock` committed; `pre-commit` declared in the development dependency group |
| Rationale | Lockfile, workspace and interpreter management; built-in dependency audit |
| Rejected alternatives | Poetry `2.5.1` |
| Authority basis | Phase 0 document, Out of Scope (package manager assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.5, 1.15 |
| Evidence | Pending — `VER-P1-BOOTSTRAP-001`, `VER-P1-DEPS-001` |

### P1-S-10 — FastAPI version and ASGI server

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | `fastapi` `0.142.2`; `uvicorn` `0.54.0`; without the `[standard]` extra |
| Version and pinning | Exact direct versions; transitive versions fixed by `uv.lock` |
| Rationale | Minimal service shell; FastAPI/OpenAPI is the HTTP API contract authority |
| Rejected alternatives | Granian; Hypercorn |
| Authority basis | Canonical specification §5; P1-OD-01 |
| Phase | P1 |
| Consumed by | Task 1.6 |
| Evidence | Pending — `VER-P1-API-SHELL-001` |

### P1-S-11 — Python linting and formatting

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | Ruff `0.16.10`, for linting and formatting of `services/`, with the security (`S`) rules enabled |
| Version and pinning | Exact |
| Rationale | One tool for linting and formatting |
| Rejected alternatives | Black with flake8 and isort |
| Authority basis | Phase 0 document, Out of Scope (formatter and linter assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.10, 1.11 |
| Evidence | Pending — `VER-P1-LINT-001`, `VER-P1-FORMAT-001` |

### P1-S-12 — Python type checker

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | mypy `2.4.0`, strict mode; run as a command and in CI, not as a pre-commit hook |
| Version and pinning | Exact |
| Rationale | Pure Python; no runtime download of a Node.js runtime |
| Rejected alternatives | pyright |
| Authority basis | Phase 0 document, Out of Scope (type checker assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Task 1.12 |
| Evidence | Pending — `VER-P1-TYPECHECK-001` |

### P1-S-13 — Python test runner

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | pytest `9.1.1`; httpx `0.28.1` (development only) |
| Version and pinning | Exact |
| Rationale | Standard Python test runner; FastAPI's test client requires httpx |
| Rejected alternatives | unittest |
| Authority basis | Phase 0 document, Out of Scope (test runner assigned to Phase 1; ACC-008); P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.6, 1.13 |
| Evidence | Pending — `VER-P1-TEST-001`, `VER-P1-API-SHELL-001` |

### P1-S-14 — Python import-rule enforcement

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | import-linter `2.15`, with forbidden contracts only: one for Platform importing neither Application nor Domains (canonical specification §9), and one each for P1-ED-01, P1-ED-02 and P1-ED-03. No layers contract |
| Version and pinning | Exact |
| Rationale | Forbidden contracts map one-to-one onto the enforced rules without permitting or forbidding the edges deferred under P1-OD-02 |
| Rejected alternatives | Tach; a custom script |
| Authority basis | Canonical specification §4, §8, §9; P1-ED-01 to P1-ED-03; P1-OD-01 |
| Phase | P1 |
| Consumed by | Task 1.7 |
| Evidence | Pending — `VER-P1-BOUNDARIES-001` |
| Notes | Whether an independence contract can express domain isolation generically is established in task 1.7. If it can, adding it is recorded as a change to this entry; if not, domain isolation is deferred as task 1.7 provides |

### P1-S-15 — Frontend dependency-restriction mechanism

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | A repository check script using only the Python standard library, which checks the `apps/web` manifest and the pnpm lockfile against an explicit, reviewable prohibited-package list |
| Version and pinning | Not applicable (repository code) |
| Rationale | Deterministic; checks dependency declarations as task 1.8 specifies; adds no dependency |
| Rejected alternatives | dependency-cruiser |
| Authority basis | Canonical specification §6; P1-OD-01 |
| Phase | P1 |
| Consumed by | Task 1.8 |
| Evidence | Pending — `VER-P1-WEB-SHELL-001` |
| Notes | The prohibited-package list is the authoritative deterministic input to this check. Any expansion or change to the prohibited set is recorded as a change to P1-S-15 before implementation |

### P1-S-17 — Dependency vulnerability scanning

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | `pnpm audit` (pnpm `11.28.4`) for the JavaScript dependency graph; `uv audit` (uv `0.12.23`) for the Python dependency graph |
| Version and pinning | Follows P1-S-01 and P1-S-09 |
| Policy | Any known advisory fails, regardless of severity. Development-only and transitive dependencies are included. An advisory with no available fix fails. An exception exists only when approved by the Project Owner and recorded in §9. A nonzero audit result caused by one or more advisories not covered by a §9 exception is FAIL. An execution or tooling failure that prevents a trustworthy audit result, including an unreachable advisory service or offline execution, is BLOCKED, never PASS. Each audit run records its date and tool version |
| Exception mechanisms | uv: `uv audit --ignore-until-fixed <ID>` for each §9 exception where it is appropriate. pnpm: the GHSA-based `audit.ignore` mechanism, listing only GHSA IDs recorded in §9. A pnpm `audit.ignore` entry does not lapse when a fix becomes available, so each pnpm exception is reviewed by its §9 review date and removed when it is no longer approved. Suppression not backed by a §9 entry, and wholesale or severity-wide suppression, are prohibited |
| Rationale | P1-OD-07 requires scanning with the selected package-management tooling |
| Rejected alternatives | osv-scanner; pip-audit |
| Authority basis | P1-OD-07; canonical specification §21; P1-OD-01 |
| Phase | P1 |
| Consumed by | Tasks 1.15, 1.16 |
| Evidence | Pending — `VER-P1-DEPS-001` |
| Notes | The exact commands, exit-status semantics and exception behaviour are established in task 1.15 |

### P1-S-18 — Pre-commit hook set

| Field | Value |
| ----- | ----- |
| Decision | Decided |
| Decided by | Project Owner |
| Decision date | 2026-10-06 |
| Selection | The existing Gitleaks hook, unchanged (DR-P0-001, DR-P0-002), plus the `ruff-check` hook from `https://github.com/astral-sh/ruff-pre-commit` at commit `f12be1ebaa5351c1fc76472de98db2c3446c8253` (tag `v0.16.10`), with `files: ^services/`, check-only (no `--fix`) |
| Version and pinning | Pinned by commit; the Ruff hook version equals P1-S-11 |
| Rationale | The hook runs in a pre-commit-managed environment, needs neither the project virtual environment nor `node_modules`, and keeps the Phase 0 pre-commit controls and `VER-P0-FORMAT-001` results unchanged |
| Rejected alternatives | A `ruff-format` hook; hooks that depend on the project environment |
| Authority basis | DR-P0-002 rationale (formatter, linter and type-check hooks belong to Phase 1); P1-OD-01 |
| Phase | P1 |
| Consumed by | Task 1.14 |
| Evidence | Pending — `VER-P1-PRECOMMIT-001`; `VER-P0-PRECOMMIT-NEG` and `VER-P0-PRECOMMIT-POS` through `VER-P1-P0-REGRESSION-001` |
| Notes | The pre-commit configuration must not introduce text matched by the `VER-P0-FORMAT-001` detector |

## 9. Phase 1 Vulnerability Exceptions

Each exception is approved by the Project Owner before it is applied, and is the only basis for an ecosystem suppression entry (P1-S-17).

| Advisory ID | Ecosystem | Affected package | Rationale | Approved by | Approval date | Review date | Mechanism |
| ----------- | --------- | ---------------- | --------- | ----------- | ------------- | ----------- | --------- |

No exception is recorded.
