# Phase 0 — Product & Secure Engineering Foundation

**File:** `docs/phases/phase-0-product-and-secure-engineering-foundation.md`

## Status

`Verification`

## Objective

Establish the authoritative product, architecture, engineering-governance, Claude Code, documentation, and baseline security foundations required before application implementation begins.

No application capability implementation is performed in this phase.

## Why This Phase Exists

Without an explicit foundation, implementation can create:

- conflicting requirements;
- architecture drift;
- undocumented decisions;
- inconsistent Claude Code behaviour;
- insecure repository practices;
- unclear completion criteria;
- duplicated documentation authority.

Phase 0 establishes the controls that later phases execute against.

## Scope

This phase establishes:

- product scope, requirements, user stories, acceptance criteria, and roadmap;
- architecture context and architecture authority documents;
- canonical specification, ADR, phase, and documentation governance;
- status and acceptance models;
- Claude Code configuration;
- security documentation;
- pre-commit, Gitleaks, and independent CI secret-scanning baselines;
- developer workflow;
- verification procedures;
- contradiction review.

## Out of Scope

This phase does not implement:

- application APIs;
- database schemas;
- authentication;
- Redis;
- background jobs;
- accessibility scanning;
- AI provider integrations;
- RAG;
- browser audit infrastructure;
- cloud deployment;
- the package manager, formatter, linter, test runner, or type checker (Phase 1).

## Dependencies

None.

Phase 0 is the governance root of the project.

## Architectural Constraints

Phase 0 complies with the current Accepted Canonical Engineering Specification, resolved through `docs/architecture/canonical-specification/README.md`.

The cross-cutting invariants are defined by that specification and are not restated here.

## Deliverables

### Task 0.1

#### Objective

Define product scope.

#### Inputs

Existing Sentinel AI product direction; current canonical specification.

#### Implementation

`docs/product/product-scope.md`

#### Tests

Review scope against the roadmap and canonical specification.

#### Security

Security-sensitive product boundaries are explicit (non-goals include autonomous production deployment and LLM-only authority).

#### Observability

Not applicable — documentation-only task.

#### Documentation

Cross-references the canonical specification and roadmap.

#### Acceptance Criteria

P0-AC-001 (file exists). Content is assessed by the review layers (P0-AC-024, P0-AC-025).

#### Verification Evidence

`VER-P0-DOCS-001`, `VER-P0-REVIEW-L1`, `VER-P0-REVIEW-L2-RUNTIME-*` in the Phase 0 verification record.

---

### Task 0.2

#### Objective

Define testable product requirements.

#### Inputs

Product scope.

#### Implementation

`docs/product/requirements.md`, with stable identifiers and observable wording.

#### Tests

Ambiguity and contradiction review.

#### Security

Security and AI trust requirements are represented (REQ-PLATFORM-001, -005, -006).

#### Observability

Observability requirements are represented (REQ-PLATFORM-004).

#### Documentation

Requirements are traced from user stories and acceptance criteria by identifier.

#### Acceptance Criteria

P0-AC-001. Requirement quality is assessed by the review layers.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.3

#### Objective

Define user workflows.

#### Inputs

Product scope; requirements.

#### Implementation

`docs/product/user-stories.md`, each story listing the requirements it traces to.

#### Tests

Story-to-requirement review.

#### Security

Authorization and human-approval stories are included where relevant.

#### Observability

Not applicable — documentation-only task.

#### Documentation

Stories link to requirements by identifier. Known trace gaps are recorded in the stories document.

#### Acceptance Criteria

P0-AC-001. Trace completeness is assessed by the review layers.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.4

#### Objective

Define product-level acceptance criteria.

#### Inputs

Requirements; user stories.

#### Implementation

`docs/product/acceptance-criteria.md`, each criterion referencing requirement and story identifiers, with a coverage table.

#### Tests

Every criterion is observable and testable.

#### Security

Security criteria are represented (AC-PLATFORM-001).

#### Observability

Failure-diagnosis criteria are represented (AC-PLATFORM-003).

#### Documentation

