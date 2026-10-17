# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-17
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0 PASS; G0R RAM numeric threshold Owner-waived; G1 partial prep; G1R diagnostic PASS; G1S returned; G1P code preparation followed by G1P2 code/TypeScript/Next build PASS. **G1T RETURN_UNSUPPORTED_DOTNET_DIRECTORY_ACL_OVERLOAD**: the .NET method-resolution failed before any Secret/DB creation. **G1TR is the sole current READY Gate.** Old DB/volume/network/images and 22 source changes preserved according to local Executor. Website NOT_RUNNING; G2 not authorized.

## SYSTEM_MAP
- Fixed upstream: https://github.com/ItusiAI/MokerSaaS c98f68c68de312cc1378130b96f82418e22bd5f3. Owner-local isolated checkout `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab`, 22 scoped modified/new paths (all uncommitted) reported as of G1P2.
- Next.js 16.3.0 / NextAuth v4, Node22 pnpm9.15.0. Local app DB now postgres-js/Drizzle with LOCAL_LAB file-backed DB credential in `lib/local-db-config.ts`; Drizzle config uses same getDatabaseUrl helper. NextAuth `authOptions.secret` uses file reader under LOCAL_LAB (`lib/local-auth-config.ts`); old production env behavior unchanged. Build-phase helper branches and actual TS/Next build reported PASS.
- `docker-compose.g1s.yml`: NEW project `mokersaas-local-lab-g1s`, distinct PostgreSQL service/volume/internal network, DB secret file available only to DB+migrator+app as needed, separate session-secret file mounted only to app; app published only 127.0.0.1:3077:3000. Secret file paths refer to future protected directory outside Git/build; actual files and ACL not yet created/tested.
- New G1P2 image `mokersaas-local-lab-g1p2/app:auth-secret-file-fix-20261017` ID `sha256:5692813e121e043d15a4dad133e89f32a8574954d0eb12f9ed8f0f622fd10889`. Pre-G1P app/migrator images remain retained. New migrator image may need one bounded rebuild to include latest Drizzle DB helper.
- Historical unsafe unauthenticated GET/POST `/api/admin/set-admin` existed upstream; G1 owner-local patch reportedly turns both into 404, but not yet runtime-proven. Other lab Stripe/Resend/OAuth/Cron/affiliate/Umami fail-closed patches reported; verify static source before first app start and negative behavior after start. Referral/payment concurrency/refund not G1T scope.
- Original old DB `mokersaas-local-lab-db-1`, volume `mokersaas-local-lab-db-data`, network `mokersaas-local-lab-network` and old images are NOT new G1T targets; original DB role password lost/unverified, never reset/reuse/delete under this project Gate.
- Physical host Owner reported Windows 11 Home build 26300, PowerShell 7.6.5, x64 non-admin, Docker Desktop 29.7.2 Engine, Compose 5.4.0; 3077/5432 last seen without host listeners. Host available RAM numeric gate waived; actual system/Docker instability remains return.

## CURRENT_ACCEPTED_STATE
Both Owner approvals durably recorded in DECISION_LOG: new synthetic isolated DB/localhost smoke and temporary no-offhost-Secret-recovery exception only for disposable synthetic data. G1P2 app image built and verified from local Executor report. First G1T attempt returned at unsupported legacy .NET Directory.CreateDirectory overload before any directory/Secret/DB/container write. A scoped existing docker-compose.g1s.yml edit to use G1P2 image and remove app build was reported retained; exact current diff needs readback. No Docker commands or fresh post-return snapshots were performed in G1T. Microsoft documentation identifies modern FileSystemAclExtensions.CreateDirectory(DirectorySecurity,string), to be checked on the real PowerShell/.NET runtime before a NEW guarded write. Previously policy-denied OLD DB password reset must not be retried.

## CURRENT_GATE
**SOLE ACTIVE:** MOKER-G1TR-ACL-COMPAT-DB-LOCALHOST-20261017 in G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md, READY_FOR_OWNER_LOCAL_EXECUTOR. G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md is a historical failed attempt; its READY header is stale and has NO execution authority. One bounded continuation from modern .NET ACL creation through new separate DB/schema/localhost basic smoke, conditional on actual security checks. STOP_AT_REVIEWER=YES.

