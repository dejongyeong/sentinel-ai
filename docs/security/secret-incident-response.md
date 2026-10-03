# Sentinel AI — Secret Incident Response

**File:** `docs/security/secret-incident-response.md`  
**Status:** Proposed  
**Owner:** Engineering  
**Authority:** The single authoritative procedure for responding to a detected or suspected secret

Other documents (Claude Rules, security architecture, security baseline, phase documents) reference this procedure and must not maintain their own copies.

## 1. Triage

1. Treat every Gitleaks finding or reported exposure as a suspected secret until investigated.
2. Determine whether the value is a real credential, a test fixture, or a false positive.
3. Never print, paste, or log the suspected value. Use redacted output (`--redact`).

## 2. Confirmed Real Secret

Perform these steps in order:

1. **Stop distribution.** Do not commit, push, or share the affected content further.
2. **Revoke or rotate** the credential with its issuer.
3. **Assess exposure:** where the value was visible (local only, pushed branch, CI logs, artifacts, forks) and for how long.
4. **Investigate repository history** to find every commit and location that contains the value.
5. **Remove the active exposure** from current source and artifacts.
6. **Establish regression protection** (for example, a detection rule or test) so the same exposure is caught again.
7. **Document the incident** where appropriate, without including the secret value.

Git history rewriting is not an automated default remediation. It requires an explicit human decision, because revocation (step 2), not history rewriting, is what neutralizes the credential.

## 3. False Positives and Test Fixtures

- A confirmed real secret is never allowlisted.
- A false positive is resolved by the narrowest legitimate mechanism. Every allowlist entry in `.gitleaks.toml` documents why the value is not a secret, why narrower detection is not possible, its owner or reviewer, and its review condition.
- Synthetic test credentials used by verification controls are generated at runtime outside the repository and are never committed or allowlisted.

## 4. Related Authority

- Layered security model: `docs/architecture/security-architecture.md` §6.
- Secret policy: `docs/architecture/security-architecture.md` §7.