Traceability chain: US → REQ → AC → Phase Task → Evidence.

#### Acceptance Criteria

P0-AC-001. Objectivity of wording is assessed by the review layers.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.5

#### Objective

Establish the project roadmap.

#### Inputs

Canonical specification phase list.

#### Implementation

`docs/product/roadmap.md`

#### Tests

Phase names and sequence are consistent with phase governance.

#### Security

Not applicable — planning document.

#### Observability

Not applicable — planning document.

#### Documentation

The roadmap does not duplicate detailed phase tasks. Duplication of the roadmap inside the canonical specification is a recorded deferred improvement (`docs/decisions/decision-register.md`, DGI-001).

#### Acceptance Criteria

P0-AC-001.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.6

#### Objective

Establish architecture authority documents.

#### Inputs

Current canonical specification.

#### Implementation

- `docs/architecture/context.md`
- `docs/architecture/system-architecture.md`
- `docs/architecture/application-architecture.md`
- `docs/architecture/data-architecture.md`
- `docs/architecture/ai-architecture.md`
- `docs/architecture/security-architecture.md`

#### Tests

Architecture contradiction review.

#### Security

`security-architecture.md` defines the single layered security model.

#### Observability

Not applicable — documentation-only task.

#### Documentation

The documents agree on system, layer, data, AI trust, security, worker, and API boundaries.

#### Acceptance Criteria

P0-AC-001. Agreement is assessed by the review layers.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.7

#### Objective

Establish canonical specification governance.

#### Inputs

Canonical specification v0.3; knowledge of earlier versions v0.1 and v0.2.

#### Implementation

- `docs/architecture/canonical-specification/README.md`
- `canonical-specification-v0.3.md` (Accepted)
- `canonical-specification-v0.1.md` and `canonical-specification-v0.2.md` as status-only `Historical` records, because their original sources are unavailable. No historical content is reconstructed.

#### Tests

Exactly one Accepted version exists and it is backed by the acceptance register.

#### Security

Not applicable — governance document.

#### Observability

Not applicable — governance document.

#### Documentation

The version change process and status-only record rules are explicit.

#### Acceptance Criteria

P0-AC-002, P0-AC-009.

#### Verification Evidence

`VER-P0-STATUS-DOC-001`, `VER-P0-VERSIONREF-001`.

---

### Task 0.8

#### Objective

Establish ADR governance.

#### Inputs

Canonical specification ADR rules.

#### Implementation

`docs/decisions/README.md`, which is the sole ADR index. ADR files live under `docs/decisions/adr/`; the directory is created with the first actual Proposed ADR. ADR decision acceptance is recorded in the ADR, not the acceptance register.

#### Tests

ADR statuses, consequential-decision criteria, human decision authority, and the canonical relationship are defined.

#### Security

Not applicable — governance document.

#### Observability

Not applicable — governance document.

#### Documentation

Index entries without files are marked "Not yet written".

#### Acceptance Criteria

P0-AC-003, P0-AC-007.

#### Verification Evidence

`VER-P0-STATUS-ADR-001`, `VER-P0-ACCEPT-001`.

---

### Task 0.9

#### Objective

Establish phase governance.

#### Inputs

Canonical specification phase lifecycle.

#### Implementation

`docs/phases/README.md`: statuses, transition table, dependency semantics, template, completion requirements, evidence location.

#### Tests

Phase documents conform to the template and lifecycle.

#### Security

Not applicable — governance document.

#### Observability

Not applicable — governance document.

#### Documentation

Evidence location is declared in `docs/phases/README.md` §25a.

#### Acceptance Criteria

P0-AC-004, P0-AC-006, P0-AC-008.

#### Verification Evidence

`VER-P0-STATUS-PHASE-001`, `VER-P0-LIFECYCLE-001`, `VER-P0-TEMPLATE-001`.

---

### Task 0.10

#### Objective

Establish documentation ownership, status models, and the acceptance model.

#### Inputs

All authority documents.

#### Implementation

- `docs/architecture/documentation-authority.md` (authority table, status models §22, acceptance model §23)
- `docs/architecture/acceptance-register.md`

