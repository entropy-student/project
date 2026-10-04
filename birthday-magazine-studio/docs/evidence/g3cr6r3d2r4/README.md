# R4 motion execution evidence — 2026-10-04

**GATE=G3CR6R3D2R4_MOTION_POLISH**

**RESULT=PASS_CANDIDATE_G3CR6R3D2R4_MOTION_POLISH**

**OWNER_LIVE_MOTION_PERCEPTIBILITY=PENDING; STOP_AT_REVIEWER=YES**

## Authority and actual changes

PR64 remains on `codex/birthday-magazine-g3c-blocksy-wedding-productization`, starting from approved head `69b062be391a5b975aeef844378aa53f46fa6e47`. Fetched main `947e119f568f520b09e5b5a5affc57e339e1a463`; the Gate, Reviewer Handoff and diagnostic decision are blob-identical on both refs, recorded in [preflight.json](preflight.json). The accepted R2 visual execution is `8d03464dbf1678468a289e4676ba975745bcb94d`. No new template research, Focusly visit or proprietary asset acquisition occurred; only accepted D1 section3 motion observations were reused.

Only `preview-plugin/home.css` and `home-motion.js` change application behavior. Static Home858 content, imagery, factual copy, menus, footer, fonts, Preview internals and commerce remain frozen. No persistent WordPress write or presentation block migration was necessary. The desktop Closing uses a temporary JavaScript presentation wrapper around its existing children, removed on mobile/reduced motion; Owner's Gutenberg content remains byte-identical.

- Hero: visible 14-second photographic focus/scale/pan cycle; headline/CTA stay outside the loop. It pauses offscreen and when the tab is hidden.
- Editorial splits: image scale/Y progression on entry, flat/readable middle, bounded exit; paired copy settling.
- Desktop photo panels: background Y parallax within 220px vertical overscan, keeping foreground stationary and horizontal crop intact. Mobile is static, including accepted Offer320px crop.
- Samples: three full-bleed cards progress through tilt/scale/Y/depth states. Layout geometry is read before variable writes, avoiding transformed-rectangle feedback. No scroll interception.
- Closing: desktop190svh region with100svh sticky inner composition, progressively white/dim text and drifting images; CTA remains in place. Mobile retains compact ordinary flow.

See [DESIGN.md](DESIGN.md) for exact source-defined amplitudes and timing. No new dependency or image generation.

## Verification and visual evidence

[qa-report.json](qa-report.json) is the final automated result, not formal Reviewer/Owner acceptance. [round2/browser.json](round2/browser.json) records eight1440×1000/375×812 contexts: normal, reduced motion, no-JS, missing controller. [round1/browser.json](round1/browser.json) is retained as pre-fix history; do not review its narrower Closing container as final.

The single fix batch resolved the sticky wrapper's inherited Gutenberg width restriction and replaced horizontal Panel enlargement with vertical overscan. Final checks prove:

- Hero three timed states have different computed blur/scale/pan; all copy/CTA stays readable.
- Both split sections and both photo panels have three scroll measurements/screenshots. Desktop Panel measured Y travel is approximately132px across sampled positions.
- Every sample has enter/mid/exit screenshots and transforms: about+14.39°/0°/−14.39°, projected width about1117→1280→1117px on desktop. Middle scale is effectively1.
- Closing inner y=0 across scroll8588/8993/9398; full1440px width; reveal14.5/55/95.5%; CTA stays inside viewport.
- 375px document and sampled states remain375px wide, no projected card overflow, no sticky trap. Native menu opens/closes with Escape; hover and keyboard focus work.
- Reduced/no-JS/missing-controller content remains visible/static. Live reduced-motion preference changes remove/recreate desktop sticky safely. No page errors, failed HTTP resources or broken images in captured runs.

**97 final screenshots** are committed under [screenshots/](screenshots/), at original dimensions, JPEG quality90/4:4:4 with no resizing/cropping. [durable-screenshot-manifest.json](durable-screenshot-manifest.json) records sizes, SHA256 and original PNG correlation. Full PNG originals remain locally in ignored `round2/screenshots/`; [screenshot-manifest.json](screenshot-manifest.json) records their hashes. This avoids adding87MB of duplicate PNG evidence. This is encoding of existing captures, not another screenshot pass or generated imagery.

