# Sentinel AI — Documentation Authority

**File:** `docs/architecture/documentation-authority.md`  
**Status:** Accepted  
**Owner:** Engineering  
**Scope:** Repository-wide documentation governance

## 1. Purpose

This document defines which document owns each major subject in the Sentinel AI repository.

Its purpose is to prevent:

- conflicting specifications;
- duplicated normative requirements;
- architecture drift;
- contradictory phase documents;
- undocumented architectural decisions;
- Claude Code instructions becoming a competing specification;
- implementation details becoming accidental requirements;
- historical decisions being silently rewritten.

This document defines **documentation authority**.

It does not itself define product requirements or system architecture.

---

## 2. Core Authority Principle

Every major subject has one primary authoritative source.

A document may:

- reference another authoritative document;
- summarize an authoritative decision;
- explain consequences;
- provide implementation guidance;
- provide execution evidence.

A document must **not** silently redefine a subject owned by another authoritative document.

When a document needs to change an accepted decision, the appropriate authority and decision process must be used.

---

## 3. Subject-Specific Authority

Authority is subject-specific.

The current Canonical Engineering Specification is authoritative for the cross-cutting engineering baseline.

It is **not** a replacement for every subject-specific authority.

For example:

- `requirements.md` owns product requirements;
- `system-architecture.md` owns system architecture;
- an accepted ADR owns its individual architectural decision;
- a phase document owns execution governance for that phase.

The Canonical Engineering Specification establishes cross-cutting invariants that these documents must respect.

### Architecture layering of authority

- The canonical specification owns cross-cutting engineering invariants.
- `system-architecture.md` owns concrete system and repository topology. Topology described there is an implementation-level architecture convention unless it becomes a consequential decision.
- ADRs own consequential individual architectural decisions. If a topology choice becomes consequential, an ADR is created at that point.

---

## 4. Authority Table

| Subject                            | Primary authoritative source                                                                   |
| ---------------------------------- | ---------------------------------------------------------------------------------------------- |
| Product purpose and scope          | `docs/product/product-scope.md`                                                                |
| Product requirements               | `docs/product/requirements.md`                                                                 |
| User stories                       | `docs/product/user-stories.md`                                                                 |
| Product acceptance criteria        | `docs/product/acceptance-criteria.md`                                                          |
| Project roadmap and phase sequence | `docs/product/roadmap.md`                                                                      |
| System context                     | `docs/architecture/context.md`                                                                 |
| System architecture                | `docs/architecture/system-architecture.md`                                                     |
| Application architecture           | `docs/architecture/application-architecture.md`                                                |
| Data architecture                  | `docs/architecture/data-architecture.md`                                                       |
| AI architecture                    | `docs/architecture/ai-architecture.md`                                                         |
| Security architecture              | `docs/architecture/security-architecture.md`                                                   |
| Cross-cutting engineering baseline | Current `Accepted` version identified by `docs/architecture/canonical-specification/README.md` |
| Canonical specification governance | `docs/architecture/canonical-specification/README.md`                                          |
| Individual architectural decisions | `docs/decisions/adr/ADR-*.md`                                                                  |
| ADR decision lifecycle             | The ADR's own `## Status` section                                                              |
| ADR governance                     | `docs/decisions/README.md`                                                                     |
| Non-ADR decision and deferral record | `docs/decisions/decision-register.md`                                                        |
| Human acceptance of governed documents (not ADR decision acceptance) | `docs/architecture/acceptance-register.md`                   |
| Document status models             | This document, §22                                                                             |
| Phase execution governance         | `docs/phases/phase-*.md`                                                                       |
| Phase governance                   | `docs/phases/README.md`                                                                        |
| Phase verification evidence        | `docs/phases/evidence/` (location declared by `docs/phases/README.md`)                         |
| Security procedures                | `docs/security/`                                                                               |
| Secret-incident response procedure | `docs/security/secret-incident-response.md`                                                    |
| AI evaluation                      | `docs/ai/`                                                                                     |
| Accessibility domain documentation | `docs/accessibility/`                                                                          |
| Operational documentation          | `docs/operations/`                                                                             |
| Developer workflow commands        | `docs/operations/developer-workflow.md`                                                        |
| Commit message convention          | `docs/operations/developer-workflow.md` §5 (applied by the `commit` Skill, which is not its authority) |
| Claude Code prompt standard        | `docs/operations/claude-code-prompt-standard.md`                                               |
| Portfolio documentation            | `docs/portfolio/`                                                                              |
| Persistent Claude project context  | `CLAUDE.md`                                                                                    |
| Claude constraints                 | `.claude/rules/`                                                                               |
| Claude reusable procedures         | `.claude/skills/`                                                                              |
| ADR drafting procedure (procedure only; no decision authority) | `.claude/skills/adr/`                                              |
| Commit procedure (procedure only; no decision authority) | `.claude/skills/commit/`                                                 |
| Claude specialist contexts         | `.claude/agents/`                                                                              |
| Claude deterministic controls      | `.claude/hooks/`                                                                               |

