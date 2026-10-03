# Sentinel AI — Phase Governance

**File:** `docs/phases/README.md`  
**Status:** Accepted  
**Owner:** Engineering  
**Scope:** Governance of all Sentinel AI phase documents

## 1. Purpose

Phase documents convert accepted product, architecture, security, and engineering decisions into bounded implementation and verification work.

They are execution documents.

They are not replacements for:

- product requirements;
- architecture documents;
- ADRs;
- the Canonical Engineering Specification.

---

## 2. Phase Authority

Each phase document owns execution governance for that phase.

The roadmap remains authoritative for:

- phase sequence;
- phase names;
- project-level phase intent.

The roadmap is:

`docs/product/roadmap.md`

The current Canonical Engineering Specification remains authoritative for cross-cutting engineering invariants.

---

## 3. Explicit Decision Boundary

A phase document may operationalize an accepted decision.

It may not create an accepted decision.

### Mandatory rule

> **A phase document may operationalize an accepted decision but may not create an accepted decision.**

This means a phase document may say:

> Implement the accepted authentication architecture defined by ADR-XXXX.

It may not say:

> Use Provider X for authentication.

unless the decision has already been accepted through the applicable architectural decision process.

---

## 4. Unresolved Decisions

A phase may identify, analyse, and document an unresolved decision.

It may not silently resolve that decision through implementation.

For example, if queue technology is unresolved:

```text
Allowed:

Investigate Queue A
Investigate Queue B
Compare trade-offs
Create recommendation
Create ADR
Await decision
```

Not allowed:

```text
Queue technology unresolved
        ↓
Phase chooses Queue A
        ↓
Implementation treats Queue A as final architecture
```

The second sequence silently creates architecture.

---

## 5. Prototype Rule

A phase may implement a prototype for an unresolved decision when the prototype is explicitly marked as non-authoritative.

The prototype must state:

```text
Status: Experimental / Proposed
Production decision: Pending
Architectural authority: None
```

A prototype must not silently become the production architecture.

---

## 6. Decision Lifecycle

For consequential unresolved decisions:

```text
Question
   ↓
Explore
   ↓
Analyse
   ↓
Critique alternatives
   ↓
Document options
   ↓
ADR
   ↓
Human decision
   ↓
Accepted ADR
   ↓
Canonical specification update if required
   ↓
Phase implementation
   ↓
Verification
```

---

## 7. Claude Code Decision Boundary

Claude Code may:

- inspect the repository;
- analyse requirements;
- analyse architecture;
- identify contradictions;
- propose alternatives;
- draft an ADR;
- implement accepted decisions;
- test;
- verify;
- report evidence.

Claude Code may not silently accept its own proposal.

### Mandatory rule

> **Claude Code may propose an architectural decision but may not treat a proposed decision as accepted.**

Claude must explicitly distinguish:

```text
Fact
Assumption
Proposal
Accepted decision
Implementation
Verification
```

If a consequential decision is unresolved, Claude must stop before treating a selected option as accepted architecture.

---

## 8. Phase Statuses

Valid phase statuses are:

- `Not Started`
- `In Progress`
- `Verification`
- `Complete`
- `Blocked`

No other status is valid unless phase governance itself is formally changed.

---

## 9. Normal Lifecycle

```text
Not Started
      ↓
In Progress
      ↓
Verification
      ↓
Complete
```

A phase must not transition directly from:

```text
Not Started → Complete
```

---

## 10. Failed Verification

If verification fails:

```text
Verification
      ↓
FAIL
      ↓
In Progress
      ↓
Remediation
      ↓
Verification
```

The failure must be recorded.

The phase must not remain Complete after a failed required verification.

---

## 11. Blocked Status

A phase is `Blocked` only when progress cannot continue because of a documented blocking condition.

The phase document must record:

- blocker;
- affected task;
- dependency;
- owner;
- impact;
- resolution condition.

When the blocker is resolved:

```text
Blocked → In Progress
```

The phase must then continue through verification before becoming Complete.

---

## 11a. Transition Table

These are the only permitted phase transitions. Every transition is appended to the phase document's Status History with date, reason, and evidence.

| Transition                   | Condition                                                                                                   | Required evidence                                                                 |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Not Started → In Progress    | Governance dependencies (§12) are `Complete`; phase work begins                                              | Status-history row with reason                                                    |
| In Progress → Blocked        | A documented blocking condition prevents progress                                                           | Blocker record (§11): blocker, affected task, dependency, owner, impact, resolution condition |
| Blocked → In Progress        | The blocking condition is resolved                                                                          | Reference to the resolution                                                       |
| In Progress → Verification   | The phase document's transition rule for entering verification is satisfied                                 | Verification record reference (§25a)                                              |
| Verification → Complete      | All completion conditions (§23) pass, including acceptance, evidence, ADR gates, and exit criteria          | Final verification and recorded completion decision                              |
| Verification → In Progress   | A required verification fails or remediation is required                                                    | Recorded failure (§10)                                                            |

