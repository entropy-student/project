# G3CR6R3D2 — implemented homepage evidence

**Executor result: PASS_CANDIDATE. Official Reviewer decision and Owner visual approval remain pending. STOP_AT_REVIEWER=YES. Owner relay=NONE.**

## Open first

- [Desktop full homepage](round2/screenshots/desktop-normal-full.png)
- [375px full homepage](round2/screenshots/mobile-normal-full.png)
- [Desktop Hero](round2/screenshots/desktop-normal-hero.png) / [375px Hero](round2/screenshots/mobile-normal-hero.png)
- [Preserved desktop Preview](round2/screenshots/desktop-normal-preview-component.png) / [375px Preview](round2/screenshots/mobile-normal-preview-component.png)
- [Mobile menu](round2/screenshots/mobile-normal-menu-open.png)
- [Dark desktop closing](round2/screenshots/desktop-normal-bms-closing.png) / [mobile closing](round2/screenshots/mobile-normal-bms-closing.png)
- [Design contract](DESIGN.md), [machine acceptance](machine-acceptance.json), [browser evidence](round2/browser.json), [PNG hashes/dimensions](screenshot-manifest.json)

There are **53 new final PNGs**. `round2/screenshots/` contains each mapped section, three sample-card scroll states per width, early/settled entrance, hover/focus, full normal/reduced/no-JS/motion-controller-unavailable pages, and Product/Cart/Checkout/My Account route captures. Checkout captures show the native empty-cart redirect, not a submitted checkout or fresh populated form.

## Authority and submission

- Approved starting head: `89deb53b578fb6e0ddaeaf20e582fc97f23fd9a2`.
- Initial canonical main: `13601e1c5869493b2a8150c0b3fa632614f1acc7`.
- Mid-run Owner update was freshly read and synchronized by fast-forward to `7bc7bc69a9dce91ddad4939e34ef4a8ebc6b1085` before submission. Latest main freshness: `a3ca2f851398de47724452896465a900dcec8d50`. Current D2/Handoff/Owner image-quality authority files match main; unrelated monorepo changes were not imported.
- Same branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`, same PR #64. The enclosing implementation/evidence commit is the immutable submission identity; its final SHA is read back after push and linked in the PR description. No merge or next Gate.
- Accepted D1 mapping and 66 screenshots reused locally; Focusly not researched again. No proprietary template code, assets or CDN font copied. Existing gift/cover/spread are adequate product imagery; new image-generation calls **0**, including rejected iterations. The new quality-first authorization was not treated as a cost-minimization instruction.

## Actual implementation and frozen boundaries

Home858 stays an ordinary Gutenberg page with eight top-level Groups: Hero → included → Preview → how → offer → FAQ → samples → closing. Six required anchors occur once. Source builder: `poc/g3c/scripts/apply-home-g3cr6r3d2.php`, guarded against replay and unexpected target drift. Home content SHA256 changes from `3f678c490ff78f91d0918aacf4edd236d58500dced0a3ac229f0c865e86e1269` to `2e344d1edb45808d31e5e2ca8622a349dce6d58057acac424f1ed8538edbdc87`.

Independent homepage-only CSS/controller provide focus-frame Hero, warm paper, locally licensed Instrument Serif, capsule navigation, alternating image/copy and dark translucent panels, three scrolling editorial sample cards, rolling CTA labels, once-only section reveals and dark closing reveal. Mobile uses simpler flow, smaller bounded transforms, no scroll pinning, and a compact native menu. Labels retain one accessible name through `aria-hidden` duplicates.

Only existing mobile menu object1098 changes `/#sample-pages` to `/#samples`; other destinations match the before readback. Configured privacy page3 is **draft**: footer empty Privacy policy link remains unchanged. No policy created, published or guessed. Footer and Blocksy theme-mod hashes are identical.

PHP diff is exactly one homepage-guarded enqueue. Preview JS/CSS and shortcode/PHP logic outside that enqueue are unchanged; internal default geometry stays1120px desktop/335px mobile. Preview controls/photo state were **not exercised or researched**. Existing browser-local/no-upload/no-runtime-model proof is reused with source-hash correlation, not represented as a new selected-photo network test. Account/private-workspace code hashes remain unchanged; no new login or authorization test is claimed. Owner remains Administrator with Gutenberg/Home/media/global-style capabilities; no credential/session captured. No authenticated admin screenshot was required or fabricated.

