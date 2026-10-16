# G3S4R — Verified browser target and conditional Stripe TEST-only continuation

> Date: 2026-10-17
> Status: OWNER_AUTHORIZED_CONDITIONAL (new test-only round; no execution yet)
> Parent PASS: docs/REVIEWER_DECISION_G3S4E_PASS_EVIDENCE_PRESERVATION_2026-10-17.md
> Original G3S4 STOP: docs/REVIEWER_DECISION_G3S4_RETURN_BEFORE_STRIPE_TEST_EVIDENCE_PENDING_2026-10-16.md
> Stored Evidence PR #64: docs/evidence/g3s4/G3S4E_RETAINED_PREFLIGHT_AND_BACKUP_RECOVERY_2026-10-16.md @ 7397dd3bb7ab5fe62bb8575185d51405391f2c63
> Governance: entropy-student/spike.skill/main/vps-project-governance/VNEXT.md v0.2.7
> Explicit Owner authorization: docs/OWNER_AUTHORIZATION_G3S4R_SAFE_TARGET_TEST_ONLY_2026-10-17.md (one round; all preconditions remain in force)

## Gate contract

```text
GATE_ID=G3S4R_SAFE_LOCAL_TARGET_AND_STRIPE_TEST_CONTINUATION_20261017
OBJECTIVE=Safely establish exact browser/local Woo target and, conditional on fresh Owner TEST-only permission, complete the previously blocked authentic Stripe TEST payment/webhook/refund loop without rebuilding backup.
MAX_ENDPOINT_THIS_ROUND=Read-only source/runtime/backup-current-integrity check and independently verified browser target -> if safe and Owner specifically authorizes, one bounded Stripe TEST-only connection and synthetic Woo #1113 USD39.99 payment plus signed webhook/replay/negative/TEST refund -> sanitized Evidence -> Reviewer stop.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner Windows 11 original G3C Docker WP/Woo local loopback 127.0.0.1:8189, official Woo Stripe 11.1.0 currently inactive per last report, product #1113 USD39.99 virtual, PR #64 reference, local selected G3S4 protected backup.
APPLICABLE_CRITICAL_CONSTRAINTS=No bypass of Computer Use browser URL uncertainty by changing tool/channel solely to accomplish stopped operation; no live charges/refunds, production/hosting, public WP admin exposure, real customer data, model generation, PayPal retirement, PR merge, source reset or dirty-file deletion, Secret output or credentials in chat/repo. Preserve both backup generations.
PREFLIGHT=New Owner authorization scoped to G3S4R has been explicitly granted and recorded in docs/OWNER_AUTHORIZATION_G3S4R_SAFE_TARGET_TEST_ONLY_2026-10-17.md; actual Executor relay must include approval, and former G3S4 authorization expired upon STOP. Fresh read-only confirm exact original Docker target, runtime-mounted source versus PR and dirty state, Woo/plugin version/status, and selected G3S4 protected backup file presence/size/SHA-256 compared to already retained values. Historical offline restore results may be reused without redoing export/import; command exit statuses remain UNKNOWN. Owner opens the local WP/Woo Stripe settings page in own authenticated browser. Executor must positively independently identify active URL as local loopback and intended WordPress target under its operating-tool policy BEFORE interaction; if URL identification fails, STOP, do not route around policy via shell/API/another browser.
REQUIRED_EVIDENCE=Fresh target/source and original backup integrity readback; recorded prior offline-restoration results and UNKNOWN limitations; separately authorized Owner TEST-mode account identity/consent without Secrets; verified exact browser URL and target; actual Woo Stripe TEST config and callback mode; authentic signed test callback first + invalid signature + replay with correct merchant/order/amount/USD; Woo synthetic Test success/cancel/failure and TEST refund/entitlement revocation; non-target delta; stop; single sanitized Evidence commit.
ACCEPTANCE_CRITERIA=Either authenticated Test-only payment/refund/webhook end-to-end and Woo correlation is proven and stopped for Reviewer, or precise RETURN before any unsafe write. No claim of live payout or finished birthday PDF delivery.
ROLLBACK_STATUS_OR_PLAN=Preserve old and 2026-10-16 selected protected backup. Before provider/Woo mutation compare current selected backup hashes and source with retained evidence; do not recreate already qualified backup unless material change is proven and Reviewer approves a bounded repair. If unexpected provider/DB/browser status, stop, preserve state and reconcile read-only; do not blindly retry payments, reset source or import backup.
OWNER_ONLY_ACTIONS=Explicit Owner approval for this exact G3S4R Test-only round recorded, not yet exercised; any required personal Stripe TEST login/OAuth consent remains Owner-controlled. Owner may navigate to local settings manually, but must not supply credentials/Secrets. No real-money, public hosting or PayPal permission.
REVIEWER_TO_EXECUTOR_RELAY=Read this Gate, explicit Owner authorization docs/OWNER_AUTHORIZATION_G3S4R_SAFE_TARGET_TEST_ONLY_2026-10-17.md, accepted G3S4E PASS and exact PR Evidence, plus current project-owned target config only. Owner approval must be in the actual current relay. Start with target/selected-backup read-only checks and safe browser-identity checkpoint; do not reconstruct project history or redo isolated restore.
EXECUTOR_TO_REVIEWER_RELAY=Report narrow result, actual changes, target/browser identity, Test success/failure/webhook/refund proof or precise stop, backup state and single Evidence-only commit; mandatory Reviewer stop.
```

