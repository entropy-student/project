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

---

# P2 双目标读者价值验证 Gate｜执行诊断与试读工具包（2026-10-16）

## 对象、权限与核验依据

- **GATE_ID** `MCPG-P2-READER-WILLINGNESS-AND-DECISION-VALUE-20261016`；最新修订 Gate Blob `578ba5d127ddb150423dbb869d64222b3f565a9c`；main `REVIEWER_HANDOFF.md` Blob `1616f5706bb1fe00e881f97d259e9609e2e4e98e`。Owner 最新指令是面向大众的知识科普与选择方法，**不对每位商家提供个性化账户/服务商建议**。
- **PREFLIGHT PASS**：PR #132 修改前 `Open=true / Draft=true / Merged=false`，head `bcf703636ef91d5dcde055442fa760e1995be905`，与 Gate 精确一致；PR 原有变更仅 `EXECUTION_EVIDENCE.md`、`docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md`、`docs/P2_REWRITE_CANDIDATE.md`。
- **两份全文固定稿直接读取**：人文表达候选 `docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md` Blob `7924e80634f1f09a5628a78458c43a90d5019fd1`（321行）；审过的知识底稿 `docs/P2_REWRITE_CANDIDATE.md` Blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7`。没有读取废弃的旧P2或已撤销短篇。
- **原 Evidence 历史保护**：本轮写入前 Blob `9aa25725fb2bcca1a94ef9b039873795fe78fe9d`，完整 24871 JS 字符。仅在末尾追加本节，不覆盖此前任何记录；不改两份正文、Gate、P1、main、冻结7/29/42等。
- **方法限定**：只读分段诊断和文本证据映射，无调用任何其他写作 Skill，没有文章改写、HTML、P3–P5、生产/支付账户/真实交易/外部读者联系或问卷投放。

## 交付与读回

1. **独立诊断** [`docs/P2_READER_VALUE_DIAGNOSTIC.md`](./docs/P2_READER_VALUE_DIAGNOSTIC.md)，写入 commit `e56152b513fe0adf1a342b9152448a4394f58345`，**Blob `09d59a974631756ba59d64fa2d054bbf0e06ed10`**；GitHub fetch_file 回读与写入全文精确一致。包括开头和5个H2知识组各至少一个吸引点/阻力与行号链接、6项学习结果、3大众疑惑、完整自然人数字模板参考案例证据链、轻量商品变更迁移题、5项排序损失点与最小修复建议。
2. **真实试读材料** [`docs/P2_READER_TRIAL_KIT.md`](./docs/P2_READER_TRIAL_KIT.md)，写入 commit `750169f395328c27e609dd399dff3623823135b1`，**Blob `a357aaa715cd4e4eafb913754f52aa579cdf115d`**；GitHub fetch_file 回读与写入全文精确一致。读前意愿2问、读中信息收获/阅读阻力2问、读后概念/选择方法/一例因果/残余疑惑4问，完成后才查看主持人对照要点。包含匿名、拒答、敏感信息不收集说明。
3. **本文件**仅 append-only。测试问卷并未分发或收集结果，预置三条记录明确标 `UNVERIFIED`，**不得误认为已试读三人**。

## 代理审读与知识矩阵摘要

| 目标 | 结论（仅文件内诊断） | 逐稿可查的证据及不确定性 |
|---|---|---|
| **A 愿继续阅读** | `EDITORIAL_PROXY` 开头2/2、§1 1/2、§2 1/2、§3 1/2、§4 1/2、§5 2/2，合计**8/12**，纯编辑打分 | 读者问题开头L3–L7；1.1七维表L15–L23较早、2.1/2.2术语表L45–L85、4.1多表L142–L207对非专家负荷高；§5.1实用案例L238–L282迟到。**实际有无阅读兴趣 `UNVERIFIED`**，并非8/12的读者通过率。 |
| **B① 角色区分** | `PARTIAL` | §2.2 L78–L85角色表完整，PSP/MoR/收单缺少初见处的一句白话，理解门槛偏高。 |
| **B② 模式与场景** | `SUPPORTED` | §2.1 L43–L60四模式、五经营类型，法律卖方与控制收银台的区别。 |
| **B③ 选型顺序与硬门槛** | `SUPPORTED` | §1.1 L15–L27画像、§1.2 L29–L37条件、§3.1 L95–L110资格、§5.1 L228–L234四轮主备。 |
| **B④ 四层金额及到账** | `SUPPORTED` | §4.1 L142–L179金额四层及企业6单164.52扣35后129.52，均为银行可用前的示例。 |
| **B⑤ YES/NO/UNKNOWN** | `SUPPORTED` | §1.2 L35、§3.2 L129–L132、§5.1 L246–L255。 |
| **B⑥ 完整参考案例** | `SUPPORTED（阅读负担较大）` | §5.1 L238–L255，先有假设条件，区分自营与平台，NO香港Stripe；PayPal自然人及模板资格为条件未知；五单 `5×27.42=137.10` 低于 `150` 美元电汇门槛；平台备用也待核实，不能保证个人获批。特定企业电汇 `35美元` 及 `129.52` 是**独立的企业示例**，不能套用自然人。 |

- **三类大众疑惑**：角色分工（`PARTIAL`，§2.2）；为何资格先于比费率（`SUPPORTED`，§1.2/3.1/5.1）；为何支付成功不等于银行可用款（`SUPPORTED`，§3.2/4.1）。诊断报告逐项给稿内链接与完整理由。
- **主要剩余问题**：①概念与七维表过早密集；②PSP/MoR等术语解释不充分；③§4.1跨法律资格费率比较与多个表的转换成本高；§5.1参考案例出现较迟。所提修复都限定“如何修改”的建议、**实际不改正文**。
- **试读标准分离**：建议今后经Owner选择是否让3名真实目标读者试读；A至少2名愿读且能说明吸引点、B至少2名脱稿能复述判断步骤与案例理由及资格未知，**两项分别评价**；N=3不支持统计推断。真人反馈、完读率、理解率、收款渠道账户真实资格全部 `UNVERIFIED`。
- **预检算术与事实核对**：29美元在指定协议下4.40%+0.30的假设手续费为1.576，按单美分后1.58、余额27.42，五单137.10低于150；企业六单164.52减企业批次35后银行费前129.52。以上引用原文而非新费率或真实银行数据。个人与企业的资格及提现不同；诊断**不要求为读者提供个性化支付商推荐**。
- **回滚方案及停点**：只新增两份诊断类Markdown文件；如被Reviewer否决可单独撤回，两份原P2 Blob与原历史 Evidence 不因撤稿而丢失；本轮 Evidence 仅补充后续记录。**RESULT = `PASS_CANDIDATE`; `STOP_AT_REVIEWER`。** Reviewer决定诊断 Gate 是否 PASS，Owner可决定后续是否真人试读。

---

# P2 读者试读问卷防诱导返修｜正式 Reviewer RETURN 修补（2026-10-16）

- **REVIEWER_FEEDBACK**：[PR #132 comment #6209319816](https://github.com/entropy-student/project/pull/132#issuecomment-6209319816)；评审判定 `RETURN_TRIAL_KIT_LEADING_PROMPTS`。独立诊断报告内容已 `PASS`；仅允许修补问卷 Q6/Q7 的诱导性与试读者收到答案的隔离问题；不可将此返修当作读者价值最终 PASS。
- **固定执行基线**：PR #132 head `a350593e5259b2d3498c8e450d026ce4fcd66c78`，Open / Draft / 未合并；原问卷 Blob `a357aaa715cd4e4eafb913754f52aa579cdf115d`；原 Evidence Blob `b22ddb946fa7812401b7eed56d1a681f077510fd`。主 Gate `MCPG-P2-READER-WILLINGNESS-AND-DECISION-VALUE-20261016`（main Blob `578ba5d127ddb150423dbb869d64222b3f565a9c`）适用。
- **实际唯一非证据文件修改**：`docs/P2_READER_TRIAL_KIT.md`，Commit `720a8f16740fe80eb1bdcbe5d028ba024308e01d`，新 Blob `5af87f86f6ed9b4035017914cc0aa840006f2dbe`，GitHub fetch_file **DIRECT_READBACK EXACT**。
- **Q6 前后**：原“他为什么应先看自己是什么经营主体、卖什么，再比较支付手续费？你会按什么顺序...”直接给出资格优先费率的判断顺序；新文 `如果给一个新生意选择收款方案，你会依次考虑哪些事情？为什么？`，不提前给顺序。
- **Q7 前后**：原文提前提示“不能只凭香港银行账户选香港 Stripe、PayPal 仍需核验、5单遇提现额”；新文 `请用自己的话复述文中的大陆自然人数字模板案例：他的条件是什么、比较了哪些方向、怎样得出判断、哪些尚不能确定？`，让读者独立从已读文章回忆案例。
- **纯问卷导出边界**：以 Markdown 原始文本 `<!-- READER_QUESTIONNAIRE_BEGIN -->` / `<!-- READER_QUESTIONNAIRE_END -->` 作为复制范围。新增文件顶端**仅主持人操作说明**，命令式禁止向真人发送**工具包全文或其 GitHub 工具包链接**，要求仅复制两个标记内文本。主持人对照要点保留在结束标记之后，并明确 `禁止随问卷发送`；提交答案后才内部核对。
- **自动静态检查**：两个标记精确存在；标记内问卷保留题1–8共8题、文章原文链接与匿名提示；主持人参考答案、旧Q6/Q7提前给出的结论均不在可发送区段；主持人答案在隔离区保留，可供事后核对。**注意安全操作是“只复制区段”，不是把整份 Markdown 发给试读者**。
- **本轮 Git 精确差异**：通过 `compare_commits` 核实 `a350593...` → `720a8f1...` **只有** `docs/P2_READER_TRIAL_KIT.md` 一份修改，无诊断或正文改动。
- **不可改变的两份 P2**：完整知识稿 Blob `f8bb110f07ef654df2f5b4b9285540e89261b1f7`；人文表达候选 Blob `7924e80634f1f09a5628a78458c43a90d5019fd1`；已独立通过的 `docs/P2_READER_VALUE_DIAGNOSTIC.md` Blob `09d59a974631756ba59d64fa2d054bbf0e06ed10`，均在提交问卷后直接读回未变。P1、7/29/42、其他项目及 main 未触碰。
- **真人试读状态**：仍 `UNVERIFIED`，未接触、招募、暗示存在真人答卷；本轮只设计中立试读工具，无外部调查、真实支付或商户操作；未调用写作 Skill，未进入 P3–P5。
- **Evidence / 回退策略**：只在旧完整 Evidence 后追加本节，不擦除原始问卷版本和旧 Reviewer RETURN 的历史。若本轮被否决，可将工具包恢复到旧 Blob `a357aaa...` 所在提交，Evidence 用新补充记录纠正，不截断历史。**Executor RESULT = `PASS_CANDIDATE / STOP_AT_REVIEWER`**，独立 Reviewer 需复核问卷中立性与实际分发隔离；禁止自宣真正读者已喜欢或掌握知识。

---

# 第①板块恢复 V5 原三级问句 + blader/humanizer 完整自然中文润色（2026-10-16）

## Gate、基线及权限

- **GATE_ID**：`MCPG-P2-V5-H3-RESTORE-AND-HUMANIZER-20261016`，main Gate Blob **`513fa738a0dfbe8e63270bceec95591c807a4af1`**；main `REVIEWER_HANDOFF.md` 第2–4节明确了 V4 ①一级、5二级和 V5 9三级原文（本轮用作标题权威，未修改 main）。
- **PREFLIGHT**：PR [#132](https://github.com/entropy-student/project/pull/132) 原head **`f04899142b2156cb2e685faff25342b6cab6ca4e`**，Open / Draft / 未合并，精确匹配Gate。新增目标 `docs/P2_V5_STRUCTURED_HUMANIZER_CANDIDATE.md` 原路径直接返回 `NOT_FOUND`；没有覆盖已有文件。
- **唯一润色底稿**：`docs/P2_HUMAN_WRITING_STRUCTURED_CANDIDATE.md`，Blob **`7924e80634f1f09a5628a78458c43a90d5019fd1`**，完整读入，约21,126 JS字符。旧已审核知识稿 `docs/P2_REWRITE_CANDIDATE.md` Blob **`f8bb110f07ef654df2f5b4b9285540e89261b1f7`**仅为知识校验用，未作润色底稿；已撤销短稿、废弃P2未读取或复用。
- **唯一新写作 Skill**：[blader/humanizer](https://github.com/blader/humanizer/blob/main/SKILL.md) `v3.1.0`，MIT，主 Markdown Blob **`19fc634208e8cc6ae55d4ff287152583216fd244`**，与Gate钉住的版本完全一致；实际完整读取文本并应用 Staging（形式化对照、固定总结）、Rhythm（节奏模板）、Inflation（空泛抬价）、Formatting（机械加粗）、Leftovers（介绍本文而不讲知识）五类诊断。没安装软件、没执行代码脚本/npm、没向外部网站上传私有内容；没调用第二润色或旧human-writing Skill。Humanizer一般建议的合并章节/删表/改数据/删法律限定与本Gate冲突，**均未采用**。
- **写入范围**：仅新增 `docs/P2_V5_STRUCTURED_HUMANIZER_CANDIDATE.md` 和对本 `EXECUTION_EVIDENCE.md` **append-only**。新稿创建Commit **`959686a3a06a98d926c80782b2d673a8ae63ffbd`**，首次Blob `d94731d61c04ee763b9192782e96352e52625fb6`；一处“多成交3单”改回原稿金额事实用语“多完成3笔交易”的精确小修Commit **`d9da7e49a2a8bdda12777bffada3657c7e077369`**；**最终新稿 Blob `76c0ba0e50adc5377d60f003b479a8b6f7b56c10`**，22,035 JS字符，GitHub `fetch_file` 与写入全文直接读回一致。保持两份原P2、试读工具包及诊断不变。

## 冻结结构和内容保真直接复核

- **H1/H2/H3冻结标题数组逐字对照PASS**：完整按顺序逐字匹配最新 Gate + main V5权威的 **16个标题（H1=1、知识H2=5、来源H2=1、H3=9）**。9个正式H3全部恢复原V5问题，例如 1.1“如何将顾客市场、商品类型与交易模式转化为收款需求？”，2.2“支付方式、收款服务商与到账账户各自解决什么问题？”，3.2“如何核实付款、结算、提现、退款能否形成完整闭环？”。全部旧叙述式H3已移除其**标题位置**，没有擅自追加新H2/H3、调序或缩节。
- **H4**：原7个金额示范/案例/业务决策标题字面、级别及顺序**完全相同**，两条完整演练仍在5.1。
- **表格**：从原稿和新稿提取所有以 `|` 起始Markdown表格行，均为**93行，93行逐字相同**（包含所有列、跨境金融准入、费用、日期与风险限定），没有重排或重写单元格。
- **来源**：完整 `S01–S15` 参考行仍在；原稿所有**25个外部HTTP(S) URL原字符串及顺序**与新稿完全相同；资金/税务/协议/地区/商品/世界银行/钱包等文内链接均未改。
- **9 H3知识保真矩阵**（独立校验各小节关键实体均没有从旧稿消失）：

| 冻结题 | 旧有知识/案例以及新稿保留 | 改动限度 |
|---|---|---|
| 1.1 | 七维交易画像表、单价29美元软件/实物与5000美元B2B，Shopify月100单和14天回款示例 | 从重复“先别急着问”转为“从一类实际订单识别需求” |
| 1.2 | 主体/商品/收款人/退款硬性条件、体验成本软性条件、YES/NO/UNKNOWN含义 | 使用正常段落说明何为淘汰、何为可优化，未改变门槛 |
| 2.1 | 平台受理、自己收单、软件MoR、合同B2B银行四模式；国内店/跨境平台/独立站/软件订阅/B2B五类业务 | 补充MoR原缩写含义，模式表和五类业务均保持 |
| 2.2 | 支付方式、卡组织、商户PSP/收单能力、销售平台、MoR、WorldFirst/Wise及银行各自职责；顾客付款正向链、结算链、退款/拒付反向链 | 加白话PSP释义与资金链角色区分，严格保留原有行内代码链和表 |
| 3.1 | 六类型主体适用矩阵、HK银行账户与HK商户资格不同、PayPal中国**指定双协议**和另一协议排除、4.40%具体产品范围、Shopify受邀及WorldFirst规则 | 对照主角和规则来源改写，不改变受邀/审批或地区限制 |
| 3.2 | 顾客受理→销售→处理→可结算款→提现→银行可用的六节点；退款与拒付的反向责任；美元电汇150最低、企业35每批及3–7工作日、Lemon Squeezy银行国家条件，三种资格状态 | 多写明退款责任为何影响后续余额，没有删掉UNKNOWN |
| 4.1 | G/T/A/B四层金额、三个**不可跨资格直接排名**的报价结构、同主体PayPal 5/6/10/100单提现表、同主体两付款产品4.40%及经批4.10%、Shopify同店A/B两式及假设2%、软件MoR税务/结算/费率 | 只改各表衔接与叙述，所有原表格、H4、公式、货币值及事实边界未动 |
| 4.2 | 付款覆盖、现金周转、退款/拒付、渠道中断4类经营风险；100次付款意向多3笔→条件性额外销售额87美元（不当利润）及净现金比较单 | 改掉“先说我不编造数据”式预告，保留全部计算假设和经验数据UNKNOWN |
| 5.1 | 四轮主备算法；**自然人对美卖29美元原创模板（月5→100单）**与**大陆企业对美卖29美元实物（月100单、14天回款）**两套完整案例；Amazon/Shopify不同渠道、额外三类生意、主备及未获批的边界 | 让假设与选择关系叙述自然，个人/企业35美元费用不能混同；结果仍为条件候选而非真实开通 |

- **金融独立算术复核**：以下**14/14** 条用JS独立计算，偏差容忍 `1e-7` 内：29×4.40%+0.30=1.576→逐单按美分1.58，费后27.42；5单137.10（小于150），6单164.52（达到150），**仅假设企业**扣35后129.52；10单扣35后239.20，100单扣35后2707、摊每单0.35；高级卡4.10%+0.30约1.49；合格HK Stripe公开价对应国际卡29美元约1.43；Paddle 5%+0.50为1.95，10单后初步基数270.50；Shopify假设附加2%为0.58；多3笔成交×29是87美元销售额而非利润。**以上非任何账户真实到账或获批证明**。
- **严禁误用的金融边界**：支付成功≠可提余额≠银行实收；PayPal 4.40%仅特定CN协议，企业35美元/批不适用于未经核实的自然人；大陆拥有境外银行账号≠真实HK商户主体；受邀Shopify中国支付产品≠通用HK Stripe开户，WorldFirst为特定结算环节非顾客卡收单；Paddle软件MoR包含销售方责任边界且不自动接受模板；不凭空填FX、银行费、税务、退款或批准结论。新旧正文逐节关键实体静态比对均保留。

## Humanizer 实际修改证据：11组局部“原句 → 新句”（不计仅标题替换）

| 位置 | 观察到的 AI 叙述问题及原段摘录 | 候选对应表达/实际改进 |
|---|---|---|
| 开场 L3–L7 | “卖一件29美元的商品，顾客能够点下付款按钮，商家还得回答另一个问题。”接三连提问与“本章沿着……”元描述 | “一笔29美元的订单显示付款成功，商家能马上用这29美元采购下一批货吗？”直接带出交易余额与采购现金，后续仍交代全章选择路径 |
| §1.1 | “先别急着问‘大陆个人能不能接 Stripe’……答案才有对象”像模板式叫停 | “收款需求要从订单里找，单问‘能不能接 Stripe’很容易遗漏条件”，以同公司订单差异接七维画像，不删任何维度 |
| §1.2 | “有些条件一票否决……剩下的条件才适合优化”机械两步句 | 改为“判断时需要分开两种条件”，分别说明淘汰与可比较条件，不削减资质和责任条件 |
| §2.1 | “支付公司名单容易看花眼，先查订单和收据上谁是卖家……”偏说明文模板，MoR未展开缩写 | 用淘宝/Amazon、自有站、MoR、企业合同的不同卖方身份自然引到原模式表；只补已有MoR含义，不自创新服务 |
| §2.2 | “先看顾客下单以后……这一段可以沿合同与付款链核对”，读者不容易知道角色差别 | 以“顾客看到什么付款方式 / 商家靠什么商户收单”解释 Visa/钱包/PSP/结算账户；原正向和退款反向链都不动 |
| §3.1 | “筛收款产品时，先拿真实身份证明和实际商品逐一核对”偏逐项培训语气 | 将“官网国家名单只能决定能否申请”和“HK银行账户不产生HK商户资格”整合成因果段，保留产品及协议限制 |
| §3.2 | “一笔订单显示成功，商家可能仍没钱……需要顺着下面六个节点查”缺退款动机 | 将成功交易、结算、提现、银行可用和退款回扣联系起来，仍完整列六节点和独立企业电汇费用 |
| §4.1 | “有一个看起来很直观的差额”先替读者评价，再进入MoR比较 | 改成“卖软件时，选择MoR还意味着改变对消费者的销售安排”，费用1.58/1.95/270.50/239.20及适用主体完全保留 |
| §4.2 | “不用编造转化率也能先做一笔灵敏度演算”属于写作者自辩，而非读者问题 | 改为“可以假设一组数据看看支付成功率值得多少关注”，直述100次意向多3笔为87美元销售额，并坚持非真实观测/非利润 |
| §5.1与演练A | “选主用渠道，可以按四轮来做……”及“假设的业务条件”机械标题式模板 | 先说明方法用于理解资格/条件，再从大陆自然人销售模板的具体订单叙述引入；没新增真实人物经历，没有简化主备与UNKNOWN |
| §5.1与演练B | “假设的业务条件。一家有真实供货、经营资料的大陆公司……”名单式案例开场 | “再换一家大陆公司。它有真实供货和经营资料……”接100单/14天备货困境，Amazon与Shopify合同和收单职责完整保留 |

- **全章处理量**：新稿对9个叙述式H3进行逐字V5恢复；对 **45处独立正文表达单元**进行局部自然化，覆盖全部5个H2和9个H3（开篇及案例收束也有调整）。没有为了文章变短删掉知识；原稿21,126字符→新稿22,035字符，主要增量为对缩写及责任角色的短解释。长度变化不代表学习效果。
- **仍需Reviewer/Owner判断**：AI味下降只能由独立阅读评价；真人“愿不愿读”“能否掌握选择方法”尚未测试，仍为 `UNVERIFIED`。本轮仅提交完整候选，**不宣称正式标题冻结已实施到 main/最终文档**，不触发其余板块。
- **恢复机制**：可单独删除本轮新候选路径，不影响任一已审核旧稿；Evidence按append-only新节纠正，不reset/force改写历史。**EXECUTOR_RESULT = `PASS_CANDIDATE / STOP_AT_REVIEWER`**。

---

# P2 第一部分 V6正式冻结题名｜新手友好完整候选重跑（2026-10-16）

## 事实依据、现行Gate与范围

- **GATE_ID** `MCPG-P2-V6-READER-FRIENDLY-FULL-RERUN-20261016`，main `docs/P2_V6_READER_FRIENDLY_FULL_RERUN_GATE.md` Blob **`b23539269e19bdd89a402e76337633e8e17e0e2f`**；Owner已正式冻结 **7一级/29二级/42三级 V6问题**，但并未正式冻结P2第①板块的新正文。
- **PR预检**：#132为Open/Draft/未合并，执行前head精确等于Gate规定 `78d8ff48ec019bc051e59eb768f175f384a60a43`；执行分支 `mcp-p2-independent-rewrite-20261016`。唯一新增目标 `docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` 原先 `NOT_FOUND`。
- **权威V6实际版本差异（透明留证）**：Gate记载 main `REVIEWER_HANDOFF.md` 整文件旧Blob `17c59ea2e97fe8ff0ce379909cd7c8349e084d37`；实际读到新版Blob **`2c8daae15e1efb456d72ddb854e31b02878a118b`**。独立抓取旧Blob和当前全文后，**逐字符比较第二至四节正式冻结框架完全一致（约5000字符）**；差别在第九节Gate发布/执行状态和尾部新追加的发布交接记录，未涉及冻结问题原文字词。main独立冻结快照 `docs/FROZEN_FRAMEWORK_V6_20261016.md` Blob **`8c7e1d20c4c423cb07a26fca1868b3f3821c3c62`** 与Gate钉住值完全一致。故正文仅按权威冻结第二至四节和快照构建，而**不把整文件Blob误报成没有发生变化**。如Reviewer要求对整个Handoff Blob字面严格相等，请独立给出 `RETURN_PREFLIGHT_DRIFT` 复核意见；本轮没有修改main或覆盖权威。
- **唯一原文输入**：已审 `docs/P2_V5_STRUCTURED_HUMANIZER_CANDIDATE.md` Blob **`76c0ba0e50adc5377d60f003b479a8b6f7b56c10`**，22,035字符；未回退早期废稿；未调用额外写作Skill。事实复用已审核V5主稿的原始适用范围、核验日期与来源，没有创造实时金融报价/商户准入结果。
- **写入操作**：唯一独立新稿 [`docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md`](./docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md)，首次commit **`7735ae09515d04614e54e4550d96216d133bcb29`**，新Blob **`777c5ab45e4f2d748c45a1e524bf172fca467967`**，22,702字符/321行，GitHub `fetch_file` **全文直接读回EXACT**。另外只在当前Evidence原末尾append本节，不截断历史。没部署、没改main或既有P2正文、没有使用新Skill、没生成HTML或进入P3–P5。

## 标题与保真校验结果

- **严格V6标题数组比对：** Gate围栏中提取的完整标题集与新稿Markdown的 `^#{1,3} ` 行**逐字、级别、顺序全相等**；1H1、5个知识H2+1来源H2、9H3共16项；旧V5的5H2/9H3已从*新候选的标题位置*全部替换，旧稿Blob未动。不自加标题层级。
- **7个H4** 原文/顺序/等级全部与V5相等；**93行Markdown表格**逐行逐字完全相同（包括费用、适用身份、来源及两个案例的各个表），未删除或修改一行单元格；**S01–S15共15个官方来源**齐全，外部URL的25个原字符串及出现顺序逐字相同。
- **章节与内容保真静态检查**：从两稿完整提取九个H3，每个标题之下关键实体清单前后未丢失：七维画像、YES/NO/UNKNOWN、四销售/收款模式、五类业务、卡网络/钱包/PSP/MoR/WorldFirst/Wise银行角色、三条责任及资金链、六节点闭环、PayPal双协议/HK和Shopify受邀限制、G/T/A/B费用表、两套完整案例/四轮主备。九节逐节保真结果均PASS，保留退款/拒付反向责任与未知账户资格。
- **独立数学复算15/15**：$29×4.40%+$0.30=$1.576，例示逐单取美分$1.58、费后$27.42；5单$137.10<$150，6单$164.52，**仅假设符合规定的企业账户**批次电汇$35后$129.52；10单$239.20、100单$2707.00、百单均摊$0.35；在线卡高级版按4.10%+$0.30约$1.49；有资格HK Stripe标准国际卡示范约$1.43；Paddle软件MoR 5%+$0.50=$1.95/单、10单初步基数$270.50；Shopify附加2%仅数学示范$0.58；多3笔29美元订单增加销售额$87，**不等于利润**。以上均非真实开户、支付试验或银行入账。
- **关键风险界限**：香港银行账户不产生香港Stripe经营主体资格，Shopify中国版Payments基于真实获邀/WorldFirst验证，不是通用Stripe开户；PayPal公开费率限定CN指定双协议、高级卡产品要另行获准；企业$35电汇费不能套用大陆自然人。软件MoR对软件品类与法定销售方责任有边界；消费者税、银行和中转行费、FX、提现、退款/拒付及具体个人或公司的真实批准情况仍可能是UNKNOWN。

