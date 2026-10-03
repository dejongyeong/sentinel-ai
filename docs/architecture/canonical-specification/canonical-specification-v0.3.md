# Sentinel AI — Canonical Engineering Specification v0.3

**File:** `docs/architecture/canonical-specification/canonical-specification-v0.3.md`  
**Status:** Accepted  
**Supersedes:** v0.2  
**Owner:** Engineering  
**Effective:** Phase 0 baseline  
**Implementation policy:** No application implementation before Phase 0 completion

## 1. Purpose

This specification defines the accepted engineering baseline for Sentinel AI.

It exists to establish boundaries and invariants that must remain consistent across product implementation, architecture, AI systems, infrastructure, testing, security, observability, and Claude Code-assisted development.

It is normative.

Where another document conflicts with this specification, the conflict must be resolved through the documentation authority and architectural decision processes rather than silently choosing an interpretation.

## 2. Change Summary From v0.2

v0.3 consolidates the engineering baseline around:

- modular-monolith architecture;
- explicit Application / Domain / Platform boundaries;
- PostgreSQL as the authoritative durable system of record;
- SQLAlchemy as the production persistence layer;
- Alembic as the sole migration authority;
- FastAPI/OpenAPI as API contract authority;
- worker-to-application execution boundaries;
- application-level authorization;
- Redis as non-authoritative infrastructure;
- durable idempotency state in PostgreSQL;
- evidence provenance requirements;
- deterministic-before-AI processing;
- structured validation and safety boundaries for AI output;
- separation of authoritative standards data from retrieval corpus;
- human approval for consequential AI-generated repository changes;
- cross-phase security, testing, and observability;
- explicit phase and ADR lifecycle governance.

## 3. Product Architecture Principle

Sentinel AI is initially implemented as a **modular monolith**.

Microservices are not the default architecture.

A transition to separate services requires explicit architectural justification and an accepted ADR.

## 4. System Boundary

The initial platform consists conceptually of:

```text
Next.js Web Application
        │
        ▼
FastAPI API
        │
        ▼
Application Layer
        │
        ├── Accessibility Domain
        ├── Data Quality Domain
        └── Incident Domain
        │
        ▼
Platform Infrastructure
```

Background workers use the application layer:

```text
Worker
  │
  ▼
Application Use Case
  │
  ▼
Domain / Platform
```

Workers must not bypass application use cases to manipulate domain state directly.

## 5. API Contract Authority

FastAPI and its generated OpenAPI contract are authoritative for the HTTP API.

The TypeScript API client is derived from that contract.

The frontend must not independently redefine the backend API contract.

## 6. Frontend Boundary

Next.js must not directly access:

- PostgreSQL;
- Redis;
- job queues;
- internal domain persistence;
- LLM providers;
- internal infrastructure credentials.

The frontend communicates through supported API boundaries.

## 7. Application Layer

The Application layer owns use-case orchestration.

It is responsible for:

- authorization entry;
- transaction/use-case coordination;
- domain orchestration;
- interaction with repositories and platform capabilities;
- idempotency coordination;
- application-level policy enforcement.

## 8. Domain Boundaries

Domains represent business capabilities.

Initial domains:

```text
accessibility
data_quality
incident
```

Domains must not import other domains.

Cross-domain behaviour must be coordinated by the Application layer.

A domain must not become a hidden shared-services layer.

## 9. Platform Boundary

Platform contains technical infrastructure capabilities.

Examples include:

- database infrastructure;
- cache;
- queue;
- storage;
- telemetry;
- external provider clients;
- security infrastructure.

Platform must not import domains or application use cases.

## 10. Database Authority

PostgreSQL is the authoritative durable system of record.

Production persistence uses SQLAlchemy.

Alembic is the sole database migration authority.

Drizzle is explicitly **not** a production database-access layer.

No alternative ORM may be introduced without an accepted architectural decision.

## 11. Redis Authority

Redis is non-authoritative.

Redis may provide:

- caching;
- rate limiting;
- idempotency coordination;
- distributed coordination;
- ephemeral job infrastructure;
- justified locks.