Not permitted:

- `Not Started → Complete`, `Not Started → Verification`, or any transition not in the table;
- `Blocked → Complete` or `Blocked → Verification`. A blocked phase returns to `In Progress` and passes verification before it can become `Complete`.

A verification check whose result is `BLOCKED` does not by itself make the phase `Blocked`. Phase status `Blocked` is used only under §11.

---

## 12. Dependency Semantics

`Depends on` has a specific governance meaning:

> The prerequisite phase must be `Complete` before the dependent phase may become `In Progress`.

For example:

```text
P1 depends on P0
```

means:

```text
P0 = Complete
        ↓
P1 may become In Progress
```

This does not mean that every implementation detail of P1 is technically impossible before P0.

It means P1 cannot be formally opened as an execution phase until its governance prerequisite is Complete.

---

## 13. Governance Dependency vs Technical Dependency

These concepts must not be conflated.

### Governance dependency

Controls phase lifecycle.

Example:

```text
P1 depends on P0
```

### Technical dependency

Describes an actual implementation requirement.

Example:

```text
API integration requires database infrastructure.
```

Technical dependencies should be documented separately where relevant.

---

## 14. Required Phase Template

Every phase document must use:

```text
# Phase N — Name
## Status
## Objective
## Why This Phase Exists
## Scope
## Out of Scope
## Dependencies
## Architectural Constraints
## Deliverables
### Task N.X
#### Objective
#### Inputs
#### Implementation
#### Tests
#### Security
#### Observability
#### Documentation
#### Acceptance Criteria
#### Verification Evidence
## Phase-Level Acceptance Criteria
## Exit Criteria
## Risks
## Known Limitations
## Deferred Decisions
## ADRs
## Evidence
## Completion Record
### Status History
### Final Verification
### Completion Decision
```

Additional sections may be added only when necessary and must not duplicate an authoritative specification.

---

## 15. Task Requirements

A task must be:

- bounded;
- understandable independently;
- outcome-oriented;
- testable;
- traceable;
- small enough to verify.

A task should not conceal multiple unrelated architectural decisions.

---

## 16. Task Decision Boundary

A task may implement an accepted architecture.

A task may investigate an unresolved architecture.

A task may not silently accept an unresolved architecture.

For example:

### Valid

```text
Task:
Evaluate queue technologies and prepare ADR-0005.
```

### Invalid

```text
Task:
Install Redis Queue X and make it the permanent production queue.

Status:
Decision pending.
```

The second task has converted an unresolved decision into an implementation decision.

---

## 17. Security

Security is cross-phase.

A phase must implement applicable security controls when introducing the capability they protect.

A later security-hardening phase may strengthen controls.

It does not excuse earlier phases from applying basic security.

---

## 18. Testing

Testing is cross-phase.

Each phase must introduce appropriate tests for its capabilities.

Testing must not be deferred entirely to the end of the project.

Relevant tests may include:

- unit;
- integration;
- contract;
- end-to-end;
- security;
- regression;
- AI evaluation.

---

## 19. Observability

Observability is cross-phase.

A phase introducing meaningful asynchronous or externally observable work must provide appropriate observability.

Later observability phases may expand the capability.

They do not remove the obligation to provide basic diagnostics earlier.

---

## 20. Documentation

Phase documentation must:

- reference authoritative requirements;
- reference accepted architecture;
- reference accepted ADRs;
- identify unresolved decisions;
- record evidence.

It must not copy entire specifications into itself.

---

## 21. ADR Gates

A consequential architectural decision requires an `Accepted` ADR before it becomes the accepted implementation baseline.

Valid ADR statuses are:

- `Proposed`;
- `Accepted`;
- `Rejected`;
- `Superseded`.

A `Proposed` ADR does not authorize production architecture.

A `Rejected` ADR does not authorize production architecture.

A `Superseded` ADR does not authorize the superseded architecture.

Only an `Accepted` ADR authorizes the decision it records, subject to the current canonical specification and subject-specific authority.

---

## 22. Canonical Specification Gate

Before implementing consequential work, the phase must use the current Accepted Canonical Engineering Specification.

The current version is resolved through:

`docs/architecture/canonical-specification/README.md`

