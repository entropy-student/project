# G-CLOSEOUT-20261027

- OBJECTIVE：修复概览余额模块主题与文字对比度，完成本地前端阶段归档。
- MAX_ENDPOINT_THIS_ROUND：本地样式验收、脱敏可重建源码归档至 entropy-student/project:spw-api/、交接记录回读；保留本机运行与恢复材料。
- MANDATORY_REVIEW_STOP：本地修复与归档完成后停止，线上部署/渠道接入/真实调用/支付均 DEFERRED_NOT_PASS。
- TARGET_AND_SCOPE：source/web/src/styles/spw-workbench-overview.css、相关验证与项目文档；GitHub 仅新增 spw-api/ 及根 README 的导航行，不覆盖既有 saas-system/。
- APPLICABLE_CRITICAL_CONSTRAINTS：不改金额计算、认证、权限、表单、计费、转发、数据库、后端镜像；不上公网；不删除任何本地项目、数据、镜像或凭据；不上传 .env、凭据、Cookie、数据库、业务日志、真实用户资料或敏感备份。
- PREFLIGHT：源码根 new-api/source，HEAD=7d8b91268dab69d7150f345c448b5e250163146a；已有前端改动属此前已部署 SPW 方案，不复位/覆盖。运行前端 image=99157728203b5adfe00d8e1b3a6b65287d27c5fcdbcea805aec1548646857fb6；官方后端固定 abf1f675efa1847b90c049c03766e2daaf62a78998aae3625cf34b6a045b1b97；仅 127.0.0.1:3000/3001。项目库主分支无 spw-api 目录；SaaS Lab 为另一项目，保持原状。
- REQUIRED_EVIDENCE：主题明暗/预设变换与文字对比度浏览器证据、相关回归、类型/构建/代理、运行镜像 ID、归档清单与摘要、精确上游基线重建校验、GitHub 提交与回读。
- ACCEPTANCE_CRITERIA：余额模块背景跟随主题，正文及状态文案对比度至少 4.5:1；原金额与状态/钱包入口行为保持；小屏不溢出；归档无 Secret，能还原所有前端改动；延期事项清晰。
- ROLLBACK_STATUS_OR_PLAN：本轮前端镜像 pre-closeout-20261027，样式/Compose/镜像 ID 位于 backups/pre-closeout-20261027；失败时仅恢复前端，禁止以数据库恢复回退样式。
- OWNER_ONLY_ACTIONS：本轮已授权公开项目库中的非敏感归档；生产启用、支付、账号权限和 Secret 生命周期均未授权。
- REVIEWER_TO_EXECUTOR_RELAY：仅使用本 Gate、目标 CSS、现有主题变量、overview 组件与本轮证据。移除固定深色和低对比状态组合，不增加组件或依赖。先验证，再部署精确前端，再整理归档。
- EXECUTOR_TO_REVIEWER_RELAY：提交真实结果、剩余限制、回滚与归档清单，不以自报 PASS 替代运行/回读证据。

治理来源：GitHub canonical VPS Project Governance v0.2.7。已扫描全部专项；11A/B/C/D/E/F 按备份、本机部署、浏览器、公开归档及延期事项边界加载，11G 未命中。没有远端服务器或共享基础设施修改。
