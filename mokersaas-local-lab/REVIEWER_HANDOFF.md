# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-16
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0 discovery-only PASS (Reviewer 2026-10-13); G0R `SUPERSEDED_NOT_EXECUTED` by Owner scoped 2026-10-16 decision; G1 `READY_FOR_OWNER_LOCAL_EXECUTOR`. No Moker source installation/build/container launch or business tests yet.

## SYSTEM_MAP
- Source: https://github.com/ItusiAI/MokerSaaS , upstream main observed c98f68c68de312cc1378130b96f82418e22bd5f3 (2026-09-14).
- Runtime: Next.js 16.3.0 + React 19, NextAuth v4; pnpm packageManager 9.15.0; Drizzle ORM + PostgreSQL schema/migrations; app Next.js API routes; subscription expiry cron and email/marketing flows.
- DB incompatibility caveat: lib/db.ts uses `@neondatabase/serverless` `neon(...)` + `drizzle-orm/neon-http`; plain local Docker PostgreSQL TCP is not proven compatible. Possible G1 app-only driver swap to `postgres`/`drizzle-orm/postgres-js` must be planned/reviewed, not assumed.
- Required runtime environment: DATABASE_URL; NEXTAUTH_SECRET / NEXTAUTH_URL; module `lib/email.ts` throws when RESEND_API_KEY absent; other optional/provider Stripe, OAuth, Umami, cron may require fail-closed local stubs for isolated tests. No Secret values stored here.
- No official root Dockerfile/Compose observed; build/config safety caveat `next.config.mjs` sets `typescript.ignoreBuildErrors: true`.
- Confirmed blocker: `app/api/admin/set-admin/route.ts` GET/POST performs `users.role='admin'` without checking caller authorization; `proxy.ts` excludes /api. MUST remove/disable this endpoint before G1 accounts/functional smoke; do not exercise existing unsafe endpoint on public origin. Admin user operations elsewhere use `isAdmin()`.
- Referral code contains multi-step DB reward mutations in `lib/referral.ts`; atomicity/idempotency/refund reversal are UNVERIFIED.
- Moker G0 Owner-local Codex reported native Windows 11 Home build 26300, PS 7.6.5, x64 non-admin, host RAM total 15.28 GiB and free 0.81–1.44 GiB, disk 205.25 GiB free, Docker Desktop Engine client/server 29.7.2, Engine capacity 7.40 GiB, Compose 5.4.0, ports 3077/5432 unbound, no Moker containers/images/networks/volumes. Physical machine ownership remains OWNER_REPORTED to Reviewer; these runtime readings are Executor-reported, not Reviewer direct host access. Owner waived the project-specific numeric 4 GiB free-memory threshold on 2026-10-16, but actual resource failure/instability remains a hard stop.
- Current authorized bounded G1: isolated exact-commit checkout, server-side admin route disable, local Postgres adapter, fail-closed provider/email/cron boundaries, scoped Compose app+DB with 127.0.0.1:3077 only, single bounded build/start and basic smoke after prerequisites. This is planned execution, not yet verified.

## CURRENT_ACCEPTED_STATE
Governance v0.2.7 verified unchanged; Reviewer accepted G0 as discovery-only PASS from Owner-relayed Codex Evidence, independent source spot checks, ACTUAL_CHANGES=NONE. Owner on 2026-10-16 expressly removed only the numeric ~4 GiB threshold and instructed next Gate; Reviewer recorded `MOKER-D-20261016-NO-RAM-NUMERIC-GATE`. G0R proposed earlier remains SUPERSEDED_NOT_EXECUTED, not PASS; G1 Gate now authorized and READY_FOR_EXECUTOR. No local runtime change observed or claimed.

## CURRENT_GATE
`MOKER-G1-LOCAL-HARDEN-COMPOSE-SMOKE-20261016` in `G1_LOCAL_HARDEN_COMPOSE_GATE.md`, bounded project-scoped local hardening + conditional localhost Compose build/start, mandatory Reviewer stop. G0R resource-only Gate is superseded, not executed.

## CRITICAL_CONSTRAINTS
- Executor only Owner real Windows 11 local Codex; no Grok Bot/VPS/remote runners.
- G1 alone now authorizes new clean isolated source checkout, minimal project-scoped hardening and Docker artifacts, bounded pinned dependency/image download, conditional Compose build/start and private localhost smoke. No unreviewed codebase expansion, other workspace changes, account login, or next-Gate actions. Reviewer owns GitHub Evidence/Handoff persistence.
- No change to Clash Verge, HY2, WireGuard, host routes/TUN/proxy/VPN/firewall, Docker Desktop daemon/global settings, other app resources.
- No actual Stripe/Resend/OAuth/Umami/Neon keys, logins, sending, charge/refund/webhook or affiliate withdrawals; no Secret values or hashes in chat/repo/Evidence.
- Current known admin privilege escalation must be remediated BEFORE G1 user-account testing. Localhost alone does not excuse that prerequisite.
- UNKNOWN stays UNKNOWN, no PASS from executor self-report, no broad prune/deletion, no production deployment.

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 local Codex; chat relay of bounded redacted read-only Evidence to Reviewer. Reviewer persists accepted documentation via GitHub. No local repo checkout required for G0.

## CURRENT_ROLLBACK_STATUS
G0 read-only and no rollback needed. G1 source + Compose writes authorized only after project-scope/preflight/rollback proof; target changes still NONE as of this record. Isolated source, volumes and manifest must be preserved and explicitly accounted for; no automatic data volume deletion or global prune.

## UNRESOLVED
Physical host attribution remains Owner-reported; numerical RAM admission criterion removed, fresh resource observation is informational unless actual instability/failure. Port observations valid only at G0 and need re-probe before binding. Node/pnpm freeze, Neon HTTP -> local Postgres adapter, migration journal empty, fail-closed Resend/OAuth/Stripe/Cron isolation, secure admin bootstrap, referral/payment/refund idempotency, TS proof and rollback/restart are G1+ unresolved until Executor proof.

## NEXT_STEP
Pass new G1 relay to Owner's physical local Codex. Executor may create project-scoped checkout, remediate privilege issue and offline adapters, prepare isolated Compose and proceed to one localhost-only build/start/smoke only if every security/rollback/manifest precondition passes. Reviewer independently reviews results, then decides subsequent payment/referral Gate. Do not repeat G0R.

## OWNER_ACTION_REQUIRED
Pass G1 relay to Windows-local Codex; no need to close apps to meet an arbitrary RAM target. No real credentials, paid provider/account action, admin elevation, or shared Docker/WSL/network changes authorized.

## EVIDENCE_POINTERS
`EXECUTION_EVIDENCE.md`: append-only G0 accept and 2026-10-16 Owner override; `DECISION_LOG.md`: scoped RAM-gate waiver and retained safety; `G0_LOCAL_READONLY_DISCOVERY_GATE.md`: accepted history; `G0R_RESOURCE_READONLY_GATE.md`: SUPERSEDED_NOT_EXECUTED; `G1_LOCAL_HARDEN_COMPOSE_GATE.md`: sole active Executor Gate.
