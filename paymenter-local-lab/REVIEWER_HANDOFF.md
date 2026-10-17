# Paymenter 本机试用 — REVIEWER_HANDOFF
Updated: 2026-10-17
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7 (ACTIVE_PROVISIONAL)
PROJECT_GOAL: 在 Owner 的 Windows 11 本机用 Docker 启动 Paymenter（中文优先），观察真实用户前台、管理员后台、产品/套餐及可用功能；此项目目前仅供私有试用。
PROJECT_STAGE: G1_PASS_LOCAL_PREVIEW / G2_SIMPLIFIED_CHINESE_AUTHORIZED_NOT_EXECUTED
SYSTEM_MAP: Owner Windows 11 build 26300 + PowerShell 7.6.5 + Docker Desktop Linux (Engine 29.7.2 / Compose v5.4.0) → 项目专属 Compose paymenter_local_lab [Paymenter、MariaDB、Redis] → 127.0.0.1:8187；活跃 MariaDB 数据位于项目命名卷 paymenter_local_lab_database；APP_KEY、Compose、日志、历史失败数据库目录等位于 %USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab；未使用 VPS/公网路由。
CURRENT_ACCEPTED_STATE:
- OWNER_REPORTED: 已分享前台登录与管理员 Dashboard 截图，明确要求现有本机实例用户区和管理员区均改用简体中文；本 G2 仅修改 UI 本地化，不改变业务数据。
- Reviewer 已在 GitHub 审核 PR #145 的完整差异及项目执行证据，2026-10-17 完成 G1 范围内的正式 PASS；PR #145 squash merge commit ba556eb3479e13aec92885627ad6df217f40eb0c。该 PASS 是本地预览范围，不代表生产可用。
- EXECUTOR DIRECT_READBACK (GitHub 证据记录、Reviewer 审查): 三个项目容器运行；仅 127.0.0.1:8187 对本机开放；MariaDB/Redis 探测成功；Laravel 71 migrations Ran / 0 Pending；用户 1、分类 1、产品 1、方案 1、订单 0、发票 0、服务 0；Stripe/其他网关为空。
- EXECUTOR BEHAVIORALLY_VERIFIED (GitHub 证据记录、Reviewer 审查): 管理员 demo-admin@paymenter.local 已真实登录并进入 /dashboard，/admin 模块可见；虚构分类、免费演示产品及详情页可见；未打开结账、未下单。
- 中文事实：默认语言已设置 zh；前台、登录页、用户区部分繁体中文；首页及管理员后台仍有英文。未更改翻译文件。此为功能限制，不是 G1 部署阻塞。
- 源码/镜像：官方 Paymenter 上游 master 1d4c0b92dac0f93f28998b04c4c0e282bf436177；实际 App/MariaDB/Redis 镜像 SHA 与探测细节详见 EXECUTION_EVIDENCE。
- 启动问题已修复并验证：数据库 readiness 竞态；Windows host bind MariaDB InnoDB 表空间问题。改用独立命名卷，保留首次失败数据目录；未 prune/down -v、未动其他项目。
CURRENT_GATE: docs/G2_SIMPLIFIED_CHINESE_UI_GATE.md = OWNER_AUTHORIZED / EXECUTOR_NOT_STARTED。G1 预览已正式 PASS，不重演历史 Gate。
CRITICAL_CONSTRAINTS: 仅本机 loopback；不使用真实 Stripe、不产生真实交易、不购买/安装推荐扩展、不公开网络、不触碰其他 Docker 项目/VPS；不要把账号口令、DB Secret、Cookie 写到 GitHub。一次性演示密码曾在本次对话出现，禁止当作未来正式系统的可信凭据复用。
DEFAULT_EXECUTION_CHANNEL: Owner Windows 本地 Codex（已通过真实主机 G1 行为验证）；Reviewer 管理仓库文档与 Gate。
CURRENT_ROLLBACK_STATUS: 可通过精确 docker compose -p paymenter_local_lab -f <owned-compose> stop 停止试用并保留命名卷及本机文件；这属于停机而不是已验证的全量灾备/恢复，恢复演练未做。
UNRESOLVED: 简体中文补全尚未执行（前台仍有繁体，管理后台导航/组件写死英文）；Referrals 插件和 Stripe 实测仍不在当前 Gate；重启持久性及项目外生产能力未验收。
NEXT_STEP: 使用已验收 Owner Windows 本机 Codex 执行 G2：补齐 zh-Hans 翻译与硬编码后台标签，保持本机 Docker 其他业务不变，附核心页面和单服务重启回归证据后 RETURN_TO_REVIEWER。
OWNER_ACTION_REQUIRED: 将 G2 执行提示词转给同一个 Windows 本机 Codex；无需手动编辑翻译文件或重部署。
EVIDENCE_POINTERS: EXECUTION_EVIDENCE.md（2026-10-17 G1 本机执行 + Reviewer 接受记录）；docs/G2_SIMPLIFIED_CHINESE_UI_GATE.md；localization/TRANSLATION_GLOSSARY.md；PR #145（已验收 G1）；G2 尚无本机执行证据。
