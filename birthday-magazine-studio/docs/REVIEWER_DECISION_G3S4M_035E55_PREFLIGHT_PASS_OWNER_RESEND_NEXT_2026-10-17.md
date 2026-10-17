# G3S4M Reviewer — pre-replay read-only PASS; one Owner Stripe TEST event Resend next

Date: 2026-10-17
Owner project: Birthday Magazine Studio; public test callback `https://magazine.spikersun.com/?wc-api=wc_stripe`.
PR #64 observed HEAD `035e55ec6af41688b5efc56c638a58c4ebb3122b`, OPEN and UNMERGED.
Authority: `G3S4M_STRIPE_TEST_IDENTICAL_WEBHOOK_REPLAY_AND_PHASE_CLOSEOUT_GATE_2026-10-17.md`; governance `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.7 §§0–10, 11B–11F.

## Formal classification

```text
REVIEWER_DECISION=PASS_BOUNDED_G3S4M_PRE_REPLAY_READ_ONLY
STRICT_SIGNED_IDENTICAL_EVENT_REPLAY=NOT_TESTED
CURRENT_GATE=G3S4M
PR64_HEAD=035e55ec6af41688b5efc56c638a58c4ebb3122b
PR_DELTA=ONLY_EXISTING_G3S4L_EVIDENCE_APPENDED
OWNER_RELAY=ONE_MANUAL_RESEND_CLICK_IN_OFFICIAL_STRIPE_TEST_DASHBOARD
EVENT_TYPE=charge.refunded
EVENT_CREATED_UTC=2026-10-17T15:13:23Z
EXPECTED_TEST_REFUNDED_AMOUNT=USD39.99
EXISTING_WOO_REFUNDS=1;ORDER_STATUS=refunded
EXISTING_STRIPE_REFUNDS=1;SUCCEEDED;3999_CENTS;LIVEMODE_FALSE
WORKSPACE_OWNER_AFTER_FULL_REFUND=DENIED
TEST_WEBHOOK_ENDPOINT=HTTPS_MAGAZINE_SPIKERSUN_COM_WC_API_WC_STRIPE
REGISTERED_ENDPOINT_COUNT=1;EVENT_TYPES=23;ENABLED=true;LIVEMODE_FALSE
TEST_EVENT_LIST=45;HAS_MORE=false;PENDING_WEBHOOK_EVENTS=0
STRIPE_CLI_AT_VERIFIED_OWNER_SHELL=UNAVAILABLE
UNSAFE_STRIPE_DASHBOARD_COMPUTER_USE=NOT_RETRIED_OR_BYPASSED
NEW_PAYMENT_ORDER_REFUND=NONE
CLOUDFLARE_TUNNEL_PS_SHUTDOWN=NOT_YET_AUTHORIZED_UNTIL_REPLAY_OR_FORMAL_DEFERRAL_AND_CALLBACK_CLOSEOUT
```

## Reviewer readback

GitHub fetch verified `035e55ec6af41688b5efc56c638a58c4ebb3122b` changes only `birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md`, appending 2026-10-17T15:48Z G3S4M pre-replay readback. No new PHP/source modification, payment/provider route write or credential output. Read the full appendix. Owner-machine Woo and Stripe TEST readbacks were performed by Executor and are `EXECUTOR_DIRECT_READBACK` in Evidence, **not an independent Reviewer login to Stripe**. Old G3S4L one TEST payment/refund/workspace-revocation bounded PASS remains accepted; do not replay transactions.

Supported narrow preconditions:
- unique already-refunded Stripe TEST Woo order, exact one provider refund and one Woo refund of 39.99, successful provider TEST status, Woo order `refunded`, workspace owner denied.
- exact one `charge.refunded` TEST event (redacted fingerprint `9eab6614ade9`, created 2026-10-17T15:13:23Z) associated with one enabled TEST endpoint (fingerprint `1cffdfa22f00`, 23 event types) on `https://magazine.spikersun.com/?wc-api=wc_stripe`.
- no pending TEST webhook deliveries in all 45 matching events; not evidence of replay yet.
- no available authenticated official Stripe CLI in Owner local PowerShell; no further tool installation or browser automation workaround.

Official Stripe guidance https://docs.stripe.com/webhooks#manual-retries supports Dashboard **Resend** on the same existing event for up to 15 days after creation; CLI 30 days. The current supported path is **ONE Owner-manual browser click**, using the normal logged-in Stripe TEST/sandbox Dashboard. A Codex Computer Use adapter previously could not verify active Stripe browser URL, and this guard must not be bypassed. Never request event identifier, credentials, API key, signing secret or raw payment payload in ChatGPT/GitHub.

## Only immediate Owner step (exact, no extra consent loop)

In Stripe Dashboard under TEST/Sandbox for the linked Woo sandbox account:
1. Open **Events** (Workbench → Events, or **Developers → Events** depending on current UI).
2. Find original **`charge.refunded`** event, **2026-10-17 15:13:23 UTC** (China UTC+8 23:13:23), associated with the **$39.99** original refund. Select event details, not `Create/Trigger test event`.
3. Under the delivery/attempt destined for **`https://magazine.spikersun.com/?wc-api=wc_stripe`**, click **Resend** **ONCE**, then stop even if UI feedback is ambiguous. Do not change endpoint settings or choose another destination. Do not press twice or trigger new refund.
4. User replies only `已重发一次` (or `没有找到 Resend` / screenshot with account/transaction identifiers redacted). Codex next performs **read-only** matching new delivery attempt to same event, validates signed callback and no side effects: Woo order refunded, one refund 39.99, provider one refund 3999c, workspace owner denied, no new payment; append PR64 Evidence and Reviewer STOPS.

## PowerShell and closeout rule

Keep the Windows PowerShell window running **`Start-MagazineTunnel.ps1`** open pending the official resend and Reviewer acknowledgment, as it provides public WordPress routing. After one resend is confirmed (or explicitly documented `REPLAY_UNAVAILABLE`), all pending callback deliveries are zero, final Evidence saved and Reviewer phase-closeout accepted, tell Owner they may press **Ctrl+C in that specific window**. That will stop reachability of `magazine.spikersun.com` and public Stripe callbacks until the launcher is restarted; it does NOT remove original Docker WordPress, Tunnel DNS/route, or private configuration. Never uninstall or delete Token during TEST phase closeout. A later magazine-design phase Gate may use local WP without Cloudflare.

**Reviewer STOP**: do not mark replay PASS, phase CLOSE, or switch to magazine design until confirmed redelivery and state readback or a formal legitimate `REPLAY_UNAVAILABLE` deferral. PR64 remains OPEN/UNMERGED, no Live or new real/synthetic charge/refund.
