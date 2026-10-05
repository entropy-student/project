# Owner-approved gift-reference Preview reproduction — 2026-10-05

**Executor candidate: PASS_CANDIDATE. Formal Reviewer acceptance and Owner visual freeze pending. STOP_AT_REVIEWER=YES.** This is the Owner-authorized continuation of R4, not a newly invented Gate. Existing PR #64 only; open/unmerged.

## Authority / scope

The Owner provided the generated reference in [owner-reference.png](owner-reference.png), asked for high-fidelity implementation, and expressly excluded real page flipping. The approved reference replaces the former white workbench treatment **only in homepage #preview**. Its warm photographic field, substantial serif type, white form card, mulberry actions and dimensional magazines are the implementation target. Older Stripe/neutral/no-decor directions continue outside this module; the newer specific Owner instruction supersedes them inside it.

Canonical governance was freshly fetched/read from entropy-student/spike.skill main, commit 8185b7dc13221338f3dc34f73f3b0359d6697fd2 (v0.2.7). Current project main is b111fbebe2828b0628f1d1edbc2bd5a84fa56bb3; it has no project-path drift from the previously read main. PR #64 baseline/rollback is f84470a70137d1bd77b58567a9be608b82e1b750. Remote branch: codex/birthday-magazine-g3c-blocksy-wedding-productization; local checkout retains the older codex/birthday-magazine-g3cr7v1-premium-saas-visual-refinement alias.

## Implementation

- Only magazine-preview.css and four narrow homepage-conditional shortcode presentation changes in birthday-magazine-poc.php changed. Home858 Gutenberg content and Blocksy settings were **not written**. The existing headline remains Owner-editable Gutenberg text.
- A separately generated photographic background supplies flowers/ribbon/light; it contains no words, controls, magazines, people or customer content. All controls, names, photo slots, cover typography and spread content remain real HTML.
- The cover and open spread use CSS perspective, paper gradients, page edges, center-fold shading and soft shadows. No page-flip code or new animation exists.
- White form card, local photo icon, and a native anchor action to #bms-preview-result. Preview still updates instantly through the unchanged existing JS; the anchor only brings the result into view.
- Existing Personalize CTA remains /make-your-magazine/, with 12-page PDF / US$39.99 outside the button. Privacy and illustrative-sample disclosure remain visible in the lower rail.
- Empty photo slots remain neutral, without substitute pictures or illustrated placeholder artwork. Selected/replaced/removed photos use the existing browser-local mechanism.
- Self-hosted unmodified Playfair Display v1.203 (OFL1.1) gives the reference's heavier editorial serif; its license is included. Existing Instrument Serif italic remains for the magazine quote. No proprietary/reference font was extracted.
- Desktop places controls, separate cover and open spread side by side. 375px uses controls → cover → spread → CTA; it does not squeeze the desktop composition.

## Evidence / bounded inspection

Start with [final-contact-sheet.jpg](final-contact-sheet.jpg), then full-resolution [confirm/](confirm/).

- before/: seven pre-write captures, including full homepage1440.
- after/: nine first-inspection captures.
- confirm/: nine **final-candidate** captures: empty and selected photo at2048/1440/375, full homepage1440, and no-JS1440/375.
- [image-manifest.json](image-manifest.json): dimensions, byte size, SHA256 and local absolute path of25 screenshots, the Owner reference and contact sheet.
- [runtime-boundary.json](runtime-boundary.json): exact source/mount identities, seven frozen files, pre/post WP state and four original rollback hashes.
- [delivery.json](delivery.json): separate ordinary cache-enabled Edge delivery, asset/font hashes, computed tokens, hover/focus and read-only route results.
- [ASSET_PROVENANCE.md](ASSET_PROVENANCE.md) / [asset-manifest.json](asset-manifest.json): generated background, official font/license sources and exact file identity.

