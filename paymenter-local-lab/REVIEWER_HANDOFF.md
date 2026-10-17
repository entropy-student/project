# Paymenter 本机试用 — REVIEWER_HANDOFF
Updated: 2026-10-17
GOVERNANCE: entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7 (ACTIVE_PROVISIONAL)
PROJECT_GOAL: 在 Owner 的 Windows 11 本机，通过 Docker Desktop 启动 Paymenter（优先官方中文），创建可登录的本地测试管理员，观察完整用户前台、管理员后台和商业功能。仅演示，不连接真实 Stripe、不产生真实资金或公开访问。
PROJECT_STAGE: G1_AUTHORIZED_NOT_EXECUTED
SYSTEM_MAP: Windows 11 Owner 主机（上次观察为 PowerShell 7.6.x + Docker Desktop；本轮未经直接验证）→ Docker Compose [Paymenter(PHP/Nginx), MariaDB, Redis] → 127.0.0.1:8187；本地持久化仅在 %USERPROFILE%/Documents/ChatGPT/Paymenter-Local-Lab；Web/后台与 DB 分层；不访问 VPS / Shared Infra。
CURRENT_ACCEPTED_STATE:
- DIRECT_READBACK GitHub: Paymenter/Paymenter 上游 master 1d4c0b92dac0f93f28998b04c4c0e282bf436177；官方 docker-compose.example.yml 提供完整三服务栈，默认对外 80 端口须改为 127.0.0.1:8187。
- DIRECT_READBACK GitHub: config/app.php 支持 zh；lang/zh 内有翻译文件；是否全部页面中文待实机检查。
- DIRECT_READBACK GitHub: artisan app:init {name} {url}、app:user:create {first_name} {last_name} {email} {password} {role}；DatabaseSeeder 创建 admin role；User 模型 role_id / email_verified_at 可用。
- OWNER_REPORTED: 先前 Windows 11 Home / Docker Engine + Compose 可用，但可用 RAM 曾经偏低；本轮不得把先前状态当作新鲜直接读回。
- NOT VERIFIED: 本机容器是否启动、端口占用、可用内存、实际管理员登录、中文 UI、完整前后台及推荐扩展。
CURRENT_GATE: docs/G1_LOCAL_DOCKER_PREVIEW_GATE.md（最大终点为本机私有演示启动、测试管理账号及 UI 验收，不包含真实支付/付费扩展）
CRITICAL_CONSTRAINTS: 速度与可用 UI 优先；仅本机 127.0.0.1；仅项目自己的目录/Compose；不更动 Docker Desktop 全局配置、VPN/VPS、现存其他项目、Stripe Live；不执行 Docker prune / down -v；不在公开 GitHub、日志或证据中保存密码；本机生成随机一次性管理员密码，仅在本机终端显示；禁止造假部署完成。
DEFAULT_EXECUTION_CHANNEL: Owner Windows 本机 Codex；Reviewer 不可直接控制 Owner Windows。
CURRENT_ROLLBACK_STATUS: 运行前无项目资源；试用中可用精确 docker compose -p paymenter_local_lab -f <owned-compose> stop 停止；不删除数据或卷。
UNRESOLVED: 主机当前运行状况、镜像拉取、容器初始化、中文显示/后台入口、登录功能和真实裂变能力未实测。
NEXT_STEP: Owner 本地 Codex 按 G1 执行；把非敏感执行证据提交到本项目，Reviewer fresh read-back 后决定 PASS/RETURN。
OWNER_ACTION_REQUIRED: 将 G1 Relay 粘贴到 Windows 本地 Codex；本项目不要求 Owner 手工执行多条命令。
EVIDENCE_POINTERS: docs/G1_LOCAL_DOCKER_PREVIEW_GATE.md；当前阶段无本机执行证据。
