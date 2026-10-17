# SaaS System Lab｜通用 SaaS 系统实验

> 当前状态：**G0 项目文档初始化已通过 GitHub 回读／G1 Velobase 只读预检为下一执行 Gate**。无 SaaS 候选的本机安装或生产部署已验收。
> 项目仓库：`entropy-student/project` → `saas-system/`。唯一动态状态：[REVIEWER_HANDOFF](./REVIEWER_HANDOFF.md)。

## 目标

寻找一套能反复换产品、尽快实际使用的**开源 SaaS 应用模板**，而不是商城、ERP、PaaS 或纯推广工具。优先有公开营销页、用户注册/登录、用户 Dashboard、真正的平台管理员后台、Stripe 测试收款/订阅基础、可复用的客户邀请裂变；奖励可用现金佣金、使用额度、积分或会员时长实现。部署形式不设 Docker 硬门槛，可使用云平台部署、本机运行、VPS 原生服务或 Compose，以**最少改造可靠打开并使用**为原则。

这是**串行验证项目**，不是同时投产三个 SaaS，也不在该项目里搬移已关闭的 Paymenter 或修改已有产品/支付项目。

## 验证顺序与入口

| 次序 | 项目及开源源码 | 为什么先/后 | 起始状态 |
| --- | --- | --- | --- |
| 1 | [Velobase Harness](https://github.com/velobase/velobase-harness) | 已有免费 Affiliate、Stripe、额度与全栈演示；风险是部分退款、返佣可靠性、固定规则和资源 | **G1：只读预检待执行** |
| 2 | [Open SaaS](https://github.com/wasp-lang/open-saas) | Stripe、后台及长期复用较明确；缺免费现成佣金裂变，可评估接入 | **未启动** |
| 3 | [Wave](https://github.com/thedevdojo/wave) | Laravel/Filament 后台及订阅比较完整；缺免费裂变和官方全栈 Compose | **未启动** |

实验不可跳序：每款都先只读预检 → 私有演示 Gate → 功能/风险审核 → Reviewer 结论；上一款出阶段性结论后才进入下一款。Owner 已同意验证三项的方向，**不代表授权任意安装环境、对外发布或真实付费**。

## 固定验收问题

1. 是否能在可承受的本地/云环境打开**公开前台、用户中心和平台管理员后台**？分别提供页面证据，禁止把静态页面或团队管理冒充超管后台。
2. Stripe 是否存在**免费开源实现**？验证 TEST Checkout → 签名 Webhook → 本地订单 → 订阅与权限；退款、部分退款、事件重放分开测试。
3. 客户邀请链路是否免费已有：**专属链接 → 注册关系 → 有效付款 → 推荐奖励 → 退款撤销 → 重试/对账**？现金打款与积分/会员发放单独判断。
4. 不采购收费插件的情况下，必须开发或集成哪些功能？改造工作量、后续运维成本与授权约束分别记录。
5. 安装、升级、停用、恢复是否项目隔离，资源是否可承受？不影响已有 WordPress、Docker、网络和支付项目。

## 文档入口

- [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)：**唯一当前状态**及下一步。
- [docs/SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)：三候选对照、依次验证及决策规则。
- [docs/G1_VELOBASE_READONLY_GATE.md](./docs/G1_VELOBASE_READONLY_GATE.md)：**唯一当前 G1 只读执行 Gate**。
- [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md)：追加制执行事实。

项目管理遵循 [VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)。本项目不保存账户密码、API Secret、Webhook 密钥、真实客户资料、真实交易流水或浏览器 Cookie。
