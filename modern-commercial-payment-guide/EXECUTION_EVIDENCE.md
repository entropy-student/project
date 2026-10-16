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

---

# P2 修订第二轮｜对 Reviewer `RETURN_CONTENT_SYSTEMATICITY` 的返工证据

## 本轮权威与执行边界

- **AUTHORIZED_GATE：** `MCPG-P2-CHAPTER1-INDEPENDENT-REWRITE-20261016`（原 Gate 内的返工，不新增 Gate、不进入 P3）。
- **REVIEWER_RETURN：** [PR #132 评论 ID 6198541590](https://github.com/entropy-student/project/pull/132#issuecomment-6198541590)，`RETURN_CONTENT_SYSTEMATICITY`。本轮不是重审 P1；没有读取最初被 Owner 废弃的 P2。
- **PREFLIGHT_DIRECT_READBACK：** PR #132 仍 `open, draft=true, merged=false`；原分支 `mcp-p2-independent-rewrite-20261016`；此次改写前 head `a7f19031361e7e6327bee98b726a5a0c9c6a91fc`、候选文件 blob `17204626fe91441b1f41dc425a8a23aabb51ec03`、本证据文件 blob `5388fec8e0fce61a16708e73c24c12709b4a8704`。
- **ACTUAL_CHANGE 1：** 在既有 PR 分支替换 `docs/P2_REWRITE_CANDIDATE.md`，GitHub update_file 返回 commit `05eec1aa30271b236299f9ba879ff06313df8fd8` 和 blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7`。
- **DIRECT_READBACK 1：** 用 GitHub fetch_file 重新取得候选 `f8bb110f07ef654df2f5b4b9285540e89261b1f7`，正文 **19,986** 个 JS 字符；经标题文本检查 5/5 二级问题及 9/9 三级编号均存在（9 个小节）；官方 URL 25 个（含同源多次引用）。
- **ACTUAL_CHANGE 2：** 在本证据文件**末尾追加本轮证据**，不改写前轮历史结果；当前前轮 `PASS_CANDIDATE` 已经由 Reviewer 正式 `RETURN_CONTENT_SYSTEMATICITY` 否决，**不得将旧记录当作获批事实**。

## 六项 Reviewer 缺陷与实际整改对应

| 评论中的缺陷 | 第二轮实质改动 | 供 Reviewer 核查的位置 |
|---|---|---|
| 1. 没有完整经营关系模型 | 以订单为最小单位建立**经营主体/商品/买方/交易方式/销售方/店铺/资金终点**七维画像；再用“合同付款链”和“资金责任链”连接卡组织、收单商、平台、MoR 与最终受款账户 | §1.1、§2.1、§2.2 |
| 2. 仅停留在筛选、没有主备结论 | 两条完整条件化演练写明业务事实、模式、候选、NO/UNKNOWN、主选/备用及最小额外核验；未获准时明确不能宣称可上线 | §5.1 演练 A/B |
| 3. 不同主体报价被当作同条件比价 | 原香港 Stripe/Paddle/PayPal 改为“跨主体费率示范”单列；另设计**同一大陆主体/同一 $29 商品**的 PayPal 两类经批准产品对比，及**同一 Shopify 大陆企业**第三方 PSP vs 受邀中国版 Shopify Payments 的条件比较。将 MoR 划为同经营者但销售责任不同的评价，不把费率直接排行 | §4.1 三组区分 |
| 4. 未推演最终银行可得金额 | 将资金分四层：顾客支付、交易余额、可提现余额、银行入账；5/6/10/100 单美元提现批次明示最低 $150、每批 $35 影响；对中转行、入账行、实际换汇标 UNKNOWN | §3.2、§4.1 批次表 |
| 5. PayPal 费率合同适用范围漏写 | 明示 4.4% + $0.30 **仅适用于 PayPal中国跨境支付服务用户协议 + PayPal全球服务条款**的贝宝支付账户，**不适用于另一 PayPal支付服务用户协议**，另列经批准卡收款价而不泛化 | §3.1、§4.1、来源 S02 |
| 6. 分类不均衡 | 从商业模式而非厂商列表比较**大陆本地交易、跨境平台实物、跨境独立站实物、SaaS/MoR、外贸 B2B 发票** | §2.1、§5.1 演练及其他三类 |

## 第二轮官方公开资料复核

**官方页面核验日期：2026-10-16**。下列为本轮对修正最关键论断的逐项资料核对；完整 [S01]–[S15] 见候选正文末尾。此处只是公开规则核验，不是商户账户/合同/真实资金验证。

1. **PayPal CN 协议/费用：** [官方费率](https://www.paypal.com/c2/business/paypal-business-fees?locale.x=zh_C2)，页面明确限定两份中国跨境服务及全球条款，排除依另一贝宝支付服务协议开户账户；国际商业收款 4.40%+按币种固定费，USD $0.30；在线卡服务高级版国际 4.10%+$0.30，需申请/批准；对应企业 CN 银行美元电汇 $35/批次。
2. **PayPal 提现门槛：** [官方中国区提现帮助](https://www.paypal.com/c2/cshelp/article/how-do-i-withdraw-funds-from-my-paypal-account-help394)：大陆银行美元电汇最低 $150，通常 3–7 个工作日，可能延迟/被审核。
3. **Shopify 大陆企业资格：** [中国版产品](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china)及[资格/WorldFirst](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china/requirements)：受邀早期体验、大陆注册企业、跨境销售、WorldFirst 验证、不得用于大陆境内消费者销售。
4. **Shopify 外部费用叠加：** [第三方收单](https://help.shopify.com/en/manual/payments/third-party-providers)、[第三方交易费](https://help.shopify.com/en/manual/your-account/manage-billing/billing-charges/types-of-charges/third-party-charges/third-party-transaction-fees)、[Payments 卡费](https://help.shopify.com/en/manual/payments/shopify-payments/onboarding/cost-of-shopify-payments)：第三方支付成本与 Shopify 交易费可为两笔；中国版具体账户费率本轮 **UNKNOWN**。
5. **Paddle 品类/MoR/费与到账：** [限制品类](https://www.paddle.com/help/start/intro-to-paddle/what-am-i-not-allowed-to-sell-on-paddle)、[价目](https://www.paddle.com/pricing)、[结算](https://www.paddle.com/help/manage/get-paid/when-and-how-do-i-get-paid)、[税务定位](https://www.paddle.com/help/sell/tax/how-paddle-handles-vat-on-your-behalf)：主要软件、公开标准 5%+$0.50、月度结算与最低 $100；不是全部数字模板可受理。
6. **大陆与平台路径：** [支付宝网站支付产品](https://opendocs.alipay.com/open/270)、[商家主体](https://opendocs.alipay.com/b/07i07o)、[Amazon 全球收款](https://gs.amazon.cn/accs)：本地商户支付产品与跨境平台卖家资金出口应分类，不把平台卖家账户当独立站收银台。
7. **香港 Stripe 只做不同主体示范：** [Stripe 香港标准价格](https://stripe.com/en-hk/pricing) 以及 [全球地区](https://stripe.com/global)。香港价格不能证明大陆独立商家开户。

## 静态数值复算 / 范围检查

设顾客支付 `G = $29.00`、条件为符合 S02 的 CN PayPal 商户国际 USD 交易；示例每笔交易手续费 `round_to_cents(29×4.4%+0.30)=$1.58`，交易后余额按每单 `$27.42` 计算。下表**只扣除公开可确定的交易费与同一路线每次提现 $35**，不承诺银行真的收到该数值。

| 订单数 N | 验证 `N×27.42` | 至少 $150？ | 验证 `N×27.42−35` |
|---:|---:|---|---:|
| 1 | $27.42 | 否 | 不可按此路线提现 |
| 5 | $137.10 | 否 | 不可按此路线提现 |
| 6 | $164.52 | 是 | $129.52 |
| 10 | $274.20 | 是 | $239.20 |
| 100 | $2,742.00 | 是 | $2,707.00 |

**账务限定：** 官网未在本轮验证每一笔真实交易的美分舍入方法；不同余额调整/预留会改变最低额判断。表中 $129.52 等是“扣两层已知费后**银行入账前**的估计额”，**最终银行实际净得和人民币实际可用额均为 UNKNOWN**；不能把前者宣称已确定的银行实收。对于软件 MoR，标准 $29 单笔约 $27.05 但相应 MoR 结算和收款费用仍需查合同。

## 仍属 UNKNOWN、边界和回滚

- **UNKNOWN：** 特定自然人可否获得哪一种 PayPal/数字平台商户产品；Paddle/Lemon 是否接受具体模板及个人；中国版 Shopify 是否向某个商家发出邀请；中国大陆第三方实际提供商、Shopify 中国店铺的确切叠加费、WorldFirst/银行/FX报价、提款审核与真实成交率。
- **声明限制：** 没有进行任何账户认证、生产支付、真实汇兑或提现；案例是**明确前提下的演练**；不触碰 P1、7/29/42 框架、最初被 Owner 废弃 P2、其他模块、HTML、管理规范或生产基础设施。
- **ROLLBACK：** 本次只有原 PR 分支内两份 Markdown 变化；旧候选版本仍在历史 commit `a7f19031361e7e6327bee98b726a5a0c9c6a91fc`，正文改稿在 `05eec1aa30271b236299f9ba879ff06313df8fd8`，可以由 Reviewer 决定继续修改或回撤；main 与 P1 均不因 PR 更新而改变。
- **EXECUTOR_RESULT：** `PASS_CANDIDATE`，**STOP_AT_REVIEWER**；本轮覆盖与公开材料、算术自检不能代替 Reviewer 的方法论和写作质量审核。

---

# P2 human-writing 单技能阅读实验｜2026-10-16

## 任务和权限
- **GATE_ID：** `MCPG-P2-HUMAN-WRITING-READABILITY-PILOT-20261016`。
- **EXECUTOR_RESULT：** `PASS_CANDIDATE`、`STOP_AT_REVIEWER`。仅为提交审核，不是内容 Reviewer PASS 或 Owner 阅读体验确认。
- **前置直接读回：** main 的 `modern-commercial-payment-guide/REVIEWER_HANDOFF.md` Blob `8b34ce70415265d1cb975129ba803f75c5944f4c`；当前 Gate Blob `84c2dcc220917911706fc7e97d730c88514c4720`。PR #132 创建样稿前为 `open=true, draft=true, merged=false`，head `17ea75adec7448a8bbe6387788b5bfe321ff68f6`（与 Gate 完全一致）。已审核候选正文 `docs/P2_REWRITE_CANDIDATE.md` Blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7`。
- **允许的原文：** 仅上述 P2 已审核版本 §4.1 第 130–172 行与 §5.1 演练 A 第 228–245 行，及官方 S02/S05；未引用被弃用 P2，未启动 P3。
- **唯一使用的 Skill：** [KKKKhazix/human-writing](https://github.com/KKKKhazix/human-writing) v1.1.0，主 `SKILL.md` Blob `76bbf86ef49504628e356555f4da7cc6cbac3b7c`，与 Gate 固定版本相符。实际依顺序读取 `references/forum-prose.md` Blob `8bbc5fc0e7dccc1a6fa13dd457166e7eded303d4`、`references/reality.md` Blob `844e9c9236826cf29de9ccd9c7248eb970a15e02`；**写完初稿后才读** `references/revision.md` Blob `2a884689c52b42a23df757ae7060b1fbaa50ae4f` 并修改。未使用第二个 Skill（包括 `copy-editing`）。

## 实际变更与直接证据
1. **仅新增** [`docs/P2_HUMAN_WRITING_SAMPLE.md`](./docs/P2_HUMAN_WRITING_SAMPLE.md)，写入 commit `fb9ce13905f30a71870b08114f887e1fc87c50b9`，Blob `b05dfdc45e03649927a25be0db0380f40a681ba6`；GitHub `fetch_file` 直接读回与写入全文完全相同。正文 **1470 个汉字**，包括附录、Markdown 和链接的全文长度为 **2566 个 JS 字符**；在 Gate 1200–2000 中文字范围。
2. **仅在本证据文件尾部追加**本节；上一轮所有结果与原始记录原封不动。
3. **官方规则核对（2026-10-16）：** [PayPal CN 商家费率 S02](https://www.paypal.com/c2/business/paypal-business-fees?locale.x=zh_C2) 页面注明 2025-06-18 最后更新，费率仅适用指定 `PayPal中国跨境支付服务用户协议` + `PayPal全球服务条款` 的 CN 账户，**不适用**按另一 `PayPal支付服务用户协议` 开户的账户；对应国际商业美元款 4.40% + USD 0.30；35 美元单次中国大陆电汇费出自**企业 PayPal 账户**费用表。 [PayPal CN 提现帮助 S05](https://www.paypal.com/c2/cshelp/article/how-do-i-withdraw-funds-from-my-paypal-account-help394) 为该美元电汇路线列出最低 USD 150、通常 3–7 工作日以及审核与银行限制。均非某具体账户获得批准的证据。

## 事实对应和数值复算

| 独立材料 | 原稿/官方对应 | 样稿对应 |
|---|---|---|
| 29 美元同一国际 USD 单、合同适用条件 | §4.1 + S02 | 起篇和账户限定 |
| 4.40% + 0.30，按美分 1.58 美元 | §4.1 + S02；`29×.044+.30=1.576` | 单笔费用计算 |
| 单笔费后约 USD 27.42 | §4.1 | 单笔余额 |
| 最低 USD 150；通常 3–7 工作日且受审核 | §4.1 + S05 | 五单提款疑问 |
| 5 单 USD 137.10 不达门槛，6 单 USD 164.52 达门槛 | §4.1；按单笔 27.42 计算 | 五、六单对比 |
| 对应企业账户 USD 35/批；6 单只扣该批费用后 USD 129.52 | §4.1 + S02；`164.52−35=129.52` | 六单电汇及费用 |
| 10 单费后 274.20、单次电汇后 239.20；100 单费后 2742、单次电汇后 2707 | §4.1；`10×27.42−35=239.20`，`100×27.42−35=2707` | 十单/百单 |
| 大陆自然人的商户/商品/提现资格仍 UNKNOWN，不能照搬企业费 | §5.1 演练 A；S02 条款差异 | 自然人单独核验 |
| 交易后余额、可提余额、银行实收各不相同 | §4.1 四层金额；S05 | 银行费用/汇率/税费 UNKNOWN |

- **算术自检：** 1.576 USD 按美分演算为费 1.58、单笔余 27.42；五单 137.10、六单 164.52、扣一次企业电汇费 129.52；十单 239.20，百单 2707；每单摊销 35/10=3.50、35/100=0.35。均仅为假设演算，**不等于** PayPal 真实逐笔舍入、账户批准、可即时提现或实际银行收到金额。汇兑、银行中转与入账费、税款、退单/退款、商家成本、商品及自然人资格仍 `UNKNOWN`。
- **阅读质量自检：** 有 9 组具体可追材料，先写 29 美元五单的用钱疑问，再算手续费、解释为什么差在最低额、发现六单过门槛与每批固定费用，最后给低单量或高单量的选择条件和读者具体核验动作。正文没有抽象五步法起篇、假造本人支付经历/对话/商家个案；来源与原稿映射留文末。句长、段落长短和金融判断可由 Reviewer 独立对照。
- **修订痕迹：** 首稿完成后加载 revision，删去无依据的“六个月内”说法改为“这一批订单”，并加强首段商品/交易仅为审核通过的设定及企业电汇的前提。人工检查正文无破折号、引导性冒号、翻案式固定句型、硬性商业黑话；实际阅读效果交 Reviewer。
- **范围与回滚：** 只新增一份阅读样稿、append-only 本证据。未修改已审核 P2 候选、冻结 7/29/42、P1、原 Gate/main、Reviewer Handoff、生产/账户/支付/Secret；未做 HTML 或启动第二 Skill。Reviewer 如 RETURN，可撤回样稿和本轮追加证据。**STOP_AT_REVIEWER**。

---

# P2 copy-editing 单技能独立编辑实验｜2026-10-16

## Gate、原始材料和 Skill 版本

- **GATE_ID：** `MCPG-P2-COPY-EDITING-READABILITY-PILOT-20261016`，`EXECUTOR_RESULT=PASS_CANDIDATE`，**`STOP_AT_REVIEWER=YES`**。结果并非 Reviewer 对第二稿的最终接受或实际完读率证据。
- **前置直接读取：** 主干 Gate `docs/P2_COPY_EDITING_EXPERIMENT_GATE.md` Blob `175af8960329b4b05dab6cd8c15fa7077d360f75`；主干 `REVIEWER_HANDOFF.md` Blob `8663123233ad444bb48b7dd52b0f2ecc43479f64`；[human-writing 评审正式评论](https://github.com/entropy-student/project/pull/132#issuecomment-6208144581)，结果第一实验执行 `PASS`、阅读吸引力 `PARTIAL`。
- **改稿前 PR #132：** `state=open`、`draft=true`、`merged=false`，head `d0f000e95554e530d3d52ce49acb85a0d1b4825e`（与 Gate 固定值匹配）；原 P2 正文 Blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7`；第一版 `P2_HUMAN_WRITING_SAMPLE.md` Blob `b05dfdc45e03649927a25be0db0380f40a681ba6`；此前 Evidence Blob `4cbc212684e30c52315cc180b731ba97c28ddea6`。
- **本轮唯一使用的编辑 Skill：** [coreyhaines31/marketingskills copy-editing](https://github.com/coreyhaines31/marketingskills/blob/main/skills/copy-editing/SKILL.md)，版本 `2.2.0`，主 `SKILL.md` Blob `e5fdc0e70e0a2b3d17c1f7761b00b6c51e1e0ac0`，**与 Gate 指定 SHA 完全相同**；真实读取 [references/checklist.md](https://github.com/coreyhaines31/marketingskills/blob/main/skills/copy-editing/references/checklist.md) Blob `1f33b2100a1d49db4858987e4b6bcbbd783d5b79`。无源版本漂移；**没有调用 human-writing 作为本次编辑 Skill，也没有调用任何其他写作 Skill**。
- **采用的编辑模式：** checklist 模式 B（原文已有完整清晰观点，保留事实、表达、论证线）。针对既有中文非营销科普稿，检查清晰度、声调一致、读者关心点、证据、具体性、顺读体验及诚实风险说明。Skill 原本用于营销文案，促销 CTA、FOMO、虚构证言、无依据保证或情绪刺激均**不适用且没有采用**。一轮定向编辑，不展开营销测试、专家评分或继续二次改稿。
- **公开来源实核：** [S02 PayPal CN 商家费率](https://www.paypal.com/c2/business/paypal-business-fees?locale.x=zh_C2) 2025-06-18 页面更新、2026-10-16 重新查看，适用 `PayPal中国跨境支付服务用户协议` + `PayPal全球服务条款` 的 CN 账户，排除按另一 `PayPal支付服务用户协议` 开立的账户；国际 CN 商业美元收款 4.40% + USD 0.30；`从企业PayPal账户提出余额` 对中国大陆银行电汇每笔 USD 35。[S05 中国大陆提现帮助](https://www.paypal.com/c2/cshelp/article/how-do-i-withdraw-funds-from-my-paypal-account-help394) 美元电汇最低 USD 150、一般 3–7 工作日、提现须经过审核及银行规则。均非具体账户成功获批或真实打款证据。

## 交付文件与四项以上编辑对照

- **ACTUAL_CHANGE 1：** 仅新增 [`docs/P2_COPY_EDITING_SAMPLE.md`](./docs/P2_COPY_EDITING_SAMPLE.md)，正文约 **1337 个汉字**，含 Markdown/链接的文件合计 2375 个 JS 字符。写入 Commit `0c5d018d39db0e2fe88b296dd651659b7d4e6d70`，Blob `9a4bdd2971ac1a4307e82582a3ae1d9ab413d3e5`，GitHub `fetch_file` 读回写入内容逐字一致。
- **ACTUAL_CHANGE 2：** 当前证据仅追加于 `EXECUTION_EVIDENCE.md` 末尾；历史记录不可覆盖。

| 第一版对应表达 | 第二版处理 | 编辑目的（保留事实） |
|---|---|---|
| 首段先写五单 145 USD，再说明无法提现；后文才出现六单 129.52 USD | 第一段直接显示六单总额 174、费后 164.52、扣一笔 35 后 129.52 和差额 44.48 | 先出现最有用的金融差异，立即解释它与经营资金的关系，非营销悬念 |
| 原文第7行长段连写双协议、企业身份、资格、产品差异与 35 USD 限制 | 一段短算例后独立限制段，事实不删除；35 USD 的企业账户限制再紧贴费额说明 | 限制仍可见，但不再阻断开头、且费率适用与提现定价分开 |
| 原文多段重复提示未获准、未到账、退款未知 | 在假设句一次声明获准；129.52 出现处集中解释未到账、银行费/汇率/税/余额调整和实际舍入未知；结尾注记核对条款 | 保留各项 UNKNOWN 又减少多次类似免责声明 |
| 原文五单到六单的两次乘法分占较多篇幅 | 五单 137.10 与六单 164.52 连在一个段落，强调是否跨越 150 美元提款额门槛 | 数值承载一项具体新的商家决定，降低同质计算感 |
| 原文十单、百单两次总额解释和另段重复固定费用摊薄 | 一段并列保留 10 单 274.20/239.20、100 单 2742/2707 与每单分摊 3.50/0.35 | 数字完整、节奏压缩，直接衔接低频与高频如何选择 |
| 原文尾段为四步核验清单及重复警告 | 先给最低必要的核验方法，再以单量、每批固定费和需要用钱的日期收束 | 保留行动性，避免结尾回到报告式复述 |

## 金融事实保留和算术校验

- **固定场景：** 符合特定 PayPal CN 双协议的中国大陆**企业**，已经按假设获得对应商品/国际 USD 商业交易收款及大陆银行美元电汇提现资格；单价 USD 29；批次内均成功，没有退款、拒付、风险预留、其他余额扣减。实际账户资格仍未知。
- **交易费：** `29×0.044 + 0.30 = 1.576`，示例逐单先按美分约 `1.58`，余额约 `27.42`；不冒充 PayPal 的实际舍入实现。
- **五、六单与提现门槛：** 五单扣交易费后 `137.1` 低于 USD 150；六单顾客共付 `174`，扣交易费后 `164.52` 达到门槛；**仅对应的企业电汇一次扣 USD 35** 后约 `129.52`；总已知费差 `44.48`。
- **十单/百单：** 十单交易费后 `274.2`，扣一次电汇后 `239.2`，电汇费均摊 `3.5`；百单顾客合计付 USD 2900，交易费后 `2742`，扣一次电汇后 `2707`，均摊 `0.35`。
- **静态数值复算：** 14/14 个数值计算一致（整数/小数精度容许误差小于 `1e-8`）；新样稿保留 4.40%、0.30、USD 150、USD 35、3–7 工作日、双协议及企业账户限制。**未给出银行实际到账金额**；银行/中转费、汇兑、税款、经营成本、真实账户准入均 `UNKNOWN`；大陆自然人不能照搬企业账户费率或自动获得合法提现路径。
- **文件不变性：** 首版 `P2_HUMAN_WRITING_SAMPLE.md` Blob `b05dfdc45e03649927a25be0db0380f40a681ba6` 保持；Reviewer 已通过的 `P2_REWRITE_CANDIDATE.md` Blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7` 保持；不更改冻结 7/29/42、P1、main、Gate、Handoff，不进入 P3–P5、HTML、第三轮或任何真实支付。
- **未验证与回滚：** 没有真实付款、提现、银行资金验证、用户完读率或营销效果；可单独移除第二稿/回退本轮新增提交，其他两稿及历史证据不受影响。**RESULT=PASS_CANDIDATE / STOP_AT_REVIEWER**。

---

# 结构保留型重跑 Gate｜阶段 A 安全撤回旧短篇（2026-10-16）

- **GATE_ID：** `MCPG-P2-ROLLBACK-AND-HUMAN-WRITING-STRUCTURED-RERUN-20261016`，Gate Blob `f3a761a0d56c4b85df5006dbfbd3131e5afa4266`。
- **ROLLBACK_COMPLETED：** 仅在 `mcp-p2-independent-rewrite-20261016` 分支精确删除 `docs/P2_HUMAN_WRITING_SAMPLE.md`（删除前 Blob `b05dfdc45e03649927a25be0db0380f40a681ba6`；删除 Commit `969e28709ea23ced31dc1c91861028c0db4d43c1`）和 `docs/P2_COPY_EDITING_SAMPLE.md`（删除前 Blob `9a4bdd2971ac1a4307e82582a3ae1d9ab413d3e5`；删除 Commit `701e1b1b7f8fe2740c9ee7f7605c1ca5cd72acc4`）。没有 force/reset/改写历史。两个文件仅是上一轮在 PR 分支新增的孤立短篇，非已审正文或共享依赖。
- **DIRECT_READBACK：** 删除后按完整路径分别 fetch_file，均得到 `NOT_FOUND`；旧实验文件可从 Commit `d0f000e95554e530d3d52ce49acb85a0d1b4825e` 和 `c3341053cdd3f67cb78a2e8d8ad1dba9b3e8b15c` 读出相同 Blob（恢复能力验证）。原完整 `docs/P2_REWRITE_CANDIDATE.md` Blob 仍为 `f8bb110f07ef654df2f5b4b9285540e89261b1f7`（原审提交 `17ea75adec7448a8bbe6387788b5bfe321ff68f6`）；旧 Evidence Blob `686e7f2dc070decc8a7076c92cfd3a8841099c93` 未删、未复原覆盖。
- **PR 状态：** 删除后 head `701e1b1b7f8fe2740c9ee7f7605c1ca5cd72acc4`；Open / Draft / 未合并；当前 PR 仅余已审 P2 完整稿与执行证据两份 MD 的差异。当前分支**不等于**旧原审提交（审计历史保留）。
- **权限和下一步：** 阶段 A 已读回满足 Gate，允许阶段 B；本记录 append-only，旧两轮执行记录仍存。新稿必须只用原完整 P2 全文和指定 human-writing Skill，不得复用已删除短篇作为文字输入。

---

# 结构保留型重跑 Gate｜阶段 B 完整 P2 改稿与核验（2026-10-16）

## 本轮结果与固定来源

- **GATE_ID**：`MCPG-P2-ROLLBACK-AND-HUMAN-WRITING-STRUCTURED-RERUN-20261016`，**EXECUTOR_RESULT = `PASS_CANDIDATE`，`STOP_AT_REVIEWER`**；不得当作 Reviewer PASS 或 Owner 已接受。
- **阶段 A 已完成且严格前置**：参见上节 `ROLLBACK_COMPLETED`。仅精确删除两份失效短篇（删除提交 `969e28709ea23ced31dc1c91861028c0db4d43c1` 与 `701e1b1b7f8fe2740c9ee7f7605c1ca5cd72acc4`）；当前 PR 路径读回 NOT_FOUND，历史原短文可按 `d0f000...` / `c334105...` 恢复；原完整 P2 Blob 保持不变。阶段 A Evidence 追加提交 `11c23fdabacec01ea850419900b10500aa0de3e4`。
- **唯一知识及写作底稿**：已获 Reviewer 内容 PASS 的 `docs/P2_REWRITE_CANDIDATE.md`，原始 commit `17ea75adec7448a8bbe6387788b5bfe321ff68f6`，全文 Blob **`f8bb110f07ef654df2f5b4b9285540e89261b1f7`**，原文 19,986 JS 字符。逐字读取原全文；**两份撤销短篇仅核对 SHA/恢复能力，没有用于写新稿**，最早废弃 P2 未读取。
- **唯一使用的 Skill**：[KKKKhazix/human-writing](https://github.com/KKKKhazix/human-writing/blob/main/human-writing/SKILL.md)，v1.1.0，主 Blob `76bbf86ef49504628e356555f4da7cc6cbac3b7c` 与 Gate 完全相同。按顺序实际读取 `references/forum-prose.md` Blob `8bbc5fc0e7dccc1a6fa13dd457166e7eded303d4`、`references/reality.md` Blob `844e9c9236826cf29de9ccd9c7248eb970a15e02`；先编辑并提交独立**初稿** `92e895f635d02ba69b38bd898cfbc85a2660f0a4`、Blob `a104ced44d7317031e7103d5f252d9c3e0b2ee74`，**然后才读取** `references/revision.md` Blob `2a884689c52b42a23df757ae7060b1fbaa50ae4f` 并对全文修订。未使用 copy-editing、其他写作 Skill、广告文案或虚构亲历。
- **独立全章新稿**：[docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md](./docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md)。初稿精确完成 42 处定向段落改写（章开场与九小节都有改动），修订 8 处可读性、禁用表达和金融限定。最终稿提交 `ead44cfdf2cc00559368b4b8e13754af1d3fd192`，Blob `7924e80634f1f09a5628a78458c43a90d5019fd1`，21,126 JS 字符。GitHub `fetch_file` **DIRECT_READBACK** 与写入内容一致。

## 逐节保留矩阵（知识与用途，不依赖标题数量）

| 原节点 | 原稿已有知识及本次保留项 | 新稿的阅读改进与可实际回答的问题 |
|---|---|---|
| **1.1** | 七维订单画像（销售责任人、主体、商品、客群地区、渠道、交易结构、资金终点），29 美元软件/实物与 5000 美元企业单例；七维表完整 | 从“大陆个人能否用 Stripe”的具体问法出发，沿订单画像推导业务差异；读者能写出大陆企业 Shopify、月100单、14天用款的同一条件句 |
| **1.2** | 必须符合的主体/品类/合同/结算/退款条件，费用与支付体验优化，YES/NO/UNKNOWN 三态及决策前置卡 | 先说哪类申请该排除，再说哪些优化才值得比较；区分未申请的 UNKNOWN 与规则明确 NO，读者可先筛资格而不贸然比价 |
| **2.1** | 平台控制结账、直接商户、软件 MoR、B2B 合同银行四种商业安排的权责和表格；境内自营、跨境平台、实体独立站、SaaS、B2B 五种经营类型 | 从“订单和收据谁是卖家”入手，保持四模式对照表和五类场景的选择理由，不把支付宝、Amazon、Paddle、银行放同层 |
| **2.2** | 面向顾客的合同/付款链、商家资金/责任链、反向退款链；卡网络/钱包/支付服务商/销售平台/MoR/受款账户角色区分和 Shopify 两条资金路径表 | 在两个链条前各增一段读者问题，说明为什么一笔付款从完成交易到实际可用要经过不同责任方，最后要求明确账户名义和币种 |
| **3.1** | 六类经营主体/业务资格矩阵；Stripe HK 与大陆资格差异、PayPal CN 双协议、Shopify 中国受邀+WorldFirst 的限制 | 把实质经营主体、禁止品类与合法资金终点作为筛选，读者可将“不合格”直接排除、把未审核候选记 UNKNOWN |
| **3.2** | 从付款受理到银行可用货币的六节点核验；PayPal USD150/3–7工作日、企业USD35；Lemon Squeezy 结算条件；可验证/条件/不可用三态 | 以“成功订单为何仍无法采购”解释六节点的使用时机，将企业电汇的适用范围紧靠数值标出，读者能写出每站账户与退款责任 |
| **4.1** | G/T/A/B 四层金额表；PayPal/Stripe HK/Paddle 三种不同主体费率示范；PayPal 企业1/5/6/10/100单完整提现表；相同主体 PayPal 两支付产品 4.40%和获批4.10%对照；Shopify 同店 A/B 两公式、2%仅为假设演算；软件自收单与 MoR 费用/税务责任比较 | 先问“交易额与银行可用款为何不同”，把六单174→164.52→129.52的可解释差异提前；仍完整保留四层表、三种费率表、批次表、合格支付产品表、两条公式和软件 MoR 条件 |
| **4.2** | 付款覆盖、资金时间、退款/拒付、渠道切换四成本；100次意向付款多3单→销售额上限87美元的纯灵敏度推演；同口径净现金比较单 | 让读者把每个成本关联到能否备货与按时成交；数字讲出对选择的实际影响，未捏造订单成功率 |
| **5.1** | 四轮主备算法、自然人美国数字模板29美元/月5→100单、大陆企业实物29美元/月100单两完整情景与各自平台/独立站分支、Shopify A/B 对照、三类额外业务表、主备与停止规则 | 四轮改成先做什么/需查什么的白话，分别完整推演自然人的条件主选和数字商品平台备选、企业的 Amazon/Shopify 主备；自然人表中特别改掉把**企业账户35美元**当成个人费率的含混表达，保留 UNKNOWN 和合法提款条件 |

## 标题、表格、数字与来源核验

- **标题结构逐字级别/顺序对照**：对 `^#{1,3} ` 提取两稿 Markdown 标题，数组完全一致。共 **16 个**（H1=1、H2=6，其中第六个是来源附录，因此经营问题 H2=5、H3=9）；原有七个 `####` 子标题亦按原文、级别和顺序全部保留。无遗漏 1.1–5.1 子节，没有移动到附录。
- **表格核验**：原稿 93 行 Markdown 表行，新稿仍 **93 行**；其中 **92 行全文逐字相同**，唯一一行改动为 §5.1 自然人 PayPal 候选的资金一栏，明确 `USD35` 来自**特定企业账户**、不适用于未核实的个人账户。两案例和额外三类经营结论表完整。
- **官源核验**：原稿 **S01–S15 共15条来源行、全部官方 URL 仍存在**，正文中的业务范围限制维持。2026-10-16 复核 [PayPal CN S02](https://www.paypal.com/c2/business/paypal-business-fees?locale.x=zh_C2)（指定中国跨境双协议，国际4.40% + USD0.30，另需获批高级在线卡国际4.10% + USD0.30，**企业账户大陆美元电汇35美元/笔**）、[PayPal 提现 S05](https://www.paypal.com/c2/cshelp/article/how-do-i-withdraw-funds-from-my-paypal-account-help394)（USD150最低、通常3–7工作日、可审核）与 [Shopify 中国版](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china) / [资格](https://help.shopify.com/en/manual/payments/shopify-payments/supported-countries/china/requirements)（受邀、大陆企业跨境、WorldFirst验证）。[Stripe HK](https://stripe.com/en-hk/pricing)与[Paddle](https://www.paddle.com/pricing)公开示范价亦复核。其他个别商户费率、银行最终到账、退款率和真实开通资格保持 `UNKNOWN`。
- **计算静态复核**：`29×4.40%+0.30=1.576→1.58`，交易费后 `27.42`；五单 `137.10` 未达150；六单 `164.52` 达门槛，扣一笔企业35美元后 `129.52`；十单已知两层扣费后 `239.20`；百单 `2707.00`、企业电汇费均摊每单 `0.35`；Stripe HK USD 国际卡费按例示 `1.43`、余 `27.57`；PayPal 需获批在线卡费 `1.49`、与标准差 `0.09`；Paddle MoR `1.95`、余 `27.05`、十单 `270.50`；Shopify `2%` 仅数学假设对应 `29×0.02=0.58`。**13/13 数值表达计算匹配**，仅为具体规则下举例，非实收或净利润。
- **事实保护**：PayPal 35美元严格限定企业账户；个人实际合同、提现费用和法定收汇权限 `UNKNOWN`；没有把香港 Stripe 定价推广到大陆；Shopify 第三方附加费是否适用看店铺规则，不虚构具体中国账户费率；软件 MoR 与自售责任不同。用户支付成功 ≠ 可提余额 ≠ 银行到账。
- **正文审阅**：依 Skill 改掉冗余的“不是...而是”翻案提醒和资格段反复；保留原标题、表格、来源/公式中的必要标点、技术术语和“NO/UNKNOWN”等合规警示，优先级遵照 Gate。没有虚构亲历、企业真实开户、支付成功或转账。
- **无权限越界**：仅删除 Gate 指定两短篇、新建一份独立全章候选、向本 Evidence 追加。原已审P2正文/P1/7-29-42/当前 Gate/main/其他项目均未修改；不触碰支付账户、生产或 Secret；不合并、不进入 P3/P4/P5/HTML。
- **残余与恢复**：新候选的阅读吸引力属于 Reviewer / Owner 评判，未做用户阅读完读率、实际付费及真实汇兑验证。旧短篇可从 `d0f000...` 与 `c334105...` 的 Git 历史恢复；本轮新稿可单独删除，不会影响已审正文与 append-only 证据。**RESULT=PASS_CANDIDATE；STOP_AT_REVIEWER。**
