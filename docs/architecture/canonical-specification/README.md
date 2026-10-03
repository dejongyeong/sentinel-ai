# Sentinel AI — Canonical Specification History

**File:** `docs/architecture/canonical-specification/README.md`  
**Status:** Proposed  
**Owner:** Engineering  
**Scope:** Governance of Sentinel AI Canonical Engineering Specification versions

## 1. Purpose

This directory contains the versioned Canonical Engineering Specification for Sentinel AI.

The Canonical Engineering Specification defines the accepted architectural and engineering baseline against which implementation, architecture documentation, ADRs, phase execution, and verification are evaluated.

It is intentionally narrower than the complete project documentation set.

It does **not** replace:

- Product requirements
- User stories
- Product acceptance criteria
- Architecture documentation
- ADRs
- Phase execution documents
- Security procedures
- AI evaluation methodology
- Operational runbooks
- Claude Code instructions

Those documents retain their subject-specific authority as defined by:

`docs/architecture/documentation-authority.md`

## 2. Authority Rule

Exactly one Canonical Engineering Specification version has status `Accepted`.

That version is the current canonical baseline.

A version's `Accepted` status must be backed by an entry in `docs/architecture/acceptance-register.md`.

Historical versions are immutable.

A later version must not silently rewrite historical architectural decisions.

## 3. Current Version

| Version | Status     | Role                                                                         |
| ------- | ---------- | ---------------------------------------------------------------------------- |
| v0.3    | Accepted   | Current canonical engineering baseline                                       |
| v0.2    | Historical | Status-only record; original source unavailable; content not reproduced     |
| v0.1    | Historical | Status-only record; original source unavailable; content not reproduced     |

### Current authority

`canonical-specification-v0.3.md`

## 4. Version Statuses

Canonical specification versions use:

- `Draft` — working material; not authoritative.
- `Proposed` — ready for review; not authoritative.
- `Accepted` — current authoritative baseline.
- `Superseded` — previously accepted but replaced by a later accepted version; its content is preserved.
- `Historical` — a status-only record of a superseded version whose original source is unavailable; non-authoritative.

Exactly one version is `Accepted` at a time.

## 5. Versioning Rules

Create a new version when an accepted architectural baseline changes materially.

The process is:

1. Identify the proposed change.
2. Identify affected requirements, architecture, ADRs, and phases.
3. Analyse compatibility and consequences.
4. Critique alternatives.
5. Create or update the relevant ADR.
6. Obtain the required human architectural decision.
7. Draft the next canonical specification version.
8. Explicitly document changes from the previous version.
9. Check for contradictions with authoritative documentation.
10. Accept the new version.
11. Mark the previous version `Superseded`.
12. Update references to the current version.
13. Preserve the previous version unchanged.

## 6. Historical Immutability

Historical specification files must not be edited to reflect later decisions.

If a historical file contains an error, the correction process must preserve the original record and document the correction separately.

Historical documents must never be rewritten merely to make them agree with the current architecture.

### Status-only historical records

When the original source of a superseded version is unavailable, its file is a status-only record with status `Historical`. It contains only:

- version;
- historical status;
- superseded-by (and supersedes, where known);
- a statement that the original source is unavailable;
- a statement that the original normative content is not reproduced;
- a statement that the record is non-authoritative.

Reconstructed or paraphrased normative content must not be presented in place of an unavailable original.

## 7. Relationship to ADRs

ADRs record individual consequential architectural decisions.

The Canonical Engineering Specification records the resulting overall accepted engineering baseline.

An accepted ADR that changes the canonical baseline requires a corresponding canonical specification update.

Neither document should silently contradict the other.

The relationship is:

```text
Architectural question
        ↓
Analysis / alternatives
        ↓
ADR
        ↓
Human decision
        ↓
Canonical specification update
        ↓
Implementation
        ↓
Verification
```

## 8. Relationship to Phase Documents

Phase documents execute against the current canonical specification.

A phase must not silently introduce a new architectural baseline.

If implementation exposes an architectural gap:

1. identify the gap;
2. analyse it;
3. critique alternatives;
4. create/update an ADR;
5. obtain the architectural decision;
6. update the canonical specification if required;
7. update affected phase documentation;
8. implement;
9. verify.

## 9. Review Gate

Before beginning consequential work in a phase, Claude Code and engineers should verify:

- current canonical specification version;
- relevant accepted ADRs;
- authoritative product requirements;
- authoritative architecture documents;
- relevant security documentation;
- relevant phase document;
- unresolved/deferred decisions.

## 10. Files

The directory should contain only actual canonical specification versions and this governance README.

Expected structure:

```text
docs/architecture/canonical-specification/
├── README.md
├── canonical-specification-v0.1.md
├── canonical-specification-v0.2.md
└── canonical-specification-v0.3.md
```

Empty placeholder versions must not be created.

A status-only historical record (§6) is not a placeholder: it records a real superseded version whose original source is unavailable.

## 11. Non-Authority Documents

A document outside this directory must not describe itself as the Canonical Engineering Specification unless explicitly designated as such.

Summaries may reference canonical decisions but must not redefine them.

## 12. Change Control

Changes to this README are appropriate only when:

- canonical specification governance changes;
- versioning semantics change;
- authority rules change;
- the directory structure changes.

Routine architectural changes belong in the canonical specification and/or ADRs, not here.