#### Tests

Every major documentation category has one authoritative owner. Every `Accepted` claim is backed by the register.

#### Security

Acceptance is never inferred from implementation, review, or document existence.

#### Observability

Not applicable — governance document.

#### Documentation

Status models are subject-specific.

#### Acceptance Criteria

P0-AC-002, P0-AC-007.

#### Verification Evidence

`VER-P0-STATUS-DOC-001`, `VER-P0-ACCEPT-001`.

---

### Task 0.11

#### Objective

Establish root Claude Code context.

#### Inputs

Authority documents.

#### Implementation

Root `CLAUDE.md` containing project purpose, repository structure, authoritative documentation index, essential commands, critical invariants, and verification expectations. Detailed procedures are referenced, not copied.

#### Tests

Line count, required sections, and absence of a hard-coded canonical version.

#### Security

No secrets or sensitive credentials.

#### Observability

Not applicable — configuration document.

#### Documentation

References Rules, Skills, and authority documents.

#### Acceptance Criteria

P0-AC-010.

#### Verification Evidence

`VER-P0-CLAUDE-001`.

---

### Task 0.12

#### Objective

Establish Claude Code Rules.

#### Inputs

Authority documents.

#### Implementation

`.claude/rules/`. Repository-wide invariants are unscoped; documentation constraints are path-scoped with `paths:`.

#### Tests

Rules reference authority rather than redefining it.

#### Security

`.claude/rules/security.md` references the security procedures.

#### Observability

Not applicable — configuration.

#### Documentation

Rules cite canonical sections and authority documents.

#### Acceptance Criteria

P0-AC-009. Constraint orientation is assessed by the review layers.

#### Verification Evidence

`VER-P0-VERSIONREF-001`, review records.

---

### Task 0.13

#### Objective

Establish Claude Code Skills.

#### Inputs

Phase governance; documentation authority.

#### Implementation

`.claude/skills/{phase-verification,architecture-review,documentation-review,adr,commit}/SKILL.md`, each with purpose, invocation, inputs, authority sources, procedure, constraints, verification, stopping conditions, and output. `adr` and `commit` are user-invoked only.

#### Tests

Frontmatter and required sections are present.

#### Security

Skills do not bypass deterministic verification or security controls.

#### Observability

Not applicable — configuration.

#### Documentation

Skills orchestrate scripts and do not restate their assertions. Side-effecting Skills declare `disable-model-invocation: true`.

#### Acceptance Criteria

P0-AC-011.

#### Verification Evidence

`VER-P0-SKILLS-001`.

---

### Task 0.14

#### Objective

Establish specialist reviewer agents.

#### Inputs

Phase governance §26 (verification independence).

#### Implementation

`.claude/agents/{architecture,security,ai-engineering,verification,documentation}-reviewer.md`, each read-only with `tools: Read, Grep, Glob`.

#### Tests

Tool surface, disallowed tools, and required sections.

#### Security

Reviewers have no mutation capability; Claude Code configuration is the enforcement mechanism.

#### Observability

Not applicable — configuration.

#### Documentation

Each agent states role, scope, and read-only constraints.

#### Acceptance Criteria

P0-AC-012.

#### Verification Evidence

`VER-P0-AGENTS-CONFIG-001`.

---

### Task 0.15

#### Objective

Establish deterministic Claude Code guardrails.

#### Inputs

Security architecture §6; Claude Code hooks and permissions documentation.

#### Implementation

- `.claude/settings.json`: permission deny rules and a PreToolUse hook for `Bash` and `PowerShell`.
- `.claude/hooks/block-dangerous-command.sh`: bounded destructive-command patterns; fails closed on unreadable input.
- No Stop hook. Phase verification is invoked explicitly through the `phase-verification` Skill.

#### Tests

`scripts/checks/claude-guardrails.sh` (fixture-driven).

#### Security

Guardrails are layer 1 of the layered model and are not a security boundary.

#### Observability

Not applicable — configuration.

#### Documentation

Security architecture §6 describes the layer.

#### Acceptance Criteria

P0-AC-013.

