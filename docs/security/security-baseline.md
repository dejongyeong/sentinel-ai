# Sentinel AI — Security Baseline

**File:** `docs/security/security-baseline.md`  
**Status:** Proposed  
**Owner:** Engineering  
**Authority:** Phase 0 minimum security controls and secret-handling expectations

## 1. Purpose

Define the minimum security controls required before application implementation proceeds.

The layered security model (which layer does what, and which layers are security boundaries) is defined only in `docs/architecture/security-architecture.md` §6. This document does not redefine it.

## 2. Security Principles

Sentinel AI follows:

- deny by default;
- least privilege;
- explicit authorization;
- defense in depth;
- fail closed where practical;
- secrets never committed;
- untrusted external input;
- untrusted AI output;
- independent CI enforcement;
- auditable security decisions.

## 3. Secret Management

Never commit:

- API keys;
- passwords;
- tokens;
- private keys;
- cloud credentials;
- production credentials.

Use placeholders in:

- documentation;
- examples;
- fixtures.

## 4. Secret Detection

Gitleaks is used for repository secret detection, at the developer pre-commit layer and the CI layer of the layered model (`docs/architecture/security-architecture.md` §6).

Local checks are not sufficient. CI scanning and repository protection are separate layers.

The selected Gitleaks version and pre-commit hook set are recorded in `docs/decisions/decision-register.md`.

## 5. Gitleaks Findings

Every finding must be investigated.

The response procedure is `docs/security/secret-incident-response.md`.

Never suppress a confirmed secret with an allowlist.

## 6. Authorization

Authorization is evaluated at application use-case entry (`docs/architecture/security-architecture.md` §2).

Internal workers are not implicitly trusted.

## 7. AI Security

AI output is untrusted (`docs/architecture/security-architecture.md` §4).

## 8. Security Exceptions

An exception requires:

- explicit reason;
- affected control;
- scope;
- expiration/review condition;
- owner;
- documentation.

Permanent broad bypasses are prohibited.

## 9. Phase 0 Minimum Controls

Before Phase 0 completion:

- `.gitignore` exists;
- Gitleaks is configured for pre-commit and CI;
- the Gitleaks positive control detects a synthetic credential;
- CI secret scanning has executed on the repository host;
- repository protection requires the CI security check;
- no real secrets are committed;
- security documentation exists;
- Claude Code security Rules and guardrails exist.

The verification of these controls is defined by the Phase 0 document.
