# Owner-approved Preview materials, styles and scoped frontend finish

2026-10-06 — **Executor PASS_CANDIDATE; Reviewer / Owner visual freeze PENDING. STOP_AT_REVIEWER=YES.** Bounded continuation of R4 under explicit Owner approval, not a new formally opened Gate. Latest Owner excludes WooCommerce frontend work. Preserve prior Gate decisions.

## Start here

- [Final before/after contact sheet](final-contact-sheet.jpg):2200×4800,1,218,283bytes; desktop, three styles, How, mobile, intake and no-JS.
- **[edge-final/](edge-final/)**:33 final PNGs. This is the exact mounted candidate, superseding scale-final/ after Owner identified the right photo touching the stacked page edges.
- [runtime-boundary.json](runtime-boundary.json): exact source/mount correlation, eight original backup hashes, frozen business files and Home/theme state.
- [delivery.json](delivery.json): ordinary-cache Edge loads exact final CSS/assets/font hashes, with no routing, cache clear or bypass.
- [Image manifest](image-manifest.json), [asset manifest](asset-manifest.json), [asset provenance](ASSET_PROVENANCE.md).
- [Committed Git read-back](git-readback.json):all156image blobs/six assets/four source files verified. Binary images/fonts are byte-exact; text files are equivalent after repository CRLF/LF normalization. No global Git setting change. The unmodified upstream Manrope license retains its original trailing space; this is the sole staged diff-check warning, not an application whitespace defect.

## Authority / baseline

Canonical governance main8185b7dc13221338f3dc34f73f3b0359d6697fd2, v0.2.7. Project main freshly fetchedb13901de9f696aee73422a860f692b6f29ddc56c; no Birthday Magazine path drift from prior main. Baseline / pre-write rollback / PR head66b0cf0088d60e77469513ac6ed36ab7b8a9b5f5. Same remote branch codex/birthday-magazine-g3c-blocksy-wedding-productization / PR64; local branch is an existing alias. No new PR/merge/next Gate.

## Changes

1. Physical blank photographic cover/open-spread assets replace flat CSS-only paper: real page layers, light curls, center crease and soft contact shadows. Live HTML text and browser-local photos remain separate. No real page flipping.
2. The style (formerly The mood) now switches genuinely distinct typography, title case/weight, frame shape and print rules: Soft & Warm / Bold Editorial / Retro & Playful, one shared DOM and unchanged JS.
3. How's original Alex photograph stands alone: tan rounded backing board/padding removed, image width and text column rebalanced. No new Alex image, copy or motion change.
4. Intake only: readable Review answer text/labels and boundary/optional-summary copy; Age/Birthday desktop inputs aligned. Other intake composition/logic preserved.
5. Owner's later scale steering: larger desktop paper pair, smaller form-to-stage gap and right gutter; larger cover cap and taller spread ratio. Mobile layout stays as previously repaired. Only homepage home.css enqueue now uses filemtime for ordinary cache freshness; Preview/intake already had mtime versions.
6. Owner's photo-edge steering: right-page photo moved down/inward with more outside/top margin. Empty and selected frames stay within documented front-paper safe bounds, excluding stacked outer pages; overall showcase size retained.

Design-time imagegen **2** calls, two adopted blank static assets; product/Free Preview model calls **0**. New free unmodified OFL1.1 Manrope4.505 and DM Serif Display5.200 self-hosted with licenses. Existing background, Playfair1.203 and fictional browser photo reused. The presets are illustrative preview treatments; no production PDF architecture claim.

## Verification / chronology

