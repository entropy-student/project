# G3CR2 — Blocksy Wedding + WooCommerce Compatibility Canary

> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Reviewer status: **CURRENT / PROJECT-LOCAL REVERSIBLE CANARY AUTHORIZED**  
> Production / Live payment authority: **NONE**

## 1. Goal

Answer one narrow question before any full G3C redesign:

> Can the current official **Blocksy Wedding — Gutenberg** starter be imported in a fresh isolated Birthday Magazine runtime without breaking the already-proven WooCommerce product/cart/checkout/account baseline?

This is **not** the full UI implementation Gate.

Do not adapt the whole Birthday Magazine page, integrate the Good Issue preview into the Wedding design, or perform subjective visual polishing in this canary.

## 2. Required read order

1. `../REVIEWER_HANDOFF.md`
2. `OWNER_DECISION_G3C_BLOCKSY_WEDDING.md`
3. `BLOCKSY_WEDDING_SELECTION_PROOF_2026-09-30.md`
4. `REVIEWER_DECISION_G3A_PASS.md`
5. `../poc/g3a/README.md`
6. this canary contract

The old Astra-specific G3CR1 and G3C execution packet are historical/superseded for theme-specific execution and must not be executed.

## 3. Frozen baseline

Reconstruct from the accepted G3A local baseline, preserving its accepted versions where practical:

```text
WordPress=7.1.1
WooCommerce=11.1.2
MariaDB=11.4.7
Product=synthetic virtual USD 39.99
Canonical commerce=WooCommerce
Authenticated account=required
PayPal actions=0
Model calls=0
```

Use a **new isolated G3CR2 Compose project / ports / volumes**.

Do not mutate the historical G3A runtime or historical evidence directories in place.

## 4. Phase A — read-only starter availability / dependency preflight

Install/activate only the current official free:

- Blocksy theme;
- Blocksy Companion.

Record exact installed versions.

Before importing anything:

1. run the current Blocksy starter-site listing through the supported UI or WP-CLI;
2. prove an exact **Wedding** entry exists;
3. prove a **Gutenberg** builder entry exists for Wedding;
4. capture the importer-reported required plugin list for that exact Wedding/Gutenberg entry;
5. classify every required plugin as free/open-source or paid.

Preferred read-back:

`wp blocksy demo list --format=json`

Do not rely only on a marketing page.

### Return conditions before import

If Wedding is absent:

`RETURN_G3CR2_WEDDING_STARTER_UNAVAILABLE`

If Wedding exists but Gutenberg is absent:

`RETURN_G3CR2_WEDDING_GUTENBERG_UNAVAILABLE`

If the Gutenberg path requires any paid dependency:

`RETURN_G3CR2_PAID_DEPENDENCY_REQUIRED`

If the importer requires Elementor/HT Slider for the Gutenberg variant and this cannot be clearly separated from the Gutenberg path:

`RETURN_G3CR2_GUTENBERG_DEPENDENCY_AMBIGUOUS`

Stop at Reviewer. Do not silently switch builders.

## 5. Phase B — fresh Wedding Gutenberg import

Only after Phase A passes:

- import **Wedding + Gutenberg** into the fresh isolated runtime;
- allow only the exact free dependencies required by the current importer;
- do not install Elementor merely because the Wedding marketing page lists it as a bundled plugin for another builder;
- record all actual imported plugins and versions;
- capture one desktop and one 375px screenshot proving the Wedding starter rendered.

Do not edit the Wedding design beyond the minimum required to make the synthetic WooCommerce baseline visible for compatibility checks.

## 6. Phase C — WooCommerce compatibility canary

Install/configure the accepted WooCommerce 11.1.2 package and create/reuse the G3A-equivalent synthetic local fixtures:

- USD currency;
- one simple virtual synthetic product at **US$39.99**;
- Cart;
- Checkout;
- My Account;
- guest checkout disabled;
- checkout account creation enabled;
- no PayPal;
- local no-money test gateway only if a checkout submission probe is needed.

Verify:

### Product
- product page renders without fatal error;
- price and add-to-cart are visible/usable;
- no material layout overlap or horizontal overflow at desktop and 375px.

### Cart
- synthetic product can enter native WooCommerce cart;
- quantity/remove/cart UI renders;
- no material layout break at desktop and 375px.

### Checkout
- checkout renders;
- required fields remain usable;
- account-creation path remains available;
- **do not submit a PayPal payment**.

### My Account
- login/account page renders and remains usable.

### Private workspace minimum regression
Reuse the accepted G3A project-local commerce/private-workspace plugin only if required for this probe.

Confirm:
- authenticated Buyer A can reach own synthetic workspace;
- unrelated Buyer B cannot reach Buyer A workspace;
- guest direct replay remains denied.

No payment is needed.

## 7. Canary acceptance standard

Aesthetic differences are not failures.

Return only for material functional regressions such as:

- fatal PHP/JS error blocking the path;
- unusable product/cart/checkout/account controls;
- persistent horizontal overflow that blocks core actions;
- theme CSS hiding/replacing required WooCommerce controls;
- account/private-workspace access regression.

Minor spacing, typography or visual styling differences are deferred to full G3C productization.

## 8. Forbidden scope

```text
FULL_BIRTHDAY_MAGAZINE_VISUAL_ADAPTATION=0
GOOD_ISSUE_INTEGRATION_WORK=0
PAYPAL_SANDBOX_ACTIONS=0
PAYPAL_LIVE_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PLUGIN_PURCHASES=0
ELEMENTOR_INSTALL_UNLESS_REVIEWER_REOPENS=0
GLOBAL_DOCKER_PRUNE=0
```

## 9. Evidence

Create/update a G3CR2 project-local subtree under `poc/g3cr2/` or another clearly isolated canary directory without mutating historical G3A source.

Evidence must include:

- Git baseline;
- Docker/resource before/after;
- WordPress/WooCommerce/MariaDB versions;
- Blocksy / Companion versions;
- exact starter-list read-back;
- exact Wedding/Gutenberg dependency list;
- import result;
- desktop + 375px screenshots for starter and WooCommerce critical pages;
- account/private regression result;
- browser console/network fatal-error check where relevant;
- cleanup read-back;
- forbidden action counters.

Append factual execution evidence to:

- `../EXECUTION_EVIDENCE.md`
- `../EXECUTOR_HANDOFF.md`

Do not modify Reviewer decision documents.

## 10. Cleanup

After evidence capture:

- preserve source/reports/screenshots;
- tear down only the exact G3CR2 project-scoped runtime unless Reviewer explicitly requests it remain available;
- do not remove unrelated Docker objects;
- no broad prune.

## 11. Success return

```text
PASS_CANDIDATE_G3CR2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY

WEDDING_STARTER_VISIBLE=PASS
WEDDING_GUTENBERG_VISIBLE=PASS
PAID_DEPENDENCIES_REQUIRED=0
WEDDING_GUTENBERG_IMPORT=PASS
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

## 12. Precise RETURN outcomes

```text
RETURN_PREFLIGHT_DRIFT
RETURN_G3CR2_WEDDING_STARTER_UNAVAILABLE
RETURN_G3CR2_WEDDING_GUTENBERG_UNAVAILABLE
RETURN_G3CR2_PAID_DEPENDENCY_REQUIRED
RETURN_G3CR2_GUTENBERG_DEPENDENCY_AMBIGUOUS
RETURN_G3CR2_WEDDING_IMPORT_FAILED
RETURN_G3CR2_WOOCOMMERCE_PRODUCT_REGRESSION
RETURN_G3CR2_WOOCOMMERCE_CART_REGRESSION
RETURN_G3CR2_WOOCOMMERCE_CHECKOUT_REGRESSION
RETURN_G3CR2_ACCOUNT_REGRESSION
RETURN_G3CR2_PRIVATE_WORKSPACE_REGRESSION
RETURN_TEST_FAILURE
```

Do not switch template or builder to work around a RETURN.
