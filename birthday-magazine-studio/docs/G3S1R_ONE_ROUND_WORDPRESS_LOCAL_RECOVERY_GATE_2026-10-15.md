# G3S1R — One-round local G3C WordPress recovery (conditional repair only)

> Date: 2026-10-15
> Governance: vps-project-governance v0.2.7
> Owner authority: `docs/OWNER_DECISION_G3S1R_ONE_ROUND_LOCAL_RECOVERY_2026-10-15.md`
> Supersedes current G3S1P waiting checkpoint for this single round; G3S1 Stripe staging remains ON HOLD
> Executor: Codex Windows desktop after Owner-reported restart and previously enabled Full Access
> Reviewer stop: MANDATORY

## Gate contract

```text
GATE_ID=G3S1R_ONE_ROUND_WORDPRESS_LOCAL_RECOVERY
OBJECTIVE=Restore the previously retained Owner-local G3C WordPress/WooCommerce site in one bounded execution round: try normal start once; if a real application/container defect is proven and safe backup verified, apply at most one minimal app-only repair or reinstall; validate existing buyer-flow read-only.
MAX_ENDPOINT_THIS_ROUND=Local retained/repaired WordPress and needed existing helper service healthy on loopback with Woo/private frontend smoke, non-secret payment gateway inventory, and unchanged durable data; no Stripe installation.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner physical Windows 11 local Docker Desktop context desktop-linux, Compose project birthday-magazine-g3c, original 4 project containers / 2 named volumes / private network / PR #64 mounted source only.
APPLICABLE_CRITICAL_CONSTRAINTS=NO_EXECUTOR_POLICY_BYPASS; NO_NEW_AGENT_SHELL_DOCKER_API_OR_GUI_REROUTE_ON_DENIAL; ONE_NORMAL_START_ATTEMPT_AFTER_CLIENT_RESTART; REPAIR_ONLY_IF_ACTUAL_WORDPRESS_DEFECT_PROVED; NO_DB_RESET_RESTORE_OVERWRITE; NO_NAMED_VOLUME_DELETE_RECREATE; NO_WP_CONTENT_CONFIG_UPLOADS_PLUGINS_THEMES_OVERWRITE; NO_REPLACE_PAYPAL_OR_STRIPE_FLAGS; NO_PAYMENT_PROVIDER_AUTH_CHECKOUT_REFUND_WEBHOOK; NO_PUBLIC_TUNNEL; NO_SHARED_PRODUCTION_INFRA; NO_GIT_RESET_CLEAN_MERGE; NO_FRONTEND_VISUAL_CHANGES; NO_SECRET_OR_PII_OUTPUT.
PREFLIGHT=Read current Owner decision and this Gate; fresh project-scoped main/PR read using already working GitHub connector methods; same real Windows/approved Codex execution surface/Full Access Owner report; sanitize Docker context, exact container identities/images/mounts/projects, volume contents presence without disclosing data, health, loopback port ownership and resource headroom. Unknown data ownership fails closed.
REQUIRED_EVIDENCE=FRESH_PR_MAIN; REAL_LOCAL_TARGET_AND_EXECUTOR_CHANNEL; FOUR_ORIGINAL_CONTAINER_IDENTITY; VOLUME_NETWORK_MOUNT_DATA_PRESERVATION; NATIVE_POLICY_START_RESULT; PRE_AND_POST_DOCKER_HEALTH; WORDPRESS_HTTP_AND_WOO_READBACK; PAYMENT_GATEWAY_FLAGS_REDACTED; ANY_APP_REPAIR_CAUSE_PRECHANGE_DB_AND_FILES_BACKUP_INTEGRITY_ROLLBACK_IMAGE_SOURCE; NO_FORBIDDEN_ACTIONS; OWNER_RELAY; REVIEWER_STOP.
ACCEPTANCE_CRITERIA=WordPress HTTP on loopback + functional homepage/intake/Woo checkout GET, Woo active and product metadata where available; pre-existing durable DB/WordPress data preserved; no forbidden mutations; any repair fully evidenced and restorable. Even Executor PASS_CANDIDATE is not Reviewer PASS.
ROLLBACK_STATUS_OR_PLAN=Normal existing-container startup: retain identities/volumes and observe. Conditional repair: verified consistent local DB backup plus recoverable WordPress volume/config/plugin/uploads snapshot and exact previous image/container manifest BEFORE any replace/core repair; restriction outside Git repo; scoped rollback never overwrites existing live data automatically. If backup fails, RETURN.
OWNER_ONLY_ACTIONS=Owner already authorized local app-only repair if WordPress genuinely damaged, preserving all existing DB and unique content. Any wider destructive action or policy change requires a separate Owner decision; it is NOT authorized here.
```

