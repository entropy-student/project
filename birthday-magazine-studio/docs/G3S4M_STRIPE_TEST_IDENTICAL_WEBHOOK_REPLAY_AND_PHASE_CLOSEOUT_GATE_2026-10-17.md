# G3S4M — Stripe TEST existing signed-event replay and phase closeout (single bounded attempt)

Date: 2026-10-17
STATUS=ACTIVE_EXECUTOR_GATE; REVIEWER_OWNS_FINAL_PASS_OR_PARTIAL_AND_NEXT_DESIGN_PHASE
Repo: `entropy-student/project`, PR #64 OPEN/UNMERGED, latest verified HEAD `577bb700de71a399bd52780d5a33eaeaca9d33ea`.
Owner explicit sequencing: "好的，把stripe先跑通完成收尾，然后我们再转向杂志本身的设计。如果后续要测试杂志的交易，那就后续再测试。记得告诉我一个powershell什么时候能关掉。按照项目管理规范继续推进吧。"
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §§0–10, triggered 11B (Secret/Windows target), 11C (public Tunnel), 11D (automation/auth), 11E (provider/callback/payment), 11F (phase closeout only); 11A only for shared storage context, no Shared Infra mutation, 11G not triggered. All previous accepted Gates remain stable; this gate grants no LIVE or new payment authority.

```text
GATE_ID=G3S4M_STRIPE_TEST_IDENTICAL_WEBHOOK_REPLAY_AND_PHASE_CLOSEOUT_20261017
OBJECTIVE=VERIFY_DUPLICATE_DELIVERY_OF_ONE_EXISTING_SIGNED_STRIPE_TEST_EVENT_AND_CLOSE_STRIPE_TEST_PHASE_WITH_ACCURATE_STATUS
MAX_ENDPOINT_THIS_ROUND=ONE_OFFICIAL_PROVIDER_RESEND_OF_THE_EXISTING_CHARGE_REFUNDED_EVENT_TO_THE_EXISTING_TEST_WEBHOOK_THEN_READONLY_RECONCILIATION_AND_PHASE_CLOSEOUT_EVIDENCE
MANDATORY_REVIEW_STOP=YES_BEFORE_ANY_NEXT_MAGAZINE_DESIGN_EXECUTION
TARGET_AND_SCOPE=ORIGINAL_OWNER_WINDOWS_WORDPRESS_WOOCOMMERCE_STRIPE_TEST_AT_HTTPS_MAGAZINE_SPIKERSUN_COM;PR64_EVIDENCE_APPEND_ONLY;MAIN_HANDOFF_REVIEWER_OWNED
CRITICAL_CONSTRAINTS=NO_NEW_ORDER_PAYMENT_REFUND_LIVE_OR_SIGNING_SECRET;NO_PROVIDER_CONFIG_CHANGE;NO_UNAUTHORIZED_BROWSER_AUTOMATION;NO_UNVERIFIED_WINDOWS_APPDATA;NO_PUBLISHING_OR_MERGING_PR64
PREFLIGHT=VERIFY_TEST_ONLY_ACCOUNT_AND_WEBHOOK_ENDPOINT;MATCH_SAME_EXISTING_EVENT_BY_WOO_REFUND_EVENT_PROVIDER_IDENTITY_IN_PROTECTED_RUNTIME;PRE_REPLAY_NO_PENDING_SIDE_EFFECTS;CAPTURE_BEFORE_STATE
REQUIRED_EVIDENCE=OFFICIAL_PROVIDER_RESEND_OR_EXACT_UNAVAILABLE_REASON;NO_NEW_FINANCIAL_OPERATIONS;MATCHED_EVENT_AND_ENDPOINT_FINGERPRINTS_ONLY;DELIVERY_RECEIPT;WOO_REFUND_COUNT_AMOUNT_ORDER_STATE_AND_OWNER_ACCESS_BEFORE_AFTER;ZERO_NON_TARGET_CHANGE;POWER_SHELL_TUNNEL_SHUTDOWN_READINESS
ACCEPTANCE_CRITERIA=SIGNED_SAME_EVENT_REDELIVERED_ONCE_BY_OFFICIAL_PROVIDER_TO_ORIGINAL_ENDPOINT;NO_DUPLICATE_REFUND_OR_PAY_STATE_OR_ENTITLEMENT;OR_REPLAY_UNAVAILABLE_WITH_NO_FALSE_PASS_AND_EXPLICIT_RELEASE_LIMITATION
ROLLBACK_STATUS_OR_PLAN=NO_NEWCUSTOMER_RECORD_OR_DATA_MUTATION_EXPECTED;ON_UNEXPECTED_WEBHOOK_STATE_CONTAIN_ONLY_TEST_CHANNEL_AND_PRESERVE_FORENSIC_STATE;NEVER_UNDO_REFUNDED_ORDER_OR_REISSUE_REFUND
OWNER_ONLY_ACTIONS=NONE_UNLESS_OFFICIAL_STRIPE_SANDBOX_DASHBOARD_EVENT_RESEND_OR_STRIPE_CLI_ACCOUNT_CONSENT_REQUIRES_ONE_OWNER_ACTION;NEVER_EXPOSE_KEYS_OR_AUTH_CODES
REVIEWER_TO_EXECUTOR_RELAY=SEE_SPECIFIC_BELOW
EXECUTOR_TO_REVIEWER_RELAY=STANDARD_GOVERNANCE_9_COMPLETION_PACKET_AND_ONE_G3S4M_APPEND
```

