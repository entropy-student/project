# Birthday Magazine Studio — START HERE

This file is navigation only. It is **not** a second project truth source.

## Current read order (2026-10-18)

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — latest `CURRENT_G3S4M_OWNER_MANUAL_TEST_RESEND_200_VERIFY_RUNTIME_ONLY_2026_10_18`.
2. [Active G3S4M Gate latest owner screenshot appendix](./docs/G3S4M_STRIPE_TEST_IDENTICAL_WEBHOOK_REPLAY_AND_PHASE_CLOSEOUT_GATE_2026-10-17.md) — same event manually redelivered 200 OK, only read-only Woo/Stripe idempotence evidence next.
3. [Reviewed 035e55 pre-replay state](./docs/REVIEWER_DECISION_G3S4M_035E55_PREFLIGHT_PASS_OWNER_RESEND_NEXT_2026-10-17.md) — original TEST refunded Woo/Stripe single-record baseline before the manual resend (historical Owner click request now fulfilled).
4. [PR #64 current G3S4L/G3S4M Evidence](https://github.com/entropy-student/project/blob/035e55ec6af41688b5efc56c638a58c4ebb3122b/birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md) — pre-replay baseline; post-replay evidence pending.
5. [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — history.

## Current snapshot (2026-10-18)

- **Owner manual original Stripe TEST event resend DONE at UI level:** Stripe Dashboard screenshot shows original `v1.charge.refunded` event, one **`手动重试` (manual retry) 200 OK / 已送达** to `https://magazine.spikersun.com/?wc-api=wc_stripe` at `2026-10-17 16:08:20 UTC` (UTC+8 00:08:20 on Oct18). Do not click resend again. Provider UI 200 means delivered but does not alone prove Woo refund record/entitlement unchanged.
- **PR64 latest readback:** `035e55ec6af41688b5efc56c638a58c4ebb3122b` OPEN/UNMERGED, prior TEST payment and real refund single-record baseline accepted. Codex next READ-ONLY verifies after re-delivery Woo order refunded, Woo 1 refund USD39.99, Stripe TEST 1 refund 3999 cents, same event attempt and owner workspace denied; append sanitized Evidence on PR64 then Reviewer STOP.
- **Cloudflare PowerShell:** keep foreground `Start-MagazineTunnel.ps1` open until Codex post-replay readback and Reviewer accepted phase closure; then Ctrl+C stops public forwarding but leaves Docker WordPress, data, Stripe TEST config and DNS.
- **NEXT distinct phase:** magazine P1–P12 design/production; no new paid test until features require; no Live, PR64 merge, new WP or VPS.

## Source-of-truth rule

If any supporting document conflicts with `REVIEWER_HANDOFF.md`, the Handoff wins unless the Owner gives a newer explicit instruction or fresh authoritative evidence requires Reviewer reconciliation.
