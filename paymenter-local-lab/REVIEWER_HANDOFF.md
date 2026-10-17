# Paymenter 本机试用 — REVIEWER_HANDOFF
Updated: 2026-10-17
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7 (ACTIVE_PROVISIONAL)
PROJECT_GOAL: 在 Owner 的 Windows 11 本机用 Docker 启动 Paymenter（中文优先），观察真实用户前台、管理员后台、产品/套餐及可用功能；此项目目前仅供私有试用。
PROJECT_STAGE: G1_PASS_LOCAL_PREVIEW / G2A_SOURCE_CLI_PASS_WITH_KNOWN_REGRESSION / G2B_R1_SOURCE_CLI_PASS / G2B_VISUAL_PARTIAL / G2C_LOCALE_AND_AUDIT_CLI_CANDIDATE_REVIEWER_PENDING
SYSTEM_MAP: Owner Windows 11 build 26300 + PowerShell 7.6.5 + Docker Desktop Linux (Engine 29.7.2 / Compose v5.4.0) → 项目专属 Compose paymenter_local_lab [Paymenter、MariaDB、Redis] → 127.0.0.1:8187；活跃 MariaDB 数据位于项目命名卷 paymenter_local_lab_database；APP_KEY、Compose、日志、历史失败数据库目录等位于 %USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab；未使用 VPS/公网路由。
CURRENT_ACCEPTED_STATE:
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
CURRENT_GATE: G2C `PASS_CANDIDATE_G2C_LOCALE_AND_AUDIT_CLI` / `PARTIAL_G2C_UI_EVIDENCE_PENDING`，新增三文件补丁和无敏感证据已进入 https://github.com/entropy-student/project/pull/150，等待 Reviewer；G2B 登录态视觉总体验收仍 PARTIAL 且保留，G1/G2A/R1 不重跑。
CRITICAL_CONSTRAINTS: 仅本机 loopback；不使用真实 Stripe、不产生真实交易、不购买/安装推荐扩展、不公开网络、不触碰其他 Docker 项目/VPS；不要把账号口令、DB Secret、Cookie 写到 GitHub。一次性演示密码曾在本次对话出现，禁止当作未来正式系统的可信凭据复用。
DEFAULT_EXECUTION_CHANNEL: Owner Windows 本地 Codex（已通过真实主机 G1 行为验证）；Reviewer 管理仓库文档与 Gate。
CURRENT_ROLLBACK_STATUS: 可通过精确 docker compose -p paymenter_local_lab -f <owned-compose> stop 停止试用并保留命名卷及本机文件；这属于停机而不是已验证的全量灾备/恢复，恢复演练未做。
UNRESOLVED: G2C locale 中间件和 audit 详情参数已作最小源码/CLI 修复并提交 Reviewer；后台登录态真实视觉仍未验收。另有人工注入非法前台 session locale 时原版 SetLocale 未返回 200 的非正常路径观察；内置 LocaleSwitch 有 allow-list 校验，本 Gate 未改前台中间件，Reviewer 可决定是否另开范围。Owner 的 R1 后截图证实前台切 Suomi 菜单为 Koti/Kauppa/Näytä，演示商品/分类与品牌中文来自已保存内容，属预期。R1 通知列表八项中文已实拍，但动态标题仍英文；部分管理员技术列表列名英文；用户 dashboard、商品编辑/套餐和其它交互仍未验收。原生日期占位随浏览器区域设置，Stripe/Referrals 未启用。
NEXT_STEP: Reviewer 审查 G2C 三文件增量补丁、请求级 zh/en/fi locale 证据及审计详情 fixture 渲染；若接受，再按正常支持方式补充登录态视觉验收，保持 G2B 总体 PARTIAL 直至其证据完整。不重复 Docker/G1/G2A/R1。
OWNER_ACTION_REQUIRED: G2C 源码/CLI 执行证据已提交 PR；无本机操作或业务数据变更待 Owner 执行。仅在 Reviewer 要求时，通过正常支持的路径补登录态截图；不绕过浏览器工具限制。
EVIDENCE_POINTERS: EXECUTION_EVIDENCE.md 包含 Reviewer 的五张截图分析、原版 locale 源码与 G2A audit 缺参核验；当前 Gate docs/G2C_NATIVE_LOCALE_AND_AUDIT_REPAIR_GATE.md；PR #148 G2A 原补丁、#149 R1 增量补丁；G2B 视觉仍见 docs/G2B_VISUAL_UI_ACCEPTANCE_GATE.md；修复前状态不变。


## 2026-10-17 G2C Executor result
PR: https://github.com/entropy-student/project/pull/150
- 状态：`PASS_CANDIDATE_G2C_LOCALE_AND_AUDIT_CLI` / `PARTIAL_G2C_UI_EVIDENCE_PENDING`。
- 改动：仅 `SetAdminLocale`、Filament admin navigation groups、audit detail Blade 三处；补丁、回滚、验证见 `localization/g2c/` 与本文件关联的 `EXECUTION_EVIDENCE.md`。
- 语言：前台 zh/en/fi 菜单切换通过；admin zh → zh_CN，en/fi 保持；非法/空/缺失 admin session 回退本机简体默认；Finnish 缺少的管理分组词条回退英文。
- 审计详情：真实 Blade view 使用非持久化 fixture 渲染通过。
- 未完成：未认证 admin HTTP 为 302，因此没有登录态真实截图/交互验收；G2B 整体仍 PARTIAL。
- 数据：G2C 前后业务计数、12 条通知模板聚合哈希不变；无容器重启/迁移/支付变更。