## Fixed accepted baseline (Executor MUST fresh-check target before a write)

- Exact old G3C container ID prefixes from G3S1D: `db=361d58eb5454`, `wordpress=21892d72baeb`, `mailpit=35d286e7af50`, `wpcli=de9742647e06`.
- Named volumes: `birthday-magazine-g3c_database`, `birthday-magazine-g3c_wordpress`; bridge network: `birthday-magazine-g3c_private`.
- Images: MariaDB 11.4.7, WordPress 7.1.1/PHP8.3 Apache, Mailpit 1.31.2, WordPress CLI PHP8.3. Config source `poc/g3c/compose.yaml`, PR #64 blob `d174843bb0a510003c04c8ce327852860f886f31`.
- Last Executor readback: DB running and healthy; other three stopped. WordPress port `127.0.0.1:8189`, Mailpit `127.0.0.1:8190`; no listeners.
- Last `docker start` for WordPress was denied at **executor CreateProcess before command start**, not a Docker/WordPress runtime error; Codex Windows desktop has now been **restarted by Owner**. Standard Full Access had already been enabled (Owner-reported). A **single legitimate normal attempt in the restarted approved tool** is authorized; do not attempt alternate pathways on renewed denial.
- 17 G3CR4 QA screenshots are missing in the local dirty worktree. Not runtime prerequisites; do not restore/reset them or overwrite unrelated edited preview files.
- DB volume content, installed Woo/PayPal/Stripe actual runtime flags and recoverability had not yet been reviewed: stay UNKNOWN until directly checked.

## Phase 0: fresh safety check

1. Confirm physical Owner Windows session, Docker context `desktop-linux`, Compose project label `birthday-magazine-g3c`, same original four container identities, stable source mounts including frozen preview plugin, two existing **nonempty or unknown** named volumes, private network, named port isolation and available disk/memory. Do not recreate any resource to satisfy a missing condition.
2. Fresh-read only needed project files/current main/PR. The dirty checkout is preserved as-is; no reset, checkout, clean, rebase, merge or bulk source sync. GitHub plugin's supported dedicated methods may be used if some generic GitHub methods are unregistered; this does not grant an alternate host-execution channel.
3. Read-only examine whether Docker container/process is already running. If WordPress became healthy through ordinary previous operation, skip start and go to validation.
4. If project identity/data or normal execution channel cannot be proven, `RETURN_TARGET_OR_STORAGE_UNKNOWN` without mutation. Do not ask Owner to repeat the already-enabled Full Access toggle.

## Phase A: **one normal startup attempt**, do not retry denied policy

1. If WordPress remains stopped, use the **same ordinary authorized Codex host command execution surface** after Owner's desktop restart for one simple, exact **existing-container WordPress start** (no `docker compose up`, pull/build/recreate, no dynamic shell wrapper, scheduler, GUI or secondary agent).
2. If the executor returns `CreateProcess ... blocked by policy` **before process start**, record the sanitized exact rejection class/stage and immediately `RETURN_EXECUTOR_POLICY_STILL_BLOCKED_AFTER_RESTART`. No command rephrasing, elevation, altered execution settings or alternate shell/API/GUI. **Do not reinstall WordPress** in this case: no proof it is broken and tool cannot be trusted to execute.
3. If command reaches Docker and returns a genuine Docker/WordPress error or exits, inspect redacted image/container health/event classification and **only safe allowlisted log fields** (no raw secret-bearing logs). Attribute the fault to one of `CONTAINER_RUNTIME`, `WORDPRESS_CORE`, `MOUNT_CONFIG`, `DB_DATA`, or `UNKNOWN`. Do not call every start failure WordPress corruption.
4. If start succeeds, verify WordPress process/HTTP/DB/Woo separately. For Mailpit and optionally wpcli, start **only exact original existing project containers when needed and only when same authorized path permits**; if a helper fails, classify whether it blocks website health. Do not rebuild them just to match a four-running-container count.

## Phase B: conditional, backed-up local app repair / reinstall

**Skip completely when the original WordPress site passes smoke.**

