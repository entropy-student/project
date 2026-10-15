# G3S1 — Local Stripe Gateway Staging (No Provider Connection)

> Date: 2026-10-15
> Governance: `vps-project-governance/VNEXT.md` v0.2.7
> Parent: G3S0 readiness classification PASS
> Owner target: Stripe primary, PayPal retirement not authorized
> Purpose: prepare a reversible local-only integration without waiting for Stripe merchant login

## Gate

```text
GATE_ID=G3S1_LOCAL_STRIPE_GATEWAY_STAGING
OBJECTIVE=Restore/read back the retained G3C local WooCommerce lab safely, then stage the official Stripe Gateway as an inactive plugin only if existing installation and rollback checks permit
MAX_ENDPOINT_THIS_ROUND=Existing G3C local runtime healthy and fresh payment-plugin inventory, optionally official WooCommerce Stripe Gateway installed but inactive, with backup/rollback and sanitized evidence
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner physical Windows local G3C project-isolated WordPress/MariaDB/Mailpit containers and local project source/worktree; no Shared VPS or production host
APPLICABLE_CRITICAL_CONSTRAINTS=FRONTEND_VISUAL_FREEZE_YES; WOOCOMMERCE_CANONICAL_YES; STRIPE_CONNECT_OAUTH_0; STRIPE_LIVE_ENABLEMENT_0; STRIPE_TEST_TRANSACTIONS_0; PAYPAL_DISABLE_UNINSTALL_0; CHECKOUT_SUBMISSION_0; REFUNDS_0; PROVIDER_CALLS_0; PUBLIC_TUNNELS_0; PRODUCTION_DEPLOY_0; PR64_MERGE_0; SHARED_INFRA_MUTATIONS_0; MODEL_CALLS_0
ROLLBACK_STATUS_OR_PLAN=Retain stopped-container/volume identity; before plugin mutation verify DB-consistent backup + local plugin/files state and read-back; if needed remove only this Gate's newly installed inactive Stripe plugin and restore only its changed local records/files
OWNER_ONLY_ACTIONS=NONE if exact local G3C identity and recoverability can be independently established; Stripe account login, country/entity and Test OAuth deferred to a later Gate
```

## Authority

1. This Gate and `docs/REVIEWER_DECISION_G3S0_PASS_READINESS_WITH_RUNTIME_UNKNOWN_2026-10-15.md`
2. `docs/OWNER_DECISION_G3S_STRIPE_PRIMARY_PAYPAL_RETIREMENT_DEFERRED_2026-10-15.md`
3. `docs/MVP_PRODUCT_CONTRACT.md` payment-before-generation and frozen intake rules
4. current PR #64 source and current project-scoped `main`

## Phase 0 — fresh identity and conditional STOP

- Fresh-read PR #64/main project scope. Do not reset/rebase/merge or try to resolve old PR conflicts.
- Prove execution is the Owner's actual Windows local G3C lab, not an isolated runner, temporary sandbox or unrelated Docker daemon. Record only sanitized host/runtime identity.
- Read actual Compose project, three existing container identities, mounted app/data volumes, stopped/running status, image/version, networks and host ports before mutation.
- Confirm no real-money/live production service, other project volume or provider callback is routed to those ports.
- Treat unexpectedly missing containers, database data or mounts as `RETURN_TARGET_OR_STORAGE_UNKNOWN`, not grounds to create blank replacements.

## Phase A — start retained services & inventory

If Phase 0 identity is safe, allow **start of existing stopped G3C containers only**. No `docker compose up` if it would recreate/pull/build/create services; no `down`, volume deletion, network recreation, or shared resource changes.

- Inspect resource headroom.
- Start only the same existing containers with unchanged mounts/env/image and project isolation.
- Post-start separately verify container/process, HTTP site, WordPress/DB connectivity, Woo plugin and product metadata.
- Fresh-read installed/active plugin list and payment gateway **enabled/test/live flags** in a redacted format. Do not read/export keys, webhook secrets, emails, order PII, full configuration dumps or Provider logs.
- Classify PPCP and Stripe Gateway presence and any unknown pre-existing Stripe install/connection.
- Verify Owner-accepted homepage/intake remain functional, using one minimal GET smoke; do not replay expensive historical screenshots.

If any plugin appears to have a pre-existing Stripe live/test connection, changes to gateway settings, unexpected data, or active production endpoint, RETURN before install.

## Phase B — backup barrier before changing WordPress/plugin state

- Identify all durable project-local WordPress DB/uploads/config/plugin sources; preserve full volume identity.
- Create a consistent DB backup and file/plugin manifest for the exact G3C lab, with restricted local storage and no upload to GitHub or ordinary logs.
- Verify backup artifact existence, integrity/restore **compatibility** with the known target, and a feasible scoped rollback path. For a writable test backup restore, use only an isolated copy, never overwrite the retained DB.
- If backup/recovery cannot be verified with the real local tools, `RETURN_BACKUP_OR_ROLLBACK_UNVERIFIED`, no plugin install.

