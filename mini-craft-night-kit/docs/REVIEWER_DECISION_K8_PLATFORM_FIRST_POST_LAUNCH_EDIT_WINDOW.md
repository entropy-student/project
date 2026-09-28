# Reviewer Decision — K8 Platform-First / Post-Launch Edit Window

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Owner decision

Owner explicitly chose a platform-first sequence:

- keep the production site publicly online now;
- defer real SKU/supplier/product selection;
- upload or replace real product data and cover/media later;
- continue editing customer-facing pages after deployment;
- do not enable real customer purchasing until a real offer is ready.

This supersedes the immediately preceding requirement that the Owner select K4.8 candidate A/B/C/D/E before the platform can remain online.

## Superseded Gate

```text
K8A_PRODUCTION_OFFER_SELECTION_OWNER_CHECKPOINT=SUPERSEDED_AS_PRELAUNCH_BLOCKER
PRODUCT_SELECTION_REQUIRED_BEFORE_PUBLIC_PLATFORM=NO
PRODUCT_SELECTION_REQUIRED_BEFORE_REAL_COMMERCE_ACTIVATION=YES
```

The historical K8A decision remains retained for chronology only.

## Current stage

```text
PROJECT_STAGE=PUBLIC_PLATFORM_OPERATIONAL_PRECOMMERCE
PUBLIC_ORIGIN=https://minicraft.spikersun.com
PUBLIC_PLATFORM_STATUS=ONLINE
PAYMENT_INFRASTRUCTURE_STATUS=READY_WITH_DEFERRED_FIRST_LIVE_TRANSACTION_CANARY

PRODUCT_223=PUBLIC_CONCEPT_SHELL
PRODUCT_223_PRICE=EMPTY
PRODUCT_223_PURCHASABLE=NO
PRODUCT_1224=HIDDEN_USD_1_00_CANARY

REAL_COMMERCE_ENABLED=NO
SOFT_LAUNCH_AUTHORIZED=NO
PRODUCT_SELECTION=DEFERRED_TO_PRE_COMMERCE_ACTIVATION
```

## Owner post-launch edit window

```text
OWNER_POST_LAUNCH_CONTENT_EDIT_WINDOW=OPEN
```

Owner may continue editing customer-facing content after deployment, including:

- Home page copy/layout/content blocks;
- Product 223 descriptive copy and non-commercial presentation;
- FAQ;
- Shipping & Returns explanatory content, provided claims remain truthful;
- Contact page;
- product/gallery/cover media;
- create or prepare future WooCommerce products in draft/non-purchasable state;
- replace concept imagery with future real product media when ready.

These are ordinary post-launch content operations and do not require the platform to be taken offline.

## Protected commerce boundary

Until a later commerce-activation Gate is explicitly opened, do not:

- give Product 223 or another public product a live sale price;
- make any customer-facing product purchasable;
- enable a real Add-to-Cart / checkout sales path for a production offer;
- alter PayPal Live configuration;
- alter hidden Canary Product 1224 except through a dedicated payment/recovery Gate;
- change global store currency;
- create a real order/payment/refund for testing;
- publish unsupported supplier/product/shipping/return claims;
- authorize Soft Launch.

## Future trigger

When the Owner has a real product ready to sell, the trigger is:

`OWNER_READY_TO_ACTIVATE_REAL_PRODUCT_FOR_SALE`

At that point Reviewer opens a bounded commerce activation Gate that seals only the actual offer being launched:

```text
EXACT_PRODUCT=
PRODUCTION_PRICE_USD=
CONFIRMED_CONTENTS=
AVAILABILITY_OR_INVENTORY=
FULFILLMENT_SHIPPING_TRUTH=
PUBLISHABLE_MEDIA=
RETURN_REFUND_TRUTH=
```

Then Executor may make that offer purchasable, run a non-payment production smoke check, and stop for separate Soft Launch authorization.

## Deferred real payment limitation

The first future real PayPal transaction remains:

`FIRST_LIVE_TRANSACTION_CANARY`

Real Provider paid state, signed webhook delivery, WooCommerce paid transition, real transactional email and real refund remain `NO_DEFERRED` until a genuine real transaction occurs.

No blind replay is allowed on the first real transaction.
