# MokerSaaS G1 — Local Hardening + Docker Compose + Bounded Smoke

> IMPORTANT: G1 was partially executed and returned at credential recovery; its original authorization and relay below are no longer active. DO NOT rerun this Gate or repeat completed builds. Current read-only Gate: `G1R_DB_CREDENTIAL_RECOVERY_DIAGNOSTIC_GATE.md`.
> GATE_ID: MOKER-G1-LOCAL-HARDEN-COMPOSE-SMOKE-20261016
> STATUS: RETURN_LOCAL_DB_CREDENTIAL_RECOVERY_BLOCKED — 2026-10-16; historical returned Gate, NOT active
> GOVERNANCE: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 (Reviewer interpreted)
> UPSTREAM SOURCE: ItusiAI/MokerSaaS pinned c98f68c68de312cc1378130b96f82418e22bd5f3
> MAX_ENDPOINT_THIS_ROUND: isolated project-owned source + security/provider adapters + Compose build/start on 127.0.0.1 ONLY + bounded local UI/DB/security negative smoke (conditional on prerequisite proofs)
> MANDATORY_REVIEW_STOP: YES
> STOP_AT_REVIEWER=YES

## 1. OBJECTIVE
把固定版本的 MokerSaaS 改造为 Owner 实体 Windows 11 的完全隔离 localhost-only 实验版本，修掉已确认的越权管理员接口，接入项目专属 PostgreSQL，阻断未经授权的外部支付/邮件/OAuth/cron/佣金真实动作，生成可复现 Docker Compose，在安全前提下构建、启动并验证基本前端、DB、鉴权的正反向 smoke。不要对正式商用安全或支付闭环宣称 PASS。

## 2. OWNER DECISION / SCOPE
- Owner 2026-10-16 明确取消先前 G0R 单独数值门槛，参见 DECISION_LOG MOKER-D-20261016-NO-RAM-NUMERIC-GATE。前一 G0R `SUPERSEDED_NOT_EXECUTED`；无需执行。
- No 4 GiB free-memory minimum or other invented hard RAM numeric gate. Still capture current resource facts briefly and fail on actual OOM, native failure, Docker/Windows instability, disk exhaustion, severe actual memory pressure; no daemon/WSL memory changes or forcibly closing owner processes.
- Explicit Owner intent authorizes only this bounded project-local low-risk runtime preparation/localhost smoke, not external Provider activation, real money, sharing credentials, public hosting, security-governance waiver, data deletion, or touching other projects.

## 3. TARGET_AND_SCOPE
- Execution channel: Owner physical Windows 11 **local Codex**, not ChatGPT container, cloud runner, WSL-only container, Grok Bot, SSH or VPS. Prove same-host identity with sanitized process/OS/target read-back.
- Canonical governance/docs: `entropy-student/project:main:mokersaas-local-lab/G1_LOCAL_HARDEN_COMPOSE_GATE.md`; local source workspace can be project-owned new path `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab`, but must resolve and prove the actual physical path, check virtualization/junction/reparse, ownership, cleanliness and no collision before creating it. If another path is needed, choose one equally isolated under actual Owner Windows profile, record it; no overwrite/cleanup of unknown path. Do not use existing `SaSS` repository or mutate any unrelated Git working tree.
- On a clean, project-scoped checkout only, fetch/checkout **exact** upstream pinned source SHA above and record Git HEAD, branch/detached state, status and source provenance. If repository/ref content doesn't match pinned source, stop/reconcile, do not silently upgrade to latest.
- New project Compose name e.g. `mokersaas-local-lab`, isolated images, service/container names, network, DB volume, build cache; no shared external networks, existing app DB or nginx.
- App host publish ONLY `127.0.0.1:3077:3000`, after fresh port ownership check; DB no published port, only private Compose app<->db network. Do NOT fallback to `0.0.0.0` or random external port; if 3077 taken, RETURN for Reviewer.
- Filesystem writes only new approved project source/workspace, project-owned volume/config/test files, never global Docker daemon config, existing Docker projects, VPN or GitHub Governance.

