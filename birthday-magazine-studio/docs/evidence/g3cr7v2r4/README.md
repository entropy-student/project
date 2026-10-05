# G3CR7V2R4 — Owner-approved independent widescreen refinement

**Executor result: PASS_CANDIDATE_G3CR7V2R4_WIDESCREEN_COMPOSITION_AND_PLACEHOLDER_CLEANUP. STOP_AT_REVIEWER=YES.** This is a candidate, not a Reviewer PASS or Owner visual freeze.

## Authority and scope

The Owner asked for an independent assessment of the proposed R4 direction, then explicitly authorized implementing that assessment. That latest instruction supersedes the R4 draft's mandatory light-mulberry field and very large task-page headlines. The approved composition uses a neutral `#F7F8FB` canvas, white product surfaces and the retained `#713F5D` mulberry action system. It emphasizes the magazine output by composition rather than a tinted decorative field or enlargement of every element.

Canonical governance v0.2.7/VNEXT, current project main Handoff, R4 contract, Owner return, and Stripe DESIGN/SOURCE/PROJECT_ADAPTER were read before mutation. Main was freshly fetched at `3a0ef7fd781f8c653d524830ade18361f75c8988`; PR #64 remained open/unmerged at `43ebf7bb732e9e3be8d547364ca7b018f7f505f8`. Changes continue on the existing remote branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`. The local checkout has the historical alias `codex/birthday-magazine-g3cr7v1-premium-saas-visual-refinement`; submission explicitly pushes HEAD to the canonical PR branch.

Only four application files change:

- `magazine-preview.css`: title and compact controls share the left column; the larger cover/spread occupy the right product stage. Controls follow their content height. The bottom rail separates action, commercial metadata and explanatory text. At 375px the DOM remains one readable vertical flow.
- `birthday-magazine-poc.php`: blank photo-hook elements remain for the frozen JS; the decorative text inside the cover slot is removed. The action says “Personalize your magazine →”, with “12-page digital PDF · US$39.99” outside it and the same `/make-your-magazine/` target. The duplicated bottom privacy sentence is removed; the existing intro/privacy/status copy remains.
- `frontend-reproduction.css`: broader workspace, step guidance beside the task on desktop, appropriately bounded short fields/long answers, 5/4/2-column photo grids. Existing `[hidden]` states are respected, including the Review navigation. No Status QA surface is restyled.
- `frontend-reproduction.php`: exactly five presentation-only `header`/`div` pairs group each step's existing description and body. Removing those wrappers reproduces the baseline PHP after whitespace normalization. No field, question, handler, hook or JS selector changes.

No new image or decorative asset, Gutenberg content write, theme setting, JS change, Woo backend change, account/workspace change, order mutation or database write was made. Hero, other homepage sections, native commerce and the standalone QA-only status page are outside visual scope.

## Review entry points

- [Before/final contact sheet](final-contact-sheet.jpg) — 2200×12898, 1,867,358 bytes. It is an overview; full-resolution PNGs and numeric geometry are authoritative.
- [Final screenshots](confirm/) — 27 images: all five intake steps plus empty/photo Preview at 2048/1440/375, and six additional whole-viewport context captures.
- [Before screenshots](before/) — 21 fresh captures from the pre-write live candidate.
- [Screenshot dimensions, byte sizes and SHA256](screenshot-manifest.json).
- [Before/final element geometry](geometry-delta.json), [final geometry](confirm/geometry.json).
- [Behavior and network checks](confirm/checks.json).
- [Exact source/runtime + ordinary Edge delivery](source-runtime-identity.json).
- [Frozen JS / presentation-only PHP proof](frozen-boundary-proof.json).

The Gate's nine primary final images are:

| Surface | 2048px | 1440px | 375px |
|---|---|---|---|
| Homepage Preview | `confirm/home-empty-2048.png` | `confirm/home-empty-1440.png` | `confirm/home-empty-375.png` |
| Intake About | `confirm/intake-about-2048.png` | `confirm/intake-about-1440.png` | `confirm/intake-about-375.png` |
| Intake Photos | `confirm/intake-photos-2048.png` | `confirm/intake-photos-1440.png` | `confirm/intake-photos-375.png` |

The `home-empty` captures contain the entire feature section, hence their PNG widths equal the browser viewport. Intake step captures are app-element crops at the stated CSS viewport: 1488/1248/375px actual image widths. Supplemental `intake-viewport-*` images include the full viewport width and surrounding Header/Footer. `home-viewport-*` are viewport-only contextual images, not full mobile Preview captures.

## Measured final scale

| Measure | 2048 | 1440 | 375 |
|---|---:|---:|---:|
| Preview useful content width | 1568 / 76.6% | 1280 / 88.9% | 343 / 91.5% |
| Controls / stage width | 360 / 1176 | 300 / 948 | 343 / 343, stacked |
| Preview heading | 48px | 36px | 32px |
| Cover rotated bounding width | 365px | 320px | 252px |
| Spread bounding width | 684px | 555px | 313px |
| Preview action height | 52px | 52px | 50px |
| Intake app / card width | 1488 / 1488 | 1248 / 1248 | 375 / 343 |
| Intake heading / step heading | 44 / 32px | 36 / 32px | 30 / 26px |
| Intake field text / height | 17 / 54px | 17 / 54px | 16 / 48px |
| Photo columns | 5 | 4 | 2 |

