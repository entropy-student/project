# Reviewer Decision — G4 Repository Reconciliation

Date: 2026-09-22

Role: Reviewer / Architect / Gatekeeper

## Decision

`RETURN_G4_REPOSITORY_RECONCILIATION_REQUIRED`

The G4 functional implementation remains a valid PASS candidate, but final G4 PASS is withheld until the implementation is persisted in a clean, traceable Git state.

## Confirmed repository facts

- Canonical Git root is `project-github-sync/`.
- The repository is the `entropy-student/project` monorepo.
- Sibling project directories are expected tracked content, not accidental G4 downloads.
- The outer `VPS基建/` directory contains a separate unborn Git repository and was previously mistaken for the project Git root.
- The existing monorepo worktree contains unrelated Mini Craft pending changes.
- G4 implementation currently exists as local uncommitted additions/modifications under `conversion-leak-audit/`.
- Current GitHub `main` has advanced beyond the Executor's last observed remote-tracking ref.

## Reviewer ruling

Do not clean, reset, pull, merge, or commit G4 from the dirty shared monorepo worktree.

Create a separate clean project-scoped Git workspace from current `origin/main`, using sparse checkout (or equivalent) so only `conversion-leak-audit/` is exposed.

Migrate only G4-owned implementation assets into that clean workspace. Do not blindly copy stale Reviewer-owned tracked documents over current `main`; merge Executor evidence into fresh canonical documents.

Re-run the frozen regressions and G4 integration tests in the clean workspace. Then create a dedicated G4 branch and commit containing only `conversion-leak-audit/**` changes.

Push the dedicated branch and return the branch/commit for Reviewer inspection. Do not merge to `main` before Reviewer PASS.

## Required isolation

The clean workspace must not expose or modify sibling projects.

No cleanup or mutation of the existing dirty monorepo worktree is authorized.

## Next

```text
clean sparse workspace from current origin/main
→ migrate only G4 source/evidence
→ preserve current Reviewer-owned docs
→ rerun 55/55 + 20/20 + G4 integration
→ commit only conversion-leak-audit/**
→ push dedicated G4 branch
→ PASS_CANDIDATE_G4_REPOSITORY_RECONCILED
→ STOP_AT_REVIEWER
```