#### Verification Evidence

`VER-P0-HOOKS-001`.

---

### Task 0.16

#### Objective

Define the Claude Code engineering prompt standard.

#### Inputs

Documentation authority §8.

#### Implementation

`docs/operations/claude-code-prompt-standard.md`

#### Tests

Required structure is present.

#### Security

Not applicable — documentation.

#### Observability

Not applicable — documentation.

#### Documentation

Distinguishes facts, assumptions, proposals, decisions, and open questions.

#### Acceptance Criteria

P0-AC-001.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.17

#### Objective

Establish baseline security documentation.

#### Inputs

Security architecture.

#### Implementation

- `docs/security/security-baseline.md`
- `docs/security/secret-incident-response.md` (single incident procedure)
- Layered security model in `docs/architecture/security-architecture.md` §6

#### Tests

No duplicated incident procedure exists outside `docs/security/secret-incident-response.md`.

#### Security

Repository protection is documented as a separate layer from CI scanning.

#### Observability

Not applicable — documentation.

#### Documentation

Other documents reference the procedure and the model.

#### Acceptance Criteria

P0-AC-001, P0-AC-022.

#### Verification Evidence

`VER-P0-DOCS-001`, `VER-P0-REPO-PROTECTION`, review records.

---

### Task 0.18

#### Objective

Establish the pre-commit baseline.

#### Inputs

Decision register DR-P0-002.

#### Implementation

`.pre-commit-config.yaml` with the selected, pinned hook set.

#### Tests

`scripts/checks/pre-commit-controls.sh`: clean control in a temporary repository (hooks pass, clean commit succeeds) and secret control (Gitleaks hook fails, full run fails, commit rejected).

#### Security

Pre-commit is developer workflow protection (layer 2), not the security boundary.

#### Observability

Not applicable — local tooling.

#### Documentation

Selection and rationale in `docs/decisions/decision-register.md` (DR-P0-002). No formatter contract is established in Phase 0.

#### Acceptance Criteria

P0-AC-014, P0-AC-018, P0-AC-019.

#### Verification Evidence

`VER-P0-FORMAT-001`, `VER-P0-PRECOMMIT-NEG`, `VER-P0-PRECOMMIT-POS`.

---

### Task 0.19

#### Objective

Establish Gitleaks secret detection.

#### Inputs

Decision register DR-P0-001.

#### Implementation

Pinned Gitleaks version; `.gitleaks.toml` extends the default rules with no allowlist entries.

#### Tests

`scripts/checks/gitleaks-controls.sh`: clean negative control, deterministic runtime-generated positive control detected by `github-pat`, clean control again, token absent from the repository.

#### Security

Response to findings follows `docs/security/secret-incident-response.md`. Local Gitleaks execution is not a security boundary. The positive control determines whether the candidate version is acceptable; being the latest release is not a criterion.

#### Observability

Not applicable — local tooling.

#### Documentation

Selection and rationale in DR-P0-001.

#### Acceptance Criteria

P0-AC-015, P0-AC-016, P0-AC-017.

#### Verification Evidence

`VER-P0-GITLEAKS-NEG`, `VER-P0-GITLEAKS-POS`, `VER-P0-GITLEAKS-HISTORY`.

---

### Task 0.20

#### Objective

Establish independent CI secret scanning.

#### Inputs

DR-P0-001; security architecture §6.

#### Implementation

`.github/workflows/security.yml` with third-party actions pinned to full commit SHAs and least-privilege permissions.

#### Tests

Static configuration validation, and a real CI run on the repository host, independent of local pre-commit, that (1) executes the CI positive control (`scripts/checks/gitleaks-controls.sh`), in which a synthetic fixture generated at runtime in an isolated temporary workspace outside the checkout is detected by rule `github-pat` and removed within the job, and (2) runs the repository secret scan with no leaks reported. Evidence: the CI run URL and job log.

#### Security

CI remains effective when local hooks are bypassed. Static validation is not operational verification.

#### Observability

CI job summary and run logs.

#### Documentation

Security architecture §6 (layer 3).

