# Reviewer Decision — K4 Owner Manual Edits Finalize

Date: 2026-09-23
Status: AUTHORIZED
Parent checkpoint: OWNER_K4_FINAL_UI_EDIT_WINDOW

## Owner manual baseline — PROTECT

Owner has completed and saved the following manual Home/Header edits. These are now the protected visual baseline and must NOT be reverted:

### Hero
- current Hero uses the newly uploaded wide background image;
- background image spans the Hero rather than remaining a standalone right-side image;
- current left-to-right light overlay/gradient is intentional;
- current left-side copy / CTA placement is intentional;
- current empty right structural column may remain if needed for layout; do not collapse or rebuild it merely because it is empty in the editor.

### Product-display section
Owner manually replaced the four replaceable product/media slots with new product imagery.
Protect the current four media assignments and their order exactly as saved.

### Header / site branding
Owner manually updated the site/header branding/logo.
Protect the current saved Header/logo state.

### Existing content
Preserve all currently saved text, palette, typography, Story, Offer copy, FAQ, reassurance, CTA, Footer, Product/Cart/Checkout surfaces, and WooCommerce/PayPal/order behavior unless explicitly authorized below.

## Problems to finalize

### A. Remove redundant Three-step section
Delete the standalone section containing:
- Open the box.
- Make together.
- Keep the memory.

Do not relocate this copy elsewhere on Home.

After deletion, normalize only the adjacent spacing so Hero flows naturally into the Three-value section.

### B. Repair Gutenberg invalid blocks in Three-value cards
Current editor shows invalid/unexpected-content warnings at the top of the three value cards:
- Less planning.
- Easy to begin.
- Something remains.

Required:
- remove only the invalid child blocks responsible for those warnings;
- preserve all three cards, titles, body copy, borders/radius/layout, and current visual styling;
- do NOT rewrite card copy;
- if the invalid blocks are the previous icon blocks, delete those broken icon blocks rather than attempting destructive recovery;
- do not add replacement icons unless required to preserve a valid existing structure.

Final target:
GUTENBERG_INVALID_BLOCK_COUNT=0

## Gate

GATE=K4_OWNER_MANUAL_EDITS_FINALIZE

Allowed changes are ONLY:
1. remove the redundant Three-step section;
2. normalize Hero→Three-value adjacent spacing;
3. remove/repair invalid child blocks inside the three value cards;
4. make only the minimum DOM/block cleanup needed for Gutenberg validity.

## Hard locks

Do not change:
- current saved Hero background image;
- Hero overlay/gradient;
- Hero copy / CTA;
- Header/logo;
- current four product images or their order;
- Story;
- Offer/product copy;
- FAQ/reassurance;
- Closing CTA;
- Footer;
- global colors/fonts;
- Product / Cart / Checkout / Account;
- WooCommerce / PayPal / order/payment state.

No image generation.
No web downloads.
No new marketing claims.
No broad CSS refactor.
No layout redesign.

## Preflight protection

Before modifying Page 939:
- capture current post_content hash;
- record current Hero media/background reference;
- record current Header/logo reference;
- record current four Offer media references/order;
- create a local rollback point if the existing process requires one.

The post-run evidence must explicitly confirm these protected references were unchanged.

## Verification

Home widths:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Required:
- Home HTTP 200;
- Three-step section absent;
- Three-value cards intact;
- Gutenberg invalid block count 0;
- no horizontal overflow;
- no clipping;
- mobile nav PASS;
- Hero protected baseline unchanged;
- Header/logo unchanged;
- four product media assignments/order unchanged;
- Product → Add to Cart → Cart → Checkout smoke PASS without payment/order;
- WooCommerce / PayPal / existing Sandbox order unchanged.

## Visual evidence

Capture and commit:
- Home desktop 1440 full-page
- Home mobile 390 full-page

Per Visual Evidence Protocol:
if screenshots cannot be rendered directly in current chat, return:
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_REQUIRED

and provide exact GitHub paths/links for both PNGs.

## Stop

Return:

GATE=K4_OWNER_MANUAL_EDITS_FINALIZE
RESULT=PASS_CANDIDATE_K4_OWNER_MANUAL_EDITS_FINALIZE
SUMMARY=
EVIDENCE=
COMMIT=
HERO_PROTECTED=YES
HEADER_LOGO_PROTECTED=YES
PRODUCT_MEDIA_PROTECTED=YES
GUTENBERG_INVALID_BLOCK_COUNT=
VISUAL_REVIEW_DELIVERY=<CHAT_ATTACHMENT | OWNER_UPLOAD_REQUIRED>
OWNER_ACTION=<NONE | UPLOAD_FINAL_SCREENSHOTS>
NEXT=STOP_AT_REVIEWER

Do not enter K5.
