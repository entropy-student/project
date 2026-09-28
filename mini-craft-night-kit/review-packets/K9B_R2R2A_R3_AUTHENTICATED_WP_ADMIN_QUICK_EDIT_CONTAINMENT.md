# K9B-R2R2A-R3 — Authenticated WordPress Admin Quick Edit Containment

Status: AUTHORIZED_SINGLE_RETRY_STATUS_ONLY
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R2R2A_R2_RETURN_RETRY_VIA_QUICK_EDIT.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md

## Goal

Perform exactly one new authenticated Admin attempt to change Product 1224 from Published to Draft using the Products list Quick Edit path.

Do not use PPCP logs.

## Preflight

In WooCommerce / Products:

Locate Product ID 1224.

Confirm:

```text
PRODUCT_ID=1224
STATUS=Published
PRICE_USD=1.00
CATALOG_VISIBILITY=Hidden
```

If already Draft:
- do not write;
- proceed to public validation.

If any guarded value differs materially:
- RETURN;
- do not modify.

## Mutation

Preferred path:

```text
Products
-> Product 1224
-> Quick Edit
-> Status = Draft
-> Update
```

Only one new Update click is authorized.

Do not change any other Quick Edit field.

## Post-write read-back

After Update:
- wait for row refresh;
- read back Product 1224 status from Admin;
- if UI disconnects, reload Products list once and read server state;
- never click Update a second time without Reviewer authorization.

Expected:

```text
POST_STATUS=Draft
PRICE_USD=1.00
CATALOG_VISIBILITY=Hidden
```

If still Published:

`RETURN_K9B_R2R2A_R3_STATUS_UPDATE_NOT_COMMITTED`

## Public validation

Only after Draft is proven:

```text
PUBLIC_SHOP_CONTAINS_1224=NO
UNAUTHENTICATED_STORE_API_SEARCH_RETURNS_1224=NO
UNAUTHENTICATED_STORE_API_DIRECT_1224=NOT_PUBLIC
PUBLIC_PRODUCT_PERMALINK_1224=NOT_PUBLIC
PUBLIC_PURCHASABLE_1224=NO
```

Do not create cart/order/checkout.

## Forbidden

No:
- PPCP Logs page;
- Product 223 mutation;
- PayPal/webhook/email mutation;
- filesystem/Docker mutation;
- direct SQL;
- plugin/theme/file editor;
- plugin installation;
- order/payment/refund.

## Persist

Append to:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

Fresh-read-back both.

Success:

```text
PASS_CANDIDATE_K9B_R2R2A_R3_AUTHENTICATED_WP_ADMIN_QUICK_EDIT_CONTAINMENT
FIRST_LIVE_TRANSACTION_CANARY=ARMED_DORMANT
STOP_AT_REVIEWER=YES
```

Do not resume K9B cleanup or enter K9C automatically.
