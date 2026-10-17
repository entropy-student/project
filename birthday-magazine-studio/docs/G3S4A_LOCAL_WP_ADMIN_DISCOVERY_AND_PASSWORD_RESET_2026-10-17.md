# G3S4A — Recover local WordPress administrator login without exposing credentials

> Date: 2026-10-17
> Status: **OWNER_AUTHORIZED_CONDITIONAL — EXECUTOR_NOT_YET_RUN**
> Explicit Owner authorization: `docs/OWNER_AUTHORIZATION_G3S4A_WORDPRESS_ADMIN_CREDENTIAL_RECOVERY_2026-10-17.md`
> Parent G3S4R stop: `docs/REVIEWER_DECISION_G3S4R_RETURN_BROWSER_TARGET_UNVERIFIED_2026-10-17.md`
> Prior host/backup evidence: PR #64 `docs/evidence/g3s4/G3S4R_BROWSER_TARGET_RETURN_2026-10-17.md` @ `777463995a298118dae0c6763f6c668207a19350`
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7

## Gate contract

```text
GATE_ID=G3S4A_LOCAL_WP_ADMIN_DISCOVERY_AND_PASSWORD_RESET_20261017
OBJECTIVE=Identify the CURRENT local G3C WordPress administrator account safely and, only if uniquely identified and Owner supplies a private new password, reset exactly its password so Owner can manually log into WordPress without rebuilding site or using Computer Use.
MAX_ENDPOINT_THIS_ROUND=Verify exact Owner Windows G3C WordPress runtime and selected recovery boundary -> read-only administrator role/ID inventory -> if unique and safe, one locally hidden Owner-input credential update using a reviewed stdin/memory-only host-to-WP process route -> read-only nonsecret verification -> one sanitized Evidence commit on PR #64 -> STOP for Reviewer.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner Windows 11; existing Docker Desktop desktop-linux G3C original WordPress 7.1.1 + Woo 11.1.2, WP-CLI and MariaDB existing container IDs/volumes; existing site http://127.0.0.1:8189/wp-admin/; ONLY one existing administrator password field / internal associated session invalidation. Do not assume username 'admin' from prior projects.
APPLICABLE_CRITICAL_CONSTRAINTS=No new account, admin-role promotion, user/email/other-password updates, session theft, reset-link emailing, sharing secret or hash, WordPress source edits, Stripe activation/payment/config, Woo order/content mutations, Mailpit start, database restore/import, Docker recreate/Compose up, local source Git clean/reset/stash, deletion of backups, unrelated services, public web exposure, Netlify/PayPal, PR merge or real funds. Computer Use/browser automation unnecessary and forbidden this Gate.
PREFLIGHT=Owner's exact current approval is recorded in Owner authorization linked above and must appear in Executor relay. Fresh host/Windows/Docker context/source/Compose identity and loopback checks: exactly original running G3C WP/WPCLI/DB project and immutable target path/volume; read-only verify no material source/backend changes since G3S4R and protected selected 2026-10-16 backup still present (use retained G3S4R size/SHA evidence, avoid repeating entire backup/offline restore). Read-only enumerate administrator(s) using native WP capabilities/role: ID and role, username only on the protected Owner terminal if needed. If 0 or >1 administrators, multisite/superadmin ambiguity, unexpected host/source difference, unknown DB health or incompatible native WP-CLI tooling, STOP before changing credentials. The prior claim that 'admin' existed elsewhere does NOT prove identity here. Determine a secure local no-echo prompt/STDIN transport path compatible with actual PowerShell/runtime and PHP/WP-CLI. Do not perform any credential write until secret transport can be shown to avoid argv/env/shell history/temp/plain logs and Owner confirms selected account locally.
REQUIRED_EVIDENCE=Exact Owner approval; native exact host/container IDs/role/network identity; baseline WP/Woo/Stripe plugin status; administrator account count and uniquely verified target without publishing user/login/email; source/backup scope and non-target baseline; password method with Owner-only no-echo entry, twice confirmation, transport review for no argv/env/log/temp/echo/history and negative secret exposure checks; one native update attempt/result (no secret values/hashes), WordPress authenticated-site health and only selected user credential field change where safely provable, old session behavior if observable without collecting cookies; state of no payment/provider action, backups preserved, local checkout untouched; single sanitized PR #64 Evidence file, exact Git diff and Reviewer stop.
ACCEPTANCE_CRITERIA=ONE existing G3C WordPress admin uniquely discovered and (if local secret transport safe) password updated exactly once, and Owner can successfully enter admin area with self-kept new password (Owner login confirmation may be a separate non-secret final checkpoint). If credentials cannot be safely accepted or multiple admins need selection, return exact RETURN without password change. Not a Stripe/payment Gate; plugin inactive unless independent later permission.
ROLLBACK_STATUS_OR_PLAN=This is a deliberate credentials change with invalidation of old sessions, not a zero-write operation. The prior verified G3S4 protected full DB/WP/source recovery set remains intact, but do not restore entire DB to undo a password reset. Recovery route for a failed/unknown credential reset is a separately reconciled verified administrator identity + new private prompt, not a blind repeated password update. Owner stores the new password privately in a password manager; no agent-generated password backup in repo or profile-only copy as sole recovery.
OWNER_ONLY_ACTIONS=Owner chooses/enters the new secret via trusted local masked prompt and privately confirms it; if multiple admins, Owner chooses which existing admin based on local display, then Executor stops for revised explicit account selection rather than silently choosing. This Gate already holds scoped Owner authorization for one unique existing admin; no G3S4M Stripe plugin/provider/test write approval.
REVIEWER_TO_EXECUTOR_RELAY=Read only this Gate, its Owner authorization, G3S4R accepted host+backup Evidence and exact local target/source. Use existing original WP-CLI/container; start with read-only count and verified target; no Computer Use/Stripe/Browser action. If one admin and transport safe, deliver one atomic Owner-side masked-password checkpoint whose code is independently reviewed; relay no secret values. Never expose password in process arguments, env vars, command history, stdout/stderr, logs, scripts or ordinary temp files. If cannot verify, RETURN.
EXECUTOR_TO_REVIEWER_RELAY=One concise packet: administrator enumeration count (no personal details), reset attempt result, local source and backup unchanged, non-target provider delta zero, credentials not disclosed, Evidence link+SHA or precise blocker. Mandatory Reviewer STOP.
```

