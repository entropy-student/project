# Reviewer Decision — K3R8B Local OAuth Helper Diagnostic

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Trigger

Owner ran the local secure OAuth helper and received:

`PAYPAL_SANDBOX_OAUTH=FAIL ERROR=LOCAL_REQUEST_FAILURE`

This is NOT a PayPal credential verdict because the helper did not return an HTTP authentication result.

## Goal

Determine whether the local PowerShell helper failed because of:

- host DNS/network/proxy;
- TLS/certificate/Schannel;
- PowerShell/Invoke-WebRequest/Invoke-RestMethod behavior;
- helper-script encoding/argument/body construction.

## Scope

1. Inspect the existing helper script only; do not read or recover any secret value.
2. Run host-side no-secret checks to `api-m.sandbox.paypal.com`: DNS resolution, TCP 443, TLS/HTTPS request.
3. Modify the helper only if needed so that it reports a redacted error class/category and HTTP status when available.
4. It may report sanitized values such as:
   - DNS_FAILURE
   - TCP_FAILURE
   - TLS_FAILURE
   - PROXY_FAILURE
   - HTTP_401
   - HTTP_403
   - HTTP_200_TOKEN_RECEIVED
   - POWERSHELL_REQUEST_EXCEPTION
5. It must never print Client ID, Secret, Authorization header, access token, response body, app_id, merchant data, or raw request headers.
6. Owner reruns the corrected helper interactively.

## Result handling

- If corrected helper returns HTTP 200/token received: continue K3R8 Phase C.
- If it returns HTTP 401 or invalid_client: credentials are invalid/mismatched.
- If it returns a host network/TLS/proxy failure: return that root cause to Reviewer.

## Safety

No PPCP version change, no source patch, no Live mode, no real payment, no public tunnel/VPS, no credential persistence.

Stop at Owner checkpoint after preparing the corrected helper.