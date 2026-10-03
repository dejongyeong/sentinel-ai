# Sentinel AI — Claude Code Prompt Standard

**File:** `docs/operations/claude-code-prompt-standard.md`  
**Status:** Proposed  
**Owner:** Engineering  
**Authority:** Preferred structure for engineering prompts given to Claude Code (Phase 0 Task 0.16)

## 1. Purpose

A consistent prompt structure makes Claude Code work repeatable, reviewable, and verifiable. This standard describes how humans write prompts. It does not grant Claude Code any decision authority; that is defined by `docs/architecture/documentation-authority.md` §8.

## 2. Structure

| Section             | Content                                                                                       |
| ------------------- | --------------------------------------------------------------------------------------------- |
| Role                | The perspective Claude should take (for example, implementer or reviewer)                     |
| Context             | Relevant background and the authoritative documents to read                                   |
| Objective           | The single outcome required                                                                   |
| Constraints         | Boundaries, invariants, files that must not change                                            |
| Inputs              | Files, identifiers, or data provided                                                          |
| Process             | Required order of work (for example: explore → plan → implement → test → verify → report)     |
| Output              | Expected deliverable and format                                                               |
| Quality Criteria    | How the output will be judged                                                                  |
| Stopping Conditions | When Claude must stop and ask instead of proceeding                                           |
| Verification        | The executable checks that demonstrate success                                                |

## 3. Expectations

Prompts and responses distinguish:

- facts;
- assumptions;
- proposals;
- accepted decisions;
- open questions.

Claude Code inspects before modifying, avoids unrelated changes, and reports failures rather than claiming success.

## 4. Example Skeleton

```text
Role: <reviewer | implementer>
Context: read <authority documents>
Objective: <one outcome>
Constraints: <invariants, out-of-scope files>
Inputs: <paths, IDs>
Process: explore → plan → implement → test → verify → report
Output: <format>
Quality Criteria: <measurable conditions>
Stopping Conditions: <when to stop and ask>
Verification: <commands>
```
