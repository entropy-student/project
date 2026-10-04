# G3CR7R1 Executor Evidence

**Executor result:** `PASS_CANDIDATE_G3CR7R1_EXECUTOR_REPRODUCTION`
**Gate:** `G3CR7R1_EXECUTOR_REPRODUCTION`
**Review stop:** `STOP_AT_REVIEWER=YES`
**PR:** #64, existing branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`; open and unmerged at pre-write head `97aceb4a1a9990f2e203e90de8bd5965202d63b8`.

Before submission, `origin/main` was refreshed to `8f8153b1f4f2d54de6721aaf6d77245a0e33f628`. The current Gate, product contract, and Reviewer Handoff blobs on that main head match the PR head; no Gate-authority drift was found.

This is Executor evidence only. It does not change Reviewer decisions or claim formal PASS.

## Baseline and scope

The implementation was independently reconstructed from accepted source baseline `e71f94377d341a88ba388f2c5da153e7cd6ee8b8`. The previous Reviewer prototype at `0603706ca0441fb1cb65ff716f47f7a919e2e4f3` remains reference-only; the new implementation does not require its `frontend-flow.php` or `frontend-intake*` files.

Accepted baseline blobs and final source read-back:

| File | Accepted baseline blob | Final blob | Result |
|---|---|---|---|
| `poc/g3c/preview-plugin/birthday-magazine-poc.php` | `a677f5c321d9ac323c64b7efda73a57a37efe431` | `0aa39e131b7958652bc0cfbd4ada7a4621fb3caf` | Bounded CTA/copy adjustment and new independent include |
| `poc/g3c/preview-plugin/preview.js` | `bf60295a2236eb96e0c358158653b05b95b1f390` | `bf60295a2236eb96e0c358158653b05b95b1f390` | Exact baseline; browser-local photo logic unchanged |
| `poc/g3c/preview-plugin/home.css` | `709556a42d2058d8252392f5df5d8339aae5d126` | same | Unchanged |
| `poc/g3c/preview-plugin/studio.css` | `33252bd489156cf05522bf9a2cb60d4c89078de1` | same | Unchanged |
| `poc/g3c/preview-plugin/magazine-preview.css` | `6eb88f4cc76ca99692499cd8eeb13362697507eb` | same | Unchanged |

`source-diff.patch` contains the scoped source changes against the accepted baseline. No homepage Gutenberg content was edited: Home page 858 SHA256 stayed `7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a`.

Files implemented or changed under the Gate target:

- `poc/g3c/preview-plugin/birthday-magazine-poc.php` — point the Free Preview and Home Offer entry to the local five-step page; adjust copy that implied a server-side creator; include the new isolated implementation.
- `poc/g3c/preview-plugin/frontend-reproduction.php` — five-step intake shell, WooCommerce-backed status callback, and explicitly labeled visual-only status fixture.
- `poc/g3c/preview-plugin/frontend-reproduction.css` — responsive presentation; one scoped mobile correction removes Gutenberg's narrow constrained-width cap on the intake page. At 375px the form step grew from 266px to 311px and document width stayed 375px.
- `poc/g3c/preview-plugin/frontend-reproduction.js` — browser-memory form state, validation, local image selection, review summary, and WooCommerce-native handoff.
- `poc/g3c/preview-plugin/g3cr7r1-local-seed.php` — local-only WP-CLI seed for the two static display pages; guarded by CLI context and `BMS_G3CR7R1_LOCAL_ONLY=1`.
- `poc/g3c/preview-plugin/preview.js` — exact accepted baseline after removing the reference prototype's previous query-string forwarding from the preview CTA. Name/age are not put in the URL or sent as an intake draft.

The intake page keeps answers and selected photos only in page memory. It does not write a draft, send form answers, or send photo bytes to WordPress. Checkout CTA sends only canonical WooCommerce product `1113` through its native add-to-cart endpoint and redirects to WooCommerce checkout; the automated check did not submit checkout.

## Runtime read-back

Direct runtime read-back against retained `http://127.0.0.1:8189/`:

- WordPress `7.1.1`; WooCommerce `11.1.2`; PHP `8.3.33`; active theme Blocksy `2.1.57`.
- Product `1113`, “The Birthday Magazine”, is `39.99 USD`, virtual, and does not manage stock. Product permalink resolves to `/product/birthday-magazine/`.
- Local pages created by the guarded helper: `make-your-magazine` (ID `1147`) and `magazine-status-preview` (ID `1148`). They contain only the two Gate shortcodes.
- Before/after: Woo order count `1 → 1`; paid order count remained `0`; the one existing synthetic `on-hold` order remained unpaid; Home 858 content hash unchanged.
- Database table scan found `0` tables matching generation/job names. No order or job was created by the handoff test.
- Runtime and existing Docker services were retained; no Compose rebuild, pull, restart, teardown, or global cleanup was used.

## Validation

Machine report: [`browser-report.json`](browser-report.json). Runtime/version/product/container read-back: [`runtime-readback.json`](runtime-readback.json). Screenshot dimensions and SHA256 values: [`screenshot-manifest.json`](screenshot-manifest.json). Captures are synthetic/local only.

