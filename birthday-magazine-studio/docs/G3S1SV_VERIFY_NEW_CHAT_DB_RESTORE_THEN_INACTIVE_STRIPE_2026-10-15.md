# G3S1SV — Verify successful new-chat local DB restore, then conditionally stage inactive Stripe

> Date: 2026-10-15
> Governance: VPS Project Governance v0.2.7
> Fresh new input: `docs/OWNER_RELAY_G3S1SV_NEW_CODEX_CHAT_DB_RESTORE_SUCCESS_2026-10-15.md`
> Previous HOLD: `docs/G3S1SH_CODEX_POLICY_HOLD_AND_RESUME_CRITERIA_2026-10-15.md`
> Scope: only Owner-local Windows Docker Desktop, no VPS/SSH

## Gate contract

```text
GATE_ID=G3S1SV_VERIFY_NEW_CHAT_DB_RESTORE_THEN_INACTIVE_STRIPE
OBJECTIVE=Correlate the Owner-reported successful exit-0/58-table MariaDB import to the exact existing restricted G3S1S backup and truly isolated target without rerunning valid operations; then, only if full current backup recoverability is proven, install official WooCommerce Stripe Gateway inactive.
MAX_ENDPOINT_THIS_ROUND=Read-only validation of prior new-chat restore + official pinned Woo Stripe extension installed INACTIVE, subject to prewrite backup PASS; otherwise precise RETURN and no install.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner physical Windows local Docker Desktop project birthday-magazine-g3c and existing restricted LocalAppData G3S1S backups; no remote SSH/VPS, production or other services.
APPLICABLE_CRITICAL_CONSTRAINTS=NO_REPEAT_SUCCESSFUL_DB_IMPORT_FOR_EVIDENCE; NO_POLICY_BYPASS_ALTERNATE_TOOL_SHELL_GUI_AGENT_ON_DENIAL; NO_ORIGINAL_DB_MUTATION_OR_VOLUME_RESET; NO_WORDPRESS_REINSTALL_RESTART_UNNECESSARILY; NO_STRIPE_AUTH_ENABLEMENT_TEST_LIVE_PAYMENT_CHECKOUT_WEBHOOK_REFUND; NO_PAYPAL_MUTATION; NO_PUBLIC_TUNNEL; NO_MAIN_OR_PR_MERGE; NO_GIT_RESET_CLEAN; NO_RAW_SQL_OR_PRIVATE_HASH_CREDENTIAL_OR_PII_IN_CHAT_GIT.
PREFLIGHT=Fresh main/PR project-scope Gate/Owner relay, original G3S1S backup Evidence and G3S1SR HOLD; confirm exact Owner Windows local context and project Docker identity; no VPS/SSH; verify current site/DB health and sufficient resources.
REQUIRED_EVIDENCE=EXACT_BACKUP_SOURCE_CORRELATED_TO_PRIVATE_MANIFEST; IMPORT_NATIVE_EXIT_0; TARGET_MARIADB_11_4_7; EXACT_DISPOSABLE_TARGET_AND_NO_ORIGINAL_MOUNTS; TABLE_COUNT_58_OF_58_AND_NON_SECRET_READ_COMPATIBILITY; ORIGINAL_DB_AND_SITE_UNCHANGED; BACKUP_FRESHNESS_AND_COMPLETE_WP_FILES_RECOVERY; IF_INSTALLED_OFFICIAL_STRIPE_SOURCE_VERSION_SHA_COMPATIBILITY_AND_INACTIVE_STATE; NO_PROVIDER_PAYMENT_PAYPAL_MUTATIONS; RETURN_OR_PASS_CANDIDATE_AND_STOP.
ACCEPTANCE_CRITERIA=Same protected source backup restored in truly isolated scratch MariaDB with read compatibility, full current DB+WordPress-files rollback baseline validated; official Stripe extension installed ONLY inactive and gateway unavailable in checkout; original Woo/WordPress/PayPal state preserved. If metadata to prove source/target/isolation cannot be recovered, STOP without reinstall or speculative rerun.
ROLLBACK_STATUS_OR_PLAN=Previously verified WordPress/bind-source files and privately retained DB backup are kept; no overwrite of original DB. Plugin rollback removes only newly installed inactive plugin and its precisely known local files/settings, without changing preexisting Woo/PayPal/orders. If backup freshness fails, take only required new snapshot and validate it in isolated copy before install, or RETURN.
OWNER_ONLY_ACTIONS=NONE for this bounded local inactive staging; Stripe merchant login/entity/KYC/payment and eventual conditional PayPal removal remain separate.
```

## Accepted context

