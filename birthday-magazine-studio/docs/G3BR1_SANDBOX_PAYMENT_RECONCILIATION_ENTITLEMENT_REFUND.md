# G3BR1 — Sandbox Payment Reconciliation + Entitlement + Refund Closure

> Reviewer execution contract  
> Status: CURRENT / AUTHORIZED THROUGH PHASE D / OWNER REFUND CHECKPOINT REQUIRED  
> Parent Gate: G3B  
> Accepted input: PR #51 interim RETURN evidence  
> Rule: **NO SECOND SANDBOX PAYMENT**

## Goal

Close the remaining G3B proof around the **already observed** Sandbox payment without replaying payment.

Required sequence:

```text
existing Woo paid order #30
→ read-only provider / Woo correlation
→ prove exactly one completed Sandbox capture for USD 39.99
→ paid + intake incomplete => 0 generation-ready jobs
→ mark synthetic intake complete
→ exactly 1 canonical deferred generation-ready job
→ repeated entitlement evaluation => still exactly 1
→ STOP_AT_OWNER_REFUND_CHECKPOINT
→ after fresh Owner authorization: one WooCommerce-initiated Sandbox refund
→ provider refund correlation
→ revoke entitlement + cancel deferred generation action
→ model calls remain 0
```

## Phase A — fresh runtime and safety preflight

1. Start from latest `main`; dedicated branch.
2. Read current Handoff, this contract, G3B contract and PR #51 evidence.
3. Freshly verify whether the G3B Docker runtime and temporary HTTPS origin are still alive.
4. If either is gone/stale, reconstruct only from committed G3B project-local artifacts; do not create a new payment.
5. Confirm:
   - PPCP official plugin;
   - Sandbox=YES;
   - Live=NO;
   - Woo order #30 still exists;
   - no refund already exists;
   - generation/model counts remain 0 before mutation.
6. Never print/read/commit Client Secret, access token, cookies, buyer credentials or raw sensitive provider payload.

## Phase B — read-only payment reconciliation

Before any entitlement mutation or refund, establish the strongest available read-only correlation using WooCommerce/PPCP/provider-supported read paths.

Required facts:

- exactly one intended Woo order candidate;
- order #30 is paid;
- amount = USD 39.99;
- environment = Sandbox;
- payment method = PPCP;
- exactly one completed provider capture/payment for this order;
- provider amount/currency match;
- no second/duplicate capture;
- callback/webhook handling is consistent with the same transaction.

Identifiers may be compared inside the protected runtime, but ordinary Evidence must store only redacted/hashed/non-secret correlation metadata.

The provider query path must be read-only. Do not use a helper that can create/capture/cancel/refund.

If exact correlation is unavailable or ambiguous:

`RETURN_G3BR1_PROVIDER_CORRELATION_UNRESOLVED`

Do not run another payment.

## Phase C — paid entitlement, intake incomplete

With provider/Woo correlation proven:

- set/read synthetic intake state = incomplete;
- evaluate entitlement;
- generation-ready canonical job count must remain 0;
- scheduled generation action count must remain 0;
- model call count = 0.

## Phase D — intake complete + idempotency

Mark only the synthetic order's intake complete.

Then evaluate the project-local entitlement adapter:

```text
Woo order paid
AND exact Sandbox payment correlated
AND intake complete
AND not refunded
→ exactly one canonical generation-ready job
```

Requirements:

- canonical job count = 1;
- deferred Action Scheduler dispatch count <= 1;
- dispatch must not call a real model/provider;
- refresh/revisit/re-evaluation/event replay must keep canonical job count at 1;
- no remote model spend.

This proves local entitlement idempotency only, not production model-spend idempotency.

## Owner checkpoint before Phase E

After Phase B-D PASS, **stop before any refund action** and return:

`RETURN_OWNER_SANDBOX_REFUND_AUTH_REQUIRED`

At this checkpoint provide only non-secret read-back:

- provider/Woo payment correlation = PASS;
- provider capture cardinality = 1;
- paid + intake incomplete job count = 0;
- paid + intake complete canonical job count = 1;
- entitlement re-evaluation idempotency = PASS;
- model calls = 0;
- refund already exists = NO.

Do not click or invoke refund until the Owner gives a fresh explicit authorization for this exact Sandbox refund.

This checkpoint is required by the Production Provider Canary/Recovery governance boundary: refund is a consequential Provider action and is not implicitly authorized by earlier Seller/Buyer approval.

## Phase E — one Sandbox refund

Only after Phase B-D PASS **and fresh Owner authorization**:

1. initiate exactly one refund from WooCommerce through official PPCP;
2. amount must not exceed captured amount;
3. verify provider Sandbox refund completed;
4. verify WooCommerce refund record/correlation;
5. verify no duplicate refund;
6. entitlement becomes revoked;
7. canonical job audit record remains but transitions to cancelled/revoked;
8. deferred generation action count returns to 0;
9. model calls remain 0.

Do not execute a second refund to repair ambiguous state; reconcile first.

## Cleanup

After evidence:

- restore local WordPress URLs if temporarily rebound;
- stop the temporary tunnel;
- verify localhost runtime health;
- scoped G3B Docker teardown only when no further Reviewer/Owner checkpoint requires the runtime;
- no global prune;
- preserve unrelated/Mini Craft resources.

## PASS_CANDIDATE requirements

- EXISTING_PAYMENT_ONLY=YES
- SECOND_SANDBOX_PAYMENT=NO
- SANDBOX=YES
- LIVE=NO
- WOO_ORDER_30_PAID=PASS
- PROVIDER_QUERY_SEMANTICS=READ_ONLY_VERIFIED
- PROVIDER_CAPTURE_CARDINALITY=1
- PROVIDER_CAPTURE_COMPLETED=PASS
- ORDER_AMOUNT_CURRENCY_CORRELATION=PASS
- DUPLICATE_CAPTURE=NO
- CALLBACK_WEBHOOK_CORRELATION=PASS
- PAID_INTAKE_INCOMPLETE_JOB_COUNT=0
- PAID_INTAKE_COMPLETE_CANONICAL_JOB_COUNT=1
- DEFERRED_GENERATION_ACTION_COUNT_MAX=1
- ENTITLEMENT_REEVALUATION_IDEMPOTENCY=PASS
- MODEL_CALL_COUNT=0
- OWNER_SANDBOX_REFUND_AUTH=PASS
- SANDBOX_REFUND=PASS
- REFUND_CORRELATION=PASS
- DUPLICATE_REFUND=NO
- REFUND_REVOKES_ENTITLEMENT=PASS
- DEFERRED_GENERATION_ACTION_AFTER_REFUND=0
- REAL_PAYMENT=NO
- REAL_CUSTOMER_DATA=NO
- SECRET_EXPOSURE=NO
- G4_STARTED=NO
- STOP_AT_REVIEWER=YES

## Valid RETURN conditions

Return without replay if:

- Phase B-D reaches refund boundary without fresh Owner authorization: `RETURN_OWNER_SANDBOX_REFUND_AUTH_REQUIRED`;
- provider query/correlation is ambiguous;
- more than one capture/payment is found;
- payment amount/currency/order mismatch exists;
- Woo order has already changed to an unexpected terminal state;
- a refund already exists unexpectedly;
- entitlement idempotency fails;
- refund result is ambiguous;
- current runtime requires Live credentials, real money, production domain, VPS or Secret exposure.

## Handoff

Before the refund checkpoint, update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`, commit/push, open/update PR to `main`, and stop at Owner. After fresh Owner authorization, resume the same branch/PR for Phase E, cleanup and final `STOP_AT_REVIEWER`.
