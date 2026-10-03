# Sentinel AI — System Context

**File:** `docs/architecture/context.md`  
**Status:** Proposed  
**Authority:** System context

## 1. Context

Sentinel AI provides engineering assurance capabilities through a web application, API, asynchronous execution, deterministic analysis, AI-assisted analysis, and persistent evidence.

## 2. External Actors

Primary actors include:

- engineering users;
- administrators;
- automated systems invoking supported APIs.

## 3. External Systems

Potential external systems include:

- browser/runtime infrastructure;
- LLM providers;
- embedding providers;
- notification providers;
- object storage;
- cloud infrastructure.

Specific providers remain subject to relevant ADRs.

## 4. Logical System Boundary

The canonical request path is:

```text
Client (Next.js web UI, or another API client)
        │
        ▼
FastAPI API boundary
        │
        ▼
Application
        │
        ▼
Domain / Platform
```

Next.js is the web/UI layer. It is one client of the FastAPI API boundary; other supported API clients call the same boundary directly. API clients are not required to route through Next.js.

Logical components behind the API boundary:

```text
FastAPI API
        │
        ▼
Sentinel AI Application
        │
        ├── Accessibility
        ├── Data Quality
        └── Incident
        │
        ├── PostgreSQL
        ├── Redis
        ├── Queue / Worker
        ├── AI Infrastructure
        ├── Observability
        └── External Systems
```

This document does not introduce a backend-for-frontend or proxy layer.

## 5. Trust Boundaries

Important trust boundaries include:

- user → web application;
- web application → API;
- external API client → API;
- API → application;
- application → infrastructure;
- application → external providers;
- AI output → application;
- worker → application;
- evidence artifact → evidence metadata.

All external and AI-generated data must be treated as untrusted until validated.
