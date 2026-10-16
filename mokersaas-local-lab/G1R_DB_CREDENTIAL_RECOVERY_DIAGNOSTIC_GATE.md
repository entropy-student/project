# MokerSaaS G1R — Synthetic DB Credential / Execution-Policy Reconciliation
> GATE_ID: MOKER-G1R-DB-CREDENTIAL-POLICY-DIAG-20261016
> STATUS: READY_FOR_OWNER_LOCAL_EXECUTOR
> GOVERNANCE: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7; interpreted by Reviewer; Executor does not reread entire Governance
> MAX_ENDPOINT_THIS_ROUND: SAME-HOST READ-ONLY classification of G1 blocked operation, existing synthetic DB credential custody/recoverability metadata, source diff/evidence reviewability and retained Docker state; NO mutation / NO credential rotation / NO service start
> MANDATORY_REVIEW_STOP: YES
> STOP_AT_REVIEWER=YES

## 1. OBJECTIVE
Keep the already built isolated MokerSaaS candidate and existing project-owned Postgres DB resources intact. Explain precisely why the first local synthetic DB credential recovery was blocked by the process execution policy, whether that attempted operation started or not, and whether an approved previously stored project credential/recovery artifact exists (existence/type/access metadata ONLY, not the value). Provide a narrowly justified next recovery decision to Reviewer. Do not re-run entire G1 or invent a different execution method.

## 2. ACCEPTED_BASELINE
- Prior G0 discovery-only PASS, Owner RAM-numeric threshold waived under `MOKER-D-20261016-NO-RAM-NUMERIC-GATE`. Do not reinstate any arbitrary RAM threshold.
- G1 Executor returned `RETURN_LOCAL_DB_CREDENTIAL_RECOVERY_BLOCKED`. Local Windows runtime facts, image IDs and file changes are relayed from Owner, not independently reviewed by Reviewer. Source SHA `c98f68c68de312cc1378130b96f82418e22bd5f3` from upstream `ItusiAI/MokerSaaS`.
- Owner-local Windows workspace reportedly `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab` with 14 modified + 4 new project files. Bounded image build reported successful: app `sha256:22085e2a08a9`, migrator `sha256:e69b2319be63`, TypeScript/Next build exit 0. No G1 code diff available to Reviewer yet; no GitHub source commit authorized.
- Healthy project DB container and empty `mokersaas` public schema (0 tables) reported; DB role requires password for TCP; no app container, no host 3077 listener; internal Compose network; project-only volume. DB synthetic credential previously ephemeral and now unavailable. Attempted role password reset process-creation denied by execution policy; underlying action was reportedly NOT_EXECUTED.
- For PostgreSQL initialized persistent volume, changing Compose `POSTGRES_PASSWORD` alone does NOT reliably rotate existing database user password. Do not try this as “recovery”.
- No live Stripe/Resend/OAuth/Neon, external payment/mail, public hosting, real data, or other Docker resources authorized.
- Current work is a technical hold. G1 NOT PASS; successfully completed subwork must be retained and not replayed absent material drift.

## 3. TARGET_AND_SCOPE
Only Owner physical Windows 11 local Codex using already existing isolated workspace and named Compose project. Reviewer will persist authoritative project Evidence/Handoff in GitHub; Executor returns sanitized metadata via chat.
No source edits, local artifact creation, checkout, Git commit, process launch for credential recovery, database/schema/user changes, Docker build/pull/up/down/restart/exec that could mutate state, file deleting or backups being overwritten. Limited approved read-only observations on existing project objects only, and only by already permissible inspection channels. If policy also prevents even readonly queries, report `RETURN_EXECUTION_POLICY_DIAGNOSTIC_BLOCKED` with policy class; no workaround.

## 4. PREFLIGHT
1. Prove same physical local Windows/PowerShell context without emitting device/user identity. Ensure Docker Engine and project workspace are available. Preserve source and all current images, DB container, network, volume as forensic state.
2. Confirm existing isolated repo path, source origin/HEAD, current Git status and **filenames only** for 18 changes. Do NOT touch unrelated repositories. Project path outside expected host context => RETURN target drift.
3. Confirm existence and source (not content) of G1 local rollback plan and its declared cleanup restrictions. No deletion.
4. Read only specific known artifacts, Docker project labels and metadata (container/volume names, health, exposed host ports, no Secret ENV inspect). Never print raw logs, environment, command strings containing passwords or full docker inspect.
5. Record original blocked operation semantics as **non-secret abstract action**: requested target db/role category; operation stage and tool policy class; whether process not created, started but not connected, connected but no commit, or UNKNOWN; explicit objective basis and native/tool error classification, no secret or SQL/payload text. No command replay or policy-tool bypass.
6. Determine the original synthetic credential lifecycle through NON-SECRET metadata only: was its creation CSPRNG in intended protected host; was there an approved durable secret location (existence/ACL metadata) or encrypted separate recovery artifact (existence/access metadata); does an authorized unchanged runtime reader still have access? Do not read, print, hash, decrypt or export any password/Secret. A forgotten ephemeral credential is not an accessible recovery artifact.
7. If evidence says old DB contains zero public tables, confirm existing same-scope DB/volume identity metadata read-only when possible, but do not infer absence of ALL durable data solely from public table count. State inventory unknown when not inspected.
8. For possible review of local hardening changes, produce a **sanitized, bounded** non-secret summary of modified paths and the design of auth/provider/db changes. Indicate which precise code diffs Reviewer still needs for acceptance. Do not create an unreviewed archive containing `.env`, Git metadata, logs, user data, volumes, test secrets.
9. Report at most: a) recoverable-by-existing-authorized-secret-reader, b) no approved recovery secret available and rotation would be needed, c) original recovery result ambiguous, d) policy prevents even read-only classification; name an exact next Owner-only checkpoint decision where needed. No credential operations authorized by this Gate.

