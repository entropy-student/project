# Reviewer Decision — K4 Workspace Hygiene V2

Date: 2026-09-23
Status: AUTHORIZED
Priority: run before resuming K4_STRICT_STOREFRONT_CLEANUP

## Trigger

The shared workspace root has accumulated project-generated temporary/runtime folders again after an earlier hygiene pass.

Visible examples include:
- .tmp-k4-detail-browser-desktop
- .tmp-k4-detail-browser-mobile
- .tmp-cdp-test2
- _project-artifacts
- g4-5-owner-visual-review-runtime
- mini-craft-k3r4-docker-mariadb
- mini-craft-k3r4-mariadb-recovery
- mini-craft-kadence-poc
- mini-craft-night-kit

The purpose is not to delete aggressively. The purpose is to:
1. classify ownership and necessity;
2. remove only proven disposable material;
3. archive project-specific retained evidence/rollback material inside a canonical project artifact location;
4. prevent root clutter from recurring.

## Current active runtime — PROTECT

Active runtime remains:
mini-craft-k3r4-mariadb-recovery

Current site:
http://localhost:8093/

Do not rename, move, delete, recreate, or migrate the active runtime in this Gate.

Do not touch its Docker/MariaDB runtime dependencies.

## Never touch by default

- .git
- .clone-ui
- formwork-design
- unrelated project folders
- anything with uncertain provenance
- current project source/repo sync
- current rollback artifacts referenced by active evidence

If ownership is uncertain:
UNCLASSIFIED_LEFT_IN_PLACE

## Phase A — root inventory, read-only first

Inspect root-level entries by:
- name
- type
- size
- modified time
- whether referenced by active process/container/config/evidence
- whether it is reproducible
- whether durable evidence already exists elsewhere

Classify every visible Mini-Craft-adjacent item into exactly one category:

1. KEEP_ACTIVE
2. KEEP_PROJECT_SOURCE
3. KEEP_ROLLBACK_REFERENCED
4. ARCHIVE_PROJECT_ARTIFACT
5. SAFE_DELETE_TRANSIENT
6. UNCLASSIFIED_LEFT_IN_PLACE
7. UNRELATED_LEAVE

Do not delete during classification.

## Known likely transient candidates

The following may be deleted ONLY after positive attribution and proof they are not in use:

- .tmp-k4-detail-browser-desktop
- .tmp-k4-detail-browser-mobile
- other .tmp-k4-* / .tmp-mc-* browser/profile/capture folders created by completed Gates
- transient browser profiles/caches whose final screenshots/evidence are already committed or packaged

.tmp-cdp-test2:
- previous hygiene explicitly left it unclassified;
- it has been modified again;
- do NOT delete unless this pass can positively attribute it and prove no current session/process depends on it.

## Runtime / duplicate-looking folders

Do NOT delete merely because a folder looks old or duplicated.

For:
- mini-craft-k3r4-docker-mariadb
- mini-craft-kadence-poc
- mini-craft-night-kit
- g4-5-owner-visual-review-runtime
- _project-artifacts

determine:
- purpose;
- whether referenced by current Docker compose/container/volume/process;
- whether it contains unique rollback/source/evidence;
- whether evidence is already committed;
- whether it is disposable, archivable, or must remain.

If any uncertainty remains: KEEP.

## Canonical artifact policy

Going forward, Mini Craft local-only artifacts must not accumulate directly in the shared workspace root.

Preferred canonical location:

mini-craft-k3r4-mariadb-recovery/.artifacts/<gate>/

Use subfolders when useful:
- rollback/
- screenshots/
- browser-profile/
- helpers/
- deliverables/

If a project artifact must outlive the current runtime, use:
_project-artifacts/mini-craft-night-kit/<gate>/

but only after proving _project-artifacts is the intended shared archive.

Do not create new top-level ad-hoc runtime/capture folders.

## Permanent anti-regression rule

Every future Mini Craft Gate must end with:

WORKSPACE_TEMP_CLEANUP=<PASS | RETURN>
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
DELIVERABLE_LOCATION=
ROLLBACK_LOCATION=

Rules:
- temporary browser profiles go inside the current Gate artifact folder or OS temp;
- temporary helpers are removed at Gate end unless explicitly retained with manifest;
- visual ZIP stays under the current Gate artifact/deliverables location;
- screenshots committed to GitHub remain the durable visual archive;
- no new .tmp-k4-* directory may remain in shared root after a successful Gate;
- any unavoidable retained local artifact must have a manifest and purpose.

## Safe execution

After classification, execute only:
- deletion of SAFE_DELETE_TRANSIENT items;
- relocation of ARCHIVE_PROJECT_ARTIFACT items into the canonical artifact location when relocation is proven safe.

Do not:
- delete Docker volumes;
- stop/remove active containers;
- alter WordPress/database state;
- mutate pages/media/config;
- alter WooCommerce/PayPal/orders;
- clean other projects.

## Verification

After cleanup:
- http://localhost:8093/ HTTP 200
- WordPress container up
- MariaDB healthy
- Home/Product/Contact/FAQ/Shipping HTTP 200
- active runtime path unchanged
- Home hash unchanged
- Product Gallery CSS unchanged
- no order/payment mutation
- no secret output

## Return

GATE=K4_WORKSPACE_HYGIENE_V2
RESULT=<PASS_CANDIDATE_K4_WORKSPACE_HYGIENE_V2 | RETURN_REVIEWER_*>
SUMMARY=
ROOT_ITEMS_CLASSIFIED=
KEEP_ACTIVE=
KEEP_PROJECT_SOURCE=
KEEP_ROLLBACK_REFERENCED=
ARCHIVED=
CLEANED=
UNCLASSIFIED_LEFT_IN_PLACE=
UNRELATED_LEFT_UNTOUCHED=
ACTIVE_RUNTIME_UNCHANGED=YES
SITE_HTTP_200=YES
WORDPRESS_CONTAINER=UP
MARIADB_CONTAINER=HEALTHY
PAGE_CONFIG_MEDIA_MUTATION=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MUTATION=0
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_REMAINING=
ANTI_REGRESSION_POLICY_RECORDED=YES
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not resume K4_STRICT_STOREFRONT_CLEANUP automatically.
Do not enter K5.
