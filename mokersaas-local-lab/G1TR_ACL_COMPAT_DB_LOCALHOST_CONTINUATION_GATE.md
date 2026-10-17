# MokerSaaS G1TR — ACL-compatible secret creation + resume NEW local DB/site smoke

> GATE_ID: MOKER-G1TR-ACL-COMPAT-DB-LOCALHOST-20261017
> STATUS: READY_FOR_OWNER_LOCAL_EXECUTOR
> GOVERNANCE: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7
> AUTHORITY: Owner already approved `MOKER-D-20261017-APPROVE-G1S-NEW-DB` and `MOKER-D-20261017-DISPOSABLE-RECOVERY-EXCEPTION`; the second waives ONLY off-host encrypted recovery copy for a NEW disposable synthetic test credential.
> MAX_ENDPOINT_THIS_ROUND: correct the single Windows/.NET ACL creation API mismatch, then continue G1T's SAME authorized target through new DB/schema, private localhost app, basic auth/admin/provider-negative smoke.
> STOP_AT_REVIEWER=YES

## WHY / ACCEPTED RECONCILIATION
G1T first attempt stopped at .NET **method overload resolution**, before the protected directory creation call. The failed API was `System.IO.Directory.CreateDirectory(string, DirectorySecurity)` (legacy .NET Framework). This is NOT a policy denial and did not create any Secret or DB. Microsoft documents modern .NET replacement `System.IO.FileSystemAclExtensions.CreateDirectory(DirectorySecurity, string)` in System.IO.FileSystem.AccessControl:
https://learn.microsoft.com/en-us/dotnet/api/system.io.filesystemaclextensions.createdirectory?view=net-10.0
This replacement creates a directory with its ACL specified at creation; existing-directory behavior means the Executor must **fail if target already exists**, not adopt a directory with unknown ACL.

Existing Owner Windows 11 local source pinned `ItusiAI/MokerSaaS` SHA `c98f68c68de312cc1378130b96f82418e22bd5f3` with 22 accepted G1/G1P/G1P2 change paths. G1P2 app already built and TS/Next production-build checked, image `sha256:5692813e121e043d15a4dad133e89f32a8574954d0eb12f9ed8f0f622fd10889`. Existing original DB `mokersaas-local-lab-db-1`, original volume `mokersaas-local-lab-db-data` and network `mokersaas-local-lab-network` remain protected. Old role password-reset tool command previously policy-denied; NEVER reattempt its effect by alternate shell/agent.

First G1T attempt also reported a limited local change to the existing `docker-compose.g1s.yml` (app now references G1P2 image and no app build clause). **This change is retained but not independently re-read by Reviewer; must read back before any further write**. No G1S DB/container/volume/Secret/App was reported created; the Executor ran no Docker command in G1T failed operation. No actual website listener or tests yet.

## TARGET / NON-NEGOTIABLE BOUNDARIES
- Only original Owner physical Windows 11 local Codex, exact existing isolated Moker source and a separately named NEW Compose project `mokersaas-local-lab-g1s`; never Grok Bot/VPS/cloud/SSH/remote.
- Preserve old DB/service/volume/network and both earlier app+migrator images and newer G1P2 app image unchanged. No old DB password rotation/recovery/deletion. No Compose default file/old project `up`, `down -v`, broad prune, Docker daemon/WSL settings, VPN/Clash/WG/HY2/TUN/proxy/firewall/system ACL changes or other projects.
- No real provider/Stripe/Resend/Neon/OAuth/Umami, email, refunds, affiliate payouts, customer data, public bind, automated jobs or live money. All account/test records disposable synthetic. No arbitrary RAM threshold; actual native resource failures stop.
- Secrets via OS CSPRNG (DB + NextAuth independently), atomic **new** protected local files outside checkout/build, restrictive Windows ACL + Docker Desktop intended reader check. Never plaintext secret/hash in env, CLI args, output, history, logs, code, GitHub, build or image. No off-host copy required ONLY because Owner accepted synthetic lab loss risk. No Secret overwrite on retries.
- An actual tool-policy rejection stops the denied effect, no alternate language/shell/helper/agent. A non-existent .NET method is distinct from such a denial, and this Gate's explicitly reviewed supported method is the sole authorized compatibility correction.
- G1T original maximum endpoint and STOP_AT_REVIEWER apply. Do not independently continue to G2, production, real checkout, refunds or referral tests.

