# G3 — Paymenter 本机试用项目安全移除
GATE_ID: PAYMENTER-G3-OWNER-WINDOWS-LOCAL-DECOMMISSION-20261017
STATUS: OWNER_AUTHORIZED / LOCAL_EXECUTION_NOT_STARTED
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7，适用 11A/11B/11C/11F（Closeout）
OWNER_INSTRUCTION: “把本项目在我的电脑安全移除吧，移除完成后 GitHub 仓库也安全移除。”授权彻底移除且仅移除本机 Paymenter 私有演示实例的容器、项目命名卷、项目专属网络、本机专属文件和秘密；**先本机核验删除，再由 Reviewer 清除 GitHub entropy-student/project 中 paymenter-local-lab 路径**。不授权删除整个共享 GitHub 仓库、不授权 Git history 改写或清理其他项目/镜像/通用缓存。

## 目标与最大终点
本机任务仅在真实 Owner Windows 上完成 Paymenter 的安全清理和独立退出证明，产生不含密码/令牌的精简执行回执提交至 `paymenter-local-lab/EXECUTION_EVIDENCE.md`（**本机清理完之前/之后仍可以由 GitHub Connector 记录**，不能依赖被删除本机目录），随后 STOP_AT_REVIEWER。Reviewer 核验本机证据后另执行 GitHub 删除，最终从 main 验证 `paymenter-local-lab/` 不存在且其他项目不变。

## 已知但需 fresh 核对的本机边界
- Host: Owner Windows 11 + Docker Desktop。入口原为 http://127.0.0.1:8187。
- Compose project: `paymenter_local_lab`；声明服务 `paymenter`, `database`, `cache`，另有 profile `asset-builder`（可能从未启动，**先枚举**）。
- 原启动配置 `%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab\docker-compose.yml`，所有权标记 `.paymenter-preview-owned`。
- 命名卷：`paymenter_local_lab_app`、`paymenter_local_lab_database` 预期；实际卷和网络**必须由 Docker labels/config/mounts 查明，绝不可根据猜测通配删除**。原版启动采用 `./:/app/var`，且分别 bind `storage/logs`、`storage/public`、`themes`、`extensions`；首次失败的旧 `database` host 目录在项目根内。
- 已接受的上次本机只读结果为 users 1/categories 1/products 1/plans 1/orders 0/invoices 0/services 0/extensions 0/payment gateways 0，仅虚构演示；这**不是今天实时保证**。
- 项目单独私有翻译备份、补丁和 APP_KEY/MariaDB 凭据在本机项目根，删除时按秘密处理，不能在输出、GitHub 或聊天中公开。
- GitHub shared repo: `entropy-student/project` 的 `paymenter-local-lab/`；历史 PR #143, #145–#150 及主仓库其他项目**不是本机清理目标**。

## Preflight — 删除前全部必须成立
1. 确认真正的 Owner Windows 主机、当前用户、PowerShell 与 Docker Engine/Compose；不是 Codex 沙箱、WSL 代理或另一台 VPS。只读枚举正在运行/已停止的项目容器、镜像、network、volume 及 bind mounts，确认所有待删除项 Docker label (`com.docker.compose.project=paymenter_local_lab`)、Compose config、文件系统路径/ownership marker 相互吻合；若冲突/残余项目身份不明，`RETURN_SCOPE_UNKNOWN`。
2. 列出所有 Docker 项目/网络/卷被引用关系；若任一准备删除的卷/网络同时被其它项目/非项目容器使用，`RETURN_SHARED_RESOURCE`，不删除。禁止删除共享镜像/基础镜像和 Docker Desktop/WSL、构建缓存、其他 docker 项目、Docker daemon 配置。
3. 检查当前演示状态仅为虚构数据，无新实付、真实订单/发票/服务/用户业务资料；若有未知或真实业务数据，`RETURN_DURABLE_DATA_REVIEW` 不得删除。确认当前本机目录无未提交独特源码/文档（可与 GitHub 交叉核对）或非本项目文件。若目录存在 junction/symlink/reparse-point 或外指路径，`RETURN_UNOWNED_PATH` 不递归删除。不要为检查内容而打印秘密文件/环境变量。
4. GitHub 远程为已回读可访问的项目代码与记录；Owner 已明确要求最终从 GitHub main 移除（历史 Commit/PR 保留可追溯），不需要额外外传本地源码/秘密/数据库；不创建远端备份或上传隐私文件。
5. 检查本机准确的 `docker-compose.yml` 与 project name 仍一致；没有失踪/虚拟化路径/非 Owned 目录。Preflight 非 PASS 时只返回事实、停止，**不要执行任何破坏命令**。

