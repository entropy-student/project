# Paymenter 本机试用 — REVIEWER_HANDOFF
Updated: 2026-10-17
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7 (ACTIVE_PROVISIONAL)
PROJECT_GOAL: 在 Owner 的 Windows 11 本机用 Docker 启动 Paymenter（中文优先），观察真实用户前台、管理员后台、产品/套餐及可用功能；此项目目前仅供私有试用。
PROJECT_STAGE: G3_DOCKER_DECOMMISSION_PARTIAL_PASS / G3_OWNER_LOCAL_ROOT_DELETE_CHECKPOINT_PENDING / GITHUB_REMOVAL_DEFERRED
SYSTEM_MAP: Owner Windows 11 build 26300 + PowerShell 7.6.5 + Docker Desktop Linux (Engine 29.7.2 / Compose v5.4.0)；原独占 Compose paymenter_local_lab 的 3 个容器、app/database 2 个命名卷、专属网络已经删除，127.0.0.1:8187 无监听；仅剩 C:\Users\34707\Documents\ChatGPT\Paymenter-Local-Lab 本机专属目录（含项目秘密、旧失败数据库文件、备份），等待 Owner Windows 手动精准删除。其他 35 个容器、22 卷、12 网络、20 镜像不动；未使用 VPS/公网路由。
CURRENT_ACCEPTED_STATE:
- Reviewer G3 PARTIAL_ACCEPTED 2026-10-17：审阅 PR #151 的 Docker 域执行证据，3 项容器、2 项只属于 Paymenter 的命名卷及其唯一项目网络已移除，8187 不再监听，未动 35 其他容器、22 卷、12 网络、20 镜像；旧目录仍含 1,105 个项目文件及秘密和遗留 host 数据库；单路径 PowerShell 递归删除由自动执行策略阻止，未执行且未换工具。PR #151 合并至 main d679f3a0edaf20499e050f118277171522adf7f0；G3 整体未 PASS。根据 Governance 11F，下一步只能将该唯一准确删除动作转为 Owner 原生 Windows GUI 人工 checkpoint，再做只读缺失核验；不可自动换方式绕过。GitHub 目录保持不动。
- OWNER_AUTHORIZED_G3_DECOMMISSION 2026-10-17：Owner Windows fresh preflight 确认当前只有已知演示账户/虚构商品，无订单、发票、服务、交易或扩展；唯一 Paymenter 容器/网络/两个命名卷已按标签与引用检查后移除，8187 无监听。执行器自动策略拒绝了专属项目根目录递归删除，根目录仍含本地专属文件/秘密，因此结果为 RETURN_PARTIAL_DECOMMISSION。非 Paymenter Docker 清单与镜像 ID 前后摘要完全一致。GitHub 子树未删除；先由 Reviewer 核对部分卸载证据并解决余项。
- OWNER_REPORTED 2026-10-17（G2C 后真实体验，RECORD_ONLY）：管理员后台无论调整语言仍然英文，也可能没有找到正确设置；前台切换不同语言后仍出现中英文/其他语言混排。此 G2B UX 问题保持 OPEN/UNVERIFIED_ROOT_CAUSE；不以 G2C CLI PASS 覆盖 Owner 使用感受。用户明确要求暂不修复，转向调查 Paymenter 裂变功能。
- REFERRAL_RESEARCH 2026-10-17：本机 G1 历史确认安装扩展 0、支付网关 0（本轮无新本机读回），优惠券为原生功能且不自动等于推荐关系。第三方 Referrals https://paymenter.org/marketplace/119604-referrals，BuiltByBit 收费 $6.99、closed source、标注英语界面、仅公开标记 Paymenter 1.5.0 兼容（本机 1.5.9 未核实）；可提供个人推荐链接/码、首几张发票折扣、持续佣金、账户余额兑换、佣金等级及管理后台，但插件未购未装，手输邀请码和直接发 SaaS 额度/会员权益尚未确认。
- Reviewer G2C PASS 2026-10-17: Reviewed complete PR #150 with exact three-source-file incremental patch, replay README, non-secret execution evidence, and official Filament v5.7.6 NavigationGroup/NavigationManager source. Confirmed admin locale allows session values and zh only maps zh_CN, en/fi remain; NavigationGroup Closure lazily resolves label; audit details restore two removed arguments and pass actual in-memory fixture rendering by Executor. Validated reported HTTP Kernel locale probes, data/12 notification template invariants and bidirectional patch checks within scoped trust boundary. Reviewer did not directly log in to Owner Windows; G2B remains PARTIAL. PR #150 squash merged into main 752b4ececf0d58850fc34431db785327add4dc25.
- Reviewer G2C SOURCE_DIAGNOSIS 2026-10-17：Owner 新增五张截图证实前台语言选择 Suomi 后菜单变 Koti/Kauppa/Näytä，原本中文商品与分类因源自数据库记录，不随 locale 变换，故前台 UI 切换部分正常；但 G2A 中 admin SetAdminLocale 无条件 zh_CN，确实属于不应存在的强制中文覆盖。源补丁 audit 详情 view 另存在两个缺参调用 `str_replace('_', ' ', )` 与 `class_basename()`，可导致详情页运行时报错，虽截图 audit 列表正常也不能证明详情安全。两项最小修复 G2C 已授权但尚未本机执行；G2B 视觉仍 PARTIAL。
- OWNER_SCREENSHOTS 2026-10-17：R1 后通知模板 8 个默认英文主题已显示简体中文，未知带动态变量主题和 Email verification 仍英文；Audit List/Failed Job List 顶部列标题英文。五张图只证实页面可见，不证实保存/业务运行，也未覆盖用户 dashboard 或套餐编辑。
- G2B R1 REVIEWER SOURCE_CLI_PASS 2026-10-17：Reviewer 审核 PR #149 六文件增量补丁、README、CLI/只读 HTTP/业务计数证据并核对 Filament TableWidget heading 和 Group 对象 API，确认八个默认通知标题仅管理员列表精确显示映射，动态变量/自定义模板、数据库及实际发送功能不变；商品与套餐选项仅翻译显示标签。PR #149 squash 合并至 main b2dca40ccfdf8c405a1bfce36f248ed74a701e08。R1 本机补丁由 Executor 应用并通过其 CLI/静态检查，但 Reviewer 未独立登入本机验证修改后的页面；G2B 总体 PARTIAL。
- G2B VISUAL_REVIEW 2026-10-17 (OWNER_SCREENSHOTS + REVIEWER_DIRECT_INSPECTION): 四张 2048x1028 截图逐页展示已登录管理员仪表盘、商品列表、创建优惠券、通知模板列表，主要后台导航与操作/报表已简体中文、未发现明显错位，但 Support / 暂无 ticket / Category: / Slug、日期占位 yyyy/mm/日、通知模板主题内容及侧边栏底部文案仍有英文。本轮判为 PARTIAL_G2B_VISIBLE_LANGUAGE_GAPS（不是 G2 FAIL，更不是全站 G2 PASS），仅授权当前 Gate 内的显示层最小 R1 修补。截图本身留在 Owner 对话，不提交公开仓库。
- Reviewer G2A PASS 2026-10-17：PR #148 经补丁/源码及证据审查，已 squash 合并到 main（a5a5f119eedd4cd56bd6e8f7a94865c935ebd7a3）。Executor DIRECT_READBACK 在真实本机 Paymenter v1.5.9（ee729f7d99ac18942625b79f3f93d8d8b21255e8）部署了 117 路径源码简体中文主补丁及 themes_default 启动覆盖补丁；15 组 lang/zh，新增 zh_CN 与 642 键 JSON，115 PHP lint、11 Blade 编译、26 资源标签、24 常见标签探针均通过；只有 paymenter 单服务重启，HTTP 首页/登录/演示商品 GET 为 200 且有简体中文。Reviewer 并未直接操作 Owner 本机，登录后的 UI 效果仍 UNKNOWN，不得称 G2 整体验收 PASS。
- 运行/回滚：Paymenter v1.5.9 应用源码位于 /app 项目命名卷；翻译补丁/回滚说明已归档，项目专属备份在 %USERPROFILE%\\Documents\\ChatGPT\\Paymenter-Local-Lab\\g2a-work\\backup-original；恢复只允许这轮文件及首页设置，保留服务数据和其他 Docker 项目。
- OWNER_REPORTED 2026-10-17: 本轮 G2 Executor 只读确认 Paymenter v1.5.9 与三服务可用；Windows 浏览器工具未能充分确认活动页面 URL 并要求停止 Computer Use；本轮未汉化、未重启、未提交 PR。Reviewer 将该情况归类为 RETURN_BROWSER_TOOL_UNAVAILABLE，与 G1 业务运行状态区分处理。
- OWNER_REPORTED: 已分享前台登录与管理员 Dashboard 截图，明确要求现有本机实例用户区和管理员区均改用简体中文；本 G2 仅修改 UI 本地化，不改变业务数据。
- Reviewer 已在 GitHub 审核 PR #145 的完整差异及项目执行证据，2026-10-17 完成 G1 范围内的正式 PASS；PR #145 squash merge commit ba556eb3479e13aec92885627ad6df217f40eb0c。该 PASS 是本地预览范围，不代表生产可用。
- EXECUTOR DIRECT_READBACK (GitHub 证据记录、Reviewer 审查): 三个项目容器运行；仅 127.0.0.1:8187 对本机开放；MariaDB/Redis 探测成功；Laravel 71 migrations Ran / 0 Pending；用户 1、分类 1、产品 1、方案 1、订单 0、发票 0、服务 0；Stripe/其他网关为空。
- EXECUTOR BEHAVIORALLY_VERIFIED (GitHub 证据记录、Reviewer 审查): 管理员 demo-admin@paymenter.local 已真实登录并进入 /dashboard，/admin 模块可见；虚构分类、免费演示产品及详情页可见；未打开结账、未下单。
- 中文事实：默认语言已设置 zh；前台、登录页、用户区部分繁体中文；首页及管理员后台仍有英文。未更改翻译文件。此为功能限制，不是 G1 部署阻塞。
- 源码/镜像：官方 Paymenter 上游 master 1d4c0b92dac0f93f28998b04c4c0e282bf436177；实际 App/MariaDB/Redis 镜像 SHA 与探测细节详见 EXECUTION_EVIDENCE。
- 启动问题已修复并验证：数据库 readiness 竞态；Windows host bind MariaDB InnoDB 表空间问题。改用独立命名卷，保留首次失败数据目录；未 prune/down -v、未动其他项目。
CURRENT_GATE: docs/G3_SAFE_DECOMMISSION_GATE.md = DOCKER_PARTIAL_PASS / OWNER_LOCAL_EXACT_DIRECTORY_CHECKPOINT_PENDING / GITHUB_DELETION_WAITING；自动删除明确 blocked by policy 且未执行，不允许更换自动执行工具规避。
CRITICAL_CONSTRAINTS: 仅本机 loopback；不使用真实 Stripe、不产生真实交易、不购买/安装推荐扩展、不公开网络、不触碰其他 Docker 项目/VPS；不要把账号口令、DB Secret、Cookie 写到 GitHub。一次性演示密码曾在本次对话出现，禁止当作未来正式系统的可信凭据复用。
DEFAULT_EXECUTION_CHANNEL: Owner Windows 本地 Codex（已通过真实主机 G1 行为验证）；Reviewer 管理仓库文档与 Gate。
CURRENT_ROLLBACK_STATUS: 原应用/数据库专属 Docker 卷已删除，无法保证恢复原演示数据库；旧失败数据库 host 目录未被证明可用于恢复，不能当成可用备份。GitHub 历史代码仍存在；本机 secrets/legacy files 待 Owner 本地精准删除。此 G3 属用户明确授权的最终退役，无完整数据回滚保证。
UNRESOLVED: Owner 在 G2C 后反馈：后台无论如何调整仍英文（也可能尚未找到正确入口），前台切换语言后中英及其他语言混杂；真实 UX 原因未诊断且 G2B 视觉仍 PARTIAL。G2C 仅源码/请求/fixture 范围 PASS，不可抵消使用者报告。原生 DB 商品/分类不会自动翻译，后台芬兰语缺词条时英文 fallback。Stripe/Referrals 未启用（历史证据；非最新直读）。Owner 要求暂记问题，不再推进翻译。
NEXT_STEP: Reviewer 已接受 PR #151 Docker-only 清理事实。根据治理 §11F，阻止自动删除后不得换用其它自动方式；只剩 Owner 自己在 Windows 文件资源管理器对唯一准确目录 C:\Users\34707\Documents\ChatGPT\Paymenter-Local-Lab 进行一次 Shift+Delete 永久删除。之后由原本机 Codex **只读**验证该目录不存在、项目容器/网络/卷 0、8187 无监听、其他 Docker 项目未变，返回非敏感结果；Reviewer 核验 LOCAL_PASS 后仅删除共享 GitHub repo/main 的 paymenter-local-lab 子树。
OWNER_ACTION_REQUIRED: 唯一一次手动操作：Win+E，地址栏粘贴 C:\Users\34707\Documents\ChatGPT，核对 Paymenter-Local-Lab 文件夹，单选它并按 Shift+Delete（永久删除、不进入回收站），确认 Windows 弹窗。该目录包含项目秘密/旧演示数据，无法保证恢复；千万不要删除上层 ChatGPT 或其它目录。然后将“已删除”回复，Reviewer 提供本机 Codex 只读核验口令，后续 GitHub 清理由 Reviewer 完成。
EVIDENCE_POINTERS: docs/G3_SAFE_DECOMMISSION_GATE.md；EXECUTION_EVIDENCE.md 的 2026-10-17 G3 Executor 仅 Docker 范围清理证据、Reviewer PR #151 部分接受记录；PR #151 squash d679f3a0edaf20499e050f118277171522adf7f0；本机目录仍在，GitHub main 目录待 LOCAL_PASS 后删除。


## 2026-10-17 G2C Executor result
PR: https://github.com/entropy-student/project/pull/150
- 状态：`PASS_CANDIDATE_G2C_LOCALE_AND_AUDIT_CLI` / `PARTIAL_G2C_UI_EVIDENCE_PENDING`。
- 改动：仅 `SetAdminLocale`、Filament admin navigation groups、audit detail Blade 三处；补丁、回滚、验证见 `localization/g2c/` 与本文件关联的 `EXECUTION_EVIDENCE.md`。
- 语言：前台 zh/en/fi 菜单切换通过；admin zh → zh_CN，en/fi 保持；非法/空/缺失 admin session 回退本机简体默认；Finnish 缺少的管理分组词条回退英文。
- 审计详情：真实 Blade view 使用非持久化 fixture 渲染通过。
- 未完成：未认证 admin HTTP 为 302，因此没有登录态真实截图/交互验收；G2B 整体仍 PARTIAL。
- 数据：G2C 前后业务计数、12 条通知模板聚合哈希不变；无容器重启/迁移/支付变更。
