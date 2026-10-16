# G3S4 — Stripe TEST-only WooCommerce payment loop, conditional combined Gate

> Date: 2026-10-16
> Status: **OWNER_AUTHORIZED_TEST_ONLY — PRECONDITIONAL_GATE_ACTIVE**
> Parent Reviewer PASS: `docs/REVIEWER_DECISION_G3S3R_PASS_LOCAL_RUNTIME_RECOVERY_2026-10-16.md`
> Runtime source: original local Windows G3C; PR #64 evidence at `1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c`
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7
> Explicit Owner authorization: `docs/OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md`. Provider/checkout TEST-only writes are **conditional on fresh source/runtime verification, new qualified recovery point and Owner-controlled authenticated consent**; STOP on failed/ambiguous preflight.

## Gate contract

```text
GATE_ID=G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_20261016
OBJECTIVE=Establish one source-correlated, backed-up, strictly Stripe TEST-mode WooCommerce payment/refund/webhook proof, with signed callback authenticity, idempotent paid order+entitlement and refund revocation; leave a bounded, reviewable result for the next paid-MVP backend phase.
MAX_ENDPOINT_THIS_ROUND=Read-only preflight/source correlation -> fresh DB+WP-files+uploads recovery and rollback proof -> conditional Owner-connected TEST gateway and signed TEST event path -> bounded synthetic Woo checkout success/failure/replay/TEST refund and entitlement assertions -> sanitize Evidence -> mandatory Reviewer stop. If a prerequisite is not met, STOP; do not improvise a different live architecture or retry ambiguous payments.
MANDATORY_REVIEW_STOP=YES; no production or real-money continuation.
TARGET_AND_SCOPE=Owner Windows 11 local preexisting G3C Docker/MariaDB/WP/Woo product #1113 virtual USD39.99; official WooCommerce Stripe 11.1.0; test-only Stripe environment/account as Owner-verified; PR #64 source reference only; original Netlify static website out of scope.
APPLICABLE_CRITICAL_CONSTRAINTS=No real charges/refunds/payouts or provider live configuration; no real buyer/customer data; no automated paid magazine production; no PayPal uninstall; no VPS/production deployment/Netlify mutation; no PR merge; no wiping or resetting dirty checkout, WordPress named volumes or previous protected backup; Secret values never enter chat/repo/logs/Evidence or exposed shell commands.
PREFLIGHT=Obtain an explicit current-turn Owner approval for exact TEST-only account connection, local gateway TEST activation/config, synthetic test orders/TEST payment and TEST refund. Verify genuine Stripe merchant account TEST access via Owner-side authenticated checkpoint (report only non-secret account-region/type and capability/restriction status); require distinct TEST vs LIVE guard and no production account secrets. Prove fresh Docker/containers/db/product/plugin/config, project-scope source and effective bind mounts, isolation of dirty worktree, no unexpected services or internet exposure. Define stable tested origin and webhook route/secret strategy, non-target baselines, TEST rollback and expiry before provider actions. If blocked by any policy/host/identity/source/backup constraint, return before writes.
REQUIRED_EVIDENCE=Owner exact Test-only authorization and scope; current protected target/source fingerprint and dirty-worktree isolation; selected fresh, consistent DB+WP/uploads backup with protected storage, integrity, isolated restore compatibility or equivalent credible restoration proof and stop procedure; plugin gateway TEST-only configuration with non-secret status readback; no Live credentials or capabilities; TEST endpoint origin/authentic signature + mode/merchant/order/amount/currency correlation, first delivery/replay/invalid signature; native Woo order/payment/entitlement truth; failed/canceled/test duplicate behavior; synthetic TEST refund and correct entitlement revocation; non-target/PayPal/protected-photo/worker delta; backup/rollback and final state; sanitized repo Evidence and no exposed Secrets.
ACCEPTANCE_CRITERIA=Either a verified TEST-only Woo order/callback/refund cycle with strict identity and idempotency and credible recovery, or a precise RETURN with no further writes. No Test-only PASS may be presented as Live acceptance, payout support, actual personalized-order fulfillment, public deployment, or Stripe Checkout hosted-page integration. Existing original frontend remains Owner frozen.
ROLLBACK_STATUS_OR_PLAN=Do not modify gateway or create synthetic orders until current restorable DB+WordPress/uploads+config recovery point, protected scope and restoration path are verified; preserve older private backups. For settings failure revert only exact Test setting against tested backup/known baseline; after partial/ambiguous provider outcome, perform read-only reconciliation and STOP, no blind repeat, direct SQL order repair, test refund or data wipe.
OWNER_ONLY_ACTIONS=Owner must separately and explicitly approve TEST-only Stripe account login/OAuth/connection and local gateway configuration plus bounded synthetic test order/payment/refund actions; Owner handles any authenticated Stripe consent. Gate creation/documentation is not that approval. Production/real-money/cost decisions are NOT included.
REVIEWER_TO_EXECUTOR_RELAY=Use the phase instructions below; exact target runtime, immutable accepted evidence pointer and scoped privilege/rollback are included. No full project-history scan.
EXECUTOR_TO_REVIEWER_RELAY=Fixed short result with Evidence Git SHA and exact STOP state; PASS_CANDIDATE is not a Reviewer PASS.
```

