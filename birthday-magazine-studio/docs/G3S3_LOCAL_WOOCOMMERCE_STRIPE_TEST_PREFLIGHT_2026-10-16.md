# G3S3 — Local WooCommerce / Stripe Test-only integration preflight

> Status: ACTIVE_FOR_NARROW_READONLY_EXECUTION; STOP_AT_REVIEWER
> Date: 2026-10-16
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7
> Parent PASS: `docs/REVIEWER_DECISION_G3S2_PASS_READONLY_POLICY_PLAN_OWNER_ELIGIBILITY_PENDING_2026-10-16.md`
> New Owner update: `docs/OWNER_UPDATE_G3S3_STRIPE_APPROVED_NETLIFY_STATIC_2026-10-16.md`
> Working source: PR #64 `codex/birthday-magazine-g3c-blocksy-wedding-productization`, last verified head `4cb0d527d77a6d583e123acd3f62c45408669569`; verify fresh before using.

## Gate contract

```text
GATE_ID=G3S3_LOCAL_WOOCOMMERCE_STRIPE_TEST_PREFLIGHT_20261016
OBJECTIVE=Prove the smallest current local runtime/source/rollback/webhook facts needed to design an actually executable Stripe TEST-only Woo checkout integration; identify exact missing prerequisites; avoid replaying completed merchant-policy research.
MAX_ENDPOINT_THIS_ROUND=READONLY project-scoped local runtime and source readback plus sanitized integration-preflight Evidence and Executor completion packet; NO activation/OAuth/test payment/provider mutation.
MANDATORY_REVIEW_STOP=YES; no continuation into Test activation even on PASS_CANDIDATE.
TARGET_AND_SCOPE=Owner Windows 11 local Birthday Magazine G3C at 127.0.0.1:8189, PR #64 scoped source, WooCommerce product #1113 and locally installed official Stripe extension, backup/recovery references, proposed TEST webhook path; public Netlify info URL is read-only context only.
APPLICABLE_CRITICAL_CONSTRAINTS=Stripe 11.1.0 installed inactive; Woo canonical order; Owner-accepted visual is frozen; no credential disclosure; no changed WP/Docker/source config; no Stripe login or connect; no dashboard merchant mutation; NO real/test Checkout submission, signed event simulation, refund, tunnel, public deployment or PayPal uninstall; no PR #64 merge or new PR.
PREFLIGHT=Read only this Gate, referenced Owner update, parent G3S1SVE Reviewer PASS, exact G3C compose/Stripe plugin/source paths named by Gate. Fresh project-owned runtime readback, project-scoped source freshness, and provider-independent recovery inventory. Stop if wrong machine/runtime or contradictory source identity.
REQUIRED_EVIDENCE=FRESH_RUNTIME_AND_PLUGIN_STATUS; PRODUCT_AND_WOO_ORDER_OWNERSHIP_INVARIANTS; BACKUP_RECOVERY_SUITABILITY_FOR_FUTURE_TEST_WRITE; EXACT_PROPOSED_STRIPE_TEST_ACCOUNT_CONNECTION_AND_WEBHOOK_DELIVERY_STRATEGY; SIGNATURE/AMOUNT/CURRENCY/ENV/REPLAY/REFUND_TEST_MATRIX; FRONTEND_NETLIFY_VS_WOO_RUNTIME_BOUNDARY; BLOCKERS_AND_OWNER_CHECKPOINTS; NO_MUTATION_ATTESTATION.
ACCEPTANCE_CRITERIA=Every item proven as DIRECT_READBACK, accepted prior Evidence, OWNER_REPORTED, or UNKNOWN; no substitute screenshot for actual runtime; a bounded next Test-mode write Gate is feasible or exactly blocked, with rollback and no unstated host/provider prerequisites.
ROLLBACK_STATUS_OR_PLAN=This Gate does not mutate. Source recovery via retained PR commit, local DB/files previous isolated recovery limited to inactive staging; a later activation Gate requires freshly selected restorable DB/files point and an independently reviewed scoped rollback/stop.
OWNER_ONLY_ACTIONS=Owner later authorizes specific Test-mode Stripe account linkage/login/OAuth and gateway setting changes; provides non-secret account merchant country, legal structure, payment and payout status; separate explicit authorization before any live money, public hosting cost or real account payout/refund.
```