This document does not name a specific canonical version, so it remains valid when a later version becomes current.

If a phase discovers that the specification is insufficient or incorrect:

```text
Stop consequential implementation
        ↓
Analyse
        ↓
Critique
        ↓
ADR if required
        ↓
Human decision
        ↓
Update canonical specification if required
        ↓
Update affected phase
        ↓
Resume
```

---

## 23. Phase Completion

A phase is Complete only when all applicable conditions have passed:

- implementation;
- tests;
- security;
- observability;
- documentation;
- acceptance criteria;
- verification evidence;
- ADR gates;
- exit criteria.

"Code exists" is not a completion criterion.

---

## 24. Implemented, Verified, Accepted, Complete

These terms have precise meanings.

### Implemented

The implementation exists.

### Verified

The implementation has passed the relevant verification checks.

### Accepted

The applicable human decision authority has accepted the relevant decision.

### Complete

The phase's full completion criteria have passed and the completion decision has been recorded.

For example:

```text
Implementation:
Complete

Tests:
Passing

ADR:
Accepted

Verification:
Passing

Phase:
Complete
```

must not be reduced to:

```text
"Claude implemented it, therefore it is complete."
```

---

## 25. Evidence

Verification evidence may include:

- command output;
- test results;
- CI results;
- screenshots;
- logs;
- traces;
- security scans;
- review reports;
- acceptance results;
- ADR references.

Evidence must demonstrate the criterion being verified.

A command merely executing successfully is not necessarily evidence that the underlying requirement passed.

### 25a. Evidence Location

Verification record path: docs/phases/evidence/{phase}/verification-record.md

`{phase}` is the phase identifier (for example `phase-0`). Review records for a phase live in the same directory. `scripts/verify-phase.sh` reads the path from the line above.

Evidence records use the lifecycle `Pending` / `Recorded` / `Superseded` (`docs/architecture/documentation-authority.md` §22) and never state the phase status.

Deterministic verification scripts never write into the repository. Only verification orchestration (the `phase-verification` Skill) writes evidence records.

No commit may occur in the real repository between a verification run's baseline snapshot and its final snapshot. The `commit` Skill is prohibited during that interval.

---

## 26. Verification Independence

Where practical, the implementation agent should not be the only party evaluating its own work.

A fresh verification context or verification subagent should be used for consequential work where useful.

Claude Code's current guidance explicitly recommends verification mechanisms and adversarial/fresh-context review for stronger feedback loops.

---

## 27. Status History

Status history is append-only.

Every transition records:

- previous status;
- new status;
- date/time;
- reason;
- relevant evidence.

---

## 28. Deferred Decisions

Deferred decisions must be explicit.

A deferred decision means:

```text
No accepted decision exists yet.
```

It does not mean:

```text
Claude may choose one silently.
```

---

## 29. Cross-Phase Changes

Changes affecting multiple phases follow:

```text
Identify
   ↓
Analyse
   ↓
Critique
   ↓
Decision / ADR
   ↓
Update authority
   ↓
Update affected phases
   ↓
Implement
   ↓
Verify
```

---

## 30. Claude Code Workflow

For consequential work, Claude should follow:

```text
Explore
   ↓
Plan
   ↓
Implement
   ↓
Test
   ↓
Verify
   ↓
Report evidence
```

Claude Code's current best-practices documentation recommends separating exploration/planning from implementation for non-trivial work and giving Claude a concrete check it can execute to verify its work.

---

## 31. Claude Code Stopping Conditions

Claude must stop and request clarification or decision authority when:

- an accepted requirement is missing;
- architecture conflicts;
- an ADR is required but not accepted;
- a security boundary is unclear;
- an unresolved consequential decision would affect implementation;
- evidence cannot be produced;
- a required authority document is missing.

Claude must not resolve such conditions by silently guessing.

---

## 32. Phase Directory Policy

Initially:

```text
docs/phases/
├── README.md
├── phase-0-product-and-secure-engineering-foundation.md
└── evidence/
    └── phase-0/
```

Do not create empty placeholder phase documents.

A phase document should be created when its authoritative content is sufficiently defined.

---

## 33. Phase Review

Review this governance document when:

- phase lifecycle changes;
- phase dependency semantics change;
- phase completion rules change;
- ADR gates change;
- Claude decision authority changes.

Do not modify it for ordinary task-level implementation changes.

---

## 34. Governing Principle

The phase system preserves this invariant:

> **Phases execute accepted decisions; they may investigate unresolved decisions, but they do not accept consequential architecture.**

And:

> **Claude Code assists with exploration, planning, implementation, and verification; it does not possess architectural decision authority.**
