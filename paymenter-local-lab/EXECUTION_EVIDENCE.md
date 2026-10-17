# EXECUTION_EVIDENCE — Paymenter Local Lab (append-only)
## 2026-10-17 Reviewer source discovery / no Owner-host writes
AUTHORIZED_GATE: PAYMENTER-G1-LOCAL-DOCKER-ZH-PREVIEW-20261017
PROVENANCE: DIRECT_READBACK GitHub + official docs only
- Paymenter/Paymenter master source commit: 1d4c0b92dac0f93f28998b04c4c0e282bf436177
- Official compose: docker-compose.example.yml includes database (MariaDB), cache (Redis), paymenter (PHP + Nginx); upstream host port 80 would be public unless rewritten. Local launcher rewrites to 127.0.0.1:8187 and uses a separate project name.
- Official config/app.php includes zh and lang/zh directory exists.
- app:init takes company name + URL. app:user:create takes names/email/password/role. DatabaseSeeder creates admin role; User model supports role_id and hashed password.
- Docker launcher prepared in this repository. *No local container, account, or browser flow has yet been executed from this ChatGPT session.*
CURRENT_STATUS: PREPARED_NOT_EXECUTED
EXPECTED_OWNER_RUNTIME_PROOF: host identity, docker ps/inspect, port, app/UI, login, Chinese visual, evidence without credentials.
ANOMALIES: Real Windows current state UNKNOWN until Codex executes on actual machine. Third-party Referrals excluded.
ROLLBACK: no Owner-host changes by current Reviewer; future exact project-only docker compose stop (no -v).

## 2026-10-17 Owner Windows G1 execution — Reviewer pending
AUTHORIZED_GATE: PAYMENTER-G1-LOCAL-DOCKER-ZH-PREVIEW-20261017
PROVENANCE: DIRECT_READBACK GitHub + Owner Windows PowerShell; BEHAVIORALLY_VERIFIED local browser
TARGET_IDENTITY: Windows 11 Owner host (OS build 10.0.26300.0), PowerShell 7.6.5, Docker Desktop Linux context desktop-linux; public hostname/account omitted.
PREFLIGHT_FACTS:
- Dedicated %USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab root was absent; ports 8187-8197 had no listeners; paymenter_local_lab had no containers.
- Docker Engine 29.7.2, Docker Compose v5.4.0; Docker engine memory 7,942,590,464 bytes.
- Locked official source commit: Paymenter/Paymenter 1d4c0b92dac0f93f28998b04c4c0e282bf436177; launcher source was read from GitHub blob efb145bf540421ca16c82836d33b22311518f5d6.
ACTUAL_CHANGES:
- Created only the owned local preview root, its Compose project/network, local APP_KEY/database credentials, and project data. Secret values remain on the Owner host.
- First launch exposed two startup issues: the launcher treated artisan about as DB readiness, then app:init hit Connection refused; MariaDB later logged case-insensitive host filesystem and migration 2024_06_27_122914_create_config_option_products_table failed with InnoDB “Tablespace is missing”.
- Preserved the first-run host database directory. Changed only this owned Compose database mount to project named volume paymenter_local_lab_database; Compose config validated. No down -v, prune, global Docker setting, or other project operation.
- Patched START_PAYMENTER_LOCAL.ps1 to generate the MariaDB data directory as a named volume and to wait for Laravel migrate:status to report no Pending migrations before app:init. The same readiness change was exercised by the successful rerun.
- In admin Settings set Default Language to zh (zh remained allowed). A synthetic demo-noreply@paymenter.local system address was entered because the required field prevented saving; SMTP is not configured and no mail was sent.
- Created category 演示产品（虚构）, product 云主机体验套餐（虚构）, and Free plan 体验版（免费演示） through the admin UI. Product and category descriptions say fictional/demo only.
OBJECTIVE_READBACK:
- Compose project paymenter_local_lab; paymenter, database, cache all running. App published only on 127.0.0.1:8187. Final image IDs: Paymenter sha256:b6d02133b0f1ae6cb77cdaac95b66b3bd363a2ab1b6834e8dd283977e49f1c61; MariaDB sha256:99c125f103f5d081ebbc9ffe064e63daf7f688ac33a5f7f29af2d7260a96debf; Redis sha256:3811787313eba226a2ef38658c6ccb91cd5e110edc89c37767de373120a0e5a0.
- mariadb-admin ping exit 0; redis-cli ping returned PONG; Laravel migrate:status exit 0 with 71 Ran and 0 Pending.
- Read-only row counts: users=1, categories=1, products=1, plans=1, orders=0, invoices=0, services=0.
VALIDATION:
- Browser login succeeded with demo-admin@paymenter.local and redirected to /dashboard. User dashboard showed Chinese navigation and labels for 控制面板, 服務, 發票, 服務單, activated services, tickets, and invoices.
- /admin loaded as Demo Admin. Admin navigation exposed dashboard, invoices, orders, products, tickets, users, services, categories, configuration, gateways, extensions, system settings, audits, APIs, and job/email tools.
- Storefront category and product details showed the fictional product, Free plan, Chinese category/action labels, and the join-cart link. The cart/checkout link was not opened and no order was submitted. Admin Gateway list showed No gateway.
- Language is partial: default zh saved and storefront/user-area labels are Chinese (Paymenter translation uses traditional Chinese strings); homepage “Welcome to Paymenter!” / “Services” and admin dashboard/module labels remain English. No translation files were changed.
ANOMALIES: Initial app:init attempt failed before the admin creation step; final data readback confirms one demo user only. Initial host-mounted database remains preserved in the owned root for diagnosis; the active DB is the project named volume.
EVIDENCE_ARTIFACTS_AND_PURPOSE:
- Local browser accessibility/visual readbacks described above prove the user dashboard, admin session, storefront product, and language behavior. No screenshot file or credential is committed.
- Runtime image identities, loopback port, service/DB/Redis/migration checks, and business-row counts are direct readbacks from the Owner host.
ROLLBACK_EFFECT: Exact project-scoped docker compose -p paymenter_local_lab -f %USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab\docker-compose.yml stop stops this trial while retaining its named volume and local files; legacy database directory retained. No other Docker project was changed.
EXECUTOR_RESULT: PASS_CANDIDATE_LOCAL_PREVIEW; STOP_AT_REVIEWER. No Stripe/payment gateway, real payment, order, public route, or paid add-on enabled.

