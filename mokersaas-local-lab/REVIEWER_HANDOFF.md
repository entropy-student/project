# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-17
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0 discovery-only PASS; G0R superseded by Owner waiver; G1 returned after partial local source build; G1R read-only diagnostic PASS; G1S `RETURN_PRECONDITIONS_UNSATISFIED` before ANY target write (no new DB/Secret/app). **G1P code-only execution returned PASS_CANDIDATE; Reviewer status PARTIAL pending reviewable exact five-file source diff.** No further G1P code writes/rebuild authorized just to regenerate evidence. Original 18 local changes, two app/migrator images and original healthy DB/volume/network retained; localhost website still NOT_RUNNING. G2+ NOT_AUTHORIZED.

## SYSTEM_MAP
- Source: https://github.com/ItusiAI/MokerSaaS , upstream main observed c98f68c68de312cc1378130b96f82418e22bd5f3 (2026-09-14).
- Runtime: Next.js 16.3.0 + React 19, NextAuth v4; pnpm packageManager 9.15.0; Drizzle ORM + PostgreSQL schema/migrations; app Next.js API routes; subscription expiry cron and email/marketing flows.
- DB incompatibility caveat: lib/db.ts uses `@neondatabase/serverless` `neon(...)` + `drizzle-orm/neon-http`; plain local Docker PostgreSQL TCP is not proven compatible. Possible G1 app-only driver swap to `postgres`/`drizzle-orm/postgres-js` must be planned/reviewed, not assumed.
- Required runtime environment: DATABASE_URL; NEXTAUTH_SECRET / NEXTAUTH_URL; module `lib/email.ts` throws when RESEND_API_KEY absent; other optional/provider Stripe, OAuth, Umami, cron may require fail-closed local stubs for isolated tests. No Secret values stored here.
- No official root Dockerfile/Compose observed; build/config safety caveat `next.config.mjs` sets `typescript.ignoreBuildErrors: true`.
- Confirmed blocker: `app/api/admin/set-admin/route.ts` GET/POST performs `users.role='admin'` without checking caller authorization; `proxy.ts` excludes /api. MUST remove/disable this endpoint before G1 accounts/functional smoke; do not exercise existing unsafe endpoint on public origin. Admin user operations elsewhere use `isAdmin()`.
- Referral code contains multi-step DB reward mutations in `lib/referral.ts`; atomicity/idempotency/refund reversal are UNVERIFIED.
- Moker G0 Owner-local Codex reported native Windows 11 Home build 26300, PS 7.6.5, x64 non-admin, host RAM total 15.28 GiB and free 0.81–1.44 GiB, disk 205.25 GiB free, Docker Desktop Engine client/server 29.7.2, Engine capacity 7.40 GiB, Compose 5.4.0, ports 3077/5432 unbound, no Moker containers/images/networks/volumes. Physical machine ownership remains OWNER_REPORTED to Reviewer; these runtime readings are Executor-reported, not Reviewer direct host access. Owner waived the project-specific numeric 4 GiB free-memory threshold on 2026-10-16, but actual resource failure/instability remains a hard stop.
- G1 Owner-relayed Executor evidence (2026-10-16): isolated local checkout pinned exact c98f68c; 14 modified + 4 newly added files, uncommitted; Docker app build and TS/Next reported exit=0; app image short sha256:22085e2a08a9, migrator sha256:e69b2319be63; lab auth/provider/DB adapter code patches reported but diff NOT yet accessible to Reviewer. Compose config reported localhost-only 127.0.0.1:3077, internal network, DB no host port; only healthy PostgreSQL container and own empty public schema/volume/network exist, app not started. Native policy denied synthetic DB role password reset process creation; no credential recovery or schema push occurred. 
- Retained artifacts are NOT a complete G1 deployment. G1R confirmed two blocked password reset attempts were rejected before CreateProcess, with no DB write started; existing project resources unchanged. The original synthetic DB credential approved storage/recovery remains UNKNOWN. Do not change existing DB or attempt an alternative write channel. New G1S side-by-side DB plan has scoped Owner authorization, but actual execution still requires independently policy-permitted process creation and safe Secret recovery; no real provider or Stripe use reported.

## CURRENT_ACCEPTED_STATE
2026-10-17 Reviewer reconciled G1S Executor report: original physical Windows local runner/pinned upstream remain Owner-relayed; no new G1S DB network, volume, Secret, schema or app created; old DB/migrator/app images remain as reported. `RETURN_EXECUTION_POLICY_BLOCKED` is imprecise for **new target** because no G1S new-object write was attempted/denied; classify `POLICY_PERMISSION_UNPROVEN`. Previously rejected old-role password reset in G1 remains a genuine CreateProcess denial and cannot be rerouted. Independent encrypted Secret recovery failure domain not verified, OneDrive directory merely present/unproven; no exception currently approved under Governance v0.2.7. Actual local patched code diff not Reviewer accessible. New Gate G1P permits ONLY non-secret project code-adapter and Compose-template fixes, no real DB/Secret/runtime actions, based on existing Owner-approved G1S source scope.