## Execution phases — strictly conditional

**A — Read-only target and source preflight.** Current Owner approval is explicitly recorded for this one bounded G3S4 Test-only round in `docs/OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md`. The current instruction sent to Executor must relay that approval; do not infer login consent from a GitHub file alone.  Start from this Gate, parent Reviewer PASS, current actual PR #64 head and locally mounted `poc/g3c/compose.yaml`, Stripe/Woo source and the currently preserved dirty-worktree change-path inventory. Current G3S3R result: MariaDB, WordPress and WP-CLI were running, WP 7.1.1, Woo 11.1.2, Stripe 11.1.0 installed *inactive* and product #1113 virtual USD39.99. That is dated Executor readback, not a guarantee of current state. Check local `http://127.0.0.1:8189` with explicit loopback proxy bypass where required. Compare **effective mounted files** (not only old HEAD) to selected PR source, list exact project-scoped different/untracked paths and preserve all dirty/untracked files, including 17 historical screenshot deletions. If the runtime candidate is ambiguous, return before provider write. No git reset/stash/rebase/clean/merge or silent sync.

**B — Fresh recovery prerequisite.** Create a **new** selected consistent protected backup of the current test DB and WordPress state/uploads and verify integrity and restoration semantics (isolated instance/volume where needed, no touch to original DB for rehearsal); preserve preexisting archives. Record metadata only outside the protected host. Do not duplicate previously accepted old 58-table import simply as a box-tick; new verified recovery exists for this higher-risk Test-write scope. A failure here stops before Stripe configuration.

**C — Owner TEST-only connection and signed callback.** Owner performs Stripe login/consent. Record non-secret account scope, distinguish TEST and LIVE strictly. Official Woo Stripe 11.1.0 callback suffix candidate `?wc-api=wc_stripe`; choose the actual local canonical origin from WP readback. Evaluate Stripe CLI forwarding as a candidate without declaring it automatically supported: some plugin-created webhook setup may overwrite the Test Webhook Secret or install another endpoint, so resolve compatibility before first event; do not print or hardcode secrets and do not publish WP admin/database on public ports. Temporary public HTTPS relay is a separate reviewed extension if unavoidable. No arbitrary Test or Live webhook endpoint accumulation.

**D — Smallest meaningful synthetic Test suite.** Once authenticated TEST webhook and Woo native checkout are correctly correlated, exercise a bounded synthetic test customer and product #1113: success/failed or canceled checkout, valid signed first delivery with correct merchant/mode/order/amount/USD and durable paid state, deliberately invalid signature negative and identical-event replay without repeated paid entitlements, and a separately scoped **TEST** refund with associated entitlement revocation. A fabricated Stripe event alone cannot prove authentic provider-side success; a Woo 'processing' status alone cannot prove full paid flow. Never upload real customer pictures/answers, trigger real AI generation or send real product mail to actual customers. Keep TEST Woo order/test fixture IDs inside protected host and record redacted counts.

**E — End state and Reviewer stop.** Read back gateway flags/config mode, TEST provider status (redacted), Woo states, refund, duplicate count, non-target delta, original visual/source, PayPal status, local health and private bind policy. Tear down only ephemeral forwarding started by this Gate after reconciliation, without deleting data or historical private backups. Save one append-only sanitized evidence file under `birthday-magazine-studio/docs/evidence/g3s4/` on PR #64 if permitted and isolated. Reviewer determines PASS/RETURN. Never proceed to Live or paid magazine generation automatically.

## Separate product blockers (do not conflate)

Full pre-payment magazine intake of 12–25 photos and all story answers must be held in a server-side bounded draft linked to exactly one Woo paid order and authenticated owner, and paid generation/secure 12-page PDF delivery still remain a different later build. The current static Netlify site is not the WooCommerce backend. Stripe dashboard review approval was Owner-reported; live charges/payout and bank compatibility are not proven by this Test Gate. Historical PayPal Sandbox PASS does not grant Stripe PASS or authorize PayPal removal.

## Exact Executor packet

```text
结果：PASS_CANDIDATE_G3S4_TEST_ONLY / RETURN_*
改动：说明仅测试环境、受保护备份和合成 Woo/Stripe 测试动作。
验证：说明最新本机身份、Test 账号/回调签名/金额币种关联、首投递和重放、取消失败、Test 退款/撤销及源状态。
问题：NONE 或具体阻塞。
回滚：受保护新备份和实际可恢复性、残余受限数据和任何未完成的测试状态。
请 Reviewer 检查：本轮 Test-only 是否满足验收，下一轮是否可以进入真实订单素材绑定与自动履约。
Owner 转交：NONE 或明确单一必要动作，禁止索取密钥/证件/银行号码。
```
