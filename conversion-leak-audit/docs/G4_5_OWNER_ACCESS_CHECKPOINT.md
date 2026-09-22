# G4.5 — Owner WordPress Access & Visual Checkpoint

Date: 2026-09-22

Status: `REQUIRED_BEFORE_FINAL_G4_5_PASS`

## Purpose

G4 functional PASS does not equal Owner visual approval.

Before G4.5 can pass, the Owner must have:
- a working local front-end URL;
- a working WordPress admin login;
- administrator-level edit access;
- direct page-edit access;
- Site Editor access when supported by the active block theme;
- an opportunity to inspect the implemented Home / Progress / Result / Evidence / Error states.

Reviewer must not declare G4.5 PASS before this checkpoint is completed.

## Required local access

Executor must start the existing local WordPress runtime and report the actual resolved URLs.

Expected defaults from the canonical baseline:

- Front end: `http://localhost:8080/` unless another local port is explicitly used.
- Admin: `http://localhost:8080/wp-admin/`
- Site Editor: `http://localhost:8080/wp-admin/site-editor.php` when available.

Do not assume the port; report the actual active port.

## Editing access

Executor must ensure the Owner has a local-only WordPress administrator account.

The canonical bootstrap baseline uses local development credentials, but Executor must verify the actual running instance rather than assume them.

If the existing local admin credential cannot be confirmed, Executor may reset/create a local-only administrator password with WP-CLI.

Rules:
- local environment only;
- never commit the password;
- never write the password into GitHub evidence;
- return the credential only in the local Codex/Owner session;
- no production credential reuse.

## Direct edit links

Executor must resolve and return:
- Home page editor;
- How it works editor;
- Demo editor;
- Pricing editor;
- FAQ editor;
- Blog editor;
- Site Editor/theme editing entry when available.

Use actual page IDs from the running WordPress instance.

## Owner visual review

Owner must be able to inspect at minimum:
- Home;
- URL input;
- Scan progress;
- Free Top 3;
- Evidence detail;
- incomplete/error;
- mobile layout.

Owner may request visual/content changes before G4.5 acceptance.

These requests are not automatically accepted as new scope: Reviewer determines whether each is a bounded G4.5 correction or a later product change.

## Gate rule

Until Owner confirms access and has had the chance to inspect/edit:

`G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE = OWNER_ACCESS_CHECKPOINT_PENDING`

Candidate G4.5 PASS is not sufficient by itself.

Owner intervention required: `YES — VISUAL/EDIT ACCESS REVIEW ONLY`.