## 4. ACCEPTED_FACTS
- G0 accepted as discovery-only PASS; local Docker Desktop 29.7.2 + Compose 5.4.0 responded; Windows 11 build 26300, PS 7.6.5 x64; past G0 port 3077/5432 free and no Moker objects (re-probe only right before actual binding).
- Pin upstream commit `c98f68c...`; Node requirement >=20.9 from pinned Next.js package vs README Node18+ mismatch; repo pnpm@9.15.0, lock v9 plus package-lock; choose pinned pnpm lock consistently, do not silently resolve from two lockfiles.
- `app/api/admin/set-admin/route.ts` GET/POST promotes admin without authentication; `proxy.ts` excludes /api. **Cannot start functional auth tests until route removed/disabled with negative checks**.
- `lib/db.ts` uses Neon HTTP driver, incompatible assumption for standard local Postgres; `postgres` package already listed; `drizzle/meta/_journal.json` entries=[]; do not claim `db:migrate` initialized schema without read-back.
- `lib/email.ts` throws on missing Resend credential; `app/api/stripe/webhook/route.ts` directly instantiates Stripe client at module scope and imports mail. OAuth providers are unconditional. Current `next.config.mjs` ignores TS build errors.
- `lib/referral.ts` awards referral points via multiple independent writes, webhook uses pre-lookup not sufficient for concurrent idempotency; refund reversal is NOT proven. These remain out-of-scope for actual funds; do NOT exercise payment/referral/withdraw workflows against real providers.

## 5. PREFLIGHT (MUST PASS BEFORE ANY WRITE)
1. Prove real Owner Windows local target (not remote/sandbox), effective user/privilege, Docker Engine access, exact isolated target path, nonexistence or safe empty/new project-owned state, disk capacity, current host resource readings and no concrete active instability. G0 RAM number alone cannot return/stop this round. If actual unresponsive Docker/Windows or OOM, stop with precise native error; no retry loops.
2. Validate project target and scope; selected checkout does not overwrite an existing project or dirty worktree. If `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab` is nonempty/unknown, STOP and report instead of deleting. Create path only after validated write preflight. For source fetch, verify pinned commit, secure origin and immutable content; unrelated checkout untouched.
3. Before build/up, verify no existing host 3077 listener, no `mokersaas-local-lab` Compose namespace/resource collision. If existing objects from unknown provenance, stop; do not `down` or `prune` them.
4. Record rollback plan BEFORE mutating: scoped source diff and immutable base, Compose manifest, project-specific volume inventory, local DB fixture-only classification, project-only stop/removal plan requiring later approval for deletion; no deletion of unknown data, no global prune. Stop/revert of service only if exact owned and proved. Secret store and recovery as applicable in bounded local test.
5. No real Stripe/Resend/Neon/OAuth/Umami credentials or tokens. Synthetic disposable lab fixtures only; keep any authentication material private to protected app runtime. Never print Secret values/hashes, `.env`, raw logs or `docker inspect` environment. If the framework demands an unsafe real provider Secret or unavoidable real provider call, STOP `RETURN_SECRET_RISK` with sanitized facts; don't fake a PASS.
6. Validate expected implementation/approach and security boundaries BEFORE executing package/build scripts. Allow only pinned dependencies/images needed for exact app/DB; no unbounded downloader, scripts that modify global configuration, paid APIs or local large model downloads.

