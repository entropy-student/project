# Birthday Magazine Studio — START HERE

This file is navigation only. It is **not** a second project truth source.

## Current read order (2026-10-17)

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — **latest `CURRENT_G3S4M_035E55_PREFLIGHT_PASS_ONE_OWNER_STRIPE_TEST_RESEND_2026_10_17`**, one Owner TEST event Resend pending.
2. [Reviewer formal G3S4M pre-replay PASS at PR64 035e55](./docs/REVIEWER_DECISION_G3S4M_035E55_PREFLIGHT_PASS_OWNER_RESEND_NEXT_2026-10-17.md) — original TEST refund and Webhook uniquely matched, no replay yet, one Owner click.
3. [ACTIVE G3S4M single official signed event resend Gate](./docs/G3S4M_STRIPE_TEST_IDENTICAL_WEBHOOK_REPLAY_AND_PHASE_CLOSEOUT_GATE_2026-10-17.md) — then read-only idempotency/revocation and TEST-only Stripe phase closeout.
4. [PR64 035e55 pre-replay Evidence](https://github.com/entropy-student/project/blob/035e55ec6af41688b5efc56c638a58c4ebb3122b/birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md).
5. [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — supporting history.

## Current snapshot (2026-10-17)

- **G3S4M Reviewer pre-replay PASS:** PR64 HEAD `035e55ec6af41688b5efc56c638a58c4ebb3122b` OPEN/UNMERGED, new G3S4M Evidence appendix only. Stripe TEST refund remains exactly one 3999-cent succeeded, Woo one $39.99 refund and order refunded, workspace access denied. Unique original TEST `charge.refunded` created 2026-10-17 15:13:23 UTC, active registered magazine webhook, 45 events zero pending. No redelivery yet, so strict replay still NOT TESTED.
- **NOW Owner one-step:** in ordinary Stripe **Test/Sandbox** dashboard Workbench/Developers → Events, select that existing charge.refunded at 15:13 UTC / $39.99 refund, click `Resend` ONCE to existing `https://magazine.spikersun.com/?wc-api=wc_stripe`. No new charge/refund or event trigger. If unavailable, report and stop.
- **Then Codex:** read-only actual second signed event delivery/zero duplicate refund, unchanged order/access, append PR Evidence; Reviewer Stripe TEST phase closeout then P1–P12 magazine design Gate.
- **Cloudflare PowerShell:** leave foreground Tunnel running until final Reviewer closeout/pending callback zero; after explicit closeout may press **Ctrl+C** to temporarily stop public website, preserving original Docker WP and credentials. No Live, PR merge or service install.

## Source-of-truth rule

If any supporting document conflicts with `REVIEWER_HANDOFF.md`, the Handoff wins unless the Owner gives a newer explicit instruction or fresh authoritative evidence requires Reviewer reconciliation.
