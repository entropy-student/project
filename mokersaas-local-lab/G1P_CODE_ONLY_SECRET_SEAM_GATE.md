# MokerSaaS G1P — Source-only Local Secret Readiness

> REVIEWER 2026-10-17: All requested five-file code content was supplied and inspected. DB file-credential helper/Compose internal network design retained. **RETURN** on NextAuth session secret still passed as Compose environment variable. New single-purpose G1P2 Gate: `G1P2_AUTH_SECRET_FILE_FIX_GATE.md`. Prior relay below is historic and not executable.

> REVIEWER NOTE (2026-10-17): Owner-relayed Executor reports exactly five project-local source/config change paths and static validations; no DB/Secret/runtime changes. Exact current five-file local diff not yet supplied for Reviewer inspection. Gate is already executed; do not rerun code edits, re-install or rebuild. Next deliver **read-only, redacted** diff/content through chat, not a new source mutation.
> GATE_ID: MOKER-G1P-CODE-ONLY-SECRET-SEAM-20261017
> STATUS: REVIEWED_RETURN_NEXTAUTH_SESSION_SECRET_ENV_BOUNDARY — DO NOT REEXECUTE
> GOVERNANCE: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 (Reviewer interpreted)
> OWNER_AUTHORIZATION: Existing MOKER-D-20261017-APPROVE-G1S-NEW-DB covers bounded local code/Compose adapter changes. This narrower Gate has NO authority to create database, Secret or service, so no separate permission is needed to perform source-only changes.
> MAX_ENDPOINT_THIS_ROUND: modify ONLY isolated non-secret source/config required for safe file-backed local DB Secret consumption and Docker build-context exclusion; bounded non-network static/TypeScript validation if available
> MANDATORY_REVIEW_STOP: YES
> STOP_AT_REVIEWER=YES

## OBJECTIVE
Resolve the confirmed source-code blocker from G1S without recreating/recovering any database password or requiring an independent backup destination yet. Prepare a strictly project-local file-based Secret reader for *future* new DB, safe Compose example, and robust Docker build exclusions. Keep the existing G1 build work and all original DB assets.

## ACCEPTED STATE
- Upstream fixed c98f68c68de312cc1378130b96f82418e22bd5f3, in existing `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab` isolated local Windows checkout. Prior 18 uncommitted files are project-owned; preserve all. No changes to any other working trees.
- G0 discovery PASS, G1 RETURN after locally reported build, G1R diagnostic PASS. G1S returned **before writes**: new DB creation was NOT actually attempted or denied; current policy permission for such a distinct operation remains UNKNOWN. Earlier **old-role reset** command denied at CreateProcess; NEVER retry its effect through alternate tool/shell.
- Original DB container `mokersaas-local-lab-db-1`, volume `mokersaas-local-lab-db-data`, network `mokersaas-local-lab-network` and app/migrator images must remain unchanged. No app listening on 3077.
- Governance §11B requires protected Secret handling and separate encrypted recovery in a different failure domain unless Owner explicitly authorizes a narrowly scoped, permissible exception. **No such exception exists yet**. G1P does NOT create Secret or recovery copy and does NOT need them to edit nonsecret files.
- No fixed RAM numeric threshold; actual resource failure is reported. No live accounts, Stripe/Resend/OAuth/Umami, email, webhook, payment or external integration.

## TARGET, BOUNDARIES, PREFLIGHT
1. Executor must run on same Owner physical Windows 11 local Codex, verify non-sensitive host context, target path, pinned origin/HEAD, existing 18 scoped changes (including no unknown newly staged/untracked changes). Do not clone/rebase/reset or touch SaSS or other projects.
2. Ensure source file changes are distinct from blocked password reset operation, do not ask for/new generate/modify/reveal any password. Ordinary source edits may proceed under existing project authorization; there is no requirement to somehow guarantee in advance that an arbitrary future command will be allowed. If actual tool policy blocks a source write, STOP without rerouting/bypass and report the exact denied effect. No repeated alternate agent/tool/shell attempts.
3. Record original bounded diff/filenames and rollback before editing, preserve G1 18-file patch exactly except narrowly justified additions/edits.
4. Scope allowed for writes: only project-owned `lib/db.ts`, `drizzle.config.ts` if necessary, a small new private file-secret reader helper (e.g. `lib/local-db-config.ts`), `.dockerignore`, Compose **template** / `docker-compose.yml` only to prepare an unused, separate `mokersaas-local-lab-g1s` target, and non-secret local test docs. No real `secrets/` files or runtime data in source.
5. Never alter Docker volumes/networks/containers/images, Docker Desktop/WSL, network/proxy/VPN/Clash/HY2/WG, firewall, profile, Registry, global package settings; no install/pull/build/app/schema/start for this source-only Gate.

