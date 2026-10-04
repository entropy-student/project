# R4 — Hero travel expansion

**Executor PASS_CANDIDATE; Reviewer / Owner visual confirmation pending.** Owner accepted the previous dual-image Hero and requested only a less restricted desktop window. The approved plan permits passage underneath navigation and copy, with a readability gradient; mobile stays fixed. This supersedes only the previous navigation/copy avoidance boundary.

## Narrow implementation

- Only `home-motion.js` / `home.css` application changes:9/7 JS additions/deletions and2 CSS additions. Home858 database content, Header/menu, assets, Preview and business logic unchanged.
- Desktop bounds are Hero edges,24px inset.1440×1000 measurements: window720×420; horizontal−336…336px, vertical−121…411px. Pointer follows through the separate Header. Leaving the Hero visual field or browser recentres the window with the existing easing.
- Layers: clear scene0, frame1, noninteractive copy gradient2, copy/caption3; native Header20. The window can pass behind copy and navigation. Native links remain the hit-test targets and keyboard focus is visible.
- Readability gradient only for desktop enhanced Hero: transparent52%, ink70% at64%,85% at100%. Conservative white-background alpha-composite checks exceed3:1 for large heading and4.5:1 for body. First inspection found the gradient too heavy; one opacity adjustment preceded final confirmation.
- Existing two images, scene coordinate pairing,20s cycle, blur/zoom/crossfade, clear holds, easing and offscreen pause unchanged. Mobile retains327×276 fixed window /480px photographic field. Reduced/no-JS static fallback unchanged. Imagegen0.

## Evidence

- [Owner-approved scope](DESIGN.md)
- [62 automated checks](qa-report.json) / [eight final browser contexts](round2/browser.json)
- [55 PNG source captures](screenshot-manifest.json), local/ignored / [55 committed full-size JPGs](durable-screenshot-manifest.json)
- [Screenshots](screenshots/): desktop-normal-pointer-top/header/bottom, cta-focus, pointer-return, mobile default, and fallback frames.
- [Source diff](source-diff.patch) / [protected source and asset correlation](source-correlation.json)
- [152 unchanged non-Hero CSS rules](non-hero-css-projection.json); non-Hero controller exact.
- [Runtime before](runtime-before.json) / [after](runtime-after.json) / [resource comparison](resource-readback.json)
- [Rollback proof](rollback-proof.json) / [internal advisory](internal-finish-review.md), not a formal Reviewer decision.

Round1 desktop/mobile inspection, one desktop shade-opacity repair, one round2 final confirmation. No further polish loop. Timed A→B→A was observed without seeking clocks. All1440×1000 /375×812 normal/reduced/no-JS/missing-controller contexts have no horizontal overflow, broken images, browser errors or failed HTTP resources. Header/CTA hit-testing, focus, native mobile menu and live reduced-motion remain usable.

## Frozen state and limits

Home858 SHA256 `7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a`, eight editable Groups/six anchors; media, theme mods, footer, menu and protected Preview/Woo/workspace hashes unchanged. All five R2 images unchanged. Owner Administrator/Gutenberg/media/global-style capabilities retained. No new photo-network or authenticated-workspace test is claimed; accepted evidence correlated.

GET-only Product1113 virtual USD39.99, empty Cart/Account200; empty Checkout redirects to Cart200. This is not populated checkout proof. Orders1→1, jobs/model0. No cart/order/account/payment/provider action. Still frames and headless measurements do not prove physical-device frame rate or Owner visual approval. The lens is intentionally dimmed when passing behind text; it reveals the local scene crop rather than always the whole magazine cover.

## Rollback / submission

Baseline `022ad6de2d64237ad6669c5c4a29e6eef11cea79`; canonical main `301eda93ee91bef860341ec280e95f39f97cbcf7` contains no Birthday project authority drift. Same branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`, PR64 open/unmerged. The enclosing execution/evidence commit is submission identity, read back after push. Prior Owner artifacts/deletions excluded; no Reviewer decision edit.

Pre-write byte-exact backup at `poc/g3c/artifacts/backups/g3cr6r3d2r4-hero-range/`. Dry source-copy/read-back PASS; no live rollback. If authorized, from repo run `node birthday-magazine-studio/poc/g3c/scripts/rollback-g3cr6r3d2r4-hero-range.cjs --apply`; this restores only the two application files to022ad6d. Historical Hero-focus and earlier backups retained.

Project and unrelated Docker identities/state/start/mounts/ports, volume names and networks unchanged. No start/build/pull/recreate/prune/teardown. Runtime retained: http://127.0.0.1:8189/ ; http://127.0.0.1:8189/wp-admin/ . Credentials omitted.

Imagegen, Preview/product/provider model calls, PayPal, real money, AddCart, Checkout submission, production/shared-infra, P1–P12/Aha/G4, merge and global prune0. Owner: Ctrl+F5, move cursor through the Header and down across the title to compare travel. `OWNER_VISUAL_FREEZE=PENDING`; `STOP_AT_REVIEWER=YES`.