Useful comparisons: `desktop-normal-hero-0/1/2.jpg`; `desktop-normal-what-you-get-enter/mid/exit.jpg`; `desktop-normal-preview-panel-enter/mid/exit.jpg`; `desktop-normal-sample-1/2/3-enter/mid/exit.jpg`; `desktop-normal-closing-early/mid/late.jpg`; corresponding mobile files and fallback full/closing captures.

## Frozen behavior and proof limits

[runtime-before.json](runtime-before.json) and [runtime-after.json](runtime-after.json) are identical: Home SHA256 `7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a`, eight Gutenberg Groups, six anchors, administrator edit/media/global-style capabilities; Blocksy2.1.57/WP7.1.1/Woo11.1.2; Product1113 virtual USD39.99; orders1→1; generation jobs0; product model calls0. Five adopted R2 asset hashes are rechecked against accepted provenance.

Preview PHP/JS/CSS and private-workspace/Woo source hashes remain unchanged. Default Preview width stays1120px desktop/335px mobile. This reuses accepted privacy/permission proof with fresh source/geometry correlation; **no photo interaction, permission replay or new photo-network experiment** was performed. Free Preview model calls/server photo uploads/external image POST remain0 under that unchanged boundary.

Product, Cart, Checkout and Account are read-only native GET paths. Product shows$39.99, Cart is empty, Account login form exists; empty-cart Checkout redirects to Cart200. This does not claim a populated checkout form or payment test. The homepage controller is absent on Woo routes. All non-GET/HEAD, add-to-cart and PayPal requests are blocked by the capture harness; none were attempted.

Add-to-Cart, checkout submission, new order, PayPal, real money, product model/provider, imagegen, production, shared infrastructure, P1–P12, core Aha, G4 and merge actions are all0.

## Rollback, storage and retained runtime

Pre-write backup: `poc/g3c/artifacts/backups/g3cr6r3d2r4/`, saving accepted R2 Home plus exact CSS/JS/PHP bytes and menu projection. [rollback-proof.json](rollback-proof.json) verifies backup hashes and an isolated byte-exact copy/read-back. Live rollback was not executed. `node birthday-magazine-studio/poc/g3c/scripts/rollback-g3cr6r3d2r4.cjs --apply` restores only accepted R2 `home.css` and `home-motion.js`; no Home/menu/asset/DB write is needed. It does not restore pre-D2.

[resources-before.json](resources-before.json), [resources-after.json](resources-after.json), [resource-readback.json](resource-readback.json) show unchanged project/unrelated Docker metadata. No build/pull/start/recreate/teardown/prune or tunnel action. Temporary rollback copy directory was removed; originals/evidence/backups are project-local. Pre-existing screenshot deletions/Owner archives/untracked older artifacts are excluded from this submission. No auth headers, cookies, tokens, passwords, credentials or customer data were exported.

**Runtime retained:** http://127.0.0.1:8189/ ; admin http://127.0.0.1:8189/wp-admin/ . Refresh the local page (Ctrl+F5 if an older browser cache persists), wait several seconds at Hero, then scroll normally through split/photo sections, Samples and desktop Closing. Owner must confirm perceptibility in the actual browser before formal motion PASS.

## Reproduction

Existing local Node24.19.0, Playwright Core1.62.1 and Microsoft Edge154.0.4258.53; no dependency install. Screenshot encoding uses existing Pillow12.3.0. `capture-g3cr6r3d2r4.cjs <round>` captures the controlled GET-only contexts. `readback-g3cr6r3d2r4.cjs after` checks retained state; `verify-g3cr6r3d2r4.cjs round2` validates evidence and frozen hashes; `package-motion-evidence-g3cr6r3d2r4.py` encodes existing final captures. Do not rerun the guarded pre-write backup or expand into payment/Preview testing.
