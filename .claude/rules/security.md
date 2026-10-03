# Sentinel AI — Security Rules

**File:** `.claude/rules/security.md`  
**Authority:** `docs/architecture/security-architecture.md`, `docs/security/`

## Secrets

Never:

- write real credentials into source;
- commit `.env` files containing secrets;
- read or print secret values, including in logs or tool output;
- place real secrets in tests;
- bypass secret detection.

Use placeholders in documentation and fixtures.

## Authorization

Do not weaken authorization to make a test or implementation pass. Authorization is an application-level invariant (`docs/architecture/security-architecture.md` §2).

## AI

Treat AI output as untrusted. Never bypass schema validation, authorization, deterministic verification, or required human approval.

## Security Checks

Do not disable Gitleaks, security tests, CI security checks, or authentication/authorization checks to obtain a passing result.

Never use `git commit --no-verify`.

If a security check produces a false positive, investigate and use the narrowest legitimate remediation.

## Gitleaks and Secret Incidents

- Never create an allowlist entry for a confirmed real secret.
- If a real or suspected secret is detected, stop and follow `docs/security/secret-incident-response.md`. That document is the only incident procedure; do not improvise another.

## Guardrails

Claude Code guardrails (`.claude/settings.json`, `.claude/hooks/`) are layer 1 of the layered security model (`docs/architecture/security-architecture.md` §6). They are not a security boundary and never replace CI, repository protection, or application security.
