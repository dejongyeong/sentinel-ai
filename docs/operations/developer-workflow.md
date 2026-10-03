# Sentinel AI — Developer Workflow

**File:** `docs/operations/developer-workflow.md`  
**Status:** Proposed  
**Owner:** Engineering  
**Authority:** Standard developer commands for validating changes

## 1. Scope

This document lists the commands a contributor uses to validate a change. It does not define the toolchain: the package manager, formatter, linter, test runner, and type checker are Phase 1 decisions. Commands for capabilities that do not exist yet are marked as such rather than invented.

## 2. Prerequisites

| Tool        | Purpose                                         | Notes                                                               |
| ----------- | ----------------------------------------------- | ------------------------------------------------------------------- |
| Git         | Version control                                 | —                                                                   |
| Bash        | Runs repository scripts and Claude Code hooks   | Git Bash on Windows                                                 |
| Python 3    | Snapshot tool and JSON/YAML validation          | Standard library only for project scripts                           |
| pre-commit  | Local commit-boundary hooks                     | Installed in a local virtual environment (`.venv`, ignored by Git)  |
| Gitleaks    | Secret detection                                | Version recorded in `docs/decisions/decision-register.md` (DR-P0-001) |

## 3. Commands

| Activity                     | Command                                                    | Status                                                                           |
| ---------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------------------- |
| Install local hooks          | `python -m venv .venv`, then install `pre-commit` into it, then `pre-commit install` | Available                                                    |
| Run local hooks              | `pre-commit run --all-files`                               | Available. Scans tracked and staged files only.                                  |
| Secret scan (working tree)   | `gitleaks dir . --redact`                                  | Available                                                                        |
| Secret scan (history)        | `gitleaks git --redact`                                    | Available once commits exist                                                     |
| Gitleaks controls            | `scripts/checks/gitleaks-controls.sh`                      | Available. Runs in a temporary directory outside the repository.                 |
| Pre-commit controls          | `scripts/checks/pre-commit-controls.sh`                    | Available. Uses temporary repositories outside the repository.                   |
| Claude Code guardrail tests  | `scripts/checks/claude-guardrails.sh`                      | Available                                                                        |
| Repository snapshot          | `python scripts/checks/repo_snapshot.py capture`           | Available. Writes to standard output only.                                       |
| Documentation / phase validation | `scripts/verify-phase.sh <phase-id> --baseline <snapshot.json>` (for example `phase-0`; capture the baseline with `repo_snapshot.py capture` to a path outside the repository) | Available. Without `--baseline`, `VER-P0-GIT-SAFETY-001` cannot be evaluated and is reported as `FAIL`. |
| CI-equivalent verification   | `scripts/verify-phase.sh <phase-id> --baseline <snapshot.json>` | Available locally for static checks. CI execution requires the repository host. |
| Commit                       | `/commit` in Claude Code (user-invoked Skill), or `git commit` with hooks installed | Available. Never `--no-verify`. Not during a phase verification run.  |
| Lint                         | —                                                          | Not applicable until Phase 1 defines the toolchain                               |
| Format                       | —                                                          | Not applicable until Phase 1 defines the toolchain                               |
| Test (application)           | —                                                          | Not applicable until application code exists                                     |
| Type check                   | —                                                          | Not applicable until Phase 1 defines the toolchain                               |
| Local infrastructure         | —                                                          | Not applicable until Phase 2 (Containerisation & Local Infrastructure)           |

## 4. Rules

- Never use `git commit --no-verify`.
- Never allowlist a real secret. See `docs/security/secret-incident-response.md`.
- Verification scripts never write into the repository; evidence is recorded only through the phase-verification process (`docs/phases/README.md`).

## 5. Commit Message Convention

This section is the authoritative commit-message convention for the repository. It applies to every commit, whether made with the `/commit` Skill or directly with `git commit`. The `/commit` Skill applies this convention; it is not its authority.

### One logical change

A commit represents one focused logical change. Unrelated changes are split into separate commits.

**Initial-bootstrap exception (one time only):** the first commit of the repository may contain the complete Phase 0 foundation as one logical change, because the uncommitted files collectively establish the initial repository and governance foundation. The exception exists for that reason, not merely because it is the first commit. After the first commit, the one-logical-change rule applies normally.

### Subject

`type(scope): subject`

- `scope` is optional. When used, it is a short lowercase name of the affected area (for example `governance`, `security`, `claude`, `ci`, `product`, `scripts`).
- Imperative, present-tense wording ("add", not "added" or "adds").
- Approximately 50 characters where practicable; never more than 72.
- No trailing period; no unnecessary punctuation.
- Describes the change, not a list of files.

### Types

| Type       | Use for                                                                                       |
| ---------- | --------------------------------------------------------------------------------------------- |
| `feat`     | A new user-visible capability of the product                                                   |
| `fix`      | Correction of incorrect product behaviour or configuration                                     |
| `docs`     | Documentation and governance changes                                                           |
| `refactor` | A code restructuring that changes neither behaviour nor interfaces                             |
| `test`     | Adding or changing tests or verification scripts without changing the code they test          |
| `chore`    | Repository maintenance that fits no other type (for example Claude Code configuration)         |
| `build`    | Build system, dependencies, tooling configuration, and CI configuration (`.github/workflows/`) |
| `perf`     | A change whose purpose is performance, without behaviour change                                |
| `style`    | Formatting or whitespace only, with no change in meaning                                       |

No other types are used. A revert commit uses the type of the change it undoes, says "revert" in the subject, and names the reverted commit in the body.

### Body

Optional for a small, self-explanatory change. Otherwise:

- one blank line after the subject;
- the problem or motivation;
- why this change addresses it;
- relevant alternatives or design trade-offs where that context matters;
- lines wrapped at approximately 72 characters.

### Trailers

Only trailers with a legitimate project purpose.

The project-approved AI co-authorship trailer may be added automatically when an exact attribution identity is provided by the project/session. No author name, email address, or other attribution identity is invented or inferred.

Issue numbers, ticket references, sign-offs, and other metadata are added only when explicitly supplied or required by project policy, and are never invented.

### Never

- `git commit --no-verify` or `-n`.
- Amending, rebasing, or otherwise rewriting history without a separately authorized workflow.