## CURRENT_GATE
`MOKER-G1P-CODE-ONLY-SECRET-SEAM-20261017` code-only changes reported PASS_CANDIDATE; execution stopped, pending Reviewer actual five-file diff inspection. No active mutation/startup Gate; read-only code submission for evidence required. G1S original returned, no retry. Previous G1S `MOKER-G1S-NEW-SYNTHETIC-DB-AND-SMOKE-20261017` returned and is no longer executable; old proposal remains historical non-executable.

## CRITICAL_CONSTRAINTS
- Executor only Owner actual Windows 11 local Codex; no cloud runner, VPS, Grok Bot, SSH, or unrelated repositories.
- G1P already executed code-only and reports total 21 project changed paths (original 18 preserved, 2 new and 3 existing touched); do NOT repeat/edit merely for evidence. Read-only show actual five-file redacted patch/content to Reviewer next. No active DB/Secret/container/build/runtime mutation Gate. Old DB/volume/network and both original images remain untouched as reported.
- Do not require impossible advance promise that arbitrary new writes are policy-allowed; actual tool policy denial on a requested source edit means STOP, no alternate shell/helper/agent bypass. Specifically old database role password reset is forbidden to retry by another channel.
- No numeric RAM minimum. Actual OOM/native failure => precise RETURN; never change Docker/WSL global settings or close Owner apps without approval.
- No real payment, Stripe, Resend, OAuth, Neon, Umami, email, affiliate payout, public bind, VPN/Clash/HY2/WireGuard/proxy/firewall changes.
- Governance §11B protected Secret/recovery rules unchanged. G1P generates no Secret; future DB startup needs approved separate recovery destination **or** explicit narrowly scoped Owner exception; do not silently choose OneDrive merely because folder exists.
- UNKNOWN != PASS; Reviewer writes GitHub Evidence/Handoff and decides acceptance; STOP_AT_REVIEWER=YES.

## DEFAULT_EXECUTION_CHANNEL
Owner physical Windows 11 local Codex, project-only checkout. Reviewer manages canonical GitHub docs; Executor reports compact sanitized Evidence in chat. No additional GitHub commit from Executor without later reviewed authorization.

## CURRENT_ROLLBACK_STATUS
G1S no-write return => rollback NOT_APPLICABLE. Original G1 source 18 uncommitted files, two built images, original `mokersaas-local-lab-db-1` and `mokersaas-local-lab-db-data` retained. G1P must record bounded baseline diff/rollback before changing project-only nonsecret source files. No DB/volume/container deletion or modifications authorized.

## UNRESOLVED
(1) Secret recovery: separate encrypted failure domain not verified; OneDrive local folder exists but Owner control/sync/storage authorization unknown; or Owner must specifically authorize tightly scoped disposable-lab exception consistent with Governance. (2) For new DB creation, no policy denial shown, but future tool actions may still be refused; only actual rejection establishes that. (3) File-backed DB credential helper, Drizzle configuration and G1S Compose template are now reported as implemented in G1P (five changed paths) but NOT Reviewer-inspected; TypeScript and runtime Secret mounting unverified. (4) G1P five-file actual diff not yet provided to Reviewer; need exact tracked diff for lib/db.ts, drizzle.config.ts, .dockerignore and full content of new lib/local-db-config.ts and docker-compose.g1s.yml with no Secrets; G1 inherited 18-path security diff remains unreviewed at runtime. (5) New DB/schema/app/login/security/provider runtime tests NOT_STARTED. (6) all prior original assets and uncommitted changes must remain.

## NEXT_STEP
Request a single READ-ONLY code submission: actual tracked diff for lib/db.ts, drizzle.config.ts, .dockerignore and complete content of the new lib/local-db-config.ts + docker-compose.g1s.yml (redacted, no Secret values/private paths). Reviewer checks helper encoding/build-phase fail-closed, Drizzle compatibility, Compose private network/file Secret mounts and ignore rules to accept G1P, then issues the next bounded runtime Gate. Do not re-run G1P, rebuild or create DB. Owner in chat accepted a disposable synthetic-test-only exception to off-host Secret recovery, but the canonical DECISION_LOG write was blocked and **not persisted there**; do not activate a runtime exception on undocumented assumption.

## OWNER_ACTION_REQUIRED
Immediately: request Codex output the five-file redacted actual G1P code diff/content only (no new Gate or writes). Owner already approved a disposable-only local exception in chat; its DECISION_LOG persistence failed due tool safety rejection and must be reconciled before runtime Secret creation. No password, admin elevation or third-party account action needed.

## EVIDENCE_POINTERS
`EXECUTION_EVIDENCE.md`: G0/G1/G1R, G1S no-write return and reviewer reconciliation; `DECISION_LOG.md`: Owner RAM waiver, original G1S approval (no new exception yet); `G1S_NEW_TEST_DB_AND_LOCAL_SMOKE_GATE.md`: returned historical Gate, not active; `G1P_CODE_ONLY_SECRET_SEAM_GATE.md`: executed PASS_CANDIDATE / actual diff review pending, not an active mutating Gate; `G1S_NEW_TEST_DB_RECOVERY_PROPOSAL.md`: old inactive proposal with historically stale pending text.

