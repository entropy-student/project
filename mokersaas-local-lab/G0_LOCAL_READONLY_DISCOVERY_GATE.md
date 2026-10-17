# MokerSaaS — G0 LOCAL READ-ONLY DISCOVERY

> HISTORICAL: G0 discovery-only PASS already accepted; DO NOT execute old relay. Current sole active Gate: G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md; see REVIEWER_HANDOFF.md.
> GATE_ID: MOKER-G0-LOCAL-READONLY-DISCOVERY-20261013
> STATUS: REVIEWER_PASS_DISCOVERY_ONLY — HISTORICAL_NOT_EXECUTABLE
> MAX_ENDPOINT_THIS_ROUND: local environment/source compatibility read-only findings, chat-only sanitized completion relay
> MANDATORY_REVIEW_STOP: YES
> Governance: vps-project-governance/VNEXT.md v0.2.7; Reviewer interpreted, Executor must NOT reread all Governance
> Source: ItusiAI/MokerSaaS upstream main observed c98f68c68de312cc1378130b96f82418e22bd5f3
> STOP_AT_REVIEWER=YES

## OBJECTIVE
确认 MokerSaaS 在 Owner 真实 Windows 11 本地的隔离 Docker 测试可行性与限制，识别数据库驱动、环境变量、初始化权限、端口、内存、安全缺陷与测试替身设计。只读发现，不部署、不安装、不修复、不连接第三方真实账号。

## TARGET_AND_SCOPE
Owner 物理 Windows 11 当前 Codex 本地执行上下文。与云端 Codex/Grok Bot/WSL 容器/VPS 区别必须有非 Secret 证据。上游源码仅只读 GitHub / 既有本地安全 checkout（如存在）；不创建 checkout，不跨读其他项目工作树。
Reviewer 已从 GitHub 核对源文件: `README.md`, `package.json`, `lib/db.ts`, `lib/email.ts`, `lib/stripe.ts`, `lib/referral.ts`, `app/api/admin/set-admin/route.ts`, `proxy.ts`, `next.config.mjs`; 仅有特定疑问才补小范围读取。

## APPLICABLE_CRITICAL_CONSTRAINTS
Canonical governance v0.2.7 universal §§0–10,11 trigger,12–13; triggered 11A resources/isolation, 11B target identity/Secrets, 11C deploy/network, 11D authentication/automations, 11E Stripe/payment; G0 does not authorize real production or cleanup 11F. Reviewer interpreted all triggers; Executor reads only this Gate/Relay, necessary source snippets and fresh target metadata.
Absolute G0 READ_ONLY: no git clone/checkout, npm/pnpm install, Docker pull/build/up, file writes to local project, new configs, credentials, network changes, account signup or actual provider calls. No live Stripe/Resend/Neon/OAuth/Umami, local app or unpatched vulnerable admin API invocation; no test email, outgoing marketing, cron, user funds, affiliate withdrawal.
No changes to Clash/HY2/WG/TUN/proxy/routes/firewall, Docker Desktop daemon/WSL settings, shared containers/networks/volumes, registry/system state, shell profile; no admin privilege elevation. Do not inspect Secret values, `.env` contents, browser cookies, raw `docker inspect` ENV, raw logs or private process command lines. Return exact precise RETURN on conflict.

## ACCEPTED_FACTS / KNOWN BLOCKERS
- GitHub source commit observed c98f68c68de312cc1378130b96f82418e22bd5f3, project uses Next.js 16.3.0 and `pnpm@9.15.0`. README Node 18+ statement may differ from actual Next.js engine requirement; verify lock/engines before planning G1.
- Repo root has no observed Dockerfile/Compose, so Docker Compose is a project-scoped new deployment adapter in G1, NOT an official one-click installer.
- `lib/db.ts` uses `@neondatabase/serverless` HTTP client, not a confirmed localhost Postgres TCP connection; identify a bounded adapter solution using already-declared `postgres` dependency or return UNKNOWN.
- `lib/email.ts` throws on missing RESEND_API_KEY; G1 needs safe mail stub/no-sending behavior; NEVER use dummy live-looking secret as proof of offline safety.
- Publicly routable `/api/admin/set-admin` performs administrator promotion without server-side auth; G1 should remove/disable it and create test admin through non-public fixture procedure. Do not call it.
- `next.config.mjs` suppresses TypeScript build errors. Future acceptance must run explicit `tsc --noEmit` and capture failures.
- Referral reward writes and Stripe webhook idempotency/refund reconciliation not yet verified. No real money in current project scope.