#### Acceptance Criteria

P0-AC-020, P0-AC-021.

#### Verification Evidence

`VER-P0-CI-CONFIG`, `VER-P0-CI-EXEC`.

---

### Task 0.21

#### Objective

Record unresolved architectural decisions and Phase 0 selections.

#### Inputs

Canonical specification §31.

#### Implementation

`docs/decisions/decision-register.md`

#### Tests

No deferred decision is implemented; Phase 0 selections are not also listed as deferred.

#### Security

Not applicable — governance record.

#### Observability

Not applicable — governance record.

#### Documentation

This document's Deferred Decisions section references the register.

#### Acceptance Criteria

P0-AC-001. Register correctness is assessed by the review layers.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.22

#### Objective

Establish developer workflow commands.

#### Inputs

Repository tooling.

#### Implementation

`docs/operations/developer-workflow.md`

#### Tests

Every listed available command exists in the repository or is a documented external tool.

#### Security

Includes the `--no-verify` prohibition and secret-handling references.

#### Observability

Not applicable — documentation.

#### Documentation

Capabilities not yet established are marked not applicable with the owning phase.

#### Acceptance Criteria

P0-AC-001.

#### Verification Evidence

`VER-P0-DOCS-001`, review records.

---

### Task 0.23

#### Objective

Create the reusable phase verification Skill and deterministic verification scripts.

#### Inputs

Phase governance.

#### Implementation

- `.claude/skills/phase-verification/SKILL.md` (orchestration and evidence recording)
- `scripts/verify-phase.sh` (deterministic checks; never writes into the repository)
- `scripts/checks/` (control scripts and `repo_snapshot.py`)

#### Tests

The script emits one result per verification ID using only `PASS`, `FAIL`, `BLOCKED`, `NOT APPLICABLE`.

#### Security

Scripts write only to temporary locations outside the repository.

#### Observability

Machine-readable and human-readable output per check.

#### Documentation

Evidence location declared in `docs/phases/README.md` §25a.

#### Acceptance Criteria

P0-AC-005, P0-AC-011, P0-AC-023.

#### Verification Evidence

`VER-P0-STATUS-RECORD-001`, `VER-P0-SKILLS-001`, `VER-P0-GIT-SAFETY-001`.

---

### Task 0.24

#### Objective

Perform a documentation and architecture contradiction review.

#### Inputs

All authority and Claude Code governance documents.

#### Implementation

Review recorded in `docs/phases/evidence/phase-0/contradiction-review.md`.

#### Tests

Check for contradictory authority, duplicated normative requirements, ambiguous terms, incompatible status definitions, conflicting dependency semantics, hidden decisions, and incorrect Claude Code responsibilities.

#### Security

Contradictory security rules are blocking.

#### Observability

Not applicable — review.

#### Documentation

Known limitations are recorded rather than ignored.

#### Acceptance Criteria

P0-AC-024.

#### Verification Evidence

`VER-P0-REVIEW-L1` (documentation/governance perspective) and the contradiction review record.

---

### Task 0.25

#### Objective

Perform the multi-perspective Phase 0 engineering review.

#### Inputs

Phase 0 deliverables and verification results.

#### Implementation

- Layer 1: main-session five-perspective review (software engineering, architecture, security, AI engineering, documentation/governance) in `engineering-review.md`.
- Layer 2: independent read-only reviewer agents in `independent-review.md`.

#### Tests

Each review records findings, severity, evidence, recommendation, and whether remediation is required before completion.

#### Security

Reviewer agents are read-only; repository snapshots before and after each reviewer must be identical.

#### Observability

Not applicable — review.

#### Documentation

Layer 1 and Layer 2 are separate evidence sources.

#### Acceptance Criteria

P0-AC-024, P0-AC-025.

#### Verification Evidence

`VER-P0-REVIEW-L1`, `VER-P0-REVIEW-L2-RUNTIME-<agent>`.

## Phase-Level Acceptance Criteria

Each criterion is a predicate. The verification ID names the check in `scripts/verify-phase.sh` or the review protocol. All evidence is recorded in `docs/phases/evidence/phase-0/verification-record.md` unless stated otherwise.

