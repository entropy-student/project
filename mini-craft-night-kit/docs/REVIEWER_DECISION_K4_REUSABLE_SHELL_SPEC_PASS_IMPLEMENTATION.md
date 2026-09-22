# Reviewer Decision — K4 Reusable Storefront Shell Spec PASS / Implementation Authorized

Date: 2026-09-22
Status: SPEC COMPLETE; IMPLEMENTATION AUTHORIZED

## Reviewer-owned design decision

The reusable storefront specification is fixed in:
- docs/UI_DESIGN_SYSTEM.md
- docs/STOREFRONT_RESKIN_MAP.md

Owner-approved operating model:
FUTURE_RESKIN_NORMAL_SCOPE=IMAGES_TEXT_GLOBAL_COLORS
LAYOUT_REBUILD=NORMALLY_NO
WOOCOMMERCE_FLOW_REBUILD=NO
PAYMENT_LOGIC_REBUILD=NO

## Current Gate

K4_REUSABLE_STOREFRONT_SHELL_IMPLEMENTATION

Executor must implement the Reviewer-owned specification using existing Kadence/Gutenberg/WooCommerce architecture.

## Critical constraints

EXECUTOR_IMAGE_GENERATION=FORBIDDEN

Use only:
- existing approved project images;
- existing Media Library images;
- replaceable neutral placeholders when a final image is unavailable.

Functionality and responsive behavior outrank visual parity.

Mandatory regression widths:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Must preserve:
- Gutenberg validity
- Kadence responsive mechanics
- Product/Add to Cart
- Cart
- Checkout
- Account
- existing WooCommerce order semantics
- PayPal configuration/state
- existing Sandbox paid test order unchanged

## Protected commerce surfaces

Cart / Checkout / Thank You / Account may inherit global tokens only. Do not redesign their structure.

## Implementation pages

Primary layout adaptation:
- Home
- Product
- FAQ
- Shipping & Returns
- Contact

Brand-only/global styling:
- Shop
- Cart
- Checkout
- Thank You / Order Received
- My Account

## Evidence required

Return:
- exact sections changed/reused
- image slots and source/placeholder status
- global tokens applied
- Gutenberg invalid-block count
- responsive matrix
- horizontal-overflow checks
- Product/Add-to-Cart/Cart/Checkout smoke without real payment
- WooCommerce/PayPal version and setting preservation
- before/after screenshots for Home/Product/FAQ/Shipping/Contact desktop + mobile

## Stop

Return PASS_CANDIDATE_K4_REUSABLE_STOREFRONT_SHELL_IMPLEMENTATION or a bounded RETURN result.

No K5, VPS, Live PayPal, real payment, refund, or production-domain action.
