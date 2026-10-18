# G2L1｜恢复已有本机 Velobase Demo 并完成页面验收（2026-10-18）

> GATE_ID=`SAAS-G2L1-LOCAL-EXISTING-DEMO-RESUME-20261018`
> STATUS=`REVIEWER_READY / NOT_EXECUTED`
> OWNER_DECISION=`REJECT_CODESPACES / RESUME_EXISTING_LOCAL_ASSETS`
> TARGET=`OWNER_WINDOWS_LOCAL_CODEX / EXISTING_VELOBASE_ONLY`
> UPSTREAM_COMMIT=`e88e259b974f883913f68ac74a9b8377765d005d`
> CURRENT_EXECUTION_GATE=`G2L1`
> MANDATORY_REVIEW_STOP=`YES`

## OBJECTIVE

只利用 **G2 已经在 Owner Windows 本机安装并构建成功的 Velobase 实验资产**，在不重新拉代码、不重新 build、不修改 Docker 全局配置和不影响其他项目的前提下，恢复已有 Demo 服务并实际完成 Landing、登录、用户 Dashboard、平台 Admin、Affiliate 与 Worker/依赖健康的验收。**不是新安装，不切换云端**。

Owner 明确拒绝 Codespaces；此前 G2I1 Gate 已被撤销并关闭。旧三个 Docker 容器是否由 Owner 手动停止仍属不确定事实；Owner 暂不要求恢复它们，这不等于历史退出根因已查明。G2 旧事故保持 `CAUSE_UNKNOWN`，不再复现调查，但如本轮**新发生**其他项目真实回退仍须 STOP。

## MAX_ENDPOINT_THIS_ROUND

只能在 **现有** `%USERPROFILE%\Documents\ChatGPT\Velobase-Harness-e88e259` 和 **现有** Compose project `saasvh-e88e259` 上操作；允许验证资源确实完整后，**仅一次**顺序启动现成 `postgres/redis/web` 容器，检查本机 `http://127.0.0.1:3003` 的完整 UI、认证和资源状态。若识别出需修改应用源码或启动配置的兼容问题，仅记录最小修复建议，**本轮不实施**：G2 的 Web 代码已打入现有镜像，修改 Windows 工作树不会自动更新容器镜像。若问题需要 Docker 重建镜像、镜像下载、迁移数据、删卷、重置 Demo 或全局环境修改，本轮停止并交 Reviewer 判断下一局部 Gate；不能为了减少 RETURN 任意扩权。

**禁止**：对旧三个容器或其他 Compose 项目做 start/stop/restart/删除；`docker compose up --build`、`down -v`、`docker system prune`、清空/更换数据库、全局改 Docker Desktop/WSL、占用共享 VPS、购买外部资源、公开端口、Stripe TEST/Live 或其它 Provider 行为。

## MANDATORY_REVIEW_STOP

`YES`。若出现任何同机其他项目健康回退、新增实际 OOM、持续系统卡死、端口/容器归属不明、服务身份不符、独占卷损坏或重要数据风险，立刻**只停止本轮实际启动的 Velobase 项目服务**，保留其他项目原状和全部原有数据，准确记录时间和影响。**不把固定剩余 RAM 数值单独作为拒绝条件**，但必须记录资源及已有工作负载变化。

## TARGET_AND_SCOPE

- **真机**：Owner Windows 11 Home（历史 build 26300），由 Owner 本机 Codex 新鲜证明主机与 Shell/Docker Engine 身份。ChatGPT GitHub Reviewer 不具备操作 Windows 的能力。
- **源码**：只使用 G2 既有本地源码位置；`git rev-parse HEAD` 必须与固定 SHA 一致，原始 `compose.demo.yml` 与 `Dockerfile.demo` 存在；新写文件禁止覆盖未知/唯一工作。不存在或与固定 SHA 不符时停止，不能 clone、checkout、reset、重新安装。
- **容器**：仅 `saasvh-e88e259` 的 `web/postgres/redis`，由 **现有** 容器标签和 G2 留存身份同时核对；如果任何所需容器缺失、不是原实例、正在由其他流程管理或重建才能启动，则 RETURN，不做隐式创建。
- **持久化**：原 `saasvh-e88e259_preview_data`、`saasvh-e88e259_demo_state` 命名卷和网络按实时容器/Compose 解析核验；不改变挂载、卷/数据、demo state、Seed、admin 密钥，不读取或输出 Secret。
- **网络**：只允许 Web 发布 `127.0.0.1:3003`，Postgres/Redis 不发布宿主端口；禁止公网转发。不使用个人主浏览器已有账号会话/扩展凭证作为 Demo 认证依据。
- **费用**：零额外云资源与账号开通。
- **历史**：G2 成功构建、G2R1 原因未知、旧三个容器当时退出的记录不改写；重新读取当前状态只为判断新一轮运行影响。

