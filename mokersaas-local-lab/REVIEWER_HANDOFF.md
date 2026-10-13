# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0_READONLY_DISCOVERY_READY。仅 Reviewer 的 GitHub 源码初检完成；Owner 本机没有执行本项目安装/部署/实际测试的已接受证据。

## SYSTEM_MAP
- Source: https://github.com/ItusiAI/MokerSaaS , upstream main observed c98f68c68de312cc1378130b96f82418e22bd5f3 (2026-09-14).
- Runtime: Next.js 16.3.0 + React 19, NextAuth v4; pnpm packageManager 9.15.0; Drizzle ORM + PostgreSQL schema/migrations; app Next.js API routes; subscription expiry cron and email/marketing flows.
- DB incompatibility caveat: lib/db.ts uses `@neondatabase/serverless` `neon(...)` + `drizzle-orm/neon-http`; plain local Docker PostgreSQL TCP is not proven compatible. Possible G1 app-only driver swap to `postgres`/`drizzle-orm/postgres-js` must be planned/reviewed, not assumed.
- Required runtime environment: DATABASE_URL; NEXTAUTH_SECRET / NEXTAUTH_URL; module `lib/email.ts` throws when RESEND_API_KEY absent; other optional/provider Stripe, OAuth, Umami, cron may require fail-closed local stubs for isolated tests. No Secret values stored here.
- No official root Dockerfile/Compose observed; build/config safety caveat `next.config.mjs` sets `typescript.ignoreBuildErrors: true`.
- Confirmed blocker: `app/api/admin/set-admin/route.ts` GET/POST performs `users.role='admin'` without checking caller authorization; `proxy.ts` excludes /api. MUST remove/disable this endpoint before G1 accounts/functional smoke; do not exercise existing unsafe endpoint on public origin. Admin user operations elsewhere use `isAdmin()`.
- Referral code contains multi-step DB reward mutations in `lib/referral.ts`; atomicity/idempotency/refund reversal are UNVERIFIED.
- Owner Windows 11 real runtime identity/available memory/ports/Docker Engine status are UNKNOWN for this Moker round. Previous BettaFish local-lab reported resource pressure (~1.4 GiB host available), not a fresh Moker preflight.
- Recommended eventual G1: isolated code checkout, localhost-only app host port, internal-only Postgres DB (no published DB port), project-specific Compose project/volumes, mock email/provider endpoints, no external account usage. Not authorized by G0.

## CURRENT_ACCEPTED_STATE
Governance v0.2.7 fully read by Reviewer (universal + all 11A–11G trigger scan, triggered 11A–11E/closeout boundary). Upstream root/README/package/db/auth/stripe/email/referral/admin API files inspected through GitHub. This is a source review, NOT Windows-local read-back, runtime readiness or functional PASS.

## CURRENT_GATE
`MOKER-G0-LOCAL-READONLY-DISCOVERY-20261013` in `G0_LOCAL_READONLY_DISCOVERY_GATE.md`, mandatory Reviewer stop. Missing accepted local runtime truth means G0 must not proceed to installation or service start.

## CRITICAL_CONSTRAINTS
- Executor only Owner real Windows 11 local Codex; no Grok Bot/VPS/remote runners.
- G0 read-only: no Git clone, dependency installation, Docker pull/build/up, config/write, port binding, admin elevation, system cleanup or payment/customer actions. Reviewer owns canonical GitHub persistence; local Git management repo checkout not required.
- No change to Clash Verge, HY2, WireGuard, host routes/TUN/proxy/VPN/firewall, Docker Desktop daemon/global settings, other app resources.
- No actual Stripe/Resend/OAuth/Umami/Neon keys, logins, sending, charge/refund/webhook or affiliate withdrawals; no Secret values or hashes in chat/repo/Evidence.
- Current known admin privilege escalation must be remediated BEFORE G1 user-account testing. Localhost alone does not excuse that prerequisite.
- UNKNOWN stays UNKNOWN, no PASS from executor self-report, no broad prune/deletion, no production deployment.

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 local Codex; chat relay of bounded redacted read-only Evidence to Reviewer. Reviewer persists accepted documentation via GitHub. No local repo checkout required for G0.

## CURRENT_ROLLBACK_STATUS
G0 makes no runtime/source changes: rollback NOT_APPLICABLE. For later G1, plan isolated Compose namespace, durable DB volumes and exact teardown/backup boundaries before writes.

## UNRESOLVED
Real target proof, memory/CPU/Docker allocation, ports/source checkout collisions, runtime build constraints and dependency lock choice, local Neon HTTP replacement method, safe fake/disabled Resend behavior, Stripe test-mode integration, safe admin bootstrap, browser/DB/function/negative test fixtures, rollback/restart persistence.

## NEXT_STEP
Pass G0 Relay to Owner's physical Windows local Codex. Reviewer assesses evidence and prepares bounded G1 project-only adapter/security patch + Docker local deployment with negative tests. No auto-continue.

## OWNER_ACTION_REQUIRED
Pass relay; no keys/payments/admin elevation required. Do not manually install components or adjust networking for G0.

## EVIDENCE_POINTERS
`G0_LOCAL_READONLY_DISCOVERY_GATE.md` (active Gate); upcoming append-only `EXECUTION_EVIDENCE.md` after Reviewer checks Codex report; no completed Windows-local evidence yet.
