# Reviewer Decision — K3R11 Connection Reconciled / Public-Origin Rebind

Date: 2026-09-21
Status: CONNECTION RECONCILIATION PASS; PUBLIC-ORIGIN REBIND PREP AUTHORIZED

## Independent review

Reviewer independently inspected Executor commit:

`1657c2b815656e493c8100df117a77dbd413608a`

Accepted facts:

- the prior `PPCP_REST_MERCHANT_CONNECTED=NO` was caused by the diagnostic helper reading the wrong response path;
- PPCP `/wc/v3/wc_paypal/common` exposes `merchant` at the top level, not under `data`;
- corrected read-only parsing returns `merchant.isConnected=YES`;
- corrected state also returns `merchant.isSandbox=YES`;
- Sandbox/manual-connection flags remain enabled;
- onboarding remains completed;
- the Settings UI connected presentation and corrected REST state agree;
- no Disconnect, reconnect, PayPal credential request, public origin, payment, capture, version change, source change, VPS action, or secret output occurred.

Reviewer accepts:

`K3R11_CONNECTION_STATE_RECONCILIATION=PASS`

The previous claim that Secret rotation had already made the local PPCP merchant state disconnected is superseded as a probe parsing error.

## Remaining credential-safety fact

The local PPCP connection metadata is still bound to the credential material stored before Owner rotated the Sandbox Secret.

Project security policy already records:

`OLD_SANDBOX_SECRET_REUSE=FORBIDDEN`

Therefore the current local "connected" presentation must not be used as permission to continue provider calls with the previously stored credential material.

## Source review of official Disconnect

Reviewer inspected PPCP `AuthenticationRestEndpoint::disconnect()` and `AuthenticationManager::disconnect()`.

The official disconnect path:

- clears locally stored merchant authentication details;
- resets local connection/environment state;
- flushes related caches/merchant flags;
- does not require Owner credential entry;
- does not itself perform a checkout/payment/capture.

This makes one bounded local disconnect the safest way to remove the pre-rotation credential binding before public-origin testing.

## Authorized next phase

Current Gate:

`K3R11_PUBLIC_ORIGIN_REBIND_PREP`

Executor may:

1. verify the existing K3R11 rollback point is still present and valid;
2. use the official PPCP disconnect path exactly once to clear the locally stored pre-rotation merchant credentials/state;
3. verify only redacted post-disconnect state:
   - merchant connected NO;
   - credential fields absent/not-active as presence booleans only;
   - Sandbox/connection UI is ready for a fresh connection;
4. establish one temporary, reversible HTTPS public origin to the existing local Docker WordPress runtime;
5. record original and temporary WordPress home/site URL values;
6. temporarily configure WordPress to generate the public HTTPS origin;
7. verify public front-end/admin/direct PayPal Settings reachability;
8. stop at Owner checkpoint for one Manual Connect using the already-rotated Sandbox credentials through the local/public WooCommerce UI.

After Owner connection success, Executor may resume read-only/readiness verification for:

- Sandbox merchant connection;
- PPCP SDK v6 client token;
- PayPal Checkout button rendering;
- webhook registration against the public HTTPS callback.

K3R11 still stops before Sandbox buyer approval or capture.

## Not authorized

- no reuse of the old Sandbox Secret;
- no credential extraction/output;
- no Live/Production credentials;
- no real payment;
- no Sandbox buyer approval/capture yet;
- no refund;
- no VPS deployment;
- no production-domain cutover;
- no PPCP/WooCommerce/WordPress version change;
- no PPCP source patch.

## Current checkpoint

`K3R11_PUBLIC_ORIGIN_REBIND_PREP`
