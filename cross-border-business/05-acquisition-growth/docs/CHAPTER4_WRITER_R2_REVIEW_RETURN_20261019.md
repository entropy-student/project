# 第五部分·第四章《找客户到底划不划算？》｜Writer R2独立Reviewer复核（2026-10-19）

> **REVIEW_RESULT：RETURN_CH4_R2_VAMP_REVENUE_AND_COST_SCOPE**  
> **CHAPTER4：WRITER_R2_DELIVERED / STRUCTURE_PASS_6_12 / CONTENT_RETURN / NOT_SEALED**  
> **CURRENT_GATE：CB05-CH4-WRITER-R3-MINIMAL-REPAIR-20261019**  
> **FRAMEWORK：OWNER_FROZEN_V2_1_6_35_78（不变）**  
> **CHAPTER1–3：FINAL_SEALED（保持不变）**  
> **OWNER_ACTION_REQUIRED：转发Writer R3完整最小返修ZIP与提示词，回收R3完整正文和事实核验ZIP。**

## 一、R2完整交付与独立结构验收

- Owner上传`第五部分_第四章_Writer_R2完整交付.zip`，**39,524字节**，SHA256 `5dc88259e05ab87e2f142d8a374ecc849b744038914aeba7989931473366434a`，`testzip()=None`。
- 完整正文 `第五部分_第四章_找客户到底划不划算_Writer_R2完整候选稿.md`，**47,646字节/467行**，SHA256 `b8baba4e0e70d4b1b9b3c98c3f5bc6bd847da5cac412b9beb9cbf1cd16be7268`。
- 完整核验 `第五部分_第四章_Writer_R2事实核验与返修记录.md`，**36,789字节/251行**，SHA256 `5ea6e197afd9ea4ebf95b5cd55c0db325407877e9b58770692c2b0a9e2508b74`。
- 与[Owner正式冻结V2](FROZEN_FRAMEWORK_V2_20261018.md)逐字核对：1一级/6二级/12三级全部**原文、顺序、层级、归属PASS**；正文全部六节齐备、18个代码围栏配对；相较R1保留原知识主体并进行了实质定向修复。
- 数学演算重算正确：$480/12=$40；$4250/$350≈12.14周；$90−26−17.50−4.26−4.50−1=$36.74；$36.74−42=−$5.26；$110/22=5个月；Cohort第7期预期累计≈$114.78；n=100、p=2%时P(0)≈13.26%。**数学正确不等于收入、净利润或实际现金回款口径必然正确**。

## 二、R1问题复审矩阵

| R1 ID | R2复核 | 判断 |
|---|---|---|
| B01 折扣重复入账 | **PARTIAL** | $90实收与$10折扣二次扣费已修；仍将$100标价“确认收入”与内部折扣分析混用，见新B02 |
| B02 同期、订单与现金 | **PASS** | §4.1.2已区分同期/Cohort、现金存量/净流量、客户/订单 |
| B03 无对照归因冒充统计显著 | **PASS** | §4.2.2明确只有方向性观察，不能据两周前后比较推断因果 |
| B04 PayPal/Visa规则 | **PARTIAL/RETURN** | PayPal 10%/90天已标为官方示例；Visa VAMP 0.9–1%来源映射仍错误，见新B01 |
| B05 Stripe泛化 | **PASS** | §4.4.1限定美国标准卡交易与国际卡附加费用、无货币兑换等假设 |
| B06 UTM/RFC/GA4 | **PASS** | 纠正RFC仅为URI技术编码，GA4旧模型2023-11退役，优惠码及问卷存在偏差 |
| B07 LTV与回本 | **PASS_WITH_NOTE** | Cohort期望与单客户实际回本已区分，月付模型的6.59月插值需说明见N03 |
| B08 刚性测试规则 | **PASS_WITH_NOTE** | 改为经营者自定预算并加入产品类型反例，残留“8周/必然扩量更贵”见N01 |
| N01 漏斗解释 | PASS | 已按业态列可能原因和验证动作 |
| N02 工时现金与机会成本 | PASS | 已拆现金流账本、决策账本 |
| N03 绝对拒付/物流时限 | PASS_WITH_NOTE | 旧绝对封号删除，仍留Visa错误门槛和扩量必然表述 |

## 三、R3最小必修（仅三项）

