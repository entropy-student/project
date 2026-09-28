# Reviewer Decision — K7 R2R1 Webhook Simulation Result Void / Read-only Reconciliation

Date: 2026-09-28  
Role: Reviewer / Architect / Gatekeeper

## Context

Owner completed the official PayPal Live onboarding in WooCommerce PayPal Payments and provided UI evidence showing:

```text
PAYPAL_CONNECTION=CONNECTED
PAYPAL_ACCOUNT_TYPE=BUSINESS
PAYPAL_ENVIRONMENT=LIVE
WEBHOOK_NOTIFICATION_URL=https://minicraft.spikersun.com/wp-json/paypal/v1/incoming
WEBHOOK_SUBSCRIPTIONS_PRESENT=YES
```

No order, buyer payment, capture, refund, Product mutation, webhook resubscribe, or Soft Launch action was performed.

The Owner then used the already-authorized single `Simulate webhooks` action. The UI entered `Waiting for the webhook to arrive...` and later returned to the ordinary settings view without a durable success/failure result.

## Upstream dependency finding

Current upstream WooCommerce PayPal Payments evidence makes the simulation result non-authoritative:

- upstream issue `woocommerce/woocommerce-paypal-payments#4627` is open;
- the current stable source advertises `Stable tag: 4.1.3`;
- current code search still shows `WebhookSimulation::start()` returning immediately under the comment `Disabled for 3.3.1 release.`;
- therefore the merchant-facing simulation control cannot be used as fresh proof of webhook delivery on the affected versions.

This supersedes the earlier assumption that the simulation button itself could seal webhook health.

## Reviewer decision

```text
K7_R2R1_LIVE_ONBOARDING_UI=PASS_OWNER_EVIDENCE
K7_R2R1_NOTIFICATION_URL=PASS_EXACT_CURRENT_ORIGIN
K7_R2R1_WEBHOOK_SUBSCRIPTIONS_PRESENT=YES
K7_R2R1_WEBHOOK_RESUBSCRIBE_USED=NO
K7_R2R1_WEBHOOK_SIMULATION_USED=1
K7_R2R1_WEBHOOK_SIMULATION_RESULT=VOID_UPSTREAM_PLUGIN_BUG
BLIND_SIMULATION_RETRY=FORBIDDEN
CURRENT_GATE=K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY
CURRENT_GATE_STATUS=READONLY_RECONCILIATION_REQUIRED
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
SOFT_LAUNCH_AUTHORIZED=NO
```

The simulation is neither PASS nor RETURN evidence. Do not click it again.

## Read-only reconciliation authorized

Executor may perform only the following bounded read-only checks:

1. verify the currently installed WooCommerce PayPal Payments plugin version;
2. verify Live/connected account state without reading or persisting Secret values;
3. verify the current Notification URL is exactly:
   `https://minicraft.spikersun.com/wp-json/paypal/v1/incoming`;
4. read the plugin/system-status webhook status and current subscribed-event metadata;
5. inspect existing extension logs if present, without enabling new logging;
6. perform at most one unsigned public POST reachability negative-test to the notification endpoint, with no PayPal signature or production payload, solely to prove the route is externally reachable and rejects unauthenticated input rather than returning a route/host failure;
7. inspect the installed plugin source only as needed to classify the upstream simulation behavior.

Forbidden:

- another simulation;
- Resubscribe;
- real or replayed webhook payloads;
- order creation;
- payment/capture/refund;
- Product mutation;
- Secret/token/hash output;
- enabling logging or changing PayPal settings;
- Shared Infra mutation;
- Soft Launch.

## Acceptance

If fresh read-only evidence proves Live connection, exact Notification URL, subscriptions present, and externally reachable fail-closed webhook route, Reviewer may close K7 R2R1 with the simulation limitation explicitly recorded and defer real signed-callback proof to the separately authorized Production Canary.

If endpoint reachability, Live state, or webhook registration is not proven, RETURN with the precise cause. No blind replay or provider mutation is allowed.
