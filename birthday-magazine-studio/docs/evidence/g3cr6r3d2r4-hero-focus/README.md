# R4 — Owner-approved Hero focus window

**Executor PASS_CANDIDATE; formal Reviewer / Owner visual confirmation PENDING.** This iteration supersedes only the previous same-image Hero crop loop. The other Owner-video motion work remains intact.

Owner identified two photographic states and a cursor-following transparent window in the phone video, accepted the Hero-only plan, then explicitly authorized implementation. This latest instruction authorizes this narrow change despite the earlier Reviewer wait-for-Owner clause. No Reviewer decision was edited.

## What changed

- Only `poc/g3c/preview-plugin/home.css` and `home-motion.js` application files changed. Home858 content, Gutenberg blocks, navigation, theme settings, media and PHP remain unchanged.
- Existing Mira gift image and Lena gift image alternate. Both are owned fictional/sample marketing assets, not customer photos. No new image generation or image replacement.
- The blurred background and clipped clear scene use matching dimensions, crop, object-position, scale, opacity and animation clock. Pointer movement moves the **window**, revealing corresponding scene pixels.
- Desktop:720×420 window, horizontal range±180px; measured vertical range−55…52px. Eased pointer following, bounded above copy, leave returns to centre. Title, copy and CTA remain fixed.
- A20-second cycle: Mira clear8s →2s defocus/zoom/crossfade → Lena clear8s →2s transition back. Clear-window blur0px during holds,12px transition peak; zoom1.08 peak. Background10–20px blur.
- Mobile375:327×276 fixed window over a480px photographic field;6px transition peak,1.035 zoom,8–14px background blur. It does not require pointer interaction. A fade into the existing dark copy area preserves readability.
- Reduced-motion uses the original static Hero; no JS or missing controller leaves original images/copy/CTA readable. Loops pause offscreen or when hidden. No continuous idle pointer frame loop.

## Evidence

- [Confirmed direction](DESIGN.md)
- [60 machine checks](qa-report.json)
- [Final eight browser contexts](round2/browser.json)
- [Corrected offline non-Hero CSS comparison](non-hero-css-projection.json):152 unchanged style rules. The earlier four-rule browser projection skipped CSSStyleRule declarations; it is superseded by this complete comparison.
- [PNG manifest](screenshot-manifest.json) / [51 committed full-size JPGs](durable-screenshot-manifest.json) / [screenshots](screenshots/)
- [Source diff](source-diff.patch) / [source and asset correlation](source-correlation.json)
- [Before](runtime-before.json) / [after](runtime-after.json) / [Docker comparison](resource-readback.json)
- [Rollback integrity](rollback-proof.json)
- [Internal advisory finish review](internal-finish-review.md), not an official Reviewer decision.

Key frames: `desktop-normal-hero-default.jpg`, `desktop-normal-pointer-left.jpg`, `desktop-normal-pointer-right.jpg`, `desktop-normal-a-to-b.jpg`, `desktop-normal-b-clear.jpg`, `mobile-normal-hero-default.jpg`, `mobile-normal-b-clear.jpg`, plus reduced/no-JS frames. Timed measurements were observed without seeking animation clocks. Still screenshots cannot convey the complete movement.

## Checks and limits

Round1 desktop/mobile inspection and one round2 confirmation; no application repair batch after inspection. Initial capture helper stopped on a duplicate brand selector, then used the visible device-specific selector. Offline CSS parsing was corrected after round2 without another site visit or UI change. All diagnostics are retained rather than relabeled.

1440×1000 and375×812 × normal/reduced/no-JS/missing-controller: no document overflow, broken images, page errors or failed HTTP resources. Clear A→B→A, transition blur/zoom, matching paired scenes/clocks, pointer return, stationary CTA, keyboard focus, mobile menu and live reduced-motion were checked.

Home SHA256 remains `7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a`: eight editable Gutenberg Groups / six anchors. Non-Hero controller section byte-identical,152 CSS rules unchanged, all five R2 assets unchanged. Preview default widths1120/335 and its PHP/JS/CSS hashes unchanged. No new upload/replace/remove or authenticated-workspace test is claimed; prior accepted proof is correlated.

Product1113 remains virtual USD39.99. GET-only Product/empty Cart/Account200; Checkout follows native empty-cart redirect to Cart200, **not** populated checkout verification. No cart/order/account/payment mutation. Orders1→1, generation jobs0, product model calls0. Headless Edge154 measurements are not physical-device frame-rate or Owner visual acceptance.

## Rollback and handoff

Pre-write byte-exact Home/CSS/JS/PHP backup: `poc/g3c/artifacts/backups/g3cr6r3d2r4-hero-focus/`. Dry copy/read-back PASS; live rollback not executed. If rollback is authorized, run `node birthday-magazine-studio/poc/g3c/scripts/rollback-g3cr6r3d2r4-hero-focus.cjs --apply` from the repository. It restores only the two changed application files to198aed6; no DB/media/menu/business operation.

Baseline198aed658fb59ebecffa596e37e143892d2d763b; canonical main4caed9bb0dbf069d5407b261fe66740794c7676a project authority unchanged. Same branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`, existing PR64 open/unmerged. The enclosing execution/evidence commit is the submitted identity, read back after push; earlier commits and history remain intact.

Docker project/unrelated container identity/state/start/mount/port, volumes and networks unchanged. No start/build/pull/recreate/prune/teardown. Runtime retained: http://127.0.0.1:8189/ ; admin http://127.0.0.1:8189/wp-admin/ . Owner Administrator/Gutenberg/media/global-style capabilities retained. Credentials omitted.

Imagegen, Preview/product/provider model calls, PayPal, real money, AddCart, Checkout submit, production/shared-infra, P1–P12/core Aha/G4, merge and global prune actions0. Prior Owner deletions/archives/untracked evidence excluded.

Owner: Ctrl+F5, move the pointer within Hero, then wait10–12 seconds to see the other image. Reviewer: inspect the Hero-only diff, paired coordinates, timed evidence and frozen boundaries. `OWNER_VISUAL_FREEZE=PENDING`; `STOP_AT_REVIEWER=YES`.
