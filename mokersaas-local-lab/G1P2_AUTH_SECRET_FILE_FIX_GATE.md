# MokerSaaS G1P2 — NextAuth Session Secret File Fix + Bounded Build Check

> REVIEWER 2026-10-17: G1P2 minimal session secret FILE-backed fix and TypeScript/Next.js build verified from Owner-relayed Codex report and reviewed source snippets. PASS limited to code/build; no actual Secret, new DB, app, localhost or transaction tests occurred. No active runtime Gate. Relay below is historical and MUST NOT be rerun.
> GATE_ID: MOKER-G1P2-AUTH-SECRET-FILE-FIX-20261017
> STATUS: REVIEWER_PASS_CODE_BUILD_ONLY__COMPLETED — do not reexecute
> GOVERNANCE: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7; Reviewer interpreted
> OWNER_SCOPE_REFERENCE: MOKER-D-20261017-APPROVE-G1S-NEW-DB (previously authorized lab-only source safety adjustments and necessary single scoped rebuild); no new DB/payment/provider actions
> MAX_ENDPOINT_THIS_ROUND: minimal isolated source-only session-secret file adapter + future Compose file-secret template + targeted build/type verification conditional on safe target preflight; NO DB/Secret generation or application startup
> MANDATORY_REVIEW_STOP: YES
> STOP_AT_REVIEWER=YES

## OBJECTIVE
Repair one concrete defect found after Reviewer read the exact five-file G1P submission. The DB password file helper and G1S internal/localhost Compose arrangement are retained; no redo. `docker-compose.g1s.yml` currently interpolates `NEXTAUTH_SECRET` into container ENV and pinned upstream `lib/auth.ts` currently sets `authOptions.secret=process.env.NEXTAUTH_SECRET`. Canonical Governance §11B prohibits secret values in ordinary process env/Compose config, including lab secrets. Provide a protected read-only *file-backed* session secret for lab-only NextAuth v4, preserving existing non-lab behavior, then verify build phase and code compatibility without runtime Secret generation.

## ACCEPTED FACTS
- Owner Windows 11 native local Codex project workspace under `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab`, upstream pinned `ItusiAI/MokerSaaS` c98f68c68de312cc1378130b96f82418e22bd5f3. G1 18 original paths retained; G1P reports total 21 local modified/new paths, including `lib/local-db-config.ts`, `drizzle.config.ts`, `docker-compose.g1s.yml`. Actual submitted G1P file contents inspected by Reviewer in chat; all 5 code paths need no broad rework.
- G1P Reviewer decision `RETURN_NEXTAUTH_SESSION_SECRET_ENV_BOUNDARY` only. Existing app/migrator built images are **pre-G1P** and do NOT validate current patched sources. Previous TypeScript/Next build successes concern earlier source state; local `tsc` unavailable. Static Compose parse and helper branch checks reported success for G1P, not runtime tests.
- Original healthy lab DB container `mokersaas-local-lab-db-1`, volume `mokersaas-local-lab-db-data`, network `mokersaas-local-lab-network`, previous image IDs all PRESERVED. No G1S new database/Secret/app exists; host 3077 not running. Previous password reset process was blocked; do not retry by alternate means.
- Owner explicitly approved a scoped disposable synthetic DB exception to off-host encrypted Secret recovery in chat but corresponding `DECISION_LOG.md` persistence was blocked, and NO runtime Secret/DB Gate is active. This code/build Gate creates no real secrets and makes no use of that exception.

## BOUNDED PREFLIGHT
1. Confirm correct physical local Windows target, pinned Git origin/HEAD and isolated worktree including preexisting 21 paths; preserve untracked files intact. Do not reset, replace, clone, archive or edit SaSS/other worktrees. Prove source path real/not redirected and local Docker Engine, if build intended, only own resources.
2. Preserve diff and minimal rollback: ONLY new G1P2 source modifications may be reversed; never discard G1 or G1P patch. Check current `lib/auth.ts` baseline including its existing LOCAL_LAB Credentials-only provider behavior, and any other NextAuth secret readers; do not overwrite those previous security modifications.
3. No numeric RAM threshold. Actual native OOM/Docker/Windows instability, untracked source drift or execution policy rejection means STOP, exact RETURN, not workaround/forced process shutdown. G1S original previous policy denial is not evidence of all future allowed writes; however previously denied old DB role reset is strictly forbidden to reroute.
4. No actual Secret generation/printing/reading, ACL or recovery-store mutation, no DB container/network/volume work, no Compose up/down/exec, no app start, provider calls, webhooks, real payment/mail or auth user actions. No global Docker/WSL/proxy/VPN/firewall/network changes.

