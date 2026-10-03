# Sentinel AI — Product Scope

**File:** `docs/product/product-scope.md`  
**Status:** Proposed  
**Owner:** Product / Engineering  
**Authority:** Product purpose and scope

## 1. Product Purpose

Sentinel AI is an engineering assurance platform designed to help teams detect, understand, remediate, validate, and continuously monitor software quality and operational risks.

The platform initially focuses on Accessibility Sentinel and is designed to extend into:

1. Accessibility Sentinel
2. Data Quality Sentinel
3. Incident Sentinel

The three capabilities share an engineering platform while retaining explicit domain boundaries.

## 2. Initial Product Focus

The initial vertical slice is Accessibility Sentinel.

The initial workflow is:

```text
Register website
    ↓
Create audit
    ↓
Execute browser-based checks
    ↓
Run deterministic accessibility checks
    ↓
Collect observations/findings
    ↓
Collect evidence
    ↓
Analyse findings
    ↓
Propose remediation
    ↓
Validate remediation
    ↓
Monitor continuously
```

## 3. Product Principles

Sentinel AI should:

- prefer deterministic evidence over unsupported inference;
- preserve evidence provenance;
- distinguish findings from explanations;
- distinguish correlation from causation;
- treat AI output as untrusted;
- require human approval for consequential changes;
- expose uncertainty;
- support reproducibility;
- provide traceability from finding to evidence and remediation.

## 4. Product Boundaries

Sentinel AI is not:

- a replacement for human accessibility expertise;
- an automatic legal compliance certification authority;
- an autonomous production deployment system;
- an authoritative source of truth based solely on an LLM;
- a microservice platform by default.

## 5. Users

The initial product is intended for engineering and quality-focused users who need repeatable evidence about software quality and operational risks.

Detailed personas and workflows belong in `user-stories.md`.

## 6. Domain Boundaries

### Accessibility Sentinel

Focuses on web accessibility auditing, findings, evidence, standards mapping, remediation, validation, and monitoring.

### Data Quality Sentinel

Focuses on data quality checks, contracts, anomalies, validation, and AI-assisted investigation.

### Incident Sentinel

Focuses on operational signals, incident investigation, correlation, evidence, and response assistance.

These domains must remain logically isolated.

## 7. Product Non-Goals

The product does not initially attempt to:

- replace human judgment;
- establish legal compliance solely through automated scanning;
- autonomously modify and deploy production software;
- support every cloud provider at initial release;
- implement every future Sentinel domain before the initial vertical slice is validated.