Only if:
- a real app/container/source defect was conclusively shown **after** the permitted process started/reached Docker,
- the target identity/data scope is unchanged,
- a DB-consistent backup (DB-native consistent dump/snapshot) and a separate protected WordPress durable files/config/plugins/uploads recovery point are created and verified for integrity/read/restore compatibility,
- existing Docker image digest, env/mounts, current DB/account state and exact scoped rollback are documented,
- the action targets *only* the failing application component and is technically reproducible, reversible, and within the present Owner approval,

then perform **at most one narrowly selected fix**: repair an objectively broken WordPress-core-only file set with version match, **or** replace only the project WordPress **container** with the same pinned approved image/digest and exactly retained mounts/config/network. The repair may not blindly reset WordPress installation. Never delete/recreate either named volume, empty WP data, trigger database reinstall/setup wizard, overwrite `wp-config.php`, `wp-content`, plugins/themes/uploads, alter PayPal/Woo settings, or touch DB container/image as part of the WordPress replacement. Any container removal/recreation is allowed only after backup integrity, container ownership, exact recreate parameters and validation of **no unique data outside the retained volumes**. Preserve recovery ability of prior container/config until new one is proven functional. If removal would discard unique contents or compatible rollback cannot be proven, STOP.

If the failure concerns DB content, settings, Secrets, unknown volume bytes or corrupted unique business state, **do not reinstall**; `RETURN_RECOVERY_DATA_RISK` with evidence. If source/editor changes are implicated, do not overwrite pre-existing dirty preview worktree. If backup/recovery cannot be verified, `RETURN_BACKUP_OR_ROLLBACK_UNVERIFIED` without repair.

## Phase C: acceptance check and stop

1. Fresh verify loopback `http://127.0.0.1:8189` responds with the existing Owner-accepted homepage, Free Preview and separate core intake page; verify WooCommerce active, current product ID 1113 virtual USD39.99 if present, a GET-only cart/checkout entry, and login/private workspace entry without logging in or submitting.
2. Sanitized installed/active-plugin and PPCP/Stripe gateway boolean inventory only; never print keys, customer data, order payloads, token or full option dumps. Do not enable, connect, install or alter payment gateways. Record if actual plugin flags cannot be read; payment staging remains deferred.
3. Verify exact G3C volume/network identities, unchanged DB health, permitted local ports only, no external tunnels, no unexpected application/account changes. If app-only repair happened, record image/content manifest delta, backup location class (not secret path details if sensitive), integrity, rollback and healthy same-target readback.
4. Mark `PASS_CANDIDATE_G3S1R_LOCAL_RUNTIME_RESTORED` **only** if site and Woo functional smoke plus data preservation evidence are sufficient. Otherwise precise `RETURN_*`, preserving partially healthy state. No business provider/test payment, Mailpit email sending, Stripe plugin stage, additional visual redesign, or merge.
5. Write one concise redacted Executor Evidence record to project PR #64 when GitHub connector permits. Stop for **Reviewer independent inspection**. Do not automatically move to G3S1 payment plugin staging or a new Gate.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:
1. This current G3S1R Gate;
2. `docs/OWNER_DECISION_G3S1R_ONE_ROUND_LOCAL_RECOVERY_2026-10-15.md`;
3. last `docs/evidence/g3s1/G3S1D_READONLY_RUNTIME_POLICY_DIAGNOSTIC_2026-10-15.md` from PR #64;
4. `poc/g3c/compose.yaml` and exact already mounted plugin entry points only as needed;
5. current PR #64/main project-scope freshness.

No broad governance/history reread. No extra approvals from Owner are needed for the authorized narrow app-only repair if all conditional safety barriers above pass; if they fail, RETURN instead of requesting ad hoc deletion authorization.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_G3S1R_LOCAL_RUNTIME_RESTORED / RETURN_*
改动：原容器正常启动，或说明有何确证损坏、备份后做了哪一处局部修复。
验证：Codex 重启后普通启动命令是否真正执行；WordPress/Woo/页面和 DB/卷状态；如有修复，备份验证和精确回滚。
问题：NONE，或单个阻塞原因及简短解释。
回滚：原数据/卷不删除；具体备份与恢复验证状态。
请 Reviewer 检查：Evidence 路径及可核实的恢复结果。
Owner 转交：NONE，除非发生明确的权限或数据风险。
```

## STOP boundary

This is **one recovery round**, not unlimited retries. No Stripe inactive install yet. A renewed process-creation policy denial is **not** permission to switch shells, agents, computer UI, scripts or call paths. Do not declare success from Docker health alone. Keep parent G3S1 financial integration on HOLD.