## EXECUTION — MINIMAL FIX
A. Add one minimal server-only `LOCAL_LAB=1` NextAuth secret-file reader (can reuse a carefully isolated helper in `lib/local-db-config.ts` or new `lib/local-auth-config.ts`), accepting only `NEXTAUTH_SECRET_FILE` path to a future read-only mounted file; fail closed on unset/unreadable/empty/unacceptably short content, do not expose secret/path in exception, log, CLI, build artifact or tests. Do not generate any actual runtime Secret. Keep production/non-lab existing `NEXTAUTH_SECRET` behavior without broad rewrite.
B. Update only existing project-local `lib/auth.ts` `authOptions.secret` to call that helper in local lab. NextAuth v4 auth handler must use this stable secret for sessions; inspect local call sites for other secret dependencies and keep auth guards/providers as previously hardened. Do NOT disable JWT verification to avoid secret requirements.
C. Update `docker-compose.g1s.yml`: remove any `NEXTAUTH_SECRET:${...}` value environment interpolation, add separate `g1s_nextauth_secret` FILE-backed Secret mounted only to `g1s-app`, use `NEXTAUTH_SECRET_FILE=/run/secrets/g1s_nextauth_secret` as a nonsensitive path ENV, refer to future protected external Secret directory without placing values inside source/build context. Preserve existing file-backed DB password `g1s_db_password`, Postgres/migrator, internal network and `127.0.0.1:3077:3000` loopback binding. Do not give session secret to DB/migrator service.
D. Verify `.dockerignore` still excludes project .env/secret, encrypted-recovery and data files. If no need to change it, leave unchanged.
E. Verify build-phase behavior explicitly: Next.js `phase-production-build` detection in existing `getDatabaseUrl()` must not need mount-time passwords; NextAuth's build-phase behavior must also be accounted for without embedding usable default signing secret in shipped runtime. A helper-only Node test is not proof of actual Next 16.3.0 build. If build-time NextAuth import requires Secret but can't supply it safely, return precise `RETURN_BUILD_SECRET_BOUNDARY_UNRESOLVED` instead of hardcoding a reusable signing key.
F. Run `git diff --check`; a narrow TypeScript type check using previously installed dependencies or one project-scoped controlled Docker build if necessary and if safe. The existing Dockerfile pinned base/lock must be used, no new global installs and no real Secret during build. Permit **at most one** isolated app image rebuild (and migrator only if code changed requires it) for validation; record app image ID, exact changed-source fingerprint, `tsc --noEmit` exit and actual Next build exit. If resource/native/tool-policy failure, STOP and return. Do not run any container/DB app startup or migrate.
G. Return actual diff of changed `lib/auth.ts`, new helper if added, and changed Compose relevant sections, with no private host paths or Secret values. Report all unchanged other G1P/G1 resources, exact validation statuses and rollback boundary; STOP_AT_REVIEWER.