## Executor sequence

1. Read this Gate and the referenced G3S4E Evidence. Respect the existing 44-file mounted-source match and recorded DB/files offline restore. Freshly verify unchanged source and existing selected backup file hashes only when authorized; do not repeat backup/export/offline restore or source rebuild by default. Existing local dirty/untracked files stay untouched.
2. Confirm the current WordPress/Woo target on loopback. Computer Use is not required by Stripe technically; it is a browser-operation option, not a business prerequisite. The prior Computer Use refusal remains binding: never switch to another tool just to evade URL safety policy. Owner manually opens the correct site administration page and navigates to WooCommerce Stripe settings. Browser-target identity must be independently verifiable under the same control's safety rules. If Computer Use still cannot establish current Edge URL reliably, RETURN_BROWSER_TARGET_UNVERIFIED without using other automation to bypass it.
3. Only after a fresh G3S4R authorization and confirmed target, Owner authenticates and consents in the genuine Stripe TEST account. Do not request or print credentials. Connect ONLY TEST gateway and verify signed callback mode. Any forwarding to localhost must be explicitly limited to TEST, must not publicly expose WP admin/DB and must not conflict with plugin-created webhook secret.
4. Perform one bounded synthetic Woo #1113 USD39.99 TEST purchase; verify provider authenticity and merchant/order/amount/currency mapping, signed first webhook delivery, invalid signature rejection, replay idempotence, failed/canceled state and a TEST refund with appropriate paid-entitlement revocation. No real buyer data or Live activity.
5. Record sanitized results on PR #64, leave original backups and dirty source protected, and STOP for Reviewer. If any prerequisite fails, RETURN at that point. Do not continue into production or auto-generation.

## Executor completion packet

```text
结果：PASS_CANDIDATE_G3S4R_TEST_ONLY / RETURN_*
改动：只报告本轮真正执行的 TEST-only 配置和模拟交易，或无变更。
验证：已确认的本机目标、原备份现时完整性、Stripe 测试模式、签名 Webhook、重复处理、退款。
问题：NONE 或确切阻断点，包括浏览器目标无法验证。
回滚：保存原备份与原有工作区；如异常停止并只读核对，不进行盲目重试。
请 Reviewer 检查：本轮是否具备 Stripe TEST 完整闭环 PASS 证据。
Owner 转交：只在需要时于个人账户自行完成登录和测试授权，无密钥转交。
```