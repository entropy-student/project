# Paymenter Local Lab
Stage: G1_PASS_LOCAL_PREVIEW — 2026-10-17

本项目是在 Owner Windows 11 本机运行的 Paymenter Docker 私有试用实例，主要用于直观考察官网、用户控制台、管理员后台及商品/套餐能力。G1 的启动、登录、界面检查已经执行并通过 Reviewer 验收；**不要重复运行 G1 作为下一步**。

## 已验收访问入口
- 前台： http://127.0.0.1:8187
- 后台： http://127.0.0.1:8187/admin
- 演示管理员登录邮箱： demo-admin@paymenter.local
- 演示密码只由 Owner 在本机保管，不提交 GitHub；不得用于公网或正式生产系统。
- 默认 zh；用户/前台部分中文（主要为繁体），后台仍部分英文。
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
Owner 直接浏览现有前台/后台，判断系统是否符合目标。要引入 Referrals、Stripe、中文完善、公开访问等再另开有界 Gate；正式执行状态见 [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)，证明见 [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md)。

历史 G1 Gate： [G1_LOCAL_DOCKER_PREVIEW_GATE.md](docs/G1_LOCAL_DOCKER_PREVIEW_GATE.md) 。
