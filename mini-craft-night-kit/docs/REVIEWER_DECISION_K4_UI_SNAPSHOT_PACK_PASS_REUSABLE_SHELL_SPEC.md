# Reviewer Decision — K4 UI Snapshot Pack PASS / Reusable Storefront Shell Spec

Date: 2026-09-22
Status: SNAPSHOT PACK ACCEPTED; NON-MUTATING SHELL SPEC AUTHORIZED

## Snapshot Pack review

Reviewer independently inspected the snapshot archive commits:

- `53160d147684d6ee7342c723a1272bc607450a22`
- clarification: `4909653e5f580ff74bd44fa96c675cade2dd4a75`

Accepted:

```text
SNAPSHOT_PACK=PASS
PAGE_COUNT=10
SCREENSHOT_COUNT=20
DESKTOP_VIEWPORT=1440x900
MOBILE_VIEWPORT=390x844
PNG_INTEGRITY=20_OF_20_VALID
PAGE_OR_CONFIGURATION_CHANGES=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
OWNER_K4_UI_EDIT_WINDOW_PRESERVED=YES
```

Captured page families:

- Home
- Shop / Store
- Product
- FAQ
- Shipping & Returns
- Contact
- Cart
- Checkout
- Thank You / Order Received route
- My Account / Orders

## State caveats

- Checkout screenshot represents the anonymous empty-cart baseline.
- Thank You / Order Received screenshot currently represents the anonymous login gate, not the full authenticated/order-key confirmation presentation.
- These caveats do not block the current design-system task because transactional structure is protected and is not an Owner UI-redesign target.

## Owner design objective

The Owner's intended storefront model is now explicit:

> Preserve the reusable page/layout structure. Future product-site changes should normally require only:
> 1. image replacement;
> 2. text/content replacement;
> 3. color/theme-token replacement.

The normal re-skin path should not require rebuilding page layouts, WooCommerce flows, or commerce logic.

## Authorized next work

Current design sub-gate:

`K4_REUSABLE_STOREFRONT_SHELL_SPEC`

This phase is documentation/audit only. It must not modify live WordPress pages.

Produce one current design specification that maps the snapshot pack and actual editable page structure into:

### A. Fixed shell
- layout hierarchy;
- section order;
- Header/Footer structure;
- WooCommerce product/cart/checkout/account structure;
- reusable cards/accordion/form structures;
- responsive behavior.

### B. Replaceable content layer
- images;
- copy/headlines/body/CTA labels;
- product data owned by WooCommerce;
- FAQ/policy/contact copy.

### C. Replaceable brand-token layer
- primary/accent/background/text colors;
- button colors;
- global typography only where safely theme-controlled;
- surface/border token guidance.

### D. Per-page replacement map
For every captured page, document:
- what Owner should replace for a new product;
- what should normally remain untouched;
- where the edit is made in WordPress/WooCommerce;
- whether replacement is Image / Text / Color / Product Data;
- any business-truth constraint.

### E. Re-skin checklist
Define a compact workflow so a future product site can be re-skinned without layout rebuilding.

Recommended output:
- `docs/UI_DESIGN_SYSTEM.md`
- `docs/STOREFRONT_RESKIN_MAP.md`

## Important constraint

Do not redesign or mutate the site during this Gate.

The current screenshots are evidence inputs. Owner UI editing remains deferred until this reusable-shell specification is reviewed.

## Protected

- Cart / Checkout / Account structure;
- PayPal configuration;
- WooCommerce payment/order logic;
- plugin/theme versions;
- live page content during this documentation Gate.

## Current Gate

`K4_REUSABLE_STOREFRONT_SHELL_SPEC`
