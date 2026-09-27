# G3B — PayPal Sandbox + Paid Entitlement + Refund

> Reviewer execution contract  
> Status: CURRENT / AUTHORIZED TO EXECUTE UNTIL OWNER PAYPAL CHECKPOINT  
> Prerequisite: G3A PASS  
> Scope: Sandbox payment and local paid-entitlement semantics only

## Goal

Prove the Birthday Magazine payment boundary using the official WooCommerce PayPal Payments integration in **PayPal Sandbox only**, then prove the product-specific entitlement rule:

```text
confirmed WooCommerce/PayPal paid state
AND
required intake complete
→ exactly one canonical generation-ready job
```

No real model/provider call occurs in G3B.

The target end-to-end Sandbox flow is:

```text
G3A Docker/MariaDB baseline
→ official WooCommerce PayPal Payments
→ temporary HTTPS public Sandbox origin
→ Sandbox merchant connection
→ PayPal Checkout button
→ one Sandbox buyer approval/capture
→ WooCommerce paid state + provider correlation + callback/webhook
→ intake still incomplete => zero generation job
→ mark synthetic intake complete
→ exactly one canonical deferred generation job
→ duplicate callbacks/re-evaluation/refresh => still exactly one job
→ one WooCommerce-initiated Sandbox refund
→ provider refund confirmed
→ generation entitlement revoked / deferred job cancelled
```

## Mini Craft lessons that are binding for this Gate

Carry forward accepted Mini Craft findings:

- use Docker/MariaDB, not WordPress Studio/SQLite;
- use only the official WooCommerce PayPal Payments plugin;
- do not hand-code PayPal API;
- do not introduce a second canonical order system;
- do not interpret every PayPal connection failure as invalid credentials;
- isolate runtime / plugin / network / credential / public-origin causes;
- test the direct PayPal settings page separately if a Payments-overview UI defect appears;
- treat a valid HTTPS public origin as a first-class Sandbox requirement for client-token/webhook behavior;
- never expose Sandbox secrets in logs/chat/GitHub;
- one successful payment must not produce duplicate capture;
- provider callback/webhook and WooCommerce order state must correlate before PASS.

Do not pin to Mini Craft's historical PPCP version merely for parity. Use the current official stable WooCommerce PayPal Payments package available to the Executor, record exact version/source/hash, and do not switch versions mid-Gate without Reviewer approval.

## Phase 0 — Recreate and reconfirm G3A baseline

1. Start latest `main`; create a dedicated branch.
2. Recreate a fresh isolated Docker Compose WordPress + MariaDB + Mailpit runtime from the accepted G3A package.
3. Re-run only the minimum G3A smoke:
   - WordPress/MariaDB health;
   - USD 39.99 virtual product;
   - native cart/checkout;
   - account-required mode;
   - Buyer workspace access control;
   - unpaid generation gate closed.
4. Do not reuse Mini Craft containers, DB, PPCP settings, Sandbox credentials or transaction state.

If the G3A baseline no longer holds, RETURN before PayPal work.

## Phase 1 — Official PPCP installation and local health

1. Install/activate only **WooCommerce PayPal Payments**, official WooCommerce package.
2. Record exact:
   - plugin name;
   - version;
   - source;
   - package SHA-256 where practical;
   - activation state.
3. Additional payment plugins = NO.
4. Verify after activation:
   - WordPress health;
   - WooCommerce admin;
   - direct PayPal settings section;
   - product/cart/checkout baseline.
5. If the Payments overview has a JS/mount defect but direct PayPal settings is healthy, record the overview defect separately and continue only if the direct section and checkout path remain usable.
6. Do not patch PPCP source or change WooCommerce/WordPress versions merely to bypass an admin defect.

## Phase 2 — Temporary HTTPS public Sandbox origin

Before end-to-end Sandbox checkout/callback acceptance, create one temporary HTTPS public origin to the local Docker WordPress runtime.

Preferred reference: the bounded temporary Cloudflare Quick Tunnel approach used successfully by Mini Craft, or an equivalent Reviewer-bounded temporary HTTPS origin.

Requirements:

