# Phase 1 — Repository & Engineering Foundation

**File:** `docs/phases/phase-1-repository-and-engineering-foundation.md`

## Status

`In Progress`

This is the phase lifecycle status (`docs/phases/README.md` §8). It changes only through the lifecycle, with the Project Owner's authorization. Creating, proposing or revising this document is not a lifecycle transition and does not move Phase 1 to `In Progress`.

**Document governance.** This document is a proposed planning baseline. Four things are distinct:
- **document creation:** this file exists;
- **document proposal:** its content is proposed for owner review;
- **content acceptance:** not required. Under the owner decision P1-OD-09 (`docs/decisions/decision-register.md` §6), no acceptance-register entry is required before entry, and none is created by this document. The Project Owner's explicit approval of this planning baseline is the basis for the later `Not Started` → `In Progress` transition;
- **phase lifecycle transition:** recorded in the Status History.

## Objective

Establish the repository and engineering foundation for Sentinel AI:
- recorded owner selections for the toolchain;
- a reproducible workspace;
- runnable application shells that respect the accepted architecture;
- deterministic enforcement of the import rules that Phase 1 can enforce;
- quality tooling and developer workflow;
- Phase 1 verification.

No product capability and no later-phase infrastructure is implemented.

## Why This Phase Exists

Phase 0 established governance and secure engineering controls and contains no application code. Its accepted content (ACC-008) assigns "the package manager, formatter, linter, test runner, or type checker" to Phase 1 (Phase 0 document, Out of Scope). Later phases need a repository in which the accepted logical architecture is physically expressed and engineering quality checks exist.

### Labels used in this document

| Label | Meaning |
| ----- | ------- |
| [Accepted] | An accepted decision in a cited authoritative source |
| [Required] | Required by a cited accepted source |
| [Constraint] | A constraint imposed by a cited accepted source or by an existing project control |
| [Proposed] | Proposed by this document; not accepted. "[Proposed — operationalizes X]" is a proposed means of meeting the accepted X, not itself accepted. "[Proposed — follows X]" follows a Proposed subject document X |
| [Assumption] | An assumption, to be confirmed |
| [Fact] | Observed in the repository |
| [Owner decision] | Reserved to the Project Owner. Decisions already made are recorded in `docs/decisions/decision-register.md` §6–§7 and cited here by their register ID; unresolved ones remain open |
| [Deferred] | Deferred to a later phase |

No statement labelled [Proposed], [Owner decision], [Assumption] or [Deferred] is treated as authoritative anywhere in this document.

### Where each subject is covered

| Subject | Section |
| ------- | ------- |
| Purpose; scope; non-goals; dependencies; pre-entry decisions | Objective; Why This Phase Exists; Scope; Out of Scope; Dependencies |
| Authority references; current baseline | Authority References; Current Baseline |
| Logical architecture and enforcement levels | Architectural Constraints |
| Target foundation, repository structure, toolchain, TypeScript, Python, Next.js, FastAPI, boundaries, API contract and client, shared packages, testing, lint/format/type check, developer workflow, Claude Code integration, security, documentation | Engineering Foundation Requirements |
| Dependency graph | Decision and Task Dependencies |
| Task breakdown | Deliverables |
| Acceptance criteria; verification evidence; exit criteria | Phase-Level Acceptance Criteria; Evidence; Exit Criteria |
| Deferred and later-phase capabilities | Out of Scope |
| Open and unresolved decisions | Deferred Decisions |
| Status history | Completion Record |

## Scope

Phase 1 establishes, subject to the owner decisions recorded in `docs/decisions/decision-register.md` §6 (summarized under Deferred Decisions):
- owner-recorded selections for the Phase 1 toolchain;
- a root workspace with pinned tool versions and committed lockfiles;
- a FastAPI service shell (health endpoint and OpenAPI generation only);
- Python package skeletons for the Application, Domains (namespace root only) and Platform layers, with enforcement of the import rules Phase 1 can enforce;
- a Next.js application shell with no data access;
- linting, formatting, type checking and test foundations for both stacks, with pre-commit integration;
- dependency and supply-chain hygiene for the new dependencies;
- documentation and Claude Code context aligned with the implemented foundation;
- Phase 1 verification machinery and evidence, with Phase 0 verification preserved.

## Out of Scope

[Constraint] Phase 1 does not implement capabilities owned by later phases (`docs/product/roadmap.md`):

| Capability | Owning phase |
| ---------- | ------------ |
| Containerisation and local infrastructure | P2 |
| PostgreSQL, SQLAlchemy, Alembic, migrations, schemas | P3 |
| Authentication and authorization (DEF-002) | P4 |
| Redis, idempotency, rate limiting | P5 |
| Background processing, workers, queues (DEF-001) | P6 |
| Full observability (telemetry, metrics, tracing) | P7 |
| AI platform and providers (DEF-006) | P8 |
| RAG and retrieval (DEF-007) | P9 |
| Accessibility engine and browser isolation (DEF-005) | P10 |
| Standards and WCAG mapping | P11 |
| Findings, evidence, storage, retention (DEF-003, DEF-004) | P12 |
| AI accessibility analysis | P13 |
| Remediation and validation | P14 |
| Continuous monitoring and compliance (DEF-008) | P15 |
| Data Quality Sentinel (DEF-009) | P16 |
| Incident Sentinel (DEF-010) | P17 |
| AI evaluation and safety | P18 |
| Security hardening | P19 |
| Performance and reliability | P20 |
| Cloud deployment (DEF-011) | P21 |
| CI/CD delivery (ADR-0014, reserved) | P22 |
| Documentation and portfolio | P23 |
| Integration and release readiness | P24 |

Phase 1 creates no directory, package or dependency for:
- workers, migrations, databases, Redis or queues;
- AI, RAG, accessibility scanning or monitoring;
- cloud deployment or portfolio material;
- any individual domain (`accessibility`, `data_quality`, `incident`).

It introduces no microservice and no Drizzle or other production persistence layer.

Tests, basic diagnostics and security hygiene for what Phase 1 builds are in scope, because testing, security and observability are cross-phase (canonical specification §21–§23; `docs/phases/README.md` §17–§19). Mentions of later-phase capabilities in documentation are references, not implementation.

## Dependencies

- **Governance dependency [Accepted]:** Phase 0 is `Complete` (Phase 0 document, Status History). A dependent phase may become `In Progress` only when its prerequisite is `Complete` (canonical specification §27; `docs/product/roadmap.md` §3).
- **Inherited controls [Constraint]:** Phase 1 must keep these working:
  - the Gitleaks pre-commit hook;
  - the security CI (`Secret scanning` and its positive control);
  - repository protection on `Secret scanning`;
  - the Claude Code guardrails;
  - the phase-verification procedure;
  - the Phase 0 verification results (Phase 0 controls P0-AC-015 to P0-AC-022).

### Pre-entry governance decisions

These are resolved before Phase 1 execution begins. They are not resolved by any Phase 1 task. Both have been decided by the Project Owner and are recorded in the decision register:

| Decision | Recorded as | Outcome |
| -------- | ----------- | ------- |
| OD-01 — how Phase 1 selections and owner decisions are recorded | P1-OD-01 (Decided, 2026-10-05) | `docs/decisions/decision-register.md` is the recording mechanism, governed through `docs/decisions/README.md` §3a (ACC-011) and the register's §1 |
| OD-09 — content acceptance of this document | P1-OD-09 (Decided, 2026-10-05) | No separate acceptance-register content acceptance; the Project Owner's explicit approval of this planning baseline is the basis for entry to `In Progress` |

**Who resolves them.** The Project Owner (canonical specification §30; `CLAUDE.md`, Decision Authority). The decisions are recorded in the authoritative mechanism designated through the accepted governance process, `docs/decisions/decision-register.md`. This document references the recorded decisions and may summarize them. A summary here does not make this document a governance authority, and this document creates no recording mechanism.

### Execution-stage decisions

OD-02 to OD-08, OD-10 and OD-11 have also been recorded by the Project Owner (P1-OD-02 to P1-OD-08, P1-OD-10, P1-OD-11; see Deferred Decisions). OD-02 and OD-03 are recorded as `Deferred`; the others as `Decided`. The task that the baseline assigned to obtaining each decision now references the recorded entry; it does not re-decide it. P1-OD-12 (Decided) was recorded during task 1.15; see Deferred Decisions.

**Lifecycle of every owner decision:**
1. unresolved;
2. owner decision, or explicit owner deferral (deferral is not available for the pre-entry decisions);
3. recorded in the decision register;
4. verified by `VER-P1-DECISIONS-001` (P1-AC-002).

## Authority References

This document operationalizes accepted architecture. It does not define it.

| Subject | Authority | Status |
| ------- | --------- | ------ |
| Cross-cutting engineering invariants | The current Accepted canonical specification, identified by `docs/architecture/canonical-specification/README.md` (currently v0.3) | Accepted |
| Document authority and status models | `docs/architecture/documentation-authority.md` | Accepted |
| Human acceptance of documents | `docs/architecture/acceptance-register.md` | Accepted |
| Phase lifecycle, template, evidence location | `docs/phases/README.md` | Accepted |
| Phase 0 hand-offs to Phase 1 | Phase 0 document (content accepted, ACC-008) | Complete phase |
| Phase sequence and names | `docs/product/roadmap.md` | Proposed |
| Repository topology | `docs/architecture/system-architecture.md` §2 (an implementation-level convention) | Proposed |
| Layer responsibilities | `docs/architecture/application-architecture.md` | Proposed |
| ADR process and index | `docs/decisions/README.md` (ACC-011) | Accepted |
| Non-ADR selections, owner decisions and deferrals (including P1-OD-01 to P1-OD-12 and P1-ED-01 to P1-ED-03) | `docs/decisions/decision-register.md`, designated by `documentation-authority.md` §4 and `docs/decisions/README.md` §3a | Proposed (the register document); its designation is Accepted |
| Developer commands; commit convention | `docs/operations/developer-workflow.md` | Proposed |
| Security architecture and procedures | `docs/architecture/security-architecture.md`; `docs/security/` | Proposed |
| Claude Code configuration | `CLAUDE.md`; `.claude/` | — |

