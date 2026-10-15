# G3S1S — Official Stripe Gateway inactive local staging after G3S1R runtime PASS

> Date: 2026-10-15
> Governance: VPS Project Governance v0.2.7
> Parent PASS: `docs/REVIEWER_DECISION_G3S1R_PASS_LOCAL_RUNTIME_RESTORED_2026-10-15.md`
> Original unfinished staging intent: `docs/G3S1_LOCAL_STRIPE_GATEWAY_STAGING.md`
> Owner Stripe intent: `docs/OWNER_DECISION_G3S_STRIPE_PRIMARY_PAYPAL_RETIREMENT_DEFERRED_2026-10-15.md`

## Gate contract

```text
GATE_ID=G3S1S_POST_RECOVERY_OFFICIAL_STRIPE_GATEWAY_INACTIVE_STAGING
OBJECTIVE=From the now-running original local G3C WordPress/Woo runtime, safely establish a restorable local backup barrier and, only if still absent, install the official pinned WooCommerce Stripe Gateway plugin INACTIVE, without any provider account, checkout or PayPal change.
MAX_ENDPOINT_THIS_ROUND=Verified original local G3C runtime + restorable project-scoped DB/files backup + official Stripe extension staged inactive (or pre-existing state classified for Reviewer).
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner Windows Docker Desktop G3C project birthday-magazine-g3c, existing WordPress container and named volumes; same canonical project source and permitted existing WP-CLI. No production/Shared VPS.
APPLICABLE_CRITICAL_CONSTRAINTS=NO_STRIPE_PROVIDER_CONNECTION_AUTH_OAUTH; NO_STRIPE_TEST_LIVE_GATEWAY_ENABLEMENT; NO_PAYMENT_OR_REFUND_OR_CHECKOUT_SUBMISSION; NO_WEBHOOK_TUNNEL_PUBLIC_ROUTE; NO_PAYPAL_SETTINGS_OR_PLUGIN_MUTATION; NO_WORDPRESS_WOOCORE_REINSTALL; NO_CONTAINER_VOLUME_NETWORK_RECREATE_OR_DELETE; NO_GIT_RESET_CLEAN_REBASE_MERGE; NO_FRONTEND_CONTENT_DESIGN_CHANGE; NO_MODEL_CALLS; NO_CUSTOMER_DATA_OR_SECRETS_IN_GITHUB_OR_CHAT.
PREFLIGHT=Fresh current main/PR project-scope Gate/Handoff checks; read G3S1R PASS and its immutable Evidence; verify current physical Windows local Docker identity, exactly retained four G3C containers, stable volumes/mounts/private ports, DB and HTTP/Woo healthy, resource headroom; redacted plugin/gateway inventory. No repeated WordPress start if already healthy.
REQUIRED_EVIDENCE=FRESH_SOURCE_AND_LOCAL_TARGET; WORDPRESS_DB_HTTP_WOO_BASELINE; REDACTED_PPCP_STRIPE_PLUGIN_AND_GATEWAY_FLAGS; EXACT_PRESERVED_VOLUMES_AND_MOUNTS; PRECHANGE_DB_CONSISTENT_BACKUP_FILES_MANIFEST_INTEGRITY_RESTORE_COMPATIBILITY; OFFICIAL_STRIPE_PLUGIN_SOURCE_VERSION_CHECKSUM_WP_WOO_PHP_COMPATIBILITY; INSTALL_INACTIVE_AND_NOT_CHECKOUT_OFFERED; UNCHANGED_PAYPAL_WOO_PRODUCT_FRONTEND_SMOKE; NO_PROVIDER_PAYMENT_NETWORK_PUBLIC_ACTIONS; ROLLBACK_SCOPE_AND_REVIEW_STOP.
ACCEPTANCE_CRITERIA=Real G3C same-target healthy; recoverability barrier verified before any install; official WordPress.org Stripe gateway installed (if initially absent) as inactive only, no provider settings/checkout offer, baseline app/PayPal and Woo product preserved; no forbidden side effects. A pre-existing plugin or unresolved recovery condition returns for Reviewer.
ROLLBACK_STATUS_OR_PLAN=Pre-install consistent local DB snapshot + WordPress durable files/plugin/uploads/config manifest, stored privately outside Git and validated for integrity/restore compatibility; rollback removes only this round's newly staged inactive plugin and restores only known changed local files/DB state if explicitly reviewed, never overwrites unrelated DB or payments.
OWNER_ONLY_ACTIONS=NONE for local inactive staging if Gate safety criteria met. Stripe merchant account login, KYC/KYB, country/entity, Test OAuth/webhook and any payment remain separate later Owner checkpoints.
```

## Accepted facts — do not replay