About short-field area stops at 840px on desktop. Story/Little things/Review use a 75ch ceiling, rather than stretching prose across the entire workspace. The measured Header-to-app gap is 64px desktop / 40px mobile; this is the actual rendered gap, not the CSS card padding. No claim is made that the older Gate's every suggested number was implemented. Home's header-gap measurement includes earlier homepage sections and is not an intake spacing metric.

At 2048 the old Preview cover/spread bounding widths were 250/502px; final widths are 365/684px. The old intake app was capped at 1120px; final is 1488px. All final states have `scrollWidth <= innerWidth`, zero rendered broken images, and no photo/copy layout overlap.

## Behavior, privacy and delivery

`readback-g3cr7v2r4.cjs` exercises name/age updates, local photo selection/reselection/removal, intake Next/Back, minimum-photo failure, 12 local synthetic photos, 3 must-use and disabled fourth must-use, and six answer summaries. The Review Woo handoff is inspected, never clicked. It still identifies product 1113, `wc-ajax=add_to_cart` and `/checkout/`. Preview images use `blob:`. Across the three contexts: non-GET attempts=0, external image requests=0, page errors=0, failed resources=0; no model/provider requests were made. Empty photo-hook elements have no text and computed `background-image: none`; no replacement asset is added. The neutral slots preserve the magazine's real type/layout, rather than making the whole result area blank.

The interaction harness uses request routing to fail closed against accidental writes; Playwright routing disables HTTP cache. **That harness is not the ordinary-cache delivery proof.** The separate `verify-g3cr7v2r4.cjs` uses ordinary Edge contexts without routing, disabled cache, cache clearing or bypass headers, then reloads the pages. Its loaded CSS URLs follow file mtimes; response SHA256 equals the source and mounted runtime bytes. The same candidate remains mounted after capture, rather than restoring old CSS.

Read-only Product/Cart/Account GETs return 200. Empty-cart Checkout GET follows Woo's redirect to Cart (200); no populated checkout form/payment truth replay is claimed. Accepted G3CR7R1R2 payment/order Evidence is reused by source correlation. `preview.js`, `frontend-reproduction.js`, `home-motion.js` match baseline after Git checkout newline normalization; the Woo status PHP suffix is byte-identical after newline normalization. No authenticated account replay is needed for this presentation scope. Existing Owner Gutenberg access is retained by leaving Home content, theme and account configuration untouched; this is preservation, not a new authenticated edit test.

## Bounded repair / limitations

One complete build was inspected, one CSS repair batch was applied, and one final visual confirmation followed. The first pass exposed older high-specificity selectors still limiting intake width/font and a Review navigation display override. The final rules fix those cascade/hidden-state conflicts. `diagnostic-first-pass-geometry.json` retains that finding; first-pass PNGs are preserved locally in ignored `.tmp/g3cr7v2r4-first-pass/`, not presented as final.

Evidence-helper corrections were also made without changing the website: URL resolution now supplies the origin; photo/copy overlap compares their shared unrotated layout coordinates rather than falsely overlapping rotated axis-aligned boxes; identity comparison normalizes Git checkout line endings; the extra geometry report distinguishes useful content width from full section width. The final reports pass. An independent subagent visually inspected the final homepage and all 15 intake frames, finding no P1/P2 layout/readability issue. It is advisory review, not the project's formal Reviewer decision.

Owner real-device visual acceptance remains **PENDING**. This does not prove production asset retention, generation, paid fulfillment or persistence; those business areas were not exercised.

## Rollback / retained runtime

Pre-write exact copies and hashes of the four source/runtime files remain locally, ignored:

`birthday-magazine-studio/poc/g3c/.tmp/g3cr7v2r4-rollback/{source,runtime,manifest.json}`

Restore only those four files from their corresponding `source/` and `runtime/` copies. Verify every copied SHA256 against the backup manifest. Restore the source copy's mtime to its runtime counterpart so the retained `filemtime()` CSS URL remains consistent. No database restore is needed. Git source rollback anchor: `43ebf7bb732e9e3be8d547364ca7b018f7f505f8`.

The container ID remains `21892d72baebe6157fbeab15ad6a1e3949cf4663ca55b45360c3f4eb1f052f00`, running. The actual mount remains the separate project worktree's `poc/g3c/preview-plugin`; only the four authorized files were copied there. Preflight found other runtime/source differences to be newline representation, not a local-only dependency. No build/pull/restart/recreate/teardown/global prune or unrelated-resource action occurred. Disposable browser contexts were closed; scoped rollback remains for Owner review.

Local review: `http://127.0.0.1:8189/#preview`, `http://127.0.0.1:8189/make-your-magazine/`, admin `http://127.0.0.1:8189/wp-admin/`.

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
CHECKOUT_SUBMISSIONS=0
ORDER_MUTATIONS=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
IMAGE_GENERATION=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
G4_ACTIONS=0
PR_MERGE=0
G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```
