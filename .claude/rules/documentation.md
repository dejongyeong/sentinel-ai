---
paths:
  - "docs/**/*.md"
  - "README.md"
  - "CLAUDE.md"
  - ".claude/**/*.md"
---

# Sentinel AI — Documentation Rules

**File:** `.claude/rules/documentation.md`  
**Authority:** `docs/architecture/documentation-authority.md`

## Authority

Never create a second source of truth.

Before editing documentation, determine:

1. the subject;
2. its authoritative file (documentation-authority §4);
3. whether the change is explanatory or normative.

## Normative Changes

If a change alters requirements, architecture, security boundaries, data authority, AI safety boundaries, or phase governance, do not hide it in a README, phase document, Skill, Rule, or CLAUDE.md. Use the authoritative document and the ADR process.

## Status

Use only the status model for the document's category (documentation-authority §22):

- authority documents and registers: Draft / Proposed / Accepted / Superseded;
- historical canonical records: Historical;
- ADRs: Proposed / Accepted / Rejected / Superseded;
- phase documents: Not Started / In Progress / Verification / Complete / Blocked;
- evidence records: Pending / Recorded / Superseded.

Never mark a document `Accepted` without an entry in `docs/architecture/acceptance-register.md`. Claude Code never records acceptance on the owner's behalf.

Do not skip phase lifecycle states (`docs/phases/README.md` §11a).

## Verification

Do not mark a phase Complete merely because implementation exists. Completion requires recorded evidence.
