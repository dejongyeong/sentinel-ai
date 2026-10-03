# Sentinel AI — Product Requirements

**File:** `docs/product/requirements.md`  
**Status:** Proposed  
**Owner:** Product / Engineering  
**Authority:** Product requirements

## 1. Requirement Conventions

Requirement identifiers use:

```text
REQ-<DOMAIN>-<NUMBER>
```

Priority values:

- `Must`
- `Should`
- `Could`

A requirement must describe an observable outcome or constraint.

Requirements state *what* the system does. *How* it is structured belongs in architecture documentation or ADRs. A requirement may reference an architectural constraint for traceability but does not redefine it.

Traceability: user stories (`docs/product/user-stories.md`) and acceptance criteria (`docs/product/acceptance-criteria.md`) reference these identifiers.

## 2. Accessibility Requirements

### REQ-ACCESS-001 — Website registration

**Priority:** Must

The system shall allow an authorized user to register a website for accessibility auditing.

### REQ-ACCESS-002 — Audit creation

**Priority:** Must

The system shall allow an authorized user to create an accessibility audit for a registered website.

### REQ-ACCESS-003 — Browser execution

**Priority:** Must

The system shall execute browser-based audit workflows in a controlled runtime.

### REQ-ACCESS-004 — Deterministic accessibility checks

**Priority:** Must

The system shall perform deterministic accessibility checks before AI analysis.

### REQ-ACCESS-005 — Findings

**Priority:** Must

The system shall persist accessibility findings and their relevant provenance.

### REQ-ACCESS-006 — Evidence

**Priority:** Must

The system shall associate findings with evidence sufficient to support later investigation.

### REQ-ACCESS-007 — Standards mapping

**Priority:** Must

The system shall support mapping accessibility findings to authoritative standards information.

### REQ-ACCESS-008 — AI analysis

**Priority:** Must

The system shall support AI-assisted interpretation of deterministic accessibility results without treating AI output as authoritative by default.

### REQ-ACCESS-009 — Remediation proposals

**Priority:** Should

The system should support AI-assisted remediation proposals.

### REQ-ACCESS-010 — Validation

**Priority:** Must

The system shall validate remediation using deterministic checks where applicable.

### REQ-ACCESS-011 — Continuous monitoring

**Priority:** Should

The system should support recurring accessibility checks and detection of changes over time.

## 3. Cross-Cutting Requirements

Priorities below derive from invariants in the current Accepted canonical specification (resolved through `docs/architecture/canonical-specification/README.md`); the cited section is the source.

### REQ-PLATFORM-001 — Authorization

**Priority:** Must (canonical specification §13)

The system shall prevent a principal from performing an operation for which the principal lacks permission. Operations are denied unless explicitly permitted.

Architectural constraint (not redefined here): where authorization is enforced is defined by `docs/architecture/application-architecture.md` §3 and `docs/architecture/security-architecture.md` §2.

### REQ-PLATFORM-002 — Auditability

**Priority:** Must (canonical specification §15)

The system shall preserve sufficient provenance to understand how important results were produced.

### REQ-PLATFORM-003 — Idempotency

**Priority:** Must (canonical specification §12)

The system shall support idempotent handling for operations where duplicate execution could produce incorrect or undesirable results.

### REQ-PLATFORM-004 — Observability

**Priority:** Must (canonical specification §23)

The system shall expose sufficient telemetry to investigate failures in important asynchronous and user-visible workflows.

### REQ-PLATFORM-005 — Security

**Priority:** Must (canonical specification §21)

The system shall apply security controls appropriate to each capability as that capability is introduced.

### REQ-PLATFORM-006 — AI validation

**Priority:** Must (canonical specification §18)

AI-generated structured output shall be validated before being consumed by consequential workflows.

### REQ-PLATFORM-007 — Human approval of consequential AI-generated changes

**Priority:** Must (canonical specification §20)

The system shall not apply, merge, or deploy an AI-generated change that is classified as consequential to a user's repository or production environment unless an authorized human has explicitly approved that change. AI-generated changes are proposals until approved.

Scope: Sentinel AI product behaviour only. Changes to the Sentinel AI repository itself are governed by canonical specification §20 and the project's engineering governance, not by this requirement.

Dependency: the consequential-change classification is an open architectural dependency (DEP-001, `docs/decisions/decision-register.md`).

## 4. Product Quality Requirements

The system should support:

- reproducibility;
- traceability;
- failure diagnosis;
- explicit uncertainty;
- safe retries;
- evidence-backed results.

## 5. Requirement Change

Changes to these requirements must identify affected:

- user stories;
- acceptance criteria;
- architecture;
- ADRs;
- phases;
- tests.

A requirement change must not be hidden inside a phase document.
