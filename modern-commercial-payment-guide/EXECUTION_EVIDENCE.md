# P2 独立重写｜执行证据（仅本 Gate）

## 记录身份

- **AUTHORIZED_GATE：** `MCPG-P2-CHAPTER1-INDEPENDENT-REWRITE-20261016`
- **EXECUTOR_RESULT：** `PASS_CANDIDATE`，**强制停止在 Reviewer；非 PASS**。
- **记录日期：** 2026-10-16。
- **输入权威：** [REVIEWER_HANDOFF.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/REVIEWER_HANDOFF.md)、[P2_REWRITE_GATE.md](https://github.com/entropy-student/project/blob/main/modern-commercial-payment-guide/docs/P2_REWRITE_GATE.md)；只读取冻结结构与现行 Gate。**没有读取旧 P2 具体稿件**。
- **资料边界：** 仅公共官方业务/产品/费率页面；不读取任何支付账户、资金、秘钥、私密客户数据或生产系统。
- **原主线基线：** `main` 在本轮创建隔离分支时为 `751d4ec9b3a5a7dc08fd6e4b0b62f5e0121dd5e9`（GitHub ref DIRECT_READBACK）。
- **隔离分支：** `mcp-p2-independent-rewrite-20261016`；只在 `modern-commercial-payment-guide/` 项目目录创建新文件，未触碰 main，也未编辑 Reviewer Handoff / P1 / P2 旧稿 / Gate。

## 实际交付

1. **候选正文：** [docs/P2_REWRITE_CANDIDATE.md](./docs/P2_REWRITE_CANDIDATE.md)，含五大判断步骤、案例、金额估算、适用边界、17 组官方来源标识（含合并引用）。
2. **执行证据：** 本文件 `EXECUTION_EVIDENCE.md`，记录本次首轮候选交付；后续更正应追加说明，不隐性覆盖历史事实。

**候选文件写入：** GitHub create_file 返回 Commit `d42c5a72005477359f410338c0dae86bafa52339`；随后在同一分支使用 GitHub fetch_file **DIRECT_READBACK**：

- 候选 Blob SHA：`17204626fe91441b1f41dc425a8a23aabb51ec03`
- 正文长度：11,290 字符（JavaScript length，含 Markdown 字符，不等于汉字字数）
- GitHub 文件：`https://github.com/entropy-student/project/blob/mcp-p2-independent-rewrite-20261016/modern-commercial-payment-guide/docs/P2_REWRITE_CANDIDATE.md`
- 只读结构比对：5 个冻结二级问题标题和 9 个对应编号小节均匹配；两个场景案例、29 美元金额三行以及官方链接均存在。
- **核验类型说明：** 文档存在、标题、金额数字和链接数量属于 `DIRECT_READBACK`；写作质量与决策价值留给 Reviewer；未做支付行为验证。

## 冻结问题覆盖矩阵（仅第①板块）

| 冻结三级 | 候选稿位置 | 可核验的实质内容 |
|---|---|---|
| 1.1 顾客市场、商品和交易模式如何转为需求 | 1.1 | 六项经营事实→准入、方式、交易和资金终点；29 美元业务描述 |
| 1.2 硬条件/软条件 | 1.2 | 一票否决 vs 成本与效率优化；不以低费率替代准入 |
| 2.1 直接、平台、MoR | 2.1 | 三种经营安排的适用与代价；MoR 与平台卖家合同边界 |
| 2.2 付款方式、服务商、到账账户 | 2.2 | 四类角色分离；Wise/WorldFirst 账户不能代替商户资格 |
| 3.1 主体、地区、商品筛选 | 3.1 | 五道否决门槛；大陆商户与 Stripe/PayPal 条件判定 |
| 3.2 收付结算提现退款闭环 | 3.2 | 资金链与证据表；大陆个人数字品／大陆企业跨境实物场景 |
| 4.1 按订单比较全费用/净额 | 4.1 | 29 美元订单三种**不同准入条件的**示范；最低提现与 35 美元电汇固定费摊销 |
| 4.2 覆盖、效率、停用风险 | 4.2 | 四项经营指标与不同阶段权重；余额不等于实际可用现金 |
| 5.1 按硬条件、优先级选择主备 | 5.1 | 四轮法、备用独立性、重新评估触发条件、五句话决策模板 |

**覆盖自检：** 5/5 二级、9/9 三级均有独立判断方法及限制；**不是 Reviewer 质量 PASS**。

## 官方事实与公开资料核验

核验日期均为 **2026-10-16**；公开信息随地区、产品、商户条件变化。候选文末 `[S01]–[S17]` 有完整 URL 与适用边界。关键事实点：

| 官方来源 | 核验的关键主张 | 本轮采用边界 |
|---|---|---|
| [Stripe Global](https://stripe.com/global)；[Stripe 限制业务](https://stripe.com/legal/restricted-businesses) | 官方全球地区名单有香港、没有中国大陆 Stripe 一般商户开户地区；业务种类可能受限制 | 不能从香港银行账号推导大陆主体可开香港 Stripe |
| [PayPal C2 商家费率](https://www.paypal.com/c2/business/paypal-business-fees?locale.x=zh_C2)；[中国区提现帮助](https://www.paypal.com/c2/cshelp/article/how-do-i-withdraw-funds-from-my-paypal-account-help394) | 中国大陆国际交易 4.40% + USD 固定费 0.30；所列大陆美元电汇 35 美元/次，最低额 150 美元 | 不能推广到 PayPal 所有市场、商品、账户及其他人民币提现产品 |
| [Shopify 中国版](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china)；[资格](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china/requirements)；[付款方式](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china/payment-methods) | 大陆企业跨境商家受邀早期体验；WorldFirst 验证必需；不支持中国大陆本地销售 | 不是大陆个人可用 Stripe 的证据；也不是所有大陆企业默认获邀 |
| [WorldFirst 店铺](https://www.worldfirst.com.cn/content/articles/b2c_portal/sstphx7u)；[授权](https://www.worldfirst.com.cn/content/articles/b2c_portal/_yuod5se) | 站点的支付服务商选择与后续收款账户授权为不同环节 | WorldFirst 账户不代替支付服务商的受理和准入 |
| [Paddle MoR](https://www.paddle.com/help/sell/tax/how-paddle-handles-vat-on-your-behalf)；[准入商品](https://www.paddle.com/help/start/intro-to-paddle/what-am-i-not-allowed-to-sell-on-paddle)；[定价](https://www.paddle.com/pricing) | Paddle 为软件等适用业务担当 MoR；排除实体商品/纯人工服务；公布标准 5% + 0.50 USD | MoR 对其销售的间接税职责不自动免除卖家本地税务 |
| [Lemon Squeezy 支持](https://docs.lemonsqueezy.com/help/getting-started/supported-countries)；[提现](https://docs.lemonsqueezy.com/help/getting-started/getting-paid) | 公告银行提现名单不含中国大陆，PayPal 路线另有覆盖与审核要求 | 对任一个人 PayPal 提现能力不作未经审核的保证 |
| [Stripe HK 定价](https://stripe.com/en-hk/pricing)；[Paddle 定价](https://www.paddle.com/pricing) | USD 结算的 Stripe HK 银行卡费、国际卡附加费，及 Paddle 标准 MoR 费 | 三种 $29 比较**主体不相同**；数字只是费率结构示范 |
| [PayPal 风险预留](https://www.paypal.com/us/cshelp/article/why-is-my-money-being-held-in-reserve-help392)；[Paddle 卖家结算](https://www.paddle.com/help/manage/get-paid/when-and-how-do-i-get-paid) | 官方说明存在风险预留机制与卖家结算门槛 | PayPal 预留金示例来自美国帮助中心，不外推大陆账户具体条件 |

### 金额静态验算

- PayPal CN 跨境 USD 收款：`29-(29×0.044+0.30)=27.424` → **$27.42**。
- 香港 Stripe USD 结算、且该交易适用国际卡费、无换汇：`29-(29×0.034+0.30+29×0.005)=27.569` → **$27.57**。
- Paddle 标准价：`29-(29×0.05+0.50)=27.05` → **$27.05**。
- PayPal 所列大陆美元电汇固定费摊销：每次 35 美元，10 笔每笔 3.50 美元；100 笔每笔 0.35 美元（假定这批订单仅提现一次，且达最低额度）。此摊销不等于每笔即时真实银行到款。
- 未包含税、退款/争议、平台佣金、汇兑、银行中转及履约成本，不可把此数字直接称作利润。

## 未验证项与异常

- **UNKNOWN / 个别账户准入：** 大陆自然人就具体数字商品注册、开通 PayPal 商业功能或 MoR 店铺是否通过审核，未以账户控制面证明。
- **UNKNOWN / 银行结算闭环：** 指定用户账户与同名/同主体银行、WorldFirst 或 PayPal 的实际收款路径没有真实支付验证。
- **UNKNOWN / 动态成本与收益：** 没有核实个别定制报价、即时汇率、商品实际税款、实际结账成功率、未来拒付率或资金冻结概率。
- **官方文档差异：** Shopify [通用中国商家支付说明](https://help.shopify.com/en/manual/intro-to-shopify/initial-setup/sell-in-china/set_up_payments)仍包含大陆 Shopify Payments 不可用的概述，与中国版 [具体早期体验专页](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china)的受邀产品形成表述差异。候选稿仅按产品专页描述**例外的受邀资格**，不泛化为公开可用；Reviewer 可重点复核。
- **未实施：** 无真实账户授权、支付测试、生产写入、HTML、P3 或 P4。
- **主观判断留 Reviewer：** “能帮助商家决策”“不过度百科化”属于质量评审，本证据没有自判 PASS。

## 变更与回滚

- **ACTUAL_CHANGES：** 新增 `modern-commercial-payment-guide/docs/P2_REWRITE_CANDIDATE.md` 和本 `modern-commercial-payment-guide/EXECUTION_EVIDENCE.md`；隔离分支，不修改原 `main`。
- **ROLLBACK_EFFECT：** 如 Reviewer RETURN，候选文档可在分支撤回或关闭 PR；原 P1、旧 P2 历史文件及 7/29/42 冻结结构不受本轮影响。
- **STOP_AT_REVIEWER：** `PASS_CANDIDATE`。Reviewer 审查方法论可用性、事实适用条件、29 美元比较可比性与是否回到百科堆砌；没有跨 Gate 权限。