## Accepted facts (no reread of old history by default)

1. [G3S4L formal last Reviewer decision](./REVIEWER_DECISION_G3S4L_577BB_STRIPE_TEST_REFUND_REVOKE_PASS_REPLAY_PENDING_2026-10-17.md) verified PR64 `577bb700...`: ONE $39.99 Stripe TEST succeeded, ONE Woo-native full Stripe TEST refund succeeded, Stripe `livemode=false` and one refund 3999 cents, Woo ONE $39.99 refund and `refunded` order, shared server-side paid/non-full-refund workspace entitlement guard PASS. Invalid signature event application-discarded but returned HTTP 204, not 4xx. Actual same signed event has NEVER been resent.
2. Exact current G3S4L Evidence `birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md` at PR64 HEAD `577bb700...`, latest sections **existing TEST order reconciliation** and **TEST refund, workspace entitlement guard, and webhook negative check**. Source PHP `birthday-magazine-studio/poc/g3c/commerce-workspace-plugin/bms-g3a-commerce-loop.php` at same PR commit blob `30c7d928916f686aa4aeff6c26615b43783344dd`. Do not revert/rewrite code simply to make a replay PASS.
3. Public target `https://magazine.spikersun.com/?wc-api=wc_stripe` is supported by foreground Windows Cloudflare named Tunnel process started with `Start-MagazineTunnel.ps1`; site also needs original Docker WordPress live. No Stripe Live account/money; checkout and refund both already completed. Owner wants clear instruction on **when Tunnel PowerShell can be closed**.
4. Official Stripe docs https://docs.stripe.com/webhooks#manual-retries : **Dashboard Resend for up to 15 days**, **Stripe CLI `stripe events resend <event_id> --webhook-endpoint=<endpoint_id>` for up to 30 days**. These are actual redelivery mechanisms, unlike `GET /v1/events`, `stripe trigger`, `stripe listen`, or manual forged valid signatures. Stripe event authenticity must be maintained via normal registered endpoint and the existing Woo signing secret; do not substitute a local CLI listener with a different `whsec_`.
5. Original Codex Computer Use FAILED its live Stripe Dashboard active-URL confidence test. This is a legitimate STOP for that adapter; DO NOT retry or bypass via another browser automation API, embedded script, direct profile/cookie/session, or old Dashboard tab. An **Owner personally clicking Resend in the logged-in official Dashboard**, or official **Stripe CLI via separate Owner-only official authentication** on a verified Windows host, is permissible with secret boundaries. Do not silently authorize new identity/login.
6. No new Stripe/WordPress asset/design/test media needed; original `widget_text-3`, visual proof, private-file selector stay separate design/security backlog. This is **Stripe TEST phase closeout only**, not website decommission or project CLOSE.