## 5. CRITICAL_CONSTRAINTS
- Prior Owner waiver concerns only numeric RAM threshold, not Secret authority, target proof, recovery, evidence or execution safety.
- A tool policy block is NOT an invitation to retry through PowerShell, Bash, Python, SQL client, Docker exec, entrypoint scripts, API hooks, task scheduler or an alternate agent. Do not attempt any other route for the same blocked write.
- Do not reveal raw policies if containing sensitive internal content; describe only observable non-secret error class/stage. Do not print Secret value/hash, environment, command args, container ENV, logs, browser data, private path identities.
- No deleting/recreating existing empty DB volume, no changing owner/password, no updating Compose env/config, no schema push, no restarting DB. Even “empty public schema” is not adequate deletion authorization.
- No extra new third-party accounts or billing, no admin elevation. No changing VPN/Clash/HY2/WireGuard/TUN/proxy/firewall, Docker daemon/WSL/global settings, other container projects.
- No numeric host RAM minimum. Actual OOM/engine failure => precise RETURN; no speculative retries.

## 6. REQUIRED_EVIDENCE
`GATE_ID`; `SAME_TARGET_PROOF`; `SOURCE_BASELINE_AND_MODIFIED_PATHS`; `CURRENT_PROJECT_RESOURCE_SNAPSHOT` (names/category/health/ports, no ENV); `BLOCKED_OPERATION_CLASS_AND_STAGE`; `BLOCKED_COMMAND_EXECUTION_STARTED` (YES/NO/UNKNOWN + evidence); `DB_WRITE_COMMIT_STATUS` (NOT_STARTED/NOT_COMMITTED/UNKNOWN); `SECRET_ORIGINAL_CREATION_METHOD_METADATA`; `APPROVED_SECRET_LOCATION_EXISTS_BOOL_OR_UNKNOWN`; `RECOVERY_ARTIFACT_EXISTS_BOOL_OR_UNKNOWN`; `RECOVERY_RUNTIME_READER_ACCESS_BOOL_OR_UNKNOWN`; `ROLLBACK_PLAN_EXISTS`; `SECURITY_DIFF_REVIEWABILITY`; `PREFERRED_LEAST_CONSEQUENTIAL_RECOVERY_PATH` (proposal only); `ACTUAL_CHANGES=NONE_TARGET`; `ANOMALIES`; `EXECUTOR_RESULT`.
Separate Executor-local DIRECT_READBACK, OWNER_REPORTED and INFERRED. No Secret, password fingerprints, raw SQL, full process arguments or sensitive logs in report.

## 7. ACCEPTANCE_CRITERIA
Reviewer can classify the previous attempt as NOT_STARTED, NOT_COMMITTED, PARTIAL_OR_PENDING or AMBIGUOUS on objective sanitized proof, establish actual remaining project resources and secret custody state, identify one policy-compliant recovery option and its required Owner approval, and preserve existing source/image/DB artifacts without modification. If a fact is unknown, say UNKNOWN; do not claim credential restored or website running.

## 8. ROLLBACK_STATUS_OR_PLAN
Read-only; no rollback required. Existing G1 state remains intact. If incidental modification discovered or previous attempt is ambiguous, STOP and report precise state, do not clean, reset, rotate, recreate, migrate or start app. Any future credential-changing action requires a **new, expressly Owner-authorized recovery checkpoint** defining target role/volume, approved secret storage/recovery, confirmation of policy-permitted channel, rollback, and post-action evidence.

## 9. OWNER_ONLY_ACTIONS
For this Gate NONE besides relaying instruction and result. Do not ask Owner to type, paste or expose database password. If the recovery path requires an authorized Owner-local action, Reviewer designs a one-shot reviewed checkpoint in a subsequent Gate after inspecting these facts; no manual debugging or ad hoc SQL requested.

## 10. REVIEWER_TO_EXECUTOR_RELAY
你是 Owner 实体 Windows 11 本机 Codex Executor。只执行 GitHub `entropy-student/project` 最新 main:`mokersaas-local-lab/G1R_DB_CREDENTIAL_RECOVERY_DIAGNOSTIC_GATE.md`。G1 因合成 PostgreSQL 凭证恢复进程创建被策略阻断而 RETURN，G1 期间构建镜像、源代码修复和健康空数据库容器均已保留；不得重跑构建或此前检查。按本 Gate 有限只读核对：具体拦截阶段和是否启动/提交、现有凭证/恢复副本是否存在（仅元数据）、原 DB/Compose 与源码变更资产是否完好；识别一个明确且不会绕过执行策略的后续恢复方案。
严禁使用其他 shell、Docker exec、语言脚本或 Agent 绕过被拒绝的密码重设动作；不要读取/输出 Secret、删除数据库卷、改密码、迁移、启动 app、修改系统/网络/其他项目。仅返回 REQUIRED_EVIDENCE 去敏短报告及固定 Executor 交接。若策略禁止只读确认，明确 RETURN，不尝试绕过。STOP_AT_REVIEWER=YES。

## 11. EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*（G1R 诊断层面，绝不代表 G1 全部通过）。
改动：NONE_TARGET。
验证：报告原被拒动作是否真正开始、凭证/恢复材料存在性元数据、当前 Docker 资源和源码变更仍完好。
问题：NONE 或 Secret 恢复/策略缺口的具体分类。
回滚：NONE（只读，保留 G1 数据）。
请 Reviewer 检查：是否能依旧有授权的恢复资料安全恢复，或需新 Owner-only 凭证/全新测试库 Gate。
Owner 转交：NONE 或精确需要 Owner 批准的后续动作（不含 Secret 值）。