## V6九个新手问题→首段直答→方法、案例与适用范围矩阵

| V6小节 | 读者第一段直接学到什么 | 继续阅读如何知道怎么判断、边界在哪里 |
|---|---|---|
| **1.1** 卖什么、卖给谁、在哪里卖，会影响怎么收钱吗？ | 直接回答**会**：国内现货、海外订阅、平台结账决定可选范围 | 同一类重复订单的7维表→美国$29软件/实物、$5000 B2B对照→100单/14天资金条件 |
| **1.2** 哪些必须、哪些可优化？ | 真实主体、商品、支付覆盖、合法受款、退款责任是硬门槛，费用/便捷/到账为软条件 | YES/NO/UNKNOWN的证据标准和淘汰vs继续调查的差异 |
| **2.1** 自收、平台、第三方卖方区别？ | 从谁销售/谁控制收银台/谁承担退款职责区分自收、平台、软件MoR、B2B合同汇款 | 保留四模式完整责任/资金表及国内小店、平台、独立站、SaaS、外贸五类业务；平台是否法律卖方需看合同 |
| **2.2** Visa/PayPal/Stripe/银行做什么？ | 首句分别点明卡网络、支付方式/商户产品、PSP收单与合法银行账户职责 | 原六行角色表＋付款/合同链＋结算/资金链＋退款拒付反向链、Shopify与WorldFirst示例；不能凭账户创造商户资格 |
| **3.1** 个人/公司与商品、地区限制？ | 回答**会限制**，官网支持地区不等于真实主体可批准，HK银行账户≠HK商户资格 | 六类经营主体资格矩阵、PayPal双协议与Shopify中国版受邀/WorldFirst要求 |
| **3.2** 怎么确认合法到账且有人退款？ | 用可付款、可结算、合法银行接收、反向退款/拒付责任检查完整闭环 | 六节点、退款责任与权益处理、PayPal美元电汇$150最低+特定企业$35、Lemon Squeezy银行范围与UNKNOWN |
| **4.1** 扣完费用还能剩多少？ | 解释需要按支付费、平台费、提现/汇兑/银行及结算节点分别核算 | G/T/A/B四金额；跨地区示范与同主体可比方案不混淆；$29按1/5/6/10/100单的企业条件演算、Shopify A/B及软件MoR完整演算 |
| **4.2** 除手续费比什么？ | 付款覆盖、现金到账、退款/争议、渠道中断与备用 | 四类原有风险清单；100次付款意向多3单假设$87仅销售额非利润，同客群真实数据才能比 |
| **5.1** 怎么选主用和备用？ | 主用必须资格/商品/结算合法且满足经营条件；备用须独立收款和合法结算 | 四轮顺序、自然人29美元模板（月5→100）及大陆企业29美元实物（月100/14天）两套完整条件推演、不同生意主备边界及未获批UNKNOWN |