| ID        | Condition / expected result                                                                                                       | Verification ID              | Method                                   | Evidence location                      | Task trace                      |
| --------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | ---------------------------------------- | -------------------------------------- | ------------------------------- |
| P0-AC-001 | Every required Phase 0 authority, governance, operations, security, and evidence file exists at its canonical path                | VER-P0-DOCS-001              | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.1–0.7, 0.16, 0.17, 0.21, 0.22 |
| P0-AC-002 | Every authority document's status belongs to its status model, and every document claiming `Accepted` has a `status` register entry | VER-P0-STATUS-DOC-001        | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.7, 0.10                       |
| P0-AC-003 | Every ADR file under `docs/decisions/adr/`, if any exists, uses the ADR status model                                              | VER-P0-STATUS-ADR-001        | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.8                             |
| P0-AC-004 | Every phase document uses the phase status model and does not use `Accepted` as its status                                        | VER-P0-STATUS-PHASE-001      | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.9                             |
| P0-AC-005 | Every evidence record uses `Pending` / `Recorded` / `Superseded` and states no phase status                                       | VER-P0-STATUS-RECORD-001     | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.23                            |
| P0-AC-006 | The Status value equals the latest Status History row, and every recorded transition is permitted                                 | VER-P0-LIFECYCLE-001         | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.9                             |
| P0-AC-007 | The six acceptance-gate conditions (Exit Criteria) hold                                                                           | VER-P0-ACCEPT-001            | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.8, 0.10                       |
| P0-AC-008 | Every task in this document has the nine mandatory subsections in order                                                           | VER-P0-TEMPLATE-001          | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.9                             |
| P0-AC-009 | No generic governance file hard-codes a canonical specification version                                                           | VER-P0-VERSIONREF-001        | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.7, 0.11, 0.12                 |
| P0-AC-010 | `CLAUDE.md` is ≤ 200 lines, contains the required sections, and contains no hard-coded canonical version                          | VER-P0-CLAUDE-001            | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.11                            |
| P0-AC-011 | Every Skill has valid frontmatter and the required sections, and the `adr` and `commit` Skills declare `disable-model-invocation: true` | VER-P0-SKILLS-001            | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.13, 0.23                      |
| P0-AC-012 | All five reviewer agents declare tools within Read/Grep/Glob, disallow Write/Edit/NotebookEdit/Bash/PowerShell, and have Role, Scope, and read-only sections | VER-P0-AGENTS-CONFIG-001 | `scripts/verify-phase.sh phase-0` | verification record                    | 0.14                            |
| P0-AC-013 | Guardrail fixtures behave as specified, `settings.json` is valid, and no Stop hook exists                                         | VER-P0-HOOKS-001             | `scripts/checks/claude-guardrails.sh`    | verification record                    | 0.15                            |
| P0-AC-014 | The formatter applicability determination is recorded                                                                             | VER-P0-FORMAT-001            | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.18                            |
| P0-AC-015 | Clean Gitleaks scans exit 0 before and after the positive control                                                                 | VER-P0-GITLEAKS-NEG          | `scripts/checks/gitleaks-controls.sh`    | verification record                    | 0.19                            |
| P0-AC-016 | The synthetic token scan exits non-zero, the JSON report parses and contains `github-pat`, and the token occurs 0 times in the repository | VER-P0-GITLEAKS-POS     | `scripts/checks/gitleaks-controls.sh`    | verification record                    | 0.19                            |
| P0-AC-017 | Repository history scan exits 0 when commits exist                                                                                | VER-P0-GITLEAKS-HISTORY      | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.19                            |
| P0-AC-018 | Clean temporary repository: hooks pass and a clean commit succeeds                                                                | VER-P0-PRECOMMIT-NEG         | `scripts/checks/pre-commit-controls.sh`  | verification record                    | 0.18                            |
| P0-AC-019 | Secret temporary repository: Gitleaks hook fails, full run fails, commit is rejected, commit count is 0                           | VER-P0-PRECOMMIT-POS         | `scripts/checks/pre-commit-controls.sh`  | verification record                    | 0.18                            |
| P0-AC-020 | The CI workflow parses and matches the pinned SHAs, permissions, triggers, fetch depth, and Gitleaks version                      | VER-P0-CI-CONFIG             | `scripts/verify-phase.sh phase-0`        | verification record                    | 0.20                            |
| P0-AC-021 | A real CI run on the repository host (1) executes the CI positive control: a synthetic fixture generated at runtime in an isolated temporary workspace outside the checkout is detected by rule `github-pat` and removed within the job; and (2) runs the repository secret scan with no leaks reported. Evidence: CI run URL and job log | VER-P0-CI-EXEC               | CI run on the repository host            | verification record (run URL)          | 0.20                            |
| P0-AC-022 | Repository protection requires the CI security check                                                                              | VER-P0-REPO-PROTECTION       | Repository host settings                 | verification record                    | 0.17, 0.20                      |
| P0-AC-023 | Commit count and remotes are unchanged, only read-only Git commands ran against the repository, and working-tree changes stay within the declared boundaries | VER-P0-GIT-SAFETY-001 | Snapshot comparison (`scripts/checks/repo_snapshot.py`) | verification record | 0.23 |
| P0-AC-024 | The Layer 1 five-perspective review and the contradiction review were performed and recorded with all required fields            | VER-P0-REVIEW-L1             | Main-session review                      | `engineering-review.md`, `contradiction-review.md` | 0.24, 0.25           |
| P0-AC-025 | Each Layer 2 reviewer either ran read-only with identical before/after snapshots and its record is complete, or is BLOCKED under the reviewer tool contract with its missing prerequisite recorded and is a member of `TRANSITION_PERMITTED_BLOCKED`. A BLOCKED reviewer is never recorded as PASS | VER-P0-REVIEW-L2-RUNTIME-<agent> | Reviewer-agent protocol              | `independent-review.md`                | 0.25                            |