- local Docker runtime remains canonical;
- no VPS deployment;
- no production-domain cutover;
- no permanent DNS record;
- no Live PayPal;
- record original local `home` / `siteurl`;
- temporarily rebind WordPress URLs only as required for Sandbox;
- verify public Home/product/checkout health;
- verify direct PayPal settings health through the public origin;
- preserve an exact rollback path;
- stop if establishing the origin requires an unapproved external account/Secret or broader infrastructure mutation.

Do not continue payment testing against a stale/dead temporary origin.

## Phase 3 — Owner Sandbox merchant connection checkpoint

The Executor may proceed automatically until PayPal requires Owner authentication, OAuth consent or Sandbox credential entry.

At that boundary, STOP with:

`RETURN_OWNER_PAYPAL_SANDBOX_MERCHANT_AUTH_REQUIRED`

Owner-only actions include:

- PayPal login;
- selecting/authorizing the Sandbox seller/business account;
- provider OAuth consent;
- manual Sandbox Client ID/Secret entry if the official plugin requires it;
- any KYC/identity prompt.

Rules:

- never request PayPal password, Client Secret, token, cookie, OAuth code or authorization header in chat/GitHub;
- do not copy credentials/state from Mini Craft;
- do not enable Live;
- do not perform a real payment.

After Owner completes the UI action, resume the same G3B Gate.

## Phase 4 — Sandbox checkout readiness

After merchant connection:

- PAYPAL_MODE=SANDBOX;
- PAYPAL_LIVE_ENABLED=NO;
- merchant connected/read-back healthy;
- onboarding state healthy where exposed;
- PayPal appears at Checkout;
- required client-token/SDK path succeeds;
- PayPal button renders;
- provider webhook/callback registration uses the active temporary HTTPS origin and is healthy.

If client-token or webhook behavior still references localhost, RETURN for public-origin reconciliation instead of improvising.

## Phase 5 — Exactly one Sandbox capture

Use synthetic buyer/order data only.

1. Create one fresh Birthday Magazine Sandbox checkout at USD 39.99 unless PayPal Sandbox/plugin limitations require a clearly documented lower test amount. Any lower amount is test-only and does not change the frozen US$39.99 product contract.
2. Stop at Sandbox buyer authentication/approval with:

`RETURN_OWNER_PAYPAL_SANDBOX_BUYER_APPROVAL_REQUIRED`

3. Owner performs Sandbox buyer login/approval only.
4. Resume and complete exactly one capture.
5. Verify:
   - exactly one WooCommerce order for the flow;
   - provider Sandbox payment/capture = completed;
   - WooCommerce transaction/provider correlation using redacted identifiers;
   - WooCommerce order = server-side paid;
   - no duplicate payment/capture;
   - actual provider callback/webhook delivery/processing is evidenced.

Do not equate `paid` with `magazine generated`.

## Phase 6 — Birthday Magazine paid-entitlement proof without model call

Implement the minimum local entitlement adapter needed for G3B.

Canonical condition:

```text
order.is_paid() == true
AND intake_complete == true
AND order_not_refunded == true
→ one generation-ready job
```

Required states:

### A. Paid, intake incomplete

Immediately after successful Sandbox capture:

- `PAID_ENTITLEMENT=YES`;
- `INTAKE_COMPLETE=NO`;
- generation-ready canonical job count = 0;
- model call count = 0.

### B. Paid, intake complete

Mark the synthetic order's intake complete through a project-local test helper/admin control.

Then:

- create exactly one canonical order-bound generation-ready record;
- schedule at most one deferred Action Scheduler action for that order;
- the action must **not call a real model/provider**;
- use a future/deferred/no-provider-dispatch state so the test cannot spend model tokens.

### C. Duplicate/idempotency smoke

Re-evaluate entitlement multiple times using combinations of:

- order page refresh;
- workspace refresh;
- explicit entitlement re-evaluation;
- duplicate local callback/event replay where safely reproducible without a second PayPal payment.

Expected:

- canonical generation-ready job count remains exactly 1;
- scheduled generation-dispatch count remains at most 1;
- provider/model calls remain 0.

This proves local paid-entitlement idempotency only. It does not prove remote provider-spend idempotency.

## Phase 7 — One Sandbox refund

Initiate one bounded refund **from WooCommerce through the official PayPal integration**.

Verify:

- one WooCommerce refund record;
- provider Sandbox refund succeeds;
- refund amount <= captured amount;
- provider/WooCommerce refund correlation with redacted identifiers;
- duplicate refund is not created;
- order/entitlement state recognizes the refund.

