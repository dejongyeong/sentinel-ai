# Sentinel AI — Acceptance Register

**File:** `docs/architecture/acceptance-register.md`  
**Status:** Accepted  
**Owner:** Project owner  
**Authority:** Sole record of human acceptance (see `docs/architecture/documentation-authority.md`, Acceptance Model)

## 1. Purpose

This register is the only record of human acceptance for documents governed by the documentation-authority status models.

A document's `Accepted` status, or a phase document's content acceptance, is valid only when a corresponding entry exists here.

Acceptance is never inferred from implementation, review, verification, or the existence of a document.

## 2. Entry Rules

- Only the acceptance authority records acceptance.
- Entries are append-only. A later entry may supersede an earlier one; earlier entries are not edited or removed.
- An entry identifies exactly one document and version.
- **Version identifier:**
  - A document that has its own governed version identifier is identified by it (for example, a canonical specification version such as `v0.3`).
  - A governed document without its own version numbering is identified by the Git commit SHA of the repository state containing the content being accepted, written as `` `<document path>` @ commit `<full SHA>` ``.
- **Effect of later changes:**
  - An entry records the version that was accepted. Later administrative or lifecycle changes that this section explicitly permits do not retroactively change the accepted version.
  - For a document accepted with type `status`, changing its own `**Status:**` line to `Accepted` to record that acceptance does not invalidate the acceptance.
  - For the Phase 0 document (`docs/phases/phase-0-product-and-secure-engineering-foundation.md`), changes to its lifecycle-controlled sections — Status, Status History, Final Verification, and Completion Record — do not invalidate its existing content acceptance. Those sections are part of the governed phase lifecycle and are expected to evolve.
  - For this register, adding later acceptance records and updating its lifecycle status do not invalidate previously recorded acceptance decisions. Existing records remain historical records.
  - Any substantive content change outside the explicitly permitted lifecycle or administrative sections requires fresh acceptance of the affected document at its new version.
- `Type` is either:
  - `status` — the document's lifecycle status is `Accepted`;
  - `content` — the document's content is accepted while its lifecycle is governed by another status model (for example, a phase document).
- `Date recorded` is the date the entry was written.
- `Original acceptance date` is the date acceptance was originally given, or `not recorded` when unknown. It must never be invented.
- ADR acceptance is recorded in the ADR itself under `docs/decisions/README.md`, not here.

## 3. Entries

| ID      | Document / version                                                              | Type   | Acceptance authority             | Date recorded | Original acceptance date | Rationale                                                                                                                                       |
| ------- | ------------------------------------------------------------------------------- | ------ | -------------------------------- | ------------- | ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| ACC-001 | `docs/architecture/canonical-specification/canonical-specification-v0.3.md` v0.3 | status | Project owner (De Jong Yeong)    | 2026-10-03    | not recorded             | Project owner instruction (Phase 0 remediation decision H5): "Treat canonical specification v0.3 as the accepted cross-cutting engineering baseline." |
| ACC-002 | `docs/architecture/documentation-authority.md` @ commit `a6d58ce0f9d66cd3d14271ad0a0c642174220f14` | status | Project owner (De Jong Yeong) | 2026-10-03 | 2026-10-03 | Project owner instruction: "I explicitly accept the six Phase 0 acceptance items identified in the current verification report." Version per owner instruction: "Use that C1 SHA as the version identifier for the next acceptance stage." |
| ACC-003 | `docs/architecture/canonical-specification/README.md` @ commit `a6d58ce0f9d66cd3d14271ad0a0c642174220f14` | status | Project owner (De Jong Yeong) | 2026-10-03 | 2026-10-03 | Project owner instruction: "I explicitly accept the six Phase 0 acceptance items identified in the current verification report." Version per owner instruction: "Use that C1 SHA as the version identifier for the next acceptance stage." |
| ACC-004 | `docs/phases/README.md` @ commit `a6d58ce0f9d66cd3d14271ad0a0c642174220f14` | status | Project owner (De Jong Yeong) | 2026-10-03 | 2026-10-03 | Project owner instruction: "I explicitly accept the six Phase 0 acceptance items identified in the current verification report." Version per owner instruction: "Use that C1 SHA as the version identifier for the next acceptance stage." |
| ACC-005 | `docs/decisions/README.md` @ commit `a6d58ce0f9d66cd3d14271ad0a0c642174220f14` | status | Project owner (De Jong Yeong) | 2026-10-03 | 2026-10-03 | Project owner instruction: "I explicitly accept the six Phase 0 acceptance items identified in the current verification report." Version per owner instruction: "Use that C1 SHA as the version identifier for the next acceptance stage." |
| ACC-006 | `docs/architecture/acceptance-register.md` @ commit `a6d58ce0f9d66cd3d14271ad0a0c642174220f14` | status | Project owner (De Jong Yeong) | 2026-10-03 | 2026-10-03 | Project owner instruction: "I explicitly accept the six Phase 0 acceptance items identified in the current verification report." Version per owner instruction: "Use that C1 SHA as the version identifier for the next acceptance stage." |
| ACC-007 | `docs/phases/phase-0-product-and-secure-engineering-foundation.md` @ commit `a6d58ce0f9d66cd3d14271ad0a0c642174220f14` | content | Project owner (De Jong Yeong) | 2026-10-03 | 2026-10-03 | Project owner instruction: "I explicitly accept the six Phase 0 acceptance items identified in the current verification report." Version per owner instruction: "Use that C1 SHA as the version identifier for the next acceptance stage." Lifecycle status remains governed by the phase status model. |