---

## 5. Canonical Engineering Specification

The Canonical Engineering Specification is governed by:

`docs/architecture/canonical-specification/README.md`

The canonical-specification README identifies the single current version with status:

`Accepted`

The current Accepted version is authoritative for the cross-cutting engineering baseline.

This document must not hard-code a specific canonical specification version because the current version may change over time.

The current Accepted specification defines cross-cutting engineering invariants including:

- modular-monolith architecture;
- persistence authority;
- application/domain/platform boundaries;
- API contract authority;
- authorization boundaries;
- Redis role;
- idempotency;
- worker execution;
- evidence provenance;
- deterministic-before-AI processing;
- AI trust boundaries;
- standards/retrieval separation;
- human approval requirements;
- cross-phase security;
- testing;
- observability;
- phase and ADR lifecycle semantics.

Subject-specific documents may provide more detailed requirements or explanations, but must not contradict the accepted cross-cutting engineering baseline.

### Version Resolution

To determine the current canonical specification:

1. Read `docs/architecture/canonical-specification/README.md`.
2. Identify the version marked `Accepted`.
3. Open the corresponding canonical specification file.
4. Verify that the specification itself has status `Accepted`.
5. Use that version as the current canonical engineering baseline.

A document must not assume that any specific canonical version remains current.

---

## 6. Architectural Decision Authority

Accepted ADRs own individual consequential architectural decisions.

For example, an accepted ADR may establish:

- a queue technology;
- an authentication mechanism;
- a cloud provider;
- a persistence pattern;
- a security boundary;
- a deployment strategy.

An ADR does not automatically become the authority for unrelated architecture.

The relationship is:

```text
Architectural question
        ↓
Analysis
        ↓
Alternatives
        ↓
ADR
        ↓
Human decision
        ↓
Accepted ADR
        ↓
Canonical specification update if required
        ↓
Implementation
        ↓
Verification
```

---

## 7. Phase Documents and Decision Authority

Phase documents are execution documents.

A phase document may:

- operationalize an accepted decision;
- break accepted requirements into tasks;
- define implementation sequencing;
- define verification steps;
- record evidence;
- identify risks;
- identify unresolved decisions.

A phase document may **not** create an accepted architectural decision.

### Explicit rule

> **A phase document may operationalize an accepted decision but may not create an accepted decision.**

A phase document may identify or analyse an unresolved architectural question, but it must not silently turn one implementation option into the accepted architecture.

If a phase encounters an unresolved consequential decision:

```text
Identify
   ↓
Analyse
   ↓
Critique alternatives
   ↓
Record unresolved decision
   ↓
ADR
   ↓
Human decision
   ↓
Update authority
   ↓
Resume implementation
```

---

## 8. Claude Code Decision Authority

Claude Code is an engineering assistant.

Claude Code may:

- inspect;
- analyse;
- critique;
- propose;
- implement;
- test;
- verify;
- document evidence.

Claude Code is not the final authority for consequential product or architectural decisions.

### Explicit rule

> **Claude Code may propose an architectural decision but may not treat a proposed decision as accepted.**

Claude Code must distinguish:

```text
Fact
Assumption
Proposal
Accepted decision
Implementation
Verification
```

These terms must not be treated as interchangeable.

---

## 9. Claude Configuration Authority

Claude Code configuration has different responsibilities:

| Mechanism         | Responsibility             |
| ----------------- | -------------------------- |
| `CLAUDE.md`       | Persistent project context |
| `.claude/rules/`  | Constraints                |
| `.claude/skills/` | Reusable procedures        |
| `.claude/agents/` | Specialist contexts        |
| `.claude/hooks/`  | Deterministic controls     |

None of these mechanisms may become an independent architectural authority.

Side-effecting Skills (`adr`, `commit`) are user-invoked only and declare `disable-model-invocation: true`.

