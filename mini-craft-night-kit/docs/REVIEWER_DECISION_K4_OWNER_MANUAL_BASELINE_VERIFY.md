# Reviewer Decision — K4 Owner Manual Edits Verification

Date: 2026-09-23
Status: AUTHORIZED
Supersedes: docs/REVIEWER_DECISION_K4_OWNER_MANUAL_EDITS_FINALIZE.md
Parent checkpoint: OWNER_K4_FINAL_UI_EDIT_WINDOW

## New Owner baseline

Owner has manually saved additional Home changes after the previous decision.

The CURRENT SAVED Home/Header state is now authoritative.

Important:
- the Three-step section has already been deleted by Owner;
- Owner also manually deleted other Home content/sections;
- Executor must NOT restore, reconstruct, or infer any deleted section;
- current Hero, Header/logo, product images, copy, section order, spacing, and all remaining content are protected exactly as they exist now.

## Invalid-block handling

Owner observed Gutenberg invalid/unexpected-content warnings in the editor on the Three-value cards, but the frontend preview currently renders normally.

This Gate is NOT authorized to delete or repair those blocks proactively.

Executor must:
1. inspect and report Gutenberg validity;
2. perform NO block recovery, no invalid-child deletion, and no reserialization solely to remove warnings;
3. if invalid block count is 0, continue verification;
4. if invalid block count is greater than 0, STOP and return a bounded Reviewer issue with exact affected block/card identification, without modifying those blocks.

Frontend rendering alone does not override Gutenberg validity evidence.

## Gate

GATE=K4_OWNER_MANUAL_BASELINE_VERIFY

This is primarily a verification/capture Gate.

Allowed writes:
- only evidence files / screenshots / handoff artifacts;
- no Home content mutation unless required solely for non-content test instrumentation and fully reversible.

Forbidden:
- restoring deleted sections;
- deleting any additional section;
- changing Hero;
- changing Header/logo;
- changing product images or order;
- changing Three-value cards;
- changing copy/colors/fonts/layout;
- repairing invalid blocks;
- WooCommerce/PayPal/order/payment mutation.

## Preflight record

Record current:
- Home post_content hash;
- Hero background/media reference;
- Header/logo reference;
- four product media references/order;
- current top-level Home block/section signature.

These become the current Owner baseline.

## Verification

Home widths:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Required:
- Home HTTP 200;
- current saved section order preserved;
- no deleted section restored;
- no horizontal overflow;
- no clipping;
- mobile nav PASS;
- Hero unchanged;
- Header/logo unchanged;
- four product media assignments/order unchanged;
- Gutenberg invalid block count reported;
- Product → Add to Cart → Cart → Checkout smoke PASS without order/payment;
- WooCommerce / PayPal / existing Sandbox order unchanged.

If GUTENBERG_INVALID_BLOCK_COUNT > 0:
RESULT=RETURN_REVIEWER_K4_GUTENBERG_INVALID_BLOCKS_REMAIN
Do not attempt repair.

If GUTENBERG_INVALID_BLOCK_COUNT = 0 and all other checks pass:
RESULT=PASS_CANDIDATE_K4_OWNER_MANUAL_BASELINE_VERIFY

## Visual evidence

Capture and commit:
- Home desktop 1440 full-page
- Home mobile 390 full-page

Per Visual Evidence Protocol:
- commit the screenshots to GitHub;
- package all screenshot evidence from this Gate into one ZIP;
- ZIP must contain only this Gate's visual screenshots plus a non-sensitive manifest;
- return the ZIP's exact absolute local path for Owner transfer.

Required return fields:
VISUAL_REVIEW_PACKAGE=<absolute local zip path>
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED

Owner will upload the ZIP to Reviewer for visual inspection.

## Return

GATE=K4_OWNER_MANUAL_BASELINE_VERIFY
RESULT=<PASS_CANDIDATE_K4_OWNER_MANUAL_BASELINE_VERIFY | RETURN_REVIEWER_K4_GUTENBERG_INVALID_BLOCKS_REMAIN>
SUMMARY=
EVIDENCE=
COMMIT=
CURRENT_HOME_BASELINE_CAPTURED=YES
HERO_PROTECTED=YES
HEADER_LOGO_PROTECTED=YES
PRODUCT_MEDIA_PROTECTED=YES
DELETED_SECTIONS_RESTORED=NO
GUTENBERG_INVALID_BLOCK_COUNT=
VISUAL_REVIEW_PACKAGE=<absolute local zip path>
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED
OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP
NEXT=STOP_AT_REVIEWER

Do not enter K5.
