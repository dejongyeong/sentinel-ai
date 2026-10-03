# Sentinel AI — Architecture Decision Record Governance

**File:** `docs/decisions/README.md`  
**Status:** Accepted  
**Owner:** Engineering  
**Authority:** ADR process and index

## 1. Purpose

Architecture Decision Records document consequential architectural decisions.

An ADR explains **why** a decision was made, not merely what code was written.

## 2. When an ADR Is Required

An ADR is required when a decision materially affects one or more of:

- system architecture;
- data authority;
- trust boundaries;
- security boundaries;
- persistence strategy;
- API contract authority;
- asynchronous execution architecture;
- AI safety boundary;
- provider architecture;
- deployment architecture;
- cross-domain boundaries;
- significant operational characteristics.

## 3. When an ADR Is Not Required

An ADR is normally unnecessary for:

- routine implementation details;
- formatting choices;
- local refactors that preserve architecture;
- ordinary bug fixes;
- documentation corrections;
- implementation choices already explicitly determined by an accepted architecture.

## 3a. ADR Location

- ADR files live only under `docs/decisions/adr/`, named `ADR-NNNN-<kebab-title>.md`.
- The `docs/decisions/adr/` directory is created together with the first actual `Proposed` ADR. No placeholder file is created before then.
- This README is the sole ADR governance document and the sole ADR index.
- `docs/decisions/decision-register.md` is not an ADR. It records phase tooling selections, deferred decisions, architectural dependencies, and deferred governance improvements.

## 3b. Document Acceptance and ADR Decision Acceptance

These are two different records:

- `docs/architecture/acceptance-register.md` is authoritative for acceptance of governed project **documents**.
- An ADR's `## Status` section (status, acceptance authority, date) is authoritative for the lifecycle of the **architectural decision** it records.

ADR decision acceptance is not duplicated into the acceptance register. Only the project owner sets an ADR to `Accepted`, `Rejected`, or `Superseded`.

## 4. ADR Statuses

Valid statuses:

- `Proposed`
- `Accepted`
- `Rejected`
- `Superseded`

### Proposed

Decision is under consideration.

### Accepted

Decision is the current accepted architectural decision.

### Rejected

Decision was considered but not selected.

### Superseded

Decision was previously accepted and replaced by another decision.

### Recording ADR acceptance

An ADR's decision lifecycle is recorded in the ADR itself: its `## Status` section names the status, the acceptance authority, and the date (§3b). ADRs are not entered in `docs/architecture/acceptance-register.md`.

A `Proposed` ADR is not an accepted architectural decision. Implementation must not treat a proposed ADR as accepted.

## 5. ADR Lifecycle

```text
Question
  ↓
Context
  ↓
Options
  ↓
Analysis
  ↓
Decision
  ↓
Consequences
  ↓
Human acceptance
  ↓
Implementation
  ↓
Verification
```

## 6. Required ADR Structure

Each ADR should contain:

```text
# ADR-NNNN — Title

## Status
## Context
## Decision Drivers
## Options Considered
## Decision
## Consequences
## Security Implications
## Operational Implications
## Alternatives Rejected
## Related Requirements
## Related Architecture
## Related Phases
## Verification
```

Sections may be omitted only when genuinely not applicable.

## 7. Human Decision Authority

Claude Code may:

- research;
- analyse;
- critique;
- identify trade-offs;
- draft ADRs;
- propose a decision.

Claude Code must not silently convert a proposed architectural decision into an accepted one.

ADR drafting uses the `adr` Skill (`/adr`, `.claude/skills/adr/SKILL.md`). It is user-invoked only and stops at `Proposed`. Claude Code may state that an ADR appears necessary and recommend `/adr`, but does not invoke it.

## 8. ADR and Canonical Specification

An accepted ADR that changes the accepted engineering baseline requires the Canonical Engineering Specification to be updated.

The ADR records the decision.

The canonical specification records the resulting baseline.

## 9. ADR and Phase Governance

A phase must not implement an unresolved consequential architecture decision as though it were accepted.

If the phase exposes an architectural gap:

```text
Pause
→ Analyse
→ ADR
→ Human decision
→ Update authority
→ Resume implementation
```

## 10. ADR Index

This README is the sole ADR index. Other documents reference it rather than copying it.

| ADR      | Title                                    | File                | Status           |
| -------- | ---------------------------------------- | ------------------- | ---------------- |
| ADR-0001 | Modular Monolith                         | —                   | Not yet written  |
| ADR-0002 | Database Ownership and Persistence       | —                   | Not yet written  |
| ADR-0003 | Application / Domain / Platform Boundaries | —                 | Not yet written  |
| ADR-0004 | Redis Role                               | —                   | Not yet written  |
| ADR-0005 | Background Job Architecture              | —                   | Not yet written  |
| ADR-0006 | Authorization Architecture               | —                   | Not yet written  |
| ADR-0007 | Observability Architecture               | —                   | Not yet written  |
| ADR-0008 | AI Architecture                          | —                   | Not yet written  |
| ADR-0009 | Retrieval Architecture                   | —                   | Not yet written  |
| ADR-0010 | Standards Versioning                     | —                   | Not yet written  |
| ADR-0011 | Evidence and Provenance                  | —                   | Not yet written  |
| ADR-0012 | AI Remediation Safety Boundary           | —                   | Not yet written  |
| ADR-0013 | Cloud Provider                           | —                   | Not yet written  |
| ADR-0014 | CI/CD Deployment Strategy                | —                   | Not yet written  |

"Not yet written" is not an ADR status. It means no ADR file exists. Planned numbers are reserved but carry no decision.

When an ADR file exists, its row's `File` column shows `docs/decisions/adr/ADR-NNNN-<kebab-title>.md` and its `Status` column matches the ADR's `## Status`. The index and the files under `docs/decisions/adr/` must agree.

### Retrospective ADRs for the accepted baseline

ADR-0001 to ADR-0004 would document decisions already contained in the current Accepted canonical specification. Retrospective ADRs for such decisions are optional, are created only where useful, and are not a phase completion gate merely because they restate the accepted baseline.

### Phase ADR gates

Phase ADR gates are operationalized by each phase document under the canonical specification's ADR rule (current Accepted version, §29) and `docs/phases/README.md` §21. The Phase 0 gate is defined in the Phase 0 document.

## 11. ADR Numbering

ADR numbers are unique and never reused.

A rejected or superseded ADR remains part of the architectural history.

Allocation:

1. Inspect both the index (§10) and the files under `docs/decisions/adr/`.
2. If they disagree — a file without an index row, an index row naming a missing file, a duplicate number, a number used for two titles — or the matching reserved entry is ambiguous, stop. Allocation resumes only after the discrepancy is resolved.
3. Otherwise, use the reserved number whose index title matches the decision; if none matches, use the next unused number after the highest number in either the index or the filesystem.

## 12. ADR Quality Criteria

An ADR should make it possible for a future engineer to determine:

- what problem existed;
- what constraints mattered;
- what alternatives were considered;
- what was selected;
- why;
- what consequences were accepted;
- what evidence or later ADR could change the decision.

## 13. No Silent Decisions

The following must not silently become architectural decisions:

- phase task implementation;
- README statements;
- source comments;
- tests;
- examples;
- Claude Code prompts;
- Skills;
- Agents;
- Hooks.

If they reveal a required architectural decision, the decision process must be initiated.
