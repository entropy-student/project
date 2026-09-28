# K9B-R2R2A — Product 1224 Public Exposure Containment

Status: AUTHORIZED_BOUNDED_SAFETY_REDUCTION
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R2R1_RETURN_RECONCILED_DOCKER_COUNT_RESOLVED_CANARY_CONTAINMENT.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical Governance latest
- Production Provider Canary and Recovery Contract
- Target Host Reality Contract

## Scope

Production safety reduction only.

Do not perform local filesystem cleanup or Docker cleanup in this Gate.

Target product:
`1224`

Authorized mutation:
`publish -> draft`

No other product/business field may change.

## Preflight

Freshly verify on the production target:

```text
TARGET_HOST_EXECUTION_PROVEN=PASS
PRODUCT_1224_EXISTS=YES
PRODUCT_1224_STATUS=publish
PRODUCT_1224_CATALOG_VISIBILITY=hidden
PRODUCT_1224_PRICE_USD=1.00
PRODUCT_1224_PURCHASABLE=YES
WOOCOMMERCE_STORE_CURRENCY=USD
PRODUCT_223_PURCHASABLE=NO
```

Also reproduce the current public exposure read-only:

```text
PUBLIC_SHOP_CONTAINS_1224=NO
UNAUTHENTICATED_STORE_API_SEARCH_RETURNS_1224=YES
```

If the current state differs materially, RETURN before mutation.

## Mutation

Use WordPress/WooCommerce application-level mutation only.

Change only:

```text
Product 1224 status:
publish -> draft
```

Do not use direct SQL.

Do not change:
- price;
- SKU;
- catalog visibility metadata;
- virtual flag;
- sold-individually flag;
- title/slug;
- Product 223;
- store currency;
- PayPal;
- webhook;
- email;
- order state.

## Ambiguous outcome handling

If the write command/connection result is ambiguous:

1. stop;
2. read back Product 1224 status;
3. if already `draft`, continue post-validation;
4. if still `publish`, RETURN;
5. do not blindly replay without state reconciliation.

## Post-validation

Freshly prove:

```text
PRODUCT_1224_STATUS=draft
PRODUCT_1224_ADMIN_FIXTURE_EXISTS=YES
PRODUCT_1224_PRICE_USD=1.00
PRODUCT_1224_CATALOG_VISIBILITY=hidden

PUBLIC_SHOP_CONTAINS_1224=NO
UNAUTHENTICATED_STORE_API_SEARCH_RETURNS_1224=NO
UNAUTHENTICATED_STORE_API_DIRECT_1224=NOT_PUBLIC
PUBLIC_PRODUCT_PERMALINK_1224=NOT_PUBLIC
PUBLIC_PURCHASABLE_1224=NO

PRODUCT_223_PURCHASABLE=NO
WOOCOMMERCE_STORE_CURRENCY=USD

PAYPAL_MUTATION=0
WEBHOOK_MUTATION=0
EMAIL_MUTATION=0
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
LOCAL_FILESYSTEM_MUTATION=0
LOCAL_DOCKER_MUTATION=0
SHARED_INFRA_MUTATION=0
```

Do not create a cart or checkout session.

## Future Canary state

After containment:

```text
FIRST_LIVE_TRANSACTION_CANARY=ARMED_DORMANT
CANARY_PRODUCT_REACTIVATION_REQUIRED=YES
CANARY_REACTIVATION_REQUIRES_FUTURE_DEDICATED_PAYMENT_GATE=YES
```

## Evidence

Append to:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

Minimum:

```text
GATE=K9B_R2R2A_PRODUCT_1224_PUBLIC_EXPOSURE_CONTAINMENT
PRE_STATUS=
PRE_CATALOG_VISIBILITY=
PRE_PRICE_USD=
PRE_PURCHASABLE=
PRE_PUBLIC_STORE_API_SEARCH_RETURNS_1224=

MUTATION=PRODUCT_1224_STATUS_PUBLISH_TO_DRAFT
MUTATION_METHOD=APPLICATION_LEVEL
DIRECT_SQL_USED=NO

POST_STATUS=
POST_PRICE_USD=
POST_CATALOG_VISIBILITY=
POST_PUBLIC_SHOP_CONTAINS_1224=
POST_PUBLIC_STORE_API_SEARCH_RETURNS_1224=
POST_PUBLIC_STORE_API_DIRECT_1224=
POST_PUBLIC_PERMALINK_1224=
POST_PUBLIC_PURCHASABLE_1224=

PRODUCT_223_PURCHASABLE=
WOOCOMMERCE_STORE_CURRENCY=
PAYPAL_MUTATION=0
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
STOP_AT_REVIEWER=YES
```

## Success

```text
PASS_CANDIDATE_K9B_R2R2A_PRODUCT_1224_PUBLIC_EXPOSURE_CONTAINMENT
STOP_AT_REVIEWER=YES
```

Do not resume K9B cleanup automatically and do not enter K9C.