For example:

- a Rule may enforce a boundary already established by architecture;
- a Skill may verify an accepted requirement;
- an Agent may critique an architecture;
- a Hook may block a dangerous operation.

None may silently establish a new architecture.

Claude Code's current guidance distinguishes persistent project context, reusable Skills, specialist subagents, and deterministic Hooks for these purposes.

---

## 10. Implementation Does Not Equal Acceptance

An implementation choice does not automatically become an architectural decision.

For example, if authentication has not yet been selected, implementing:

```text
Provider A
```

does not establish:

```text
Accepted architecture = Provider A
```

It remains an implementation choice or prototype until the required decision process has been completed.

This distinction is mandatory for:

- authentication;
- queue technology;
- object storage;
- cloud provider;
- LLM provider;
- embedding provider;
- browser isolation;
- notification provider;
- other consequential unresolved decisions.

---

## 11. Prototyping Unresolved Decisions

Exploration or prototyping of an unresolved decision is permitted when explicitly labelled as such.

A prototype must not be represented as:

- the accepted architecture;
- the production architecture;
- a final provider decision;
- a permanent dependency.

Prototype documentation should explicitly state:

```text
Status: Experimental / Proposed
Not production-authoritative
Decision pending
```

---

## 12. Requirements Authority

Product requirements belong to:

`docs/product/requirements.md`

A phase document may map tasks to requirements.

It may not silently create new product requirements.

If implementation reveals a missing requirement:

1. identify the gap;
2. document the proposed requirement;
3. update the authoritative requirements document;
4. update affected acceptance criteria;
5. update affected phase documentation;
6. implement;
7. verify.

---

## 13. Acceptance Criteria Authority

Product-level acceptance criteria belong to:

`docs/product/acceptance-criteria.md`

Phase-level acceptance criteria belong to the relevant phase document.

These are distinct.

Product acceptance establishes what the product must accomplish.

Phase acceptance establishes whether the particular phase has been completed correctly.

A phase acceptance criterion must not silently redefine a product requirement.

---

## 14. Security Authority

Security architecture belongs to:

`docs/architecture/security-architecture.md`

Detailed security procedures belong under:

`docs/security/`

Claude Rules may enforce security constraints.

Claude Hooks may deterministically prevent dangerous operations.

Neither replaces the security architecture.

---

## 15. AI Authority

AI architecture belongs to:

`docs/architecture/ai-architecture.md`

AI evaluation methodology belongs under:

`docs/ai/`

AI-generated output is not authoritative merely because an AI model produced it.

---

## 16. README Policy

README files normally provide:

- navigation;
- orientation;
- onboarding;
- indexes.

A README is governance-authoritative only when explicitly designated.

The following are explicitly governance-authoritative:

- `docs/architecture/canonical-specification/README.md`
- `docs/phases/README.md`
- `docs/decisions/README.md`

---

## 17. Conflict Resolution

When documents disagree:

### Step 1 — Identify the subject

Determine what the conflict is actually about.

### Step 2 — Identify the authority

Use the authority table in this document.

### Step 3 — Classify the conflict

Determine whether it is:

- outdated information;
- documentation error;
- explanatory difference;
- genuine contradiction;
- unresolved decision;
- intentional scope distinction.

### Step 4 — Do not guess

Do not silently choose between consequential interpretations.

### Step 5 — Apply the correct process

If the issue changes an accepted decision:

```text
Analyse
→ Critique
→ ADR
→ Human decision
→ Authority update
→ Dependent-document update
→ Implementation
→ Verification
```

---

## 18. Change Rule

A documentation correction and an architectural decision change are different operations.

### Documentation correction

Correct a statement that was intended to describe an existing decision.

No new decision is created.

### Decision change

Change the accepted behaviour, requirement, architecture, security boundary, data authority, or other consequential baseline.

Requires the appropriate decision process.

---

## 19. Traceability

Where practical, trace:

```text
Requirement
    ↓
Acceptance criterion
    ↓
Phase task
    ↓
Implementation
    ↓
Test
    ↓
Verification evidence
```

Architectural decisions should similarly trace:

```text
Architectural question
    ↓
ADR
    ↓
Canonical baseline
    ↓
Phase task
    ↓
Implementation
    ↓
Verification
```

---

## 20. Documentation Quality Principles

Documentation should be:

- authoritative;
- explicit;
- concise;
- testable where applicable;
- traceable;
- version-aware;
- status-aware;
- consistent;
- explicit about uncertainty.