| ID | 程度、原文位置 | 错误与官方依据 | 最小验收 |
|---|---|---|---|
| **B01** | **BLOCKER**，正文**§4.4.2 L329**、核验**§2 L65 / §3 L90** | 将`0.9%–1%`争议率当Visa VAMP商户统一高危线。Visa官方VAMP采用**(TC40欺诈+TC15争议)/TC05已结算交易**的计数比率，并按地区、最低欺诈争议事件笔数、2026生效变化判断。Visa官方Fact Sheet脚注写**2026-04-01起AP/加拿大/EU/美国商户过度阈值≥150bps(1.5%)，通常还需月度相关事件≥1500笔**，不是任何商家0.9–1%必然受罚。 | 正文和核验记录都删除错误数字，按Visa当前官方Fact Sheet准确说明比率、地区、最低笔数与收单机构自有监控的区别，不保证自动加收或封禁。 |
| **B02** | **HIGH**，正文**§4.3.1 L230**、核验**§2 L62** | “按$100全额确认收入、折扣列营销费用”易误导卖家改变真实财务收入确认；IFRS 15交易价格是预期可收取对价，折扣影响净额。 | 保留$100标价、$10立减、$90实收、折扣只扣一次的正确原则；可在**内部管理报表**双列原价与折扣，但明确不等于法定会计/税务上可任意确认$100收入。 |
| **B03** | **MEDIUM-HIGH**，正文**§4.4.1 L282–306，Mermaid L297–299** | 案例仅扣$42的**广告CPA**就叫“最终单笔真实利润”，而全口径CAC还可能包含制作、人力、工具、打样等。$36.74−$42=−$5.26的算术成立，但不是包含所有营销及固定支出的净利润，也不保证当日实际兑现$1052现金损失。 | 公式/图/解释统一称“扣本例广告CPA后的阶段性贡献差额”，补充未列成本/税费/实际退款及账期边界；200单−$1052只表示假设条件完全相同的**模型贡献差额**。若要叫“扣CAC后”，则必须按同一客户/订单和fully-loaded CAC口径。 |

## 四、顺手小修（不因非阻断扩大返工）

- **N01：** §4.1.2 L109“低于8周严禁”、§4.4.2 L314–317扩量“必然”导致CTR下降、§4.6.2 L452访问不足5秒“证明”受众错配：只做业务条件/教学假设，不称放诸四海皆准。
- **N02：** §4.5.1 L345订阅LTV LaTeX格式错误，且“已经是每用户贡献毛利”的量不可再次乘Gross Margin；二选一：`ARPU收入×贡献利润率/月流失率`或`每用户月贡献利润/月流失率`（稳态模型）。
- **N03：** §4.5.2 L378/L389“6.59月”仅连续线性插值，月付离散现金流应为**第7个结算/收费时点**跨过$110。
- **N04可选：** §4.6.2手写测试总预算不等于平台后台日均预算自动硬封顶；Google Ads绝大多数适用系列可单日按日均预算约2倍投放，需管实际累计成本。

## 五、独立来源与计算依据

- [Visa官方VAMP Fact Sheet，含2026-04-01脚注](https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf)：监控比率、地区阈值与最低事件数。
- [IFRS Foundation IFRS 15](https://www.ifrs.org/issued-standards/list-of-standards/ifrs-15-revenue-from-contracts-with-customers/)：预计有权收取的交易对价与收入。
- [PayPal美国账户准备金](https://www.paypal.com/us/brc/article/account-reserves)：10%/90天仅是示例，非固定全球要求。
- [Stripe美国公开收费](https://stripe.com/pricing)：2.9%+$0.30，国际卡加1.5%，换汇另计，按资格调整。
- [Google Analytics 4当前归因设置](https://support.google.com/analytics/answer/16291112)：旧首次点击、线性、时间衰减及位置模型自2023-11不可用。
- [Google Ads日均预算及超额投放](https://support.google.com/google-ads/answer/6385083)：不是多日自定义测试总额硬封顶。

## 六、完整自包含R3离线返修包与停点

- **下载附件名**：`第五部分_第四章_R2独立审核与R3最小返修包_20261019.zip`，**51,185字节**，SHA256 `b2198d8d3f607e424dc93ee4aed110036e337d748aa6feb201bcd0bbb6a6bf62`，ZIP `testzip()=None`，7个文件；含**R2两份完整原稿(467/251行)**、完整Reviewer详细报告、R3精确指令、官方证据、可直接复制转发话术和Manifest。
- **完整Reviewer详细报告在ZIP内** `01_独立Reviewer_R2复核报告.md`，本GitHub文件是同一问题矩阵的正式停点摘要。ZIP二进制只在本轮对话交Owner，**不冒称已上传GitHub**。
- Writer R3仅按**B01–B03及N01–N03**最小修订，6二级/12三级全部冻结标题逐字保留，回交**完整R3正文Markdown+事实核验与逐项修订Markdown+ZIP**，`STOP_AT_REVIEWER`；Writer无需/无GitHub权限。
- **本轮不修改候选正文、不建立第四章正式封板文件，不启动第五章；前三章正式正文与完整V2框架全部不改。**