## REQUIRED_EVIDENCE
AUTH_GATE; TARGET_LOCAL_PROOF; SOURCE_PIN_21_PREVIOUS_PATHS; G1P2_CHANGED_PATHS_AND_DIFF; NEXTAUTH_AUTHOPTIONS_SECRET_IMPLEMENTATION; NEXTAUTH_SECRET_FILE_AND_COMPOSE_MOUNT; NO_NEXTAUTH_SECRET_VALUE_IN_ENV; BUILD_PHASE_AUTH_AND_DB_SECRET_BEHAVIOR; SOURCE_DIFF_CHECK_EXIT; TS_NOEMIT_EXIT_OR_REASON_UNAVAILABLE; BUILD_EXIT_IF_PERFORMED; OLD_DB_VOLUME_IMAGE_NO_DELTA; NEW_SECRET_GENERATED=NO; NEW_DB_CREATED=NO; APPLICATION_STARTED=NO; EXTERNAL_ACTIONS=NONE; OOM_POLICY_ERRORS_IF_ANY; ROLLBACK_SCOPE; EXECUTOR_RESULT. Distinguish local DIRECT_READBACK, OWNER_REPORTED and INFERRED; no Secret value/hash or raw container env/logs.

## ACCEPTANCE_CRITERIA
- Session secret is not interpolated into Compose env; lab NextAuth options uses protected file-backed Secret; normal non-lab behavior unchanged; no default production/test signing Secret usable at runtime if mount missing.
- DB file-secret code unchanged except any bounded code fix necessary from actual build; no old DB write or Secret created, no live app.
- Valid source diff + TS/build result, explicit distinction of static vs built code. Failure to build is precise RETURN/PARTIAL, not PASS.
- Runtime localhost safety/availability and protected ACL remain future separately reviewed Gate, not claimed here.

## ROLLBACK_PLAN
Keep previous 21 scoped project files intact. Revert ONLY G1P2 changes in lib/auth.ts, Compose template and new helper if necessary; preserve all existing original DB/container/volume/images and source baseline. Any newly built test image remains project-scoped/reconstructible; no prune/no volume deletion. No actual Secret will exist from this Gate.

## OWNER_ONLY_ACTIONS
No additional Owner action for bounded non-secret code safety fix under earlier G1S source authorization. New Secret/DB/localhost startup is NOT allowed in this Gate. Prior chat-approved local disposable-DB Secret recovery exception remains not yet persisted to DECISION_LOG and must be reconciled before runtime Gate without circumventing any blocked GitHub write.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner 实体 Windows 11 本机 Codex Executor。只读取 `entropy-student/project` 最新 main 的 `mokersaas-local-lab/G1P2_AUTH_SECRET_FILE_FIX_GATE.md`、`REVIEWER_HANDOFF.md` 当前状态、`EXECUTION_EVIDENCE.md` 最新 G1P Reviewer 结论和本地现有工作区。G1P 已完成 5 文件改动并由 Reviewer 看过实际源码；不要重复任何原 G1P 或 G1/G0 步骤。
本轮仅修复一个问题：`docker-compose.g1s.yml` 仍通过 NEXTAUTH_SECRET 环境变量传递会话密钥。把 **本地实验** 的 NextAuth secret 迁到受保护的运行时文件读取，通过 `lib/auth.ts` 的 authOptions.secret 设置，并更新 Compose file-secret mount；生产模式保持现有行为。不能把密钥或实际测试密码写入环境、代码、Git、build、日志或聊天。要保证缺少运行时文件时拒绝启动/鉴权，且 Next build 阶段不打包可用于运行的默认签名密钥。
复用原 21 个本地源码变更，不碰旧 DB/卷/网络/镜像，最多只做一次必要的项目级 Docker 构建并显式 `tsc --noEmit` 验证；不启动 App、不创建新 DB/Secret、不运行迁移、不进行真实 Stripe、邮箱或第三方操作。资源/工具策略实际失败即停止，不换工具绕过。提交最小代码 diff、验证结果、回滚状态，`STOP_AT_REVIEWER=YES`。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*。
改动：仅 NextAuth session-secret file-backed adapter + Compose file-secret declaration / necessary helper; original 21 source paths preserved。
验证：file secret fail-closed; NextAuth options; TS/build exit if performed; no actual Secret/DB/runtime writes。
问题：NONE 或具体未验证/被策略拒绝。
回滚：仅 G1P2 diff；原 21 文件及既有 DB/镜像保持。
请 Reviewer 检查：实际 diff、NextAuth secret reader/mount、构建结果与原 DB 无变化。
Owner 转交：NONE；后续新 DB/runtime Gate 单独评审。
