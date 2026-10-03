# Sentinel AI — Claude Architecture Rules

**File:** `.claude/rules/architecture.md`  
**Authority:** `docs/architecture/documentation-authority.md`

## Purpose

These rules constrain Claude Code's engineering behaviour. They do not define architecture.

Authoritative sources, in order:

1. `docs/architecture/documentation-authority.md`
2. `docs/architecture/canonical-specification/README.md`, which identifies the current Accepted canonical specification
3. that canonical specification
4. `docs/architecture/{context,system-architecture,application-architecture,data-architecture,ai-architecture,security-architecture}.md`
5. Accepted ADRs indexed in `docs/decisions/README.md`

Section references (§) below refer to the current Accepted canonical specification.

## Mandatory Invariants

Preserve these accepted invariants. They summarize the canonical specification and do not replace it.

- Modular monolith unless an Accepted ADR changes it (§3).
- Next.js must not directly access LLM providers (§6).
- Next.js must not directly access PostgreSQL or internal domain persistence (§6).
- Next.js must not directly access Redis, job queues, or other internal infrastructure (§6).
- Next.js must not receive or use internal infrastructure credentials directly (§6).
- FastAPI/OpenAPI is the HTTP API contract authority; generated clients derive from it (§5).
- Application use cases own orchestration and authorization entry (§7, §13).
- Domains do not import other domains (§8). Platform does not import domains or the Application layer (§9).
- Workers execute application use cases and are not trusted merely because they are internal (§4, §14).
- PostgreSQL is the authoritative durable store; SQLAlchemy is the production persistence layer; Alembic is the sole migration authority (§10).
- Redis is non-authoritative; durable idempotency results belong in PostgreSQL (§11, §12).
- Deterministic analysis precedes AI analysis where applicable; AI output is untrusted (§16, §18).
- Consequential AI-generated repository changes require human approval before merge or deployment (§20).

## Before Architectural Changes

1. Inspect the relevant authoritative documents.
2. Identify the existing decision and the affected boundaries.
3. Determine whether an Accepted ADR exists or a new one is required.
4. Do not implement an unresolved consequential decision as though it were accepted.

## Stopping Conditions

Stop and report instead of guessing when:

- authoritative documents conflict;
- an ADR is required but missing;
- a security or dependency boundary is unclear;
- an unresolved architectural decision is encountered;
- implementation would violate an accepted invariant.

The decision process is defined in `docs/decisions/README.md` and `docs/architecture/documentation-authority.md` §6.
