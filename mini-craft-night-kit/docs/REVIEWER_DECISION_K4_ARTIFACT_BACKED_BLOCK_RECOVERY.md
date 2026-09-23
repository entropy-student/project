# Reviewer Decision — K4 Artifact-Backed Native Block Recovery

Date: 2026-09-23
Status: AUTHORIZED
Parent Gate: K4_NATIVE_BLOCK_RECOVERY_CONTACT_FAQ
Trigger: RETURN_REVIEWER_K4_GUTENBERG_EDITOR_SESSION_UNAVAILABLE

## Reviewer determination

The second stop is also correct.

The failure is an editor-session/browser-automation availability problem, not a new site defect:
- no page/config/block mutation occurred;
- no screenshots/ZIP were created;
- WordPress/MariaDB remain healthy;
- Home/Product/Contact/FAQ/Shipping all return HTTP 200.

Do not retry the same unreliable editor-session path.

A deterministic artifact-backed recovery path is now authorized.

## Gate

GATE=K4_ARTIFACT_BACKED_BLOCK_RECOVERY

This Gate still repairs ONLY the 11 known invalid blocks:
- Contact page 10: Kadence Form 1 + core/column 3
- FAQ page 1121: core/details 7

The broader K4_STRICT_STOREFRONT_CLEANUP remains paused.

## Known local evidence sources

Search read-only under the active runtime project for retained K4 rollback artifacts, especially:
- .artifacts/k4-copy-preflight-20260922-144817/pages.json
- .artifacts/k4-finalize-preflight-20260922-025529
- .artifacts/k4-preflight-20260922-011148
- other retained K4 page/content snapshots created before the corruption boundary

Evidence history records a K4 content-fill state with:
- Gutenberg invalid block count 0
- Contact form fields 3
- Contact form render PASS
- FAQ native details valid

Do not assume any artifact is usable merely because it exists. Compare exact content/fields before using it.

## Phase A — read-only recovery-source discovery

1. Inventory retained local K4 rollback/page snapshots.
2. For Contact page 10, locate the newest known-good serialized Kadence Form block that satisfies ALL:
   - block type is current registered Kadence Form;
   - fields are exactly Name / Email / Message;
   - types are text / email / textarea;
   - required semantics preserved;
   - button is Send message;
   - no invented public support email/phone/address;
   - no external webhook/integration;
   - compatible with current Kadence Blocks 3.7.11;
   - source predates the current invalid-form corruption and was previously validated as editor-safe/render-safe.
3. Record source artifact path/hash and block hash.
4. If no exact known-good Kadence Form block exists:
   RETURN_REVIEWER_K4_NO_EXACT_KADENCE_FORM_RECOVERY_SOURCE
   and make zero mutation.

## Phase B — bounded repair without Gutenberg GUI automation

### Contact Kadence Form

If and only if Phase A finds an exact known-good form:
- replace ONLY the current invalid Kadence Form serialized block with the exact known-good serialized block bytes;
- do not hand-author or synthesize Kadence plugin markup;
- do not alter surrounding content.

### Contact core/column ×3

Repair only invalid core/column targets using WordPress core parse/serialize functions.
Preserve:
- same column count/order;
- exact heading text;
- exact paragraph text;
- exact links;
- same surrounding structure.

Convert any naked paragraph HTML inside columns into registered core/paragraph children via WordPress core serialization.

### FAQ core/details ×7

Use current saved FAQ text as authority.
Rebuild ONLY the seven invalid core/details blocks using WordPress core parse/serialize functions:
- same summary text;
- same answer text;
- same links;
- same order;
- registered core/paragraph children;
- no raw HTML substitute;
- no copy cleanup in this Gate.

## Write method

Use a transient local-only PHP/WP helper or equivalent deterministic WordPress-core path:
- parse_blocks / serialize_block / serialize_blocks for core blocks;
- exact artifact bytes for the Kadence Form block.

Before write:
- save current page-local content/hash;
- confirm target block boundaries;
- record non-target block signatures.

After write:
- remove transient helper;
- compare non-target signatures.

Do not run whole-page parse→serialize.
Do not change unrelated blocks.

## Validation without editor GUI

Required deterministic checks:
- parse_blocks returns all expected registered block names;
- no malformed block delimiter structure;
- Contact do_blocks/frontend output visibly contains:
  - Name input
  - Email input
  - Message textarea
  - Send message button
- FAQ do_blocks/frontend output contains 7 details elements with expected summaries;
- Contact/FAQ HTTP 200;
- current text/links preserved;
- Shipping page unchanged;
- Home hash unchanged;
- Product Gallery CSS unchanged;
- locale/product/PayPal/order state unchanged.

If reliable Gutenberg editor automation becomes available during validation, additionally confirm editor invalid count 0.
If editor automation remains unavailable, return:
GUTENBERG_EDITOR_VISUAL_VALIDATION=PENDING_SESSION
and do NOT claim final Gutenberg Editor PASS.

## Screenshots

If frontend screenshot capture is available independently of the editor-session issue, capture:
- Contact 1440 / 390
- FAQ 1440 / 390

and package:
K4_ARTIFACT_BACKED_BLOCK_RECOVERY-visual-review.zip

If screenshot automation is also unavailable:
- do not fabricate;
- return VISUAL_REVIEW_PACKAGE=NOT_CREATED_AUTOMATION_UNAVAILABLE;
- Reviewer will decide a separate capture-only Gate.

## Protected scope

No changes to:
- Home
- Hero/Header/Logo
- Product
- Product Gallery/CSS
- Shop/product status/taxonomy
- site/admin locale
- Shipping & Returns
- WooCommerce
- PayPal
- orders/payments
- business-policy facts

NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0

## Return

GATE=K4_ARTIFACT_BACKED_BLOCK_RECOVERY
RESULT=<PASS_CANDIDATE_K4_ARTIFACT_BACKED_BLOCK_RECOVERY | RETURN_REVIEWER_*>
SUMMARY=
RECOVERY_SOURCE_INVENTORY=
KADENCE_FORM_RECOVERY_SOURCE=
KADENCE_FORM_SOURCE_HASH=
CONTACT_INVALID_TARGETS_REPAIRED=<YES | NO>
FAQ_INVALID_TARGETS_REPAIRED=<YES | NO>
CONTACT_FRONTEND_FIELDS=<NAME_EMAIL_MESSAGE_SEND | RETURN>
FAQ_DETAILS_FRONTEND_COUNT=
NON_TARGET_BLOCK_SIGNATURES_PRESERVED=<YES | NO>
GUTENBERG_EDITOR_VISUAL_VALIDATION=<PASS_0_INVALID | PENDING_SESSION>
HOME_PROTECTED=YES
PRODUCT_GALLERY_PROTECTED=YES
SITE_LOCALE_UNCHANGED=YES
PRODUCT_STATE_UNCHANGED=YES
PAYPAL_ORDER_STATE_UNCHANGED=YES
EVIDENCE=
COMMIT=
VISUAL_REVIEW_PACKAGE=<absolute local zip path | NOT_CREATED_AUTOMATION_UNAVAILABLE>
VISUAL_REVIEW_DELIVERY=<OWNER_UPLOAD_ZIP_REQUIRED | NOT_APPLICABLE>
OWNER_ACTION=<UPLOAD_VISUAL_REVIEW_ZIP | NONE>
NEXT=STOP_AT_REVIEWER

Do not resume K4_STRICT_STOREFRONT_CLEANUP automatically.
Do not enter K5.
