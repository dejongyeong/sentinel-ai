# Sentinel AI — Security Architecture

**File:** `docs/architecture/security-architecture.md`  
**Status:** Proposed  
**Authority:** Security architecture

## 1. Security Principle

Security is a cross-phase engineering concern.

Controls are introduced with the capabilities they protect and strengthened during dedicated security hardening.

## 2. Authorization

Authorization is evaluated at application use-case entry.

Default posture:

```text
Deny
  ↓
Explicit authorization
  ↓
Allow
```

## 3. Worker Security

Workers are not trusted merely because they are internal.

Worker execution must establish an execution principal and satisfy applicable authorization rules.

## 4. AI Security

AI output is untrusted.

AI-generated output must not bypass:

- schema validation;
- authorization;
- deterministic verification;
- human approval where required.

## 5. Secrets

Secrets must not be committed to source control.

Development and deployment mechanisms must use appropriate secret-management mechanisms.

## 6. Layered Security Model

This section is the single authoritative layered security model. Other documents reference it rather than redefining it.

| Layer                              | Purpose                                                                       | Controls                                                                                         | Enforcement point                                         | Security boundary? | Blocking or advisory |
| ---------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------- | ------------------ | -------------------- |
| 1. Claude Code guardrails          | Reduce the chance of destructive or control-bypassing actions by the AI assistant | `.claude/settings.json` permission deny rules; PreToolUse hook `.claude/hooks/block-dangerous-command.sh` | Claude Code tool invocation on a developer workstation    | No                 | Blocking for matched commands; bypassable outside Claude Code |
| 2. Developer pre-commit            | Catch secrets before they enter local history                                 | `.pre-commit-config.yaml` (Gitleaks hook)                                                        | Local `git commit`                                        | No                 | Blocking locally; bypassable by the developer |
| 3. CI security checks              | Detect secrets independently of local hooks                                   | `.github/workflows/security.yml` (Gitleaks action)                                               | Hosted CI on push to `main`, pull request, manual dispatch | Detective only    | Advisory unless layer 4 requires it |
| 4. Repository protection           | Prevent merging changes that fail required security checks                    | Branch protection / required status checks on the repository host                                | Repository host merge into protected branches             | Yes (repository)   | Blocking             |
| 5. Runtime / application security  | Protect the running system and its data                                      | Application-level authorization (§2), worker principal (§3), AI trust controls (§4), secret management (§5) | Application use-case entry and runtime infrastructure | Yes (application)  | Blocking             |

Rules:

- Layers 1 and 2 are convenience and workflow controls. They are never the security boundary and never substitute for layers 3–5.
- CI scanning (layer 3) is separate from repository protection (layer 4). CI detects; repository protection enforces at merge time.
- Layer 4 status: not configured. The repository has no remote yet. Configuration and verification are required before Phase 0 can be Complete (see the Phase 0 document).
- Gitleaks is the secret-detection tool for layers 2 and 3. The selected version is recorded in `docs/decisions/decision-register.md`.

## 7. Secret Policy

A Gitleaks allowlist must never be used to suppress a confirmed real secret.

A suspected secret requires investigation.

The authoritative response procedure for an exposed secret is `docs/security/secret-incident-response.md`.

Git history rewriting must not be automated as a default remediation.

## 8. Security Documentation

Detailed security procedures belong in:

`docs/security/`

## 9. Security Hardening

Phase 19 performs systematic security hardening and verification.

Phase 19 does not represent the first point at which security exists.
