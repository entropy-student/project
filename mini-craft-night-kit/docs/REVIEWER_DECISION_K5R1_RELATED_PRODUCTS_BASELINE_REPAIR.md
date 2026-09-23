# Reviewer Decision — K5R1 Related Products Baseline Repair

Date: 2026-09-23
Status: AUTHORIZED
Parent Gate: K5_RELEASE_CANDIDATE_QA
Executor return: 11115a72e18213f49cca49e928a9a40ea7e793b4

## Reviewer finding

The K5 stop is valid.

Accepted K4 truth explicitly required inherited demo tech products to be hidden from both Shop and Related Products. Current fresh Product HTML still renders:
- USB-C Cable
- Universal Charger
- Remote Control

Shop itself correctly shows only Mini Craft Night Kit.

Therefore the active runtime has a storefront baseline conflict that must be reconciled before K5 resumes.

## Gate

GATE=K5R1_RELATED_PRODUCTS_BASELINE_REPAIR

## Scope

Narrow repair only.

Do not restart all K5 QA yet.

### 1. Determine exact source

Inspect read-only first:
- current post/product status for legacy demo product IDs 222, 224, 117;
- product visibility/catalog status;
- whether current Related Products section comes from native WooCommerce dynamic related products;
- whether it is a static/manual block/template reference;
- whether stale WooCommerce transients/object/cache data explains the output.

Return:
RELATED_SOURCE=
LEGACY_PRODUCT_STATUS_222=
LEGACY_PRODUCT_STATUS_224=
LEGACY_PRODUCT_STATUS_117=

### 2. Repair order

Use the smallest valid repair.

Preferred order:

A. If demo product publication/status drifted:
- restore IDs 222/224/117 to draft;
- do not delete them.

B. If statuses are already draft and stale WooCommerce cache/transients are the cause:
- clear only the relevant WooCommerce product/related-product cache/transients;
- no broad destructive cache/database cleanup.

C. If the Related Products output is a static/manual inherited template/block:
- remove only the legacy static/manual demo-product references from the Product related section;
- preserve canonical WooCommerce Product page and gallery;
- do not redesign the Product page.

D. If native WooCommerce still exposes demo products despite correct draft state and clean cache:
- apply the narrowest filter/exclusion necessary to prevent non-published/non-customer-visible legacy demo products from appearing;
- document exact hook/filter;
- do not globally disable future legitimate related products unless no narrower repair is possible.

### 3. Acceptance

Fresh anonymous Product page must show:
- no USB-C Cable;
- no Universal Charger;
- no Remote Control.

Shop must still show only Mini Craft Night Kit.

Product gallery must remain intact.

No Home mutation.

No price/SKU/stock mutation.

No order/payment/PayPal mutation.

### 4. Evidence

Required:
- before/after product status evidence;
- source/root-cause explanation;
- fresh anonymous Product HTML/browser evidence;
- Shop evidence;
- Product gallery smoke;
- deterministic block check only if a block/template was changed.

No full visual ZIP required unless the repair changes visible layout beyond removal of the invalid demo product cards.

### 5. After PASS

Return to:
K5_RELEASE_CANDIDATE_QA_RESUME

K5 should continue the remaining checks and deployment packaging rather than replay already-proven K4 gates.

## Return

GATE=K5R1_RELATED_PRODUCTS_BASELINE_REPAIR
RESULT=<PASS_CANDIDATE_K5R1_RELATED_PRODUCTS_BASELINE_REPAIR | RETURN_REVIEWER_*>
SUMMARY=
RELATED_SOURCE=
LEGACY_PRODUCT_STATUS_222=
LEGACY_PRODUCT_STATUS_224=
LEGACY_PRODUCT_STATUS_117=
REPAIR_ACTION=
PRODUCT_RELATED_DEMO_PRODUCTS_VISIBLE=
SHOP_DEMO_PRODUCTS_VISIBLE=
PRODUCT_GALLERY=
HOME_MUTATION=
PRICE_SKU_STOCK_MUTATION=
ORDER_ACTIONS=
PAYMENT_ACTIONS=
LIVE_ACTIONS=
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not enter VPS deployment.
Do not enable Live PayPal.
