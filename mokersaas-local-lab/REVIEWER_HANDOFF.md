# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-17
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G0 PASS discovery, G0R waived by Owner, G1 partial source/build RETURN, G1R diagnostic PASS, G1S old attempt RETURN without a new DB write, G1P DB-secret source prep accepted except NextAuth issue, **G1P2 PASS (session secret via file + TypeScript/Next 16 build)**. Owner's disposable synthetic only no-offhost-recovery exception is NOW durably recorded in DECISION_LOG. **CURRENT G1T READY_FOR_OWNER_LOCAL_EXECUTOR**: NEW independent project DB/schema and 127.0.0.1:3077 smoke. Current site NOT_RUNNING and no G1T resources have been reported; no G2 payments/referral authorization.

## SYSTEM_MAP
- Fixed upstream: https://github.com/ItusiAI/MokerSaaS c98f68c68de312cc1378130b96f82418e22bd5f3. Owner-local isolated checkout `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab`, 22 scoped modified/new paths (all uncommitted) reported as of G1P2.
- Next.js 16.3.0 / NextAuth v4, Node22 pnpm9.15.0. Local app DB now postgres-js/Drizzle with LOCAL_LAB file-backed DB credential in `lib/local-db-config.ts`; Drizzle config uses same getDatabaseUrl helper. NextAuth `authOptions.secret` uses file reader under LOCAL_LAB (`lib/local-auth-config.ts`); old production env behavior unchanged. Build-phase helper branches and actual TS/Next build reported PASS.
- `docker-compose.g1s.yml`: NEW project `mokersaas-local-lab-g1s`, distinct PostgreSQL service/volume/internal network, DB secret file available only to DB+migrator+app as needed, separate session-secret file mounted only to app; app published only 127.0.0.1:3077:3000. Secret file paths refer to future protected directory outside Git/build; actual files and ACL not yet created/tested.
- New G1P2 image `mokersaas-local-lab-g1p2/app:auth-secret-file-fix-20261017` ID `sha256:5692813e121e043d15a4dad133e89f32a8574954d0eb12f9ed8f0f622fd10889`. Pre-G1P app/migrator images remain retained. New migrator image may need one bounded rebuild to include latest Drizzle DB helper.
- Historical unsafe unauthenticated GET/POST `/api/admin/set-admin` existed upstream; G1 owner-local patch reportedly turns both into 404, but not yet runtime-proven. Other lab Stripe/Resend/OAuth/Cron/affiliate/Umami fail-closed patches reported; verify static source before first app start and negative behavior after start. Referral/payment concurrency/refund not G1T scope.
- Original old DB `mokersaas-local-lab-db-1`, volume `mokersaas-local-lab-db-data`, network `mokersaas-local-lab-network` and old images are NOT new G1T targets; original DB role password lost/unverified, never reset/reuse/delete under this project Gate.
- Physical host Owner reported Windows 11 Home build 26300, PowerShell 7.6.5, x64 non-admin, Docker Desktop 29.7.2 Engine, Compose 5.4.0; 3077/5432 last seen without host listeners. Host available RAM numeric gate waived; actual system/Docker instability remains return.

## CURRENT_ACCEPTED_STATE
Owner granted `MOKER-D-20261017-APPROVE-G1S-NEW-DB` for independent new disposable DB+local smoke, and `MOKER-D-20261017-DISPOSABLE-RECOVERY-EXCEPTION` to waive **only** off-host encrypted Secret recovery copy for synthetic disposable credentials; the latter is now confirmed written to DECISION_LOG by GitHub commit 7f1511d9e3a376425a1acd66be5d94b2d0354f04. No Governance universal rule edit. Local CSPRNG, protected ACL, file readers, no credentials in env/log/CLI/Git/build, old DB preservation and runtime negative guards remain mandatory. G1P2 source/build Reviewer PASS from Owner-relayed local Codex evidence; G1T **only Gate READY**, local startup and secrets NOT executed. Prior G1 password-reset CreateProcess denial was old-target specific and cannot be retried via other tools; it is not proof that a NEW distinct operation will be rejected. Actual future denial requires STOP.

## CURRENT_GATE
`MOKER-G1T-NEW-DB-LOCALHOST-SMOKE-20261017` in `G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md`, READY_FOR_OWNER_LOCAL_EXECUTOR. One conditional combined new DB/credential/schema/app/localhost/auth/provider-negative smoke; mandatory STOP_AT_REVIEWER=YES. Supersedes no older docs: prior G1S returned and G1P2 completed, do not replay them.

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
Deliver only the active G1T relay to Owner-local Codex now. No additional Owner confirmation, new RAM diagnostic, G1P2 rebuild or G1S replay. Executor conditionally sets up a NEW lab DB and separate protected file credentials, bootstraps schema and starts site `http://127.0.0.1:3077` with negative tests. If actual hard native/policy/safety failure occurs, preserve partial assets, return precise reason and Reviewer judges. Otherwise hand back local URL and evidence, mandatory STOP_AT_REVIEWER.

## OWNER_ACTION_REQUIRED
Pass active `G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md` to Windows-local Codex. No secret values, manual SQL, USB/OneDrive, extra Owner approval, admin elevation, Provider accounts or memory-pressure cleanups required. Owner's disposable-only risk acceptance is now durably documented and no longer a blocker.

## EVIDENCE_POINTERS
`DECISION_LOG.md`: original G1S new DB consent + later temporary disposable-only off-host Secret recovery exception; `EXECUTION_EVIDENCE.md`: G1P2 PASS, decision reconciliation and G1T activation, not runtime PASS; `G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md`: current sole active Executor Gate; `G1P2_AUTH_SECRET_FILE_FIX_GATE.md`: completed PASS, historical; `G1S_NEW_TEST_DB_AND_LOCAL_SMOKE_GATE.md`: old RETURN and not executable; `G1S_NEW_TEST_DB_RECOVERY_PROPOSAL.md`: obsolete proposal with historically stale pending label.

