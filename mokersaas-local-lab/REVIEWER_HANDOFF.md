# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-17
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0 discovery-only PASS; G0R SUPERSEDED_NOT_EXECUTED; G1 `RETURN_LOCAL_DB_CREDENTIAL_RECOVERY_BLOCKED` with PARTIAL technical preparation reported. G1R `PASS` for read-only diagnosis (2026-10-16), no target changes; G1 still `RETURN_LOCAL_DB_CREDENTIAL_RECOVERY_BLOCKED` and runtime tests NOT_STARTED. Owner approved G1S on 2026-10-17 (MOKER-D-20261017-APPROVE-G1S-NEW-DB). Executable Gate is `G1S_NEW_TEST_DB_AND_LOCAL_SMOKE_GATE.md`, READY_FOR_OWNER_LOCAL_EXECUTOR; no G1S local writes or app startup have occurred. No http://127.0.0.1:3077 service.

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
Governance v0.2.7 verified unchanged, Owner numerical RAM threshold waiver still scoped. G0 PASS discovery-only. G1 Owner-relayed report received and appended to EXECUTION_EVIDENCE, classified `RETURN_LOCAL_DB_CREDENTIAL_RECOVERY_BLOCKED`; successful preparatory build/TS/source changes are REPORTED_UNVERIFIED (not Reviewer-inspected local diff/control-plane), and G1 full PASS withheld. Native recovery process denial reportedly occurred BEFORE command execution. Existing images/DB project assets retained and G1 later steps unexecuted. G1R diagnostic completed and Reviewer accepted PASS within diagnostic scope; Owner approval now recorded in DECISION_LOG, new bounded G1S Gate created, no G1S local mutation or runtime verification yet.

## CURRENT_GATE
Active G1S: `MOKER-G1S-NEW-SYNTHETIC-DB-AND-SMOKE-20261017` in `G1S_NEW_TEST_DB_AND_LOCAL_SMOKE_GATE.md`, READY_FOR_OWNER_LOCAL_EXECUTOR, bounded local NEW DB + Secret + safe smoke only. G1R diagnostic PASS and retired; G1 RETURN cannot replay; G0R superseded. Old `G1S_NEW_TEST_DB_RECOVERY_PROPOSAL.md` is an earlier non-executable draft (its old pending text has not yet been archived).

## CRITICAL_CONSTRAINTS
- Executor only Owner real Windows 11 local Codex; no Grok Bot/VPS/remote runners.
- Owner authorized bounded G1S ONLY: new separate project-owned disposable synthetic DB/volume, protected credential+encrypted recovery, minimal necessary file/Compose changes and one localhost 127.0.0.1:3077 basic test if required prerequisites pass. Old database, original images and 18 source changes preserved. Previous process-creation denial cannot be bypassed through alternate shell/language/Docker exec/helper/agent; any blocked new action must STOP. Reviewer owns GitHub Evidence/Handoff persistence.
- No change to Clash Verge, HY2, WireGuard, host routes/TUN/proxy/VPN/firewall, Docker Desktop daemon/global settings, other app resources.
- No actual Stripe/Resend/OAuth/Umami/Neon keys, logins, sending, charge/refund/webhook or affiliate withdrawals; no Secret values or hashes in chat/repo/Evidence.
- Current known admin privilege escalation must be remediated BEFORE G1 user-account testing. Localhost alone does not excuse that prerequisite.
- UNKNOWN stays UNKNOWN, no PASS from executor self-report, no broad prune/deletion, no production deployment.

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 local Codex; chat relay of bounded redacted read-only Evidence to Reviewer. Reviewer persists accepted documentation via GitHub. No local repo checkout required for G0.

## CURRENT_ROLLBACK_STATUS
G1 changed only the isolated lab checkout and created app/migrator images, project-only healthy empty-schema PostgreSQL container, isolated network and volume (as Owner-relayed). `G1_LOCAL_ROLLBACK_PLAN.md` reportedly present but not Reviewer-inspected. Preserve the retained state; no app container exists, no DB/data deletion, prune, Compose down -v, password reset or DB replacement authorized. G1R only read resources; rollback NOT_APPLICABLE. Existing images, uncommitted 18 local changes, healthy original DB and original volume remain preserved. G1S newly authorized but not yet executed; old database and existing images remain preserved. New project separately namespaced; no deletion or old password reset authorized.

## UNRESOLVED
G1R evidence now classifies reset denial at CreateProcess (NOT_STARTED, no DB write). Existing approved password recovery store and separate artifact UNKNOWN; source 18-file local diff not yet Reviewer-readable; original empty DB identity/healthy resources retained (Owner-relayed). G1 app builds remain Executor-reported, not Reviewer-inspected; schema, runtime DB adapter, app/auth/provider negatives, persistence NOT_TESTED. Approved G1S still requires fresh proof of allowed execution channel and safe encrypted Secret recovery. If these cannot be established, RETURN; no bypass or weak fallback. No numeric RAM gate. No RAM numeric gate; source pin and no real Provider/Secret/public network remain.

## NEXT_STEP
Owner hands latest `G1S_NEW_TEST_DB_AND_LOCAL_SMOKE_GATE.md` relay to Windows-local Codex. Executor first proves target and policy-permitted NEW DB operation + protected encrypted Secret storage, then conditionally creates new separate DB, schema and localhost app smoke. Old DB unchanged; any rejected process stops (no fallback), no rebuild if current images remain compatible.

## OWNER_ACTION_REQUIRED
Owner has approved scoped G1S. Pass new active G1S relay to Windows-local Codex; no password paste, owner manual SQL, admin elevation, external Provider or host global settings authorized.

## EVIDENCE_POINTERS
`EXECUTION_EVIDENCE.md`: append-only G0, scoped RAM override and G1 RETURN/PARTIAL reported footprint; `DECISION_LOG.md`: RAM waiver; `G1_LOCAL_HARDEN_COMPOSE_GATE.md`: returned previous Gate; `G1R_DB_CREDENTIAL_RECOVERY_DIAGNOSTIC_GATE.md`: completed diagnostic PASS (historical); `G1S_NEW_TEST_DB_AND_LOCAL_SMOKE_GATE.md`: active Owner-approved G1S; `G1S_NEW_TEST_DB_RECOVERY_PROPOSAL.md`: historical proposal retained with stale pending status text (archival update blocked), NOT the active Gate; `G0R_RESOURCE_READONLY_GATE.md`: superseded history.
