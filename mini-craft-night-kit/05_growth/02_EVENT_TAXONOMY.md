# Mini Craft Night Kit — Event Taxonomy

GATE=K4_6_GROWTH_FOUNDATION_SPEC
SPECIFICATION_ONLY=YES
ANALYTICS_PROVIDER=PENDING_OWNER_SELECTION
PURCHASE_CANONICAL_TRUTH=WOO_COMMERCE_PAID_ORDER_PAYMENT_STATE

This is a future implementation contract, not permission to install analytics or send events. For behavioral events, a client signal describes an observed visit/action; WooCommerce page/cart/checkout state is the operational reference. Browser events never override server order/payment state.

## Common rules

Use an opaque event_id and UTC event time where supported. Include only the minimum event properties below. Do not collect or forward customer name, email, phone, postal/street address, form contents, passwords, cookies, access tokens, PayPal credentials/Secrets, Authorization headers, raw provider payloads, or full URLs containing query secrets/order keys. No sandbox/test purchase may enter production purchase reporting.

## view_item

- Purpose: measure a product detail view.
- Trigger: product detail content has rendered and the product identity is available; not merely a navigation click.
- Client-side signal: one view_item for the rendered product view.
- Authoritative source: rendered WooCommerce product page/product identity; this event is a behavioral measure, not a commerce transaction.
- Dedupe key: event_id + product_id for one page-view instance; do not collapse later intentional views.
- Minimum properties: event_id, event_time_utc, product_id, item_name, currency, displayed price.
- Forbidden sensitive properties: common rules above; no customer or payment fields.
- Validation method: load a product page in a test environment and confirm one event for the rendered product, with no private URL/query data.

## add_to_cart

- Purpose: measure a successful add-to-cart action.
- Trigger: WooCommerce confirms the item was added; a button click alone does not qualify.
- Client-side signal: success event from the WooCommerce add-to-cart/cart-fragments flow, if a future approved integration can observe it reliably.
- Authoritative source: WooCommerce cart state for item identity and quantity; it is not a paid order.
- Dedupe key: unique successful add-to-cart event_id/request + product_id; repeated successful additions are separate actions.
- Minimum properties: event_id, event_time_utc, product_id, quantity, currency, unit price.
- Forbidden sensitive properties: common rules above; do not send cart/session cookies or customer data.
- Validation method: compare one controlled successful action with WooCommerce cart quantity and ensure failed clicks/requests emit no success event.

## view_cart

- Purpose: measure a populated cart view.
- Trigger: Cart page has rendered with the WooCommerce cart state.
- Client-side signal: one event on cart render; an empty cart may be separately classified but must not masquerade as a populated-cart view.
- Authoritative source: WooCommerce cart contents/totals.
- Dedupe key: event_id + cart-view instance; refresh is a new view unless an approved implementation deliberately deduplicates it.
- Minimum properties: event_id, event_time_utc, item_count, currency, cart_value.
- Forbidden sensitive properties: common rules above; no coupon text or customer address.
- Validation method: compare event item count/value with the test cart and verify empty/populated states are distinguished.

## begin_checkout

- Purpose: measure entry into checkout with an eligible cart.
- Trigger: WooCommerce checkout is rendered for a non-empty valid cart.
- Client-side signal: checkout-page/event signal after successful render, not a click that redirects or fails.
- Authoritative source: WooCommerce checkout/cart state.
- Dedupe key: event_id + checkout-attempt instance; a genuinely new attempt may emit a new event.
- Minimum properties: event_id, event_time_utc, item_count, currency, cart_value.
- Forbidden sensitive properties: common rules above; never include billing/shipping fields.
- Validation method: use a non-payment test session and confirm the event follows a valid non-empty cart into a rendered checkout.

## add_payment_info

- Purpose: measure selection/confirmation of a payment method, not the transmission of payment credentials.
- Trigger: a supported payment method is selected/confirmed in the WooCommerce checkout UI.
- Client-side signal: selected method enum only; do not inspect or capture provider frames/fields.
- Authoritative source: WooCommerce checkout method selection; selection is not authorization, capture, or payment success.
- Dedupe key: event_id + checkout-attempt instance + method enum; method changes are distinct selections if the future specification chooses to count them.
- Minimum properties: event_id, event_time_utc, currency, cart_value, payment_method_type.
- Forbidden sensitive properties: common rules above; no card/bank data, PayPal account details, credentials, tokens, or provider response.
- Validation method: verify only the method enum is emitted in a controlled checkout; confirm no payment request or order is created by the test.

## purchase

- Purpose: report one verified production purchase for measurement.
- Trigger: a real WooCommerce order transitions to a paid/captured state after the payment result is durably recorded. The Thank You page/browser redirect is not the trigger of truth.
- Client-side signal: optional analytics signal only; it is not authoritative and must not independently create a purchase.
- Authoritative source: WooCommerce paid/captured order/payment state. WooCommerce remains PURCHASE_CANONICAL_TRUTH.
- Dedupe key: WooCommerce order reference + qualifying paid transition/event ID, enforced idempotently on the server-side integration.
- Minimum properties: event_id, event_time_utc, opaque transaction reference, currency, paid value, item IDs/quantities. Exclude test/Sandbox orders from production reporting.
- Forbidden sensitive properties: common rules above; no order key, buyer data, credentials, token, raw PayPal transaction payload, or Authorization header.
- Validation method: prove exactly one event for each eligible real paid order by reconciling the server-side event with WooCommerce state; replay/retry produces no duplicate; pending/failed/test orders produce zero production purchase events.

PURCHASE_EVENT_REQUIREMENT=REAL_PAID_ORDER_1_TO_1_EXACTLY_ONCE

## Provider decision (not selected)

ANALYTICS_PROVIDER=PENDING_OWNER_SELECTION

- GA4: consider when the measurement plan needs Google ecosystem reporting and acquisition measurement; review event semantics, access ownership, privacy/consent, and reporting needs before selection.
- PostHog: consider when the primary need is product-event/funnel exploration; review deployment/hosting, access ownership, privacy/consent, and operational ownership before selection.

No account, project, plugin, SDK, or event integration is created by this specification. Choose one provider only after the Measurement Owner checkpoint.