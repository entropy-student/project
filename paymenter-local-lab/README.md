# Paymenter Local Lab
Stage: G1_PASS + G2A_SOURCE_CLI_PASS + G2B_VISUAL_UI_PENDING — 2026-10-17

本项目是在 Owner Windows 11 本机运行的 Paymenter Docker 私有试用实例，主要用于直观考察官网、用户控制台、管理员后台及商品/套餐能力。G1 的部署与登录已验收；G2A 的简体中文源码补丁也已应用并通过 Reviewer 的源码/CLI 范围验收。登录后的实际页面仍需 G2B 视觉检查。**不要重复运行 G1/G2A。**

## 已验收访问入口
- 前台： http://127.0.0.1:8187
- 后台： http://127.0.0.1:8187/admin
- 演示管理员登录邮箱： demo-admin@paymenter.local
- 演示密码只由 Owner 在本机保管，不提交 GitHub；不得用于公网或正式生产系统。
- 已应用简体中文本地化补丁：用户 zh / 管理端 zh_CN；实际后台登录后文字/二级页面尚未做 G2B 浏览器验收，不能称全站 100% 汉化。
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
下一步 [G2B 实际界面验收 Gate](docs/G2B_VISUAL_UI_ACCEPTANCE_GATE.md)：Owner 可从已登录页面提供后台概览、商品套餐、优惠券与用户区的非敏感截图，由 Reviewer 核查残留英文/繁体；此前浏览器自动化工具被要求停止，不得绕过。翻译补丁及仅项目文件回滚见 [G2A README](localization/g2a/README.md)。引入 Referrals、Stripe、公开访问仍需独立 Gate；正式状态见 [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)，证明见 [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md)。

历史 G1 Gate： [G1_LOCAL_DOCKER_PREVIEW_GATE.md](docs/G1_LOCAL_DOCKER_PREVIEW_GATE.md) 。