Durable business state must not exist only in Redis.

If Redis state is lost, authoritative system state must remain recoverable from PostgreSQL or another explicitly authoritative durable store.

## 12. Idempotency

Idempotency must distinguish:

- coordination state;
- durable business result.

Redis may coordinate duplicate requests.

The durable idempotency result must be persisted in PostgreSQL.

An idempotent operation must define:

- idempotency key;
- request scope;
- ownership;
- expiration/replay policy;
- durable result semantics;
- conflict semantics;
- failure semantics.

## 13. Authorization

Authorization is evaluated at application use-case entry.

HTTP middleware may provide authentication and preliminary request handling, but middleware alone is not the authoritative authorization boundary.

Authorization is deny-by-default.

Every use case must establish the principal and evaluate the permissions required for the requested operation.

## 14. Worker Security

Workers are not trusted merely because they are internal.

Worker execution must establish an execution principal and satisfy application authorization requirements.

Background execution must not bypass normal security invariants.

## 15. Evidence

Evidence metadata is authoritative in PostgreSQL.

Large binary artifacts may be stored in object storage.

The object-storage architecture is intentionally deferred to the relevant phase and ADR.

Evidence provenance must be sufficient to identify, where applicable:

- producer;
- timestamp;
- input;
- software version;
- scanner/rule version;
- model version;
- browser/runtime configuration;
- audit/job;
- generation method.

## 16. Accessibility Determinism

Deterministic accessibility checks occur before AI analysis.

AI must not replace deterministic accessibility testing.

Automated accessibility findings must retain their machine-detectable provenance.

AI may interpret, prioritize, explain, propose remediation, or assist with other bounded tasks, subject to validation and safety controls.

Automated checks do not by themselves establish complete legal or regulatory compliance.

## 17. Standards Authority

Authoritative accessibility standards data is distinct from the retrieval corpus.

The standards model represents normative information such as:

- standards;
- versions;
- requirements;
- success criteria;
- rules;
- mappings.

The retrieval corpus represents retrievable knowledge such as:

- documents;
- chunks;
- embeddings;
- metadata;
- provenance.

Retrieval results cannot override authoritative standards data.

## 18. AI Trust Boundary

AI output is untrusted input.

AI output must be:

1. structurally validated;
2. schema validated;
3. safety validated;
4. checked against applicable deterministic constraints;
5. associated with provenance;
6. subject to human approval where consequences require it.

AI output must not silently become authoritative business state.

## 19. Correlation and Causation

The platform must distinguish correlation from causation.

AI-generated explanations must not be presented as causal conclusions unless causal evidence exists and the conclusion is explicitly supported.

## 20. AI-Generated Changes

AI-generated repository changes that may affect consequential behaviour require human approval before merge or deployment.

AI may assist with implementation.

AI does not independently authorize production changes.

## 21. Security

Security is a cross-phase engineering concern.

Security controls must be introduced with the capabilities they protect.

Security is not deferred entirely to the later hardening phase.

Phase 19 strengthens and audits the security posture; it does not establish security for the first time.

## 22. Testing

Testing is cross-phase.

Relevant capabilities must receive appropriate tests when introduced.

The project must not defer all testing until a final testing phase.

Testing may include:

- unit tests;
- integration tests;
- contract tests;
- end-to-end tests;
- security tests;
- AI evaluations;
- regression tests.

## 23. Observability

Minimum observability must exist before meaningful asynchronous processing is introduced.

Full observability is expanded during Phase 7.

Observability must support appropriate:

- logs;
- metrics;
- traces;
- correlation identifiers;
- job execution visibility;
- failure diagnosis.

## 24. Documentation

Documentation must have explicit subject authority.

Documents may summarize authoritative material but must not silently redefine it.

Documentation changes that alter accepted architecture must follow the architectural decision process.

## 25. Claude Code Governance

Claude Code is an engineering assistant, not an architectural authority.

Claude Code must:

- inspect before modifying;
- consult authoritative documentation;
- identify assumptions;
- distinguish facts, decisions, and open questions;
- preserve architectural boundaries;
- avoid unrelated changes;
- run relevant verification;
- report failures honestly;
- never bypass security controls merely to complete a task;
- stop when required information or authorization is missing.

