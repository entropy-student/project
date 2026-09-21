# Reviewer Decision — K3R8C Container-Native OAuth Check + Diagnostic Packet

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Trigger

Corrected host PowerShell helper still returned:

`PAYPAL_SANDBOX_OAUTH=FAIL CATEGORY=POWERSHELL_REQUEST_EXCEPTION`

This remains a host/helper failure, not a PayPal credential verdict.

## Process correction

All diagnostic returns from this Gate must include the mandatory `DIAGNOSTIC_PACKET` defined in `docs/GITHUB_HANDOFF_PROTOCOL.md`. Conclusion-only handoffs are not sufficient.

## Goal

Bypass the Windows PowerShell HTTP stack entirely and test the Sandbox credentials through the same Docker/WordPress runtime used by PPCP.

## Method

Create a LOCAL-ONLY helper under the active project `.artifacts` directory and copy only the helper code into the WordPress container.

Preferred authenticated check:

- run inside `mini-craft-k3r4-recovery-wordpress`;
- use PHP/WordPress HTTP stack (`wp_remote_post`) or PHP cURL against `https://api-m.sandbox.paypal.com/v1/oauth2/token`;
- POST `grant_type=client_credentials`;
- construct HTTP Basic auth in memory only;
- read Client ID + Secret from STDIN supplied interactively by Owner;
- do not place credentials in command-line arguments, files, environment variables, logs, GitHub, or shell history.

Owner-facing wrapper may use PowerShell only for secure interactive input and piping to container STDIN. It must NOT perform the HTTPS request itself.

## Required redacted output

Only:

```text
CONTAINER_OAUTH_STAGE=<stage>
PAYPAL_SANDBOX_OAUTH=PASS|FAIL
HTTP_STATUS=<status_or_NONE>
TOKEN_RECEIVED=YES|NO
ERROR_CLASS=<sanitized_category_or_NONE>
```

No response body, token, Client ID, Secret, Authorization header, app_id, merchant data, or raw headers.

## Interpretation

- HTTP 200 + token received => credentials + PayPal Sandbox + container HTTP stack are valid. Continue K3R8 Phase C and inspect only redacted PPCP manual-connect failure evidence.
- HTTP 401 / invalid_client-equivalent classification => credential pair invalid/mismatched.
- no HTTP result => return the exact sanitized container-side error class/stage with DIAGNOSTIC_PACKET.

## Phase C if direct OAuth passes

Without asking Owner to re-enter credentials again, inspect only the existing failed PPCP manual-connect attempt's redacted REST/log evidence. If necessary, Owner may retry manual connect once using the same credentials locally, but no repeated blind retries.

If direct OAuth passes while PPCP manual connect still rejects the same credential pair, return:

`RETURN_K3R8C_PPCP_MANUAL_CONNECT_DEFECT_CONFIRMED`

## Safety

- no plugin/WooCommerce/WordPress version changes;
- no PPCP source patch;
- no Live;
- no real payment;
- no public tunnel/VPS;
- no credential persistence.

Stop at Owner checkpoint only if interactive credential entry is required; otherwise stop at Reviewer with a complete DIAGNOSTIC_PACKET.