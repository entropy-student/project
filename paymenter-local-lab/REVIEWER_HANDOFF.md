# Paymenter 本机试用 — REVIEWER_HANDOFF
Updated: 2026-10-17
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7 (ACTIVE_PROVISIONAL)
PROJECT_GOAL: 在 Owner 的 Windows 11 本机用 Docker 启动 Paymenter（中文优先），观察真实用户前台、管理员后台、产品/套餐及可用功能；此项目目前仅供私有试用。
PROJECT_STAGE: G1_PASS_LOCAL_PREVIEW / G2A_SOURCE_CLI_PASS / G2B_VISUAL_PARTIAL / G2B_R1_MINIMAL_FIX_AUTHORIZED_NOT_EXECUTED
SYSTEM_MAP: Owner Windows 11 build 26300 + PowerShell 7.6.5 + Docker Desktop Linux (Engine 29.7.2 / Compose v5.4.0) → 项目专属 Compose paymenter_local_lab [Paymenter、MariaDB、Redis] → 127.0.0.1:8187；活跃 MariaDB 数据位于项目命名卷 paymenter_local_lab_database；APP_KEY、Compose、日志、历史失败数据库目录等位于 %USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab；未使用 VPS/公网路由。
CURRENT_ACCEPTED_STATE:
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
CURRENT_GATE: docs/G2B_VISUAL_UI_ACCEPTANCE_GATE.md = IN_PROGRESS_PARTIAL_VISUAL_EVIDENCE / G2B_R1_TEXT_FIX_AUTHORIZED_NOT_EXECUTED；G1/G2A 正式 PASS；G2 全站 UI 尚非 PASS。
CRITICAL_CONSTRAINTS: 仅本机 loopback；不使用真实 Stripe、不产生真实交易、不购买/安装推荐扩展、不公开网络、不触碰其他 Docker 项目/VPS；不要把账号口令、DB Secret、Cookie 写到 GitHub。一次性演示密码曾在本次对话出现，禁止当作未来正式系统的可信凭据复用。
DEFAULT_EXECUTION_CHANNEL: Owner Windows 本地 Codex（已通过真实主机 G1 行为验证）；Reviewer 管理仓库文档与 Gate。
CURRENT_ROLLBACK_STATUS: 可通过精确 docker compose -p paymenter_local_lab -f <owned-compose> stop 停止试用并保留命名卷及本机文件；这属于停机而不是已验证的全量灾备/恢复，恢复演练未做。
UNRESOLVED: G2B 四张 Owner 截图确认已有管理员 Dashboard/商品列表/优惠券创建表单/通知模板列表基本简体；剩余 Support、暂无 ticket、Category:、Slug、通知模板默认英文主题、底部链接英文和日期 yyyy/mm/日 显示不一致。未见用户前台/登录后的用户 dashboard 和商品编辑/套餐选项、弹窗实际操作，功能完整性及动态文案未证实。Stripe/Referrals 未启用；浏览器工具停止指令不得绕过。
NEXT_STEP: 同一 G2B Gate 内由 Owner Windows 本地 Codex 执行尾部 2026-10-17 Reviewer Screenshot Review/R1 指令：只修明确证实的显示层英文/日期问题，生成增量补丁及 CLI/功能不变证据，保存本机回滚来源，交 Reviewer；之后最少只需用户 dashboard 与商品编辑/套餐两类补充视觉证据和改后 Dashboard/通知列表复查。
OWNER_ACTION_REQUIRED: 将同一 G2B Gate 的 R1 最小汉化修复提示词发给本机 Codex；不需要重部署或继续重复提供这四张截图。后续仅需一张用户控制台和一张商品编辑/套餐截图供最终可视核对。
EVIDENCE_POINTERS: EXECUTION_EVIDENCE.md (含 2026-10-17 G2B 四张截图的文字化审阅结论，不公开上传截图)；当前 Gate docs/G2B_VISUAL_UI_ACCEPTANCE_GATE.md 尾部 2026-10-17 R1；G2A 已合并 PR #148 a5a5f119eedd4cd56bd6e8f7a94865c935ebd7a3；回滚 localization/g2a/README.md。
