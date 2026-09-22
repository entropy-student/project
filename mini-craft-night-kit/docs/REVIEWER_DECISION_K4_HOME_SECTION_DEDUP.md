# Reviewer Decision — K4 Home Section Dedup Final Pass

Date: 2026-09-22
Status: AUTHORIZED
Parent checkpoint: OWNER_K4_FINAL_UI_EDIT_WINDOW

## Owner visual decision

The current final-polish Home was visually reviewed by Owner and Reviewer.

Decision:
REMOVE the standalone Three-step strip:
- Open the box.
- Make together.
- Keep the memory.

Reason:
Its purpose (simple process framing) is materially redundant with the following Three-value section in the current Home composition, and both sections use similar icon/text rhythm. Keeping both weakens density and repeats the same message.

## Keep

Preserve the current Three-value section:
- Less planning.
- Easy to begin.
- Something remains.

This section carries the stronger benefit/value framing and remains the immediate post-Hero section.

Do not relocate the deleted Three-step copy elsewhere in Home during this Gate.

## Exact implementation scope

GATE=K4_HOME_SECTION_DEDUP

Allowed:
- delete only the standalone Three-step strip from Home Page 939;
- close the resulting gap so Hero flows naturally into the Three-value section;
- normalize only the adjacent section spacing needed after deletion.

Locked:
- Hero content/image/CTA/typography;
- Three-value cards/content/icons;
- Story section;
- Offer/product-display section;
- FAQ/reassurance;
- Closing CTA;
- Footer;
- Header;
- global palette/fonts;
- Product / Cart / Checkout;
- WooCommerce / PayPal / order/payment state.

No image generation.
No copy rewrite.
No new section.

## Verification

Verify Home:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Required:
- Home HTTP 200;
- Three-step strip absent;
- Three-value section intact;
- Gutenberg invalid block count 0;
- no horizontal overflow or clipping;
- mobile nav pass;
- Product → Add to Cart → Cart → Checkout smoke PASS with no order/payment;
- WooCommerce / PayPal / existing Sandbox order unchanged.

Capture:
- Home desktop 1440 full-page;
- Home mobile 390 full-page.

## Visual evidence delivery

Commit both screenshots to GitHub.

If the toolchain cannot attach those PNGs directly into the current chat, return:
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_REQUIRED

and include the exact GitHub paths/links so Owner can download and upload them manually.

Do not claim Visual PASS yourself.

## Stop

Return:

GATE=K4_HOME_SECTION_DEDUP
RESULT=PASS_CANDIDATE_K4_HOME_SECTION_DEDUP
SUMMARY=
EVIDENCE=
COMMIT=
VISUAL_REVIEW_DELIVERY=<CHAT_ATTACHMENT | OWNER_UPLOAD_REQUIRED>
OWNER_ACTION=<NONE | UPLOAD_FINAL_SCREENSHOTS>
NEXT=STOP_AT_REVIEWER

Do not enter K5.
