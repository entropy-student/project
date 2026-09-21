# Reviewer Decision — K3R11 UI / REST Connection-State Mismatch

Date: 2026-09-21
Status: OWNER RECONNECT PAUSED; READ-ONLY RECONCILIATION REQUIRED

## Owner observation

At the authorized Owner reconnect checkpoint, the local WooCommerce PayPal Payments Settings UI does not present a Manual Connect control.

Instead, the UI visibly shows:

- Connection status;
- a Disconnect control;
- Business / Sandbox;
- Merchant ID, email address, and Client ID fields.

This means the admin UI currently presents the account as connected.

No credential value is recorded in this repository.

## Conflict with Executor evidence

The immediately preceding Executor read-only probe recorded:

`PPCP_MERCHANT_CONNECTED=NO`

Therefore project truth currently contains a connection-state mismatch:

```text
PPCP_ADMIN_UI_CONNECTION_STATE=CONNECTED_PRESENTATION
PPCP_REST_MERCHANT_CONNECTED=NO
```

## Reviewer decision

Do NOT ask Owner to click Disconnect merely to expose Manual Connect.

Disconnect is a state-changing action and is not justified until the mismatch is understood.

Pause the Owner reconnect checkpoint.

## Authorized next step

Executor may perform read-only reconciliation only:

1. inspect the redacted PPCP REST/common/onboarding/settings state again;
2. inspect the local WordPress/PPCP option keys only as presence/status metadata, without outputting credential values;
3. determine what condition drives the Settings UI to show Connection status / Disconnect;
4. determine what condition drives `merchant.isConnected=NO`;
5. verify whether the rotated provider Secret simply makes the stored credential pair invalid while stale/local account metadata remains present;
6. do not call PayPal with credentials unless separately authorized;
7. do not disconnect/reconnect;
8. do not create the public origin yet.

Return a diagnostic packet that explains the mismatch and the smallest safe next action.

## Not authorized

- no Disconnect;
- no reconnect;
- no credential entry/readout;
- no public tunnel/origin;
- no version/source change;
- no Live/payment/capture;
- no VPS/production-domain action.

## Current checkpoint

`K3R11_CONNECTION_STATE_RECONCILIATION`
