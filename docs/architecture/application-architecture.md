# Sentinel AI — Application Architecture

**File:** `docs/architecture/application-architecture.md`  
**Status:** Proposed  
**Authority:** Application architecture

## 1. Layers

### API

Responsible for:

- HTTP transport;
- request parsing;
- authentication integration;
- response serialization;
- OpenAPI generation.

### Application

Responsible for:

- use cases;
- authorization entry;
- orchestration;
- transaction boundaries;
- application policies;
- idempotency coordination.

### Domain

Responsible for:

- business concepts;
- domain rules;
- domain state transitions;
- domain invariants.

### Platform

Responsible for:

- persistence infrastructure;
- cache;
- queues;
- external providers;
- telemetry;
- storage;
- other technical capabilities.

## 2. Dependency Rules

```text
API → Application
Application → Domain / Platform
Domain → Domain-local abstractions
Platform → technical infrastructure
```

Domains must not import other domains.

Platform must not import domains or application.

## 3. Authorization

Authorization occurs at application use-case entry.

Authentication establishes identity.

Authorization determines whether the principal may execute the use case.

## 4. Transactions

Transaction boundaries should be owned by application use cases unless an explicit architectural decision establishes another pattern.

## 5. Error Handling

Errors should preserve enough context for clients and observability without exposing secrets or unnecessary internal implementation details.

## 6. Workers

Workers execute application use cases.

A worker is an execution mechanism, not a replacement for the Application layer.
