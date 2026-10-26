# Minshop Cloudflare Store — REVIEWER_HANDOFF

> UPDATED=2026-10-26  
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL  
> CANONICAL_PROJECT=`entropy-student/project@main:minshop-cloudflare-store/`（以合并并完成 main 回读为准）  
> 本文件是本项目 **唯一当前状态面板**；README 不是第二套动态状态。

## PROJECT_GOAL
**本项目在网站测试时优先使用。** 在无 VPS、电脑无需常开的前提下，以 Cloudflare 免费额度为目标，最小化改动 Minshop 前端/商品/Stripe 配置，优先验收「展示→支付→签名 Webhook→订单→数字文件授权下载→退款后撤权」；通过有界测试后再决定是否正式使用。

## PROJECT_STAGE
`G0_PASS_DOCUMENTATION_ONLY / RUNTIME_NOT_DEPLOYED / STRIPE_NOT_TESTED / G1_READONLY_NOT_EXECUTED`。当前属于文档研究与项目库建档；不是商店可用证明。

## SYSTEM_MAP
- **源码**：上游 `ddyy/minshop`，MIT；原生 Astro SSR + Cloudflare Workers。
- **公开前台/后台**：Worker 部署后以 `/`、`/admin/setup`、`/admin` 服务；当前项目没有实测 URL 或部署实例。
- **数据**：一个 D1（商品/订单/设置）；两个 R2（公开商品图片与私有数字文件，`FILES` 必须私有）。
- **支付**：Stripe Checkout + `/api/webhook/stripe`；默认只准测试模式，Webhook 签名验证、订单/履约幂等及退款负面测试待运行。
- **密钥**：Worker Secret `AUTH_SECRET`、`SECRETS_KEK`，Stripe Secret/Webhook 密钥在受保护的运行配置内；GitHub 不存任何密钥值。
- **邮件**：可选 Resend HTTPS 邮件 API；Cloudflare 原生邮件功能需另行核查收费。
- **端口/域名**：未部署，`workers.dev` / 自有域名均待实际确认；不使用本地常开端口。
- **Docker/VPS/Shared Infra**：无目标主机或现存服务，禁止修改既有共享 VPS、网络、个人站点与支付项目。
- **测试/恢复**：上游有测试命令；本项目尚未执行。D1/R2 备份恢复及加密密钥灾备方案尚未验证。

## CURRENT_ACCEPTED_STATE
- **OWNER_DECISION**：选择 Minshop 为网站前期测试的优先项目；不意味着已批准真实收费或产生付费资源。
- **DIRECT_READBACK**：已查阅上游 README、`CUSTOMIZING.md`、Cloudflare 官方 Worker/D1/R2 额度说明；记录见 [研究报告](./docs/FREE_DEPLOYMENT_AND_CUSTOMIZATION.md)。项目登记 PR [#172](https://github.com/entropy-student/project/pull/172) 已合并（`cf6996f7ab4d0c8de62f458f41f0f7f635acd240`）；Reviewer 已在 GitHub `main` 重新读取 5 份项目文档及中英文根目录导航，7/7 路径存在，G0 仅为 **文档归档 PASS**，不包含部署/支付验收。
- **RUNTIME_TRUTH**：本项目 Cloudflare 账户状态、资源数量、实际线上网站、Stripe 事件、订单与交付全部 `UNKNOWN/NOT_DEPLOYED_BY_THIS_ROUND`。不能把上游演示站当成用户自己的实例。
- **FREE_TIER**：免费账户 D1 最多 10 个数据库；一个独立店通常使用一个 D1，**约 10 店只是理论结构上限**，还受整个账户共享请求、CPU、D1、R2 容量限制。规划先 1 店验证，再考虑 3–5 店；非运行承诺。

## CURRENT_GATE
`G1_MINSHOP_CLOUDFLARE_STRIPE_READONLY_PREFLIGHT_20261026` — [只读预检 Gate](./docs/G1_CLOUDFLARE_STRIPE_READONLY_PREFLIGHT_GATE.md)。当前 **NOT_EXECUTED**；仅核对目标 Cloudflare/Stripe TEST 可用性、免费额度、资源边界、密钥保管与回滚，不创建资源、不收款。G1 的可接受结果只能是只读报告；任何公开部署、Stripe 配置变更或支付测试必须单独授权后开启后续 Gate。

## CRITICAL_CONSTRAINTS
1. **核心话**：本项目在网站测试时优先使用。
2. 初期目标为 Cloudflare 免费套餐；禁止未经 Owner 确认的升级、超额收费、商业正式上线、真实收款或退款。
3. 先原版验证，后换皮；不得因修改美观而破坏 Stripe、订单、权限与库存。
4. `FILES` 私有桶绝不开放公网；按测试环境设置非生产密钥；日志和 Git 不记录 Secret 或真实交易/客户原文。
5. 真实 Provider 成功、Webhook 签名、当地订单 paid、文件发货、退款撤权、重复事件幂等为独立证据，不得互相替代。
6. 既有服务器、本机 Docker、其他网站、项目目录、Cloudflare 资源不属于本 Gate 的修改范围。
7. 任何基于官网文档的功能/免费额度为 `DOCUMENTED_NOT_LIVE_VERIFIED`；实际额度和稳定性需部署前、部署后新鲜核实。

## DEFAULT_EXECUTION_CHANNEL
`GITHUB_READ_ONLY_DISCOVERY`（G1）；后续云端部署必须以 Owner 授权的 Cloudflare 账户/安全执行通道为准，`UNKNOWN` 不猜。

## CURRENT_ROLLBACK_STATUS
`DOCUMENTATION_GIT_REVERT_ONLY`；无本轮新建 Worker、D1、R2、Stripe 应用或真实资金；未来部署前另行确定 D1/R2 备份、Secret 恢复和停用方案。

## UNRESOLVED
- Cloudflare 免费账户现有 D1 / Worker / R2 资源余额与 R2 订阅状态：`UNKNOWN`。
- Stripe Test 账号和所需能力是否就绪：`UNKNOWN`；不可推定 Live 资格。
- 原版部署耗时、Worker 10ms CPU 是否超限、文件上传/下载可靠性：`UNVERIFIED`。
- 单站多站并发容量、R2 文件大小和增长、邮件供应商用量：`UNVERIFIED`。
- 部分退款撤权规则、重复 Webhook 不重复交付、恢复备份：`UNVERIFIED`。
- 对于卡密库存/API 额度/动态 AI 交付，原版不是现成闭环：`REQUIRES_SEPARATE_DESIGN`。

## NEXT_STEP
运行 G1 只读预检并由 Reviewer 核验报告；达到进入条件后另行设计/授权 G2 测试部署，先用示例数字文件与 Stripe TEST 做端到端 Canary，负面测试完整后才换皮、考虑真实销售。

## OWNER_ACTION_REQUIRED
`NONE`（目前仅文档登记）。进入 G1/G2 时，由 Owner 授权对应 Cloudflare/Stripe 测试环境及费用边界；无需将任何 Secret 发送到聊天或 GitHub。

## EVIDENCE_POINTERS
[项目执行证据索引](./EXECUTION_EVIDENCE.md) · [免费部署报告](./docs/FREE_DEPLOYMENT_AND_CUSTOMIZATION.md) · [G1 Gate](./docs/G1_CLOUDFLARE_STRIPE_READONLY_PREFLIGHT_GATE.md)。