## 执行 — 严格本机顺序
A. 使用 `docker compose -p paymenter_local_lab -f <验证过的项目 compose> down`，**不**带 `--volumes`、`--rmi`、`--remove-orphans`，必要时先处理已识别的项目专属停止容器；只能操作带已核对项目标签的容器。不能 `docker rm -f $(docker ps -aq)` 等跨项目命令。
B. 通过 fresh Docker readback，逐一精确删除只属于本项目且没有其他引用的命名卷（包括 `app` 与 `database`）；保留镜像和任何共享卷/网络，不使用通配/全局 prune。若发生部分失败，保留现场并 `RETURN_PARTIAL_DECOMMISSION`，不能转而清除所有文件来掩盖失败。
C. 确认项目 Compose 容器和专属 network/volumes 已无，8187 不再由本项目监听；若端口被其它服务占用，只报告非项目进程，不关闭它。不能仅凭 HTTP 不通宣称完整卸载。
D. 最后删除**唯一准确且已证实本项目独占**的 `%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab` 目录，包括遗留 host database 目录、源码本地补丁/工作目录、日志/扩展/主题/演示上传、项目秘密及本地备份；执行前再次确认该路径不存在软链接/重解析点/unknown 独特文件，且没有任何 Compose/Docker mount 仍引用。绝不删除父目录 `Documents\ChatGPT`、同级其他 SaaS 或 Windows 账户目录。
E. 只读 post-check：项目名匹配容器 0、卷 0、网络 0；项目本机根目录不存在；本机 8187 不再是 Paymenter；其它 Docker 项目的容器、卷、网络摘要不变。记录仅非敏感计数/资源精确名称/检查结论，不能包含秘密或整份 compose 展开。

## 验收与 Gate 边界
- `LOCAL_DECOMMISSION_PASS_CANDIDATE`：有本机真实执行证明、前后对照、精确 Docker 资源名/labels、安全数据分类、无交叉影响、项目目录不存在、端口不属于本项目；GitHub 路径仍保留等待 Reviewer **后续按 Owner 顺序清理**。
- 如果目标路径或数据不明、出现真实交易/独有资料、资源共享或执行一部分失败，则 `RETURN_具体原因`，先 reconcile，保留 GitHub 项目，不继续删除。
- 不允许执行 `docker system prune`/`docker volume prune`、宽范围 `Remove-Item`、Docker Desktop 卸载、git reset/force push、删除整个 entropy-student/project 仓库或重写历史。
- 本轮终点为本机清理证明 **STOP_AT_REVIEWER**，不要本机 Codex 自行删除共享仓库的 project 目录或其他 GitHub 分支，Reviewer 接受证据后接手 GitHub-only 清理。
- 恢复模型：删除演示数据和本地秘密后**不保证原数据可恢复**（Owner 已授权全量卸载、已核对无真业务）；GitHub 旧 commit 可用于重建源码，但不能恢复被删的本机 DB 与原密钥。不承诺删除 Git 历史中的代码或历史 PR。
- 交接简短格式：`RESULT`、`OWNER_WINDOWS_PROOF`、`PROJECT_DOCKER_OBJECTS_BEFORE_AFTER`、`OWNED_ROOT_BEFORE_AFTER`、`SHARED_RESOURCES_UNCHANGED`、`UNKNOWN_OR_RESIDUAL`、`GITHUB_NOT_TOUCHED`。不要在 PR 或 Chat 返回密码值。

## REVIEWER_TO_EXECUTOR_RELAY
只读本 Gate、项目 `REVIEWER_HANDOFF.md` 当前状态和 `START_PAYMENTER_LOCAL.ps1` 的部署边界，及真实 Owner Windows 上的已存在 Compose、Docker readback。不重新调研项目/汉化/支付。一次性完成有界 fresh preflight→Compose project down→精确项目命名卷/残余网络删除→准确项目独占本机根目录删除→非敏感 readback。只有 fresh data + ownership + no cross-project refs 全 PASS 时才删除；否则返回精准阻塞、不清理共享资源。项目真实卸载证明返回 Reviewer 后**由 Reviewer 清 GitHub**。

## EXECUTOR_TO_REVIEWER_RELAY
结果：LOCAL_DECOMMISSION_PASS_CANDIDATE / RETURN_精准阻碍
改动：仅 Owner PC 中 paymenter_local_lab 容器/卷/网络与唯一项目目录。
验证：删除前后有界 Docker 对象、8187、项目本机目录和其他项目无变化。
问题：NONE / 精确未知与残留。
回滚：已删除演示 DB/密钥不保证复原；保留 GitHub 既有 commit 用于重新安装源码。
请 Reviewer 检查：本机全清零且范围正确，并在确认后删 GitHub main 里 paymenter-local-lab 目录。
Owner 转交：仅本轮运行结果，不包含秘密。
