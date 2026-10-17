# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-17
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0 discovery PASS; G0R Owner-waived; G1 technical prep PARTIAL/RETURN; G1R diagnostic PASS; G1S no-write preflight RETURN; G1P SOURCE REVIEW RETURN on NextAuth ENV secret; **G1P2 source/session-secret+TypeScript/Next 16 build PASS (Reviewer 2026-10-17)**. Pinned source project-local worktree now reports 22 changed paths; new G1P2 app image `sha256:5692813e121e043d15a4dad133e89f32a8574954d0eb12f9ed8f0f622fd10889`; original DB/volume/network/images preserved. No new DB/schema/site/startup yet. G2/real payments not authorized.

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
G1P2 Executor source/code and native build report reviewed from Owner's relay, including actual minimal four-file diff. Lab `authOptions.secret` calls protected-file helper in LOCAL_LAB mode; Compose mounts separate file only for app and removes runtime NEXTAUTH_SECRET env value. File helper build-phase returns undefined, missing runtime file fails closed; legacy nonlab behavior retained. Dockerfile removed placeholder NEXTAUTH_SECRET, existing DB file-secret seam untouched. Executor reports pinned-image TypeScript `tsc --noEmit=0`, Next.js 16.3.0 build=0, Compose parse=0, git diff check=0; Reviewer gives `PASS` **G1P2 only**, not site/auth/runtime. Original containers/volumes unchanged; new compiled app image ID recorded in EXECUTION_EVIDENCE. Actual site `http://127.0.0.1:3077` has no listener. Separate only-disposable synthetic DB off-host encrypted recovery-copy waiver was explicitly agreed by Owner in chat but DECISION_LOG write was blocked by tool safety and never committed; do not claim active published exception or start DB based on that unrecorded status.

## CURRENT_GATE
No active **Executor mutation/runtime Gate** immediately after accepted G1P2. G1P2 historical Gate now completed code/build PASS. Next bounded G1T runtime/DB gate must be separately reviewed and have a permissible documented Secret custody/rollback/recovery boundary. G1S returned and must NOT be rerun; G1/G1P edits and G1P2 build already completed.

## CRITICAL_CONSTRAINTS
- ONLY Owner physical Windows 11 native local Codex may act on isolated `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab` project. No remote runner/Grok bot/VPS/other projects.
- Source 22 paths and original pinned HEAD `c98f68c68de312cc1378130b96f82418e22bd5f3` preserved; prior app/migrator images plus new G1P2 image retained. Original `mokersaas-local-lab-db-1`, `mokersaas-local-lab-db-data`, internal network untouched; never reset or delete old DB. There is currently NO approved DB/credential/start Gate.
- Previously denied old Postgres role password reset `CreateProcess` cannot be retried using alternate shell/Docker/agent. A distinct new-target operation is not inherently denied, but actual tool policy refusal remains a STOP.
- No numeric RAM threshold; actual OOM/system instability stops. No Docker/WSL daemon changes, VPN/Clash/HY2/WG/TUN/proxy/network/firewall changes, broad prune or other project disruption.
- No real Stripe, Resend, OAuth, Neon, Umami, payment, refund, email, affiliate payout, production secrets or private customer data; no public network binding.
- Protected local credential files must stay outside source/build, least-privilege ACL and only intended reader; no plaintext values/hashes in env, CLI, logs, chat or Git. Owner chat exception to separate off-host recovery for disposable-only synthetic DB is NOT committed in DECISION_LOG due policy-blocked write; do not bypass previous blocked archival action via another tool.
- Runtime NextAuth file mount/actual login/session/404+403 negative provider tests and DB schema remain NOT_VERIFIED. Reviewer owns canonical evidence and all Gate decisions. STOP_AT_REVIEWER=YES.

## DEFAULT_EXECUTION_CHANNEL
Owner physical Windows 11 local Codex, project-only checkout. Reviewer manages canonical GitHub docs; Executor reports compact sanitized Evidence in chat. No additional GitHub commit from Executor without later reviewed authorization.

## CURRENT_ROLLBACK_STATUS
G1P2 only created/modified `lib/auth.ts`, `lib/local-auth-config.ts`, `docker-compose.g1s.yml`, `Dockerfile` plus new project-only app image; no DB/Secret/container start. Old 21 G1/G1P paths, images and original database resources retained. Revert ONLY G1P2 patch if later authorized; no rollback executed and no volume deletion.

## UNRESOLVED
(1) Runtime secure credential creation/storage: protected Windows external source directory and Docker reader ACL untested; separate DB + NextAuth file Secret mount not exercised. (2) Owner chat-scoped off-host encrypted recovery exception is explicit but DECISION_LOG archival write blocked; not a published exception under present Governance. (3) G1P2 app image built, but actual localhost URL/app health/database schema/login/security/Stripe provider-negative tests NOT_STARTED. (4) Source G1 inherited other 18 paths were not fully line-reviewed; static guard claims require runtime negative and scope checks. (5) Docker `internal:true` loopback published port reachability/NextAuth cookie behavior on Windows remains unverified. (6) no actual CreateProcess denial for NEW DB command; cannot preemptively infer permission or denial.

## NEXT_STEP
Do not request more code edits or Docker build merely for G1P2; PASS completed. Once proper canonical exception persistence or an independently recoverable protected Secret option is available, Reviewer issues ONE narrowly scoped G1T new synthetic DB/start/smoke Gate using existing G1S code + G1P2 app build. Confirm no real secrets/payment/external calls, create new side-by-side DB only, validate Secret ACL, build/source image applicability (new G1P2 app image), schema/app/auth security/provider fail-closed, old DB no delta, rollback. If tool blocks allowed NEW action, stop, do not route via alternate. Do not silently use chat-only exception as completed persistence.

## OWNER_ACTION_REQUIRED
No immediate action needed for G1P2 (Reviewer PASS). To advance to runtime, the project must resolve Secret recovery exception persistence/allowed custody; Owner already explicitly consented in chat to disposable-only off-host-copy waiver, so do not ask again. Do not ask Owner to send actual credentials/SQL or perform admin/global Docker changes.

## EVIDENCE_POINTERS
`EXECUTION_EVIDENCE.md`: append-only G1P2 Reviewer PASS, source hashes/image ID, runtime not performed; `DECISION_LOG.md`: RAM waiver and original G1S approval, but separate disposable Secret recovery exception still NOT PERSISTED (a previous update attempt was tool-safety blocked); `G1P2_AUTH_SECRET_FILE_FIX_GATE.md`: complete G1P2; `G1P_CODE_ONLY_SECRET_SEAM_GATE.md`: earlier code review RETURN, resolved by G1P2; `G1S_NEW_TEST_DB_AND_LOCAL_SMOKE_GATE.md`: previous returned Gate, not executable.