## V5→V6真实语言对应：7处可读性改动样例

| 位置 | V5原话（节选） | V6改动与目的 |
|---|---|---|
| **1.1** | “收款需求要从订单里找，单问‘能不能接 Stripe’很容易遗漏条件。” | “会影响，而且通常比支付品牌的名字更早决定选择范围。”直接回答题目里的“会影响吗”，再以国内现货/海外订阅/平台场景说明为何 |
| **1.2** | “判断时需要分开两种条件。” | 开门见山列主体、商品、买家付款、合法账户、退款为必须条件，再说明何时可以比较方便与费用 |
| **2.1** | “同样是顾客付钱，卖家的身份可以完全不同。” | 直接用销售方、结账控制权和退款责任区分自营/平台/MoR/B2B，保留平台≠一律MoR的区别 |
| **2.2** | “顾客看到的是银行卡、支付宝或 PayPal 等付款方式；商家接触的则可能是 Stripe...” | 逐一解释Visa/Mastercard/银联、PayPal、Stripe/PSP和银行账户具体职责，随后自然接原双链与MoR/WorldFirst |
| **3.1** | “支付服务商官网上的国家名单只是起点。” | 先给出“会限制”的明确答案，再用大陆自然人/HK账户和实际商品说明开户条件为何不同 |
| **3.2** | “顾客的付款记录显示成功，只说明交易到了某个状态。” | 变成完整检查顺序，并在首段主动告诉新手退款/拒付责任要逆向核对；保留原六节点 |
| **4.1/5.1** | “费用比较最容易出错的地方...”“前面分清了支付角色...” | 首段先说明29美元如何从G/T/A到B、主用及独立备用的合格标准，再看原公式和两件完整案例，不用猜标题问题的答案 |

