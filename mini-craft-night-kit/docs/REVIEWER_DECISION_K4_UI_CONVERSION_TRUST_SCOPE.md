# Reviewer Decision — K4 UI + Conversion & Trust Scope

Date: 2026-09-22
Status: K4 SCOPE UPDATED

## Decision

K4 remains a single Gate and is expanded to include the Owner-requested UI modification stage before final Conversion & Trust acceptance.

Current Gate:

`K4_UI_CONVERSION_TRUST`

## K4 execution order

1. **UI Modification**
   - Home
   - Product
   - FAQ
   - Shipping & Returns
   - Contact
   - typography, spacing, imagery, section hierarchy, CTA presentation, trust-module presentation
   - preserve Kadence starter-template structural base
   - preserve WooCommerce canonical commerce behavior
   - do not rebuild Cart / Checkout / Account core flows

2. **Conversion & Trust**
   - offer clarity
   - CTA clarity
   - trust presentation
   - product/business truth
   - FAQ completeness
   - shipping/returns clarity
   - contact clarity
   - Owner editability

3. **K4 acceptance**
   - UI and conversion/trust are reviewed together before entering K5 RC QA.

## Owner editing window

Owner may directly modify UI/content within K4 on the approved pages.

To avoid edit collisions:
- Executor should not simultaneously modify the same page/block while Owner is actively editing it.
- Before Executor resumes implementation on a page changed by Owner, it should re-read the current WordPress/page state and treat the latest Owner-approved state as the working baseline.
- Owner UI edits do not require a new Gate unless they alter commerce/payment behavior.

## Protected areas

Do not change without a separate Reviewer decision:

- Cart core flow
- Checkout core flow
- Account core flow
- PayPal configuration
- WooCommerce order/payment state logic

## K4 acceptance target

```text
UI_MODIFICATION=PASS
HOME_CONVERSION_TRUST=PASS
PRODUCT_CONVERSION_TRUST=PASS
FAQ=PASS
SHIPPING_RETURNS=PASS
CONTACT=PASS
BUSINESS_TRUTH=PASS
OWNER_EDITABILITY=PASS
RESPONSIVE=PASS
GUTENBERG_VALIDITY=PASS
WOOCOMMERCE_BEHAVIOR=PASS
```

K5 remains Release Candidate QA after K4 PASS.
