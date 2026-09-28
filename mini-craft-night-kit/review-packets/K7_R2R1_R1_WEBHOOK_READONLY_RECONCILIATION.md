# K7 R2R1 R1 — PayPal Live / Webhook Read-only Reconciliation

Status: AUTHORIZED_READONLY_EXECUTION

Governance:
- canonical `entropy-student/spike.skill/vps-project-governance` latest
- Production Provider Canary and Recovery Contract rev2
- current Mini Craft `REVIEWER_HANDOFF.md`
- `docs/REVIEWER_DECISION_K7_R2R1_WEBHOOK_SIMULATION_VOID_READONLY_RECONCILIATION.md`

## Goal

Close the current PayPal Live/Webhook readiness uncertainty without any new Provider mutation or real transaction.

The Owner has already completed official PayPal Live onboarding. Current Owner UI evidence shows:

```text
PAYPAL_CONNECTION=CONNECTED
PAYPAL_ACCOUNT_TYPE=BUSINESS
PAYPAL_ENVIRONMENT=LIVE
WEBHOOK_NOTIFICATION_URL=https://minicraft.spikersun.com/wp-json/paypal/v1/incoming
WEBHOOK_SUBSCRIPTIONS_PRESENT=YES
WEBHOOK_RESUBSCRIBE_USED=NO
WEBHOOK_SIMULATION_USED=1
WEBHOOK_SIMULATION_RESULT=VOID_UPSTREAM_PLUGIN_BUG
```

Upstream `woocommerce/woocommerce-paypal-payments#4627` is an open bug affecting the merchant-facing simulation control. Do not use the simulation result as success/failure evidence and do not rerun it.

## Preflight

Read:
- `REVIEWER_HANDOFF.md`
- `PROJECT_RECORD.md`
- `PROJECT_STORAGE_MANIFEST.md`
- latest accepted `EXECUTION_EVIDENCE.md`
- latest `EXECUTOR_HANDOFF.md`
- the Reviewer decision above
- canonical Governance latest

Confirm before any probe:

```text
CURRENT_GATE=K7_R2R1_R1_WEBHOOK_READONLY_RECONCILIATION
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
RESUBSCRIBE_ACTIONS=0
NEW_SIMULATION_ACTIONS=0
PAYPAL_SETTINGS_WRITES=0
```

If current state materially differs, return `RETURN_PREFLIGHT_DRIFT`.

## Allowed — read-only only

1. Determine the currently installed WooCommerce PayPal Payments plugin version from authoritative runtime/plugin metadata.
2. Read current PPCP connection state and prove Live/connected status without reading or emitting Secret values.
3. Read current Notification URL and prove exact equality with:
   `https://minicraft.spikersun.com/wp-json/paypal/v1/incoming`
4. Read current subscribed webhook-event metadata/count/list as available.
5. Read WooCommerce/System Status webhook status if exposed.
6. Inspect existing PPCP/WooCommerce logs if they already exist.
   - do not enable Logging;
   - do not create new diagnostic logging settings;
   - redact private business identifiers;
   - record only metadata/relevant non-secret lines.
7. Perform at most ONE public unsigned POST reachability negative-test against:
   `https://minicraft.spikersun.com/wp-json/paypal/v1/incoming`
   Requirements:
   - no PayPal signature headers;
   - no real/replayed PayPal webhook payload;
   - synthetic minimal body only;
   - purpose is only to prove DNS/TLS/route reachability and fail-closed rejection;
   - record HTTP status/body classification only, no cookies/tokens.
8. Inspect installed plugin source only as needed to classify the known simulation behavior/version boundary.
9. Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`.
10. Persist results to GitHub and read them back.

## Forbidden

- clicking or invoking Simulate webhooks again;
- Resubscribe webhooks;
- changing PayPal/WooCommerce settings;
- enabling Logging;
- any order creation;
- buyer action;
- authorization/capture;
- refund;
- real webhook replay;
- product/currency mutation;
- Secret/token/private-key/hash output;
- Cloudflare/Caddy/Shared Infra mutation;
- Docker/Compose/service restart unless Reviewer issues a separate Gate;
- Soft Launch.

## Evidence required

At minimum:

```text
PPCP_PLUGIN_VERSION=
PAYPAL_LIVE_CONNECTED=
PAYPAL_ACCOUNT_TYPE=
WEBHOOK_NOTIFICATION_URL=
WEBHOOK_URL_EXACT_MATCH=
WEBHOOK_SUBSCRIPTIONS_PRESENT=
WEBHOOK_STATUS_READBACK=
EXISTING_LOGS_INSPECTED=
LOGGING_ENABLED_BY_THIS_GATE=NO
UNSIGNED_ENDPOINT_PROBE_COUNT=
UNSIGNED_ENDPOINT_REACHABLE=
UNSIGNED_ENDPOINT_FAIL_CLOSED=
RESUBSCRIBE_ACTIONS=0
NEW_SIMULATION_ACTIONS=0
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
PAYPAL_SETTINGS_WRITES=0
SECRET_VALUES_EMITTED=0
```

For the unsigned negative test, a reachable rejection such as an authentication/signature/forbidden-class response is acceptable evidence; a host/DNS/TLS/route failure is not.

## PASS candidate

Return only if all material read-only invariants pass:

```text
PASS_CANDIDATE_K7_R2R1_R1_WEBHOOK_READONLY_RECONCILIATION
STOP_AT_REVIEWER=YES
```

## RETURN examples

```text
RETURN_PREFLIGHT_DRIFT
RETURN_PAYPAL_LIVE_CONNECTION_NOT_PROVEN
RETURN_WEBHOOK_URL_MISMATCH
RETURN_WEBHOOK_REGISTRATION_UNPROVEN
RETURN_WEBHOOK_ENDPOINT_UNREACHABLE
RETURN_READONLY_EXECUTION_FAILURE
```

Do not repair a failure in this Gate. Return to Reviewer with evidence.
