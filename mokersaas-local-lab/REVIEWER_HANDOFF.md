# MokerSaaS Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-17
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 / ACTIVE_PROVISIONAL (blob 3917c88a7f36df7a53758b3879a92703d659ef9d)
> Project namespace: entropy-student/project main:mokersaas-local-lab/
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
在 Owner 真实 Windows 11 本地、localhost 隔离方式评估并部署测试 ItusiAI/MokerSaaS，验证页面、认证、会员积分、推荐/佣金及 Stripe 测试/模拟流程的可行性，确定修复及商用成本；不产生真实交易或邮件、不开公网、不影响现有 VPS/VPN/其他 Docker 项目。

## PROJECT_STAGE
G1X **LOCALHOST FIRST BOOT DELIVERED / SITE_UP_ACCEPTED_FOR_OWNER_LOCAL_EVALUATION** on 2026-10-17, according to detailed Owner-forwarded local Executor DIRECT_READBACK. New synthetic Docker-native Secret volumes, independent G1S PostgreSQL (running/healthy), migrated schema, already-built G1P2 App (running/healthy), Windows host HTTP 200 at 127.0.0.1:3077 and narrow login/admin/provider negative checks reported. Historic G0–G1UV work summarized below/EXECUTION_EVIDENCE. **NO ACTIVE EXECUTOR GATE**: G1X completed, no rerun requested. Formal independent-audited Reviewer PASS is NOT ATTESTED solely from forwarded Executor report (Governance §7). G2, production, real payments and mail still not authorized.

## SYSTEM_MAP
- Fixed upstream `ItusiAI/MokerSaaS` SHA `c98f68c68de312cc1378130b96f82418e22bd5f3`; 22 project-scoped Owner-local uncommitted source/config changes retained. Windows 11 Home 26300, PowerShell 7.6.5, Docker Engine 29.7.2; local physical Owner ownership OWNER_REPORTED.
- App uses Next.js 16.3.0, NextAuth v4, Node22 + tested G1P2 image `sha256:5692813e121e043d15a4dad133e89f32a8574954d0eb12f9ed8f0f622fd10889`; local file-backed DB and NextAuth Secret readers. Migrator newly built using current Drizzle/DB helper image `sha256:63afa66cbc871809288bb2b4273b24f6d28823b9b38d0658d026f0cd7b1d36e5`; pinned pnpm downloaded from npm registry during build.
- Current `docker-compose.g1s.yml` G1X-scoped only: two DISTINCT G1X Docker-native secret-only named volumes, files `0:31001:0440` DB and `0:31002:0440` NextAuth, OS-CSPRNG generated 32-byte entropy independently. DB and migrator DB Secret only; app both, readonly and proved readable by its actual UID 1000. Previous Windows Secret files untouched; old G1U Secret volumes untouched, not reused as runtime values. No values/hashes in ordinary logs/env/args.
- New G1S Postgres uses retained G1S DB-data volume and `mokersaas-local-lab-g1s-internal` only; 5432 never host-published. App joins that internal network PLUS a distinct **G1S-only user-defined bridge network** with `enable_ip_masquerade=false` for working host publishing; app host bind ONLY `127.0.0.1:3077:3000` and reported Windows actual HTTP 200. Masquerade-off does not prove universal no-egress; local first-boot only.
- G1X DB new schema 17 public tables, 155 constraints, one synthetic user `role=user`. Local test: signup 200, signin 302, session 200, admin/users forbidden 403, anonymous GET/POST /api/admin/set-admin 404. Credentials-only OAuth; Stripe, webhook, portal, payout, cron 503; LOCAL_LAB=1, external provider keys count 0, suppressed mail, no business provider calls reported. These do NOT authorize real money.
- OLD separate database `mokersaas-local-lab-db-1`, original volume `mokersaas-local-lab-db-data`, its original network/images, 22 local changes and original protected Windows Secret files were preserved. Previously refused old DB role password-reset must never be retried through alternate transports.
- One empty Postgres-image anonymous audit volume retained; old G1TRF stopped audit container preserved. No cleanup/prune. Docker-local site and DB remain RUNNING as reported until Owner stops them.

## CURRENT_ACCEPTED_STATE
2026-10-17 Owner forwarded a G1X PASS_CANDIDATE with detailed local DIRECT_READBACK. G1X generated two distinct Docker-native synthetic Secrets and verified four DB Boolean checks PASS, app/migrator reader and no NextAuth cross-mount; retained old Windows credentials, old and G1U Secret volumes. New isolated Postgres running/healthy OOM=false, authenticated DB read; 17 public tables, 155 constraints; migrated after first Corepack/DNS failure (first run BEFORE Drizzle and DB still zero tables; one actual successful schema initialization). New migrator image sha256:63afa66cbc871809288bb2b4273b24f6d28823b9b38d0658d026f0cd7b1d36e5; reused G1P2 app image sha256:5692813e121e043d15a4dad133e89f32a8574954d0eb12f9ed8f0f622fd10889. App live with HTTP 200 on Owner Windows localhost 127.0.0.1:3077, narrow auth/admin and provider-negative tests passed by executor readback. Added G1S-only app bridge with masquerade disabled to expose loopback, DB remains on internal only. Scoped build downloaded fixed pnpm version from npm registry; no Stripe/Resend/Neon/OAuth calls or real customer data. One empty anonymous audit volume retained. Old database still healthy and old container ID/volume/network match before/after by reported metadata (not byte-wise database comparison). REVIEWER_DECISION: SITE_UP_ACCEPTED_FOR_OWNER_LOCAL_EVALUATION; G1X functional delivery completed, no further G1X Gate. **Formal independent audit PASS not attested**: no raw local Docker/HTTP/Compose artifacts accessible to Reviewer; Executor packet was inspected as claim rather than independent control-plane proof per Governance §7. Separate Reviewer decision file documents accepted observations and limits.

