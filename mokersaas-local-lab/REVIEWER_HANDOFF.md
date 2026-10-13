# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0 discovery-only PASS (Reviewer 2026-10-13); G0R_RESOURCE_READONLY_READY. G1 local build/deploy BLOCKED_RESOURCE while latest 1.44 GiB host free; no runtime installation or functional tests have occurred.

## SYSTEM_MAP
- Source: https://github.com/ItusiAI/MokerSaaS , upstream main observed c98f68c68de312cc1378130b96f82418e22bd5f3 (2026-09-14).
- Runtime: Next.js 16.3.0 + React 19, NextAuth v4; pnpm packageManager 9.15.0; Drizzle ORM + PostgreSQL schema/migrations; app Next.js API routes; subscription expiry cron and email/marketing flows.
- DB incompatibility caveat: lib/db.ts uses `@neondatabase/serverless` `neon(...)` + `drizzle-orm/neon-http`; plain local Docker PostgreSQL TCP is not proven compatible. Possible G1 app-only driver swap to `postgres`/`drizzle-orm/postgres-js` must be planned/reviewed, not assumed.
- Required runtime environment: DATABASE_URL; NEXTAUTH_SECRET / NEXTAUTH_URL; module `lib/email.ts` throws when RESEND_API_KEY absent; other optional/provider Stripe, OAuth, Umami, cron may require fail-closed local stubs for isolated tests. No Secret values stored here.
- No official root Dockerfile/Compose observed; build/config safety caveat `next.config.mjs` sets `typescript.ignoreBuildErrors: true`.
- Confirmed blocker: `app/api/admin/set-admin/route.ts` GET/POST performs `users.role='admin'` without checking caller authorization; `proxy.ts` excludes /api. MUST remove/disable this endpoint before G1 accounts/functional smoke; do not exercise existing unsafe endpoint on public origin. Admin user operations elsewhere use `isAdmin()`.
- Referral code contains multi-step DB reward mutations in `lib/referral.ts`; atomicity/idempotency/refund reversal are UNVERIFIED.
- Moker G0 Owner-local Codex reported native Windows 11 Home build 26300, PS 7.6.5, x64 non-admin, host RAM total 15.28 GiB and free 0.81–1.44 GiB, disk 205.25 GiB free, Docker Desktop Engine client/server 29.7.2, Engine capacity 7.40 GiB, Compose 5.4.0, ports 3077/5432 unbound, no Moker containers/images/networks/volumes. Physical machine ownership remains OWNER_REPORTED to Reviewer; these runtime readings are Executor-reported, not Reviewer direct host access. Host free memory not sufficient for G1 combined first build/up confidence.
- Recommended eventual G1: isolated code checkout, localhost-only app host port, internal-only Postgres DB (no published DB port), project-specific Compose project/volumes, mock email/provider endpoints, no external account usage. Not authorized by G0.

## CURRENT_ACCEPTED_STATE
Governance v0.2.7 current verified; Reviewer accepted G0 evidence as discovery-only PASS after reading Owner-relayed Codex report and independently checking pinned source lib/db.ts, drizzle/meta/_journal.json (empty migration entries), and unauthenticated admin role elevation code. G0 Executor reported RETURN_REVIEWER_REVIEW_REQUIRED (mandatory review stop), ACTUAL_CHANGES=NONE. No Moker runtime started; host evidence remains relayed, not Reviewer direct access. Resource constraint OPEN; G1 not authorized.

## CURRENT_GATE
`MOKER-G0R-RESOURCE-READONLY-20261013` in `G0R_RESOURCE_READONLY_GATE.md`, mandatory Reviewer stop. Do not re-run whole G0. Only read-only resource headroom evidence; no G1 install/build/up.

## CRITICAL_CONSTRAINTS
- Executor only Owner real Windows 11 local Codex; no Grok Bot/VPS/remote runners.
- Current G0R read-only: no Git clone, dependency installation, Docker pull/build/up, config/write, port binding, admin elevation, system cleanup or payment/customer actions. Reviewer owns canonical GitHub persistence; local Git management repo checkout not required. G1 requires a fresh reviewed Gate, separate resource decision and rollback.
- No change to Clash Verge, HY2, WireGuard, host routes/TUN/proxy/VPN/firewall, Docker Desktop daemon/global settings, other app resources.
- No actual Stripe/Resend/OAuth/Umami/Neon keys, logins, sending, charge/refund/webhook or affiliate withdrawals; no Secret values or hashes in chat/repo/Evidence.
- Current known admin privilege escalation must be remediated BEFORE G1 user-account testing. Localhost alone does not excuse that prerequisite.
- UNKNOWN stays UNKNOWN, no PASS from executor self-report, no broad prune/deletion, no production deployment.

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 local Codex; chat relay of bounded redacted read-only Evidence to Reviewer. Reviewer persists accepted documentation via GitHub. No local repo checkout required for G0.

## CURRENT_ROLLBACK_STATUS
G0/G0R are read-only: rollback NOT_APPLICABLE. For later G1, plan isolated Compose namespace, durable DB volumes, exact rollback/backup semantics before writes; none of these have been implemented.

## UNRESOLVED
Physical host attribution remains Owner-reported; future fresh pre-build resources required (previous free RAM 0.81–1.44 GiB). Port observations valid only at G0; rerun at future actual bind. Node engine/pnpm freeze, Neon HTTP -> local Postgres adapter, migrations journal empty, fail-closed Resend/OAuth/Stripe/Cron isolation, admin bootstrap, referral/payment/refund idempotency and security, TypeScript proof, rollback/restart persistence are G1+ unresolved.

## NEXT_STEP
Owner can voluntarily close nonessential apps after saving work, then pass G0R resource relay to local Codex; Reviewer reviews resource proof. On sufficient memory Reviewer may prepare separate G1 source/security+Docker Gate; if still under reviewer planning threshold, select smaller footprint or defer build with a new reviewed Gate.

## OWNER_ACTION_REQUIRED
Pass G0R relay; optional Owner-directed closure of their own nonessential apps only, no Codex process killing, no account keys/payments/administrator actions or network/Docker changes.

## EVIDENCE_POINTERS
`EXECUTION_EVIDENCE.md`: Reviewer-recorded G0 discovery PASS and provenance; `G0_LOCAL_READONLY_DISCOVERY_GATE.md`: accepted G0 boundary; `G0R_RESOURCE_READONLY_GATE.md`: active pending read-only resource Gate.
