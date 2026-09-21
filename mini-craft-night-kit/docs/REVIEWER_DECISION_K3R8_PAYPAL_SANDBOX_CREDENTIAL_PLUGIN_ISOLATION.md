# Reviewer Decision — K3R8 PayPal Sandbox Credential / Plugin Isolation

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K3R8_PAYPAL_SANDBOX_CREDENTIAL_PLUGIN_ISOLATION`

## Trigger

Owner retried official PPCP manual Sandbox connection with Sandbox Mode enabled and a Sandbox REST App Client ID + Secret, but WooCommerce still returned:

`Could not connect to PayPal. Please verify your credentials and try again.`

## Goal

Determine whether the failure is:

1. invalid Sandbox credentials;
2. host/container network/TLS reachability;
3. valid PayPal credentials but PPCP 4.1.3 manual-connect failure.

## Safety

Secrets remain Owner-only.

Executor must never request, print, persist, commit, log, screenshot, or echo Client ID/Secret/token values.

Do not enable Live. Do not change plugin/WooCommerce/WordPress versions. Do not patch PPCP source.

## Phase A — no-secret network check

On active runtime `http://localhost:8093/`, verify from the WordPress container:

- DNS resolution for `api-m.sandbox.paypal.com`;
- outbound HTTPS/TLS reachability to PayPal Sandbox;
- no firewall/proxy/TLS failure.

If network/TLS fails:

`RETURN_K3R8_PAYPAL_SANDBOX_NETWORK_FAILURE`

## Phase B — Owner-run direct OAuth credential check

Prepare a LOCAL-ONLY PowerShell helper script for the Owner to run manually.

Requirements:

- prompt Client ID interactively;
- prompt Secret with `Read-Host -AsSecureString`;
- credentials exist only in process memory;
- POST to `https://api-m.sandbox.paypal.com/v1/oauth2/token` with `grant_type=client_credentials`;
- output only redacted status such as HTTP/result/token_received yes/no;
- do not print access token, Client ID, Secret, Authorization header, response body, app_id, or merchant data;
- do not write credentials/token to disk/log/history/GitHub;
- clear plaintext variables in finally where practical.

Owner must execute the helper locally; Executor must not fabricate the result.

Interpretation:

- OAuth authentication failure => `RETURN_K3R8_SANDBOX_CREDENTIALS_INVALID`;
- OAuth HTTP 200/token received => proceed to Phase C.

## Phase C — PPCP-isolated interpretation

If PayPal direct OAuth succeeds and Phase A network/TLS is healthy, record:

`PAYPAL_SANDBOX_DIRECT_OAUTH=PASS`

Then inspect only redacted WooCommerce/PPCP error logs and the manual-connect REST response/error code around the failed connection attempt.

Do not expose secrets/tokens.

If the plugin still rejects the same valid credentials, return:

`RETURN_K3R8_PPCP_4_1_3_MANUAL_CONNECT_DEFECT`

Do not retry credentials repeatedly.

## Evidence

Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` with redacted results only.

Stop at Reviewer.