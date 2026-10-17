# Paymenter Local Lab
Stage: G1_PASS + G2A_SOURCE_CLI_PASS + G2B_R1_SOURCE_CLI_PASS + G2C_LOCALE_AUDIT_PASS + G2B_VISUAL_PARTIAL — 2026-10-17

本项目是在 Owner Windows 11 本机运行的 Paymenter Docker 私有试用实例，主要用于直观考察官网、用户控制台、管理员后台及商品/套餐能力。G1 的部署与登录已验收；G2A 简体汉化、G2B-R1 少量显示文字修复，以及 G2C 保留原生多语言/修复审计详情缺参均已在本机应用并通过各自范围 Reviewer 审核。登录后的多语言/二级界面仍需 G2B 视觉核对，**不要重复运行 G1/G2A/R1/G2C，不需要重新部署。**

## 已验收访问入口
- 前台： http://127.0.0.1:8187
- 后台： http://127.0.0.1:8187/admin
- 演示管理员登录邮箱： demo-admin@paymenter.local
- 演示密码只由 Owner 在本机保管，不提交 GitHub；不得用于公网或正式生产系统。
- 已应用 G2A、R1 与 G2C：默认 zh 为简体中文，后台对应 zh_CN 翻译词库，用户手动切换 en/fi 时不再强制中文。已见前台芬兰语菜单 Koti/Kauppa，但保存在数据库中的中文商品/品牌仍显示原文，这是预期。R1 后完整用户/管理员 UI 未通过最终 G2B 视觉验收，不能称全站 100% 汉化。
- 虚构演示套餐已经创建：无订单、无发票、无真实收款或网关。
- 官方源码： https://github.com/Paymenter/Paymenter ，Docker 说明： https://paymenter.org/docs/installation/docker

## 真实本机资源
- Compose 项目： paymenter_local_lab
- 工作目录： %USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab
- 项目数据库命名卷： paymenter_local_lab_database
- 本机启动器： [START_PAYMENTER_LOCAL.ps1](START_PAYMENTER_LOCAL.ps1)（已随 PR #145 修正，但不要因浏览界面需要重复部署）
- 不能使用 broad docker prune/down -v 删除。
- 按需暂停，仅可精确 stop 本项目 Compose，保留数据。

## 后续
下一步 [G2B 实际界面验收 Gate](docs/G2B_VISUAL_UI_ACCEPTANCE_GATE.md)：Owner 可从已登录页面提供 **G2C 后管理员中文/英语导航、用户控制台、商品编辑/套餐** 四类非敏感截图供 Reviewer 核查；此前浏览器自动化工具被要求停止，不得绕过。已验收的 G2A 补丁见 [G2A README](localization/g2a/README.md)，已验收的 R1 增量补丁与独立回滚见 [R1 README](localization/g2b-r1/README.md)，G2C 语言修复与回滚见 [G2C README](localization/g2c/README.md)。引入 Referrals、Stripe、公开访问仍需独立 Gate；正式状态见 [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)，证明见 [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md)。

历史 G1 Gate： [G1_LOCAL_DOCKER_PREVIEW_GATE.md](docs/G1_LOCAL_DOCKER_PREVIEW_GATE.md) 。
