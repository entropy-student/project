# G3S1SR — One-round isolated DB restore diagnosis, then conditional inactive Stripe staging

> Date: 2026-10-15
> Governance: vps-project-governance/VNEXT.md v0.2.7
> Parent Reviewer decision: `docs/REVIEWER_DECISION_G3S1S_RETURN_BACKUP_RESTORE_UNVERIFIED_2026-10-15.md`
> Prior G3S1S Evidence: PR #64 `docs/evidence/g3s1s/G3S1S_POST_RECOVERY_OFFICIAL_STRIPE_GATEWAY_INACTIVE_STAGING_2026-10-15.md` at `d0ae16640fe01db90093ca00738c130a6f8a9915`
> Parent accepted local runtime: G3S1R PASS. Owner conditional PayPal retirement remains future only.
> Reviewer stop: mandatory. This is a **new** Gate, not an attempt to override the previous RETURN.

## Gate contract

```text
GATE_ID=G3S1SR_DB_RESTORE_DIAGNOSTIC_CONDITIONAL_STRIPE_INACTIVE
OBJECTIVE=Determine why a private 9.8MB MariaDB consistent dump failed to import into an isolated scratch instance and prove a restorable current recovery point; only after objective full backup PASS, stage official WooCommerce Stripe Gateway as an inactive plugin in existing local G3C.
MAX_ENDPOINT_THIS_ROUND=One fault-domain DB import reproduction with safe error classification and at most one evidenced correction in disposable isolation; if recovered and all prewrite barriers verified, official plugin installed inactive only; then stop at Reviewer.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner physical Windows 11 Codex desktop, existing Docker Desktop desktop-linux, exactly project birthday-magazine-g3c; private backup in Owner LocalAppData; scratch MariaDB 11.4.7 with network none/tmpfs only, never mounted to original volumes.
APPLICABLE_CRITICAL_CONSTRAINTS=NO_LIVE_DB_SQL_MUTATION_OR_RESTORE; NO_ORIGINAL_VOLUME_DELETE_RECREATE_REBIND; NO_WORDPRESS_REINSTALL_OR_RESTART; NO_ALTERNATE_EXECUTOR_COMMAND_SHELL_API_GUI_AGENT_ON_POLICY_DENIAL; NO_PERMISSION_OR_TOOL_POLICY_CHANGE; NO_STRIPE_CONNECTION_ACCOUNT_OAUTH_TEST_LIVE_ENABLEMENT_CHECKOUT_WEBHOOK_PAYMENT_REFUND; NO_PAYPAL_PLUGIN_OR_SETTINGS_CHANGE; NO_PUBLIC_TUNNEL_OR_SHARED_INFRA; NO_GIT_CLEAN_RESET_REBASE_MERGE; NO_RAW_DB_DUMP_SECRETS_PII_OR_CREDENTIALS_IN_GIT_LOG_CHAT; NO_FRONTEND_REDESIGN.
PREFLIGHT=Fresh exact main/PR project scope and source provenance; read this Gate, parent RETURN and G3S1S Evidence only; verify normal authorized same Owner-host executor, original G3C healthy and backup artifacts' protected physical existence/checksums without printing contents; original container/volume identities and private port same; inspect permitted previous command/error stage from safe private metadata if any.
REQUIRED_EVIDENCE=FRESH_SOURCE_AND_NATIVE_TARGET; PREVIOUS_IMPORT_ERROR_UNKNOWN_ACKNOWLEDGED; EXISTING_PRIVATE_BACKUP_FILES_AND_HASHES_CHECKED_PRIVATELY; ISOLATED_DB_SERVER_READINESS_AND_IMPORT_CONTRACT; EXACT_NATIVE_EXIT_AND_ALLOWLISTED_FAILURE_CLASS_WITH_PHASE; TABLE_DEFINITION_COUNT_AND_READ_COMPATIBILITY_AFTER_RESTORE; SOURCE_CURRENT_BACKUP_FRESHNESS_OR_REFRESHED_CONSISTENT_SNAPSHOT; WP_FILE_AND_BINDING_RECOVERY_REUSE; ORIGIN_DB_NOT_MUTATED; IF_STRIPE_STAGE_OFFICIAL_SOURCE_VERSION_SHA_COMPATIBILITY_AND_INACTIVE_NO_PROVIDER_NO_PAYPAL_DELTA; ROLLBACK_PLAN; EVIDENCE_AND_STOP.
ACCEPTANCE_CRITERIA=Recovered database dump imports to a disposable identical-version MariaDB target with native exit 0; non-secret table/schema and bounded record-count/read compatibility align with source backup; current DB+file recoverability barrier valid before any plugin write. If plugin is installed, official compatible pinned Stripe extension remains **inactive**, no gateway offers/PayPal settings/provider actions, original site and product smoke preserved.
ROLLBACK_STATUS_OR_PLAN=All failed import attempts affect disposable network-isolated tmpfs only; preserve original data and existing private backups. Conditional plugin stage requires verified current DB backup + WordPress files/bind source recoverability; if permitted, reverse only newly installed inactive plugin files/records, never restore/overwrite original DB automatically.
OWNER_ONLY_ACTIONS=NONE for approved local isolated recovery test and conditional inactive official plugin stage. Owner controls any later provider account/KYC/Stripe Test/Live/real money. A future PayPal retirement needs full Stripe end-to-end PASS and separate exact-target review.
```