## APPLICABLE_CRITICAL_CONSTRAINTS

执行 GitHub `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 的 §0–10、§11 触发扫描、§11A/B/C/D（隔离/身份/服务健康/演示认证），以及 §11E 对支付的禁止边界与 §12–13。本轮与已经停机的其他项目无恢复权限。未批准使用 Codespaces、VPS、外部身份或任何资金交易。服务开始操作前必须证明仅影响固定三容器、卷和网络。

## PREFLIGHT / EXECUTION

1. **真实目标与 Git**：Owner 本机 Codex 只读识别当前 Windows 主机、用户权限、PowerShell/Docker、工作目录，确认 `%USERPROFILE%\Documents\ChatGPT\Velobase-Harness-e88e259` 与上游完整固定 SHA，工作树有唯一未提交数据则保留并避免覆盖；不得重做已经完成的全栈构建。
2. **现状先查**：记录本轮起始 `docker compose -p saasvh-e88e259 -f compose.demo.yml ps -a`、所属 Labels、现有服务、镜像、网络、两卷、`127.0.0.1:3003` 占用。核对已有三容器真实存在且只属于本项目。捕获其他运行中容器**脱敏**基线及关键健康状态；记录三个历史旧容器现状但不猜测它们的归属，不用它们必须恢复为开始条件。
3. **资源边界**：采样 Windows 和 Docker 内存/CPU/磁盘实际情况；不要以预设的“至少空闲 N GiB”阻挡操作。若 Docker Engine 不可达，不要自动重置/重装 Docker Desktop 或 WSL；返回 `RETURN_SHARED_DOCKER_ENGINE_UNAVAILABLE`。
4. **已有 Demo 实例顺序恢复**：如 G2 三容器全是 stopped、镜像/卷身份无变化且端口空闲，**仅启动既有实例**。优先执行与下列语义等效的项目限定命令，在旧 DB/Redis 确认 ready 后再启动旧 Web：
   ```powershell
   Set-Location "$env:USERPROFILE\Documents\ChatGPT\Velobase-Harness-e88e259"
   docker compose -p saasvh-e88e259 -f compose.demo.yml start postgres redis
   # 只读核对这两个既有容器健康后：
   docker compose -p saasvh-e88e259 -f compose.demo.yml start web
   ```
   若三容器并非全停，先判断是否已经由 Owner 其它流程运行：已存在健康 Demo 则直接进入只读 UI 验收，不为“重试”重启；非健康或身份不一致则 RETURN，不擅自 recreate。严禁 `up --build`、`up -d`（可能新建容器）、`pull`、重建、迁移或调整 Docker 全局配额。
5. **优先验证最重要的页面**：先使用 HTTP 与浏览器检查 `http://127.0.0.1:3003` Landing 及登录弹窗，再点击本地管理员演示入口，确认 session 登录**真的完成**；接着验证真实的 Dashboard、平台 Admin、非管理员不可读写 Admin 路由的负例、Affiliate 页面/保护重定向及账户设置。只报告真实截图/DOM/响应，不以首页 200 或 307 替代业务功能 PASS；测试账户只使用安全的原生 Demo 数据，不伪造真实用户资料。
6. **健康与性能**：Web/HTTP、Postgres/Redis readiness、Web 中由 `SERVICE_MODE=web,worker` 启动的后台进程/Worker 需分别核实；在短时间连续采样 CPU、内存、请求延时和旧有运行容器差异。若页面仅因为负载超时，明确记录资源/响应而不推断架构缺陷。不得触发真实 Worker 外部业务。
7. **回滚边界**：若实际触发本轮新异常，先记录当前服务/数据/旧项目状况，然后**仅** `docker compose -p saasvh-e88e259 -f compose.demo.yml stop --timeout 30`，保留源码、两卷、网络、镜像和旧项目现状。不要重启或清理其他项目。若已经成功、确实可持续操作且未影响其他服务，**保留 Velobase 当前运行**供 Owner 直接浏览（不自动停机）。
8. **结果归档**：把本轮非敏感完整执行 Evidence 写入 GitHub `main:saas-system/docs/` 新文件或让 Owner 转交给 Reviewer，由 Reviewer 审核后更新唯一 Handoff；不能让 Executor 自己宣称正式 PASS。

