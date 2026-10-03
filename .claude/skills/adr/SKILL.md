---
name: adr
description: Draft a Proposed Architecture Decision Record for Sentinel AI — determine whether an ADR is required, inspect authority, draft options and consequences, and stop before any acceptance. Never accepts or enacts a decision.
when_to_use: The owner explicitly invokes /adr for a consequential architectural question.
argument-hint: "[decision question]"
disable-model-invocation: true
---

# ADR

## Purpose

Prepare a `Proposed` ADR so the project owner can decide. This Skill drafts; it never accepts, rejects, supersedes, or enacts a decision.

## Invocation

Only when the owner invokes `/adr`. Claude may state that an ADR appears necessary and recommend `/adr`, but never invokes this Skill itself.

## Inputs

- The architectural question (argument or conversation).
- Any related phase task, requirement, dependency, or finding.

## Authority Sources

1. `docs/decisions/README.md` — ADR governance, index, required structure, location (`docs/decisions/adr/`), numbering
2. `docs/architecture/documentation-authority.md`
3. The current Accepted canonical specification, resolved through `docs/architecture/canonical-specification/README.md`
4. `docs/architecture/*.md`, `docs/product/requirements.md`, `docs/decisions/decision-register.md`
5. Existing ADR files in `docs/decisions/adr/`

## Procedure

1. **ADR required?** Compare the question with `docs/decisions/README.md` §2–§3. If not required, report why and stop.
2. **Already decided?** Check the canonical specification, Accepted ADRs, and the decision register. If decided, report the authority and stop. If the question would change an accepted decision, say so explicitly.
3. **Number allocation:**
   a. Read the index in `docs/decisions/README.md` §10 and list every `docs/decisions/adr/ADR-*.md` file.
   b. Stop and report if the index and filesystem disagree (a file without an index row, an index row naming a missing file, duplicate numbers, a number used for two titles, or any ambiguity in which reserved entry matches the question).
   c. Otherwise use the reserved number whose index title matches the question; if none matches, use the next unused number after the highest number in either the index or the filesystem. Numbers are never reused.
4. **File:** `docs/decisions/adr/ADR-NNNN-<kebab-title>.md`. Create `docs/decisions/adr/` only if it does not exist and this is an actual draft.
5. **Draft** with the required structure (`docs/decisions/README.md` §6). `## Status`: `Proposed`, with the acceptance authority and date left blank.
6. **Options:** at least two genuine alternatives with trade-offs, decision drivers, and evidence.
7. **Consequences:** security, operational, and cost implications; affected requirements, architecture documents, phases, dependencies, and verification.
8. **Index:** update only this ADR's row in `docs/decisions/README.md` §10 (file path, `Proposed`).
9. **Stop.** Present the draft and the list of documents that would change if it were accepted. Do not edit them.

## Constraints

- Never set `Accepted`, `Rejected`, or `Superseded`; only the project owner records the decision lifecycle in the ADR's `## Status`.
- Never record ADR decision acceptance in `docs/architecture/acceptance-register.md`; that register is for governed documents.
- Never implement, configure, or depend on the proposed option.
- Never modify the canonical specification or architecture documents while drafting.
- A `Proposed` ADR is not an accepted decision.

## Verification

- The draft has every required section, status `Proposed`, and an empty acceptance record.
- The index row matches the file, and index and filesystem agree.
- No file other than the ADR file and its index row changed.

## Stopping Conditions

- The question is not consequential, or is already decided.
- Index and filesystem disagree, or numbering is ambiguous.
- Authority documents conflict.
- Real alternatives cannot be stated from the available information.
- After drafting (always): wait for the owner's decision.

## Output

ADR path and number, options with the recommendation labelled as a proposal, affected documents, and an explicit statement that the decision is not accepted.