Avoid:

- duplicated normative text;
- hidden decisions;
- stale architecture;
- ambiguous status;
- contradictory terminology;
- implementation detail inside product requirements;
- architecture hidden inside Claude configuration.

---

## 21. Completion Language

Documentation must distinguish:

### Implemented

The change exists in the repository.

### Verified

Evidence demonstrates that the relevant checks passed.

### Accepted

The appropriate human decision authority has accepted the requirement or architectural decision.

### Complete

All applicable implementation, verification, documentation, security, observability, ADR, acceptance, and exit criteria have passed.

No document may use these terms interchangeably.

---

## 22. Status Models

Status models are subject-specific. No single lifecycle vocabulary applies to every artifact.

| Category                                                                                            | Lifecycle statuses                                                 |
| --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| Canonical specification versions                                                                    | `Draft` / `Proposed` / `Accepted` / `Superseded` (exactly one `Accepted`) |
| Historical canonical record whose original source is unavailable                                    | `Historical`                                                       |
| Product, architecture, governance, security, and operations authority documents; registers          | `Draft` / `Proposed` / `Accepted` / `Superseded`                   |
| ADRs                                                                                                | `Proposed` / `Accepted` / `Rejected` / `Superseded` (see `docs/decisions/README.md`) |
| Phase documents                                                                                     | `Not Started` / `In Progress` / `Verification` / `Complete` / `Blocked` (see `docs/phases/README.md`) |
| Verification and review evidence records                                                            | `Pending` / `Recorded` / `Superseded`                              |

Rules:

- `Draft` — working material; not authoritative.
- `Proposed` — ready for review; the document itself has not been formally accepted.
- `Accepted` — accepted by the acceptance authority **and** recorded in `docs/architecture/acceptance-register.md`. A document generated, implemented, reviewed, or verified is not thereby `Accepted`.
- `Superseded` — previously accepted and replaced.
- `Historical` — status-only record; non-authoritative.
- Evidence records: `Pending` (not yet executed), `Recorded` (results recorded), `Superseded` (replaced by a later run). An evidence record never states or implies a phase lifecycle status.
- Verification **results** (`PASS` / `FAIL` / `BLOCKED` / `NOT APPLICABLE`) are not lifecycle statuses and are never used as document statuses.

### Canonical specification and subject-specific documents

> The current Accepted canonical specification is the cross-cutting engineering baseline. Subject-specific documents own their respective subjects. A subject-specific document may have an independent lifecycle status. A Proposed subject-specific document does not invalidate an accepted decision already recorded in the current Accepted canonical specification; it means that the document itself has not yet been formally accepted as the maintained subject-specific representation.

A Proposed subject-specific document doesn't undo a decision the current Accepted canonical specification already accepted, and that specification doesn't take over those subjects.

This rule refers to the canonical version identified as current by `docs/architecture/canonical-specification/README.md`.

---

## 23. Acceptance Model

- `docs/architecture/acceptance-register.md` is the sole record of human acceptance.
- Acceptance is recorded only by the acceptance authority: the project owner.
- An entry has type `status` (the document's lifecycle status is `Accepted`) or `content` (the document's content is accepted while its lifecycle follows another model, such as a phase document).
- How an entry identifies the accepted version, and which later changes leave a recorded acceptance in force, are defined in `docs/architecture/acceptance-register.md` §2.
- A document claiming `Accepted` without a corresponding register entry is inconsistent.
- Acceptance dates are never invented; an unknown original date is recorded as `not recorded`.
- Two kinds of acceptance are kept separate. This register is authoritative for acceptance of governed project **documents**. An ADR's `## Status` section is authoritative for the lifecycle of the **architectural decision** it records. ADR decision acceptance is not duplicated into the acceptance register (`docs/decisions/README.md` §3b).

---

## 24. Review Policy

Review this document when:

- a documentation authority changes;
- a new documentation category is introduced;
- canonical specification governance changes;
- ADR governance changes;
- phase governance changes;
- Claude Code governance changes.

Routine implementation changes do not require modification.

---

## 25. Governing Principle

The repository must preserve this invariant:

> **Documentation explains accepted decisions; ADRs record consequential decisions; the canonical specification records the accepted cross-cutting engineering baseline; phases operationalize accepted decisions; Claude Code assists with analysis and execution; verification provides evidence.**

No lower-level artifact may silently promote itself into a higher-level decision authority.
