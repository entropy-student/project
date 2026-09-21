# Reviewer Decision — K3R8E Payee-Probe Parity Test

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Reviewer assessment of K3R8C Phase C

Reviewer independently inspected the Executor evidence and PPCP 4.1.3 source.

Accepted facts:
- the Owner-provided Sandbox credential pair successfully obtained an OAuth token from PayPal Sandbox (HTTP 200);
- the existing PPCP manual-connect attempt failed inside `AuthenticationManager::request_payee()` with `Failed to retrieve payee details.`;
- PPCP 4.1.3 manual connection does more than OAuth: it creates a minimal USD 1.00 PayPal order, retrieves that order, and extracts `purchase_units[0].payee.merchant_id` and `email_address`;
- PPCP catches upstream/JSON/transport failures in this probe and collapses them to the generic manual-connect error.

Not yet accepted:
- that the plugin itself is definitively defective.

Reason: the current evidence does not distinguish a PPCP implementation defect from a PayPal Sandbox/account/app capability failure in the exact create-order/get-order payee-probe sequence.

Therefore the earlier Executor label `RETURN_K3R8C_PPCP_MANUAL_CONNECT_DEFECT_CONFIRMED` is narrowed to:

`K3R8C_PPCP_MANUAL_CONNECT_PAYEE_PROBE_FAILURE_CONFIRMED`

## K3R8E goal

Reproduce the exact payee-probe semantics outside PPCP, from the active WordPress container, using the same Owner-entered Sandbox Client ID + Secret.

## Required test

Owner-run local helper, credentials entered interactively and passed only through STDIN to the container.

Inside the active WordPress container:
1. obtain Sandbox OAuth token;
2. POST `https://api-m.sandbox.paypal.com/v2/checkout/orders` with:

```json
{
  "intent": "CAPTURE",
  "purchase_units": [{
    "amount": {"currency_code": "USD", "value": "1.00"}
  }]
}
```

3. if create succeeds, GET `/v2/checkout/orders/{id}`;
4. inspect only whether `purchase_units[0].payee.merchant_id` and `email_address` are present.

## Redacted output only

```text
OAUTH_HTTP=<status>
ORDER_CREATE_HTTP=<status_or_NONE>
ORDER_GET_HTTP=<status_or_NONE>
PAYEE_OBJECT_PRESENT=YES|NO
PAYEE_MERCHANT_ID_PRESENT=YES|NO
PAYEE_EMAIL_PRESENT=YES|NO
ERROR_CLASS=<sanitized_category_or_NONE>
```

Never print/store token, Client ID, Secret, order ID, payee values, response body, Authorization header, debug ID, merchant data, or raw headers.

## Interpretation

- OAuth 200 + create 201 + get 200 + payee fields present => direct provider capability passes; PPCP 4.1.3 implementation/client path becomes the isolated failure boundary.
- OAuth 200 but create/get fails => provider Sandbox/account/app capability or request-level behavior is the failure boundary; do not call it a PPCP defect.
- create/get succeeds but payee fields are absent => PayPal response shape/capability mismatch with PPCP assumptions.

## Safety

No PPCP/WooCommerce/WordPress version change, no source patch, no persisted credentials, no Live, no real capture/payment, no VPS/tunnel. Creating the Sandbox order is test-only; do not approve/capture it.

Stop at Owner checkpoint after preparing and no-secret validating the helper.