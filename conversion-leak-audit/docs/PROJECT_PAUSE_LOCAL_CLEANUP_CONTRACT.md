# Project Pause — Local Cleanup Contract

Date: 2026-09-23
Project state: PAUSED_BY_OWNER
Archive/seal: NO

## Goal

Remove local Conversion Leak Audit duplicates after all required state has been merged/pushed to the canonical Git repository.

Target final local state:

```text
VPS基建/
  project-github-sync/
    conversion-leak-audit/   # canonical monorepo checkout only
```

No extra CLA workspace, screenshot bundle, review ZIP, archive copy, runtime-temp copy, or duplicate source tree should remain.

## Safety order

Before deleting anything:

1. `git fetch origin`.
2. Confirm canonical `origin/main` contains:
   - `docs/PROJECT_PAUSE_HANDOFF.md`;
   - G6 read-only preflight docs;
   - G6 Compose candidate;
   - paused `CURRENT_STATUS.json`.
3. Enumerate all local CLA-owned worktrees/artifacts.
4. For each worktree:
   - confirm clean;
   - confirm branch work is merged/preserved in GitHub;
   - confirm no untracked unique evidence.
5. For each artifact directory/ZIP:
   - confirm it is CLA-owned;
   - confirm no unique evidence is needed for future resume;
   - if unique textual evidence exists, stop and report it rather than deleting.

## Remove

Only after verification, remove:

- merged/clean CLA worktrees under `workspaces/`;
- CLA-only screenshot directories;
- CLA-only review ZIPs/packages;
- CLA-only archives;
- CLA-only runtime-temp that is no longer active;
- duplicate CLA source/export folders outside canonical checkout;
- local merged CLA branches when safe and not checked out;
- stale Git worktree metadata via `git worktree prune`.

Use proper `git worktree remove` for Git worktrees; do not manually delete an active worktree first.

## Do not remove

- `project-github-sync`;
- canonical `conversion-leak-audit` inside it;
- monorepo `.git`;
- another project;
- any unmerged/unpushed work;
- unknown/unproven `.tmp-*` ownership;
- active processes/runtime directories;
- shared tools such as `.clone-ui`;
- VPS files;
- remote GitHub history.

## VPS/network rule

This cleanup is local-only.

Forbidden:
- SSH write;
- VPS mkdir/remove;
- Docker changes on VPS;
- deployment;
- port changes;
- payment/provider work.

## Final verification

Return:

```text
GATE=PROJECT_PAUSE_LOCAL_CLEANUP
RESULT=PASS_LOCAL_CLEANUP | RETURN_LOCAL_UNIQUE_EVIDENCE_FOUND
PROJECT_STATE=PAUSED_BY_OWNER
CANONICAL_CHECKOUT=...
REMOVED_WORKTREES=...
REMOVED_ARTIFACT_PATHS=...
REMOVED_DUPLICATE_SOURCE_PATHS=...
LOCAL_CLA_DUPLICATES_REMAINING=0|...
LEFT_IN_PLACE_UNRESOLVED=...
VPS_ACTIONS=0
OWNER_ACTION=NONE|...
REVIEWER_SOURCE=GITHUB
REVIEWER_HANDOFF=conversion-leak-audit/docs/PROJECT_PAUSE_HANDOFF.md
NEXT=STOP
```

Keep the terminal return concise. Do not dump full logs.
