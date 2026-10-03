# Sentinel AI — System Architecture

**File:** `docs/architecture/system-architecture.md`  
**Status:** Proposed  
**Authority:** System architecture

## 1. Architecture Style

Sentinel AI uses a modular monolith initially.

The platform is intentionally structured so that technical boundaries remain explicit even while deployed as a single logical application.

## 2. Primary Components

The repository topology below is an implementation-level architecture convention owned by this document. It is not a cross-cutting canonical invariant. If a topology choice becomes a consequential architectural decision, it requires an ADR at that point (see `docs/architecture/documentation-authority.md` §3).

```text
apps/web
services/api
services/application
services/domains
services/sentinel_platform
services/worker
services/migrations
```

## 3. Dependency Direction

```text
Web
 ↓
API
 ↓
Application
 ↓
Domain / Platform
```

Workers follow:

```text
Worker
 ↓
Application
 ↓
Domain / Platform
```

Domains do not depend on one another.

Platform does not depend on domains or application.

## 4. Persistence

PostgreSQL is authoritative.

SQLAlchemy is the production persistence layer.

Alembic is the migration authority.

## 5. API

FastAPI/OpenAPI is the API contract authority.

Generated TypeScript clients consume the API contract.

## 6. Asynchronous Work

Asynchronous execution is mediated through the Application layer.

Workers must not bypass application use cases.

Queue technology remains an explicit unresolved decision until the relevant ADR is accepted.

## 7. External Providers

External providers must be isolated behind platform/application boundaries.

Provider-specific implementation must not leak throughout domain logic.

## 8. Architecture Evolution

Microservices are not introduced unless justified through an accepted ADR.