The Claude Code configuration follows this separation:

| Mechanism         | Primary responsibility                |
| ----------------- | ------------------------------------- |
| `CLAUDE.md`       | Persistent project context            |
| `.claude/rules/`  | Constraints and conventions           |
| `.claude/skills/` | Reusable procedures                   |
| `.claude/agents/` | Specialist delegated contexts         |
| `.claude/hooks/`  | Deterministic lifecycle/tool controls |

This separation follows current Claude Code guidance.

## 26. Phase Governance

Phases use:

- `Not Started`
- `In Progress`
- `Verification`
- `Complete`
- `Blocked`

Normal progression:

```text
Not Started
     ↓
In Progress
     ↓
Verification
     ↓
Complete
```

A failed verification returns the phase to `In Progress`.

A blocked phase returns to `In Progress` when the blocking condition is resolved.

A phase cannot move directly from `Not Started` to `Complete`.

## 27. Dependency Semantics

`Depends on` means the prerequisite phase must be `Complete` before the dependent phase may become `In Progress`.

This is the governance dependency.

Technical implementation dependencies must be documented separately.

## 28. Phase Completion

A phase is `Complete` only when all applicable completion conditions have been satisfied:

- implementation;
- tests;
- security;
- observability;
- documentation;
- acceptance criteria;
- verification evidence;
- ADR gates;
- exit criteria.

## 29. Architectural Decisions

ADR statuses:

- `Proposed`
- `Accepted`
- `Rejected`
- `Superseded`

A consequential architectural decision must have an `Accepted` ADR before implementation becomes the new architectural baseline.

## 30. Human Decision Authority

Claude Code may analyse, critique, propose, implement, test, and verify.

It must not silently make consequential architectural decisions on behalf of the project owner.

## 31. Unresolved Decisions

The following decisions remain intentionally unresolved until their designated phases:

- queue technology;
- authentication mechanism;
- object storage;
- evidence retention;
- browser isolation;
- LLM providers;
- embedding provider/model;
- notification provider;
- Data Quality connectors;
- Incident signal sources;
- cloud provider.

Phase 0 additionally selects:

- initial Gitleaks version;
- initial pre-commit hook set.

Unresolved decisions must not be silently implemented.

## 32. Canonical Roadmap

```text
P0  Product & Secure Engineering Foundation
P1  Repository & Engineering Foundation
P2  Containerisation & Local Infrastructure
P3  Database & API Foundation
P4  Identity, Authentication & Authorization
P5  Redis, Idempotency & Rate Limiting
P6  Background Processing
P7  Observability
P8  AI Platform Foundation
P9  RAG & Retrieval
P10 Accessibility Engine
P11 Standards & WCAG Mapping
P12 Findings & Evidence
P13 AI Accessibility Analysis
P14 Remediation & Validation
P15 Continuous Monitoring & Compliance
P16 Data Quality Sentinel
P17 Incident Sentinel
P18 AI Evaluation & Safety
P19 Security Hardening
P20 Performance & Reliability
P21 Cloud Deployment
P22 CI/CD
P23 Documentation & Portfolio
P24 Integration & Release Readiness
```

## 33. Architectural Change Process

Any consequential architectural change follows:

```text
Identify
   ↓
Analyse
   ↓
Critique alternatives
   ↓
ADR
   ↓
Human decision
   ↓
Canonical specification update
   ↓
Affected documentation update
   ↓
Implementation
   ↓
Verification
```

No phase, README, source comment, Claude instruction, Skill, Agent, Hook, test, or example may silently change the architecture.

## 34. Non-Goals

This specification does not:

- define detailed product requirements;
- define every API endpoint;
- define database schemas;
- select unresolved infrastructure providers;
- define detailed security procedures;
- define AI evaluation datasets;
- replace phase acceptance criteria;
- replace ADRs.

Those concerns belong to their authoritative documents.

## 35. Acceptance

This document is the current engineering baseline for Sentinel AI.

**Status:** Accepted
