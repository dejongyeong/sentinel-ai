# Sentinel AI — Product Acceptance Criteria

**File:** `docs/product/acceptance-criteria.md`  
**Status:** Proposed  
**Owner:** Product / Engineering  
**Authority:** Product-level acceptance criteria

## 1. Acceptance Rules

Acceptance criteria must be:

- observable;
- testable;
- unambiguous;
- traceable to a requirement or user story.

Traceability chain: US → REQ → AC → Phase Task → Evidence. Requirement and story text is not repeated here; criteria reference identifiers.

The phase task and verification evidence for each criterion are assigned when the implementing phase document is created. No product capability is implemented in Phase 0.

## 2. Accessibility

### AC-ACCESS-001

Given an authorized user has a registered website, when the user creates an audit, then the system persists an audit record containing an audit identifier, the registered-website identifier, the requesting principal's identifier, and a creation timestamp, and that record is retrievable by its audit identifier.

Traces: REQ-ACCESS-002, REQ-PLATFORM-001; US-ACCESS-002

### AC-ACCESS-002

Given an audit is executed, deterministic accessibility checks run before AI analysis.

Traces: REQ-ACCESS-004; US-ACCESS-003

### AC-ACCESS-003

Given a deterministic check produces a finding, the finding is persisted with the identifier of the audit and the identifier of the producing check.

Traces: REQ-ACCESS-005, REQ-PLATFORM-002; US-ACCESS-003

### AC-ACCESS-004

Given a finding has associated evidence, the user can retrieve the evidence through an authorized workflow.

Traces: REQ-ACCESS-006, REQ-PLATFORM-001; US-ACCESS-004

### AC-ACCESS-005

Given a finding is mapped to an accessibility requirement, the mapping references the authoritative standards model.

Traces: REQ-ACCESS-007; US-ACCESS-005

### AC-ACCESS-006

Given AI analysis is requested, AI output that fails schema or safety validation is rejected and is not stored as an authoritative result.

Traces: REQ-ACCESS-008, REQ-PLATFORM-006; US-ACCESS-006

### AC-ACCESS-007

Given remediation is proposed, validation can determine whether the relevant deterministic check still fails.

Traces: REQ-ACCESS-010; US-ACCESS-007

### AC-ACCESS-008

Given continuous monitoring is enabled, subsequent executions can be compared against prior results.

Traces: REQ-ACCESS-011; US-ACCESS-008

## 3. Security

### AC-PLATFORM-001

An unauthorized principal cannot successfully execute an operation requiring permissions the principal does not possess.

Traces: REQ-PLATFORM-001

## 4. Idempotency

### AC-PLATFORM-002

A duplicate request using the same idempotency scope does not create duplicate durable business results.

Traces: REQ-PLATFORM-003

## 5. Observability

### AC-PLATFORM-003

Given an asynchronous operation fails, a telemetry record exists that contains the operation identifier, a correlation identifier, a failure classification, and the failure timestamp, and that record can be retrieved for investigation.

Traces: REQ-PLATFORM-004

## 5a. AI Change Approval

### AC-PLATFORM-004

Given an AI-generated change classified as consequential and no recorded approval, when application, merge, or deployment of the change is requested, then the system does not perform it. When an authorized human approves the change, the system records the approver's identifier, the change identifier, and the approval timestamp before the change can be applied.

Traces: REQ-PLATFORM-007; US-SAFETY-001

## 6. Coverage

| Requirement     | Acceptance criteria                         |
| --------------- | ------------------------------------------- |
| REQ-ACCESS-001  | none yet                                    |
| REQ-ACCESS-002  | AC-ACCESS-001                               |
| REQ-ACCESS-003  | none yet                                    |
| REQ-ACCESS-004  | AC-ACCESS-002                               |
| REQ-ACCESS-005  | AC-ACCESS-003                               |
| REQ-ACCESS-006  | AC-ACCESS-004                               |
| REQ-ACCESS-007  | AC-ACCESS-005                               |
| REQ-ACCESS-008  | AC-ACCESS-006                               |
| REQ-ACCESS-009  | none yet                                    |
| REQ-ACCESS-010  | AC-ACCESS-007                               |
| REQ-ACCESS-011  | AC-ACCESS-008                               |
| REQ-PLATFORM-001 | AC-ACCESS-001, AC-ACCESS-004, AC-PLATFORM-001 |
| REQ-PLATFORM-002 | AC-ACCESS-003                              |
| REQ-PLATFORM-003 | AC-PLATFORM-002                            |
| REQ-PLATFORM-004 | AC-PLATFORM-003                            |
| REQ-PLATFORM-005 | none yet                                   |
| REQ-PLATFORM-006 | AC-ACCESS-006                              |
| REQ-PLATFORM-007 | AC-PLATFORM-004                            |

"None yet" records a coverage gap; criteria are added by the requirements owner, not by a phase document.

## 7. Evidence

Every accepted criterion must have recorded verification evidence before the relevant phase or release can be considered complete.