## Accepted evidence, no replay

1. Local G3C WP/Woo restored and independently Reviewer accepted in G3S1R: WordPress+DB running, WP-CLI running, Mailpit stopped; loopback 8189 site/products functioning, exact four project container identities/two named volumes/network retained.
2. G3S1S created private ACL-restricted backups under Owner `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S1S\20261015T213127-f1ccf9a1` (absolute username omitted). DB `wordpress-db-consistent.sql`, ~9,802,953 bytes, SHA-256 matched private manifest; 58 InnoDB tables. WP files ~126MB and bound source files ~23.7MB both passed isolated extraction/read and private checksum. Do not rearchive them automatically. Preserve the backup set even if invalid for full restore.
3. Isolated MariaDB 11.4.7 restore command returned **exit 1**, but stdout/stderr and failing phase were not retained. Cause `UNKNOWN`, even though `wp db check` separately gave a self-signed TLS client error. **Do not equate these separate events without evidence** and do not assume dump corruption.
4. The next sanitized diagnostic command was blocked at executor process-creation policy; no bypass. Original Woo/product/pages/PayPal and Stripe remained unchanged and no Stripe package was downloaded.
5. G3C currently has no official PPCP or Stripe extension; legacy Woo PayPal option disabled. Historical G3B PayPal Sandbox PASS is retained separate. Future Owner PayPal retirement conditional decision is unaffected.

## Phase A — bounded one-fault-domain isolated DB diagnostic

1. **Read-only analysis first.** From existing privately retained non-secret command metadata (if any), classify prior command invocation/import phase, target DB creation, container/server readiness, client/library compatibility, SQL encoding/collation/definer issues and TLS/auth settings. Never read/print secret-bearing SQL or config to chat/repo. Do not repeat a denied command simply to see if policy changed.
2. Preflight a single **new independent isolated recovery rehearsal** designed to supply what prior Evidence lacked: MariaDB image/digest/version match; disposable container/DB with `network=none`, tmpfs only, no project/host volume mounts; server lifecycle and ready-state proof; correct target database/schema creation; compatible import client and STDIN/path; expected binary-safe input; output capture into a restricted private local temp outside Git. Verify output sanitization of SQL/client errors **before** displaying any lines.
3. Perform **at most one diagnostic import** of an immutable private copy of the existing verified dump. Record native exit code, failure stage, stable normalized MariaDB error **class/code/SQLSTATE if available**, and redacted brief cause; don't emit raw line text, SQL statements, identifiers from private data, emails, passwords, paths containing usernames, or credentials. Sanitize inside protected local boundary before Git/chat. If the normal execution tool blocks process creation at any point, STOP as `RETURN_EXECUTION_POLICY_BLOCKED_DB_DIAGNOSTIC`, with no alternate shell/API/GUI/agent and no plugin action.
4. If first import fails with an **unambiguous, reversible scratch-only environment/command-contract error** (e.g. DB not created, MariaDB not ready, target client auth/TLS contract mismatch), allow at most **one** corrected isolated rehearsal using a **new disposable tmpfs instance**, same immutable private SQL input, and normal approved command channel. Explain precisely which observation justifies it. No speculative second attempt, no changes to the dump's SQL to make a test pass, and no live DB settings/permission edits. If failure is unknown, SQL dump appears truncated/incompatible, or correction would affect real data: `RETURN_DB_IMPORT_ROOT_CAUSE_UNRESOLVED`.
5. On import exit 0, assert MariaDB server reads all expected application table definitions, InnoDB schema and bounded non-secret row/table counts compared against snapshot time; do not sample, print or export customer/order/credentials. Confirm isolated instance uses no real G3C mounts and original DB remains healthy. Delete only exact disposable scratch container/files after capturing sanitized results. Preserve existing private backups.

## Phase B — recovery barrier and **conditional** Stripe inactive staging

Only enter this phase if Phase A proves a DB restore compatible with the existing preserved dump, **no** tool-policy denial, no ambiguous temporary mutations, and expected post-import schema checks pass.