## 6. EXECUTE (STRICT ORDER, CONDITIONAL CONTINUATION)
A. **Source isolation:** Create clean repo-scoped workspace; fetch exact pinned source SHA; capture source hash, project path category and source diff. Do not push upstream, create remote PR, or modify canonical project repo except Reviewer-managed docs.
B. **Auth hardening:** Remove/disable both GET and POST `/api/admin/set-admin` server handlers, ensuring any anonymous/ordinary-session call returns 404/403 with no role mutation. Do NOT just hide admin UI. For testing admin, use a one-shot non-public fixture/seed in the private local DB, never publicly routable bootstrap API. Preserve other auth paths and normal admin role guard.
C. **Local database:** Adapt only `lib/db.ts` and minimal affected code to use the existing `postgres` + `drizzle-orm/postgres-js` adapter or another verified direct local Postgres adapter. App ↔ db connection internal network only. Use a brand-new app-owned empty PostgreSQL volume/DB. For fixture-only lab DB `drizzle-kit push` may be used ONLY after independent empty-database/project identity checks; empty journal means `db:migrate` is NOT accepted as schema proof. Verify essential tables/constraints by DB query WITHOUT emitting any private row values.
D. **External-action fail-closed lab mode:** Application in LOCAL_LAB mode must block ALL provider network actions/fee actions: Resend real mail, Stripe checkout/customer portal/real webhook processing, OAuth redirects/token exchanges, Umami API/analytics, external AI/storage, real cron scheduler and real affiliate withdrawals. Prefer small explicit lab seam/stub with audited call sites, no disabling login/admin authorization or making API blindly accept calls. Refuse payment endpoints with clear non-success statuses (e.g. 503) and no side effects; never return success for unverified Stripe webhook. No real provider key is used. Local email sink may hold synthetic fixture messages only. No startup automatic external jobs. Verify negative paths before exposing localhost.
E. **Compose/Docker:** Add project-scoped Dockerfile, .dockerignore (exclude live data/Secrets/.env/Git/large caches), docker-compose for Next.js + Postgres, explicit project-only volume, health checks when possible and localhost-only host bind. Pin DB base image to explicit stable major + digest when feasible; record actual resolved image digest, app image ID/commit. No `:latest` unverified releases; don't publish Postgres port. Ensure no accidental peer service or shell mode side effects.
F. **Build/test:** Run targeted dependency install using one pinned package manager with deterministic lockfile; run `tsc --noEmit` explicitly before claiming TS health, then project test/build commands. Log sanitized statuses; report failures without bypassing TypeScript gate by existing `ignoreBuildErrors`. If existing source TS failures, repair only bounded clearly local compatibility errors or RETURN with details. Avoid multiple costly full retries; after a comparable failure, focused diagnosis not speculative repeat.
G. **Bounded localhost startup (only after A–F prerequisites):** Resolve `docker compose config` and confirm host bind and no extra published ports; then single project-scoped `docker compose up -d --build` or sealed-image equivalent, only exact manifest/service list. No `docker compose down -v`; no global prune/restart. Verify container process and dependency health separately (Next.js HTTP, Postgres schema, app session route). Start URL must be `http://127.0.0.1:3077`.
H. **Smoke and negative checks:** Anonymous homepage loads, controlled local test credential signup/signin only if mail stub and auth safely isolated, unauthorized `set-admin` both methods cannot change role, ordinary user blocked from admin API (403), lab Stripe Checkout/webhook/Resend/OAuth/withdraw cannot create external actions, DB survives app-only restart if included and safe; no real external endpoints. Capture non-secret browser URL/status/screenshots or sanitized checks. If any unauth privilege change/public exposure/real provider action observed, fail closed immediately, contain exact project-owned service and RETURN.

## 7. REQUIRED_EVIDENCE (REPORT WITHOUT SECRET VALUES)
`AUTHORIZED_GATE`; `OWNER_OVERRIDE_ID`; `TARGET_LOCAL_PROOF`; `SOURCE_ORIGIN_AND_COMMIT`; `PROJECT_WORKSPACE_CATEGORY_AND_GIT_STATUS`; `PREFLIGHT_FACTS` (RAM observation only, not pass threshold, exact Docker/port status); `ACTUAL_CHANGES` (scoped file list+diff summary); `SECURITY_PATCH`; `DB_ADAPTER_AND_SCHEMA_PROOF`; `PROVIDER_BLOCKING_PROOF`; `COMPOSE_MANIFEST_AND_HOST_BIND`; `TEST_COMMANDS_AND_NATIVE_EXIT`; `TS_CHECK`; `BUILD_ID`; `CONTAINER_IMAGE_ID_AND_HEALTH`; `LOCAL_URL_AND_HTTP_STATUS`; `ANONYMOUS_AND_ORDINARY_USER_NEGATIVE_TESTS`; `DATA_PERSISTENCE_IF_TESTED`; `RESOURCE_OR_BUSINESS_DELTA`; `NO_REAL_PROVIDER_ACTIONS`; `ANOMALIES`; `ROLLBACK_STATUS`; `EXECUTOR_RESULT`. Mark DIRECT_READBACK / OWNER_REPORTED / INFERRED accurately. Produce concise six-line Executor completion relay, detailed sanitized Evidence available in local project-owned file if created; Reviewer will persist accepted facts to GitHub.
Project artifact paths and container IDs can be identified by project-only aliases/short non-secret hashes; never reveal device/user IDs, raw env or payment/customer identifiers.