## 恢复、尚待审核与停点

- **回滚：** 若独立Reviewer不接受新稿，可只撤销 `docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` 新路径，旧V5稿与已审核诊断、试读问卷、知识稿均不会受损；Evidence另追加后续更正，不force/reset或截断历史。
- **最终限制：** 全文可学习价值是**文内结构/内容支持的判断**，真实读者阅读意愿、理解水平仍为 `UNVERIFIED`。无真实商户、试读、提现实测；P2新稿正式冻结仍 `PENDING`。本次结束状态仅 **`PASS_CANDIDATE / STOP_AT_REVIEWER`**；PR Open/Draft/未合并，P3–P5保持未启动。


---

# P2 V6 Owner冻结版与教学重构R1独立候选｜本轮直接编辑证据（2026-10-16）

## AUTHORIZED_GATE / 角色与停点
- **授权事实**：Owner原话“我没问题，先正式修改就行了，嗯，目前这版先冻结下一版看结果再判断是否要替代。”
- **GATE**：`MCPG-P2-V6-PEDAGOGICAL-R1-20261016`，GitHub main `docs/P2_V6_PEDAGOGICAL_R1_REWRITE_GATE.md` Blob `d5c5f93aa8440d6b221415861ec5d3076f11f28c`。
- **执行者说明**：本轮由同一助手直接完成文本编辑及机械自检，**未作为独立Codex执行、未进行独立Reviewer复核**。当前最多 `EDIT_CANDIDATE_READY / INDEPENDENT_REVIEW_PENDING`，不能填 `REVIEWER_PASS`，真实新手愿读与读懂仍 `UNVERIFIED`。