Because the generation provider has not started in G3B:

- revoke generation entitlement;
- cancel/remove the deferred generation action;
- canonical job transitions to cancelled/revoked (do not delete the audit record);
- model/provider calls remain 0.

Do not test customer-facing final PDF deletion in this Gate.

## Security requirements

Never persist or commit:

- PayPal passwords;
- Client Secret;
- access/refresh token;
- OAuth code;
- cookies/session values;
- Authorization headers;
- webhook signing secrets;
- raw provider payloads containing sensitive values.

Evidence may include only redacted transaction/order/capture/refund identifiers sufficient for correlation.

If any Sandbox Secret is accidentally exposed, stop immediately, record a sanitized incident, require Owner rotation, and do not reuse that Secret.

## Cleanup

After evidence is complete:

1. restore local WordPress `home` / `siteurl` if temporarily rebound;
2. verify local runtime health;
3. stop/remove the temporary HTTPS tunnel/origin;
4. confirm no temporary public origin remains relied upon;
5. scoped Docker Compose teardown for Birthday Magazine only;
6. no global prune;
7. verify unrelated Docker/Mini Craft identities unchanged.

The working Sandbox seller connection may be preserved only in the local disposable DB backup/evidence policy if it contains no exported Secret; do not publish credentials.

## PASS_CANDIDATE requirements

- G3A_BASELINE_RECONFIRMED=PASS
- OFFICIAL_WOOCOMMERCE_PAYPAL_PAYMENTS=PASS
- PPCP_EXACT_VERSION_RECORDED=PASS
- PAYPAL_MODE=SANDBOX
- PAYPAL_LIVE_ENABLED=NO
- TEMP_PUBLIC_HTTPS_ORIGIN=PASS
- SANDBOX_MERCHANT_CONNECTED=PASS
- PAYPAL_CHECKOUT_VISIBLE=PASS
- PPCP_CLIENT_TOKEN_OR_EQUIVALENT=PASS
- WEBHOOK_OR_CALLBACK_READY=PASS
- SANDBOX_BUYER_APPROVAL=PASS
- SANDBOX_CAPTURE=PASS
- WOO_ORDER_PAID_STATE=PASS
- ORDER_PROVIDER_CORRELATION=PASS
- DUPLICATE_PAYMENT_CAPTURE=NO
- PAID_INTAKE_INCOMPLETE_JOB_COUNT=0
- PAID_INTAKE_COMPLETE_CANONICAL_JOB_COUNT=1
- GENERATION_SCHEDULED_ACTION_COUNT_MAX=1
- ENTITLEMENT_REEVALUATION_IDEMPOTENCY=PASS
- MODEL_CALL_COUNT=0
- SANDBOX_REFUND=PASS
- REFUND_CORRELATION=PASS
- DUPLICATE_REFUND=NO
- REFUND_REVOKES_GENERATION_ENTITLEMENT=PASS
- DEFERRED_GENERATION_ACTION_AFTER_REFUND=0
- REAL_PAYMENT=NO
- REAL_CUSTOMER_DATA=NO
- VPS_WRITE=NO
- PRODUCTION_DOMAIN_CUTOVER=NO
- SECRET_EXPOSURE=NO
- CLEANUP_READBACK=PASS
- G4_STARTED=NO
- STOP_AT_REVIEWER=YES

## Valid RETURN outcomes

Return rather than improvising for:

- Owner Sandbox merchant authentication/consent required;
- Owner Sandbox buyer approval required;
- official plugin incompatible with the local runtime;
- Sandbox merchant account unavailable/ineligible;
- temporary HTTPS public origin cannot be established within scope;
- client-token/button/webhook still bound to localhost;
- plugin/runtime/credential failure cannot be isolated safely;
- payment would require Live/real money;
- a Secret would need to be exposed;
- paid-entitlement idempotency fails;
- refund path cannot be verified through the official integration.

## Explicit non-goals

- PayPal Live;
- real-money canary;
- production AI/provider call;
- production provider-spend idempotency;
- final photo storage;
- final PDF delivery;
- VPS/production deployment.

Those remain later Gates.

## Handoff

Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`; retain sanitized screenshots/reports and public-origin rollback evidence; commit, push, PR to `main`; do not merge; `STOP_AT_REVIEWER`.
