# G1_LOCAL_DOCKER_PREVIEW_GATE — Paymenter 本机可见性优先
GATE_ID: PAYMENTER-G1-LOCAL-DOCKER-ZH-PREVIEW-20261017
GOVERNANCE: entropy-student/spike.skill/vps-project-governance/VNEXT.md v0.2.7
STATUS: AUTHORIZED_NOT_EXECUTED

## OBJECTIVE / MAX_ENDPOINT / STOP
在 Owner 真正的 Windows 11 本机，以官方 Paymenter 容器镜像 + MariaDB + Redis 实现私有本机试用；中文优先；创建一个临时管理员；核实登录及首页、用户控制台、管理员后台的可见性。最大终点：LOCAL_PREVIEW_READY；禁止再执行 Stripe、付费插件、真实用户/订单业务。执行完成 STOP_AT_REVIEWER，不能自己声明正式 PASS。

## TARGET_AND_SCOPE
- 唯一目标：Owner Windows Desktop Docker Engine（不是 Codex sandbox / VPS / WSL 的其他宿主）。
- 唯一数据根：%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab；若非空且无本项目所有权标志，停止，不接管；可由 Executor 在 owned root 内创建 docker-compose.yml 与非秘密标记。
- Compose 项目名 paymenter_local_lab；服务：paymenter/database/cache；绑定 127.0.0.1:8187:80（端口冲突可在 8187-8197 中选一个未占用端口并同步 URL；不得覆盖其他服务）。
- 上游 Docker Compose 来源：Paymenter/Paymenter master commit 1d4c0b92dac0f93f28998b04c4c0e282bf436177 的 docker-compose.example.yml；官方文档 https://paymenter.org/docs/installation/docker。
- env APP_LOCALE=zh；若页面/个人设置还有语言配置，只在官方 UI 内调整，不分叉翻译文件。
- 独立随机 MariaDB 密码；绝不使用默认 CHANGE_ME；管理员 demo-admin@paymenter.local 随机强密码，仅在真实 Owner 本机显示，不写入 repo、日志、临时可共享目录或执行命令行参数。

## PREFLIGHT
1. 真实 Owner Windows 主机身份、用户、Shell 版本、Docker Server 与 Compose 版本 fresh readback；隔离 Codex 虚拟/重定向路径；不要以沙箱为真机。
2. 只读检查目标文件夹及其现存所有权、Compose 命名空间、端口冲突、本机资源；资源实在不足则精确说明并停止，不修改全局 Docker 内存配额、不清理其他容器。
3. 从官方锁定 commit 下载 Compose，核对其结构；强制只监听 loopback、独立随机 DB 密码、加入 zh 环境，验证 docker compose config。
4. 使用已审核官方镜像和现成 Compose，尽量少改代码。保留镜像 ID/digest 和持久化位置的非敏感记录。

## EXECUTE
- 先 docker compose up -d；核查 DB/cache/app；根据官方指南调用 app:init、CustomPropertySeeder；创建 admin 权限临时用户，自动产生本机显示的随机密码。可使用 Artisan 交互隐式输入或通过 stdin 向容器内短 PHP 进程传递密码，避免泄露在进程参数/日志中。
- 实际浏览器检查首页、注册登录、用户 dashboard、管理员 /admin，核实 zh 展示；如页面没有商品，不要误判为应用故障。允许创建**虚构、非付费、不可公开的展示产品/套餐**以核查界面；不绑定支付网关、不提交订单。
- 对 Referrals 扩展只做只读存在性/安装成本确认，本 Gate 不购买或安装第三方付费插件。
- 必须在 Owner 真实机器上证明前台与后台均可访问；不可用网页 HTTP 200 代替登录成功。

## ACCEPTANCE / EVIDENCE
- DIRECT_READBACK 主机证据、Docker/Compose 版本、项目限定 namespace、端口、容器状态、image ID、数据库+Redis 存活、应用响应、实际中文 UI 截图/描述。
- BEHAVIORALLY_VERIFIED：临时 admin 真正登录，能看到用户区和 admin 区；记录所见模块列表；无需核验生产支付。
- 隐私：不记录真实管理员密码、数据库密码、访问令牌或 Cookie；本机终端可向 Owner 单独展示一次性测试密码。
- 验收不足时返回具体 RETURN_*，停止在当前 Gate；禁止以重复全栈重建规避页面/登录错误。
- EXECUTION_EVIDENCE 新增非敏感事实，RESULT 最多 PASS_CANDIDATE，Reviewer 复核后更新 REVIEWER_HANDOFF。

## ROLLBACK / OWNER_ONLY / CONSTRAINTS
- 回退只允许定位到 paymenter_local_lab 的精确 docker compose stop；保留数据与日志以便复核。不 down -v、不 prune、不卸载 Docker、不清理其他容器。
- 不修改 VPN、VPS、生产域名、已有共享项目；不访问 Stripe Live；无实际付费、公开路由、第三方付费扩展。
- Owner 已授权进行可逆的本机试用部署和一次性测试账号创建；真实生产、公开上网、支付和成本项不在范围。

## REVIEWER_TO_EXECUTOR_RELAY
在真实 Owner Windows 11 本地 Codex 执行本 Gate，先读本文件和上游官方 Docker Compose 与当前项目代码必要片段，不必读完整 Governance/历史文件。使用最小且可恢复的本机独立 Compose；中文优先；自动创建随机强密码的临时管理员并只在本机终端向 Owner 展示，证明真实用户和管理员登录后 STOP_AT_REVIEWER。非敏感证据写到 paymenter-local-lab/EXECUTION_EVIDENCE.md 并 GitHub 回读验证。任何 RETURN 只解释实际问题，不反复扩大研究。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_<精准原因>
改动：本机项目限定文件/容器变化。
验证：Docker、中文、实际登录的直接事实；不泄露口令。
问题：NONE / 精确阻碍及其业务影响。
回滚：项目级 stop 和数据保留状态。
请 Reviewer 检查：界面截图/模块、证据以及 scope。
Owner 转交：NONE / 仅真实需要 Owner 操作的单项。
