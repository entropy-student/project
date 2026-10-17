# Birthday Magazine Studio — START HERE

This file is navigation only. It is **not** a second project truth source.

## Current read order (2026-10-17)

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — latest `CURRENT_G3S4L_728609_NAVIGATION_PASS_STRIPE_TEST_OAUTH_OWNER_NEXT_2026_10_17`.
2. [Reviewer 728609 — bounded navigation PASS, Stripe TEST Owner next](./docs/REVIEWER_DECISION_G3S4L_728609_NAVIGATION_PASS_STRIPE_TEST_AUTH_NEXT_2026-10-17.md).
3. [Active G3S4L Gate last appendix](./docs/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_GATE_2026-10-17.md) — no more nav/cart/CSS/Tunnel tasks; official Stripe TEST-only OAuth first.
4. [PR64 latest link-fix Evidence](https://github.com/entropy-student/project/blob/728609c54b68ae955150fd4957af93cac2f4d815/birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md) — 11 menu IDs + home/footer/header, zero rendered checkout loopback hrefs, rollback.
5. [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — historical context.

## Current snapshot (2026-10-17)

- **Reviewer G3S4L navigation PASS:** PR64 HEAD `728609c54b68ae955150fd4957af93cac2f4d815` OPEN/unmerged. WP native guarded updates only: 11 menu custom URL records, Home CTA, reusable footer block 1143 (3), Blocksy header button (1). Actual checked public home/preview/product/my-account/nonempty checkout now have zero loopback hrefs over HTTPS 200. Old URL rollback values recorded, guest cart cleaned, no order/payment.
- **Deferred nonblocking URL:** `widget_text-3` in `ct-footer-sidebar-3` stores old localhost links but was NOT rendered on the sampled public pages. Fix only if/when activated; no unnecessary global DB replace. Rendered screenshot still unverified, not a blocker for TEST account registration.
- **Stripe status:** Official Woo Stripe 11.1.0 active; gateway disabled, TEST selector saved, NO test account/OAuth/test/live keys or Webhook signing secret. GET 200 to `/?wc-api=wc_stripe` is route only. **Next action is Owner-only official Woo Stripe TEST account signup/login/OAuth** via `https://magazine.spikersun.com/wp-admin/` → WooCommerce Payments/Stripe; TEST-only separate from Live. Real/Live payment forbidden.
- **After OAuth:** Codex read-only verifies connected TEST identity, Stripe TEST webhook signed POST and status before one narrowly authorized $39.99 simulated payment/webhook/refund/entitlement revoke; no new infrastructure, backup, repeated scans, VPS or merge.

## Source-of-truth rule

If any supporting document conflicts with `REVIEWER_HANDOFF.md`, the Handoff wins unless the Owner gives a newer explicit instruction or fresh authoritative evidence requires Reviewer reconciliation.
