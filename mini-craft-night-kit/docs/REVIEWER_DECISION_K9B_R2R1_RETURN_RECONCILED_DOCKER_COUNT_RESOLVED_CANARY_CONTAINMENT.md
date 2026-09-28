# Reviewer Decision — K9B-R2R1 RETURN Reconciled / Docker Count Resolved / Canary Containment Required

Date: 2026-09-29
Role: Reviewer / Architect / Gatekeeper

## Reviewed evidence

Accepted:

- Evidence commit: `d083dfde567a11c30d72630ffa64c6950dfdcd3e`
- Executor Handoff commit: `1110409486ba3af29ef0baaa3fe6485c5315b0c0`

## K9B-R2 partial execution acceptance

The persisted partial execution facts are accepted as current truth:

```text
SCREENSHOT_DUPLICATES_REMOVED=28
SCREENSHOT_DUPLICATE_DELETED_BYTES=16067299
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=0

ROLLBACK_METADATA_RELOCATED=YES
ROLLBACK_METADATA_PROTECTED_TARGET_BYTES=54911
ROLLBACK_METADATA_CONTENT_READ=0
ROLLBACK_METADATA_HASH_ACTIONS=0

MINICRAFT_DOCKER_CONTAINERS_REMOVED=8
MINICRAFT_DOCKER_CONTAINERS_CURRENT=0
MINICRAFT_DOCKER_NETWORKS_REMOVED=4
MINICRAFT_DOCKER_NETWORKS_CURRENT=0
MINICRAFT_DOCKER_VOLUMES_REMOVED=0
MINICRAFT_CUSTOM_IMAGE_TAGS_CURRENT=0
NON_MINICRAFT_DOCKER_RESOURCES_TOUCHED=0
BROAD_PRUNE_USED=NO
```

K9B-R2 itself remains RETURN because remaining local filesystem cleanup is not closed.

## Docker volume-count reconciliation

Fresh exact read-back identifies nine retained Mini Craft volumes:

```text
1 mini-craft-k3r4-db-data
2 mini-craft-k3r4-wp-data
3 mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-db-data
4 mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-wp-content
5 mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-wp-data
6 mini-craft-kadence-poc_db_data
7 mini-craft-kadence-poc_uploads
8 mini-craft-kadence-poc_wp_core
9 mini-craft-night-kit_db_data
```

Historical accepted Evidence describes the same topology:

- K3R4 control runtime: independent WordPress + MariaDB volumes = 2;
- K3R4 recovery runtime: MariaDB + WordPress core/state + wp-content = 3;
- Kadence PoC: db_data + wp_core + uploads = 3;
- old Mini Craft project: db_data = 1.

Total expected historical topology: `2 + 3 + 3 + 1 = 9`.

No exact tenth volume name has been documented, and accepted K9B-R2/R2R1 evidence records zero volume deletions.

Therefore:

```text
DOCKER_VOLUME_COUNT_DISCREPANCY=RESOLVED
CURRENT_EXACT_MINICRAFT_VOLUME_COUNT=9
HISTORICAL_EXPECTED_VOLUME_COUNT=9
PRIOR_REPORTED_10=SUPERSEDED_AS_COUNTING_ERROR
MISSING_VOLUME_EVIDENCE=NO
VOLUME_DELETE_EVIDENCE=NO
```

The nine volumes remain retained recovery exceptions for now. This decision does not authorize their deletion.

## Product 1224 public exposure finding

Accepted production read-back:

```text
PRODUCT_1224_STATUS=publish
PRODUCT_1224_CATALOG_VISIBILITY=hidden
PRODUCT_1224_PRICE_USD=1.00
PRODUCT_1224_PURCHASABLE=YES
PRODUCT_1224_PUBLIC_SHOP_HTML=ABSENT
PRODUCT_1224_UNAUTHENTICATED_STORE_API_SEARCH=RETURNS_ID_1224
REAL_COMMERCE_ENABLED=NO
SOFT_LAUNCH_AUTHORIZED=NO
```

This violates the project safety intent of the platform-first state. A catalog-hidden but anonymously API-discoverable purchasable Canary is not sufficiently dormant while real commerce is disabled.

The current Owner direction remains:

- public platform may stay online;
- no real customer purchasing until a real production offer is ready.

Therefore Product 1224 must be moved to a non-public dormant state.

## Current priority Gate

Pause further local cleanup.

```text
CURRENT_GATE=K9B_R2R2A_PRODUCT_1224_PUBLIC_EXPOSURE_CONTAINMENT
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_SAFETY_REDUCTION
LOCAL_FILESYSTEM_DELETION_AUTHORIZED=NO
LOCAL_DOCKER_MUTATION_AUTHORIZED=NO
```

## Authorized production mutation

Change **only** Product 1224 post/product status:

```text
publish -> draft
```

Preserve:
- product ID 1224;
- title/slug;
- USD 1.00 price;
- hidden catalog visibility metadata;
- virtual/sold-individually and other Canary properties;
- PayPal settings;
- global currency;
- Product 223;
- all other products/orders.

Use WordPress/WooCommerce application-level mutation, not direct SQL.

## Why draft

Draft keeps the Canary fixture available administratively while making it non-public. The future first real transaction Canary remains conceptually armed but dormant.

```text
FIRST_LIVE_TRANSACTION_CANARY=ARMED_DORMANT
CANARY_REACTIVATION_REQUIRES_FUTURE_DEDICATED_PAYMENT_GATE=YES
```

A future real Canary Gate may explicitly restore Product 1224 to publish/hidden immediately before the Owner-authorized real transaction.

## Required preflight

Before mutation, fresh read-back must prove:

```text
PRODUCT_ID=1224
STATUS=publish
CATALOG_VISIBILITY=hidden
PRICE_USD=1.00
PURCHASABLE=YES
STORE_CURRENCY=USD
PRODUCT_223_PURCHASABLE=NO
PAYPAL_LIVE_CONFIGURATION_UNCHANGED_BASELINE=YES
```

If any business-relevant field differs, RETURN before write.

## Post-mutation acceptance

Must prove:

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
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
```

Do not create a cart/order/payment to validate this Gate.

## Failure / ambiguity

If mutation command outcome is ambiguous, do not blindly replay. Read back Product 1224 status first.

If status is already draft, continue validation.
If status remains publish, RETURN with the precise failure.
Do not restore public exposure merely to reproduce the old state.

## After PASS

Only after Reviewer PASS of this containment Gate may K9B local closeout resume.

K9C remains unauthorized.