## Single bounded Executor steps

### A — No-write readbacks and deterministic safety lock

- Verify original real Windows host identity (Governance §11B), running Docker/Cloudflare connector remains healthy, TEST mode, exact original account and registered endpoint. Use only masked plugin-native status and authoritative provider readbacks. No raw `sk_test`, `whsec`, CLI OAuth keys, token/cookies/session/Stripe event payload shown to Codex chat, logs, PR or project docs. Do not re-download cloudflared or change AppData.
- Derive unique **existing** `charge.refunded` TEST event from already accepted one refunded $39.99 order, and unique original enabled TEST `we_...` endpoint targeting `https://magazine.spikersun.com/?wc-api=wc_stripe`. All provider lookup using TEST scope and read-only semantics; ensure `livemode=false`, recorded completed refund, and **no further refunds or pending TEST webhook retry**. Ambiguous matches/invalid ownership -> STOP before resend. Record only event/endpoint **one-way redacted fingerprints** and date/time range, not raw names/emails/account IDs/event IDs.
- Before test, capture and independently read back `Woo refund record count=1, refund amount=39.99, order status=refunded, Stripe refund count=1, refunded amount=3999 cents, workspace owner denied`, and any prior webhook delivery state. Do not invoke Woo operations with mutation masquerading as read-only.

### B — One officially signed SAME-EVENT redelivery; no new payment

Prefer the route requiring least Owner work that remains trusted/authorized:
- If an already installed/authenticated **official Stripe CLI** exists at a separately verified ordinary Owner-native path and the CLI `events resend` supports the TEST connected account, only then issue **one** `stripe events resend <EXISTING_EVENT_ID> --webhook-endpoint=<EXISTING_TEST_ENDPOINT_ID>` on actual Owner host with exact TEST scope, capturing sanitized redelivery result. Event/endpoint identifiers are not secret API credentials but avoid copying them to GitHub. Absolutely **no** `stripe trigger`, no synthetic new event, no `stripe listen` alternate signing secret.
- If CLI is unavailable, **do NOT trigger an installation/environment rebuild merely for this one test**. Prepare **one minimal Owner-controlled action**: in their **normal browser**, logged into the official Stripe **sandbox/test** dashboard (not automated Codex Computer Use), select the exact EXISTING `charge.refunded` event and existing `magazine.spikersun.com` delivery, click official **Resend** **ONCE** within the 15-day window; Codex provides one short exact click-path only if needed and does not ask for raw event IDs/secrets. Then Codex handles native Woo and provider read-back on the original runtime. Do not trick the app Computer Use current-tab URL check or use raw Browser cookies/API keys.
- If the only way would be installing a new CLI + another auth workflow or the official resend option is missing/disabled/wrong account, classify `REPLAY_UNAVAILABLE_UNDER_CURRENT_AUTH`. Do **not** endlessly retry, invent signed event payloads, lower signature enforcement, or demand new orders/refunds. ONE replay at most, not a loop.

### C — Actual identical event idempotence and side effects

- Read delivery receipt/log for same ORIGINAL provider event identity (without publishing ID), signed validation result, callback HTTP status, durable Woo side-effect timestamps/records, and owner entitlement. For duplicate already-refunded event, Woocommerce/provider refund record count and amount remain unchanged, order stays `refunded`, bound owner and anonymous still have no access. A 2xx alone is not idempotency PASS; compare before/after records; if the provider's resend was queued, do not claim it actually arrived until verified.
- If dynamic replay succeeded with no side effects: result `PASS_CANDIDATE_IDENTICAL_TEST_EVENT_REPLAY`, submit evidence, Reviewer can promote G3S4L strict test callback to PASS. If official resend couldn't be executed or delivery not independently verified: `PARTIAL_REPLAY_UNAVAILABLE`, **retain strict replay NOT_TESTED** and an explicit release hardening item. If unexpected mutating side effect or another refund appears, contain TEST route only, STOP, no broad recovery or second replay.
- No new Webhook security probes beyond accepted invalid signature check, no duplicate financial charges/transactions or new product checkout.

