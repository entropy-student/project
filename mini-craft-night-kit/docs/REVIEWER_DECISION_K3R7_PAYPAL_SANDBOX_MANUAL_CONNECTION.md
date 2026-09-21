# Reviewer Decision — K3R7 Manual Sandbox Connection

Date: 2026-09-21
Status: OWNER ACTION AUTHORIZED

## Gate

`K3R7_PAYPAL_SANDBOX_MANUAL_CONNECTION`

## Accepted current state

Owner reported the provider-side PayPal authorization page completed, but read-only local inspection on the active Docker/MariaDB runtime showed:

```text
PAYPAL_PROVIDER_AUTH=OWNER_REPORTED_PASS
PAYPAL_MERCHANT_CONNECTED=NO
PAYPAL_ONBOARDING_COMPLETED=NO
PAYPAL_SANDBOX_MODE=NO
MERCHANT_ID=ABSENT
```

The PPCP settings/payment REST endpoints return HTTP 200, but local merchant connection state was not written.

Therefore the automatic onboarding attempt is not accepted as a Sandbox connection.

## Decision

Do NOT create a public callback/tunnel yet.

Use the official WooCommerce PayPal Payments manual Sandbox connection path on the active local runtime. This is the preferred bounded bypass because the official plugin supports manual connection with Sandbox Client ID and Secret Key when automatic onboarding is not possible.

## Owner-only steps

Active runtime:

`http://localhost:8093/`

1. Open the direct PayPal settings page.
2. Use the Back navigation inside PPCP setup to return to the Welcome page if currently on `Complete Your Payment Setup`.
3. Open `See advanced options`.
4. Enable `Sandbox Mode` / select Sandbox.
5. Choose `Manually Connect`.
6. In PayPal Developer Dashboard, use/create a SANDBOX REST app associated with the Sandbox Business merchant account.
7. Enter the SANDBOX Client ID and SANDBOX Secret directly into the local WooCommerce UI.
8. Click `Connect Account`.

Never paste the Client ID/Secret, password, token, OAuth code, cookie, or webhook secret into ChatGPT, Codex, GitHub, evidence files, screenshots intended for publication, or logs.

## Validation after Owner action

Executor may perform only redacted/read-only validation and must report:

```text
PAYPAL_MERCHANT_CONNECTED
PAYPAL_ONBOARDING_COMPLETED
PAYPAL_SANDBOX_MODE
MERCHANT_ID_PRESENT
PAYPAL_GATEWAY_ENABLED
```

Do not print any credential value.

Expected success state:

```text
PAYPAL_MERCHANT_CONNECTED=YES
PAYPAL_ONBOARDING_COMPLETED=YES
PAYPAL_SANDBOX_MODE=YES
MERCHANT_ID_PRESENT=YES
```

If successful, return:

`PASS_CANDIDATE_K3R7_PAYPAL_SANDBOX_MANUAL_CONNECTION`

If manual connection cannot be completed, return:

`RETURN_K3R7_MANUAL_SANDBOX_CONNECTION_FAILED`

## Important

- Do not resume or accept the previous non-Sandbox automatic onboarding state.
- Do not enable Live.
- Do not create a tunnel/public callback yet.
- Do not run a real payment.
- Do not change plugin/WooCommerce versions.

Webhook/public callback validation remains a later K3 substep after Sandbox merchant connection is confirmed.