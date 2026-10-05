# Owner-approved homepage Preview emphasis — 2026-10-05

**Executor candidate only; formal Reviewer decision and Owner visual freeze pending. STOP_AT_REVIEWER=YES.** This is a bounded Owner-approved continuation of R4, not a new formally opened Gate. Existing PR #64 only; no merge.

## Scope and authority

The Owner said the whole Preview module felt like a white board and should be the homepage's most prominent feature. The subsequent approval explicitly limited this run to that module. The approved treatment supersedes the prior neutral/low-weight marketing header **only within homepage #preview**. Existing deep mulberry #713F5D remains the brand.

Fresh main: `32c4d440b72229100ead7087861238e046742176`. Pre-write PR head / rollback baseline: `1bb5dedde256ad84fec02d7350430f051492ed0f`. No project file drift between previously read main and refreshed main. Remote branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`; local checkout has the older execution alias `codex/birthday-magazine-g3cr7v1-premium-saas-visual-refinement`.

## What changed

- Full-width Gutenberg headline above the controls/result: **Their name. Their photo. / Their birthday magazine.** Weight650, with the final line deep mulberry at700; 64px at2048,48px at1440,34px at375.
- A pale mulberry #F4EBF0 field defines the whole feature, white controls and a warm-white #FFFDF9 magazine stage. No decorative artwork or substitute photo was added.
- Selective bold emphasis for free/instant/privacy and existing field/upload/action labels; a homepage-only “Try it for free” controls heading.
- Only existing scoped CSS, that one conditional presentation PHP line, and three Gutenberg text blocks inside Home858's Preview Group changed. Magazine internals, empty photo slots and all Preview behaviors remain unchanged.

## Review evidence

Start with [final-contact-sheet.jpg](final-contact-sheet.jpg), then full-resolution [confirm/](confirm/). The contact sheet compares before vs final at2048 empty,1440 selected photo and375 selected photo. Its JPG is2200×3370,557017 bytes. [screenshot-manifest.json](screenshot-manifest.json) records dimensions, size and SHA256 for all25 captures plus the contact sheet.

- `before/`: seven pre-write captures.
- `after/`: first complete inspection (nine captures). After this inspection, the controls heading was restricted to `is_front_page()`; homepage pixels were unchanged.
- `confirm/`: **final candidate**, nine captures including empty/photo at2048/1440/375, full homepage1440, and no-JS1440/375.
- [home-preview-before.html](home-preview-before.html) and [home-preview-after.html](home-preview-after.html): public synthetic Gutenberg Group snapshots.
- [scope-runtime-readback.json](scope-runtime-readback.json): unchanged content outside Preview, theme settings, roles/edit access, counts, source/runtime byte identities.
- [delivery-and-boundary.json](delivery-and-boundary.json): ordinary cache-enabled Edge delivery, seven frozen source/runtime files, PHP single-line delta and all four backup hashes.

The synthetic photo is the existing fictional `sample-eli-cover.png`, used only for local selection tests. Its magazine-within-magazine appearance is a test fixture, not a new page asset.

## Verification and limits

All final2048/1440/375 checks passed: no horizontal overflow, broken visible image or photo/copy overlap; name/age changes, all three styles, photo selection/reselection/removal and unchanged CTA target. Chosen photos resolve to `blob:`. The request-routed interaction harness denied non-GET requests and recorded0 attempts; external image posts and product model calls remain0. This harness disables browser cache through routing, so cache correctness is proven **separately** by ordinary Edge without routing, cache clearing or bypass. It loaded the mtime-versioned CSS with response SHA256 equal to source/mount and computed #F4EBF0 / #713F5D /650 /700 tokens.

Seven frozen files are normalized-newline equivalent to baseline in both source and mount: Preview JS, frontend JS/PHP/CSS, home CSS/motion JS and studio CSS. Stripping the single homepage-conditional heading exactly reproduces prior PHP after newline normalization. No intake, commerce or payment regression was rerun; prior accepted evidence is reused. Orders remain1, jobs0, product model calls0. Home outside-Preview SHA256 and Blocksy theme-mods SHA256 are exactly unchanged. Owner edit permission and Gutenberg editor remain true. Other homepage Group widths, heights and computed styles are unchanged; their natural vertical offset changes with Preview height.

The independent advisory screenshot inspection found no P1/P2 readability/layout issue; this is not formal Reviewer acceptance. No-JS remains readable; interaction still requires JS. Checks use reduced motion; no motion layer was changed.

## Runtime and rollback

The exact candidate remains mounted in unchanged container `birthday-magazine-g3c-wordpress-1` at [homepage Preview](http://127.0.0.1:8189/#preview). Admin: http://127.0.0.1:8189/wp-admin/. No Docker lifecycle, teardown or global cleanup occurred.

Ignored local rollback directory: `poc/g3c/.tmp/preview-focus-20261005/`. Contains source/runtime copies of the two changed files with original mtimes/hashes, `wordpress-before.json` and manifest. All four original file hashes were checked. No secret/session/password is stored. Do not overwrite this backup. No rollback was applied.

For an authorized rollback, first require the current source/runtime hashes and Home858 Preview hash to equal this candidate. Restore **only** the two source/runtime files from the recorded role copies (preserve original mtimes), and replace **only** the unique Preview Gutenberg Group with `home-preview-before.html`. Require outside-Preview hash unchanged; stop on drift rather than restoring the whole Home/database. Never reset volumes or other homepage sections. The durable before/after Group snapshots and Git baseline support scoped reconstruction if the ignored backup is unavailable.

Application helpers: `preview-brand-focus.cjs` (one-off guarded backup/apply/verify), `readback-preview-brand-focus.cjs` (scoped interaction/captures), `verify-preview-focus-boundary.cjs` (read-only boundary/delivery). Dependencies reused: Node24.19.0, Playwright1.62.1, Edge154.0.4258.53 and bundled Pillow for contact sheet; no packages installed.

Add-to-Cart, checkout submission, order mutation, PayPal, real money, product model/provider calls, image generation, deployment, Shared Infra mutation, G4, PR merge: **0**. Owner visual freeze pending.

