# Executor Handoff — G2A1 Component Feasibility

## Latest G2A1R1 closure update — controls this handoff

**Gate:** `G2A1R1_EVIDENCE_CLOSURE`
**Branch:** `codex/birthday-magazine-g2a1r1-evidence-closure`
**Current result:** `RETURN_GUEST_UPLOAD_ACCESS_CONTROL_FAILED` and `RETURN_GUEST_PRIVATE_DELIVERY_ACCESS_CONTROL_FAILED`
**Stop point:** `STOP_AT_REVIEWER=YES`; do not enter G2A2.

```text
GATE=G2A1R1_EVIDENCE_CLOSURE
RESULT=RETURN_GUEST_UPLOAD_ACCESS_CONTROL_FAILED

GUEST_UPLOAD=POSITIVE_PASS / NEGATIVE_FAIL
GUEST_PRIVATE_DELIVERY=POSITIVE_PASS / NEGATIVE_FAIL
BYTE_DOWNLOAD_HASH=PASS
DURABLE_SCREENSHOTS=PASS
CLEANUP_READBACK=PASS
HANDOFF_RECONCILED=PENDING_GITHUB_SUBMISSION

GIT_BRANCH=codex/birthday-magazine-g2a1r1-evidence-closure
GIT_COMMIT=PENDING
GITHUB_PR=PENDING

FORBIDDEN_ACTIONS=0
G2A2_STARTED=NO
STOP_AT_REVIEWER=YES
```

Both guest order pages passed the wrong-email and unrelated-order visibility checks. Both plugins denied the raw storage URL with HTTP 403. The Upload Files guest download link and Attach Me guest download link each returned HTTP 200 when replayed in the unrelated guest context. That bearer-link replay fails the Gate's required negative access check, so both plugin decisions return to Reviewer. The private fixture was actually downloaded: 112 bytes, with SHA-256 equal to the committed fixture. Durable synthetic screenshots are under `docs/evidence/g2a1r1/`.

Local Mailpit v1.31.2 was added to the disposable Compose stack. Its UI binds only to `127.0.0.1:8128`; SMTP is not published to the host. The test PHPMailer helper targets only `mailpit:1025`. A synthetic mail probe was captured and cleared; WooCommerce's guest email verification compared the entered billing email and generated no email (capture count stayed zero during verification).

The project Compose containers, volumes, and network are gone; pre-execution Docker inventory counts were restored, and the exact temporary package and diagnostic directories were removed. Git commit, push, and pull request creation remain before this handoff is fully reconciled. No secret, order key, cookie, token, signed URL, real customer data, or real email is recorded in this handoff.

## Earlier G2A1 feasibility handoff — preserved as history, superseded above

**Gate:** `G2A1_FRONTEND_AND_REUSABLE_COMPONENT_FEASIBILITY_POC`
**Execution branch:** `codex/birthday-magazine-g2a1-component-feasibility`
**State:** Return for Reviewer assessment; no PASS is asserted.
**Stop point:** `STOP_AT_REVIEWER=YES`.

## Proposed result for Reviewer

```text
GATE=G2A1_FRONTEND_AND_REUSABLE_COMPONENT_FEASIBILITY_POC
RESULT=RETURN_REVIEWER_DECISION_REQUIRED

FRONTEND_PREFERRED=C
FREE_PREVIEW=GOOD_ISSUE_FALLBACK
ORDER_UPLOAD=RETURN
PRIVATE_DELIVERY=RETURN

EVIDENCE=EXECUTION_EVIDENCE.md
HANDOFF=EXECUTOR_HANDOFF.md
STOP_AT_REVIEWER=YES
```

Concrete return reasons: `RETURN_STORELLY_PREVIEW_NOT_BROWSER_LOCAL` (and a runtime fatal), `RETURN_ORDER_UPLOAD_GUEST_PATH_UNVERIFIED_MAIL_UNAVAILABLE`, `RETURN_PRIVATE_DELIVERY_GUEST_PATH_UNVERIFIED_MAIL_UNAVAILABLE`, `RETURN_PRIVATE_DELIVERY_BYTE_DOWNLOAD_UNCONFIRMED`, and `RETURN_SCREENSHOT_ARTIFACT_EXPORT_GAP`.

## Decision basis

- **Route C is the best feasibility candidate** because it preserves the Good Issue gift/editorial interaction, keeps the single optional preview image in a browser `blob:` URL, and routes the CTA through a native WooCommerce product/cart path. It is a WordPress page/shortcode and small local plugin, not a separate commerce frontend.
- **Storelly should not be accepted for the current free preview**: its image builder stores uploads on the WordPress server, and the tested Storelly product page raised a PHP fatal/HTTP 500. Cloud export was not connected. The safe fallback is the Good Issue local preview implementation.
- **Vanquish Upload Files is reusable for registered-account uploads**, with one file per configured field and two fields supporting two images. Its guest order path could not be verified because WooCommerce email verification was required and the local mail transport was unavailable. Therefore the executable result is `RETURN`, with the passing registered-account evidence preserved for Reviewer.
- **Vanquish Attach Me is a plausible reusable private-delivery component for registered orders**: direct file paths were denied and plugin authorization allowed the owning account but rejected unrelated customer B. The guest flow was not verified and the authorized browser download did not produce a completed download event. Therefore the executable result is `RETURN` pending those two checks.
- Exact Kadence Jewelry Shop and Blocksy Modern Shop starter imports were not run. Their installed base-theme shells were compared only. No claim is made that either named starter site is accepted.
- Payment setup, AI-to-PDF, G2A2, VPS and public deployment were not entered.

## Current repository/runtime state

- Only these project additions are in scope: `poc/g2a1/`, `EXECUTION_EVIDENCE.md`, `EXECUTOR_HANDOFF.md`.
- No edits to `REVIEWER_HANDOFF.md`; no commit; no pull request.
- Before handing off, remove the project-scoped Compose stack and its volumes, plus temporary packages in `poc/g2a1/packages/`. Retain the custom preview source and the small synthetic image/text fixtures for review.
- Final `git status` should show only those intended project files on `codex/birthday-magazine-g2a1-component-feasibility`.

## Reviewer asks

1. Decide whether to accept Route C as the frontend feasibility candidate, with current Good Issue browser-local preview code continuing inside WordPress + WooCommerce.
2. Decide whether to accept Upload Files for registered-account flows and return only the guest flow, or require a local email-capture run before acceptance.
3. Decide whether Attach Me meets the private proof-delivery bar for registered orders and whether guest delivery plus an actual completed byte download must be rerun before acceptance.
4. Decide if the exact A/B starter-site imports need their own bounded follow-up evidence. Do not continue to G2A2 in this execution.
