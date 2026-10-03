---
name: architecture-review
description: Review Sentinel AI changes for architectural consistency, dependency boundaries, authority conflicts, ADR requirements, and violations of the canonical engineering baseline.
when_to_use: Before or after a change that touches architecture documents, layer or domain boundaries, persistence, API contracts, workers, authorization, or AI trust boundaries.
---

# Architecture Review

## Purpose

Determine whether a change is consistent with accepted architecture and whether it requires an ADR.

## Invocation

On request, or as part of a phase review layer. This Skill reviews; it does not approve architectural decisions.

## Inputs

- The changed files or the scope under review.
- Any related phase task.

## Authority Sources

1. `docs/architecture/documentation-authority.md`
2. The current Accepted canonical specification, resolved through `docs/architecture/canonical-specification/README.md`
3. `docs/architecture/*.md` architecture documents
4. Accepted ADRs indexed in `docs/decisions/README.md`

## Procedure

1. Read the authority sources.
2. Inspect the changed files.
3. Identify dependencies introduced or removed.
4. Check layer boundaries, domain isolation, persistence authority, authorization, worker/application boundaries, and AI trust boundaries.
5. Determine whether an ADR is required.
6. Classify each finding: architecture violation, documentation conflict, missing ADR, dependency violation, security boundary violation, or acceptable implementation detail.

## Constraints

- Do not approve a change solely because it works.
- Do not resolve a consequential contradiction by guessing.
- Do not treat a proposed decision as accepted.

## Verification

Each finding cites file and line evidence and the authority it is measured against.

## Stopping Conditions

Stop and report when authoritative documents conflict, an ADR is required but missing, or a boundary is ambiguous.

## Output

For each finding: severity, evidence, affected authority, ADR requirement, recommended remediation.
