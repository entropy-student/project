# Reviewer Decision — K4 Home Detail Polish

Date: 2026-09-22
Status: AUTHORIZED
Parent checkpoint: OWNER_K4_FINAL_UI_EDIT_WINDOW

## Source of truth

The current GPT-6-upgraded Home is the visual baseline.

Do not revert it toward an older mockup. The earlier design reference may be used only for visual ideas such as product-image density, icon rhythm, and detail hierarchy.

## Goal

Improve the current Home from "good template adaptation" to a more complete branded storefront through a bounded detail pass.

## Locked

Do not change:
- Hero composition, hero image treatment, or overlay/transparency in this pass;
- current GPT-6 visual direction;
- global palette;
- typography system;
- existing copy except tiny label corrections if required for layout;
- WooCommerce / PayPal / order/payment behavior;
- Header/Footer mechanics;
- responsive system.

## Allowed changes

### 1. Offer / product-content visual density

In the existing "What the night is built around" / equivalent offer section, add four replaceable media slots above or within the existing four content items.

Rules:
- 4:3 target ratio;
- native Gutenberg/Kadence structure;
- Owner-replaceable in editor;
- no generated images;
- no web-sourced images;
- prefer existing approved Media Library product-like assets if clearly suitable;
- otherwise use clearly temporary, neutral visual placeholders that do not imply confirmed SKU contents;
- no exact contents claims unless already supplier-confirmed.

The four slots are structural placeholders for future product/contents imagery.

### 2. Native line icons

Add consistent burgundy line icons using existing Kadence/native icon capability, not generated image files.

Apply where useful to:
- Open the box / Make together / Keep the memory;
- three value cards;
- compact trust/reassurance items.

Keep icon use restrained and consistent.

### 3. Small polish

Allowed:
- thin borders/dividers;
- consistent card radius already defined by the design system;
- minor vertical alignment/gap normalization;
- subtle surface grouping using existing palette tokens.

Do not add:
- new animation framework;
- large custom CSS;
- absolute positioning;
- gradients/glass effects;
- fake badges;
- extra marketing claims.

## Old mockup boundary

Do NOT copy unverified content from the earlier mockup, including:
- exact contents;
- "everything you need";
- fixed shipping days;
- 30-day returns;
- reviews/ratings;
- guarantees;
- social proof.

Use the old mockup only as a visual-density reference.

## Executor image restriction

EXECUTOR_IMAGE_GENERATION=FORBIDDEN

Do not call or simulate image-generation tools.

## Verification

Because only Home is changed in this pass, verify Home at:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Also verify:
- Home HTTP 200;
- Gutenberg invalid block count 0 for Home;
- no horizontal overflow;
- mobile nav remains functional;
- Add to Cart / Cart / Checkout smoke remains healthy without payment;
- current GPT-6 Hero remains unchanged;
- WooCommerce/PayPal settings and existing Sandbox order unchanged.

Capture:
- Home desktop 1440 full-page;
- Home mobile 390 full-page.

Avoid leaving root-level temporary capture/profile directories after verification. Clean task-generated temporary artifacts before returning.

## Stop

Return:
GATE=K4_HOME_DETAIL_POLISH
RESULT=PASS_CANDIDATE_K4_HOME_DETAIL_POLISH
SUMMARY=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not enter K5.
