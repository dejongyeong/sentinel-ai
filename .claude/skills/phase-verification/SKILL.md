---
name: phase-verification
description: Orchestrate verification of a Sentinel AI phase by running the deterministic verification scripts, running the review layers, and recording evidence. Use only when the owner has explicitly authorized the verification stage for a phase.
when_to_use: The owner explicitly authorizes verification of a phase (for example "verify phase-0"). Never invoke automatically after implementation.
---

# Phase Verification

## Purpose

Orchestrate phase verification and record evidence. This Skill does not contain verification assertions; those live in `scripts/verify-phase.sh` and `scripts/checks/`.

## Invocation

Only after explicit owner authorization of the verification stage. Implementation authorization does not authorize verification.

## Inputs

- Phase identifier (for example `phase-0`).
- The phase document `docs/phases/<phase-id>-*.md`.

## Authority Sources

1. `docs/phases/README.md` (lifecycle, transition table §11a, evidence location §25a)
2. The phase document (acceptance criteria, exit criteria, transition rule)
3. `docs/architecture/documentation-authority.md` (status models §22, acceptance model §23)
4. The current Accepted canonical specification, resolved through `docs/architecture/canonical-specification/README.md`

## Procedure

1. Re-inspect the phase document and authority sources.
2. Capture a repository snapshot: `python scripts/checks/repo_snapshot.py capture > <scratchpad>/S-before.json` (outside the repository).
3. Run `scripts/verify-phase.sh <phase-id>` and keep its full output in the scratchpad.
4. Inspect every result. Do not reinterpret a result the script produced.
5. Perform the Layer 1 review described by the phase document.
6. Run the Layer 2 read-only reviewer agents described by the phase document, with a snapshot before and after each agent.
7. Reconcile findings: confirmed / false positive / duplicate / unresolved / requires decision. Apply only already-authorized remediation, then re-run every affected check and mark the earlier results `Superseded`.
8. Record evidence in the evidence files declared by `docs/phases/README.md` §25a, appending a new dated run section.
9. Capture the final snapshot and confirm that only the declared evidence files changed.
10. Apply the phase document's transition rule. The set of checks whose `BLOCKED` result may coexist with entering `Verification` is the constant `TRANSITION_PERMITTED_BLOCKED` in `scripts/verify-phase.sh`; do not restate or extend it.
11. Update the phase `## Status` and Status History only if the transition rule is satisfied.

## Constraints

- Results are only `PASS`, `FAIL`, `BLOCKED`, `NOT APPLICABLE`. `STOP` is a process action and always accompanies `FAIL`.
- Evidence records use `Pending` / `Recorded` / `Superseded` and never state the phase status.
- Never record a result before the check has run.
- Never convert `FAIL` to `BLOCKED`, or `BLOCKED` or `NOT APPLICABLE` to `PASS`.
- Never record acceptance; only the owner records acceptance in `docs/architecture/acceptance-register.md`.
- Never mark a phase `Complete` without the phase's completion conditions and a recorded completion decision.
- Never run Git mutations against the real repository.

## Verification

Each recorded result cites the command, its label (`[REAL REPO]` or `[TEMP REPO <path>]`), exit code, timestamp, and the evidence fields required by the verification record.

## Stopping Conditions

Stop (process action `STOP`, result `FAIL`) and report on:

- unauthorized repository mutation or an S1→S2 change outside the evidence files;
- a reviewer integrity violation;
- a security positive-control failure;
- a finding that requires an unauthorized consequential decision (then wait for the owner);
- any need to modify the canonical specification, introduce architecture, or weaken a control.

A `BLOCKED` result is not a stopping condition; independent checks continue.

## Output

- Per-check table: verification ID, result, process action, evidence location.
- Layer 1 and Layer 2 review results, kept separate.
- Transition-rule evaluation and the resulting phase status.
- Remaining blockers with their exact prerequisites.