Where this document restates an invariant, the cited authority prevails.

## Current Baseline

State at commit `4a8fd607c4fb04319276799d3a7e370792015a4e` (Phase 0 completed at `beac056cf65dd151a6a3f0c3e35ec5b98fdae730`; later commits are governance-only):
- [Fact] No `package.json`, lockfile, `tsconfig`, Node version pin, `pyproject.toml` or Python version pin exists. There is no application code.
- [Fact] `.gitignore` already lists Node, pnpm, Turborepo, Next.js and Python tool caches. These entries are not tool selections.
- [Fact] `.gitattributes` normalizes only `*.sh` (L1-R2-5, accepted residual).
- [Fact] `.pre-commit-config.yaml` has one hook, Gitleaks `v8.30.1` (DR-P0-002). DR-P0-002's rationale assigns formatter, linter and type-check hooks to Phase 1.
- [Fact] `.github/workflows/security.yml` runs only secret scanning and its positive control. `main` requires the `Secret scanning` check.
- [Fact] `scripts/verify-phase.sh` supports only `phase-0`. Its `VER-P0-STATUS-PHASE-001` and `VER-P0-LIFECYCLE-001` checks read every `docs/phases/phase-*.md`, so they also read this document.
- [Fact] `docs/operations/developer-workflow.md` marks lint, format and type check as "Not applicable until Phase 1 defines the toolchain".
- [Fact] `README.md` and `CLAUDE.md` still describe the project as in Phase 0 with no application code.
- [Fact] No ADR file exists. ADR-0003 "Application / Domain / Platform Boundaries" is reserved but not written (`docs/decisions/README.md` §10).
- [Fact] The Phase 1 owner decisions and deferrals (P1-OD-01 to P1-OD-11) and enforcement dispositions (P1-ED-01 to P1-ED-03) are recorded in `docs/decisions/decision-register.md` §6–§7 (commit `4a8fd607c4fb04319276799d3a7e370792015a4e`).

## Architectural Constraints

The **logical architecture** is accepted. The constraints below are cited, not redefined; section numbers refer to the current Accepted canonical specification:

1. [Constraint] Modular monolith; no service split without an accepted ADR (§3).
2. [Constraint] Dependency direction: Next.js → FastAPI → Application → Domain / Platform; Worker → Application → Domain / Platform (§4).
3. [Constraint] FastAPI and its generated OpenAPI contract are authoritative for the HTTP API. A TypeScript API client is derived from that contract, and the frontend must not independently redefine it (§5).
4. [Constraint] Next.js does not directly access PostgreSQL, Redis, job queues, internal domain persistence, LLM providers or internal infrastructure credentials (§6).
5. [Constraint] The Application layer owns use-case orchestration and authorization entry (§7).
6. [Constraint] Domains do not import other domains, and a domain must not become a hidden shared-services layer (§8).
7. [Constraint] Platform does not import domains or application use cases (§9).
8. [Constraint] PostgreSQL, SQLAlchemy and Alembic are the persistence authorities, and Drizzle is not a production database-access layer. None is implemented in Phase 1 (§10).
9. [Constraint] Redis is non-authoritative and is not introduced in Phase 1 (§11).
10. [Constraint] Unresolved decisions are not silently implemented (§31; `docs/phases/README.md` §4).

The **physical topology** (directory and package names) is not canonical. `docs/architecture/system-architecture.md` §2, a Proposed document, records it as an implementation-level convention. The Phase 1 physical structure under Engineering Foundation Requirements is [Proposed — follows `system-architecture.md` §2].

### Levels of boundary in Phase 1

| Level | What it governs | Phase 1 treatment |
| ----- | --------------- | ----------------- |
| Architectural dependency direction | Constraint 2 | Documented here; enforced only through the levels below |
| Runtime / service boundary | Next.js and FastAPI are separate runtimes communicating over HTTP; the worker is a later runtime (P6) | Two shells exist. No frontend API calls in Phase 1 (P1-OD-11). No worker runtime |
| Python package / import boundary | Imports among the API, Application, Domains and Platform packages | Enforced as listed below (task 1.7) |
| Frontend dependency restriction | Constraint 4: what `apps/web` may depend on | [Proposed — operationalizes §6] Enforced by a dependency check (task 1.8) |

**Python import rules.** These apply to the layer packages whatever their final import names; the names are fixed in task 1.7.

| Rule | Label and basis |
| ---- | --------------- |
| Platform imports neither Application nor Domains | [Constraint] §9 |
| Domain-to-domain isolation | [Constraint] §8. Enforced only where demonstrable without placeholder domains (task 1.7) |
| Platform does not import API | [Constraint — §4 direction; enforcement confirmed by the Project Owner, P1-ED-01] |
| Application does not import API | [Constraint — §4 direction; enforcement confirmed by the Project Owner, P1-ED-02] |
| Domains import neither Application nor API | [Constraint — §4 direction; enforcement confirmed by the Project Owner, P1-ED-03] |

P1-ED-01 to P1-ED-03 are enforcement of the accepted §4 dependency direction. They are not new architectural decisions, and their register entries carry no independent architectural authority.

**Dependency edges not settled by any authority [Owner decision, OD-02 — Deferred, P1-OD-02].** Phase 1 neither permits nor forbids these, and does not enforce them. Resolution gate: before the first phase whose implementation depends on these edges; the ADR requirement in `docs/decisions/README.md` §2 then applies (ADR-0003 reserved).

| Edge | Why it is open |
| ---- | -------------- |
| Domains → Platform | §4 and system architecture §3 show "Application → Domain / Platform" without settling Domain → Platform. Application architecture §2 says "Domain → Domain-local abstractions". Deferred family F10 |
| API → Platform | The direction names only API → Application |
| API → Domains (directly) | The direction names only API → Application; authorization entry is at Application (§7) |

No package is created only to make the dependency graph testable.

## Engineering Foundation Requirements

Each choice is an owner selection (task 1.1), recorded in `docs/decisions/decision-register.md` §8 (P1-S-01, P1-S-03 to P1-S-15, P1-S-17, P1-S-18).

### Target engineering foundation

[Proposed] At Phase 1 exit:
- a contributor can clone the repository and, using pinned versions and committed lockfiles, install, lint, format-check, type-check, test and build both stacks with documented commands;
- both shells run locally;
- the enforced import rules reject violations deterministically;
- Phase 1 verification checks exist and pass;
- Phase 0 verification results are unchanged.

### Repository structure

**(1) Physically established by Phase 1** [Proposed — follows `system-architecture.md` §2]:

| Path | Content | Task |
| ---- | ------- | ---- |
| Root workspace, version-pin and lock files | As selected in task 1.1 | 1.5 |
| `services/api/` | FastAPI service shell | 1.6 |
| `services/application/` | Application layer package; no use cases | 1.7 |
| `services/domains/` | Domain namespace root only; no individual domain package | 1.7 |
| `services/sentinel_platform/` | Platform layer package; no infrastructure clients | 1.7 |
| `apps/web/` | Next.js application shell | 1.8 |
| `docs/phases/evidence/phase-1/` | Phase 1 evidence; created at the first verification run | 1.19 |

**(2) Architecturally documented by Phase 1, not physically created:**
- the worker → Application boundary (P6);
- the migration authority (P3);
- the persistence, cache, queue and provider seams within Platform (P3, P5, P6, P8);
- the individual domains: accessibility (P10 onward), data quality (P16), incident (P17).

**(3) Deferred to their owning phases [Deferred]:**
- container files (P2);
- infrastructure and deployment configuration (P21, P22);
- `docs/ai/`, `docs/accessibility/`, `docs/portfolio/`;
- `docs/decisions/adr/`, which is created only with the first actual ADR (`docs/decisions/README.md` §3a).

### Toolchain requirements

- [Required] Phase 1 selects the package manager, formatter, linter, test runner and type checker (Phase 0 document, Out of Scope, ACC-008).
- [Owner decision] Recording mechanism: decided (P1-OD-01) — selections are recorded in `docs/decisions/decision-register.md`.
- [Proposed] Each selection record states the candidate and version, the rationale, the selection criteria (including supply-chain considerations), the evidence that the selection works, and the owner's decision.
- The individual selections are S-01 to S-18 (task 1.1).

### TypeScript requirements

- [Owner decision, decided — P1-S-04] TypeScript version and compiler baseline (S-04). TypeScript configuration stays local to `apps/web` (P1-OD-03).
- [Proposed — operationalizes `docs/phases/README.md` §18] A type-check command exists and passes for all TypeScript code (task 1.12).
- [Constraint] No TypeScript code independently defines the HTTP API contract (§5).

### Python requirements

- [Owner decision, decided — P1-S-08, P1-S-09] Python version and project/dependency manager (S-08, S-09).
- [Fact] Existing scripts require Python ≥ 3.9 and use only the standard library. The project's Python version must not break `scripts/verify-phase.sh` or `scripts/checks/repo_snapshot.py`.
- [Proposed] The service and layer packages are importable in an environment created from a committed lock (tasks 1.5–1.7).

### Next.js foundation requirements