## FIRST: SHORT READ-ONLY RECONCILIATION
1. Read unchanged project `REVIEWER_HANDOFF.md` CURRENT state, `DECISION_LOG.md` two 2026-10-17 Owner authorizations and original G1P2 evidence only as needed; no broad history. Verify exact physical local Windows target, process, project root/pinned Git origin/head and original 22 changes.
2. Direct read-back of `docker-compose.g1s.yml` modified G1T candidate: no new unrelated source paths, only app-image reference and removal of app build clause. Verify referenced image exists **by full exact ID** and source matches G1P2 build. Check separate new `mokersaas-local-lab-g1s` namespace still has NO service/volume/network; original database container/volume/network identity same; 3077 free. If any G1T write started in fact, or new resources already exist, do not blindly retry: stop for Reviewer reconcile.
3. Verify existing Compose file-backed DB and NextAuth secrets, `LOCAL_LAB=1`, disabled admin escalation, provider/e-mail/cron/payout fail-closed, app published ONLY `127.0.0.1:3077:3000`, DB no host published port, separate internal network. If source risk discovered, return without starting. Verify migration service is built/referenced from patched Drizzle current source (bounded one migrator build if necessary); no app rebuild if image matches.
4. In the SAME permitted PS 7.6.5 .NET process, READ-ONLY reflect actual availability/signature of `System.IO.FileSystemAclExtensions.CreateDirectory(DirectorySecurity, string)` and the ACL-aware restrictive file creation method `FileSystemAclExtensions.Create(FileInfo, FileMode, FileSystemRights, FileShare, Int32, FileOptions, FileSecurity)`. If absent, RETURN `RETURN_ACL_API_NOT_AVAILABLE` without creating directory/file or performing create-then-SetAcl. No library installation for alternate channels.
5. Confirm trusted existing parent of **new absent** private project directory located outside Git/build. Define `DirectorySecurity` ACL for Owner user SID and necessary SYSTEM/service identities only; disable unnecessary inheritance, restrict unrelated users/groups. Do not touch parent ACL or existing dirs; do not reveal actual identity/path. Preflight the file ACL reader/writer design and rollback boundary. A mismatch to Docker Desktop mount permissions means stop rather than add `Everyone` ACL.

## CONDITIONAL ONE-SHOT CONTINUATION
A. For one absolutely NEW child directory, use the documented `[System.IO.FileSystemAclExtensions]::CreateDirectory($directorySecurity, $exactNewPath)` Windows/.NET ACL-at-creation method **only after reflection proves it exists**, ensuring exact path doesn't already exist and verifying effective ACL immediately after creation. Do not call old unsupported `Directory.CreateDirectory(path, security)`; do not use `New-Item` followed by `Set-Acl` or a temporary unprotected secret directory. If this fails, STOP, classify exact exception/tool rejection and preserve partial state.
B. Generate independent DB password and NextAuth secret with OS CSPRNG, one-time create-new using ACL-aware file creation (no overwrite/create-then-ACL), UTF-8 no BOM, no control chars. Immediately confirm output format, file protections, stable readers, intended Docker file mounts without leaking contents, no extra provider/service access. Test that the intended app/migrator/DB readers can read exactly their authorized files and unrelated services cannot read/mount NextAuth file. If file create/read restriction cannot be demonstrated, STOP without starting new DB/app. Do not silently regenerate or overwrite.
C. Continue G1T, only if A+B succeeded, against `docker-compose.g1s.yml` under distinct NEW `mokersaas-local-lab-g1s` namespace: start NEW pinned postgres, keep old DB untouched; prove new DB role/volume/healthy service. Run current-source Drizzle schema push only on proven NEW empty DB. One bounded new migrator build if pre-G1P image lacks helper; no speculative rebuild loops. Prove essential tables/constraints by readback. If tool policy denies **this** new operation, STOP and no alternate channel.
D. Start only G1P2 app build with LOCAL_LAB=1, distinct file Secret mounts and host loopback `127.0.0.1:3077`; no exposed DB or external provider/network path. Actual localhost homepage HTTP, local synthetic signup/signin and session, anonymous GET/POST `/api/admin/set-admin` 404/403 and no role mutation, ordinary user admin denied, Stripe/email/OAuth/cron/withdraw fail-closed negative tests, no real outbound effects. Do not assert availability if loopback isn't reachable on Windows Docker Desktop.
E. If feasible verify app-only restart retaining files/session/DB data. If real provider or privilege vulnerability observed, stop only exactly new owned app and report incident. Keep new lab running on success; no automatic volume/Secret deletion or global shutdown.
F. Emit sanitized required G1T evidence for new/current container/volume/image IDs, source & Compose readback, actual API signature/ACL metadata (no private paths/SIDs), CSPRNG method, file-reader proofs, schema/HTTP/negative tests, original DB identities PRE/POST, anomalies and resource delta. Mandatory STOP_AT_REVIEWER.