## Phase C — official Stripe Gateway staging only

- If `woocommerce-gateway-stripe` is already present or activated, do not reinstall, overwrite, downgrade or change its settings. Report precise non-secret current version/status and STOP at Reviewer if any prior Stripe account connection requires reconciliation.
- Otherwise download a **specific official stable release** of `woocommerce-gateway-stripe` via official WordPress.org repository; pin exact version, verified source URI, downloaded SHA256 and supported WP/Woo/PHP compatibility. No arbitrary fork or latest-version drift.
- Install only in this retained isolated local G3C WordPress lab as an **inactive plugin**. No account connection, OAuth, API key, dashboard login, Test/Live settings changes, public Webhook, or checkout.
- Existing PPCP/PayPal and Woo account/payment state stay untouched. New Stripe gateway must remain **not available for checkout**.
- Prefer existing project-scoped file/WordPress installation path; if technical installer necessarily changes plugin metadata, list precise non-secret deltas.
- Never put DB dumps, live keys, customer data, or secrets into repo/Evidence.

## Validation

- Report the exact final installed package version/hash and inactive state.
- Fresh-read account/payment gateway flags without secret values.
- Homepage, intake and existing Woo checkout entry render at baseline; product 1113 remains virtual USD39.99 if fresh read-back supports it.
- No Stripe provider network action or webhook setup, no Test/Live transaction, no PayPal disable/removal, no generation job.
- Preserve all old G3C mounts, containers, DB records and existing Owner-frozen frontend.
- Same-target runtime and local plugin readback; rollback/provenance recorded.

## Required Evidence

```text
SOURCE_AND_PROJECT_FRESHNESS
TARGET_LOCAL_IDENTITY
STOPPED_CONTAINERS_AND_RETAINED_VOLUMES_PRESTATE
POST_START_CONTAINER_HTTP_DB_WOO_READBACK
PLUGIN_AND_GATEWAY_INVENTORY_SANITIZED
PRE_INSTALL_DB_BACKUP_AND_RECOVERY_PROOF
OFFICIAL_STRIPE_GATEWAY_PINNED_VERSION_SOURCE_SHA256
FINAL_INSTALLED_INACTIVE_STATE
PAYPAL_BASELINE_UNCHANGED
WOOCOMMERCE_PRODUCT_AND_FRONTEND_SMOKE
NO_PROVIDER_PAYMENT_AUTH_OR_TUNNEL_ACTIONS
ROLLBACK_SCOPE
STOP_AT_REVIEWER=YES
```

If original containers cannot be safely restarted or plugin install is blocked, preserve successful subchecks and RETURN exact cause. No repeated start/restore/install loop.

## Acceptance criteria

`PASS_CANDIDATE_G3S1` requires real target-local runtime identity + safe retained service startup; fresh plugin/gateway inventory; verified backup and recoverability; and when absent, official Stripe Gateway installed in inactive state with no Provider or checkout mutation. If plugin already exists, classify it and return for Reviewer routing rather than declaring an install success.

A successful G3S1 **does not establish** merchant eligibility, Stripe OAuth/connection, actual webhook delivery, test payment, refund or real payout.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:
1. this Gate;
2. parent Reviewer G3S0 decision;
3. Owner Stripe provider decision;
4. current G3C local Compose/WordPress/Gateway metadata and exact related source;
5. original G3S0 Executor inventory claims as preflight context only;
6. official WordPress.org Stripe gateway package metadata.

No broad governance/project-history reread. Do not read Secrets. No payment or provider actions. No public tunnel.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_G3S1 / RETURN_*
改动：安全恢复现有 G3C 本地容器并核对运行态；如需且有完整备份，再将官方 Stripe Gateway 以未激活状态安装到本地。
验证：实际本机/卷/容器身份、Woo/plugin/gateway fresh readback、备份/恢复可行性、插件版本和 SHA、前端及商品 smoke、Provider/支付/公网操作为零。
问题：NONE，或准确的运行态/备份/插件障碍。
回滚：既有 DB/卷/PayPal 证据完整保留；本轮新增内容可精确回退。
请 Reviewer 检查：实际 runtime readback + backup evidence + 官方插件来源/未激活状态。
Owner 转交：NONE。
```

## Stop boundary

Stop after local inactive staging. Do not connect Stripe, set up Test webhooks/HTTPS public routing, initiate Test checkout/refund, disable PayPal, save any bank data, build prepayment backend, merge PR #64 or deploy production.