## Small exact-source startup / Reviewer-to-Executor relay

1. Work on the Owner's actual **Windows 11 local G3C runtime** only; no VPS/SSH. Begin by checking the current source/target; do not assume Docker is running because of historical evidence. Read `poc/g3c/compose.yaml`, relevant Woo/Stripe plugin status, WooCommerce product #1113 current metadata and the exact currently active WordPress checkout/payment plugin configuration **read-only, excluding Secret values**.
2. Use these accepted pointers without broad archaeology: `REVIEWER_HANDOFF.md`, `docs/REVIEWER_DECISION_G3S1SVE_AND_G3S1SV_PASS_INACTIVE_STRIPE_STAGING_2026-10-15.md`, `docs/OWNER_UPDATE_G3S3_STRIPE_APPROVED_NETLIFY_STATIC_2026-10-16.md`, PR #64 G3S1SVE Evidence `docs/evidence/g3s1sv/G3S1SVE_EXECUTOR_EVIDENCE_RECOVERY_ONLY_2026-10-15.md`. The accepted plugin 11.1.0 install was inactive; do **not** reinstall, activate or repeat prior DB restore.
3. Determine without mutating what is needed for **Woo checkout via the Stripe Woo gateway** (which is not automatically Stripe-hosted Checkout): actual plugin activation/connection prerequisites, exact test site origin, order ownership/account path, selected Woo product, Stripe TEST-only webhook route and how authenticated signed test callbacks could reach the local site. `https://birthday-magazine-original.netlify.app/` is a static information site, not the callback endpoint. A proposed tunnel/Stripe CLI is only a plan; do not open one.
4. Inventory current existing backup DB+uploads+plugin state, restoration capability and residual temp ZIPs **without rebuilding/importing/deleting anything**. Report what fresh recovery proof a later gateway-setting write would require.
5. Describe a smallest TEST-mode sandbox matrix: test-only payment success, cancellation/failure, correct Woo order paid/entitlement correlation, signed webhook acceptance and rejected invalid signature, identical-event replay/idempotence, and TEST refund/revocation. Distinguish prior PayPal Sandbox proof from unproven Stripe behavior. Do not run transactions.
6. Record whether local draft intake is still browser memory only, and production generation/secure delivery are not yet ready. Do not conflate payment-test success with a full paid MVP.
7. Do not scan/render Stripe bank account numbers, identity documents, access tokens, OAuth cookies, provider payloads or configuration secrets. Do not write source docs to Git until allowed by established read-only Evidence-only workflow; the sanitized Executor evidence may be appended only within an explicitly authorized evidence path if supported, otherwise return facts to Reviewer for persistence.

## Evidence and stop

Sanitized packet to Reviewer:

```text
结果：PASS_CANDIDATE_G3S3_PREFLIGHT / RETURN_*
改动：只读检查；没有修改任何本机、Stripe、Netlify 或 GitHub 业务配置。
验证：原站与 Woo/Stripe 插件状态、测试链路、当前可恢复性及最小测试方案。
问题：NONE 或具体阻塞及 UNKNOWN。
回滚：没有执行变更；下一轮 Test 写入前仍需新鲜可恢复备份。
请 Reviewer 检查：G3S3 是否满足下一轮 Test-only Gate 准入。
Owner 转交：NONE；或列出需 Owner 在 Stripe 本人账户中确认的非敏感状态/授权。
```

`EXECUTOR_RESULT` is not formal PASS. Do not use this Gate as authorization to enable gateway, configure credentials, charge/refund, alter Stripe account or delete PayPal.