## ACCEPTANCE / ROLLBACK
G1TR PASS_CANDIDATE requires real on-host Secret directory+files with least-privilege effective ACL and matching container readers, new isolated DB schema, localhost HTTP/signup/login, auth/admin/provider negatives and original DB zero cross-impact. Source/build/static-only is PARTIAL. Any failure stops immediately with exact unsupported method vs native exception vs policy denial, including whether any protected dir/file was created; do not retry ambiguous changes. Preserve old and new durable volumes/credentials as-forensic unless a separate Owner-authorized cleanup Gate; only exact new app may be stopped for safety. Never claim old DB byte-level unchanged without a comparison; report names/metadata only when that's all measured.

## REQUIRED EVIDENCE
`GATE_ID`; `ORIGINAL_G1T_RETURN_CLASSIFICATION`; `OWNER_AUTHORITY`; `SAME_OWNER_LOCAL_TARGET`; `PINNED_SOURCE_AND_COMPOSE_DELTA`; `ORIGINAL_DB_IDENTITIES_PRE_POST`; `NEW_NAMESPACE_COLLISION`; `DOTNET_ACL_API_SIGNATURE_READBACK`; `ACL_ATOMIC_DIR_CREATE_AND_EFFECTIVE_PERMISSIONS`; `ATOMIC_RESTRICTIVE_SECRET_FILE_CREATE`; `DB_NEXTAUTH_DISTINCT_SECRETS_AND_READERS`; `NO_SECRETS_IN_ENV_IMAGES_LOGS`; `SCOPED_MIGRATOR_IMAGE_BUILD_IF_NEEDED`; `NEW_DB_HEALTH_AND_SCHEMA`; `LOCALHOST_HTTP`; `SIGNUP_LOGIN_SESSION`; `ADMIN_404_403_ROLE_NO_DELTA`; `PROVIDER_NEGATIVE_AND_NO_REAL_OUTBOUND`; `NO_OLD_DB_WRITE_REPORTED`; `ROLLBACK_STATUS`; `ACTUAL_CHANGES`; `ANOMALIES`; `EXECUTOR_RESULT`. Mark DIRECT_READBACK vs OWNER_REPORTED vs INFERRED. STOP_AT_REVIEWER=YES.

## OWNER ONLY / RELAYS
Owner action: NONE. The original new DB authorization and the disposable synthetic only off-host recovery exception are in `DECISION_LOG.md`. No Secret/pw/SQL/share approvals requested.

### REVIEWER_TO_EXECUTOR_RELAY
你是 Owner 实体 Windows 11 本机 Codex Executor。执行 `entropy-student/project` 最新 main 的唯一当前 Gate `mokersaas-local-lab/G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md`。原 G1T 在 `Directory.CreateDirectory(string, DirectorySecurity)` 方法重载解析时停止；**不是**安全策略拒绝，目录、Secret、数据库、网站均未创建。微软官方的 .NET Core 替代方法是 `System.IO.FileSystemAclExtensions.CreateDirectory(DirectorySecurity,string)`；先只读核验你这台 PowerShell/.NET 的签名支持，随后若允许使用它以 ACL 创建全新的受保护目录，不能先宽松创建再改 ACL。
先最小只读核对上轮保留的 `docker-compose.g1s.yml` 镜像引用调整、G1P2 镜像 ID、原数据库资源和 G1S 新命名空间仍为空；不重做 22 项源代码、G1P2 构建或原 G1T 已通过的静态工作。
Owner 已批准独立新合成库及仅这套临时库不要求异地凭证恢复副本，仍需 CSPRNG、创建即受限 ACL 的两个新 Secret 文件、精确 Docker 容器读者验证。只有确实成功后，再继续单轮创建新 PostgreSQL/Schema 和仅回环 `127.0.0.1:3077` App，实测登录、set-admin GET/POST 不能提权、普通用户管理接口拒绝、Stripe/邮件/OAuth/cron/提现禁用；不得真实交易或联网第三方。原库容器/卷、旧镜像及全部本地源码成果不动，无内存数值门槛。
若 ACL API 不存在、ACL 拒绝、真正执行策略拒绝或有任何写入结果不明，立即 RETURN，不使用其他 shell/agent/helper 绕过、更不删除数据。返回 REQUIRED_EVIDENCE 的去敏短报告和准确 localhost HTTP 状态，STOP_AT_REVIEWER=YES，不进入 G2。

### EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*。
改动：仅保护新 Secret 目录/文件、新 G1S DB/卷/必要迁移镜像及项目专属 Compose；旧库保留。
验证：实际 ACL/reader、DB/schema、localhost HTTP、登录/管理员及 Provider 负面测试；未做项明确 NOT_TESTED。
问题：NONE 或准确 .NET 方法/ACL/策略/构建/启动错误及写入阶段。
回滚：精准本轮新资产状态，不删除任何新旧持久数据。
请 Reviewer 检查：原 G1T 故障已解决且无权限暴露/策略绕过、原 DB 无交叉、新站点实际运行结果。
Owner 转交：NONE，除非真实出现超出既有授权的外部 Owner 专属操作。
