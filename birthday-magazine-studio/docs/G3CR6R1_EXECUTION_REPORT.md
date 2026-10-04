# G3CR6R1 — Frontend Composition Redesign execution

## Current result

`PASS_CANDIDATE_G3CR6R1_FRONTEND_COMPOSITION_REDESIGN`

Execution date: 2026-10-02 (Owner timezone Asia/Shanghai; exact UTC checkpoints are in machine reports).
Branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`.
Pre-run HEAD: `9f90c1e53058567010fcbd9f505ac99ceaacc6f9`.
Existing [PR #64](https://github.com/entropy-student/project/pull/64) remains open/unmerged. No new PR.
Submission HEAD is the commit containing this record; its exact SHA is returned after GitHub fresh readback, avoiding a self-referential commit hash in this file.

Canonical main Reviewer handoff and all three G3CR6/G3CR6R1 decision packets were read in full before implementation. G3CR6 technical evidence was used only as baseline; its visual RETURN was not overridden. This is a local frontend candidate, not an Owner visual freeze.

## Composition, not another skin

The Home is rebuilt as **eight independently reorderable core Gutenberg Groups**:

1. A centered editorial birthday-gift statement over a wide magazine gift scene, with a small overlapping paper note. The old split text/image Hero is gone.
2. A concise digital-product/privacy value strip.
3. A deliberately unequal, staggered Cover + Spread gallery. No equal three-card portfolio grid; fictional sample labels remain.
4. A full-width warm-pink Preview chapter. Horizontal details/upload controls lead into a large physical cover and open spread; it is no longer a utility beside a small demo.
5. A large “12” and spread image with a vertical editorial feature list. No four equal text boxes.
6. A vertical numbered journey: photo → free preview → native purchase → private workspace. No default four-column steps.
7. A centered emotional gift conclusion with US$39.99 / 12-page digital PDF and a supporting cover.
8. A separate, open Q&A section. No CTA-card/accordion split.

The historical `g3cr4-*` DOM/classes and old CSS enqueue chain are absent from current Home rendering. Historical CSS files remain on disk for provenance/rollback; none are enqueued. Existing nav anchor `#what-you-get` was intentionally preserved by the new Included chapter. Native Blocksy header and native Woo controls were retained because they preserve supported navigation and commerce behavior, not to preserve the old visual skeleton.

The Footer is an editable Gutenberg `wp_block` (runtime ID 1143), rendered through Blocksy's supported footer hook. Supported footer placements remove the old widget columns; the supported copyright filter removes CreativeThemes attribution without a theme/vendor-file or license change.

## Preview and Woo

Preview retains the accepted browser-local JS mechanism: File → temporary object URL → decoded Image → cover/spread. It never uses upload/fetch/model APIs. New markup, balanced separate photo/copy frames, designed empty state, warm style default, horizontal controls on desktop and stacked controls on mobile replace the old workbench.

Desktop and 375px tests pass selection, replacement, removal, invalid MIME rejection, corrupt-image rejection, name/age/style updates and old-blob revocation. Network capture around every interaction proves:
```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
```
No raw photo bytes, customer record or credential is included in the report. Synthetic fixture imagery is used for the selected-photo screenshots.

Woo Product now uses a correctly proportioned gift scene, editorial title/price/summary, scope note, Preview link and supporting magazine-story section. Product title/slug/SKU/price/virtual status/identity are unchanged. Only public product description/excerpt were edited. Cart, Checkout and Account gain gift-context introductions, paper form layouts and the same typography/palette/footer. All actions/forms/nonces remain native Woo; no fake cart/checkout/order system.

Native Add to Cart (Blocksy/Woo response success), quantity 1→2, USD79.98 subtotal and remove pass. Native Checkout and My Account login forms load at both widths. Checkout is never submitted. Order count **1 before / 1 after**.

## Protected backend and Owner editing

