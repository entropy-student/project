# Birthday Magazine Studio — START HERE

This file is navigation only. It is **not** a second project truth source.

## Current read order (2026-10-17)

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — latest `CURRENT_G3S4M_STRIPE_TEST_REPLAY_CLOSEOUT_BEFORE_MAGAZINE_DESIGN_2026_10_17`: finish TEST phase, then P1–P12 design.
2. [CURRENT G3S4M one signed TEST event resend / Stripe phase closeout Gate](./docs/G3S4M_STRIPE_TEST_IDENTICAL_WEBHOOK_REPLAY_AND_PHASE_CLOSEOUT_GATE_2026-10-17.md) — no new purchase/refund, one official same-event redelivery if safely authorized, otherwise document replay unavailability; include cloudflared Ctrl+C condition.
3. [Accepted G3S4L Reviewer TEST payment/refund/revocation decision](./docs/REVIEWER_DECISION_G3S4L_577BB_STRIPE_TEST_REFUND_REVOKE_PASS_REPLAY_PENDING_2026-10-17.md) — core $39.99 TEST closed loop already PASS, identical signed Webhook replay still pending.
4. [PR64 last accepted G3S4L Evidence](https://github.com/entropy-student/project/blob/577bb700de71a399bd52780d5a33eaeaca9d33ea/birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md) — Woo/Stripe single refund, workspace revoke, invalid signature and missing replay.
5. [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — supporting history.

## Current snapshot (2026-10-17)

- **Owner's sequence:** Stripe TEST closeout **FIRST**, then P1–P12 magazine design. Future magazine transaction test belongs to later feature Gates, not now.
- **Stripe core PASS (PR64 `577bb700...` OPEN/UNMERGED):** one $39.99 TEST payment and one genuine full Woo Stripe gateway refund verified both provider/Woo, Woo order refunded, account workspace revoked by server predicate after full refund; invalid webhook signature discarded by app with HTTP 204. No Live payment. Do not repeat.
- **Only strict TEST callback gap:** identical previously signed `charge.refunded` Webhook event never resent. G3S4M permits one **official** existing TEST event resend via already authorized CLI (30-day) or Owner normal Stripe Dashboard (15-day). If unsafe/unavailable, record `REPLAY_UNAVAILABLE / DEFERRED_NOT_PASS`, not fictitious PASS; then bounded closeout/next design handoff.
- **Cloudflare PowerShell:** keep dedicated foreground connector running through potential replay and pending callbacks; after Reviewer accepts TEST phase closeout, Owner can **Ctrl+C** to stop. This temporarily takes `magazine.spikersun.com` offline; original Docker, token and DNS route preserved for later public magazine preview.
- **No PR merge/Live/production activation:** existing website and account remain TEST only. No new WordPress/VPS/paid hosting.

## Source-of-truth rule

If any supporting document conflicts with `REVIEWER_HANDOFF.md`, the Handoff wins unless the Owner gives a newer explicit instruction or fresh authoritative evidence requires Reviewer reconciliation.
