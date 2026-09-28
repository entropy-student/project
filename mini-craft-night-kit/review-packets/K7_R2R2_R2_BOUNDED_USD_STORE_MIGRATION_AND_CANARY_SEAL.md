# K7 R2R2 R2 — Bounded USD Store Migration and Canary Seal

Status: AUTHORIZED_REVERSIBLE_NONPAYMENT_MIGRATION

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K7_R2R2_R1_RETURN_USD_STORE_MIGRATION_PATH.md
- docs/REVIEWER_DECISION_K7_R2R2_USD1_CANARY_AMOUNT_SEALED.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical VPS Project Governance latest

## Current truth

```text
WOOCOMMERCE_STORE_CURRENCY=JPY
PRODUCT_223_PRICE=1_JPY_TEST_ONLY
PRODUCT_223_STATUS_VISIBILITY=publish/VISIBLE
PRODUCT_1224_PRICE=500_JPY
PRODUCT_1224_STATUS_VISIBILITY=publish/HIDDEN
PRODUCTION_TRANSACTION_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=1.00
REAL_PAYMENT_AUTHORIZED=NO
```

K2 formally records JPY 1 and JPY site currency as test-only values, not production business truth.

## Goal

Migrate the production store itself to USD without turning Product 223's historical JPY 1 test price into a customer-buyable USD 1 offer.

Target safe state:

```text
STORE_CURRENCY=USD
PRODUCT_223_PRICE=EMPTY
PRODUCT_223_PURCHASABLE=NO
PRODUCT_223_STATUS_VISIBILITY=UNCHANGED
PRODUCT_1224_PRICE_USD=1.00
PRODUCT_1224_STATUS_VISIBILITY=publish/HIDDEN
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
```

## Phase A — pre-mutation read-only guard

Use the existing verified SSH/runtime path.

Read exactly:

1. all published WooCommerce product IDs;
2. for each published product:
   - status;
   - catalog visibility;
   - current/regular/sale numeric price presence only as needed to classify impact;
3. exact current rollback values for:
   - `woocommerce_currency`;
   - Product 223 regular/current/sale price;
   - Product 1224 regular/current/sale price;
4. Product 223 current purchasability;
5. Product 1224 current fixture semantics.

Do not dump broad wp_options, env, secrets, PPCP logs, cookies, sessions, nonces or tokens.

PASS precondition:

- Product 223 is the only ordinary catalog-visible published product with a non-empty numeric price;
- Product 1224 is the hidden Canary;
- no other public/catalog-visible priced product would be reinterpreted.

If not true:

```text
RETURN_USD_MIGRATION_PUBLIC_PRODUCT_IMPACT_UNRESOLVED
STOP_AT_REVIEWER=YES
```

No writes.

## Phase B — rollback preparation

Before any business-state write:

1. create exactly one project-local DB backup under the accepted Mini Craft backup namespace;
2. record backup path/identity without Secret material;
3. capture exact rollback tuple:

```text
PRE_CURRENCY=
PRE_223_REGULAR_PRICE=
PRE_223_CURRENT_PRICE=
PRE_223_SALE_PRICE=
PRE_1224_REGULAR_PRICE=
PRE_1224_CURRENT_PRICE=
PRE_1224_SALE_PRICE=
```

No Shared Infra write.

## Phase C — exact write sequence

Use supported WordPress/WooCommerce APIs where practical so product caches remain coherent.

### C1 — neutralize Product 223 test offer

Modify only Product 223 price fields:

- remove/unset current/regular/sale test price as applicable;
- EMPTY/unset means no production price is currently sealed;
- do NOT set numeric 0;
- do not modify title/content/media/SKU/stock/status/visibility/tax/shipping.

Fresh read-back must prove:

```text
PRODUCT_223_TEST_PRICE_REMOVED=YES
PRODUCT_223_CURRENT_PRICE=EMPTY
PRODUCT_223_PURCHASABLE=NO
```

If it remains purchasable, rollback and RETURN.

### C2 — global production currency migration

Change exactly:

```text
woocommerce_currency: JPY -> USD
```

No other WooCommerce commercial setting.

### C3 — hidden Canary rebase

Modify only Product 1224 price:

```text
regular/current price = 1.00
sale price = empty unless it was already structurally required
```

Preserve:
- publish/HIDDEN;
- Simple;
- Virtual=yes;
- Downloadable=no;
- Sold individually=yes;
- Manage stock=no.

### C4 — narrow coherence cleanup

Only if required:
- narrow product/cache/transient invalidation for Product 223/1224 and currency rendering.
- no broad cache purge;
- no unrelated product mutation.

## Phase D — authoritative post-write read-back

Prove:

```text
WOOCOMMERCE_STORE_CURRENCY=USD
PRODUCT_223_CURRENT_PRICE=EMPTY
PRODUCT_223_PURCHASABLE=NO
PRODUCT_223_STATUS_VISIBILITY=UNCHANGED
PRODUCT_1224_CURRENT_PRICE=1.00
PRODUCT_1224_STATUS_VISIBILITY=publish/HIDDEN
PRODUCT_223_MUTATION_SCOPE=PRICE_FIELDS_ONLY
PRODUCT_1224_MUTATION_SCOPE=PRICE_FIELDS_ONLY
STORE_CURRENCY_MUTATION_COUNT=1
```

## Phase E — customer-facing validation

1. Verify Product 223 customer-facing page/card does not expose a buyable historical test price or functional Add-to-Cart purchase path.
2. Populate Cart with exactly Product 1224 qty 1.
3. Validate Checkout:

```text
CANARY_QUANTITY=1
CANARY_ITEM_TOTAL_USD=1.00
CANARY_SHIPPING_USD=0.00
CANARY_TAX_USD=0.00
CANARY_ORDER_TOTAL_USD=1.00
PAYPAL_METHOD_PRESENT=YES
PAYPAL_LIVE_CONNECTED=CARRIED_FORWARD_ACCEPTED_PASS
```

Do not click Place order or enter PayPal buyer flow.

## Phase F — final prepayment seal

Persist:

```text
BUYER_ACCOUNT_SEPARATION=REQUIRED
SAME_PAYPAL_ACCOUNT_BUYER_AND_MERCHANT=FORBIDDEN
MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
EXPECTED_PAID_ORDER_STATUS=PROCESSING
EXPECTED_SIGNED_WEBHOOK_PROOF=DEFERRED_TO_REAL_CANARY
FULL_REFUND_GROSS_USD=1.00
PAYPAL_FEE_RECOVERY_STATUS=UNKNOWN_OWNER_AWARENESS_REQUIRED
NO_BLIND_REPLAY=SEALED
REAL_PAYMENT_AUTHORIZED=NO
REFUND_AUTHORIZED=NO
SOFT_LAUNCH_AUTHORIZED=NO
```

## Mandatory rollback

If any invariant fails after the first write and before PASS_CANDIDATE:

Restore exact pre-gate values:
- Product 223 price tuple;
- Product 1224 price tuple;
- store currency = JPY.

Then fresh read-back and RETURN exact cause.

No partial USD migration state may remain.

Do not rollback a fully passing migration simply because execution stops at Reviewer.

## Strictly forbidden

- production price invention for Product 223;
- Product 223 title/content/media/SKU/stock/status/visibility mutation;
- unrelated product mutation;
- order creation;
- Place order;
- buyer PayPal approval/login;
- payment/capture/refund;
- webhook replay/simulation/resubscribe;
- PayPal settings mutation;
- Secret/token/nonce/session/hash output;
- Shared Infra mutation;
- Soft Launch.

## Evidence minimum

```text
GATE=K7_R2R2_R2_BOUNDED_USD_STORE_MIGRATION_AND_CANARY_SEAL
PUBLISHED_PRODUCT_SET=
PUBLIC_PRICED_PRODUCT_SET=
PRE_CURRENCY=
PRE_223_REGULAR_PRICE=
PRE_223_CURRENT_PRICE=
PRE_223_SALE_PRICE=
PRE_1224_REGULAR_PRICE=
PRE_1224_CURRENT_PRICE=
PRE_1224_SALE_PRICE=
PROJECT_DB_BACKUP_CREATED=
WOOCOMMERCE_STORE_CURRENCY=
PRODUCT_223_CURRENT_PRICE=
PRODUCT_223_PURCHASABLE=
PRODUCT_223_STATUS_VISIBILITY=
PRODUCT_1224_CURRENT_PRICE=
PRODUCT_1224_STATUS_VISIBILITY=
CANARY_QUANTITY=
CANARY_ITEM_TOTAL_USD=
CANARY_SHIPPING_USD=
CANARY_TAX_USD=
CANARY_ORDER_TOTAL_USD=
PAYPAL_METHOD_PRESENT=
PRODUCT_223_MUTATION_SCOPE=
PRODUCT_1224_MUTATION_SCOPE=
STORE_CURRENCY_MUTATION_COUNT=
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
BUYER_APPROVAL_ACTIONS=0
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
WEBHOOK_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SOFT_LAUNCH_AUTHORIZED=NO
```

## Success

```text
PASS_CANDIDATE_K7_R2R2_R2_BOUNDED_USD_STORE_MIGRATION_AND_CANARY_SEAL
STOP_AT_REVIEWER=YES
```

Any ambiguity: exact RETURN and STOP_AT_REVIEWER. Do not enter the real-payment Gate.
