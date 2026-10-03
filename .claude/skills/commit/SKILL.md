---
name: commit
description: Create one local Git commit for Sentinel AI from exactly confirmed paths representing one logical change, with an owner-approved message that follows the project convention, after relevant checks and a passing pre-commit preflight. Explicit /commit only. Never bypasses hooks, never pushes, never rewrites history.
when_to_use: The owner explicitly invokes /commit.
argument-hint: "[exact paths and/or commit intent]"
disable-model-invocation: true
---

# Commit

## Purpose

Create one local commit containing one focused logical change, whose exact contents and message the owner has confirmed, with the installed pre-commit hook running normally.

This Skill is a procedure. It applies the commit-message convention in `docs/operations/developer-workflow.md` §5 and is not the authority for that convention.

## Invocation

Only by explicit `/commit`. Prohibited while a phase verification run is in progress, between that run's baseline snapshot and its final snapshot (`docs/phases/README.md` §25a).

## Inputs

- Exact paths to commit, or an intent from which candidate paths are proposed for confirmation.
- Optional message guidance.

## Authority Sources

1. `docs/operations/developer-workflow.md` (commands; §5 Commit Message Convention)
2. `.claude/rules/security.md`
3. `docs/security/secret-incident-response.md`
4. `.pre-commit-config.yaml`

## Procedure

1. **Inspect (read-only):** `git status`, `git diff --staged`, `git diff`, untracked files, current branch, commit count, and `git log -1` if commits exist. If anything is already staged that the owner has not confirmed, stop and ask.
2. **Establish exact paths:** if the owner supplied exact paths, use those. Otherwise present the candidate paths and obtain explicit confirmation before staging. Never infer broad staging from vague intent.
3. **One logical change:** if the confirmed paths contain unrelated logical changes, stop and ask the owner to split them into separate commits. The only exception is the one-time initial-bootstrap exception in `docs/operations/developer-workflow.md` §5.
4. **Branch:**
   - Zero commits: the first commit is made on the current branch (`main`).
   - Commits exist and the current branch is the default branch: do not branch automatically and do not commit yet. Ask the owner to choose: create or use a named non-default branch, or explicitly authorize this one commit on the default branch.
   - Default branch: the branch referenced by the remote's HEAD when a remote exists; otherwise `git config init.defaultBranch`; otherwise `main`. If these disagree or none resolves, ask.
5. **Stage exact paths:** `git add -- <path>...` for the confirmed paths only. Never `git add -A`, `git add .`, `git add -u`, or `git commit -a`. Refuse `.env` files, credentials, keys, and generated output; on a suspected secret, stop and follow `docs/security/secret-incident-response.md`.
6. **Inspect the staged diff:** `git diff --staged --stat` and `git diff --staged`; confirm it contains exactly the confirmed paths.
7. **Relevant checks:** run the checks `docs/operations/developer-workflow.md` lists for the changed file types (for example `bash -n` for shell scripts, JSON/YAML parsing). Stop on failure.
8. **Hook installed:** confirm `.git/hooks/pre-commit` was installed by pre-commit. If not, stop and ask the owner to run `pre-commit install`.
9. **Preflight:** `pre-commit run --all-files` must exit 0; otherwise stop and report. Do not run a separate Gitleaks command; the pre-commit Gitleaks hook covers it.
10. **Draft the message** following `docs/operations/developer-workflow.md` §5: subject `type(scope): subject`; a body when the change is not small and self-explanatory; trailers only as §5 permits.
11. **Validate the message** before showing it, and revise the draft until every check holds:
    - the type is one of `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `build`, `perf`, `style`;
    - the optional scope, if present, is a short lowercase area name in parentheses;
    - the subject has the form `type(scope): subject` or `type: subject`;
    - the subject line is approximately 50 characters where practicable and never more than 72;
    - the subject uses imperative, present-tense wording;
    - the subject has no trailing period and no unnecessary punctuation;
    - a body, if present, is separated from the subject by one blank line and wrapped at approximately 72 characters;
    - trailers are limited to those §5 permits. The project-approved AI co-authorship trailer is added only when an exact attribution identity is provided by the project/session; never invent or infer an author name, email address, or other attribution identity. No issue numbers, ticket references, sign-offs, or other metadata unless explicitly supplied or required by project policy.
12. **Owner approval:** show the validated message and the confirmed staged paths, then wait for explicit input: accept, revise, or reject. On revise, apply the change, re-validate, and show again. On reject, do not commit; report that the paths remain staged.
13. **Commit:** prefer `git commit -m "<approved subject>" -m "<approved body>"` (omit the second `-m` when there is no body, and add trailer paragraphs as further `-m` arguments). If a temporary message file is needed for a multiline message, create it outside the repository, never stage it, and remove it after the commit attempt whether the commit succeeds or fails. The commit is plain, so the installed hook runs normally: no `--no-verify`, no `-n`, no `--amend`. If it fails, stop and report; never retry with a bypass.
14. **Report:** `git log -1 --stat` and `git status`.

## Constraints

- Never use `--no-verify` or `-n`; never disable, edit, or skip hooks to pass.
- Never push, create a PR, amend, rebase, reset, squash, or rewrite history.
- Never stage paths the owner has not supplied or confirmed.
- Never combine unrelated logical changes in one commit, except the one-time initial-bootstrap exception.
- Never commit without the owner's explicit approval of the exact message.
- Never invent message metadata or an attribution identity.
- Never commit to the default branch, once commits exist, without explicit per-commit owner authorization.
- Never commit during a phase verification run.
- Never change phase status, evidence records, or acceptance records as part of committing.

## Verification

- The message passed step 11 validation and was explicitly approved by the owner.
- `pre-commit run --all-files` exit 0 before the commit.
- The installed hook ran during `git commit` and the commit exists.
- The commit contains exactly the confirmed paths, and its message equals the approved message.
- Any temporary message file was removed.

## Stopping Conditions

- Paths are unconfirmed, or unconfirmed content is already staged.
- The paths contain unrelated logical changes (outside the initial-bootstrap exception).
- The branch choice is unresolved.
- A relevant check, the preflight, or the hook fails.
- A suspected secret is found.
- The hook is not installed.
- The message cannot be made to pass validation, or the owner rejects it.
- A verification run is in progress.

## Output

Branch, committed paths, commit hash and subject, preflight result, and remaining uncommitted changes.
