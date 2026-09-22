# Reviewer Decision — K4 Local Artifact Hygiene

Date: 2026-09-22
Status: AUTHORIZED SIDE TASK
Current primary checkpoint remains: OWNER_K4_FINAL_UI_EDIT_WINDOW

## Purpose

Clean project-generated temporary files/folders created during today's K4 UI/responsive work from the shared local workspace.

This is a hygiene task only. It must not modify WordPress pages, media, WooCommerce, PayPal, Docker runtime state, or Owner UI choices.

## Scope rule

Only touch artifacts that can be positively attributed to Mini Craft Night Kit / today's K4 work.

If provenance is uncertain, leave the item untouched and record it as UNCLASSIFIED_LEFT_IN_PLACE.

Do not inspect or modify unrelated project folders beyond the minimum metadata needed to avoid touching them.

## Known likely Mini Craft artifacts

Names such as:
- .tmp-k4-matrix-home-320
- .tmp-k4-matrix-home-375
- .tmp-k4-matrix-home-390
- .tmp-k4-matrix-home-430
- .tmp-k4-matrix-home-768
- .tmp-k4-matrix-home-820
- .tmp-k4-matrix-home-1024
- .tmp-k4-matrix-home-1280
- .tmp-k4-matrix-home-1366
- other .tmp-k4-matrix-* created by the same K4 responsive run

These are expected to be reproducible transient capture outputs. If confirmed to be Mini Craft K4 artifacts and their durable evidence is already committed under docs/ui-k4-shell/ or docs/ui-k4-copy/, delete them from the shared root instead of duplicating them into an archive.

## Uncertain/shared items

Examples visible in the workspace:
- .clone-ui
- .tmp-cdp-test2
- .git

Rules:
- .git: never touch.
- .clone-ui: leave unless there is explicit proof it is dedicated only to this project and safe to relocate; default LEAVE.
- .tmp-cdp-test2: touch only if positively proven to be a Mini Craft temporary artifact from this K4 work; otherwise LEAVE.

## Retention policy

KEEP:
- project source
- committed evidence
- Reviewer/Executor docs
- current rollback/recovery artifacts referenced by active evidence
- anything needed for current Docker/MariaDB runtime
- anything with uncertain ownership

DELETE:
- confirmed Mini Craft transient screenshots/render/cache/temp folders that are reproducible and already superseded by committed evidence
- temporary helpers that are no longer used

ARCHIVE inside project only when:
- the artifact is project-specific,
- still useful for rollback/debug,
- not already represented by committed evidence,
- and should not remain in the shared workspace root.

Preferred archive location:
mini-craft-night-kit/.artifacts/local-hygiene/

Do not commit bulky local runtime/archive artifacts to GitHub unless a separate Reviewer instruction explicitly requires it.

## Required evidence

Return:
- root-level items inspected by name only
- CLEANED list
- ARCHIVED list
- LEFT_UNTOUCHED_UNRELATED list
- UNCLASSIFIED_LEFT_IN_PLACE list
- proof that active site remains http://localhost:8093/ and HTTP 200
- Docker WordPress up / MariaDB healthy
- no page/media/config/order/payment mutation
- no secret output

## Stop

This side task does not close the Owner UI edit window.

Return:
GATE=K4_LOCAL_ARTIFACT_HYGIENE
RESULT=PASS_CANDIDATE_K4_LOCAL_ARTIFACT_HYGIENE
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