1. Fresh-check original project DB and WordPress file identity and compare backup snapshot age/drift. If the old dump no longer represents a defensible pre-install recovery point, take **one fresh** consistent private DB snapshot with same approved `mariadb-dump --single-transaction --quick` and verify THAT selected snapshot in isolated disposable MariaDB 11.4.7 with native exit, schema/count compatibility and hash; keep original archived snapshot. Refresh WordPress-files manifest only if material file drift is proven; reuse previously verified extraction otherwise. Failed fresh restore -> STOP before plugin stage.
2. Record exact protected local backup set for rollback and verified restore compatibility (no raw data in Evidence); establish non-secret WordPress plugin baseline, Woo current state and source integrity. If any backup invariant fails: `RETURN_BACKUP_OR_ROLLBACK_UNVERIFIED`.
3. Recheck absence of official Stripe plugin and no pre-existing live/test provider connection. Verify official stable WordPress.org `woocommerce-gateway-stripe` package provenance/version/SHA256 and WP 7.1.1, PHP 8.3 and Woo 11.1.2 compatibility; **no package download/install before restore PASS**. If absent, install into existing local WP as **inactive only**, never configure/connect/activate it, never switch checkout or pay. If already present or unexpected account/payment state, STOP for Reviewer; do not modify.
4. Verify plugin installed, INACTIVE and not offered as a payment method; product 1113 virtual USD39.99 and minimal GET-only homepage/intake/product/cart/account smoke unchanged, DB/WP resources stable, PayPal plugin and gateway flags unchanged, no new providers/tunnels/webhooks/checkout/orders/refunds. Record precise new plugin file delta and recovery/rollback invariant.
5. Save sanitized Evidence to PR #64 and STOP for Reviewer. Do not continue to account onboarding, Test/Live mode, money movement, later Gates, or PayPal retirement.

## Fail-closed and signal quality

- Both scratch attempts are optional; **maximum one new diagnostic import plus one justified environment-only correction**. No continuing attempts if policy blocks.
- A previous `exit 1` without stderr is not enough to diagnose database corruption. No script may translate a failed native command to a synthetic success; record process-start status/exit code separately from SQL import outcome.
- The sanitized exact error **class/phase** must be preserved when a failure occurs. If even error classification cannot be captured safely, STOP with `RETURN_DB_IMPORT_CAUSE_UNKNOWN` rather than hiding the failure.
- Never repair dump contents, run SQL into original site, drop schemas on original database, disable TLS/security globally, install fallback payment software, run plugin installer, or restore from backup into the original site to test it.
- Preserve the protected local evidence artifacts outside Git, don't commit backup bytes or secret-bearing hashes. Rollback status stays PARTIAL until DB import is proven.

## REVIEWER_TO_EXECUTOR_RELAY

Start with:
- This Gate and `docs/REVIEWER_DECISION_G3S1S_RETURN_BACKUP_RESTORE_UNVERIFIED_2026-10-15.md` on fresh main.
- Prior PR #64 `docs/evidence/g3s1s/G3S1S_POST_RECOVERY_OFFICIAL_STRIPE_GATEWAY_INACTIVE_STAGING_2026-10-15.md` at `d0ae16640fe01db90093ca00738c130a6f8a9915`.
- Current PR #64/main **project-scoped** diff and G3C Compose/plugin identifiers only if needed.
- Existing Owner-local restricted backup bytes in the recorded G3S1S backup directory, **never exported**.

Do NOT reread unrelated project history or re-run previously accepted WordPress/file restoration. The intent is to resolve exactly one DB import error, and if proven correct, complete Stripe inactive staging without waiting for another routine Gate.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_G3S1SR_DB_RECOVERY_AND_STRIPE_INACTIVE / RETURN_*
改动：隔离 DB 恢复诊断（至多一次纠正）；只有备份全部验证后才安装未激活 Stripe 插件。
验证：真实错误阶段/错误类别、数据库隔离导入退出码与表数量、备份恢复兼容性和原网站状态、Stripe 官方版本与 inactive 标志或不适用原因。
问题：NONE，或一个有证据的阻塞原因。
回滚：仅涉及隔离恢复容器与必要时新装的 inactive Stripe 插件；原数据卷、数据库和 PayPal 均保留。
请 Reviewer 检查：脱敏 Evidence、DB 恢复证据、备份可恢复性、插件未启用状态。
Owner 转交：NONE。
```

## STOP

One bounded round. Policy denial -> STOP. Unknown DB import cause -> STOP. Existing business/payment/Stripe credentials remain untouched. The user has already approved only eventual PayPal retirement after complete Stripe end-to-end PASS, not in this Gate.