## PREFLIGHT_FACTS / DIRECT_READBACK
- PR #132 起始 head `dd40ca89ecdffff195f43e3d00c84fa3dee2ada8`，Open/Draft/未合并，工作分支 `mcp-p2-independent-rewrite-20261016`；分支在本次提交前没有其他未审变更。
- 原完整V6 `docs/P2_V6_READER_FRIENDLY_FULL_CANDIDATE.md` Blob `777c5ab45e4f2d748c45a1e524bf172fca467967`；main另存的Owner冻结对照版 `docs/P2_V6_OWNER_FROZEN_REFERENCE_20261016.md` **同Blob** `777c5ab45e4f2d748c45a1e524bf172fca467967`，321行、22,702字符，字面完全相同。
- main正式V6全框架 `docs/FROZEN_FRAMEWORK_V6_20261016.md`仍保留7/29/42标题不变；正文标题本次没改字词或层级。
- 当前唯一新的写作Skill指南来自 `arjunprabhulal/agent-skills/skills/docs/plain-language/SKILL.md`，MIT，Blob `a80064b322df5dd720788fd601ef30e45c1d91fb`，仅以文字准则指导编辑，未安装第三方脚本、未调用其他写作Skill。

## ACTUAL_CHANGES / 修改范围
- PR分支**只新增**完整备选正文 `docs/P2_V6_PEDAGOGICAL_R1_CANDIDATE.md`，初次Commit `3107830f9be14b77e9465a11179aa01243619ad1`，再作本地内容质检后的修正Commit `132754c0082bd35f493d7fbabca9b2d889006169`，最终候选Blob `5658f49d627828607f198ed1595115b158dbf166`、346行、23,887字符。
- 旧V6正文及main Owner冻结对照不变。初稿主要**改写原45个段落/导语/方法与案例入口**，并**把§1.1原七维完整表格整体从未解释名词的第一屏，放到一个具体订单示范及必要名词短释之后**；原表格行文字与其他表格相对顺序没有变。
- 修正阶段重点恢复Paddle按月结算/100美元门槛/部分15美元SWIFT费用的明确叙述、恢复企业示例采购与物流款以人民币使用的条件、确保YES要审核实际通过才成立、修复Markdown表格前空行。没有新增未核验的商家开户权限和费率。