- [Proposed] `apps/web` builds and has at least one test (task 1.8).
- [Constraint] It does not directly access PostgreSQL, Redis, queues, LLM providers or internal credentials (§6).
- [Proposed — operationalizes §6] A deterministic dependency check on `apps/web` (task 1.8).
- [Owner decision, decided — P1-S-05] Next.js version (S-05).
- [Owner decision, decided — P1-OD-11] `apps/web` makes no API calls in Phase 1. No proxy, backend-for-frontend or other new trust boundary is introduced.

### FastAPI foundation requirements

- [Proposed] `services/api` exposes a health endpoint and generates its OpenAPI document, with tests (task 1.6).
- [Constraint] No persistence, authentication, Redis, queue or provider integration (Out of Scope).
- [Proposed — follows `docs/security/security-baseline.md` §3] Configuration comes from the environment. Only a non-secret `.env.example` may be committed.
- [Owner decision, decided — P1-S-10] FastAPI version and ASGI server (S-10).

### Application / Domain / Platform boundaries

See Architectural Constraints, "Levels of boundary in Phase 1". Task 1.7 enforces the listed rules, including P1-ED-01 to P1-ED-03. The OD-02 edges are deferred (P1-OD-02) and not enforced.

### API contract, generated client and frontend consumption

Three separate matters:

| Matter | Status |
| ------ | ------ |
| 1. API contract authority | [Constraint] FastAPI/OpenAPI is the authoritative HTTP contract (§5). It applies throughout Phase 1 and is not affected by OD-04 or OD-11 |
| 2. Generated TypeScript client | [Constraint] Any TypeScript client is derived from the contract (§5). [Owner decision, decided — P1-OD-04] Derivation is implemented in P3, not Phase 1 |
| 3. Frontend consumption of the API | [Owner decision, decided — P1-OD-11] No frontend API calls in Phase 1. Consumption is not assumed to require a generated client, and a generated client does not imply consumption |

Not implementing derivation in Phase 1 does not weaken or defer the contract authority. P1-AC-007 enforces it in Phase 1 as the absence of API request code and of independently defined API contracts in `apps/web`.

**Note on OD-11.** OD-11 was introduced during the Stage 2 consistency pass. Frontend API consumption is logically independent of the API contract authority (matter 1) and of generated-client timing (matter 2), so coupling it to OD-04 would have decided it implicitly. OD-11 does not modify or defer the accepted FastAPI/OpenAPI contract authority. It has since been decided by the Project Owner (P1-OD-11).

### Shared package requirements

- [Owner decision, deferred — P1-OD-03] No shared TypeScript package and no generated-client location in Phase 1; TypeScript configuration stays local to `apps/web`. Resolution gate: when a shared package or client location is first needed.

### Testing foundation

- [Required] Each capability introduced receives appropriate tests (canonical specification §22; `docs/phases/README.md` §18).
- [Proposed — operationalizes §22] Each deterministic enforcement mechanism introduced by Phase 1 has an appropriate positive and negative verification path where technically applicable. Negative paths run in temporary locations outside the repository unless they are themselves test sources.

### Linting, formatting and type checking

