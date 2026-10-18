# 第五部分第四章《找客户到底划不划算？》｜Owner授权Reviewer直修与正式封板证据

> **STATUS：CHAPTER4_FINAL_SEALED / OWNER_AUTHORIZED_DIRECT_MINIMAL_REPAIR（2026-10-19）**  
> **唯一正式正文：** [CHAPTER4_FINAL_SEALED.md](CHAPTER4_FINAL_SEALED.md)  
> **正式框架：** [FROZEN_FRAMEWORK_V2_20261018.md](FROZEN_FRAMEWORK_V2_20261018.md) 核心1/一级6/二级35/三级78，**不变**；第④章原题6个二级/12个三级。  
> **后续唯一Gate：** [第⑤章独立Writer完整首稿](CHAPTER5_INDEPENDENT_WRITER_GATE_V1_20261019.md)，**不代表第⑤章完成或封板**。

## 1. 原稿、审核与Owner新授权

- Writer R1独立审核[RETURN](CHAPTER4_WRITER_R1_REVIEW_RETURN_20261019.md)（八项必修，三项小修）；Writer随后完整交付R2 ZIP：`第五部分_第四章_Writer_R2完整交付.zip`，39,524字节，SHA256 `5dc88259e05ab87e2f142d8a374ecc849b744038914aeba7989931473366434a`，ZIP `testzip()==None`。
- **R2全文原件**：47,646字节、467行、SHA256 `b8baba4e0e70d4b1b9b3c98c3f5bc6bd847da5cac412b9beb9cbf1cd16be7268`；**R2核验原件**：36,789字节、251行、SHA256 `5ea6e197afd9ea4ebf95b5cd55c0db325407877e9b58770692c2b0a9e2508b74`。
- [R2独立Reviewer报告](CHAPTER4_WRITER_R2_REVIEW_RETURN_20261019.md)判`RETURN_CH4_R2_VAMP_REVENUE_AND_COST_SCOPE`，剩余**B01–B03必修及N01–N03小修**。其`NOT_SEALED`只反映当时Writer候选的状态，**不再是Owner后续决定后的当前状态**。
- **Owner本轮明确授权：**“这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。”Reviewer据此直接在Writer R2**整章原稿**上执行最小修复并独立校验，提交正式全文、审计与后续Writer Gate。**没有独立Writer R3实际交付**；旧R3返修包是历史中间资料，后续不应重复催促Writer R3。

## 2. 逐项最小修复证据

| 问题 | Writer R2风险与定位 | 最终正文的更正 |
|---|---|---|
| **B01：Visa VAMP** | §4.4.2错误以0.9–1%单一争议率引用VAMP官方阈值 | 直接核对Visa官方VAMP Fact Sheet**2026-04-01修订脚注**，解释`(TC40欺诈+TC15争议)/TC05结算交易`计数比率，商户在**亚太/加拿大/欧盟/美国**Excessive门槛**≥150bps（1.5%）**并有**月度相关事件≥1,500件**等准入条件；地区差异、收单机构自身标准和支付服务商内控规则单独说明，绝不推断自动封禁。 |
| **B02：折扣与收入** | §4.3.1把100美元标价直接“确认收入”与10美元独立营销支出混用 | 讲清100标价、10优惠、**90美元交易对价/实收示例**，内部展示原价/折扣仅用于管理分析；不能将其当作改变适用财务或税务收入确认的许可。坚持折扣只扣一次。 |
| **B03：CPA与净利润** | §4.4.1`36.74−42=−5.26`曾被称为扣尽全口径CAC后的净利润并必然兑现1052美元现金亏损 | 保留全部正确算术，名称改为**扣本例广告CPA后的阶段性贡献差额**，突出未扣素材、人力、工具、固定支出、所得税及结算偏差；200单−1052只是相同假设下的模型差额，不是已实现现金损失。图/公式/注释与正文统一。 |
| **N01** | 8周现金跑道、广告扩量与5秒停留当通用确定规则 | 改成示意风险护栏与可核验的信号，不声称普遍因果/行业硬线。 |
| **N02** | 订阅LTV公式重复乘贡献率且括号有误 | 统一`ARPU收入×贡献利润率/月流失率`或`每用户月贡献利润/月流失率`两种互斥表示，限定稳定流失的简化预期模型。 |
| **N03** | 订阅回本6.59或6.6月被表述成真实收款 | 严格区分连续线性插值和**第7个按月结算时点**首次跨过110美元的群组期望贡献。 |
| **顺手** | 编辑错字与广告总预算口径 | 修订两处重复词；经营者书面测试上限≠广告平台自动总限额，需查看已计费支出和主动暂停。 |

修订遵循最小变更：保留完整六节、全部6+12题目原文、数学示例、全部9组Markdown代码围栏与原教程主体；改动集中于16处定位，并附三条对应官方资料和适用局限。**正文使用通用经营知识，不提供特定中国大陆主体/海外账户的法律、会计、税务定制意见**。

## 3. 官方一手资料与事实边界

- [Visa Acquirer Monitoring Program官方Fact Sheet](https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf)，特别是脚注5的2026年4月1日修订和各地区最低数量。该文件还区分收单商户/收单机构；部分排除条件依数据时间点。
- [IFRS Foundation—IFRS 15](https://www.ifrs.org/issued-standards/list-of-standards/ifrs-15-revenue-from-contracts-with-customers/)：以适用交易价格/预期对价核算收入，**并非**“原价与折扣可自由归类改变法定收入”；实际会计准则取决于所属法域。
- [PayPal美国账户储备金](https://www.paypal.com/us/brc/article/account-reserves)：比例与扣留期按商户账户实际风控条款，10%/90天属于示例而非强制规则。
- [Stripe公开费率](https://stripe.com/pricing)：第五板块正文仅保留**特定美国商户、国际卡且无汇兑**的教学参数；不把费率套用全世界。
- 无实际商户、银行或广告后台账户读取；当前实例数值均为`MODEL_ASSUMPTION`，非真实交易、统计结论或确认损益。

## 4. 正式成果、指纹与复查

- 正式GitHub路径：`cross-border-business/05-acquisition-growth/docs/CHAPTER4_FINAL_SEALED.md`。**main正式文件50,835 UTF-8字节，Git blob SHA `f314ac35126674fa7ba136135429911923e3132c`，内容SHA256 `a96fe0bdaecd3d08a053b72d076f74f76876c3c2f69d625c5b2ae71f2a846960`**，已提交main并读回全文一致。独立Reviewer本地文件不再多保留尾行空行。
- 官方V2题树核对：章标题及**6个二级、12个三级题目**逐字一致，顺序、层级、父子归属均一致；Markdown代码围栏**18个、9组成对**；数理演算保持对应假设。
- 第①②③章GitHub唯一正式正文、第五板块V2问题树及其它①②③④板块均不修改。历史R1/R2审核结论保留，但后续Reviewer必须从本证据和**唯一当前Reviewer交接**恢复，不能将历史RETURN当现行封板状态。
- **结论：PASS_FOR_OWNER_AUTHORIZED_SEAL / CHAPTER4_FINAL_SEALED**。第⑤章Writer Gate单独启动，**第⑤章没有Writer首稿也没有正式知识正文**。
