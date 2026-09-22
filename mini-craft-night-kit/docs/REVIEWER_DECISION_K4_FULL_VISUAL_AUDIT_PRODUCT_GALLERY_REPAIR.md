# Reviewer Decision — K4 Full Visual Audit + Product Gallery Repair

Date: 2026-09-23
Status: AUTHORIZED
Supersedes: K4_OWNER_MANUAL_BASELINE_VERIFY

## Why this Gate changed

Owner requested one consolidated visual evidence package for the whole storefront and reported a reproducible Product detail gallery defect.

Observed Product behavior from Owner screenshots:
- initial Product load can show the expected large main image;
- after gallery interaction/state change, the main media area can collapse into a small image/thumbnail-like state while leaving a large blank area;
- this is a real UI defect and must be reproduced and repaired before K4 close.

Do not assume the root cause. Diagnose whether it is WooCommerce gallery state, Kadence layout/CSS, image sizing, flex/slider reflow, or another local interaction issue.

## Current Owner baseline — PROTECT

The CURRENT SAVED Home/Header state is authoritative.

Protect exactly:
- current Hero wide background image;
- current Hero overlay/gradient;
- current Hero copy/CTA/layout;
- current Header/logo;
- current four product-display images and order;
- all Owner-deleted Home sections remain deleted;
- current remaining Home content/section order;
- Story / FAQ / reassurance / CTA / Footer;
- WooCommerce / PayPal / order/payment behavior.

Do not restore deleted Home content from older specs/screenshots.

## Gate

GATE=K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR

This Gate has two parts:

### A. Product gallery diagnosis + minimal repair

Reproduce on the current Product page:
1. initial load;
2. click/change thumbnails/images repeatedly;
3. verify main gallery image sizing and container height after each interaction;
4. verify page refresh and viewport changes.

Expected:
- exactly one large active Product image remains visible in the main gallery area;
- thumbnails stay thumbnails;
- active image does not collapse to thumbnail dimensions;
- no large unexplained blank gallery area;
- zoom/lightbox behavior remains native if already enabled;
- mobile gallery remains usable.

Repair rules:
- preserve WooCommerce canonical gallery;
- do NOT rebuild the Product page;
- do NOT replace Woo gallery with custom JS/carousel;
- prefer native Woo/Kadence settings or minimal scoped CSS/JS only if necessary;
- document exact root cause and exact fix;
- no product/order/payment logic changes.

### B. Full storefront visual audit capture

Capture the CURRENT latest state of all core UI surfaces at:
- Desktop 1440px
- Mobile 390px

Required pages/surfaces:
1. Home
2. Shop
3. Product
4. FAQ
5. Shipping & Returns
6. Contact
7. Cart
8. Checkout
9. Thank You / Order received — use an already-existing safe Sandbox test order/state only if accessible without creating a new payment/order
10. Account

If a surface cannot be rendered safely without creating a new order/payment or requiring secrets, record it in manifest as NOT_CAPTURED with the exact reason; do not fabricate.

For Product, additionally capture:
- initial gallery state;
- post-thumbnail-interaction gallery state;
- desktop and mobile.

## Home Gutenberg validity

Owner previously saw invalid/unexpected block warnings in the editor while frontend preview rendered normally.

This Gate may inspect Gutenberg validity.

If invalid count > 0:
- report exact affected blocks/cards;
- do NOT repair those blocks in this Gate unless they directly block rendering/capture;
- return the count and affected locations to Reviewer.

## Regression verification

Home widths:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Product widths:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Required:
- Home HTTP 200;
- Product HTTP 200;
- no horizontal overflow/clipping on tested widths;
- mobile nav PASS;
- Product gallery remains stable after repeated thumbnail changes;
- Hero unchanged;
- Header/logo unchanged;
- four Home product media assignments/order unchanged;
- Owner-deleted Home sections remain deleted;
- Product → Add to Cart → Cart → Checkout smoke PASS;
- no new order;
- no payment;
- WooCommerce / PayPal / existing Sandbox order unchanged.

## Visual evidence package — REQUIRED

All screenshots from this Gate must be:
1. committed to GitHub for long-term evidence;
2. packaged into ONE ZIP for Owner transfer.

ZIP name:
K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR-visual-review.zip

ZIP contents only:
- screenshots from this Gate;
- manifest.txt

Recommended folders:
- desktop/
- mobile/
- product-gallery/
- manifest.txt

manifest.txt must include:
- Gate
- commit SHA
- page/surface
- screenshot filename
- viewport size
- Product gallery interaction state where applicable
- NOT_CAPTURED reason where applicable
- no secrets

Do not include logs, DB exports, cookies, credentials, provider payloads, unrelated files, or other projects.

Return:
VISUAL_REVIEW_PACKAGE=<absolute local zip path>
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED

## Stop

Return:

GATE=K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR
RESULT=<PASS_CANDIDATE_K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR | RETURN_REVIEWER_*>
SUMMARY=
PRODUCT_GALLERY_ROOT_CAUSE=
PRODUCT_GALLERY_FIX=
EVIDENCE=
COMMIT=
HOME_BASELINE_PROTECTED=YES
HEADER_LOGO_PROTECTED=YES
HOME_PRODUCT_MEDIA_PROTECTED=YES
DELETED_HOME_SECTIONS_RESTORED=NO
GUTENBERG_INVALID_BLOCK_COUNT=
VISUAL_REVIEW_PACKAGE=<absolute local zip path>
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED
OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP
NEXT=STOP_AT_REVIEWER

Do not enter K5.