- PHP `8.3.33` parser: `birthday-magazine-poc.php`, `frontend-reproduction.php`, and `g3cr7r1-local-seed.php` all pass `php -l` inside the running WordPress container.
- Node `--check`: changed `frontend-reproduction.js` and accepted-baseline `preview.js` pass.
- Microsoft Edge `154.0.4258.53` through existing Playwright; 1440×1000 and 375×812.
- Homepage Offer CTA and Free Preview CTA both reach `/make-your-magazine/`; preview values are not added to the URL.
- The five required steps render in order. Empty identity, empty photo step, incomplete story prompts, and incomplete final prompts cannot advance.
- 12 and 25 local PNG fixtures are accepted; a 26th file is rejected; 3 photos can be marked must-use and the fourth choice is disabled. The fixtures are geometric synthetic illustrations, not customer photographs.
- Free Preview selected image is `blob:`; selecting it caused no POST request. The intake photo grid URLs are all `blob:`. No AI/model/generation endpoint is present or called.
- Native checkout handoff resolves to `/checkout/`, with Woo checkout form and product name visible. Checkout was not submitted. The temporary Playwright browser context was closed after the run.
- Status helper read the actual on-hold order using WooCommerce `is_paid()`: `awaiting_payment`. `?paid=1&status=ready` did not promote it; nonexistent order state was `not_found`; wrong-context replay showed no project paid/ready status.
- Intake document/body widths equal viewport at both 1440px and 375px. Browser console errors `0`; page errors `0`; failed requests `0`.
- Only external requests observed were Google Fonts (`fonts.googleapis.com`, `fonts.gstatic.com`); no third-party image request or upload occurred.

### Order-received evidence boundary

The existing local on-hold order belongs to a registered account. The anonymous browser was denied order details by WooCommerce, so no owner credential was read or reused. Screenshots include (1) the explicitly watermarked local continuation/ready visual fixture and (2) the actual wrong-context WooCommerce order-received response with no project paid/ready state. The positive continuation screenshot is therefore a visual fixture, not a claim that an authorized customer order page was opened. The actual status callback's payment truth is checked from the real unpaid order as described above. Reviewer should decide whether this local fixture satisfies the Gate's non-consequential order-received evidence requirement.

## Screenshot index

All 25 current captures are under [`screenshots/`](screenshots/):

- Homepage entry: `home-entry-desktop.png`, `home-entry-mobile-375.png`.
- Existing Free Preview after synthetic photo selection: `free-preview-selected-desktop.png`, `free-preview-selected-mobile-375.png`.
- Intake whole page: `intake-entry-full-desktop.png`, `intake-entry-full-mobile-375.png`.
- About: `intake-step-01-about-desktop.png`, `intake-step-01-about-mobile-375.png`.
- Photos empty: `intake-step-02-photos-empty-desktop.png`, `intake-step-02-photos-empty-mobile-375.png`.
- 12 photos / 3 must-use: `intake-step-02-photos-12-must-use-desktop.png`, `intake-step-02-photos-12-must-use-mobile-375.png`.
- Story: `intake-step-03-story-desktop.png`, `intake-step-03-story-mobile-375.png`.
- Little things: `intake-step-04-little-things-desktop.png`, `intake-step-04-little-things-mobile-375.png`.
- Review: `intake-step-05-review-desktop.png`, `intake-step-05-review-mobile-375.png`.
- Woo checkout handoff: `woocommerce-checkout-handoff-desktop.png`.
- Status and ready visual fixture: `status-visual-fixture-desktop.png`, `status-visual-fixture-mobile-375.png`, `woocommerce-order-received-continuation-fixture-desktop.png`, `woocommerce-order-received-continuation-fixture-mobile-375.png`.
- Unauthorized order-received context: `woocommerce-order-received-unauthorized-desktop.png`, `woocommerce-order-received-unauthorized-mobile-375.png`.

## Rollback and forbidden actions

Git rollback to the accepted target-file source is `git restore --source=e71f94377d341a88ba388f2c5da153e7cd6ee8b8 -- birthday-magazine-studio/poc/g3c/preview-plugin/birthday-magazine-poc.php birthday-magazine-studio/poc/g3c/preview-plugin/preview.js birthday-magazine-studio/poc/g3c/preview-plugin/home.css birthday-magazine-studio/poc/g3c/preview-plugin/studio.css birthday-magazine-studio/poc/g3c/preview-plugin/magazine-preview.css`, then remove the four new Gate-only helper files. Runtime-only rollback additionally restores the pre-overlay PHP copy from `C:\Users\34707\AppData\Local\Temp\birthday-magazine-g3cr7r1\birthday-magazine-poc.php.before`, removes the four added runtime helper files, and deletes only local pages `1147` and `1148`; no such rollback was applied.

```text
REAL_PAYMENTS=0
CHECKOUT_SUBMISSIONS=0
PROVIDER_MUTATIONS=0
MODEL_OR_GENERATION_CALLS=0
PRODUCTION_DEPLOYMENTS=0
SHARED_INFRA_MUTATIONS=0
P1_P12_BUILD=0
PR64_MERGE=0
```
