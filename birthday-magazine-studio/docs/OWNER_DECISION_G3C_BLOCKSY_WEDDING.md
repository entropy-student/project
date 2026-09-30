# Owner Decision — G3C Blocksy Wedding

Date: 2026-09-30

## Decision

The Owner selected **Blocksy Wedding** as the preferred visual starter for Birthday Magazine Studio.

This **supersedes the previous Astra Bestselling Author selection for future G3C work**. The Astra decision and PR #59 remain historical provenance and must not be rewritten as though they never occurred.

Current implementation status:

```text
THEME_FAMILY=BLOCKSY
STARTER_SITE=WEDDING
PREFERRED_BUILDER=GUTENBERG
OWNER_SELECTION=APPROVED
FULL_G3C_IMPLEMENTATION=HOLD_PENDING_COMPATIBILITY_CANARY
G4_LIVE_PAYMENT_AUTHORIZED=NO
```

## Why this route is preferred

The selected route minimizes total modification cost:

- use the Wedding starter for the photo / memories / stories visual shell;
- keep WooCommerce as the already-proven canonical commerce/order system;
- keep the Good Issue browser-local preview as the core free-value / activation interaction;
- avoid requiring the starter itself to be a WooCommerce store template;
- prefer Gutenberg to minimize page-builder dependencies.

## Preserved product boundaries

This decision does not change:

- WooCommerce as canonical order system;
- US$39.99 MVP test price;
- authenticated-account MVP;
- browser-local pre-payment preview;
- zero preview model calls;
- zero preview photo upload;
- PayPal Live / real-money G4 remains HOLD;
- no production deployment / Shared VPS mutation.

## Canary prerequisite

Before full visual adaptation begins, execute the bounded compatibility canary in:

`G3CR2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY.md`

The canary must prove that the current official Wedding Gutenberg starter can be imported in an isolated runtime and that the accepted WooCommerce product/cart/checkout/account path remains usable.

Only a Reviewer PASS on that canary authorizes refreshing the full G3C implementation packet for Blocksy Wedding.