PASS for a review check means that the review was successfully performed with the required integrity/evidence conditions. It does not mean that the reviewer found no issues.

## Exit Criteria

### Transition to Verification

Phase 0 may move from `In Progress` to `Verification` only when all of the following hold:

1. every check whose applicability and prerequisite predicates are both true has executed and has result `PASS`;
2. no check has result `FAIL`;
3. every `BLOCKED` check was evaluated, its missing prerequisite is recorded, and it is a member of `TRANSITION_PERMITTED_BLOCKED` (the single constant defined in `scripts/verify-phase.sh`; it is not redefined here). `BLOCKED` on any other check keeps Phase 0 `In Progress`;
4. every `NOT APPLICABLE` check has its applicability determination and reason recorded;
5. `VER-P0-REVIEW-L1` is `PASS`, and every `VER-P0-REVIEW-L2-RUNTIME-<agent>` is `PASS` or a `BLOCKED` permitted by condition 3;
6. no process action `STOP` occurred.

### Transition to Complete

Phase 0 may become `Complete` only after:

- all Transition to Verification conditions hold;
- `VER-P0-CI-EXEC` is `PASS` (a real CI run);
- `VER-P0-REPO-PROTECTION` is `PASS`;
- `VER-P0-ACCEPT-001` is `PASS`, meaning the acceptance gate below is satisfied;
- the Phase 0 ADR gate is satisfied;
- the completion decision is recorded.

External prerequisite sequence for `VER-P0-CI-EXEC` (not an additional gate): a commit (`/commit`), then remote setup and push (separately authorized), then a CI run on the repository host.

### Acceptance gate

Recorded in `docs/architecture/acceptance-register.md` by the project owner:

1. `docs/architecture/documentation-authority.md` — status `Accepted` and a `status` entry;
2. `docs/architecture/canonical-specification/README.md` — status `Accepted` and a `status` entry;
3. `docs/phases/README.md` — status `Accepted` and a `status` entry;
4. `docs/decisions/README.md` — status `Accepted` and a `status` entry;
5. `docs/architecture/acceptance-register.md` — status `Accepted` and a `status` entry;
6. this document — a `content` entry. Its lifecycle status remains governed by the phase status model and is never `Accepted`.

