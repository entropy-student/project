# Mini Craft Night Kit — UTM Standard

GATE=K4_6_GROWTH_FOUNDATION_SPEC
SPECIFICATION_ONLY=YES
NO_LIVE_CAMPAIGNS_CREATED=YES

## Parameters

Required: utm_source, utm_medium, utm_campaign

Optional: utm_content, utm_term

## Naming rules

- lowercase; use ASCII letters/numbers where practical.
- separate words with hyphens; no spaces or ad hoc punctuation.
- use stable, controlled source and medium vocabularies; one accountable campaign owner approves new values.
- keep campaign names stable across links that belong to the same campaign.
- never put names, emails, phone numbers, order/customer identifiers, or other PII in any UTM value.
- use utm_content for a stable creative/placement label and utm_term only for a non-PII paid-search keyword/theme where applicable.
- do not invent a live campaign or add tags to production links as part of this document.

## Naming examples only — not live campaigns

| Example channel | utm_source | utm_medium | utm_campaign |
|---|---|---|---|
| Organic social | tiktok | organic-social | date-night-validation |
| Creator | creator-partner | creator | date-night-validation |
| Email | owned-email | email | date-night-validation |
| Paid social | meta | paid-social | date-night-validation |
| Paid search | google | paid-search | date-night-validation |

These values illustrate syntax only. They do not assert an active channel, approved spend, creator, or campaign. Organic search-result traffic should be measured from referrer/Search Console reporting; do not add UTMs to Google’s organic result URLs.

## Reconciliation with WooCommerce attribution

1. Keep WooCommerce order/payment state as the canonical transaction record; UTM values are attribution context, not purchase truth.
2. Preserve the approved UTM values and their capture context in the future measurement implementation; do not silently rename values between systems.
3. Compare WooCommerce order-attribution fields with analytics source/medium/campaign using an access-controlled internal reconciliation keyed by an opaque WooCommerce order reference. Do not export order keys or customer data.
4. Reconcile eligible paid-order counts/value separately from analytics event counts. A browser event must never create, remove, or change an order.
5. Treat differences (missing consent, attribution window, direct return, blocked browser event, duplicate signal) as measurement discrepancies to investigate, not grounds to overwrite WooCommerce truth.
6. Choose and document first-touch/last-touch reporting semantics before provider implementation; this template does not select an attribution model.

ATTRIBUTION_MODEL=PENDING_OWNER_SELECTION
PURCHASE_CANONICAL_TRUTH=WOO_COMMERCE_PAID_ORDER_PAYMENT_STATE