## PREFLIGHT
1. Prove real Windows execution, PS version, OS/architecture, effective privilege, remote/sandbox/WSL status without publishing hostname, username, IP, serial, MAC. If cannot prove owner local target, RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE.
2. Read-only capacity: CPU, host total/free memory GiB, free disk GiB on prospective project drive, Docker Desktop presence/Engine responsiveness, Engine allocated memory and Compose version; check native command exit status. Prior BettaFish ~1.4 GiB free RAM was a historical snapshot only. Do NOT auto-close apps or change Docker settings.
3. Identify existing local project checkout / safe path availability without creating it; if workspace absent, classify `SOURCE_CHECKOUT=ABSENT` (not a failure for G0). If checkout exists, check Git root/branch/HEAD/dirty state for that directory only; do not mutate it.
4. Read-only inventory of app host-port candidates (suggested 127.0.0.1:3077 but not reserved), typical postgres host port 5432, and existing Moker-namespaced containers/images/networks/volumes by names/labels only. Do not publish DB port in proposed G1 plan. Report port conflicts without process arguments or private metadata.
5. Verify upstream commit/file shape narrowly; flag whether installer tools, scripts, lockfile, Node engine, Neon HTTP db adapter, Resend module init, Stripe services, OAuth, cron, admin bootstrap, TS build controls prevent isolated smoke without credentials. No package installation or database migration.
6. Propose G1 lowest-risk Docker structure: app + internal-only PostgreSQL, app on 127.0.0.1 host only, isolated Compose name/volumes, no external APIs/smtp payments, localhost smoke; demonstrate local DB driver swap feasibility, no secret-bearing configs or registry/docker changes. Feasibility is INFERRED, not tested.
7. Record test matrix needed later: page load, DB schema migration, account creation/login, admin-negative-before-role-bootstrap, two test users referral bonus exactly once, affiliate attribution, Stripe webhook fake signature negative/replay, refund/reversal, health/port restart and rollback. Clearly distinguish intended from completed tests.
8. Record sanitized output and native exit codes. Avoid broad/raw Docker info and other sensitive host outputs.

## REQUIRED_EVIDENCE
Return compact non-secret chat report (Reviewer will persist to project GitHub):
GATE_ID, TARGET_LOCAL_PROOF, WINDOWS_VERSION, PS_VERSION, ADMIN_BOOL, CPU_ARCH, HOST_RAM_TOTAL_GiB, HOST_RAM_AVAILABLE_GiB, DISK_AVAILABLE_GiB, DOCKER_ENGINE_STATUS_AND_VERSION, DOCKER_ENGINE_RAM_GiB_OR_UNKNOWN, COMPOSE_VERSION, PORT_3077_STATUS, PORT_5432_STATUS, SOURCE_CHECKOUT_STATUS, SOURCE_COMMIT, SOURCE_DRIVER_AND_EXTERNAL_DEPENDENCY_FINDINGS, SECURITY_BLOCKER, G1_FEASIBILITY, ACTUAL_CHANGES=NONE, OBSERVED_COMMAND_ERRORS, EXECUTOR_RESULT. Label direct findings DIRECT_READBACK, prior statements OWNER_REPORTED, technical forecast INFERRED. Scrub personal identifiers. Do not emit Secret values/hashes, full env or raw logs.

## ACCEPTANCE_CRITERIA
Reviewer can inspect current true Owner-local target and resources; no unreviewed changes; database/mail/auth/payment blockers and source revision accurately identified; credible localhost-only G1 scope and ability to restore clean state; unsafe privilege elevation blocked before account testing. G0 PASS_CANDIDATE is feasible only if evidence is reviewable and target real; runtime may remain uninstalled. Missing or conflicting required facts => precise RETURN_*. Reviewer alone decides PASS.

## ROLLBACK_STATUS_OR_PLAN
No runtime/filesystem changes authorized; rollback NOT_APPLICABLE. If unexpected mutation discovered, freeze, report precise non-secret footprint, do not cleanup, RETURN for Reviewer reconciliation.

## OWNER_ONLY_ACTIONS
Docker Desktop/WSL installs or changes, admin elevation, Secret acquisition/entry/rotation, any actual external account use/Stripe checkout/refund/paid API, real email, production/public exposure, modifying shared infra or deleting data. ALL DEFERRED. Local G1 deployment requires a newly reviewed/authorized Gate after G0.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner Windows 11 本机 Codex Executor。只执行 `entropy-student/project` 最新 `main:mokersaas-local-lab/G0_LOCAL_READONLY_DISCOVERY_GATE.md`，必要时只读旁边 `REVIEWER_HANDOFF.md` 的 CURRENT_ACCEPTED_STATE、SYSTEM_MAP 和约束；不要自行重读整个 Governance 或历史项目。
这轮 G0 **只读**：证明真实 Windows 主机、资源/Docker/Compose、端口/已有部署冲突；有限核对 MokerSaaS 固定源码版本、Neon HTTP 与本地 Postgres 适配缺口、Resend 初始化、Stripe 关闭方法、无鉴权的 set-admin 路由。不要 clone、install、pull、build、up、访问或修改任何运行中的应用，也不要修改 VPN/Clash/HY2/WireGuard/代理/路由/防火墙/WSL/Docker 全局配置。
不得使用真实 Secret、Stripe、Resend、Neon、OAuth、外部支付或收发邮件；不调用不安全管理员接口。没有安全本地 Git checkout **不是**本轮 blocker，也不要为此创建它；Reviewer 负责 GitHub 文档归档。
按 REQUIRED_EVIDENCE 在聊天中仅返回去敏短报告，最后按 6 行 Executor 格式汇报。结尾 `STOP_AT_REVIEWER=YES`，不得自动执行 G1，不得宣称 PASS。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*
改动：NONE_TARGET，只有只读环境/源码核查。
验证：目标主机/资源/Compose/端口/源代码依赖检查的去敏证据。
问题：NONE 或具体阻塞及无法确认之处。
回滚：NOT_APPLICABLE（无变更）。
请 Reviewer 检查：资源与本地同一性、Neon/邮件隔离方案、管理员接口修复先后顺序和 G1 准入。
Owner 转交：NONE 或最小必要人工动作。
