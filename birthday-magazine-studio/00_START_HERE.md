# Birthday Magazine Studio — START HERE

This file is navigation only. It is **not** a second project truth source.

## Current read order (2026-10-17)

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — latest `CURRENT_G3S4L_577BB_TEST_PAYMENT_REFUND_REVOKE_PASS_REPLAY_PENDING_2026_10_17`.
2. [G3S4L 577bb formal Reviewer decision](./docs/REVIEWER_DECISION_G3S4L_577BB_STRIPE_TEST_REFUND_REVOKE_PASS_REPLAY_PENDING_2026-10-17.md) — actual $39.99 Stripe TEST refund/entitlement PASS, identical signed event replay NOT TESTED.
3. [Current G3S4L Gate last 577bb appendix](./docs/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_GATE_2026-10-17.md) — release-hardening replay-only if safe official provider route available; no second payment/refund.
4. [Latest PR64 G3S4L Evidence](https://github.com/entropy-student/project/blob/577bb700de71a399bd52780d5a33eaeaca9d33ea/birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md) — one TEST order/refund, signature-negative and workspace access; accepted source fix `dcb10c56...`.
5. [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — prior decisions/history.

## Current snapshot (2026-10-17)

- **G3S4L core financial PASS (Reviewer @ PR64 `577bb700...` OPEN/UNMERGED):** only one $39.99 Stripe TEST payment, one native Woo Stripe TEST full gateway refund with Stripe provider `succeeded/livemode=false`, Woo one refund and order `refunded`; no retry after post-call evidence summary failure. One previous PHP source-only commit `dcb10c56...` added server-side shared paid/non-full-refund access guard for My Account workspace entry and direct workspace route; paid owner before refund permitted, after refund denied, other/unpaid/anonymous denied. No Live transaction or other orders touched.
- **Webhook security:** genuine refund delivery correlated through provider event and Woo success stamp; intentionally invalid signature discarded without business mutation despite **HTTP 204** (not 4xx); **identical signed event replay NOT TESTED**, source refund ID guard seen but not dynamic proof. **Overall G3S4L PARTIAL** for strict replay criterion, do not claim full signed duplicate-handling PASS or Live/production-ready.
- **Next:** no repeat payment/refund, Cloudflare/CSS/nav/cart/media scans, or browser safety bypass. One safe official signed **same TEST event resend** if available can close replay; if no trusted CLI/UI resend, track `REPLAY_UNAVAILABLE` as focused release-hardening debt and proceed with unrelated product-development work. No Owner action now.
- **Other existing:** dormant `widget_text-3` prior URLs, final rendered screenshot and synthetic exact protected-file negative remain outside this payment Gate and previously documented.

## Source-of-truth rule

If any supporting document conflicts with `REVIEWER_HANDOFF.md`, the Handoff wins unless the Owner gives a newer explicit instruction or fresh authoritative evidence requires Reviewer reconciliation.
