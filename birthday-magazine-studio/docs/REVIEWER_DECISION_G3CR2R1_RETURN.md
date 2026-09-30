# Reviewer Decision — G3CR2R1 Variant Metadata RETURN

Date: 2026-09-30  
Reviewed PR: #61  
Executor result: `RETURN_G3CR2R1_VARIANT_METADATA_UNAVAILABLE`

## Result

**RETURN ACCEPTED AS VALID EVIDENCE.**

Accepted facts:

- fresh isolated runtime was created;
- Blocksy Theme 2.1.57 and Blocksy Companion 2.1.57 were installed from official WordPress.org packages;
- the exact legacy PHP call `fetch_single_demo(['demo'=>'Wedding','builder'=>'gutenberg','field'=>'all'])` executed twice and returned Boolean `false`;
- no demo/builder/plugins/pro fields were returned;
- no Starter Site import was attempted;
- Elementor / HT Slider were not installed;
- WooCommerce canary and private-workspace regression were not run;
- project-scoped cleanup passed;
- payment / model / production / Shared Infrastructure actions remained zero.

## Reviewer interpretation

This RETURN closes only the old **single-demo PHP metadata path**.

It does **not** prove that:

- Wedding/Gutenberg is absent from the current Blocksy dashboard catalogue;
- Elementor is required by the Gutenberg variant;
- HT Slider is required by the Gutenberg variant;
- Blocksy Wedding is unsuitable for Birthday Magazine.

Current Blocksy Companion source shows the active dashboard path is different:

1. `static/js/dashboard/helpers/starter-sites.js` requests:
   `https://startersites.io?route=v2/demo/get_all`
   with `companion_version` and optional license/install parameters.
2. `DemoInstall.js` stores that raw v2 response directly in `demos_list`.
3. `Wizzard/PickBuilder.js` selects an individual variant record and initializes plugin configuration from that record's own `plugins` field.

Therefore the current authoritative dependency question is:

> In the v2 dashboard catalogue, what does the exact record with `name=Wedding` and `builder=gutenberg` list in `plugins`?

## Current state

```text
G3CR2=RETURN_ACCEPTED
G3CR2R1=RETURN_ACCEPTED
BLOCKSY_WEDDING_SELECTION=RETAINED
LEGACY_GET_SINGLE_PATH=UNAVAILABLE
CURRENT_V2_DASHBOARD_CATALOGUE_CHECK=REQUIRED
G3CR2R2=CURRENT
FULL_G3C_IMPLEMENTATION=HOLD
G4=HOLD_NOT_AUTHORIZED
```

## PR #61 handling

PR #61 remains valid RETURN evidence and must not be treated as PASS.

Current closure contract:

`G3CR2R2_BLOCKSY_WEDDING_V2_CATALOG_CLOSURE.md`