- before/:28 PNGs. First collection failed on a full-page collector's null root; helper corrected before UI edits. No website failure/state change caused by that tool bug.
- after/:28 first inspection PNGs. Actual mobile spread copy extended below paper and Retro photo border did not clip; one CSS repair batch fixed both.
- confirm/:33 passing PNGs, including no-JS. Independent advisory of eight images found no P1/P2 blocker, not formal Reviewer acceptance.
- Owner then requested greater desktop presence. scale-final/:33 passing final PNGs, all three styles at1440/375,2048/1440/375 empty/local-photo/How and five intake steps plus1440/375 no-JS. One rejected phase-name invocation was a collector argument guard; it made no browser request and was corrected.
- Owner then identified photo/frame pressure on the outer page layers. edge-final/:33 passing current PNGs; right frame occupies x≈55–91% of spread and y≈12–14% at its top. A geometric safe-region assertion verifies it stays within the front paper; empty/selected mobile and desktop inspected. Final advisory review of three current images finds no P1/P2 blocker, not formal Reviewer acceptance. All earlier rounds remain historical, not current acceptance claims.
- Final no horizontal overflow, visible broken image, page error or image/copy overlap. Story page scrollHeight≤clientHeight for all three styles. Photo select/reselect/remove stays blob-local; request-routed browser records0non-GET attempts /0external image requests. Name/age update, Next/Back retention, minimum-photo guard,12local photos/3must-use/fourth-disabled and6answers pass. No checkout handoff click or server save.
- Ordinary-cache Edge154.0.4258.53 independently verifies3stylesheet/4newasset HTTP200 and response/source hashes; three font profiles loaded, visible focus and aligned factual controls. No browser cache bypass in this delivery proof. One2048 image request was navigation-aborted; all final visible images are complete, and this is not reported as a missing image or upload.
- No-JS marketing/layout stays readable. Live preview/intake interactions still require JavaScript; not claimed to function without it.
- Node24.19.0 / Playwright1.62.1 / bundled Pillow reused; no install. PHP syntax passes.
- One Impeccable detector pass flags inherited Inter/side-tab/layout-transition declarations in unchanged legacy rules. These are documented existing narrow-scope exceptions; no broad redesign/refactor. New physical assets and fonts align with Owner-pinned reference.

## Frozen boundaries / retained runtime

Home858 Gutenberg content and theme-mods hashes unchanged; existing Owner edit capability and Gutenberg true. Orders1→1, canonical generation jobs0→0, product model calls0→0. Five protected source/runtime files unchanged: preview.js, frontend-reproduction.js/.php, home-motion.js,studio.css. Stripping only home CSS version + style display label exactly reproduces baseline PHP. Woo CSS (studio.css), canonical product1113/add_to_cart/checkout handoff, account/workspace/entitlement/order/payment logic unchanged. No Woo frontend route or payment regression replay; previous accepted evidence reused by source correlation.

Exact source copied only to the existing scoped bind mount; four-file/new-asset hashes match. Same container ID remains running. Runtime identity: birthday-magazine-g3c-wordpress-1; no Docker lifecycle/global cleanup/tunnel/deployment/shared-infra operation. No WP database/content/settings write.

Before submission, main advanced again through unrelated monorepo changes; fresh fetch confirmed no Birthday Magazine path changes and remote PR head still66b0cf00. Current main SHA is recorded in Execution Evidence/Handoff.

Local review: http://127.0.0.1:8189/#preview and http://127.0.0.1:8189/make-your-magazine/ . Admin /wp-admin/. Runtime retained, no rollback/teardown.

Ignored project-local rollback: poc/g3c/.tmp/preview-materials-20261006/, four source + four actual-mount originals with exact hash/mtime manifest. Stop on drift; restore only those files from role-specific copies and mtimes, then remove new asset references/files only if no dependency. No restore performed. Canonical temporary checkout and collector scratch are project-isolated; cleanup disposition in temp-cleanup.json. Pre-existing Owner ZIP is excluded.

## Action counts

Free Preview model / server photo uploads / external photo POSTs=0. Add-to-Cart, checkout submission, order mutation, PayPal, real money, production AI/provider, deployment, Shared Infra, Docker lifecycle/global prune, paid purchase, G4 and PR merge=0. Design-time imagegen=2, separately disclosed. OWNER_VISUAL_FREEZE=PENDING. Formal Reviewer decides acceptance.
