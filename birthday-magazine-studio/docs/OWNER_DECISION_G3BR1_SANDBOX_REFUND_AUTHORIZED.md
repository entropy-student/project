# Owner Decision — G3BR1 Sandbox Refund Authorized

Date: 2026-09-28  
Gate: `G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND`

## Authorization

Owner explicitly authorizes exactly one consequential provider action:

- WooCommerce order: **#30**
- Environment: **PayPal Sandbox only**
- Action: **one full refund**
- Path: **WooCommerce → official WooCommerce PayPal Payments / PPCP**
- Purpose: verify refund correlation, entitlement revocation, and cancellation of the deferred generation-ready job/action.

## Boundaries

This authorization does **not** allow:

- a second refund;
- a second payment or capture;
- PayPal Live;
- real-money refund;
- a different WooCommerce order;
- direct hand-written PayPal refund API calls outside the official PPCP path;
- any AI/model provider call;
- production-domain/VPS deployment;
- any Secret/token/cookie export.

If the refund result is ambiguous, partially fails, or requires replay, stop and return to Reviewer/Owner. Do not retry the refund automatically.
