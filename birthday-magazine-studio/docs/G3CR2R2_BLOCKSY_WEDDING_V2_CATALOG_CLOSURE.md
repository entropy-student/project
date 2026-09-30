# G3CR2R2 — Blocksy Wedding v2 Dashboard Catalogue Closure

> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Reviewer status: **CURRENT / PROJECT-LOCAL REVERSIBLE CLOSURE AUTHORIZED**  
> Production / Live payment authority: **NONE**

## 1. Goal

Resolve the Blocksy Wedding dependency question using the **same v2 starter catalogue consumed by the current Blocksy dashboard UI**.

Do not use:

- `wp blocksy demo list` as builder-specific proof, because it merges variants;
- legacy `fetch_single_demo(...)` as the authoritative current dashboard source, because PR #61 proved that path returns `false` in this runtime.

## 2. Required read order

1. `../REVIEWER_HANDOFF.md`
2. `REVIEWER_DECISION_G3CR2R1_RETURN.md`
3. `OWNER_DECISION_G3C_BLOCKSY_WEDDING.md`
4. `G3CR2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY.md`
5. PR #60 and PR #61 evidence
6. this closure

## 3. Source-of-truth for this closure

Current Blocksy Companion 2.1.57 source:

- `static/js/dashboard/helpers/starter-sites.js`
- `static/js/dashboard/screens/DemoInstall.js`
- `static/js/dashboard/screens/DemoInstall/Wizzard/PickBuilder.js`

The dashboard fetches:

```text
https://startersites.io?route=v2/demo/get_all
```

and appends:

```text
companion_version=2.1.57
```

plus license/install parameters only when present.

For a free/anonymous local runtime, do not invent license/install parameters.

## 4. Phase A — read-only v2 catalogue query

Reconstruct the same fresh isolated G3CR2 runtime.

Install/activate only:

- Blocksy 2.1.57
- Blocksy Companion 2.1.57

Then perform a read-only request to the exact v2 starter endpoint used by the dashboard.

Preferred execution inside WordPress:

- use `wp_remote_get()` or the same request helper available to Blocksy;
- request the exact v2 URL with `companion_version=2.1.57`;
- save the HTTP status and sanitized JSON body;
- no Starter import.

From the returned JSON array, select records where:

```text
name == "Wedding"
```

Persist all Wedding records, preserving their individual:

- name
- builder
- plugins
- is_pro / plans if present
- url / screenshot only if useful
- any stable variant identifier if present

Then select the exact record where:

```text
name == "Wedding"
builder == "gutenberg"
```

Do not merge records.

## 5. Decision boundary

### A — Wedding/Gutenberg record exists and plugins exclude Elementor stack

If exact record exists and its `plugins` field excludes:

- `elementor`
- `ht-slider-for-elementor`

then:

```text
WEDDING_GUTENBERG_V2_METADATA=PASS
ELEMENTOR_REQUIRED_FOR_GUTENBERG=NO
HT_SLIDER_REQUIRED_FOR_GUTENBERG=NO
```

Continue immediately into the existing G3CR2 compatibility canary:

1. import Wedding + Gutenberg;
2. install only the exact free dependencies from that individual v2 record;
3. install/configure WooCommerce 11.1.2;
4. create the synthetic USD 39.99 virtual product;
5. verify Product / Cart / Checkout / My Account;
6. run minimum private-workspace regression;
7. capture desktop + 375px screenshots;
8. stop at Reviewer.

### B — exact Wedding/Gutenberg record includes Elementor or HT Slider

Return:

`RETURN_G3CR2R2_GUTENBERG_V2_REQUIRES_ELEMENTOR_STACK`

Stop before installing either plugin.

### C — Wedding exists but no Gutenberg record exists

Return:

`RETURN_G3CR2R2_WEDDING_GUTENBERG_RECORD_UNAVAILABLE`

### D — v2 endpoint cannot be retrieved or decoded

Return:

`RETURN_G3CR2R2_V2_CATALOG_UNAVAILABLE`

Include:

- HTTP status if available;
- WordPress/WP_Error code;
- response type;
- no secret-bearing raw headers.

### E — paid-only dependency

Return:

`RETURN_G3CR2R2_PAID_DEPENDENCY_REQUIRED`

## 6. Important implementation note

The current Blocksy UI's `PickBuilder.js` initializes selected builder plugins from the individual record's own `plugins` array.

That exact individual record is the dependency authority for this closure.

Do not use a union of all Wedding variants.

## 7. Existing canary rules remain

If dependency closure passes, continue only the already-authorized compatibility canary.

No full Birthday Magazine redesign yet.

Forbidden:

```text
FULL_G3C_VISUAL_ADAPTATION=0
GOOD_ISSUE_INTEGRATION_WORK=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PLUGIN_PURCHASES=0
GLOBAL_DOCKER_PRUNE=0
```

Elementor / HT Slider must remain uninstalled unless a later Reviewer decision explicitly changes the builder policy.

## 8. Success return

If the v2 metadata and the resumed compatibility canary both pass:

```text
PASS_CANDIDATE_G3CR2R2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY

WEDDING_V2_CATALOG=PASS
WEDDING_GUTENBERG_RECORD=PASS
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
