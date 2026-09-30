# G3CR2R1 — Blocksy Wedding Gutenberg Variant Dependency Closure

> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Reviewer status: **RETURN ACCEPTED / SUPERSEDED BY G3CR2R2 — DO NOT EXECUTE**  
> Production / Live payment authority: **NONE**

## 0. Superseded

PR #61 executed this closure and returned `RETURN_G3CR2R1_VARIANT_METADATA_UNAVAILABLE`. Reviewer accepted the RETURN. The legacy single-demo PHP path is no longer the active dependency source. Current execution is `G3CR2R2_BLOCKSY_WEDDING_V2_CATALOG_CLOSURE.md`.

## 1. Historical Goal

Resolve the only open question from G3CR2:

> What dependencies does the **exact Wedding + Gutenberg variant** require according to Blocksy's own builder-specific importer metadata?

The previous `wp blocksy demo list --format=json` output must not be used as a builder-specific dependency source because Blocksy's CLI merges variants with the same demo name and unions their plugin lists.

## 2. Required read order

1. `../REVIEWER_HANDOFF.md`
2. `REVIEWER_DECISION_G3CR2_RETURN.md`
3. `OWNER_DECISION_G3C_BLOCKSY_WEDDING.md`
4. `G3CR2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY.md`
5. PR #60 evidence
6. this closure

## 3. Phase A — read-only exact variant query

Reconstruct the same fresh isolated G3CR2 runtime:

- WordPress 7.1.1
- MariaDB 11.4.7
- Blocksy 2.1.57
- Blocksy Companion 2.1.57

No WooCommerce is needed before the dependency boundary is closed.

After Blocksy + Companion are active, query the builder-specific importer metadata by invoking the same current code path used by Blocksy itself:

```php
\Blocksy\Plugin::instance()->demo->fetch_single_demo([
    'demo' => 'Wedding',
    'builder' => 'gutenberg',
    'field' => 'all'
])
```

A WP-CLI `wp eval` wrapper is acceptable.

Persist a sanitized JSON read-back containing at minimum:

- requested demo = Wedding
- requested builder = gutenberg
- returned demo identity if present
- returned builder if present
- returned `plugins` field
- returned free/pro marker if present
- success/error status

Do not import the starter during this read-only step.

## 4. Decision boundary

### A — exact Gutenberg metadata excludes Elementor and HT Slider

If the exact Wedding:gutenberg response does **not** require:

- `elementor`
- `ht-slider-for-elementor`

then dependency closure passes.

Continue immediately into the existing G3CR2 Phase B / C:

1. import Wedding + Gutenberg;
2. install only exact free dependencies returned for that variant;
3. run WooCommerce 11.1.2 product/cart/checkout/account compatibility canary;
4. run the minimum private-workspace regression;
5. capture required screenshots/evidence.

Do not stop merely because the old merged list still contains Elementor.

### B — exact Gutenberg metadata still includes Elementor or HT Slider

Return:

`RETURN_G3CR2R1_GUTENBERG_VARIANT_REQUIRES_ELEMENTOR_STACK`

Stop before installing either plugin.

### C — exact builder-specific response cannot be retrieved

Return:

`RETURN_G3CR2R1_VARIANT_METADATA_UNAVAILABLE`

Stop before starter import.

### D — paid-only dependency appears

Return:

`RETURN_G3CR2R1_PAID_DEPENDENCY_REQUIRED`

Stop.

## 5. Existing G3CR2 success criteria remain

If Phase A passes and the remaining compatibility canary passes, return:

```text
PASS_CANDIDATE_G3CR2R1_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY

WEDDING_GUTENBERG_VARIANT_METADATA=PASS
ELEMENTOR_REQUIRED_FOR_GUTENBERG=NO
HT_SLIDER_REQUIRED_FOR_GUTENBERG=NO
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

## 6. Forbidden actions

Unchanged:

- no Elementor install unless a later Reviewer decision explicitly authorizes it;
- no HT Slider install;
- no paid purchase;
- no PayPal;
- no real money;
- no AI/model call;
- no production deployment;
- no Shared Infrastructure;
- no full Birthday Magazine visual adaptation;
- no Good Issue integration work;
- no global Docker prune.

## 7. Cleanup

Same scoped cleanup rules as G3CR2.

Preserve only source, sanitized reports and screenshots required for review.
