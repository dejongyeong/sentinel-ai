# Sentinel AI — User Stories

**File:** `docs/product/user-stories.md`  
**Status:** Proposed  
**Owner:** Product / Engineering  
**Authority:** User stories

Each story lists the requirement identifiers it traces to (`docs/product/requirements.md`). Traceability chain: US → REQ → AC → Phase Task → Evidence.

## 1. Accessibility Auditor

### US-ACCESS-001 — Register a website

As an engineering user, I want to register a website so that Sentinel AI can audit it.

Traces: REQ-ACCESS-001

### US-ACCESS-002 — Start an audit

As an engineering user, I want to start an accessibility audit so that I can obtain evidence about accessibility issues.

Traces: REQ-ACCESS-002, REQ-ACCESS-003

### US-ACCESS-003 — Review findings

As an engineering user, I want to review deterministic accessibility findings so that I can understand what was detected.

Traces: REQ-ACCESS-004, REQ-ACCESS-005

### US-ACCESS-004 — Inspect evidence

As an engineering user, I want to inspect evidence associated with a finding so that I can validate the reported issue.

Traces: REQ-ACCESS-006

### US-ACCESS-005 — Understand standards mapping

As an engineering user, I want findings mapped to relevant accessibility requirements so that I can understand the applicable standard.

Traces: REQ-ACCESS-007

### US-ACCESS-006 — Receive AI assistance

As an engineering user, I want AI assistance to explain findings and propose remediation so that I can investigate issues more efficiently.

Traces: REQ-ACCESS-008, REQ-ACCESS-009

### US-ACCESS-007 — Validate remediation

As an engineering user, I want remediation to be re-tested so that I can determine whether the detected issue was resolved.

Traces: REQ-ACCESS-010

### US-ACCESS-008 — Monitor continuously

As an engineering user, I want recurring audits so that I can identify regressions.

Traces: REQ-ACCESS-011

## 2. Engineering Safety

### US-SAFETY-001 — Review consequential AI changes

As an engineering user, I want consequential AI-generated changes to require human approval so that automation does not silently modify production behaviour.

Traces: REQ-PLATFORM-007

### US-SAFETY-002 — Trace results

As an engineering user, I want important results to retain provenance so that I can understand how they were produced.

Traces: REQ-PLATFORM-002

## 3. Future Domains

Future Data Quality and Incident workflows must be introduced through domain-specific stories rather than expanding this document with implementation details.
