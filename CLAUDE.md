# Sentinel AI — Claude Code Project Context

**File:** `CLAUDE.md`

## Project

Sentinel AI is a modular-monolith engineering assurance platform.

- Initial domain: Accessibility Sentinel.
- Planned domains: Data Quality Sentinel, Incident Sentinel.

Phase 0 (governance and secure engineering foundation) contains no application code.

## Repository Structure

```text
.claude/            Claude Code rules, skills, reviewer agents, hooks, settings
.github/workflows/  CI (security.yml: independent secret scanning)
docs/architecture/  documentation authority, canonical specification, architecture, acceptance register
docs/product/       scope, requirements, user stories, acceptance criteria, roadmap
docs/decisions/     ADR governance and index, decision register; adr/ holds ADR files (created with the first ADR)
docs/phases/        phase governance, phase documents, evidence/<phase>/
docs/security/      security baseline, secret-incident response
docs/operations/    developer workflow, Claude Code prompt standard
scripts/            verify-phase.sh and checks/ (deterministic verification)
```

## Authority

Before consequential work, consult:

1. `docs/architecture/documentation-authority.md`
2. `docs/architecture/canonical-specification/README.md`, which identifies the current Accepted canonical specification
3. that canonical specification
4. the relevant product, architecture, and security authority documents
5. relevant Accepted ADRs (`docs/decisions/README.md`)
6. the relevant phase document

Do not create competing sources of truth. Do not hard-code a canonical specification version in this file.

Status models are subject-specific (documentation-authority §22). `Accepted` requires an entry in `docs/architecture/acceptance-register.md`, recorded only by the project owner.

## Commands

See `docs/operations/developer-workflow.md` for the full list.

```bash
pre-commit run --all-files                 # local hooks (Gitleaks)
gitleaks dir . --redact                    # working-tree secret scan
scripts/checks/claude-guardrails.sh        # Claude Code guardrail tests
scripts/checks/gitleaks-controls.sh        # Gitleaks negative/positive controls
scripts/checks/pre-commit-controls.sh      # pre-commit controls (temporary repositories)
python scripts/checks/repo_snapshot.py capture   # working-tree snapshot (stdout only)
scripts/verify-phase.sh phase-0 --baseline <snapshot.json>   # deterministic phase checks
```

User-invoked Skills (never run automatically): `/commit` (one local commit from confirmed paths, pre-commit preflight, no push) and `/adr` (draft a Proposed ADR; never accepts).

Lint, format, test, and type-check commands do not exist until Phase 1 defines the toolchain.

## Critical Architecture Invariants

Summarized from the current Accepted canonical specification; `.claude/rules/architecture.md` lists them with section references.

- Modular monolith first.
- PostgreSQL is the authoritative durable system of record; SQLAlchemy is the production persistence layer; Alembic is the migration authority.
- FastAPI/OpenAPI is the API contract authority.
- Next.js does not directly access PostgreSQL, Redis, queues, LLM providers, or internal infrastructure credentials.
- Application use cases own orchestration and authorization entry.
- Domains do not import other domains; Platform does not import Application or Domains.
- Workers execute Application use cases.
- Redis is non-authoritative; durable idempotency state belongs in PostgreSQL.
- Deterministic checks occur before AI analysis where applicable; AI output is untrusted.
- Consequential AI-generated repository changes require human approval.
- Security, testing, observability, and documentation are cross-phase concerns.

## Decision Authority

Claude Code may inspect, analyse, critique, propose, implement, test, verify, and document evidence. It may not treat a proposed decision as accepted, and it never records acceptance.

Distinguish: fact, assumption, proposal, accepted decision, implementation, verification.

If a consequential decision is unresolved: stop, explain it, identify alternatives, follow the ADR process (`docs/decisions/README.md`), and resume only when the decision is accepted.

A phase document may operationalize an accepted decision but may not create one.

## Workflow

For non-trivial work: explore → plan → implement → test → verify → report evidence. Inspect before modifying. Avoid unrelated changes. Prompt structure: `docs/operations/claude-code-prompt-standard.md`.

## Verification

- Never claim success without executed evidence. A file existing is not evidence that an activity occurred.
- Verification results are only `PASS`, `FAIL`, `BLOCKED`, `NOT APPLICABLE`; `STOP` is a process action.
- Phase verification is run explicitly through the `phase-verification` Skill, only when the owner authorizes it.
- Distinguish Implemented, Verified, Accepted, and Complete.

## Security

Constraints are in `.claude/rules/security.md`. Secret incidents follow `docs/security/secret-incident-response.md`. Never commit secrets, bypass authorization, disable security controls to pass a check, use `--no-verify`, or allowlist a real secret.

Claude Code guardrails are layer 1 of the layered security model (`docs/architecture/security-architecture.md` §6) and are not a security boundary.