Fresh host/runtime SHA readbacks match scoped preflight for Compose, unchanged commerce/workspace plugin, Mailpit MU integration and Woo main source. Product remains virtual USD39.99; active plugins/theme are unchanged. Existing private-workspace handler returns Owner200, unrelated403 and guest403. This test uses in-memory synthetic identity; it does not claim an authenticated HTTP login/session test. Anonymous workspace HTTP request independently returns403.

Owner remains Administrator with Home edit, Media Library and theme-options capabilities. Core heading/paragraph/image blocks provide editable copy/media; eight top-level Groups allow reorder; the interactive shortcode is confined to Preview. Core-block parse/serialize/render roundtrip passes. An authenticated Gutenberg save was not performed or claimed.

The global design tokens consume the supported Blocksy `colorPalette` setting. Blocksy's supported Dynamic CSS Output setting is `inline`, avoiding the stale imported file cache and allowing Owner palette edits to render. Palette readback verifies Coral #c74e39, Cream Hero rgb(255,249,242) and Warm Pink Preview rgb(239,216,206). The three successful capability flags are not used as a substitute for the documented editing structure.

Legacy job/model counter options are absent. The no-call conclusion comes from the Preview implementation and browser request trace, not from those absent options defaulting to zero.

## Assets and visual evidence

Generated this Gate: **none**. Reused existing G3CR6 assets because their quality suits the redesigned composition:

- `preview-plugin/assets/g3cr6/gift-hero.png`
- `preview-plugin/assets/g3cr6/sample-spread.png`
- `preview-plugin/assets/g3cr6/sample-cover.png`

Synthetic interaction fixture: `theme-overrides/g3cr6/synthetic-preview-portrait.png`.
No AI/model calls were made to create assets this Gate.

All 21 required screenshots are in [g3cr6r1 screenshots](../poc/g3c/artifacts/screenshots/g3cr6r1/).
The numeric sequence exactly matches the requested desktop/mobile Home, Hero, Samples, empty/photo Preview, Included/How, Offer/FAQ/Footer, Product, Cart, Checkout and Account views.
Actual final local rendering was visually reviewed; header overlap, cover photo/name separation, mobile spread containment and stale Blocksy palette output were corrected before final capture.

All 10 route/viewport checks show document width=viewport, zero broken images and no blocking horizontal overflow; all mobile widths are375. Browser page errors=0.

Machine evidence:

- [Preflight](../poc/g3c/artifacts/reports/g3cr6r1-preflight.json)
- [Browser regression and screenshot SHA manifest](../poc/g3c/artifacts/reports/g3cr6r1-browser.json)
- [Final protected/backend/Owner report](../poc/g3c/artifacts/reports/g3cr6r1-final.json)

## Scoped rollback and review

New rollback: [poc/g3c/artifacts/backups/g3cr6r1](../poc/g3c/artifacts/backups/g3cr6r1/).
Contains pre-run Home/Product public presentation, Blocksy theme mods, Preview source copies, baseline Home screenshot and checksum manifest. Previous G3CR6 rollback is untouched.
Opt-in local presentation restore: `node poc/g3c/scripts/restore-g3cr6r1.cjs --restore-presentation`. It has not been run. It does not restore/change orders, accounts, entitlements, jobs or runtime topology.

The 17 pre-existing missing G3CR4 screenshot files and unrelated untracked screenshot/ZIP files were not restored, removed or staged. Only the explicit G3CR6R1 frontend/evidence allowlist is submitted.

Local review: [Home](http://127.0.0.1:8189/) · [WordPress Admin](http://127.0.0.1:8189/wp-admin/).

## Forbidden counters

```text
PR_MERGE=0
THEME_CHANGE=0
BUILDER_CHANGE=0
ELEMENTOR_INSTALL=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PURCHASES=0
GLOBAL_DOCKER_PRUNE=0
G4_ACTIONS=0
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

Reviewer/Owner must evaluate the new visual composition. No G4, production deployment, payment or merge authorization is inferred.