## 2026-10-17 Reviewer decision — G1 PASS local preview
REVIEW_SCOPE: Source and evidence review of PR #145 at head 0c39f90c270ab7071164bbdf3b17cc7c0db0a3a2; merged as ba556eb3479e13aec92885627ad6df217f40eb0c. No direct access to Owner's local browser from Reviewer; Reviewer assessed Executor's recorded DIRECT_READBACK and BEHAVIORALLY_VERIFIED observations, not a newly repeated runtime test.
GATE_DECISION: PASS (scoped to disposable private local UI preview only).
INSPECTED: PR file list (2 project-owned files), full changed patch (readiness wait, named volume, Evidence), local execution evidence (identity/port/container/images, database/Redis/migrations, login to /dashboard and /admin, fictional product, zero commercial actions). No credentials were found in PR's submitted diff or Evidence.
RATIONALE: The previously authorized acceptance goal—see a functional local storefront, user dashboard, admin dashboard, Chinese coverage, and a demo product—was fulfilled without real payments or third-party paid extensions. Neither incomplete translation nor lack of Stripe/Referrals transactions constitutes an G1 failure.
SCOPE_EXCLUSIONS: No independent current-time host inspection, screenshot archive, restart persistence proof, backup/restore validation, ACL verification, Stripe connect, checkout, order, email delivery, or referral payout acceptance. These are NOT_APPLICABLE to functional preview or UNVERIFIED for production; no production readiness is inferred.
RISK_NOTE: Local one-time demo credential was subsequently quoted in Owner chat; do not reuse for external/public deployment. Database named-volume persistence and preserved original host database folder are recorded; neither may be blindly deleted.
FOLLOW_UP: Owner inspects the running pages to determine product-fit. No re-deploy is required. New Gate needed for any live payment, public exposure, paid extension, or consequential feature change.


## 2026-10-17 G2 browser check blocked; Reviewer scope split
AUTHORIZED_GATE: PAYMENTER-G2-LOCAL-SIMPLIFIED-CHINESE-20261017
PROVENANCE: OWNER_REPORTED executor result; not independent direct Owner host readback.
OBSERVATIONS: Paymenter v1.5.9 and Paymenter/MariaDB/Redis reportedly running on local 127.0.0.1:8187; app source in project-specific Docker /app named volume. Browser skill could not reliably establish active page URL; tool explicitly required stopping Computer Use in that attempt.
ACTUAL_CHANGES: NONE reported; no container restarts, localization modifications, data changes or PR from that attempt. G1 PASS unaffected.
FAILURE_CLASSIFICATION: RETURN_BROWSER_TOOL_UNAVAILABLE; browser evidence unavailable is not evidence of app failure, and cannot be silently replaced with server-up evidence.
REVIEWER_DECISION: Split G2 into authorized code/CLI-only G2A then later G2B real UI verification. G2A must honor tool stop, may create/apply scoped translation files based on source and PHP/CLI checks with verified rollback; cannot claim UI or G2 complete. Current Gate: docs/G2A_SOURCE_NO_COMPUTER_USE_GATE.md.