## CURRENT_GATE
**NONE — no active Executor Gate.** G1X_DOCKER_NATIVE_LOCAL_FIRST_BOOT_GATE.md is `PASS_CANDIDATE_REVIEWED__SITE_UP_ACCEPTED__COMPLETED_NOT_EXECUTABLE`; all earlier G0–G1UV Gates historic/completed/returned or superseded. Project is operationally at Owner localhost UI and product-fit evaluation, not another provisioning/diagnosis round. G2 payments/referral/production need new explicit scope/authorization and independent evidence in future, not implied here.

## CRITICAL_CONSTRAINTS
- Local lab only: preserve OLD separate DB/container/volume/network/images and do not attempt previously tool-policy-denied old password reset. Keep 22 Owner-local changes/source pinned; no Docker daemon/global network/VPN/WSL or unrelated project changes.
- Synthetic Docker-native Secret files in isolated volumes, readonly scoped DB/app/migrator mounts; original Owner/SYSTEM private Windows credentials preserved and UNUSED. Never show Secret content/hash or change/broaden ACL. No real customer data, real Provider account tokens/Stripe payment/mail/refund/payout/public routing.
- Site bound only to 127.0.0.1:3077 via project bridge, DB no published host port. `enable_ip_masquerade=false` reduces IPv4 masquerading but cannot alone certify absolute egress isolation; no production/public security certification inferred.
- No automatic cleanup, `down -v`, volume removal, prune, credential reset or rebuild solely for audit. Leave new app and Postgres running for Owner experience. Any later production/real-data/payment or destructive action requires independently authorized Gate; no active task is authorized right now.
- Reviewer cannot inspect physical host directly; distinguish Owner-forwarded Executor DIRECT_READBACK from independent Reviewer controls. Site functional delivery accepted but formal governance PASS requires actual reviewable primary Evidence (§7).

## DEFAULT_EXECUTION_CHANNEL
Owner physical Windows 11 local Codex, project-only checkout. Reviewer manages canonical GitHub docs; Executor reports compact sanitized Evidence in chat. No additional GitHub commit from Executor without later reviewed authorization.

## CURRENT_ROLLBACK_STATUS
Old DB `mokersaas-local-lab-db-1` plus volume `mokersaas-local-lab-db-data`, its network/images, old Windows protected files, earlier G1U Secret volumes, retained G1TRF audit container, new G1S DB-data volume/network and all local source changes preserved; G1X additionally created new two Docker Secret-only volumes, new current migrator image, separate G1S DB/schema, app container and loopback-serving bridge. One PostgreSQL anonymous audit volume was directly inspected empty and retained. No cleanup or rollback performed. Leave new App/DB RUNNING for Owner use. Future cleanup requires bounded exact-object inventory and authorization; do not perform now.

## UNRESOLVED
G1X functional first-boot objective delivered by Owner-local Executor readback. Remaining **nonblocking** items: independent reviewer access to primary Docker/HTTP/Compose redacted evidence for any future formal audited PASS; npm registry build-time download means build not strictly air-gapped; extra project-only app bridge/disable masquerade does not prove absolute zero external egress; one verified-empty audit anonymous Docker volume retained. These are not reasons for another G1X repair Gate or for stopping current local site. True production/payment/referral/scheduler/end-to-end financial testing is deliberately OUT OF SCOPE. Owner-local source/Secret bytes/Docker containers are NOT committed into GitHub project docs.

## NEXT_STEP
Owner now opens `http://127.0.0.1:3077` on the **same Windows PC with Docker Desktop running** and evaluates MokerSaaS functionality/UI/commercial fit. No Codex rerun/rebuild/redeploy is requested. G1X stopped at Reviewer after delivery; no G2 progression. If Owner later explicitly requests a functional evaluation, production readiness or payment feature phase, define a NEW goal and authorization; current first-boot phase is complete in practical terms.

## OWNER_ACTION_REQUIRED
NONE for deployment. Owner may open localhost in their PC browser and explore using only synthetic lab data. Do not ask them to supply passwords, approve a repetitive Gate or run Docker cleanup.

## EVIDENCE_POINTERS
G1X_REVIEWER_ACCEPTANCE_2026-10-17.md is the Reviewer decision and per-item observations/limitations; EXECUTION_EVIDENCE.md append-only G1X runtime results, build network exception and retained assets; DECISION_LOG.md holds synthetic lab approvals; README.md entry. G1X_DOCKER_NATIVE_LOCAL_FIRST_BOOT_GATE.md marked completed/not executable. Governance source `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.7; §7 independent evidence requirement. GitHub docs contain no actual raw Windows Docker/HTTP artifacts or worktree patch bytes.

