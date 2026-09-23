# Reviewer Decision — Mini Craft Project Directory Consolidation

Date: 2026-09-23
Status: AUTHORIZED

## Goal

Make the local Mini Craft project understandable as one project instead of a collection of unrelated-looking root folders.

Target canonical operational workspace:

`C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\`

Preferred structure:

```
mini-craft-night-kit-workspace/
  README_LOCAL_WORKSPACE.md
  runtime/
    current/
  rollback/
    k3r4-docker-mariadb/
    kadence-poc/
    legacy-runtime/
  artifacts/
    gates/
    deliverables/
  pointers/
    REPO_LOCATION.txt
```

## Critical Git rule

Do NOT move or restructure a directory that is part of an active Git worktree/repository until the repository boundary is proven.

Specifically inspect:
- `.git`
- `project-github-sync`
- `mini-craft-night-kit`

If `project-github-sync\mini-craft-night-kit` is part of a shared Git worktree, leave it physically where Git expects it and create only a pointer file in the canonical workspace.

Do not copy the whole repo just to make the tree look tidy.

## Active runtime

Current active runtime:
`mini-craft-k3r4-mariadb-recovery`

It MAY be moved to:
`mini-craft-night-kit-workspace\runtime\current`

only if all path dependencies are proven and the following reversible migration is possible:

1. create fresh DB/compose rollback metadata;
2. record container names, compose project, named volumes, bind mounts, ports;
3. stop only the active Mini Craft current-runtime containers;
4. move directory atomically on the same volume;
5. restart from the new compose path using the SAME named volumes and configuration;
6. verify localhost:8093 and all critical pages;
7. confirm DB/order/PayPal hashes/state unchanged.

If any bind mount, script, process, or configuration cannot be safely rewritten:
- DO NOT MOVE the active runtime;
- leave it in place;
- create a pointer/junction inside the canonical workspace;
- return `ACTIVE_RUNTIME_PHYSICAL_MOVE=DEFERRED_WITH_REASON`.

Safety is more important than cosmetic consolidation.

## Rollback/runtime folders

Inspect:
- mini-craft-k3r4-docker-mariadb
- mini-craft-kadence-poc
- mini-craft-night-kit
- g4-5-owner-visual-review-runtime

For each:
- determine whether a running container/process still references it;
- determine whether it is rollback, source, legacy runtime, or unrelated;
- stop nothing unless explicitly safe and project-owned;
- move only when references are understood;
- never delete Docker volumes.

Preferred destination for proven Mini Craft rollback dirs:
`mini-craft-night-kit-workspace\rollback\...`

If move is unsafe, leave in place and create a pointer + manifest.

## Artifact consolidation

Canonical Gate artifacts:
`mini-craft-night-kit-workspace\artifacts\gates\<gate>\`

Cross-runtime durable deliverables:
`mini-craft-night-kit-workspace\artifacts\deliverables\<gate>\`

Existing `_project-artifacts\mini-craft-night-kit` may be moved/merged only after confirming it is not shared by another active process and preserving existing files/hashes.

Historical evidence already committed to GitHub remains canonical there; do not duplicate bulky screenshots unnecessarily.

## Explicit cleanup authorization

For the completed Gate:
`k4-final-mobile-commerce-visual-polish`

After verifying:
- screenshots are committed to GitHub;
- visual ZIP exists and hash matches evidence;
- rollback SQL is retained;

DELETE the disposable Gate-local:
- four browser profiles;
- two debug screenshots;
- transient helpers/caches

Do not delete:
- visual-review ZIP;
- manifest;
- rollback SQL;
- committed evidence.

This explicit authorization resolves the prior execution-policy cleanup block.

## Existing root temp folders

Investigate:
- .tmp-cdp-test2
- .tmp-k4-detail-browser-desktop
- .tmp-k4-detail-browser-mobile

Rules:
- `.tmp-cdp-test2`: if currently referenced by Edge processes, do not kill the user's general browser. Only delete after no process references the profile and ownership is proven.
- `.tmp-k4-detail-browser-desktop/mobile`: if no process references them and contents are only Crashpad/browser temp data, ownership can be attributed to K4 by name/timestamp + K4 evidence, and deletion is authorized.
- if doubt remains, leave and document.

## Workspace index

Create:
`mini-craft-night-kit-workspace\README_LOCAL_WORKSPACE.md`

It must tell the Owner in plain language:
- where the GitHub/project docs live;
- where the current runtime lives;
- where rollback environments live;
- where local artifacts/deliverables live;
- which folders are legacy/pointers only;
- which folder should be opened for day-to-day work.

Also create:
`pointers\REPO_LOCATION.txt`
when the Git repo must remain outside the canonical workspace.

## Root cleanliness target

After Gate:
- no new Mini Craft ZIP at shared root;
- no new .tmp-k4-* or .tmp-mc-* at shared root;
- no loose Mini Craft debug screenshots at shared root;
- every remaining Mini Craft root-level folder has a documented reason or is represented through the canonical workspace.

Do not touch unrelated:
- .clone-ui
- formwork-design
- SHARED_VPS_HANDOFF.md
- workspaces unrelated to Mini Craft
- other projects

## Runtime/site verification

After any move:
- WordPress container UP
- MariaDB HEALTHY
- http://localhost:8093/ = 200
- Home/Product/FAQ/Shipping/Contact/Cart/Account = 200
- current Product Gallery behavior unchanged
- site locale remains en_US frontend / zh_CN admin
- selling/shipping countries remain US
- demo products remain non-public
- Contact form remains visible
- FAQ 9 details remain
- no order/payment/live action
- PayPal settings unchanged
- existing order baseline unchanged

## Workspace closeout contract

Return:

GATE=PROJECT_DIRECTORY_CONSOLIDATION
RESULT=<PASS_CANDIDATE_PROJECT_DIRECTORY_CONSOLIDATION | RETURN_REVIEWER_*>
SUMMARY=
CANONICAL_WORKSPACE=
REPO_PHYSICAL_LOCATION=
REPO_POINTER_CREATED=
ACTIVE_RUNTIME_PHYSICAL_LOCATION=
ACTIVE_RUNTIME_PHYSICAL_MOVE=<PASS | DEFERRED_WITH_REASON>
ROLLBACK_LOCATIONS=
ARTIFACTS_LOCATION=
CURRENT_GATE_PROFILES_DELETED=
CURRENT_GATE_DEBUG_SCREENSHOTS_DELETED=
VISUAL_ZIP_RETAINED=
ROLLBACK_SQL_RETAINED=
ROOT_MINI_CRAFT_ITEMS_BEFORE=
ROOT_MINI_CRAFT_ITEMS_AFTER=
ROOT_TEMP_ITEMS_REMAINING=
ROOT_ITEMS_REMAINING_WITH_REASON=
SITE_HTTP_200=
WORDPRESS_CONTAINER=
MARIADB_CONTAINER=
PAGE_CONFIG_MEDIA_MUTATION=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MUTATION=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
WORKSPACE_TEMP_CLEANUP=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
README_LOCAL_WORKSPACE=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not start Growth/SEO.
Do not enter K5.