### D — Stripe TEST phase closeout and transition boundary

- Append exactly one short **G3S4M closeout Evidence section to the EXISTING PR64 G3S4L Evidence** or one appropriately named `docs/evidence/g3s4/G3S4M_...` only if existing format demands; preserve old append-only facts. Include current account TEST-only, zero new TEST order/refund, replay outcome/provenance, before/after invariants, code/source and rollback unchanged, explicit unresolved items, `RELEASE_STATUS=TEST_ONLY`, `NO_LIVE_OR_PRODUCTION_ACTIVATION`.
- Record **PowerShell readiness**: while the foreground `cloudflared tunnel run --token-file` process remains open, public `magazine.spikersun.com` is connected to Windows 8189. It may be stopped safely **AFTER** final Stripe callback/delivery is finished, with **no pending test webhooks needing public delivery**, evidence complete, and Reviewer authorizes end of this provider canary. Owner then may press **Ctrl+C** in the original Cloudflare PowerShell window; no daemon/service uninstall, Token deletion, DNS wipe, project Docker deletion or secret loss. Stopping it makes external `magazine.spikersun.com` temporarily unreachable even if DNS remains; subsequent public preview/payment callback requires reconnect by the reviewed launcher.
- Keep Stripe TEST-only connection/config and original paid/refunded record **for future product transaction tests**; avoid disabling/deleting/reconnecting provider or removing Tunnel route just to mark a phase complete. Don't silently activate Live or permit anonymous real sales. If Owner elects to leave public site visible during design, connector window must remain up, or a separately approved reviewed persistence approach is needed (not this Gate).
- Once G3S4M Reviewer accepts PASS or formally recorded `PARTIAL_REPLAY_UNAVAILABLE`, Reviewer publishes current Handoff and a **new, separate magazine design phase Gate** with scope/content/P1–P12/product pipeline later. Executor **MUST NOT** start magazine design under this Stripe closeout Gate.

## REVIEWER_TO_EXECUTOR_RELAY

Read ONLY:
1. This Gate `birthday-magazine-studio/docs/G3S4M_STRIPE_TEST_IDENTICAL_WEBHOOK_REPLAY_AND_PHASE_CLOSEOUT_GATE_2026-10-17.md`;
2. `birthday-magazine-studio/docs/REVIEWER_DECISION_G3S4L_577BB_STRIPE_TEST_REFUND_REVOKE_PASS_REPLAY_PENDING_2026-10-17.md` for accepted TEST facts and before/after criteria;
3. PR64 `birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md`, last **two refund/reconciliation sections** only, plus `poc/g3c/commerce-workspace-plugin/bms-g3a-commerce-loop.php` only if genuine source drift found;
4. Official https://docs.stripe.com/webhooks#manual-retries and https://docs.stripe.com/cli/events/resend ; no other history unless material drift proven.

**Execute no more than one official same-event TEST `charge.refunded` redelivery** and one evidence closeout. Do not read all Governance/Handoff/entire past G3S4L, redo checkout/refund, force Stripe CLI installation or browser bypass. If Owner manual step truly required, report it ONCE with exact test-only click-path and stop waiting; do not claim redelivery then. After actual one redelivery, compare invariants and stop Reviewer. **Owner relay defaults NONE**.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_REPLAY_UNAVAILABLE / RETURN_UNEXPECTED_STATE
改动：只追加脱敏 G3S4M Stripe TEST 收尾 Evidence；没有新交易或配置变更。
验证：是否同一事件由官方重发并真实到达；Stripe/Woo退款总数/金额/工作区访问前后。
问题：NONE / 原因+精确人工作业（如需）/ 真实新风险。
回滚：没有新的业务写入；原退款及安全代码保留；云隧道仍可用且停止条件已记录。
请 Reviewer 检查：重放真实性、业务状态不变、回调签名和测试阶段收尾。
Owner 转交：NONE / 一次官方测试事件手动 Resend（如需，不能含账号密钥）。
```
