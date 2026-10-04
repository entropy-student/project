# R2 — targeted visual polish evidence

Gate: `G3CR6R3D2R2_VISUAL_POLISH`. Executor candidate only; formal visual acceptance and Owner freeze remain with Reviewer/Owner.

## Actual changes

- Home858: exactly five image blocks replaced. All other Gutenberg content is byte-identical to the accepted D2 Home; eight top-level Groups and six anchors preserved.
- Samples: three original, full-bleed compositions (terracotta Eli cover, cobalt/yellow open spread, Lena receiving a gift), desktop1280×853 and mobile343×229. The old padded cover mat is removed. Existing perspective controller is byte-identical.
- Preview **outer** photographic panel: two fictional friends sharing memories. Offer: fictional father/daughter birthday scene. Hero, introduction, how-to and closing keep their accepted original imagery/direction.
- 375px header:343px shell,22px serif brand,44px native trigger,84.55px measured brand-to-trigger gap. Stored menu URLs and native offcanvas remain unchanged.
- Mobile nonfunctional spacing reduced; final height7866px versus accepted D2 capture7959px. The two photographic panels bottom-align their text; Preview560px, Offer650px. Offer's320px upper photograph reveals faces above the text card, with a warm backing below. No factual copy, FAQ, offer or Preview content removed.
- Five built-in imagegen calls, all five adopted, zero rejected. These are static marketing images, entirely fictional people, not real customers, customer output, runtime Preview generation or P1–P12 changes. Full prompts, section/replacement purpose, tool paths, adopted paths, dimensions, bytes and hashes: [generated-asset-provenance.json](generated-asset-provenance.json).

## Reproducible evidence

- `runtime-before.json` / `runtime-after.json`: WP7.1.1, Blocksy2.1.57, Woo11.1.2, default page.php, editable Home, Owner administrator/media/global style, Product1113 virtual USD39.99, menus/footer/theme/active plugins/protected source correlation, orders1→1 and jobs/model0.
- `home-final.json` and `apply-result.json`: actual Home body and five image replacements.
- `round1/browser.json`: first batched inspection; round1 PNGs remain local working evidence.
- `round2/browser.json` and `round2/screenshots/`: final eight contexts, desktop1440×1000/mobile375×812 × normal/reduced/no-JS/motion-controller-unavailable. Required full/sections, all three cards and three perspective states, menu/hover/focus, native routes.
- `qa-report.json`: machine assertions from `scripts/verify-g3cr6r3d2r2.cjs`. No overflow, missing images, page errors or failed HTTP resources; visible fallback content; motion/card matrices and native menu open/Escape captured.
- `resources-before.json` / `resources-after.json` and `resource-readback.json`: same container IDs/state/start times/mounts/ports, volumes and networks, including unrelated projects. Readback initially flagged differing Docker mount-list ordering; sorting by destination hash removed that harness-only false positive. No runtime start/rebuild/pull/recreate/prune/teardown.
- `DESIGN.md`: current R2 display contract; historical D2 documentation retained.

## Frozen boundaries and limits

`preview.js`, `magazine-preview.css`, Preview PHP, workspace plugin, Woo core, motion controller, menus, footer/theme mods, price/product identity and all non-image Home content are unchanged. Preview geometry/type remain1120px desktop/335px mobile.

No photo selection/replacement/removal replay. Accepted local-photo privacy evidence is reused with byte and geometry correlation, **not represented as a new uploaded-photo network proof**. Browser automation blocks non-GET/HEAD, add-to-cart queries and PayPal hosts; attempted blocked business requests0. No Add to Cart, Checkout submission, order/account login, payment/provider or product-model action.

Product, empty Cart and My Account return200. GET Checkout follows native empty-cart redirect to Cart200; this is not a fresh populated Checkout form test. Account/private-workspace authorization proof is retained from accepted baseline with source/capability correlation, not newly exercised authenticated accounts.

Configured Privacy Policy remains draft, so the previously empty footer link remains an acknowledged deferred issue. No legal content or guessed URL created.

## Rollback / retained runtime

`poc/g3c/artifacts/backups/g3cr6r3d2r2/` snapshots accepted D2 Home and exact CSS/JS/PHP bytes before mutation, menus and new-asset previous absence. `.gitattributes` preserves backup bytes. `rollback-proof.json` records hash validation and dry-run only.

`node birthday-magazine-studio/poc/g3c/scripts/rollback-g3cr6r3d2r2.cjs --apply` is a guarded local restore to **accepted D2**, not pre-D2. It restores Home858/source files only; five newly generated static files become inert/unreferenced. No DB/media/order deletion. Actual restore not executed.

Site retained: http://127.0.0.1:8189/ ; admin: http://127.0.0.1:8189/wp-admin/ . Browser contexts closed after capture; no sessions exported.

## Owner visual relay

Upload **`reviewer-visual-contact-sheet-r2.jpg`** directly to the current ChatGPT conversation. This compares34 existing/final frames, without revisiting Focusly or using any of its paid assets on the site. `reviewer-visual-contact-sheet-r2-manifest.json` records source/output dimensions, bytes, hashes and absolute local paths. No ZIP, data URI or Base64 visual bundle.

Same branch and PR64, no merge. All pre-existing Owner archives, unrelated untracked evidence and17 historical PNG deletions are excluded. Submission commit identity is the enclosing Git commit, read back on PR64 after push; no self-referential SHA embedded in its own file.

`STOP_AT_REVIEWER=YES`; `OWNER_VISUAL_FREEZE=PENDING`; no next Gate.
