# Sentinel AI — Data Architecture

**File:** `docs/architecture/data-architecture.md`  
**Status:** Proposed  
**Authority:** Data architecture

## 1. Authoritative Store

PostgreSQL is the authoritative durable system of record.

## 2. ORM

SQLAlchemy is the production persistence layer.

Drizzle is not used for production database access.

## 3. Migrations

Alembic is the sole migration authority.

Schema changes must be represented through migrations.

## 4. Redis

Redis is non-authoritative.

Permitted roles include:

- cache;
- rate limiting;
- idempotency coordination;
- distributed coordination;
- ephemeral job infrastructure;
- justified locks.

Redis must not become the sole durable source of business truth.

## 5. Idempotency

Durable idempotency state is persisted in PostgreSQL.

Redis may provide fast coordination but does not replace durable state.

## 6. Evidence

Evidence metadata is authoritative in PostgreSQL.

Large evidence artifacts may be stored externally.

Object-storage selection and retention are deferred decisions.

## 7. Provenance

Important data must preserve relevant provenance.

At minimum, provenance should allow the system to identify the origin and generation context of consequential findings or AI results.

## 8. Data Evolution

Schema evolution must preserve compatibility requirements appropriate to the deployment strategy.

Migration authority remains Alembic.