## EXECUTE — CODE PREPARATION
A. Inspect only local existing source diffs affecting `lib/db.ts`, `drizzle.config.ts`, `.dockerignore`, `Dockerfile`, `docker-compose.yml` and security-critical `set-admin`, auth/provider file guard changes. Summarize succinctly for Reviewer without secret or private content.
B. Add `LOCAL_LAB`-only support for an app/Drizzle migrator **file-backed** database credential. Use a known read-only mounted file at runtime, never `process.env.DATABASE_URL` or Compose environment for the *plaintext password*. Permitted nonsecret DB host/port/user/db-name fields may be env variables; combine in process memory inside server-only code with correct URL encoding, never emit connection string or password in logs. Preserve production/non-lab existing behavior without broad rewrite. Ensure Drizzle migrate/schema operations can later use identical Secret file boundary.
C. Prepare an additional/new Compose configuration for **future separate project** only, with precise app loopback publish `127.0.0.1:3077:3000`, new DB network internal, no published DB port, new unique service/volume/network names, file Secret mount and PostgreSQL `POSTGRES_PASSWORD_FILE` compatibility; do not create/start project or point anything at original DB. If a nonsecret Compose template can't safely express protected host path/permission, document exact deferred runtime setting instead of hardcoding an invented path.
D. Improve `.dockerignore` with narrowly scoped exclusions covering all project-side `.env*`, local Secret directories/files, encrypted recovery copies, DB data/dumps and sensitive temp/cache. Do not exclude essential Next.js source/lock files or broadly delete files. Secrets must live outside source and build context in actual later run.
E. Verify syntactic/state integrity with `git diff --check` and narrow local static/TypeScript command only if tools already exist and no external effects. **Do not launch containers/build** or install deps merely to force this Gate PASS. Source-only pass does not imply runtime function or G1S pass.
F. Stop after code-only evidence, including exact paths changed, source diff summary, safe file-secret design and backward-compatibility status; no generated credential, DB schema, website, or payments.

## REQUIRED_EVIDENCE
GATE_ID; TARGET_LOCAL_PROOF; SOURCE_PIN_AND_18_PRIOR_CHANGED_PATHS; EXACT_NEW_SCOPED_FILE_CHANGES; ORIGINAL_DB_AND_IMAGES_PRESERVED; NEW_DB_CREATED=NO; SECRET_CREATED=NO; NO_PROVIDER_ACTIONS; FILE_SECRET_PATH_AND_RUNTIME_READER_DESIGN; POSTGRES_PASSWORD_FILE_AND_MIGRATOR_PLAN; DOCKERIGNORE_SECRET_EXCLUSIONS; COMPOSE_LOOPBACK_AND_PRIVATE_DB_TEMPLATE; SOURCE_AUTH_PROVIDER_GUARD_SUMMARY; NARROW_STATIC_VALIDATION_EXIT; RESOURCE_OR_BUSINESS_DELTA; ROLLBACK_PLAN; ANOMALIES; EXECUTOR_RESULT. DISTINGUISH DIRECT_READBACK/OWNER_REPORTED/INFERRED. No raw env, Secret/password/hash, private ID, DB bytes or logs.

## ACCEPTANCE / ROLLBACK
Reviewer may PASS **G1P code-only preparation** if bounded source diff and nonsecret file-secret adapter design are reviewable and code-level checks pass. No inferred G1S runtime PASS. Native denial or unreviewed source collision => precise RETURN and preserve. Rollback is restoring only project-scoped G1P diff, not G1 18 accepted existing edits; no volumes ever deleted. No rollback of other apps.

## OWNER_ONLY_ACTIONS
Nothing needed to edit non-secret local source under prior Owner G1S approval. Next runtime Gate still needs a proven separate encrypted recovery destination **or** fresh explicit Owner decision granting a narrowly scoped disposable-lab exception (if Governance-compatible), and a policy-allowed execution channel. Do not ask Owner for credentials in chat, don't write any actual Secret in this Gate.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner 实体 Windows 11 本机 Codex Executor。仅执行 `entropy-student/project` 最新 main 中 `mokersaas-local-lab/G1P_CODE_ONLY_SECRET_SEAM_GATE.md`。G1S 上轮在写入前 RETURN，不能据此断言“所有新操作被执行策略禁止”。本轮不重试旧库重置、新库创建或任何 Secret 写入；只在既有独立项目工作区补好 `lib/db.ts`/Drizzle 的文件凭证读取适配，完善 .dockerignore 与新 Compose 模板，保留原 18 项变更和已有 DB/镜像。
本轮不要求先证明未来任意新操作一定被策略允许；正常受授权源码编辑按工具实际执行，若实际被拒，停止，不换工具/脚本绕过。禁止生成/读取输出密码，不动 Docker 容器/卷/网络，不安装/构建/启动项目或调用真实 Stripe/邮件/第三方。产出去敏的 scoped source diff 摘要、git diff --check、已有可用的静态检查结果，固定六行交接，STOP_AT_REVIEWER=YES。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*
改动：限定非 Secret 文件凭证适配和 Compose 模板、.dockerignore；保留原 18 变更
验证：Git/source, diff/check, guarded credential reader and no runtime changes
问题：NONE，或真实工具拒绝/代码检查失败/无法证实保护边界
回滚：项目源码 diff 可逆，原 DB/镜像不动
请 Reviewer 检查：diff、file-backed secret strategy、旧项目资产未改变、下一轮运行前条件
Owner 转交：NONE；运行时恢复策略另行确定
