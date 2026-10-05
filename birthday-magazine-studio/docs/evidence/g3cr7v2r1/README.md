# G3CR7V2R1 — Stripe Visual Continuation

**Executor result:** `PASS_CANDIDATE_G3CR7V2R1_STRIPE_VISUAL_CONTINUATION` · `STOP_AT_REVIEWER=YES`
**Runtime:** `http://127.0.0.1:8189/` (kept running; same container ID and start time)
**PR:** #64, existing source branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`, open/unmerged.

## Authority and payment-truth reuse

The Gate, Reviewer overrule, Owner Stripe style lock, `PROJECT_ADAPTER.md`, `DESIGN.md` and `SOURCE.md` were read from freshly fetched `origin/main=af53ff7434f22db6408d663111c396dab3c42f39`. Before submission, `main` was fetched again at `0a6c384ba0ea32ad4e3064cff1653ca63b319d4f`; no `birthday-magazine-studio/` paths changed since the first read. The vendored design reference remains pinned to Git blob `589bd23baeb1344444f087043c060afd6239371f`. The false-positive preflight RETURN was overruled because order #1131 had no proven access context and the three candidate source blobs still match the accepted G3CR7R1R2 implementation. See [`runtime-preflight.json`](runtime-preflight.json) and [`design-token-map.md`](design-token-map.md).

The candidate checkout has these exact frozen blobs:

- `frontend-reproduction.php` — `db3af21e56fe2683b20020ae25cda0fbf6a8f5a1`
- `frontend-reproduction.js` — `cbd67a7dc0897e87e4c7bc4edb017a1e138d2e6a`
- `birthday-magazine-poc.php` — `0aa39e131b7958652bc0cfbd4ada7a4621fb3caf`

G3CR7R1R2 payment/order truth was reused. No order was created, no order/payment was replayed, and no checkout was submitted.

## Scoped visual changes

Only `poc/g3c/preview-plugin/magazine-preview.css` and `frontend-reproduction.css` changed. A new original abstract local mesh, `poc/g3c/preview-plugin/assets/g3cr7v2r1-soft-mesh.svg`, sits behind the Home Preview introduction. It is not copied from Stripe and contains no figure or logo. No image-generation call was made.

The Home Preview now uses a cool soft canvas, local atmospheric mesh, white controls/stage/CTA surfaces, indigo actions and a deliberate single-column 375px composition. The existing magazine cover/spread remains ivory/editorial. Intake and status use compact sans-serif product UI, white work/status panels, thin borders, restrained shadows, 6px fields, a clear stepper and indigo state/CTA accents. No PHP, JS, Gutenberg, database, product, order, account, entitlement, payment or generation behavior was changed.

## Browser evidence

The after set contains 14 PNGs and the final [`contact-sheet.jpg`](contact-sheet.jpg). Full-resolution images and byte hashes are in [`screenshot-manifest.json`](screenshot-manifest.json). The 14 accepted G3CR7V2 before screenshots were reused from `docs/evidence/g3cr7v2/before/`; they were not recaptured.

[`after/browser-smoke.json`](after/browser-smoke.json) records Microsoft Edge `154.0.4258.53` driven by Playwright on Node `v24.19.0` at 1440×1000 and 375×812:

- Home Preview default and selected-photo views captured at both widths. Name/age/photo updated; two preview image nodes used the same browser `blob:` URL. The selected-photo interaction produced zero non-GET requests, zero external image requests and zero model requests. The browser did fetch the site's pre-existing Lato font stylesheet/font from Google Fonts by GET; this Gate added no font request or external image asset.
- Intake About, Photos and Review captured at both widths. Twelve neutral geometric PNG fixtures stayed local (`blob:`/`data:`), one must-use selection worked, and Next → Back → Review worked. The flow stopped on Review before its WooCommerce CTA.
- Status generating fixture and the ready timeline row captured at both widths. These are explicitly local visual fixtures, not orders or generation jobs.
- `scrollWidth == innerWidth` at 1440 and 375 for all three surfaces; Preview and photo-grid internal overflow checks also passed. No broken images, failed requests, HTTP resource errors or page errors were observed.
- Woo's published checkout permalink remains `/checkout/`. A read-only GET with an empty cart redirected to `/cart/` (HTTP 200 final response); no checkout action was submitted.

No actual order-received page screenshot was attempted: this run had no validated access context, and the Gate prohibits replaying payment truth to create one. The accepted G3CR7R1R2 order-received evidence remains the payment-truth authority.

## Runtime read-back and limitation

[`runtime-final-readback.json`](runtime-final-readback.json) confirms the root page returns HTTP 200, the original WordPress container ID/start time are unchanged, and the mounted CSS + SVG SHA256 values exactly match the reviewed source candidate. The exact same visual candidate remains mounted after screenshot capture.

The separate active `g3cr2` worktree already had a dirty `birthday-magazine-poc.php` before this run; its runtime Git blob is `57b27b433dd764bdbb115809904bb7e426edff55`, rather than candidate blob `0aa39e131b7958652bc0cfbd4ada7a4621fb3caf`. This pre-existing PHP file was not read for behavior, changed, overwritten or committed. The three clean-candidate source blobs above match the accepted values. Only presentation CSS/SVG was copied to that already-running bind mount. Reviewer should consider this runtime-worktree discrepancy when assessing the live preview.

## Rollback

In the clean candidate checkout, restore the two CSS files from source commit `806907177ba48ef2ed11310e36f4cca0e209b421` and remove the new mesh asset. The exact CSS files mounted before this run are preserved byte-for-byte under `rollback/runtime-mounted-before/` for runtime-only restoration. The runtime was intentionally not rolled back so Owner can inspect this candidate.

Forbidden-action counts for this run: `ORDERS=0`, `CHECKOUT_SUBMISSIONS=0`, `PAYMENT/PROVIDER=0`, `MODEL=0`, `PRODUCTION_DEPLOYMENT=0`, `DOCKER_LIFECYCLE=0`, `SHARED_INFRA=0`, `PR_MERGE=0`, `P1_P12=0`.