## 8. ACCEPTANCE_CRITERIA
- No loss or modification of non-Moker data / other Docker projects / VPN / system configuration; proven physical host and isolated source/Compose.
- Unsupported numeric free-RAM threshold NOT reintroduced. An actual OOM/engine crash/memory-related native failure returns precise RETURN with cause; do not brute-force retries or silently change memory limits.
- Admin elevation route disabled from GET/POST; ordinary user cannot access admin API. Negative tests required where runtime reached; source-only completion cannot be labeled full PASS.
- App/DB only local, no DB host port; no legitimate access to real payment/Resend/OAuth/affiliate payout, no external traffic from app to those services. Synthetic test account allowed only under lab isolation.
- Pinned build, TS check and DB schema verification; frontend HTTP/DB/auth health distinguished; exact project data survives intended restart where tested.
- If prerequisites fail, return a specific `RETURN_*`; partial implemented prep remains reported as PARTIAL/NOT_VERIFIED, never claim running website or PASS. Reviewer alone decides accepted state.

## 9. ROLLBACK_STATUS_OR_PLAN
Before writes, record exact source commit/diff, project resource namespace, DB volume and data classification. On partial build/start failure, do NOT clear unknown state; stop only exact owned project containers if unsafe, preserve diagnostic metadata and volume. Restoration to upstream baseline via clean pinned checkout/diff reversal within isolated project scope; DB has no real data and its disposal requires separate Owner authorization or explicit approved cleanup Gate. No unbounded Docker system prune or `down -v`. No real Provider Secret was used, hence no credential rotation expected; any unexpected exposure triggers incident handling.

## 10. OWNER_ONLY_ACTIONS
None needed for synthetic localhost basic tests if no admin elevation/credential required. Any request for UAC elevation, Docker/WSL global configuration, real Stripe/Resend/OAuth account setup or keys, nonzero real purchase/refund/commission, public exposure, overwriting unrelated data or deleting project durable data requires STOP and separate explicit Owner decision. Existing instruction does not authorize them.

## 11. REVIEWER_TO_EXECUTOR_RELAY
你是 Owner 实体 Windows 11 的本机 Codex Executor。读取 `entropy-student/project` 最新 main 中 `mokersaas-local-lab/G1_LOCAL_HARDEN_COMPOSE_GATE.md` 并严格执行 G1，按 Gate 指名只读 `REVIEWER_HANDOFF.md` 的接受现状/约束、`EXECUTION_EVIDENCE.md` 的 G0 接受段，以及固定上游 SHA 的实际目标源码。不要重读整份 Governance、扫描其他项目或旧 Gates。
Owner 已明确取消 G0R ~4 GiB 内存数字硬门槛；G0R 标记 SUPERSEDED_NOT_EXECUTED。**不得再以 4 GiB 或任意新设 RAM 数值作为开工阻挡**。资源实际崩溃/构建失败则按事实 RETURN，不自动关软件、不改 Docker/WSL/VPN。
本轮允许在真实本机的全新隔离工作区按固定 SHA 准备源码、修复无鉴权 set-admin，适配本地 PostgreSQL，建立安全的无第三方调用 lab stubs 和 Docker Compose；在每个前置安全条件得到可复核证明后，可执行一次本项目范围的构建、启动到 `127.0.0.1:3077` 和基础本地 smoke。若任一关键前置条件不成立，就保持未执行后续步骤并精确 RETURN。不得接真实 Stripe/Resend/Neon/OAuth/Umami，不发邮件、不开公网、不真实交易或佣金、不接管其他项目/网络/系统、不改 Github Governance。
最后给出 REQUIRED_EVIDENCE 的去敏摘要和固定六行交接，声明 `STOP_AT_REVIEWER=YES`，不自行进入后续 Gate、不自行宣布 PASS。

## 12. EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*。
改动：实际修改的本项目源码/Compose/容器范围（无其他影响）。
验证：实际 TS/构建/DB/localhost URL/负面鉴权/第三方阻断结果及原生退出码。
问题：NONE，或具体阻塞点，不得说 generic FAILED。
回滚：本项目独立源码恢复及容器/数据保留状态。
请 Reviewer 检查：所有前置安全证明、原样还原能力、数据与端口隔离、实际运行版本及 Evidence。
Owner 转交：NONE，或最小真实 Owner 动作（需要时停下）。
