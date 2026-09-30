# G3CR2R3 — Blocksy Wedding Import + WooCommerce Compatibility Canary

> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Reviewer status: **CURRENT / PROJECT-LOCAL REVERSIBLE EXECUTION AUTHORIZED**  
> Production / Live payment authority: **NONE**

## 1. Goal

Now that the Wedding Gutenberg dependency question is closed, answer the remaining practical question:

> Can the Owner-selected **Blocksy Wedding Gutenberg** starter be imported into a fresh isolated Birthday Magazine runtime without materially breaking the accepted WooCommerce / account / private-workspace baseline?

This is the final compatibility canary before full G3C visual productization.

Do not reopen starter-catalogue metadata research unless actual import behavior contradicts the accepted dependency mapping.

## 2. Required read order

1. `../REVIEWER_HANDOFF.md`
2. `REVIEWER_DECISION_G3CR2R2_DEPENDENCY_PASS.md`
3. `OWNER_DECISION_G3C_BLOCKSY_WEDDING.md`
4. `REVIEWER_DECISION_G3A_PASS.md`
5. `../poc/g3a/README.md`
6. this Gate
7. PR #62 evidence only as historical catalogue evidence

## 3. Frozen dependency mapping

For Blocksy Companion 2.1.57 / current Wedding v2 catalogue:

```text
WEDDING_BUILDER=GUTENBERG
RAW_V2_BUILDER_VALUE=""
REQUIRED_FREE_PLUGINS=
  simply-gallery-block
  stackable-ultimate-gutenberg-blocks
  wpforms-lite
ELEMENTOR_REQUIRED=NO
HT_SLIDER_REQUIRED=NO
STARTER_IS_PRO=NO
```

Do not install:

- Elementor;
- HT Slider for Elementor.

If the actual current importer attempts to install either despite the selected blank/Gutenberg variant, stop and return:

`RETURN_G3CR2R3_IMPORT_DEPENDENCY_CONTRADICTION`

## 4. Fresh isolated runtime

Reconstruct a new project-scoped runtime.

Preserve the accepted G3A baseline where practical:

```text
WordPress=7.1.1
WooCommerce=11.1.2
MariaDB=11.4.7
Product=synthetic virtual USD 39.99
Authenticated account=required
Canonical commerce=WooCommerce
```

Use a new isolated Compose project / ports / volumes / network.

Do not mutate historical G3A/G3B runtime or evidence directories in place.

## 5. Phase A — Wedding Gutenberg import

Install/activate:

- Blocksy Theme 2.1.57
- Blocksy Companion 2.1.57

Install only the accepted Gutenberg dependencies:

- `simply-gallery-block`
- `stackable-ultimate-gutenberg-blocks`
- `wpforms-lite`

Then import the **Wedding blank-builder/Gutenberg variant** through the current supported Blocksy Starter Site flow.

The implementation may use the dashboard importer or an equivalent current supported path that selects the blank-builder Wedding record.

Do not use the broken legacy `fetch_single_demo(..., gutenberg)` path as a prerequisite.

Capture:

- exact importer route used;
- exact plugin list active after import;
- no Elementor / no HT Slider;
- one desktop screenshot of imported Wedding homepage;
- one 375px screenshot of imported Wedding homepage.

### Import failure

If the actual supported importer cannot import the selected blank-builder Wedding variant:

`RETURN_G3CR2R3_WEDDING_IMPORT_FAILED`

If it unexpectedly demands Elementor/HT Slider:

`RETURN_G3CR2R3_IMPORT_DEPENDENCY_CONTRADICTION`

## 6. Phase B — WooCommerce 11.1.2 compatibility canary

After Wedding import succeeds:

Install/configure WooCommerce 11.1.2.

Create the G3A-equivalent synthetic baseline:

- currency USD;
- one simple virtual synthetic product;
- price US$39.99;
- native Cart;
- native Checkout;
- native My Account;
- guest checkout disabled;
- checkout account creation enabled;
- no PayPal.

### Product

Verify:

- page loads without PHP fatal / blocking JS error;
- US$39.99 visible;
- Add to Cart visible and usable;
- desktop core controls usable;
- 375px core controls usable;
- no horizontal overflow that blocks core actions.

### Cart

Verify:

- product enters native WooCommerce Cart;
- quantity/remove/basic controls usable;
- desktop and 375px core path usable.

### Checkout

Verify:

- checkout renders;
- required fields usable;
- account-creation path remains available;
- no PayPal action or real payment.

### My Account

Verify:

- account page renders;
- login/account controls usable.

## 7. Phase C — minimum private-workspace regression

Reuse the accepted G3A project-local commerce/private-workspace plugin only as needed.

Verify:

- Buyer A can access Buyer A's synthetic workspace;
- Buyer B cannot access Buyer A's workspace;
- Guest direct replay remains denied.

No payment is required.

## 8. Acceptance standard

Visual polish is not part of this Gate.

Do not fail for:

- typography differences;
- spacing differences;
- wedding-specific copy;
- colors;
- imperfect product-page aesthetics.

Return only for material compatibility regressions:

- fatal PHP/JS failure;
- unusable Product / Cart / Checkout / My Account controls;
- blocking 375px overflow;
- theme CSS hiding required commerce controls;
- private-workspace authorization regression.

## 9. Screenshots

At minimum:

```text
wedding-home-desktop.png
wedding-home-mobile-375.png
woo-product-desktop.png
woo-product-mobile-375.png
woo-cart.png
woo-checkout.png
woo-my-account.png
```

Synthetic/sample data only.

## 10. Owner editing requirement

This canary does not implement final editing UX, but evidence should confirm the imported homepage remains a normal Gutenberg-editable WordPress page.

Record:

```text
WEDDING_HOME_GUTENBERG_EDITABLE=YES/NO
```

Do not create or expose a persistent Owner password in GitHub/evidence.

Full G3C will later require Owner Administrator access and direct visual editing before final visual freeze.

## 11. Forbidden scope

```text
FULL_G3C_VISUAL_ADAPTATION=0
GOOD_ISSUE_INTEGRATION_WORK=0
ELEMENTOR_INSTALL=0
HT_SLIDER_INSTALL=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PLUGIN_PURCHASES=0
GLOBAL_DOCKER_PRUNE=0
```

## 12. Evidence and cleanup

Create/update a clearly isolated G3CR2R3 subtree.

Evidence must include:

- Git baseline;
- runtime versions;
- import route;
- active plugin list;
- Wedding import result;
- screenshots;
- WooCommerce critical-page checks;
- private-workspace regression;
- Gutenberg-editability read-back;
- resource before/after;
- scoped cleanup;
- forbidden-action counters.

Append factual execution evidence to:

- `../EXECUTION_EVIDENCE.md`
- `../EXECUTOR_HANDOFF.md`

Do not modify Reviewer decision documents.

## 13. Success return

```text
PASS_CANDIDATE_G3CR2R3_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY

WEDDING_GUTENBERG_IMPORT=PASS
WEDDING_HOME_GUTENBERG_EDITABLE=YES

SIMPLY_GALLERY_BLOCK=PASS
STACKABLE=PASS
WPFORMS_LITE=PASS
ELEMENTOR_INSTALL=0
HT_SLIDER_INSTALL=0

WOOCOMMERCE_11_1_2=PASS
USD_39_99_PRODUCT=PASS
PRODUCT_DESKTOP=PASS
PRODUCT_MOBILE_375=PASS
CART=PASS
CHECKOUT=PASS
MY_ACCOUNT=PASS
PRIVATE_WORKSPACE_REGRESSION=PASS

PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
SHARED_INFRA_MUTATIONS=0

FULL_G3C_IMPLEMENTATION=NOT_STARTED
STOP_AT_REVIEWER=YES
```

## 14. Precise RETURN outcomes

```text
RETURN_PREFLIGHT_DRIFT
RETURN_G3CR2R3_IMPORT_DEPENDENCY_CONTRADICTION
RETURN_G3CR2R3_WEDDING_IMPORT_FAILED
RETURN_G3CR2R3_WOOCOMMERCE_PRODUCT_REGRESSION
RETURN_G3CR2R3_WOOCOMMERCE_CART_REGRESSION
RETURN_G3CR2R3_WOOCOMMERCE_CHECKOUT_REGRESSION
RETURN_G3CR2R3_ACCOUNT_REGRESSION
RETURN_G3CR2R3_PRIVATE_WORKSPACE_REGRESSION
RETURN_TEST_FAILURE
```