## Execution procedure

### A. Read-only target and account discovery

1. Prove real Owner Windows PowerShell/runtime version, Docker Desktop `desktop-linux`, existing Compose project/container IDs, `127.0.0.1:8189` private mapping, database health and actual live WordPress install identity. Do not create or start new containers.
2. Within the **already running original** project WP runtime, use only read-only WordPress user/role queries to determine the administrator **count**, and present the username/ID to Owner **only on the protected local terminal as needed**. Do not write it into GitHub Evidence or public chat. If exactly one admin is proven and the target site is correct, proceed; if 0/multiple, `RETURN_ADMIN_IDENTITY_AMBIGUOUS`. Do not guess `admin`, choose the first account or create a new admin.
3. Confirm existing protected recovery point still present within its previously verified narrow scope, no unrelated site/DB/source drift. **Do not re-export or restore** or repeat 44 file hashes unless a concrete mismatch requires it.

### B. One private password reset, only if safety PASS

1. Choose **Owner-supplied strong password** (e.g., >=14 characters), entered twice via local masked `Read-Host -AsSecureString`-equivalent on Owner's Windows. The actual private input should be handled only by Owner's trusted prompt; never ask them to tell Codex/ChatGPT their password. No generated temporary username/password posted anywhere.
2. Before execution, review the exact chosen PowerShell/WP-CLI compatibility and command/argument shape. **The password itself must travel via protected process standard input or in-process memory only**, not `wp user update --user_pass=<secret>` or any command argument, environment variable, PowerShell transcript, shell history, repo/script file, log, ordinary temporary file or browser automation. Avoid echo and dumps. A fixed benign WP CLI code expression may appear as an argument only if it contains **no secret** and has been verified to read STDIN as intended. If true no-echo input and safe stdin transport cannot be shown to work on the actual runtime, `RETURN_SECRET_TRANSPORT_UNVERIFIED` with NO mutation. Do not use `--prompt` without proving it masks password input.
3. Preserve the required selected admin identifier only in protected memory/command context, apply WordPress's own password hashing/reset mechanism to **exactly one selected user** once (no raw SQL user-password write and no privilege, email, other user or Woo order changes). Capture and check native process exit status and success branch without dumping state or Secret hashes. Password change may invalidate older WP login sessions; treat that as expected.
4. After a successful and unambiguous reset, Owner keeps the chosen password in their own password manager and manually signs in via `http://127.0.0.1:8189/wp-admin/` in the browser they control. Codex does not handle browser cookies, Owner credentials or account session. If user has not yet confirmed login, report `PASS_CANDIDATE_PASSWORD_UPDATED_OWNER_LOGIN_PENDING` (not full login PASS). If update outcome ambiguous, read-only reconcile actual selected account state under safe rules; **no second reset automatically**.

### C. Evidence and stop

- Submit only one sanitized evidence Markdown at `birthday-magazine-studio/docs/evidence/g3s4/G3S4A_LOCAL_WP_ADMIN_RECOVERY_2026-10-17.md` to PR #64. Use an isolated GitHub file write, never stage the existing dirty Windows repository. Only allowlisted project evidence path is changed. Verify single-file commit diff before sending result.
- Source of truth for credential value is Owner-local ONLY; no password/hash, login email, reset URL/token, authentication cookie, raw logs or scripts containing secrets in any output.
- Stop at Reviewer. This Gate does **not** authorize Stripe plugin activation, OAuth, TEST order/webhook/refund, real charges or PR merge.

## Completion packet

```text
结果：PASS_CANDIDATE_G3S4A_ADMIN_RESET / RETURN_*
改动：仅一个既有本机 WP 管理员密码改变（或未改变），旧会话可能失效。
验证：已核实正确 G3C 目标、管理员数量、掩码输入/无 Secret 泄漏、原站点健康。
问题：NONE / 多管理员身份不明确 / 密码传输无法证明安全 / 本机身份不符等精确原因。
回滚：原 G3S4 受保护备份保留，密码丢失可再次走受控重置；不得整库恢复。
请 Reviewer 检查：目标身份及凭据恢复是否符合 Gate，接下来能否由 Owner 自行登录。
Owner 转交：仅需本人在本机设定新密码并在私有浏览器登录，不共享密码或账号资料。
```