- [Required] Phase 1 selects the formatter, linter and type checker (Phase 0 document, Out of Scope, ACC-008).
- [Proposed] Commands exist for both stacks and pass on the repository (tasks 1.10–1.12).
- [Proposed — follows DR-P0-002's rationale] The selected hooks are added to pre-commit alongside the retained Gitleaks hook (task 1.14). The hook set is S-18.
- [Owner decision, decided — P1-OD-06] These checks also run in CI in Phase 1. They are not required branch-protection status checks, and repository protection is unchanged.

### Developer workflow

- [Proposed — follows `docs/operations/developer-workflow.md` §1] The workflow document lists verified commands. Commands for capabilities that do not exist are marked as such, not invented.
- [Proposed] It gains the Phase 1 commands and a clean-clone bootstrap procedure (tasks 1.5, 1.18).

### Claude Code integration

- [Constraint] CLAUDE.md governance, Rules, Hooks, permissions, the reviewer contract and the `/adr` and `/commit` procedures are preserved and not weakened.
- [Proposed] `CLAUDE.md` is updated with the Phase 1 structure and commands, and its stale Phase 0 framing is corrected (task 1.18). Correcting CR-1 / L1-AR-1 in the same revision is optional and owner-confirmed.
- [Proposed] `.claude/rules/architecture.md` gains a pointer, not a restatement, to the import-rule configuration (task 1.18).
- [Constraint] Reviewer agent definitions are not changed (Completion Decision CD.4, F38 Deferred).

### Security requirements

- [Required] Security controls are introduced with the capabilities they protect (canonical specification §21; `docs/phases/README.md` §17).
- [Constraint] Secrets are never committed. Gitleaks remains enforced in pre-commit and CI. Repository protection on `Secret scanning` is not changed. Sources: the Phase 0 controls (P0-AC-015 to P0-AC-022) and `.claude/rules/security.md`.
- [Proposed — operationalizes §21] Dependency acquisition, provenance, integrity and installation controls are documented and verified according to the capabilities and security model of the selected package managers. Committed lockfiles, version pinning and integrity verification are proposed as the appropriate controls for Phase 1. They are not permanent architecture rules.
- [Proposed] Any new CI job follows the existing workflow's pattern: SHA-pinned actions and least-privilege permissions.
- [Owner decision, decided — P1-OD-07] Dependency vulnerability scanning is introduced in Phase 1 using the selected package-management tooling. P19 remains responsible for broader security hardening.

### Documentation requirements

- [Required] Phase documentation references authoritative requirements, accepted architecture and accepted ADRs, identifies unresolved decisions and records evidence (`docs/phases/README.md` §20).
- [Proposed] `README.md`, `CLAUDE.md` and `docs/operations/developer-workflow.md` are updated when the capabilities they describe exist (task 1.18). Any later topology change goes through `system-architecture.md` §2 (P1-OD-03, deferred).
- [Constraint] Changes to Accepted documents require fresh acceptance (`docs/architecture/acceptance-register.md` §2). This document plans none.

## Decision and Task Dependencies

Ordering:
1. pre-entry governance decisions (OD-01, OD-09; recorded);
2. toolchain selections; the topology and other owner decisions are already recorded;
3. repository foundation;
4. shells and boundaries;
5. quality, security and verification tooling;
6. documentation alignment;
7. verification and completion.

Checks are implemented in task 1.17 after the capabilities they check exist, and are executed only in task 1.19.

| Task | Depends on tasks | Gated by | Acceptance criteria | Verification |
| ---- | ---------------- | -------- | ------------------- | ------------ |
| 1.1 Toolchain selections (orchestration) | — | OD-01 (P1-OD-01, recorded). References P1-OD-04, P1-OD-05, P1-OD-07 | P1-AC-001; contributes to P1-AC-002 | `VER-P1-SELECTIONS-001`; `VER-P1-DECISIONS-001` |
| 1.2 Unsettled dependency edges | — | OD-02 (P1-OD-02, Deferred) | Contributes to P1-AC-002 | `VER-P1-DECISIONS-001` |
| 1.3 Client-derivation timing and frontend API consumption | — | OD-04 (P1-OD-04, Decided) and OD-11 (P1-OD-11, Decided), independent | Contributes to P1-AC-002 | `VER-P1-DECISIONS-001` |
| 1.4 Shared-package and client topology | 1.3 (OD-04 outcome; client slot only) | OD-03 (P1-OD-03, Deferred) | Contributes to P1-AC-002 | `VER-P1-DECISIONS-001` |
| 1.5 Root workspace and bootstrap | 1.1 (S-01, S-03, S-08, S-09) | OD-05 (P1-OD-05: no task runner); OD-08 (P1-OD-08: `.gitattributes` part only) | P1-AC-003; contributes to P1-AC-002 | `VER-P1-BOOTSTRAP-001`; `VER-P1-DECISIONS-001` |
| 1.6 FastAPI shell | 1.5; 1.1 (S-10) | — | P1-AC-004 | `VER-P1-API-SHELL-001` |
| 1.7 Python layer packages and import rules | 1.6; 1.1 (S-14); 1.2 (enforced set only) | OD-02 | P1-AC-005 | `VER-P1-BOUNDARIES-001` |
| 1.8 Next.js shell and frontend dependency check | 1.5; 1.1 (S-04, S-05, S-15) | OD-11 (P1-OD-11: no API calls) | P1-AC-006, P1-AC-007 | `VER-P1-WEB-SHELL-001`, `VER-P1-API-CONTRACT-001` |
| 1.9 Shared TS packages and client derivation — **NOT APPLICABLE in Phase 1** | — | OD-03 (P1-OD-03, Deferred); OD-04 (P1-OD-04: P3) | P1-AC-008 (NOT APPLICABLE) | `VER-P1-API-CLIENT-001` (NOT APPLICABLE) |
| 1.10 Linting | 1.6, 1.7, 1.8; 1.1 (S-06, S-11) | — | P1-AC-009 | `VER-P1-LINT-001` |
| 1.11 Formatting | 1.6, 1.7, 1.8; 1.1 (S-06, S-11) | — | P1-AC-010 | `VER-P1-FORMAT-001` |
| 1.12 Type checking | 1.6, 1.7, 1.8; 1.1 (S-04, S-12) | — | P1-AC-011 | `VER-P1-TYPECHECK-001` |
| 1.13 Test foundation | 1.6, 1.7, 1.8; 1.1 (S-07, S-13) | — | P1-AC-012 | `VER-P1-TEST-001` |
| 1.14 Pre-commit integration | 1.10, 1.11, 1.12; 1.1 (S-18) | — | P1-AC-013 | `VER-P1-PRECOMMIT-001` |
| 1.15 Dependency and supply-chain hygiene | 1.5; 1.1 (S-17) | OD-07 (P1-OD-07: scanning in Phase 1) | P1-AC-014 | `VER-P1-DEPS-001` |
| 1.16 CI quality jobs | 1.10–1.13 | OD-06 (P1-OD-06: CI jobs in Phase 1, not required checks) | P1-AC-015; contributes to P1-AC-002 | `VER-P1-CI-QUALITY-001`; `VER-P1-DECISIONS-001` |
| 1.17 Phase 1 verification checks and Phase 0 regression baseline | 1.5–1.16 | — | P1-AC-016, P1-AC-017 (and implements the deterministic checks of the others; see task 1.17) | `VER-P1-P0-REGRESSION-001`, `VER-P1-SCOPE-001` |
| 1.18 Documentation and Claude context alignment | 1.5–1.17 | — | P1-AC-018 | `VER-P1-DOCS-001` |
| 1.19 Verification and completion (orchestration) | 1.1–1.18 | OD-10 (P1-OD-10: Phase 0 stopping rule) | P1-AC-002 (evaluated in 1.19-A), P1-AC-019 to P1-AC-023 | `VER-P1-DECISIONS-001`, `VER-P1-GIT-SAFETY-001`, `VER-P1-REVIEW-L1`, `VER-P1-REVIEW-L2-RUNTIME-<agent>`, `VER-P1-CI-EXEC-001`, `VER-P1-LIFECYCLE-001` |

**No circular dependencies:**
- The pre-entry decisions precede all tasks, and all eleven owner decisions are already recorded.
- Tasks 1.1–1.4 depend on no implementation.
- Task 1.9 is NOT APPLICABLE in Phase 1, so no task depends on it.
- Task 1.17 implements checks after the capabilities exist and runs nothing for completion. Task 1.19 executes them.

## Deliverables

Each task uses the nine subsections required by `docs/phases/README.md` §14. The additional task fields (ID, dependencies, scope, non-scope, deliverables, notes, exit condition) appear as labelled items inside them. Tasks 1.1 and 1.19 are orchestration tasks: they coordinate independently verifiable activities and implement no engineering capability.

### Task 1.1

#### Objective

Orchestrate the Project Owner's Phase 1 toolchain selections. Each selection is independently verifiable. This task does not resolve OD-01; it executes under the recorded P1-OD-01.

#### Inputs

- **ID:** 1.1 (orchestration).
- **Dependencies:** P1-OD-01 (recorded). S-02 is NOT APPLICABLE under P1-OD-05; S-16 is NOT APPLICABLE under P1-OD-04; S-17 is applicable under P1-OD-07.

Every applicable selection is recorded in `docs/decisions/decision-register.md` (P1-OD-01) and verified by `VER-P1-SELECTIONS-001`. The applicable selections are recorded as P1-S-01, P1-S-03 to P1-S-15, P1-S-17 and P1-S-18 in §8 of the register; this table references them and does not restate them. The consuming task's check provides the working evidence.

| ID | Selection | Gate | Applicable / NOT APPLICABLE | Consumed by | Working evidence |
| -- | --------- | ---- | --------------------------- | ----------- | ---------------- |
| S-01 | JavaScript package and workspace manager | — | Applicable — recorded as P1-S-01 | 1.5 | `VER-P1-BOOTSTRAP-001` |
| S-02 | Task runner | OD-05 | **NOT APPLICABLE** — no task runner in Phase 1 (P1-OD-05); not a permanent rejection | — | — |
| S-03 | Node.js version | — | Applicable — recorded as P1-S-03 | 1.5 | `VER-P1-BOOTSTRAP-001` |
| S-04 | TypeScript version and compiler baseline | — | Applicable — recorded as P1-S-04 | 1.8, 1.12 | `VER-P1-WEB-SHELL-001`, `VER-P1-TYPECHECK-001` |
| S-05 | Next.js version | — | Applicable — recorded as P1-S-05 | 1.8 | `VER-P1-WEB-SHELL-001` |
| S-06 | TypeScript linting and formatting tools | — | Applicable — recorded as P1-S-06 | 1.10, 1.11 | `VER-P1-LINT-001`, `VER-P1-FORMAT-001` |
| S-07 | TypeScript test runner | — | Applicable — recorded as P1-S-07 | 1.13 | `VER-P1-TEST-001` |
| S-08 | Python version | — | Applicable — recorded as P1-S-08 | 1.5 | `VER-P1-BOOTSTRAP-001` |
| S-09 | Python project and dependency manager | — | Applicable — recorded as P1-S-09 | 1.5 | `VER-P1-BOOTSTRAP-001` |
| S-10 | FastAPI version and ASGI server | — | Applicable — recorded as P1-S-10 | 1.6 | `VER-P1-API-SHELL-001` |
| S-11 | Python linting and formatting tools | — | Applicable — recorded as P1-S-11 | 1.10, 1.11 | `VER-P1-LINT-001`, `VER-P1-FORMAT-001` |
| S-12 | Python type checker | — | Applicable — recorded as P1-S-12 | 1.12 | `VER-P1-TYPECHECK-001` |
| S-13 | Python test runner | — | Applicable — recorded as P1-S-13 | 1.13 | `VER-P1-TEST-001` |
| S-14 | Python import-rule enforcement tool | — | Applicable — recorded as P1-S-14 | 1.7 | `VER-P1-BOUNDARIES-001` |
| S-15 | Frontend dependency-restriction mechanism | — | Applicable — recorded as P1-S-15 | 1.8 | `VER-P1-WEB-SHELL-001` |
| S-16 | OpenAPI-to-TypeScript client generator | OD-04 | **NOT APPLICABLE** — derivation is in P3 (P1-OD-04) | — | — |
| S-17 | Dependency vulnerability scanner | OD-07 | Applicable — scanning in Phase 1 (P1-OD-07); recorded as P1-S-17 | 1.15 | `VER-P1-DEPS-001` (scan part) |
| S-18 | Pre-commit hook set (beyond the retained Gitleaks hook) | — | Applicable — recorded as P1-S-18 | 1.14 | `VER-P1-PRECOMMIT-001` |

#### Implementation

- **Scope:** an options analysis per applicable selection (criteria, candidates, trade-offs, supply-chain considerations), optionally with a [Proposed] recommendation. The owner selects, and the selection is recorded in the decision register.
- **Non-scope:** resolving OD-01; installing or configuring tools; selecting on the owner's behalf; ADRs, unless the owner classifies a selection as consequential.
- **Deliverables:** one owner-decided record per applicable selection (S-01, S-03 to S-15, S-17, S-18).

#### Tests

Each record defines a selection-basis check, which the consuming task executes.

#### Security

Supply-chain considerations are part of every options analysis.

#### Observability

Not applicable — decision records.

#### Documentation

Records in `docs/decisions/decision-register.md`.

#### Acceptance Criteria

P1-AC-001; contributes to P1-AC-002 (P1-OD-05, P1-OD-07 referenced).

#### Verification Evidence

`VER-P1-SELECTIONS-001`. S-02 and S-16 are NOT APPLICABLE, with P1-OD-05 and P1-OD-04 recorded as the reasons. `VER-P1-DECISIONS-001` covers P1-OD-05 and P1-OD-07.
**Exit condition:** every applicable selection is owner-decided and recorded.

---

### Task 1.2

#### Objective

Reference the owner's recorded deferral of the unsettled dependency edges (OD-02) and keep them unenforced in Phase 1.

#### Inputs

- **ID:** 1.2.
- **Dependencies:** none.
- **Decision status:** recorded as P1-OD-02 — `Deferred` (2026-10-05).

#### Implementation

- **Scope:** referencing P1-OD-02 in the Phase 1 evidence. The edges Domains → Platform, API → Platform and API → Domains stay undecided and unenforced. Resolution gate: before the first phase whose implementation depends on them, when the ADR requirement in `docs/decisions/README.md` §2 applies (ADR-0003 reserved).
- **Non-scope:** deciding the edges; drafting an ADR in Phase 1; changing canonical invariants; affecting OD-03, OD-04 or OD-11.
- **Deliverables:** none beyond the recorded deferral.
- **Notes:** task 1.7 enforces only the rules listed under Architectural Constraints.

#### Tests

Not applicable — no ADR is drafted in Phase 1.

#### Security

The analysis considers authorization entry at Application (§7).

#### Observability

Not applicable.

#### Documentation

Deferred Decisions; `docs/decisions/decision-register.md` P1-OD-02.

#### Acceptance Criteria

Contributes to P1-AC-002 (OD-02).

#### Verification Evidence

`VER-P1-DECISIONS-001`.
**Exit condition:** P1-OD-02 is recorded (met).

---

### Task 1.3

#### Objective

Reference two independent recorded owner decisions: when TypeScript client derivation is implemented (OD-04) and whether the frontend consumes the API in Phase 1 (OD-11).

#### Inputs

- **ID:** 1.3.
- **Dependencies:** none.
- **Decision status:** P1-OD-04 — `Decided`: derivation in P3. P1-OD-11 — `Decided`: no frontend API calls in Phase 1. Neither decision implies the other.

#### Implementation

- **Scope:** referencing P1-OD-04 and P1-OD-11 in the Phase 1 evidence. The contract authority itself is accepted and not in question.
- **Non-scope:** selecting a generator (S-16 is NOT APPLICABLE); weakening the contract authority; affecting OD-02 or OD-03.
- **Deliverables:** none beyond the recorded decisions.

#### Tests

Not applicable — decisions.

#### Security

Not applicable.

#### Observability

Not applicable.

#### Documentation

Deferred Decisions.

#### Acceptance Criteria

Contributes to P1-AC-002 (OD-04, OD-11).

#### Verification Evidence

`VER-P1-DECISIONS-001`.
**Exit condition:** P1-OD-04 and P1-OD-11 are recorded (met).

---

### Task 1.4

#### Objective

Reference the owner's recorded deferral of the location of shared TypeScript packages and any generated client (OD-03).

#### Inputs

- **ID:** 1.4.
- **Dependencies:** task 1.3, for the OD-04 outcome only, which determines whether a client slot is needed.
- **Decision status:** recorded as P1-OD-03 — `Deferred` (2026-10-05).

#### Implementation

- **Scope:** referencing P1-OD-03. No shared TypeScript package and no client location in Phase 1; TypeScript configuration stays local to `apps/web`. Resolution gate: when a shared package or client location is first needed, through a governed revision of `system-architecture.md` §2.
- **Non-scope:** creating directories; revising `system-architecture.md` in Phase 1; affecting OD-02, OD-04 or OD-11.
- **Deliverables:** none beyond the recorded deferral.

#### Tests

Not applicable — no revision in Phase 1.

#### Security

Not applicable.

#### Observability

Not applicable.

#### Documentation

Deferred Decisions; `docs/decisions/decision-register.md` P1-OD-03.

#### Acceptance Criteria

Contributes to P1-AC-002 (OD-03).

#### Verification Evidence

`VER-P1-DECISIONS-001`.
**Exit condition:** P1-OD-03 is recorded (met).

---

### Task 1.5

#### Objective

Establish the root workspace with pinned versions, committed lockfiles and a verified clean-clone bootstrap.

#### Inputs

- **ID:** 1.5.
- **Dependencies:** task 1.1 (S-01, S-03, S-08, S-09).
- **Recorded decisions applied:** P1-OD-05 (no task runner; root scripts) and P1-OD-08 (`.gitattributes` extended only for new Phase 1 file types).

#### Implementation

- **Scope:** root manifests and workspace definition; root scripts (no task runner); Node.js and Python version pins; lockfiles; `.gitattributes` entries for the new Phase 1 source and configuration file types only, with no renormalization of Phase 0 artefacts.
- **Non-scope:** application code; containers (P2).
- **Deliverables:** root configuration and a bootstrap procedure.
- **Notes:** existing `.gitignore` entries are kept.

#### Tests

A clean clone into a temporary directory outside the repository installs from the lockfiles.

#### Security

The proposed controls under Security requirements, applied as the selected managers support them.

#### Observability

Not applicable.

#### Documentation

The bootstrap procedure (task 1.18).

#### Acceptance Criteria

P1-AC-003; contributes to P1-AC-002 (P1-OD-05, P1-OD-08 referenced).

#### Verification Evidence

`VER-P1-BOOTSTRAP-001`.
**Exit condition:** the clean-clone bootstrap succeeds.

---

### Task 1.6

#### Objective

Create the FastAPI service shell.

#### Inputs

- **ID:** 1.6.
- **Dependencies:** task 1.5; task 1.1 (S-10).

#### Implementation

- **Scope:** `services/api` with a health endpoint; OpenAPI document generation; environment-based configuration with a non-secret `.env.example`.
- **Non-scope:** business endpoints; persistence (P3); authentication (P4); Redis (P5); background work (P6).
- **Deliverables:** the service skeleton and its tests.

#### Tests

A health endpoint test; an OpenAPI generation test.

#### Security

No secrets. [Proposed — follows `application-architecture.md` §5] Error responses expose no internal details.

#### Observability

[Proposed] Basic diagnostics only: the health endpoint and startup output. No telemetry stack (P7).

#### Documentation

Commands (task 1.18).

#### Acceptance Criteria

P1-AC-004.

#### Verification Evidence

`VER-P1-API-SHELL-001`.
**Exit condition:** the shell runs and its tests pass.

---

### Task 1.7

#### Objective

Create the Python layer package skeletons and enforce the import rules that Phase 1 can enforce.

#### Inputs

- **ID:** 1.7.
- **Dependencies:** task 1.6; task 1.1 (S-14); task 1.2 (determines only whether OD-02 edges are added).

#### Implementation

- **Scope:** `services/application`, the `services/domains` namespace root and `services/sentinel_platform`; an import-rule configuration for the rules listed under Architectural Constraints; final import names.
- **Non-scope:** use cases, domain logic, platform clients; worker and migrations packages; any individual domain package; OD-02 edges before OD-02 is decided.
- **Deliverables:** the skeletons, the configuration and the verification paths.

**Domain isolation:**
- The rule can be violated only when at least two domain packages exist. Phase 1 creates none.
- If S-14 can express the rule generically for any subpackage of the domain namespace, it is configured generically. The negative path then uses a temporary copy of the repository outside the repository, adding two throwaway subpackages clearly marked as fixtures, one importing the other. The check must fail. The copy is deleted; it names no real domain and is never committed. Only the configuration is exercised, not a second architecture.
- If S-14 can enforce the rule only by listing concrete packages, domain-isolation enforcement is [Deferred] to the first phase that creates a second domain package. Phase 1 records this in its evidence and enforces the other rules.

#### Tests

Positive path: the repository passes. Negative path: a violation of each enforced rule is rejected, where technically applicable.

#### Security

Enforcement supports the authorization-entry invariant (§7).

#### Observability

Not applicable.

#### Documentation

A pointer in `.claude/rules/architecture.md` (task 1.18).

#### Acceptance Criteria

P1-AC-005.

#### Verification Evidence

`VER-P1-BOUNDARIES-001`, which reports the enforced rules and whether domain isolation is generic or deferred.
**Exit condition:** every rule enforceable in Phase 1 is enforced and verified.

---

### Task 1.8

#### Objective

Create the Next.js application shell and enforce the frontend dependency restriction.

#### Inputs

- **ID:** 1.8.
- **Dependencies:** task 1.5; task 1.1 (S-04, S-05, S-15).
- **Recorded decision applied:** P1-OD-11 (no frontend API calls in Phase 1).

#### Implementation

- **Scope:** `apps/web` with a minimal page and local TypeScript configuration (P1-OD-03); a deterministic check that `apps/web` declares no prohibited dependency category (database drivers, ORMs, Redis or queue clients, LLM provider SDKs); no API request code.
- **Non-scope:** product features; authentication; data fetching; API calls; any proxy, backend-for-frontend or other new trust boundary.
- **Deliverables:** the application skeleton, its tests and the dependency check.

#### Tests

A render or unit test; a build; a negative path in which a prohibited dependency is rejected.

#### Security

Enforces §6. No credentials.

#### Observability

Not applicable beyond build output.

#### Documentation

Commands (task 1.18).

#### Acceptance Criteria

P1-AC-006, P1-AC-007.

#### Verification Evidence

`VER-P1-WEB-SHELL-001`, `VER-P1-API-CONTRACT-001`.
**Exit condition:** the shell builds, its tests pass and the dependency check passes.

---

### Task 1.9

#### Objective

Shared TypeScript packages and API-client derivation. **NOT APPLICABLE in Phase 1.**

#### Inputs

- **ID:** 1.9 (NOT APPLICABLE).
- **Reason:** P1-OD-03 defers shared-package and client topology, and P1-OD-04 places client derivation in P3.
- **Dependencies:** none in Phase 1.

#### Implementation

- **Scope:** none in Phase 1.
- **Non-scope:** shared packages; client generation; hand-written clients or API contract definitions.
- **Deliverables:** none. The NOT APPLICABLE status and its reason are recorded in the Phase 1 evidence.

#### Tests

Not applicable.

#### Security

Not applicable. The contract authority is enforced in Phase 1 through P1-AC-007 (task 1.8).

#### Observability

Not applicable.

#### Documentation

Deferred Decisions (P1-OD-03, P1-OD-04).

#### Acceptance Criteria

P1-AC-008 — NOT APPLICABLE.

#### Verification Evidence

`VER-P1-API-CLIENT-001` — NOT APPLICABLE, reason P1-OD-04.
**Exit condition:** the NOT APPLICABLE status and its reason are recorded.

---

### Task 1.10

#### Objective

Establish linting for both stacks.

#### Inputs

- **ID:** 1.10.
- **Dependencies:** tasks 1.6, 1.7, 1.8; task 1.1 (S-06, S-11).

#### Implementation

- **Scope:** lint configuration per stack and a root lint command.
- **Non-scope:** CI jobs (task 1.16).
- **Deliverables:** configuration and the command.

#### Tests

The command passes on the repository, and a violation is rejected.

#### Security

[Proposed] Security-relevant rules are enabled where the selected tools provide them.

#### Observability

Not applicable.

#### Documentation

The command row (task 1.18).

#### Acceptance Criteria

P1-AC-009.

#### Verification Evidence

`VER-P1-LINT-001`.
**Exit condition:** lint passes, and violations are rejected.

---

### Task 1.11

#### Objective

Establish formatting checks for both stacks.

#### Inputs

- **ID:** 1.11.
- **Dependencies:** tasks 1.6, 1.7, 1.8; task 1.1 (S-06, S-11).

#### Implementation

- **Scope:** formatter configuration and a root format-check command.
- **Non-scope:** reformatting Phase 0 documents or evidence.
- **Deliverables:** configuration and the command.
- **Notes:** the formatter's scope excludes `docs/phases/evidence/` and the Phase 0 document, so verbatim evidence (including the preserved whitespace lines) is not altered.

#### Tests

The check passes, and a mis-formatted input is rejected.

#### Security

Not applicable.

#### Observability

Not applicable.

#### Documentation

The command row (task 1.18).

#### Acceptance Criteria

P1-AC-010.

#### Verification Evidence

`VER-P1-FORMAT-001`. `VER-P0-FORMAT-001` keeps its Phase 0 semantics.
**Exit condition:** the format check passes, and mis-formatted input is rejected.

---

### Task 1.12

#### Objective

Establish type checking for both stacks.

#### Inputs

- **ID:** 1.12.
- **Dependencies:** tasks 1.6, 1.7, 1.8; task 1.1 (S-04, S-12).

#### Implementation

- **Scope:** type-checker configuration and a root type-check command.
- **Non-scope:** CI jobs.
- **Deliverables:** configuration and the command.

#### Tests

The command passes, and a type error is rejected.

#### Security

Not applicable.

#### Observability

Not applicable.

#### Documentation

The command row (task 1.18).

#### Acceptance Criteria

P1-AC-011.

#### Verification Evidence

`VER-P1-TYPECHECK-001`.
**Exit condition:** the type check passes, and type errors are rejected.

---

### Task 1.13

#### Objective

Establish the test foundation for both stacks.

#### Inputs

- **ID:** 1.13.
- **Dependencies:** tasks 1.6, 1.7, 1.8; task 1.1 (S-07, S-13).

#### Implementation

- **Scope:** test-runner configuration and a root test command running the tests of tasks 1.6–1.8 (task 1.9 is NOT APPLICABLE).
- **Non-scope:** suites for later-phase capabilities.
- **Deliverables:** configuration and the command.

#### Tests

The command passes, and a failing test makes it fail.

#### Security

Not applicable.

#### Observability

Not applicable.

#### Documentation

The command row (task 1.18).

#### Acceptance Criteria

P1-AC-012.

#### Verification Evidence

`VER-P1-TEST-001`.
**Exit condition:** the test command passes, and failing tests fail it.

---

### Task 1.14

#### Objective

Integrate the selected quality hooks into pre-commit while retaining Gitleaks.

#### Inputs

- **ID:** 1.14.
- **Dependencies:** tasks 1.10, 1.11, 1.12; task 1.1 (S-18).

#### Implementation

- **Scope:** `.pre-commit-config.yaml` gains the S-18 hooks. The Gitleaks hook and its version are unchanged.
- **Non-scope:** removing or weakening Gitleaks; any bypass mechanism.
- **Deliverables:** the updated configuration.

#### Tests

`scripts/checks/pre-commit-controls.sh` passes, and a quality violation is rejected at commit.

#### Security

`--no-verify` remains prohibited. Gitleaks remains the secret-detection hook.

#### Observability

Not applicable.

#### Documentation

The developer workflow (task 1.18).

#### Acceptance Criteria

P1-AC-013.

#### Verification Evidence

`VER-P1-PRECOMMIT-001`. The Phase 0 pre-commit checks are covered by `VER-P1-P0-REGRESSION-001`.
**Exit condition:** the hooks run, and the controls pass.

---

### Task 1.15

#### Objective

Establish dependency and supply-chain hygiene for the Phase 1 dependency surface.

#### Inputs

- **ID:** 1.15.
- **Dependencies:** task 1.5; task 1.1 (S-17).
- **Recorded decision applied:** P1-OD-07 (dependency vulnerability scanning in Phase 1).

#### Implementation

- **Scope:** documented dependency acquisition, provenance, integrity and installation controls per the selected managers, with a deterministic lockfile-consistency check, and dependency vulnerability scanning using the selected package-management tooling (P1-OD-07).
- **Non-scope:** the security-hardening programme (P19); permanent architecture rules.
- **Deliverables:** the documented controls and their check.

#### Tests

A missing or inconsistent lockfile is detected; the vulnerability scan runs and its result is reported.

#### Security

This task is itself a security control.

#### Observability

Not applicable.

#### Documentation

The developer workflow (task 1.18).

#### Acceptance Criteria

P1-AC-014.

#### Verification Evidence

`VER-P1-DEPS-001`, including its scan part.
**Exit condition:** the documented controls are verified.

---

### Task 1.16

#### Objective

Run the Phase 1 quality checks (lint, format verification, type checking, tests) in CI.

#### Inputs

- **ID:** 1.16.
- **Dependencies:** tasks 1.10–1.13.
- **Recorded decision applied:** P1-OD-06 (CI quality checks in Phase 1; not required branch-protection status checks).

#### Implementation

- **Scope:** new jobs following the existing workflow pattern. The `Secret scanning` and positive-control jobs, and repository protection, are unchanged.
- **Non-scope:** delivery and deployment (P22); changing required status checks.
- **Deliverables:** the workflow change. The new jobs are not added to the required status checks.

#### Tests

A real CI run passes the new jobs.

#### Security

Read-only permissions; SHA-pinned actions; no secrets.

#### Observability

CI logs.

#### Documentation

The Evidence section.

#### Acceptance Criteria

P1-AC-015; contributes to P1-AC-002 (P1-OD-06 referenced).

#### Verification Evidence

`VER-P1-CI-QUALITY-001`.
**Exit condition:** the jobs pass in a real CI run and repository protection is unchanged.

---

### Task 1.17

#### Objective

Implement the Phase 1 verification checks and establish the Phase 0 regression baseline, without changing Phase 0 verification semantics.

#### Inputs

- **ID:** 1.17.
- **Dependencies:** tasks 1.5–1.16, so that the capabilities to be checked exist.

#### Implementation

**Scope:** `scripts/verify-phase.sh` accepts `phase-1` and implements the Phase 1 deterministic checks only:
- `VER-P1-BOOTSTRAP-001`, `VER-P1-API-SHELL-001`, `VER-P1-BOUNDARIES-001`, `VER-P1-WEB-SHELL-001`, `VER-P1-API-CONTRACT-001`; `VER-P1-API-CLIENT-001` is reported NOT APPLICABLE (P1-OD-04);
- `VER-P1-LINT-001`, `VER-P1-FORMAT-001`, `VER-P1-TYPECHECK-001`, `VER-P1-TEST-001`, `VER-P1-PRECOMMIT-001`, `VER-P1-DEPS-001`;
- `VER-P1-SCOPE-001`, `VER-P1-DOCS-001`, `VER-P1-P0-REGRESSION-001`;
- the script part of `VER-P1-GIT-SAFETY-001`;
- `VER-P1-LIFECYCLE-001`.

The checks evaluated by orchestration, not by the script, are `VER-P1-SELECTIONS-001`, `VER-P1-DECISIONS-001`, `VER-P1-REVIEW-L1`, `VER-P1-REVIEW-L2-RUNTIME-<agent>`, `VER-P1-CI-EXEC-001` and `VER-P1-CI-QUALITY-001`.

**Phase 0 regression baseline:**
1. Before any change to verification tooling, run `scripts/verify-phase.sh phase-0` against the state that contains this document and no Phase 1 implementation. Keep the result outside the repository as the reference: 23 check IDs, results and process actions.
2. Record which detail texts legitimately vary, for example the phase-document count, which is 2 once this document exists.
3. After every Phase 1 change, rerun `phase-0`. IDs, results and process actions must be identical to the reference; only the detail differences recorded in step 2 are permitted.
4. The Phase 0 completion state remains reproducible: `phase-0` run against a checkout of `beac056cf65dd151a6a3f0c3e35ec5b98fdae730` reproduces the recorded Phase 0 result.

**`VER-P1-API-CONTRACT-001` (detection method):** a static, deterministic check.
- **Inputs:** every Git-tracked file under `apps/web/` (`git ls-files apps/web`), so untracked build output and `node_modules` are excluded by construction; and the `paths` keys of the OpenAPI document generated by the FastAPI shell (task 1.6) in a temporary location outside the repository.
- **FAIL if any of these is found** (each detection reported with file and line):
  - (a) request primitives in `.ts`, `.tsx`, `.js`, `.jsx`, `.mjs` or `.cjs` files: `fetch(`, `XMLHttpRequest`, `WebSocket(`, `EventSource(`, `sendBeacon(`, or an import or require of an HTTP client package from a fixed list in the verifier (`axios`, `ky`, `got`, `superagent`, `ofetch`, `node-fetch`, `undici`, `cross-fetch`);
  - (b) server-side request or proxy surfaces: any `pages/api/` path; any `route.ts`, `route.tsx`, `route.js` or `route.mjs` under an `app/` directory; a `"use server"` directive; a `rewrites` key in `next.config.*`;
  - (c) an independently defined contract: a tracked file named `openapi.*` or `*.openapi.*`; a JSON or YAML file with a top-level `openapi` or `swagger` key; any string literal equal to, or beginning with, a path in the FastAPI OpenAPI `paths` set.
- **PASS** when none is found.
- **Negative paths:** one injected violation each for (a), (b) and (c), in temporary copies outside the repository; each must FAIL.
- **Strictness:** in Phase 1 any request primitive fails the check (P1-OD-11). A later phase that introduces API consumption revises the check in its own phase document.

**`VER-P1-SCOPE-001`:**
- checks dependency declarations (manifests and lockfiles) for prohibited later-phase categories: database drivers, ORMs, migration tools, Redis or queue clients, LLM or embedding SDKs, browser-automation tools, cloud SDKs;
- checks physical paths for prohibited directories: worker, migrations, any individual domain package, infrastructure or deployment directories;
- does not inspect prose, so documentation references to future capabilities never make it fail.

**Non-scope:**
- any change to `VER-P0-*` semantics, including making Phase 0 checks ignore Phase 1 documents; that requires separate analysis and owner authorization;
- generalized machinery for P2–P24;
- changes to the reviewer contract;
- writing into the repository during verification.

**Deliverables:** the verifier changes and their verification paths.

**Notes:**
- a set of checks permitted to be BLOCKED at transition may be proposed with this task, for owner approval; no default is proposed;
- deferred family F21 regression-guard improvements are not required.

#### Tests

Positive and negative paths for each new check, where technically applicable; the Phase 0 regression comparison.

#### Security

The verifier never writes into the repository, and git safety is retained.

#### Observability

Not applicable.

#### Documentation

The verification commands (task 1.18).

#### Acceptance Criteria

P1-AC-016, P1-AC-017. It also implements the deterministic checks of P1-AC-003 to P1-AC-014, P1-AC-018, P1-AC-019 and P1-AC-023, which are executed in task 1.19.

#### Verification Evidence

`VER-P1-P0-REGRESSION-001`, `VER-P1-SCOPE-001`.
**Exit condition:** the Phase 1 checks run deterministically, and the Phase 0 comparison is identical.

---

### Task 1.18

#### Objective

Align developer documentation and Claude Code context with the implemented foundation.

#### Inputs

- **ID:** 1.18.
- **Dependencies:** tasks 1.5–1.17.

#### Implementation

- **Scope:**
  - `docs/operations/developer-workflow.md`: commands, bootstrap and dependency controls;
  - `CLAUDE.md`: structure, commands and stale Phase 0 framing;
  - `README.md`: navigation and the stale phase statement;
  - `.claude/rules/architecture.md`: a pointer to the import-rule configuration.
- **Non-scope:** Accepted documents; reviewer agents; hooks and permissions, unless a concrete need is found and owner-approved.
- **Deliverables:** the updated documents.

#### Tests

`VER-P0-CLAUDE-001` still passes. Every documented command exists and runs.

#### Security

Guardrails unchanged.

#### Observability

Not applicable.

#### Documentation

This task is documentation.

#### Acceptance Criteria

P1-AC-018.

#### Verification Evidence

`VER-P1-DOCS-001`.
**Exit condition:** the documentation matches the repository.

---

### Task 1.19

#### Objective

Coordinate Phase 1 verification and completion. This orchestration task implements no engineering capability: every capability and every check it runs is delivered by tasks 1.1–1.18.

#### Inputs

- **ID:** 1.19 (orchestration).
- **Dependencies:** tasks 1.1–1.18.
- **Recorded decision applied:** P1-OD-10 (Phase 0 evidence-publication stopping rule, stated explicitly before Phase 1 evidence publication begins).

#### Implementation

- **Scope:** activities 1.19-A to 1.19-F below, each independently verifiable.

**Independently verifiable activities:**

| Activity | Content | Output |
| -------- | ------- | ------ |
| 1.19-A Verification execution | Deterministic `VER-P1-*` checks and the Phase 0 regression comparison, under the `phase-verification` Skill, with baseline and S2 snapshots; evaluation of the decision records (`VER-P1-DECISIONS-001`) and the selection records (`VER-P1-SELECTIONS-001`) | Verification record entries |
| 1.19-B Review execution | Layer 1 review, contradiction review, five Layer 2 reviews | Review records |
| 1.19-C CI observation | Inherited security CI and the Phase 1 quality jobs (P1-OD-06) on the Phase 1 commits | CI evidence |
| 1.19-D Final Verification | Records the verification basis and its confirmation | Final Verification section |
| 1.19-E Completion Decision | The Project Owner's decision, with a disposition for every review finding | Completion Decision section |
| 1.19-F Evidence and lifecycle recording | Append-only evidence under the P1-OD-10 stopping rule; Status History transitions authorized by the owner | Evidence records; Status History |

- **Non-scope:** implementing or repairing capabilities (any defect returns to its owning task); completing the phase without the owner's decision.
- **Deliverables:** the `docs/phases/evidence/phase-1/` records and this document's Completion Record.
- **Notes ([Proposed] verification rules derived from Phase 0 practice; each requires owner acceptance before use and is not authoritative until then):**
  - a reviewer finding that requires an owner decision is a STOP, and a STOP is a FAIL;
  - a failed verification is recorded as a lifecycle transition when it occurs;
  - edits made after a run's baseline are confirmed against a new post-recording baseline;
  - evidence is append-only;
  - Layer 1 and the contradiction review run in every run;
  - quoted reviewer text is not a phase-status assertion.

#### Tests

The checks and reviews named above.

#### Security

`VER-P1-CI-EXEC-001`.

#### Observability

Not applicable.

#### Documentation

The evidence records; the Completion Record.

#### Acceptance Criteria

P1-AC-002 (evaluated in 1.19-A; P1-OD-10 referenced), P1-AC-019 to P1-AC-023.

#### Verification Evidence

The Phase 1 verification record.
**Exit condition:** the Exit Criteria hold and the owner's completion decision is recorded.

## Phase-Level Acceptance Criteria

[Proposed] None of these checks exists yet, and no result has been recorded.

**How each criterion is evaluated:**
- P1-AC-001, 002, 020 and 021 are evaluated by orchestration (decision and review records).
- P1-AC-015 and 022 are evaluated by CI observation.
- All others are deterministic checks implemented in task 1.17 and executed in task 1.19.

| ID | Criterion | Verification | Owning task | NOT APPLICABLE when |
| -- | --------- | ------------ | ----------- | ------------------- |
| P1-AC-001 | Each applicable selection (S-01, S-03 to S-15, S-17, S-18) has an owner-decided record in `docs/decisions/decision-register.md` | `VER-P1-SELECTIONS-001` | 1.1 | Per selection: S-02 (P1-OD-05) and S-16 (P1-OD-04) |
| P1-AC-002 | P1-OD-01 to P1-OD-12 are recorded in `docs/decisions/decision-register.md` §6 with their decision state (pre-entry OD-01 and OD-09 `Decided`; OD-02 and OD-03 `Deferred`; the others `Decided`), and P1-ED-01 to P1-ED-03 in §7 | `VER-P1-DECISIONS-001` | 1.19 (1.19-A evaluates) | — |
| P1-AC-003 | A clean clone installs from committed lockfiles with pinned tool versions | `VER-P1-BOOTSTRAP-001` | 1.5 | — |
| P1-AC-004 | The FastAPI shell's health and OpenAPI-generation tests pass | `VER-P1-API-SHELL-001` | 1.6 | — |
| P1-AC-005 | Each enforced import rule rejects its violation and the repository passes; domain isolation is reported as generic or deferred | `VER-P1-BOUNDARIES-001` | 1.7 | — |
| P1-AC-006 | The Next.js shell builds, its tests pass, and the prohibited-dependency check passes and rejects a violation | `VER-P1-WEB-SHELL-001` | 1.8 | — |
| P1-AC-007 | `apps/web` contains no API request code and no independently defined API contract (detection method in task 1.17) | `VER-P1-API-CONTRACT-001` | 1.8 | Never |
| P1-AC-008 | The derived TypeScript client matches the current OpenAPI document | `VER-P1-API-CLIENT-001` | 1.9 | **NOT APPLICABLE in Phase 1**: derivation is in P3 (P1-OD-04). P1-AC-007 stays in force |
| P1-AC-009 | Lint passes for both stacks, and violations are rejected | `VER-P1-LINT-001` | 1.10 | — |
| P1-AC-010 | The format check passes for both stacks, and mis-formatted input is rejected | `VER-P1-FORMAT-001` | 1.11 | — |
| P1-AC-011 | The type check passes for both stacks, and type errors are rejected | `VER-P1-TYPECHECK-001` | 1.12 | — |
| P1-AC-012 | Tests pass for both stacks, and a failing test fails the command | `VER-P1-TEST-001` | 1.13 | — |
| P1-AC-013 | Pre-commit runs Gitleaks and the S-18 hooks; the pre-commit controls pass | `VER-P1-PRECOMMIT-001` | 1.14 | — |
| P1-AC-014 | The documented dependency controls are verified, and the dependency vulnerability scan passes (P1-OD-07) | `VER-P1-DEPS-001` | 1.15 | — |
| P1-AC-015 | The Phase 1 CI quality jobs pass in a real CI run, and they are not required status checks (P1-OD-06) | `VER-P1-CI-QUALITY-001` | 1.16 | — |
| P1-AC-016 | `phase-0` verification yields check IDs, results and process actions identical to the reference baseline; the Phase 0 completion result is reproducible at its commit | `VER-P1-P0-REGRESSION-001` | 1.17 | — |
| P1-AC-017 | No prohibited later-phase dependency category is declared and no prohibited physical directory or package exists; prose is not inspected | `VER-P1-SCOPE-001` | 1.17 | — |
| P1-AC-018 | Developer documentation lists only existing, verified commands; `CLAUDE.md` passes its required-section check | `VER-P1-DOCS-001` | 1.18 | — |
| P1-AC-019 | During each verification run, commit count and remotes are unchanged and only read-only Git commands run | `VER-P1-GIT-SAFETY-001` | 1.19 (implemented in 1.17) | — |
| P1-AC-020 | The Layer 1 review and the contradiction review are performed and recorded with all required fields | `VER-P1-REVIEW-L1` | 1.19 | — |
| P1-AC-021 | Each Layer 2 reviewer ran read-only with exactly `Read, Grep, Glob` and identical before and after snapshots, and its record is complete | `VER-P1-REVIEW-L2-RUNTIME-<agent>` | 1.19 | — |
| P1-AC-022 | The inherited security CI (`Secret scanning` and its positive control) passes on the Phase 1 commits in a real CI run | `VER-P1-CI-EXEC-001` | 1.19 | — |
| P1-AC-023 | The phase status equals the latest Status History row, and every transition is permitted | `VER-P1-LIFECYCLE-001` | 1.19 (implemented in 1.17) | — |

## Exit Criteria

### Transition to Verification

[Proposed; follows `docs/phases/README.md` §11a] Phase 1 may move from `In Progress` to `Verification` only when:
1. every applicable `VER-P1-*` check has executed with `PASS`;
2. no check has `FAIL`;
3. every `BLOCKED` check is in an owner-approved permitted set (task 1.17); none is permitted unless the owner approves it;
4. every `NOT APPLICABLE` check records its reason;
5. `VER-P1-REVIEW-L1` is `PASS`, and every `VER-P1-REVIEW-L2-RUNTIME-<agent>` is `PASS`;
6. no process action `STOP` occurred.

### Transition to Complete

[Proposed] Phase 1 may become `Complete` only after:
- all Transition to Verification conditions hold;
- `VER-P1-CI-EXEC-001` is `PASS`;
- `VER-P1-CI-QUALITY-001` is `PASS` (P1-OD-06);
- P1-AC-002 holds (`VER-P1-DECISIONS-001` `PASS`): P1-OD-01 to P1-OD-12 and P1-ED-01 to P1-ED-03 recorded;
- the Phase 1 ADR gate is satisfied;
- the Final Verification is recorded;
- the Project Owner's completion decision is recorded, with a disposition for every review finding.

### CI in Phase 1

| What | Status |
| ---- | ------ |
| Existing security CI (`Secret scanning` and its positive control) | [Constraint] Inherited from Phase 0; mandatory; unchanged. [Proposed] Its result on the Phase 1 commits is completion evidence (`VER-P1-CI-EXEC-001`) |
| Phase 1 quality jobs in CI | [Owner decision, decided — P1-OD-06] Run in Phase 1; not required branch-protection status checks |
| Repository protection on `Secret scanning` | [Constraint] Unchanged |

## Risks

### Toolchain choices hardening into architecture

Mitigation: selections are owner decisions recorded in the decision register (P1-OD-01). An ADR is used where the owner classifies a choice as consequential.

### Speculative structure

Mitigation: only the paths under Repository structure (1) are created. `VER-P1-SCOPE-001` checks dependencies and physical paths.

### Enforcement beyond accepted architecture

Mitigation: task 1.7 enforces only the listed rules. The OD-02 edges stay deferred and unenforced (P1-OD-02).

### Phase 0 verification regression

Mitigation: task 1.17's reference baseline and `VER-P1-P0-REGRESSION-001`. This document keeps the `## Status` and Status History form that the Phase 0 lifecycle checks read.

### Evidence-recording recursion

Mitigation: the Phase 0 stopping rule (P1-OD-10), stated before Phase 1 evidence publication begins.

## Known Limitations

- Toolchain selections are recorded (`docs/decisions/decision-register.md` §8); their working evidence is pending the consuming tasks' checks.
- The OD-02 edges are undefined and deferred (P1-OD-02; deferred family F10).
- `system-architecture.md` §2 has no slot for shared TypeScript packages or a generated client; this is deferred (P1-OD-03).
- Domain-isolation enforcement depends on the capability of the tool selected under S-14 (P1-S-14; task 1.7).
- The verifier supports only `phase-0` until task 1.17.
- `README.md` and `CLAUDE.md` describe the project as in Phase 0 until task 1.18.

## Deferred Decisions

DEF-001 to DEF-011 remain recorded in `docs/decisions/decision-register.md`. None is decided or implemented in Phase 1.

Phase 1 owner decisions and deferrals. All are recorded by the Project Owner in `docs/decisions/decision-register.md` §6. This table summarizes them; the register is the record. No decision is resolved, reinterpreted or added here.

| ID | Stage | Register entry | Decision state | Decision date | Recorded outcome | Effect in this document |
| -- | ----- | -------------- | -------------- | ------------- | ---------------- | ----------------------- |
| OD-01 | Pre-entry | P1-OD-01 | Decided | 2026-10-05 | The decision register is the recording mechanism for Phase 1 selections and owner decisions and deferrals | Task 1.1 records selections there |
| OD-02 | Execution | P1-OD-02 | Deferred | 2026-10-05 | Domains → Platform, API → Platform and API → Domains not decided and not enforced in Phase 1; resolve before the first phase whose implementation depends on them (ADR requirement then applies) | Task 1.7 enforces only the listed rules |
| OD-03 | Execution | P1-OD-03 | Deferred | 2026-10-05 | No shared TypeScript package or client location in Phase 1; configuration local to `apps/web` | Task 1.9 NOT APPLICABLE |
| OD-04 | Execution | P1-OD-04 | Decided | 2026-10-05 | Client derivation in P3; FastAPI/OpenAPI remains the contract authority | S-16, task 1.9 and P1-AC-008 NOT APPLICABLE |
| OD-05 | Execution | P1-OD-05 | Decided | 2026-10-05 | No task runner in Phase 1; root scripts; not a permanent rejection | S-02 NOT APPLICABLE |
| OD-06 | Execution | P1-OD-06 | Decided | 2026-10-05 | Lint, format verification, type checking and tests run in CI in Phase 1; not required status checks | Task 1.16 and P1-AC-015 applicable |
| OD-07 | Execution | P1-OD-07 | Decided | 2026-10-05 | Dependency vulnerability scanning in Phase 1; P19 keeps broader hardening | S-17 and P1-AC-014 scan part applicable |
| OD-08 | Execution | P1-OD-08 | Decided | 2026-10-05 | `.gitattributes` extended only for new Phase 1 file types; Phase 0 artefacts not renormalized | Task 1.5 scope |
| OD-09 | Pre-entry | P1-OD-09 | Decided | 2026-10-05 | No separate content acceptance; the owner's explicit approval of the planning baseline is the basis for entry to `In Progress` | Status; entry to `In Progress` |
| OD-10 | Execution | P1-OD-10 | Decided | 2026-10-05 | The Phase 0 evidence-publication stopping rule is adopted and stated before Phase 1 evidence publication begins | Task 1.19 (1.19-C, 1.19-F) |
| OD-11 | Execution | P1-OD-11 | Decided | 2026-10-05 | No frontend API calls in Phase 1; no proxy, backend-for-frontend or new trust boundary | Task 1.8; P1-AC-007 |
| — | Execution | P1-OD-12 | Decided | 2026-10-08 | Dependency vulnerability scanning (P1-S-17) is executed under task 1.15, not in the Phase 1 CI quality jobs; later-phase CI scanning not decided | Task 1.16 scope unchanged; S-17 consumed by task 1.15 only |

Enforcement dispositions P1-ED-01 to P1-ED-03 are recorded in the register's §7 (see Architectural Constraints).

Every decision is verified through P1-AC-002 (`VER-P1-DECISIONS-001`).

## ADRs

The ADR index is `docs/decisions/README.md`.

[Proposed; follows canonical specification §29 and `docs/phases/README.md` §21] Phase 1 ADR gate:
- Any new consequential architectural decision introduced during Phase 1 must have an `Accepted` ADR before Phase 1 can become `Complete`.
- OD-02 is deferred (P1-OD-02); when it is later decided, the ADR requirement applies (ADR-0003 reserved). Any selection the owner classifies as consequential also needs an ADR. This document classifies none.
- A `Proposed` ADR is not an accepted decision, and implementation must not treat it as one.

## Evidence

Phase 1 evidence is recorded in `docs/phases/evidence/phase-1/` (location declared in `docs/phases/README.md` §25a), created at the first verification run:
- `verification-record.md`: deterministic `VER-P1-*` results, the Phase 0 regression comparison, orchestration attestations, CI evidence, the Final Verification and the Completion Decision record;
- `engineering-review.md`: Layer 1;
- `contradiction-review.md`: the contradiction review;
- `independent-review.md`: Layer 2.

Evidence records use `Pending` / `Recorded` / `Superseded`, are append-only, and never state the phase status. No `VER-P1-*` result exists until task 1.17 implements the checks and task 1.19 executes them.

No commit may occur in the real repository during a verification run (`docs/phases/README.md` §25a).

## Completion Record

### Status History

| Date       | Previous Status | New Status  | Reason                                                                                                                                            | Evidence      |
| ---------- | --------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| 2026-10-06 | —               | Not Started | Phase document created as a proposed planning baseline. This row records the phase's initial state; it is not a transition into `In Progress` | This document |
| 2026-10-06 | Not Started     | In Progress | Owner-authorized lifecycle transition (Project Owner, 2026-10-06) following the implementation-gate review at `86c03c66eff2af3c597e52e6d174862862b91dec` (decision: READY FOR PHASE 1 TRANSITION). Phase 0 is `Complete`. The Phase 1 pre-entry decisions were recorded before entering the phase: P1-OD-01 to P1-OD-11 and P1-ED-01 to P1-ED-03 (`4a8fd60`); toolchain selections P1-S-01, P1-S-03 to P1-S-15, P1-S-17 and P1-S-18 (`68474a3`); and their selection-criteria and supply-chain amendment (F-1, `86c03c6`). Transition basis under P1-OD-09: the Project Owner's approval of the planning baseline. Phase 1 work begins | `docs/decisions/decision-register.md` §6–§9; Project Owner authorization of 2026-10-06 |

Status history is append-only.

### Final Verification

To be completed when Phase 1 enters `Verification`. Results will be recorded in `docs/phases/evidence/phase-1/verification-record.md`.

### Completion Decision

To be completed only after successful verification.

```text
Decision: Pending
Decision authority: Project Owner
Verified By: Pending
Verification Date: Pending
Evidence: Pending
```