The first inspection found a wrapped CTA arrow at1440 and a weak center fold. One concentrated finish batch kept the button on one line and refined the static paper fold. One final confirmation followed; no further visual redesign/polishing loop. The advisory screenshot audit is not formal Reviewer acceptance.

## Verified behavior / limits

Final2048/1440/375: document scrollWidth equals viewport; no broken visible image or photo/copy overlap. Name/age updates (Jordan42 → Taylor30), all three style selections, local photo selection/reselection/removal and the unchanged Personalize target passed. A30-character name was checked for headline-box overflow. New anchor navigation resolves to the real result ID. No-JS preserves static layout/text; the existing interactive Preview still requires JS.

The existing fictional project image preview-memories-panel.png was selected locally as the synthetic fixture. Both image elements received blob: URLs. The routed interaction harness aborts non-GET/HEAD, recorded zero attempts, zero external image requests and zero page errors. The final report and helper preserve these assertions. This routed harness disables cache, so cache correctness is proven separately: ordinary Edge without routing/cache clear/bypass loaded mtime-versioned CSS bytes matching source/mount; background and font GETs returned200 with matching SHA256, and the font was loaded.

Read-only GETs reached intake, Product, Cart and My Account with200. Empty Checkout redirected to Cart; this is not a populated-checkout test. No Add-to-Cart, checkout submission, payment/order mutation or provider query was performed. Existing accepted Woo/account/private-workspace evidence is reused, not replayed.

Frozen normalized source/runtime files: preview.js, frontend-reproduction.js/.php/.css, home.css, home-motion.js, studio.css. PHP outside the Preview shortcode and CSS before the homepage gift override are unchanged. All additions in shortcode output are conditional on is_front_page(); non-home markup is retained. Other homepage Group widths/heights/computed styles match before, apart from natural vertical position after the resized module.

Home content SHA256: 6d15fe64e152e3fce87bbab067eb04f2ab8828ea60954bb2898cf8b8bee28917. Theme-mods SHA256: 5d0a364f9ce5a62931432798c6684f2105802a54650f4bfe237e0826547d1f38. Both unchanged. Owner edit permission and Gutenberg=true. Orders1, jobs0, product model calls0, unchanged.

Dependencies reused: Node24.19.0, Playwright1.62.1, Edge154.0.4258.53, bundled Pillow for evidence composition. No package install/purchase, API key or secret. Design-time image generation=1; **FREE_PREVIEW_MODEL_CALLS=0**, server photo uploads=0, external image posts=0.

## Runtime / rollback / cleanup

Exact candidate is retained in unchanged running container birthday-magazine-g3c-wordpress-1 (ID21892d72baebe6157fbeab15ad6a1e3949cf4663ca55b45360c3f4eb1f052f00). Site: http://127.0.0.1:8189/#preview; admin: http://127.0.0.1:8189/wp-admin/. No Docker build/pull/restart/recreate/teardown/prune.

Ignored local rollback: poc/g3c/.tmp/preview-gift-20261005/. Source/runtime copies of the two changed files retain original hashes/mtimes; all four hashes verified. No WP content/settings rollback is necessary because none changed. Rollback was not applied.

For a future authorized rollback, first guard current source/runtime against this candidate's recorded hashes and stop on drift. Restore only magazine-preview.css and birthday-magazine-poc.php from their source/runtime role copies, preserving original mtimes. Remove only the new assets/preview-gift-20261005 directory after resolving/guarding its exact project/runtime paths and ruling out reparse points. If local backup is unavailable, Git baseline supplies source files. Never reset Home/database/volumes.

The temporary canonical governance clone is removed after reading; the rollback and original generated image are intentionally retained locally. No broad cleanup. The pre-existing unrelated untracked g3cr7v2r1.zip is excluded from submission.

Forbidden actions: Add-to-Cart, checkout submission, order/payment mutation, PayPal, real money, product model/provider, production deployment, Shared Infra, Docker lifecycle/global prune, G4 and PR merge all0. No real customer data. OWNER_VISUAL_FREEZE=PENDING.
