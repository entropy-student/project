# Local Workspace Hygiene Policy

Date: 2026-09-23

## Purpose

Keep local development understandable without deleting canonical project history.

## Canonical separation

```text
project-github-sync/
  canonical Git checkout

workspaces/
  active Gate worktrees only

_project-artifacts/conversion-leak-audit/
  screenshots
  review-packages
  archives
  runtime-temp
```

## What is intentionally retained

Git-tracked project history and Reviewer decisions are retained because they are part of the audit trail.

Do not delete historical Git documents merely because a Gate has passed.

## What should be cleaned after Gate PASS + merge

- merged Gate worktree;
- stopped project-owned runtime temp;
- duplicate local screenshot directories after a final package exists;
- temporary non-canonical ZIPs superseded by the final review package.

## What should be archived

Final local-only evidence goes to:

`_project-artifacts/conversion-leak-audit/archives/<gate>/`

Keep:
- final review package;
- MANIFEST;
- unique evidence that cannot be reconstructed from Git.

## What must not be auto-deleted

- active workspaces;
- unknown `.tmp-*` directories whose ownership is unresolved;
- another project's files;
- Git repositories;
- project source;
- secrets/credentials.

## Default post-Gate action

After Reviewer merges a Gate, the next Executor prompt should include a bounded local hygiene step unless the Owner explicitly defers it.