Product1113 stays USD39.99/virtual. Product/Cart/Account GET200, empty-cart Checkout redirects to Cart200. Order count1→1; generation jobs0; product model calls0. Woo/page/backend source unchanged. No Add to Cart, form submit, order, PayPal, payment, account, entitlement or provider mutation.

## Validation and bounded finish

Final eight browser contexts: 1440×1000 and375×812 × normal, reduced-motion, all-JS-disabled, homepage-controller-unavailable. Every full-page document width matches its viewport; broken rendered images, page errors and failed HTTP resources are0. The intentionally blocked homepage controller in the unavailable scenario is a deliberate fault injection, not a normal resource failure.

Early Hero blur9px / opacity.65 desktop and blur7.76px / opacity.698 mobile settle to blur0 / opacity1. Each width records three different scroll-card matrices; hover labels change transform; keyboard focus is visible. Reduced/no-JS/unavailable content and real links remain readable. Mobile menu opens, points to#samples and closes on Escape (`closed:"false"` in browser JSON means trigger `aria-expanded=false`). No physical-touch/iOS/cross-browser claim is made.

First inspection found five visual defects. One consolidated source repair fixed brand contrast, mobile Hero spacing, spread crop, mobile closing overlap and mobile menu shell. Final internal finish review found those fixes resolved and no visible repair regressions; it is **not** a formal Reviewer PASS. `final-layout-probe.json` independently records white brand, contained spread, Hero box gaps12.42px/21.33px and mobile closing gap22.70px. Its empty file-input value describes default state only, not preservation proof. Source hashes provide preservation proof.

The generic design detector flagged closing gradient text. That gradient implements the specifically requested bounded scroll reveal; reduced-motion/no-JS use solid white text. No decorative unrelated heading gradient was introduced.

Evidence tooling: an initial final-round helper waited on lazy-image decoding; it was stopped with an exact process guard, then limited to bounded Hero-image decoding and rerun. An over-strict16px desktop box-gap probe was corrected to the actual noncollision criterion after the screenshot showed a visible safe gap. Failed helper browser trees were stopped; successful contexts closed. These were evidence-helper issues, not hidden frontend failures. Round1 browser metadata is retained; its intermediate PNGs remain local and are not included in the final submission.

## Rollback and runtime

Pre-write backup: `poc/g3c/artifacts/backups/g3cr6r3d2/` contains full Home content, exact menu object, original CSS/PHP and SHA256 manifest; new-controller prior absence is recorded. Default-dry `scripts/rollback-g3cr6r3d2.cjs` checks backup hashes and PHP restore correlation without writes. [Dry restore readback](rollback-dry-readback.json) confirms8 restorable Groups, Preview and exact menu1098. Actual rollback was not executed. An explicitly authorized future `--apply` restores only Home/menu/two sources and removes the new controller; licensed font files remain inert.

[Resource readback](resource-readback.json) compares current Docker identities/state/mounts/ports, volume names and network IDs with accepted D1R2 post-start evidence. This is a named accepted baseline, **not** a fabricated D2 before-inventory. Unrelated mounts are hash-redacted. All stable projections match. WordPress/MariaDB/Mailpit remain running, db/mail healthy, WP-CLI stopped. No start/build/pull/recreate/reset/migrate/prune/teardown occurred.

Retained site: http://127.0.0.1:8189/ ; admin: http://127.0.0.1:8189/wp-admin/ . Project-local evidence/rollback retained for review. Pre-existing Owner archives,17 old screenshot deletions and unrelated untracked evidence are untouched and excluded.

Post-push hygiene: scoped `.gitattributes` plus explicit backup re-add preserve original CRLF bytes in Git, rather than silently normalizing the SHA-guarded rollback package. Git-blob hash verification is part of submission readback. Default PowerShell HTTP routing later refused localhost; explicit `-NoProxy` and Node direct HTTP both returned200, with existing container identities/state unchanged. No global proxy setting or runtime resource was changed. This route-specific observation does not require a restart.

All forbidden actions this round are0: PayPal, real money, runtime Preview/product models, production AI, production deployment, shared infrastructure, Checkout submission, order creation, P1–P12, core Aha changes, purchases, global prune, PR merge and G4. Reviewer decision files are unchanged.