## CRITICAL_CONSTRAINTS
- Owner physical Windows 11 local Codex ONLY, fixed isolated source checkout; no VPS/cloud/Grok Bot/remote, other repos or shared projects.
- Preserve original DB/container/volume/network and every prior source edit and old images; new project under separate `mokersaas-local-lab-g1s` namespace and its own DB volume. No old role password reset or deletion/recreation. Never bypass actual tool policy denial by changing shell/helper/agent.
- New CSPRNG generated two distinct test-only credentials in protected file paths **outside checkout/build**, app/DB minimal ACL readers; no secret values/hashes in command args, ordinary env, GitHub, logs, stdout, image or chat. No off-host recovery copy required ONLY for disposable newly named synthetic lab; real or unique data invalidates exception.
- App binds ONLY `127.0.0.1:3077`; DB no host port; internal new project Docker network, no public/other networks. No numeric available-RAM limit; actual native failure/OOM stops.
- LOCAL_LAB fail-closed for unsafe admin promotion + Stripe/payment/webhooks/Resend/OAuth/cron/affiliate withdrawals and Umami; no genuine provider tokens, payments, email, customer data, callback acknowledgement or external effects. If audit before start cannot prove isolation, STOP.
- No Docker daemon/WSL, VPN/Clash/HY2/WireGuard/TUN/proxy, firewall, host global setting or unrelated ACL changes. No docker prune, volume delete, broad cleanup. Reviewer adjudicates actual evidence; Executor cannot go to G2.

## DEFAULT_EXECUTION_CHANNEL
Owner physical Windows 11 local Codex, project-only checkout. Reviewer manages canonical GitHub docs; Executor reports compact sanitized Evidence in chat. No additional GitHub commit from Executor without later reviewed authorization.

## CURRENT_ROLLBACK_STATUS
Original G1/G1P/G1P2 22-file source changes, original old DB/container/volume/network and preexisting app/migrator images remain; G1P2 adds one successfully built app image. G1T must snapshot these identities before any local write. If G1T partially creates new synthetic DB/Secret, keep durable named volume and protected files for Reviewer and stop only exactly new unsafe project services; do not delete/overwrite original or new volumes without separate Owner authorization. No G1T mutation yet.

## UNRESOLVED
G1T must prove: (1) exact Windows owner-local path/process and original resource no-delta; (2) new protected DB + NextAuth Secret file generation/ACL/mount (off-host copy is waived only for synthetic new lab); (3) new Postgres schema and constraints; (4) app loopback HTTP on physical Windows Docker Desktop and session/signup/login; (5) admin GET/POST 404/403 and role unchanged, ordinary user admin refusal; (6) actual Stripe/email/OAuth/cron/payout negative tests and no outbound effects; (7) source/image correspondence and migrator fresh build if needed; (8) safe rollback/persistence. Real refund/referral/payment remains out of scope.

## NEXT_STEP
Send active G1TR relay to Windows-local Codex. Read back existing Compose change/new namespace/old DB identity; verify current .NET ACL-aware atomic directory and file creation methods; if supported and allowed, secure two NEW test-only Secret files and continue in SAME Gate to isolated new PostgreSQL/schema and app at 127.0.0.1:3077, with auth/admin/provider negative tests. Do not replay G0/G1/G1P/G1P2 or old G1T; no extra preflight-only Gate. Actual native/policy/security failure returns precise evidence; no alternative path to circumvent denied action.

## OWNER_ACTION_REQUIRED
Owner needs only relay active G1TR to the local Codex, then return its evidence. No repeated approvals, Secret values, manual SQL, extra storage devices or numeric RAM gate.

## EVIDENCE_POINTERS
DECISION_LOG.md has both scoped Owner approvals. EXECUTION_EVIDENCE.md records G1P2 PASS, G1T ACL overload return, G1TR continuation rationale. G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md is the sole executable Gate. G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md contains a historically stale READY line (prior update blocked; not executable). Earlier G1P2 and G1S Gates are historical.

