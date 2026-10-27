# SPW API — REVIEWER_HANDOFF

UPDATED=2026-10-27
GOVERNANCE=entropy-student/spike.skill@main:vps-project-governance/VNEXT.md v0.2.7
CANONICAL_PROJECT=entropy-student/project:spw-api/

## PROJECT_GOAL

基于 New API 为外部用户提供 API 服务；保留核心功能，仅定制 SPW API 前端与本机部署。选定 G「冰川折光」及 Workbench 页面结构。

## PROJECT_STAGE

LOCAL_FRONTEND_PASS / ARCHIVE_READBACK_PENDING / OWNER_REQUESTED_HOLD。本地前端阶段收尾，线上经营与支付未验收。

## SYSTEM_MAP

- 本机 Windows Docker Compose，项目 new-api-local；官方 Go/Gin 后端＋React 19/TypeScript/Rsbuild 前端，Nginx 静态服务与代理。
- 本机入口 http://localhost:3000，API /v1，后端诊断 http://localhost:3001；均仅绑定 127.0.0.1。无公网域名、TLS 或 VPS 部署。
- 上游源码 v1.0.0-rc.46，commit `7d8b91268dab69d7150f345c448b5e250163146a`；官方后端 digest `sha256:abf1f675efa1847b90c049c03766e2daaf62a78998aae3625cf34b6a045b1b97`。
- 独立前端镜像 spw-api-frontend:glacier。最终镜像 ID 与源码摘要见 Evidence，不以可变 tag 作为唯一身份。
- SQLite/持久数据在本机 data/，日志 logs/；.env 保存会话密钥，credentials.txt 与 verification/preview-user-credentials.json 为受限本机凭据文件。仅记录位置，不归档内容；无 DB、Cookie、密码或 .env 上传。
- 原认证、角色权限、配额、计费与网关转发继续由官方后端负责。普通用户验证无管理员菜单；此前接口负面授权已验证。
- 无新增 worker、scheduler、自动化任务或对外资源，无共享基础设施变更。

## CURRENT_ACCEPTED_STATE

- 已完成品牌、冰川首页、控制台导航、概览、密钥、日志、模型广场、钱包、账户和共用管理外壳的前端改造。
- 本轮只修改概览余额 CSS：跟随现有主题、提高正文与状态文字对比度、淡化水印，钱包按钮使用高对比主题变量。金额、查询、状态判断及跳转不变。
- 普通测试用户真实登录验证；10 种预设×明暗 20 组颜色检查最低文字对比度 11.63:1；1440px 明暗截图和 320px 无溢出检查通过。
- 本轮 16 项概览/导航回归、类型检查、格式检查、生产构建及代理 13/13 通过。前一轮 201 项回归为历史证据，不冒充本轮新增测试。
- 四个新增样式的上轮检查和本轮相关检查可追溯；本轮静态样式检查无 FAIL/WARN，有两项非阻断间距建议。没有顺手重排其它页面。

## CURRENT_GATE

G-CLOSEOUT-20261027；本地修复已通过，待 GitHub 归档回读后结束。见 docs/GATE_CLOSEOUT_20261027.md。

## CRITICAL_CONSTRAINTS

核心认证、权限、计费、精度、转发、表单和数据不变；不升级后端；不启用真实支付、上游调用或公网；不删除本机源码、数据、凭据、镜像或恢复材料。现有版权、AGPL/NOTICE 与归属保留。排行榜/文档/关于仅隐藏导航，原路由保留；版本更新只在管理员维护页展示。

## DEFAULT_EXECUTION_CHANNEL

本地项目操作使用 PowerShell / Docker / 已安装 Node 工具链；构建使用固定 Bun 镜像与 frozen lock。GitHub 使用已连接插件；读取或写入失败按 Owner 规则停止，不改用浏览器。UI 验证使用 CUA，避免高频整页刷新触发原认证限流。

## CURRENT_ROLLBACK_STATUS

已保留本轮前镜像 `spw-api-frontend:pre-closeout-20261027` 与 backups/pre-closeout-20261027 中的原 CSS、Compose、镜像 ID；原运行成功镜像与后端/数据兼容。仅前端变化时，在原部署目录将备份镜像 tag 为 glacier，再执行 `docker compose -f compose.yaml up -d --no-deps --no-build --pull never --wait frontend`。不覆盖数据库。

源码重建通过固定上游＋全部改动文件覆盖层和 SOURCE_MANIFEST.json；本机验证使用同一上游 Git 对象在新目录重建并逐文件校验。归档不等于数据库或凭据灾备。原本机恢复材料保留，未验证异机数据恢复，不宣称灾备 PASS。

## UNRESOLVED

- DEFERRED_NOT_PASS：公网部署、域名/TLS、可信代理与真实 IP、生产备份/监控/容量、安全配置。
- DEFERRED_NOT_PASS：真实上游渠道、流式 SSE/WS 端到端、模型调用、实际计费及扣费对账。
- DEFERRED_NOT_PASS：支付商户资格、支付配置、TEST Checkout、签名回调、订单/额度入账、幂等/重放、退款和对账。未来先测试再单独授权真实交易。
- 本地无真实模型，模型广场为空；卡片及价格逻辑已有组件回归，不能当作在线业务验收。
- 预先存在的全仓 lint 遗留问题、图片事件与自定义页脚 HTML warning 不在本轮样式范围。

## NEXT_STEP

按 Owner 意愿暂时停止功能开发，保留本机可预览状态。以后恢复时先读取本 Handoff、最新 Evidence、SOURCE_MANIFEST 与实际运行状态，再为线上部署或支付建立独立 Gate。

## OWNER_ACTION_REQUIRED

NONE。本轮不需要新增账号、支付、服务器或凭据操作。

## EVIDENCE_POINTERS

EXECUTION_EVIDENCE.md；docs/GATE_CLOSEOUT_20261027.md；docs/RECONSTRUCTION.md；docs/DESIGN.md；evidence/closeout-contrast-report.json；evidence/closeout-summary.json；SOURCE_MANIFEST.json；evidence/closeout-balance-light.png / dark.png / mobile.png。本机原始报告在 verification/。