- G3S1R Reviewer PASS accepted **local WordPress/Woo smoke only**, not provider test readiness.
- Original WordPress, DB, named volumes and network retained. Last Executor reading: DB running/healthy, WP running, WP-CLI running, Mailpit stopped; WordPress loopback 127.0.0.1:8189.
- Read-only GET: homepage/intake/product/cart/My Account 200, checkout empty-cart 302, private unauthenticated 403. Product 1113 virtual USD39.99. Do not repeat frontend design QA/screenshots or historical PayPal transactions.
- Local WP-CLI inventory after recovery: WooCommerce active; **PPCP and Stripe official extensions not present**; legacy Woo PayPal disabled. Historical PPCP success took place in **separate G3B Sandbox environment which was cleaned up**. This is not evidence of a broken G3C PayPal plugin or a mandate to reinstall PayPal. Existing Owner decision forbids PayPal removal/config mutation.
- Parent G3S1R had no plugin/data change, so no new backup was required in that **recovery Gate**. **This Gate does require a validated backup BEFORE plugin mutation.**

## Phase A — fresh baseline and flags (read-only)

1. Use current main Handoff + this Gate + G3S1R accepted decision/evidence, plus relevant G3C source/plugin metadata only. Fresh-check PR #64 and main *only project-scoped changes*. Keep unrelated dirty source untouched.
2. Check real Owner Windows host, `desktop-linux`, exact retained G3C resources, available disk/memory and WordPress/Woo health. Do not start/recreate any missing resource automatically; return precise cause if unhealthy.
3. Redacted WP-CLI list of installed/active plugin names+versions and Woo payment gateway booleans; no keys/options dump/order/customer identity. If **Stripe Gateway is already present**, or prior Stripe account/test/live settings exist, STOP and report current redacted state for Reviewer; no overwrite, downgrade, activation or settings edit.
4. Confirm PayPal PPCP absence is consistent with *current G3C baseline*. Preserve whatever existing Woo/PayPal settings actually exist without modifying them; no effort to re-create historical G3B sandbox environment.

## Phase B — safe backup barrier

1. Identify durable DB and WordPress files/plugins/config/uploads, each volume and read-only bind source; protect unique current business data, even in a local test lab.
2. Create a DB-consistent backup with an approved MariaDB-compatible mechanism and separate WordPress files/manifest/recovery record, restricted local target storage **outside Git**. Do not expose data, credentials, user records, hashes of secrets or raw provider logs.
3. Verify created backup exists, integrity, correct source/target and parse/read/restore compatibility. A writable restore rehearsal, if warranted and safe, occurs only on a **disposable isolated copy**, never the retained site. Preserve exact rollback sequence to prior healthy G3S1R baseline. If integrity/restore compatibility unverified: `RETURN_BACKUP_OR_ROLLBACK_UNVERIFIED`, do not install.

## Phase C — official *inactive* plugin only (conditional)

1. Fetch official stable `woocommerce-gateway-stripe` from WordPress.org, pin exact version/official source URL, downloaded SHA256, and verify compatibility with running WordPress 7.1.1 / Woo 11.1.2 / PHP 8.3. If official source unavailable or compatibility fails: RETURN, no guess/fork.
2. If still absent, install ONLY as **inactive plugin** through authorized existing WordPress project tooling, retaining original files/DB and existing PayPal settings. Do **NOT** configure it, connect any account, use test/live API keys, enable the gateway, login to provider, open HTTPS tunnels, or run a checkout/transaction.
3. Postcheck WP-CLI plugin **inactive** and redacted Woo gateway flags show not offered in checkout. Check no new provider requests/tunnels and unchanged PPCP/legacy PayPal state. Product 1113 virtual USD39.99 and homepage/intake/cart/my-account GET baseline, no paid order. Record exact file/plugin differences and backup rollback details.
4. Store detailed sanitized Evidence in project PR #64, STOP at Reviewer. **No automatic next Gate or real payment.**

## REVIEWER_TO_EXECUTOR_RELAY

Read only:
- this Gate;
- `docs/REVIEWER_DECISION_G3S1R_PASS_LOCAL_RUNTIME_RESTORED_2026-10-15.md`;
- PR #64 `docs/evidence/g3s1/G3S1R_ONE_ROUND_WORDPRESS_LOCAL_RECOVERY_2026-10-15.md` at `ee03136537fdf9fda9ee36022261f84ba78dca93`;
- current G3C Compose/WordPress plugin metadata and official WordPress.org Stripe gateway package metadata;
- current PR/main project-scoped refs.

Do not reread Governance or broad project history. Full parent G3S1 document is background only; the current G3S1S Gate controls actions.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_G3S1S_INACTIVE_STAGED / RETURN_*
改动：只做验证备份 +（条件满足时）安装未激活的官方 Stripe 插件。
验证：本机原 WordPress/Woo 状态、DB/文件备份可恢复、官方版本/SHA/兼容性、插件未激活、PayPal/商品/网页状态不变。
问题：NONE，或准确的一个阻塞原因。
回滚：只回退本轮新插件，保留原数据与收款配置；注明备份完整性状态。
请 Reviewer 检查：脱敏 Evidence 的备份真实性、插件来源与未激活状态、无支付副作用。
Owner 转交：NONE。
```

## STOP

Do not create a Stripe account, enter legal entity/bank info, connect Test/Live, set up webhook, submit checkout, perform payment/refund or revoke entitlements, alter PayPal, call AI provider, publish site or merge PR #64. No broad installer/recreate/restart loop.