- Existing local WordPress recovered in G3S1R Reviewer PASS, site GET 200, Woo active, original G3C DB/WordPress volumes and containers preserved.
- G3S1S generated protected local file, bind-source, DB backup; WP files/bindings passed isolated extraction; DB SQL ~9.8 MB, 58 InnoDB tables, private checksum verified. Initial isolated MariaDB import exit 1 with no error captured.
- G3S1SR did not execute DB import due to Codex CreateProcess policy refusal, resulting in HOLD. Owner now reports a **new Codex chat successfully imported backup** exit 0 and 58/58 tables. New report is useful but not yet correlated to exact source/target. A new chat does NOT prove exact policy rule or permit any bypass.
- Prior G3C inventory: official Stripe/PPCP absent, legacy Woo PayPal disabled; PayPal G3B Sandbox PASS was separate and is historical. Owner intends PayPal removal only after Stripe full end-to-end PASS, never here.

## Execution in one round

**Phase A: read back success, no replay.**

1. In the new Codex conversation, locate retained native import status, actual command history/process metadata and disposable container identity **only if safely available**, including the exact `wordpress-db-consistent.sql` source location under `$env:LOCALAPPDATA\BirthdayMagazineStudio\G3S1S\20261015T213127-f1ccf9a1`, length and private hash agreement against restricted manifest. If the already-successful scratch container was disposed, use retained evidence from that conversation; do not rerun the import merely for display.
2. Confirm `mariadb:11.4.7`, target `network=none`, only disposable temp storage, **no mounted project named volumes**, true import native exit 0, 58/58 expected table definitions and server-side read compatible with SQL snapshot. Bounded counts without row values; no personal data or secrets output. Confirm original MariaDB/WordPress data volume identity unchanged and current site still serves GET.
3. If the new result cannot prove it is the same private SQL file or isolation, classify `RETURN_SOURCE_OR_TARGET_NOT_CORRELATED`; no Stripe install. If it proves all, record `RESTORE_VERIFIED_SOURCE_CORRELATED`.
4. Freshness: the old backup was created during G3S1S. If live DB has materially drifted since that snapshot, take one fresh native consistent DB backup into restricted local storage, ensure a compatible isolated restore of the SELECTED backup and no destructive actions. Reuse previously verified WordPress/bind-source archive proof unless actual source drift. If impossible, `RETURN_BACKUP_FRESHNESS_OR_ROLLBACK_UNVERIFIED`.

**Phase B: conditional official Stripe plugin install inactive.**

Only if Phase A and protected recovery point demonstrably PASS:
1. Verify WordPress.org official package `woocommerce-gateway-stripe` source/version/hash and compatibility with WordPress 7.1.1, WooCommerce 11.1.2, PHP 8.3.33. Confirm not already installed and not configured with any credentials.
2. Install via normal currently authorized native Codex local tooling to original G3C **inactive only**, with verified rollback and without account connection, API authorization, provider calls, payment/test/live enablement, public route, checkout submission, PayPal modification, DB/WordPress rebuild or PR merge. If policy denies any command before process startup, STOP. No alternate execution route.
3. Verify installed+inactive and not presented as a gateway; original Woo product #1113 USD 39.99, GET-only pages, DB, named volumes and PayPal flags preserved. No paid checkout, webhooks, provider call or orders. Save sanitized Evidence to PR #64 and STOP for Reviewer.

## Relay to Executor

Read only this G3S1SV Gate, latest Owner relay, existing G3S1S backup Evidence at `d0ae16640fe01db90093ca00738c130a6f8a9915`, previous G3S1SR HOLD Evidence at `d13b27fd8290d0575bd3ac7733f3f3039b415a21`, and current project-scoped main/PR refs. **No broad history or VPS discovery.**

New Codex conversation already reports successful DB import. **Do not repeat a successful import solely to collect proof**, and don't claim Reviewer PASS without source/target correlation.

```text
RESULT=PASS_CANDIDATE_G3S1SV_VERIFIED_DB_BACKUP_AND_STRIPE_INACTIVE / RETURN_*
RESTORE_SOURCE=EXACT_PRIVATE_MANIFEST_MATCH / UNKNOWN
RESTORE_IMPORT=REAL_EXIT_0_58_TABLES / OWNER_REPORTED_ONLY / UNKNOWN
RESTORE_TARGET=ISOLATED_AND_NO_PROJECT_MOUNTS / UNKNOWN
CURRENT_ROLLBACK=VERIFIED / UNVERIFIED
STRIPE_GATEWAY=INSTALLED_INACTIVE / NOT_INSTALLED
PROVIDER_PAYPAL_ACTIONS=0
EVIDENCE=PR_64_EXACT_FILE_SHA
STOP_AT_REVIEWER=YES
```
