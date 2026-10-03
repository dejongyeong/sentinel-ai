---
name: documentation-review
description: Review Sentinel AI documentation for authority conflicts, ambiguity, duplicated normative requirements, stale architecture, status-model inconsistencies, and missing traceability.
when_to_use: Before or after documentation changes, or as part of a phase contradiction review.
---

# Documentation Review

## Purpose

Find documentation that conflicts with its authority, duplicates normative content, or breaks status and traceability rules.

## Invocation

On request, or as part of a phase review layer. This Skill reviews; it does not change authority.

## Inputs

- The documents under review.

## Authority Sources

1. `docs/architecture/documentation-authority.md` (authority table §4, status models §22, acceptance model §23)
2. `docs/architecture/acceptance-register.md`
3. `docs/phases/README.md`
4. `docs/decisions/README.md`

## Procedure

1. Identify the subject of each document and map it to its authoritative source.
2. Check that the document's status belongs to its category's status model, and that any `Accepted` claim has an acceptance-register entry.
3. Compare terminology; identify duplicated normative statements and contradictions.
4. Identify ambiguous requirements.
5. Check phase status and dependency semantics.
6. Check ADR and canonical-specification references, including hard-coded canonical versions in generic governance documents.
7. Check requirement → story → acceptance-criterion traceability.

## Constraints

- Do not resolve a consequential contradiction by guessing; escalate through the decision process.
- Do not create a second source of truth while recommending fixes.

## Verification

Each finding cites file and line evidence.

## Stopping Conditions

Stop and report when authority is contradictory or a required authority document is missing.

## Output

For each finding: document, finding, severity (blocking or non-blocking), evidence, recommended authority, remediation.

Blocking: conflicting authority, contradictory architecture or security rule, ambiguous requirement affecting implementation, missing required ADR, unbacked `Accepted` status.

Non-blocking: wording, navigation, explanatory duplication, formatting.