## 10组重要正文差异及教学理由（内容均在新增稿内可检索）
| 位置 | 冻结V6的阻碍 | R1的新解释/新顺序 | 为什么不削减知识 |
|---|---|---|---|
| 开篇L3–7 | 提到账余额后立即列多个支付名词 | 先给29美元模板故事和**卖什么→有资格→实际到手→主备**四步路线 | 所有品牌与合同条件仍在原后文 |
| §1.1 | 七维表第17行先用MoR、SaaS、收单、B2B后定义 | 先讲顾客地区/商品/合法到款三问和29美元具体订单，后讲术语再完整保留七维表 | **93行原表格文字及相对次序完全相同**，只是该表在小节内部后置 |
| §1.2 | 一次罗列硬软指标与英文字母 | 先用“有香港银行不等于HK商户资格”的具体不成立例子，再引出能用/不能用/不知道与YES/NO/UNKNOWN | 资格与风险条件仍保留且只有真实批准才为YES |
| §2.1 | 首段同时堆自收/平台/MoR/B2B四模式 | 先比自己的网站和Amazon平台，再解释软件MoR是谁在卖、企业合同汇款，后保留模式表 | 平台≠一律MoR的责任边界保留 |
| §2.2 | Visa、PayPal、PSP、银行、Wise等术语在一句出现 | 用顾客输银行卡的29美元订单，分开付款网络/支付服务商/商户终点账户，再展开双链和退款反向链 | 角色表、两条链、退款责任及Shopify/WorldFirst事实无删 |
| §3.1 | 立即跳进大陆个人/企业/HK/软件等六种资格表 | 同一自然人模板订单，先问真实身份、商品和能否合法入账，再提供全资格表 | 特定CN协议、HK商户资格与Shopify中国版受邀条件仍在 |
| §3.2 | 一次抛六节点链、余额、退款 | 从支付成功却未到银行讲起，接六节点并反向检查退款/银行卡拒付 | 6个节点、$150、仅企业$35适用性等完整在正文/表内 |
| §4.1 | 一上来G/T/A/B及四类不同地区费率 | 先用附资格条件的29美元扣约1.58得27.42示范，再讲G/T/A/B，分阶段读复杂表 | 全部金额/费率/四组H4和月批提现计算、退款未知边界都在 |
| §4.2 | 付款覆盖/到账/中断都是抽象指标 | 用顾客能不能顺利刷卡、钱何时可付采购、争议占款、主渠道断线四问，再讲风险清单和87销售额例 | 未把销售额当利润，真实支付成功率仍未知 |
| §5.1 | 四轮主备与两完整案例最后集中出现 | 文章开头就给四步路线，第5节用模板自然人和14天周转企业回扣四步 | 两案例及额外三类业务、全部判断/UNKNOWN完整保留 |