A genuinely pending acceptance (valid register, no entry, no `Accepted` claim, and no inconsistency anywhere in the gate) is `BLOCKED`. A missing or malformed register, or any inconsistency, is `FAIL`.

DR-P0-001 and DR-P0-002 are not acceptance gates.

## Risks

### Documentation drift

Mitigation: explicit authority model, status models, and contradiction review.

### Overloaded CLAUDE.md

Mitigation: Rules, Skills, Agents, and Hooks hold detail; CLAUDE.md references them.

### False security confidence from local hooks

Mitigation: independent CI enforcement and repository protection (security architecture §6).

### Vacuous verification

Mitigation: behavioural positive and negative controls; NOT APPLICABLE and BLOCKED only through declared predicates.

### Premature architecture decisions

Mitigation: decision register and ADR gates.

### AI overreach

Mitigation: AI trust boundary, deterministic verification, read-only reviewers, and human approval.

## Known Limitations

- The original sources of canonical specification v0.1 and v0.2 are unavailable; those versions exist only as status-only historical records.
- Several infrastructure and provider decisions intentionally remain unresolved (decision register).
- Phase 0 establishes governance but does not validate the production runtime architecture through application implementation.
- The canonical specification duplicates the roadmap and phase lifecycle (decision register DGI-001); deferred to the next intentional canonical revision.
- Architectural dependency DEP-001 (`docs/decisions/decision-register.md`): the consequential-change classification referenced by REQ-PLATFORM-007 must be defined in `docs/architecture/ai-architecture.md`, or, if establishing it is a consequential architectural decision, through an Accepted ADR referenced by the AI architecture, before the first phase that implements consequential AI-generated remediation.
- The repository has no remote; CI execution and repository protection cannot be verified until one exists.

## Deferred Decisions

Deferred architectural decisions and Phase 0 tooling selections are recorded in `docs/decisions/decision-register.md`. They are not repeated here.

## ADRs

The ADR index is `docs/decisions/README.md`.

Phase 0 ADR gate:

- The current Accepted canonical specification is the accepted cross-cutting baseline. Retrospective ADRs documenting decisions already contained in it are optional and are not a Phase 0 gate.
- Any **new** consequential architectural decision introduced during Phase 0 must have an `Accepted` ADR before Phase 0 can become `Complete`. None has been introduced.
- A `Proposed` ADR is not an accepted decision, and implementation must not treat it as one.

## Evidence

Phase 0 evidence is recorded in `docs/phases/evidence/phase-0/` (location declared in `docs/phases/README.md` §25a):

- `verification-record.md` — deterministic verification results;
- `contradiction-review.md` — Task 0.24;
- `engineering-review.md` — Layer 1 review;
- `independent-review.md` — Layer 2 reviews.

No commit may occur in the real repository during a verification run (`docs/phases/README.md` §25a).

## Completion Record

### Status History

| Date       | Previous Status | New Status  | Reason                                                                                             | Evidence                                   |
| ---------- | --------------- | ----------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| 2026-10-03 | —               | Not Started | Phase created                                                                                      | Initial phase document                     |
| 2026-10-03 | Not Started     | In Progress | Phase 0 work commenced; transition recorded retrospectively during Phase 0 remediation (decision M1) | Phase 0 deliverables present in repository |
| 2026-10-03 | In Progress     | Verification | Transition rule satisfied by verification run 1 and re-verification (no FAIL; only permitted BLOCKED; no STOP); completion gates CI-EXEC, REPO-PROTECTION and ACCEPT-001 remain BLOCKED | `docs/phases/evidence/phase-0/verification-record.md` Run 1, §3.6–§3.7 |

Status history is append-only.

### Final Verification

To be completed when Phase 0 enters `Verification`. Results are recorded in `docs/phases/evidence/phase-0/verification-record.md`.

### Completion Decision

To be completed only after successful verification.

```text
Decision: Pending
Verified By: Pending
Verification Date: Pending
Evidence: Pending
```