## REQUIRED_EVIDENCE

`GATE_ID`, `TARGET_LOCAL_PROOF`, `SOURCE_SHA_AND_PATH`, `EXISTING_PROJECT_CONTAINER_VOLUME_IDENTITIES`, `ORIGINAL_WORKLOAD_BASELINE`, `PORT_3003_BINDING`, `DOCKER_ENGINE_READY`, `REUSED_IMAGE_AND_NO_BUILD`, `START_COMMAND_AND_EXIT_CODES`, `DB_REDIS_WEB_WORKER_HEALTH`, `UI_LANDING_SIGNIN_DASHBOARD_ADMIN_AFFILIATE_MATRIX`, `ADMIN_POSITIVE_NEGATIVE_ACCESS`, `BROWSER_DOM_OR_REVIEWABLE_SCREENSHOTS`, `REAL_RESOURCE_SAMPLES`, `EXISTING_WORKLOAD_DELTA`, `RUNNING_END_STATE`, `ROLLBACK_EFFECT`, `SECRET_EXPOSURE_COUNT=0`, `PAYMENT_ACTION_COUNT=0`, `EXECUTOR_RESULT`.

## ACCEPTANCE_CRITERIA

- Owner Windows 本机原有镜像/容器/两卷确实被复用，固定源 SHA 未变，重建/拉取/迁移/其它项目操作为零；Web 3003 仅本机监听。
- Home + 登录完成 + Dashboard + 真正的平台 Admin 都能由 Reviewer 核对到实际页面操作行为，普通用户无法访问管理功能（如果缺少可安全测试的普通演示用户，Admin 负例 `UNVERIFIED`，不能给完整 PASS）。
- Affiliate 页面/功能及后台 Worker 的健康独立展示，不把静态源码、重定向或进程存在直接升级成已完成资金闭环。
- 本轮没有导致其他运行中工作负载健康回退或实际系统异常；若出现异常执行准确项目内停机回滚。
- Stripe/真实支付/佣金与部分退款均 `NOT_TESTED`。成功 UI 演示后由 Reviewer 另设下一 Gate。
- 结论 `PASS_CANDIDATE / RETURN_*` 属于 Executor，正式 `PASS/PARTIAL/RETURN` 属于 Reviewer。

## ROLLBACK_STATUS_OR_PLAN

精准停止本轮启动的 `saasvh-e88e259` 三容器是项目内运行回滚；保持所有卷、镜像、网络、源码和旧容器现状。若任何共享数据/身份冲突出现，先 STOP 不做修复式操作。历史 G2R1 `CAUSE_UNKNOWN` 保持事实，不再对历史退出事故做试验性复现。

## OWNER_ONLY_ACTIONS

Owner 已明确要求继续并拒绝云部署，不用逐命令再次审批。此 Gate 只能由 **Owner Windows 本机 Codex** 操作已存在的项目容器，GitHub Reviewer 不能代替执行。无需新账号、买云服务器、给出密码或 Stripe Key。

## REVIEWER_TO_EXECUTOR_RELAY

你是 Owner Windows 本机 Codex，只执行 `SAAS-G2L1-LOCAL-EXISTING-DEMO-RESUME-20261018`。从 `main:saas-system/docs/G2L1_LOCAL_EXISTING_DEMO_RESUME_GATE_20261018.md` 读取本 Gate，并且只读当前 `REVIEWER_HANDOFF.md` 的 SYSTEM_MAP、CURRENT_GATE、CRITICAL_CONSTRAINTS。本轮不做 G1 源码预检和 G2 镜像重建。核实 Owner 真机和旧 `saasvh-e88e259` 的三容器/两卷/镜像/端口后，仅按受限命令恢复已存在的 Demo Postgres/Redis/Web；依健康顺序实测 Sign in → Dashboard → Admin（含权限反例）→ Affiliate，并同时验证 Worker 与其他工作负载健康。出现真实其他业务回退只停止 Velobase；**不要恢复旧三个陌生容器**。留存非敏感证据，停 Reviewer。GitHub Codespaces Gate 已撤销，不能再使用。

## EXECUTOR_TO_REVIEWER_RELAY

按 Governance §9 返回短格式：`结果 / 改动 / 验证 / 问题 / 回滚 / 请 Reviewer 检查 / Owner 转交`；详细脱敏执行 Evidence 可在本项目文档记录，不含 Secret 或原始敏感日志。
