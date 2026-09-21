# Reviewer Decision — K4 Owner Business Facts Confirmed

Date: 2026-09-22
Status: OWNER BUSINESS POLICY CONFIRMED; FINAL K4 IMPLEMENTATION AUTHORIZED

## Owner decision

Owner approved the Reviewer-recommended MVP defaults and explicitly confirmed that these rules may be revised later.

These are working launch defaults, not permanent architecture constraints.

## Approved MVP business policy

### Product contents
- Publish only contents confirmed by the actual supplier / SKU packaging list.
- Do not add unverified accessory or "everything included" claims.

### Difficulty / build duration
- Position as suitable for beginners and hobbyists.
- Do not promise a fixed completion time until verified.
- Copy may state that completion time varies by builder.

### Initial shipping market
- United States initially.

### Shipping method
- Tracked Standard Shipping.
- Do not promise a fixed carrier unless operationally confirmed.

### Shipping cost
- Shipping cost is calculated or displayed at Checkout.
- Do not promise site-wide free shipping unless later approved.

### Shipping timing
- Do not publish an unverified fixed delivery-day promise.
- Use checkout/order-specific estimates where available.
- A static timing promise may be added later after supplier/logistics validation.

### Returns
- Return window: 14 days after delivery.
- Non-defective returns: unused, unassembled, original packaging.
- Buyer pays return shipping for non-defective returns, subject to later revision if operating policy changes.

### Missing / damaged items
- Customer should contact support within 7 days of delivery and provide photos where reasonably necessary.
- Replacement parts/items are the preferred first remedy.
- Refund may be used when replacement cannot reasonably be provided.

### Support
- Public support channel: Contact page/form.
- A domain-based support email should be added once the production domain/mailbox is finalized.
- Do not invent or publish a non-existent support email.

### Business / return address
- Do not publish a personal/home address.
- A formal return/business address will be added only after an operational return address is confirmed.

## Editability

All above items remain editable business configuration/content.

Future changes to supported countries, shipping carrier/cost/timing, return window/conditions, support contact, return address, product contents, and duration/difficulty wording do not require an architecture rewrite. They may be updated through normal WordPress/WooCommerce content/settings governance, provided payment/order logic is not changed.

## Authorized Executor work

Update affected Product / FAQ / Shipping & Returns / Contact content using only the approved rules above.

Then verify:
- no invented claims;
- navigation/links;
- Gutenberg validity;
- responsive rendering;
- WooCommerce behavior;
- Owner editability.

Return one final K4 PASS_CANDIDATE.

## Current Gate

`K4_UI_CONVERSION_TRUST_FINALIZE`