## OBJECTIVE_READBACK / 保真验证
- 由现行正式V6问题快照构建的 **H1 1个、知识H2 5个、H3 9个、来源H2 1个，共16条标题逐字及顺序全匹配**；旧7H4标题同序同文。
- 原V6表格为 **93行**，新R1仍**93行；逐行内容与整体顺序全同**。原15条 `S01–S15`出处序号和25个外部HTTP(S) URL均完整，URL字符串及顺序完全一样。
- 两份完整大陆自然人数字模板、大陆企业跨境实物条件演练均在§5.1；九个H3答题/方法、YES/NO/UNKNOWN/支付-资金正反链、G/T/A/B、法律销售方与合规主体/银行终点等核心概念可定位。
- 原V6内容中所有`$金额`与`%数值`的原字符串仍出现在R1正文；额外独立算数确认 `29×4.4%+0.3=1.576`→按分1.58，费后27.42；5单137.10、6单164.52、符合资格的**企业**电汇扣35后129.52；一百单企业例示2707；Paddle单笔1.95/10单270.50；不能把美元到手数当已入银行或人民币利润。
- 对原“MoR表格先出现、后定义”重新定位：新增稿解释性文字位于七维表上方，文本原文表移入了三问、具体交易与专业词短释之后；专业缩写在需要时再正式解释。
- 本次所有变更均为文本及GitHub审计文件，不接触真实支付账户、商户审核、税务申报、资金提现；真人学会及愿读`UNVERIFIED`。Reviewer仍需检查是否还有冗余句和新先修概念未被解释。

## ROLLBACK / EXECUTOR_RESULT / OWNER_HANDOFF
- **TARGET** 本轮仅R1独立文件和Evidence append；Owner冻结V6历史对照全文及PR原稿都保持相同Blob。
- **METHOD** 如R1质量未达标，丢弃仅R1候选并在Evidence追加纠正，不截断旧Evidence，不动冻结版、不reset/force。
- **RESULT** `EDIT_CANDIDATE_READY / INDEPENDENT_REVIEW_PENDING`；**不能声称Reviewer独立PASS**。
- **NEXT REVIEW** 独立Reviewer冷读1.1、2.2、4.1、两完整案例等，核查新手是不是先理解再学术语及老手深度；Owner看完备选再决定是否替代当前冻结版。
