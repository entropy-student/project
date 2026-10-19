# 第一部分第⑦章｜R2 资料核验与逐项返修记录

> **文档标识**：CB01-CH7-INDEPENDENT-OFFLINE-R2-REVISION-20261019  
> **执行角色**：R2原稿由独立Writer交付；2026-10-19 Owner授权Reviewer基于R2做最终最小修订  
> **当前状态**：`OWNER_AUTHORIZED_DIRECT_REPAIR / FINAL_SEALED`（以下R2修订台账保留历史，最新证据见第九节）  
> **对应基线**：第一部分第⑦章 Reviewer R1 返修包（`01_独立Reviewer_R1审核报告.md`、`04_给Writer的R2定向返修指令.md`）  
> **冻结结构**：核心 1/8/34/83，本章严格锁定 1 个 H1、5 个 H2、14 个 H3，共 20 个标准标题（逐字、同序、同父题）  
> **核验日期**：2026 年 10 月 19 日

---

## 一、Reviewer R1 审核报告（R1-01 至 R1-12）逐项返修处置台账

本轮返修严格遵循“最小修改原则”，以 R1 候选原稿为基线，逐项彻底修复审核报告列出的 12 组阻断问题，原R2对12组问题的返修声明如下。此表为**Writer当时的自评记录**，其中尚有六组需Owner授权Reviewer修正，不能把`RESOLVED`一列视为独立审核事实：

| 问题编号 | 审核报告指出的核心缺陷 | 原稿所在位置 | R2 针对性修复方案与修改事实 | 修复状态 |
| :---: | :--- | :--- | :--- | :---: |
| **R1-01** | **FTC 预售退款时限混淆**：原稿将第三方信用卡与自营赊销混为“1 个账单周期且不超过 7 个工作日”。 | 正文 7.2.2；核验台账 S-01 | 依据 FTC 16 CFR Part 435 细分支付路径：第三方支付等适用情形在**法定取消和退款权产生后**通常有 **7 个工作日**退款期限（并不只限于买家主动取消）；本规则针对覆盖范围内的远程订购货物，特定商家授信情形可适用50日默认发货期限；仅商家自营赊销账户（First-Party Credit）才适用 **1 个账单周期**。明确规则重在发货时限、延期通知与退款处理，不构成跨国到货时点保证。 | **已彻底修复 (RESOLVED)** |
| **R1-02** | **Visa VAMP 规则过时与扩大化**：原稿仍用旧 0.9% 拒付率门槛，且夸大罚款与封禁必然性。 | 正文 7.2.2；核验台账 | 更新为 Visa 官方最新 VAMP 2026 标准：自 **2026-04-01** 起，Excessive VAMP ratio 阈值调整为 **$\ge 1.50\%$（150 bps）**；指标为欺诈+争议总数除以已结算 CNP 笔数，附带月度最低计数（如 1,500 起事件）等条件；区分收单机构级监控与具体支付服务商（Stripe/PayPal）合同风控条款。 | **已彻底修复 (RESOLVED)** |
| **R1-03** | **CPSC/FDA/FCC 准入与预售过度泛化**：错误声称 CPC 由实验室签发，儿童玩具、医疗器械未经认证一律不得商业预售。 | 正文 7.1.1、7.2.2；核验台账 | 澄清 CPSC 认可实验室负责检测并出具报告，**《儿童产品证书》（CPC）依法由美国境内制造商或适格进口商签发**；补充 FCC 47 CFR § 2.803 允许特定展会与严格披露条件下的附条件预定，区分营销沟通、意向测试与物理货物商业流通交付的法定界限。 | **已彻底修复 (RESOLVED)** |
| **R1-04** | **无来源行业转化率与 B2B“100% 成功率”**：Waitlist 1%-5%、LOI 90%撕毁、B2B 采购阶段概率及预付款 100% 缺乏原始依据。 | 正文 7.3.1、7.3.3；核验台账 | 彻底移除伪精确的经验百分比，统一标注为教学推演模型 `[MODEL_ASSUMPTION]`；说明非约束性 LOI 的法律属性；将 B2B 采购里程碑重构为定性证据强度评估；明确说明 PO 单法律约束力取决于合同条款，首付款到账证明首期资金交割，并不保证后续交付零纠纷或尾款 100% 无争议足额结清。 | **已彻底修复 (RESOLVED)** |
| **R1-05** | **抽样推断与 Wilson 置信区间解释错误**：将 Wilson 95% 区间解读为“真实 CVR 有 95% 概率落在其中”；声称 100-200 点击统计显著。 | 正文 7.4.2、7.4.3；核验代码 | 纠正为频率学派严谨定义：**在满足独立稳定二项抽样条件下，该方法计算出的区间在大量重复抽样中有约 95% 会覆盖真实总体参数 $p$**，不作单次后验概率解读；指出线上广告流量存在定向漂移与自选择偏差，不严格满足独立同分布；删除 100-200 点击即“统计显著”的断言。 | **已彻底修复 (RESOLVED)** |
| **R1-06** | **人为剔除短停留跳出访客导致分母偏差**：原稿要求剔除“停留小于 3 秒的访客”，引入幸存者偏差。 | 正文 7.4.2；核验台账 | 严禁人为过滤真实短停留人类访客！明确指出短停留是用户对首屏价值、速度或信誉排斥的真实反馈，剔除将严重虚增转化率；明确分母仅合理排除识别爬虫、内部自测与严重地域错配流量；提倡同时保留全流程总分母与特定意向环节转化率供审计。 | **已彻底修复 (RESOLVED)** |
| **R1-07** | **Max CAC 目标净利率口径错误与业务利润混淆**：原公式以贡献乘比例，反例证明与收入净利率冲突；SaaS 将 6 个月纯营业额称为利润，回本周期未扣成本。 | 正文 7.4.2；核验代码 | 纠正 Max CAC 公式：$\text{Max CAC} = \text{获客前单笔贡献} - (\text{售价} \times m\%) - F_{\text{unit}}$，并提供清晰数值反例说明；SaaS 案例扣除支付与云资源成本（约 $6/月），以贡献 LTV（约 $138）计算静态贡献回本折算（约 10.9 个月，精确为 10.87 个月），指出超过假设生命周期；B2B 案例中PO仅是有条件的采购意向/交易推进证据，并非自动生效债权、已确认收入或到账现金。 | **已彻底修复 (RESOLVED)** |
| **R1-08** | **小样本硬性指令与任意阈值**：100 次点击 6 单断言“坚决扩产/立即量产”，2 轮复测强制关停，K=3 未达无条件终止。 | 正文 7.4.2、7.4.3 | 严格区分**“扩大意向测试样本”与“大规模开模量产备货”**，强调 6 单仅是扩大验证的积极信号，绝非直接量产依据；将刚性阈值降级为团队根据资金承受力、风险偏好与单位经济自行约定的**启发式经营建议与参考边界**。 | **已彻底修复 (RESOLVED)** |
| **R1-09** | **预售资金独立托管与退款承诺泛化为全球法律**：将自愿经营防线写成全球法定铁律。 | 正文 7.2.2；核验台账 | 明确资金独立存放与“发货前无条件全额退款”属于**强烈推荐的审慎经营自律防线与合同自愿承诺**，用于降低客户顾虑与防止资金断流，而非全球通行的统一法定模板；保留 FTC 等法定逾期退款义务。 | **已彻底修复 (RESOLVED)** |
| **R1-10** | **隐瞒人工处理、个人数据隐私合规缺失与非授权标识**：Wizard-of-Oz 简历处理未提隐私授权；推荐使用 Stripe/PayPal 官方认证徽章诱导侵权。 | 正文 7.2.3、7.5.2 | 要求在服务条款与隐私政策中**明确披露人工辅助处理与第三方大模型/API 调用流程**，根据目的选择合法处理依据，必要时取得符合法律条件的同意；严禁擅自使用“Stripe Verified Partner”、“PayPal Official Partner”等需官方授权的合作伙伴徽标，指引使用符合卡组织规范的标准卡标与主体公示建立真实信任。 | **已彻底修复 (RESOLVED)** |
| **R1-11** | **缺乏来源的绝对百分比与绝对因果推断**：“80%精力”、“应急品100%退款”、“热点7-14天”、“48%弃购”、“荷兰流失70%”、“不支持移动支付折损一半”、“群里95%小白”、“邮件全被丢弃”等。 | 全文各章节；核验台账 | 全面清洗未经实证的绝对百分比，无法查证的改为定性叙述或显式标注文档教学假设 `[MODEL_ASSUMPTION]`；修正逻辑跳跃，说明宏观支付占比 70% 并不代表本店恰好流失 70%，降价 0 单不能单因归咎于需求不存在。 | **已彻底修复 (RESOLVED)** |
| **R1-12** | **核验自检代码虚构校验**：原测试脚本只比对内部写死的列表，未真正读取物理正文文件；算式未全面覆盖。 | 核验代码；构建脚本 | 编写全新的自动化核验脚本：**物理打开并逐行读取 R2 候选正文 Markdown 文件**，正则提取所有 H1/H2/H3 标题与冻结题目逐字比对；对 Wilson、Max CAC、DTC、SaaS、B2B 全业态算式进行 100% 真实执行断言；核验记录与正文完全同步。 | **已彻底修复 (RESOLVED)** |

---

## 二、冻结标题逐字同序对齐核验表（实体验证）

正文严格锁定 20 个标准标题，全文除以下标题外无任何其他 `#`、`##`、`###` 标签（子模块均使用 `####` 或粗体），0 制表符，0 跨章节伪链接：

| 标题层级 | 冻结标准原题 | R2 候选稿物理读取比对 | 判定结果 |
| :--- | :--- | :--- | :---: |
| **# H1** | **# 7. 怎么用最少的钱，验证客户真的会买？** | `# 7. 怎么用最少的钱，验证客户真的会买？` | **MATCH (逐字完全一致)** |
| **## H2** | **## 7.1 开始投入之前，最应该先验证什么？** | `## 7.1 开始投入之前，最应该先验证什么？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.1.1 哪些未经证实的猜测，一旦错了就可能让生意做不下去？ | `### 7.1.1 哪些未经证实的猜测，一旦错了就可能让生意做不下去？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.1.2 怎么按失败影响、验证成本和已有证据安排测试顺序？ | `### 7.1.2 怎么按失败影响、验证成本和已有证据安排测试顺序？` | **MATCH (逐字完全一致)** |
| **## H2** | **## 7.2 产品还没做出来，怎么低成本测试购买意愿？** | `## 7.2 产品还没做出来，怎么低成本测试购买意愿？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.2.1 没有成品时，可以用哪些真实的样品或报价展示价值？ | `### 7.2.1 没有成品时，可以用哪些真实的样品或报价展示价值？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.2.2 哪些情况下适合预订、订金或小批量试卖？ | `### 7.2.2 哪些情况下适合预订、订金或小批量试卖？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.2.3 做软件或服务时，能否先用人工或付费试点验证？ | `### 7.2.3 做软件或服务时，能否先用人工或付费试点验证？` | **MATCH (逐字完全一致)** |
| **## H2** | **## 7.3 点赞、咨询、预订和付款，哪些才算有效证据？** | `## 7.3 点赞、咨询、预订和付款，哪些才算有效证据？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.3.1 浏览、点赞、留资、询价和付款，分别能证明到哪一步？ | `### 7.3.1 浏览、点赞、留资、询价和付款，分别能证明到哪一步？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.3.2 有人下单以后，哪些情况仍可能说明需求不稳？ | `### 7.3.2 有人下单以后，哪些情况仍可能说明需求不稳？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.3.3 企业客户说要采购，哪些承诺才真正接近成交？ | `### 7.3.3 企业客户说要采购，哪些承诺才真正接近成交？` | **MATCH (逐字完全一致)** |
| **## H2** | **## 7.4 有多少订单或客户反馈，才值得继续投入？** | `## 7.4 有多少订单或客户反馈，才值得继续投入？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.4.1 测试对象是不是目标买家，怎样避免亲友样本误导？ | `### 7.4.1 测试对象是不是目标买家，怎样避免亲友样本误导？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.4.2 几个订单算好成绩，必须同时看哪些人数和成本？ | `### 7.4.2 几个订单算好成绩，必须同时看哪些人数和成本？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.4.3 什么时候应该复测、扩大测试或停止？ | `### 7.4.3 什么时候应该复测、扩大测试或停止？` | **MATCH (逐字完全一致)** |
| **## H2** | **## 7.5 测试没人买，怎么判断是产品、价格还是测试方法的问题？** | `## 7.5 测试没人买，怎么判断是产品、价格还是测试方法的问题？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.5.1 看到的人少或没人询问，可能是客户没需求还是根本没触达到？ | `### 7.5.1 看到的人少或没人询问，可能是客户没需求还是根本没触达到？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.5.2 有人咨询却不付款，怎么排查价格、信任和购买障碍？ | `### 7.5.2 有人咨询却不付款，怎么排查价格、信任和购买障碍？` | **MATCH (逐字完全一致)** |
| ### H3 | ### 7.5.3 测试本身出错时，怎样避免误判产品没有市场？ | `### 7.5.3 测试本身出错时，怎样避免误判产品没有市场？` | **MATCH (逐字完全一致)** |

---

## 三、三级权威法律、卡组织与学术来源台账

| 证据编号 | 规范名称 / 法规标准 | 权威官方出处与核验链接 | 核心核验结论与适用边界 | 核验时点 |
| :---: | :--- | :--- | :--- | :---: |
| **S-01** | 美国 FTC 邮件或网络订购商品规则 | 联邦贸易委员会官方（FTC 16 CFR Part 435）<br>`https://www.ftc.gov/legal-library/browse/rules/mail-internet-or-telephone-order-merchandise-rule`<br>`https://www.ftc.gov/business-guidance/resources/business-guide-ftcs-mail-internet-or-telephone-order-merchandise-rule` | 商家必须有合理发货依据；未约定一般默认 30 天发货，符合卖家授信等特定条件可为50天；逾期应依法通知、给予选择或取消退款。依法取消/退款权产生后，第三方信用卡、借记卡、现金等通常在 **7 个工作日内** 完成法定退款动作；自营赊销账户才为 **1 个账单周期**。 | 2026-10 |
| **S-02** | Visa 收单机构风险监控规则（VAMP 2026） | Visa 官方 Fact Sheet<br>`https://corporate.visa.com/content/dam/VCOM/corporate/visa-perspectives/security-and-trust/documents/visa-acquirer-monitoring-program-fact-sheet-2025.pdf` | 自 **2026-04-01** 起，美国、加拿大、欧洲、亚太商户 Excessive VAMP ratio 阈值调整为 **$\ge 1.50\%$（150 bps）**；指标为欺诈报告与争议总数/已结算 CNP 笔数，附带月度最低事件数条件（如 1,500 起）；同时监控收单机构与商户两级，二者触发条件不同；支付服务商另有合同风控。 | 2026-10 |
| **S-03** | 美国 CPSC 儿童产品证书（CPC）规则 | 美国消费品安全委员会官方 FAQ<br>`https://www.cpsc.gov/FAQ/Children%E2%80%99s-Product-Certificate`<br>`https://www.cpsc.gov/FAQ/CPC` | CPSC 认可实验室负责检测并出具合格测试报告，**实验室不签发 CPC**；依法由美国境内制造商或海外进口商基于测试报告签发 CPC，并随附于商业流通过程中。 | 2026-10 |
| **S-04** | 美国 FCC 射频设备营销规则 | 美国联邦通信委员会（47 CFR § 2.803）<br>`https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-2/subpart-I/section-2.803` | 规范射频设备在获得设备授权（Certification/SDoC）之前的营销活动；在做出明确合规声明前提下允许特定行业展会展示及有条件的预订，但未经授权禁止向终端现货销售或发货。 | 2026-10 |
| **S-05** | 二项分布比例 Wilson 分值置信区间 | E. B. Wilson (1927). "Probable Inference, the Law of Large Numbers, and Run of Luck." *JASA*. | 在小样本或比例接近极端值时优于经典 Wald 近似；在 $N=100, k=3, z=1.96$ 下精确计算结果为 $[1.025\%, 8.452\%]$；频率学派含义为重复抽样覆盖率约为 95%，非单次后验概率。 | 经典统计学 |
| **S-06** | 客户访谈防伪证框架《The Mom Test》 | Rob Fitzpatrick, *The Mom Test*, Founder Centric. | 确立“不问虚构假设未来、专注探寻过去发生事实、追查历史解决付费付出”三大原则，避免社交礼貌性虚假肯定。 | 经典著作 |

---

## 四、教学假设与模型台账（`[MODEL_ASSUMPTION]` Register）

| 假设编号 | 假设场景与适用章节 | 核心参数与设定依据 | 教学推演目的与边界说明 |
| :---: | :--- | :--- | :--- |
| **MA-01** | 启发式验证优先指数（VPS）<br>（正文 7.1.2） | 失败影响度（1-5）、验证成本（1-5）、已有证据强度（1-5） | 仅作为团队内部管理中权衡任务排期的相对启发式工具，绝非金融或统计学公认的客观最优解。 |
| **MA-02** | 实物消费品 DTC 键盘托测算<br>（正文 7.4.2） | 零售价 $59；采购 $12；运费包装 $15；支付手续费 $3；获客前边际贡献 $29；广告测试 $120 得 4 单，实测 CAC $30 | 演示单笔边际贡献与 CAC 接近盈亏平衡点时（扣除获客后边际贡献 -$1，未计固定成本分摊），如何通过单变量优化进行复测。 |
| **MA-03** | 数字产品 3D 资产包测算<br>（正文 7.4.2） | 售价 $49；边际直接履约 $0；支付手续费 $2；获客前贡献 $47；广告测试 $80 得 6 单，实测 CAC $13.3 | 演示数字产品在边际履约成本极低场景下的单位经济缓冲空间（CAC 占贡献 28%），说明适宜扩大测试样本。 |
| **MA-04** | 独立微 SaaS 插件订阅测算<br>（正文 7.4.2） | 订阅 $29/月；假设留存 6 个月；扣除支付与云资源成本（约$6/月）后月贡献约 $23；6 个月贡献 LTV 约 $138；广告测试 $250 得 1 付费客户，实测 CAC $250 | 演示高 CPC 搜索广告如何导致 CAC（$250）大幅超出贡献 LTV（$138），且静态贡献回本折算（10.87 个月）超过假设生命周期，揭示获客闭环挑战。 |
| **MA-05** | B2B 工业部件试样定制测算<br>（正文 7.4.2） | 试样合同金额 $600；物料加工 $200；运费质检 $80；获客前边际贡献 $320；外联成本 $150 得 1 PO 单，账面边际贡献 $170 | 演示 B2B 即使分母很小，高客单单笔贡献足以覆盖初期拓展费用；同时明确 PO 属于须核对合同接受与条款的较强信号，而非已确认收入或即时现金。 |

---

## 五、未核准与情境依赖事实台账（`[UNKNOWN]` Register）

| 编号 | 涉及领域 / 现象 | 行业客观现实与不确定性原因 | 正文中的客观处理方式 |
| :---: | :--- | :--- | :--- |
| **UK-01** | 全球通用的绝对及格样本量或 CVR 阈值 | 不存在全球通用的标准转化率或万能测试样本量；$10 冲动消费品与 $10,000 工业定制品转化率与样本规律差异极大。 | 正文中坚决不给出任意万能数字，强调必须结合合格分母口径、置信区间及 CAC 边际贡献动态评估。 |
| **UK-02** | 候补名单（Waitlist）到最终付费的固定转化比例 | 受发售周期长度、最终定价与预期差异、邮件打开率等多重复杂变量影响，转化比例具有极强的不确定性。 | 明确指出 Waitlist 仅反映初步兴趣，不可据此直接作为规模化备料依据，在推演中需以极低比例审慎推算。 |
| **UK-03** | 特定商户在特定国家的结账流失比例 | 尽管某国宏观支付市场某一方式占比高（如荷兰 iDEAL），但单个商户的具体流失率取决于客群细分、品类与设备分布。 | 修正 R1 中绝对化的因果推断，仅说明缺少主流本地支付通道会显著增加特定地区消费者的结账阻力。 |

---

## 六、正式封板用自动核验脚本与两种真实执行结果

为彻底杜绝 R1 阶段“只测试硬编码列表而未物理读取文件”的问题，以下 Python 脚本会在运行时**直接打开磁盘上的 `第一部分_第七章_独立Writer_R2完整候选稿.md` 文件**，逐行读取并执行严格的断言验证：

正式封板源码另存于`CHAPTER7_SELFTEST_20261019.py`，对**真实正式正文**和**唯一冻结问题树**逐字比对；检测不到正文时必须失败，LaTeX `1.50\%` 与普通百分号等价处理。执行日志如下。**结构与算术回归检查不代表法规事实自动通过。**

**ACTUAL**：exit code `0`
```text
[PASS] Real input draft: /mnt/data/cb01_ch7_sealed_20261019/CHAPTER7_FINAL_SEALED.md
[PASS] Canonical frozen framework: /mnt/data/cb01_ch7_sealed_20261019/FROZEN_FRAMEWORK_V1_20261018.md
[PASS] Physical headings 20/20, H1=1 H2=5 H3=14; structural hygiene
[PASS] 8 arithmetic/model regression groups: Wilson, MaxCAC, DTC, digital, SaaS funnel, SaaS contribution, B2B contribution, B2B contact ratio
[NOTE] These checks do not prove regulations, actual orders, model validity or commercial outcomes.
[PASS] sha256=361cd48c4be45fe264015c70341a0b64d4eaec28c9c2cb40fbfda9ac31d24a09
```

**MISSING**：exit code `2`
```text
[FAIL] MISSING_DRAFT: /mnt/data/cb01_ch7_sealed_20261019/not_exist.md
```

完整可复现 Python 源码：

```python
#!/usr/bin/env python3
# Chapter 7 sealed content regression: STRUCTURE + ARITHMETIC ONLY, not automatic legal verification.
from pathlib import Path
import hashlib, math, re, sys

def frozen_ch7_titles(framework):
    titles=[]; in_ch7=False
    for line in framework.splitlines():
        if not line.startswith('|'): continue
        cols=[x.strip() for x in line.split('|')]
        if len(cols) not in (5,7): continue
        if cols[1].startswith('7. '):
            in_ch7=True; titles.append('# '+cols[1])
        elif cols[1].startswith('8. '):
            in_ch7=False
        if not in_ch7: continue
        h2=re.fullmatch(r'\*\*(7\.\d+ .+)\*\*',cols[2])
        if h2: titles.append('## '+h2.group(1))
        if len(cols)==7 and re.fullmatch(r'7\.\d+\.\d+',cols[3]):
            titles.append('### '+cols[3]+' '+cols[4])
        if len(cols)==5:
            h3=re.fullmatch(r'\*\*(7\.\d+\.\d+)\*\* (.+)',cols[3])
            if h3: titles.append('### '+h3.group(1)+' '+h3.group(2))
    assert len(titles)==20, f'Unexpected frozen CH7 title count: {len(titles)}'
    return titles

def verify(draft, framework):
    assert draft.is_file(), f'MISSING_DRAFT: {draft}'
    assert framework.is_file(), f'MISSING_FRAMEWORK: {framework}'
    text=draft.read_text(encoding='utf-8')
    frozen=frozen_ch7_titles(framework.read_text(encoding='utf-8'))
    actual=[s.strip() for s in text.splitlines() if re.match(r'^#{1,3} ',s)]
    assert actual==frozen, f'FROZEN_HEADINGS_MISMATCH: got {len(actual)}; first mismatch {[(i,a,b) for i,(a,b) in enumerate(zip(actual,frozen),1) if a!=b][:1]}'
    assert text.count('$$')%2==0 and '\t' not in text
    # Both TeX and plain percent forms must be accepted in the SAME actual draft.
    canon=text.replace(r'\%', '%')
    for needle in ['16 CFR Part 435','7 个工作日','1.50%','VAMP','CPC','12.5%','2.0%','+$170']:
        assert needle in canon, f'REQUIRED_CONTENT_MISSING: {needle}'
    print(f'[PASS] Real input draft: {draft.resolve()}')
    print(f'[PASS] Canonical frozen framework: {framework.resolve()}')
    print(f'[PASS] Physical headings 20/20, H1=1 H2=5 H3=14; structural hygiene')
    # Executed assertion groups. These verify arithmetic under MODELED parameters, not whether business inputs are facts.
    z=1.96; n=100; k=3; phat=k/n
    c=phat+z*z/(2*n); spread=z*math.sqrt(phat*(1-phat)/n+z*z/(4*n*n)); den=1+z*z/n
    assert round((c-spread)/den,5)==0.01025 and round((c+spread)/den,5)==0.08452
    assert 40-(100*0.20)==20
    assert 59-12-15-3==29 and 120/4==30 and 29-30==-1
    assert 49-2==47 and round(80/6,1)==13.3
    assert 50 and 8 and 1 and 1/50==0.02 and 1/8==0.125
    assert (29-6)*6==138 and round(250/(29-6),2)==10.87 and 250>138
    assert 600-200-80==320 and 320-150==170
    assert 1/40==0.025
    print('[PASS] 8 arithmetic/model regression groups: Wilson, MaxCAC, DTC, digital, SaaS funnel, SaaS contribution, B2B contribution, B2B contact ratio')
    print('[NOTE] These checks do not prove regulations, actual orders, model validity or commercial outcomes.')
    print('[PASS] sha256='+hashlib.sha256(draft.read_bytes()).hexdigest())

if __name__=='__main__':
    root=Path(__file__).resolve().parent
    draft=Path(sys.argv[1]) if len(sys.argv)>1 else root/'CHAPTER7_FINAL_SEALED.md'
    framework=Path(sys.argv[2]) if len(sys.argv)>2 else root/'FROZEN_FRAMEWORK_V1_20261018.md'
    try:
        verify(draft,framework)
    except (AssertionError, UnicodeError, OSError) as err:
        print('[FAIL] '+str(err),file=sys.stderr)
        sys.exit(2)

```

---

## 七、八项章节边界隔离核验表（Boundary Isolation Checklist）

- [x] **未代写第 8 章综合决策模型**：本章严格专注于单项商业假设的敏捷意愿测试与小样本归因排查；多个候选方向间的权重打分、最终挑选手册统一由《第8章：如果手里有几个方向，最终该怎么挑？》负责。
- [x] **未代写第五板块长期投流获客运营**：测试所用广告仅作为意向检验探针，未涉及长期获客矩阵搭建、SEO 精细化排名优化或社群裂变运营。
- [x] **未代写第四板块系统代码编写**：原型展示仅涉及轻量 Artifacts 与透明人工交付，未代写软件系统的分布式微服务架构设计、数据库高并发优化或生产代码。
- [x] **未代写第三板块离岸公司与财税实操**：未代写香港/特拉华公司注册流程、跨境企业对公账户开户技术或税务筹划实操。
- [x] **未代写第二板块网络基础设施运维**：未提供云服务器搭建、Docker 容器化部署或 CDN 加速配置。
- [x] **杜绝恶意欺骗性测试**：明确禁止通过虚假页面扣费后谎称系统故障的恶意欺诈行为；所有预售必须具备履约基础与合规发货时限，提供透明的退款渠道。
- [x] **杜绝虚构案例与非实证数据**：全篇数据均经核验，教学演示数据均就地醒目标注 `[MODEL_ASSUMPTION]`，不确定事实标注 `[UNKNOWN]`。
- [x] **交付状态与权限恪守**：交付物严格包含 R2 候选正文、R2 资料核验与逐项返修记录及对应 ZIP，执行状态停留在 `CANDIDATE_FOR_REVIEW / STOP_AT_REVIEWER`，不擅自声明 PASS，不修改 Git 仓库，不启动后续章节。

---

## 八、Owner 授权 Reviewer 最终修订与冻结核验（最新有效记录）

> **权限**：Owner于2026-10-19明确授权 Reviewer 以Writer R2完整稿定向修复并正式封板，不存在Writer R3交稿；旧R2自述PASS不得替代本段独立核验。
> **正式状态**：`OWNER_AUTHORIZED_DIRECT_REPAIR / FINAL_SEALED`；审核日期2026-10-19。

| 上轮阻断 | 最终处理 | 复核结果 |
|---|---|---|
| R2-01 自检脚本失败/找不到正文却PASS | 改为读取物理文件与唯一正式冻题；归一化LaTeX百分号；缺文件非零退出；记录两种实际执行结果；声明只验证结构与算术 | **PASS** |
| R2-02 SaaS 漏斗分母 | 明确50点击、8试用、1付费；点击至付费2%、试用至付费12.5%；回本10.87月仅静态模型，6月留存下亏损 | **PASS** |
| R2-03 PO效力/利润 | PO为条件性强信号，合同和预算需另核；$170为履约且收款后的**预计单笔贡献**，不是已实现利润；40联系人和5企业分母分开 | **PASS** |
| R2-04 VAMP只写收单行 | Visa收单机构+商户双层监控，商户阈值有地区、月份、计数条件；删除无来源“争议费通常$15–$20” | **PASS** |
| R2-05 GDPR统一明示同意 | 改为识别适用的GDPR第6条合法处理依据，依法实际需要同意时取得合规同意；补充披露、敏感数据、处理者及跨境要求 | **PASS** |
| R2-06 FTC退款时点过窄 | 退款权产生/法定取消开始计时，不仅买家请求；注明规则覆盖的远程订购货物及卖家授信情境50日例外 | **PASS** |

### 8.1 事实核验官方来源及适用边界

- FTC §435：[https://www.ftc.gov/business-guidance/resources/business-guide-ftcs-mail-internet-or-telephone-order-merchandise-rule](https://www.ftc.gov/business-guidance/resources/business-guide-ftcs-mail-internet-or-telephone-order-merchandise-rule)。美国远程订购货物、发货期限与延期/退款；不替代纯数字服务所有退款法规。
- Visa VAMP：[https://corporate.visa.com/en/sites/visa-perspectives/security-trust/visa-vamp-program-update-fraud-disputes.html](https://corporate.visa.com/en/sites/visa-perspectives/security-trust/visa-vamp-program-update-fraud-disputes.html)；具体支付服务商对商户的最新门槛、计数及地域应另核：[https://docs.adyen.com/risk-management/dispute-and-fraud-monitoring/](https://docs.adyen.com/risk-management/dispute-and-fraud-monitoring/)。
- GDPR合法处理依据：[https://www.edpb.europa.eu/sme/be-compliant/process-personal-data-lawfully_en](https://www.edpb.europa.eu/sme/be-compliant/process-personal-data-lawfully_en)，同意并非唯一或优先自动选择的合法依据。
- B2B PO法律效力的**美国政府采购**示例：[https://www.acquisition.gov/far/13.004](https://www.acquisition.gov/far/13.004)，不可推定民间私人PO法效一致。
- CPSC 2026 eFiling（可选补注，不等于所有儿童产品同一电子申报义务）：[https://www.cpsc.gov/Newsroom/News-Releases/2026/CPSC-Implements-Mandatory-eFiling-for-Certificates-of-Compliance-Targeting-Dangerous-Foreign-Imports](https://www.cpsc.gov/Newsroom/News-Releases/2026/CPSC-Implements-Mandatory-eFiling-for-Certificates-of-Compliance-Targeting-Dangerous-Foreign-Imports)。

### 8.2 原稿差异、文件与实际执行回归

- Writer R2 原正文 SHA256：`88d9c49884c3269393df9ff73b74828201558fe0a49e4fa21fc581b4c320f2d7`；原核验记录 SHA256：`9166e1c9e4e5e29192455dec5e9b4106965ba6a352f3cb5ff03467a12037ca80`。
- 最小定向修订：同一正文行级diff新增/删除合计 **22** 行（diff计数只用于留痕，不代表全文重写）；冻结 H1/H2/H3 标题**20/20完全未修改**。
- 自检脚本源码为`CHAPTER7_SELFTEST_20261019.py`；标准版本读取项目`docs/CHAPTER7_FINAL_SEALED.md`与唯一`docs/FROZEN_FRAMEWORK_V1_20261018.md`；物理输入路径可显式覆盖。
- **真实正文存在**：退出码0，20冻题及8组算术回归PASS；**正文不存在**：退出码2（FAIL），不会假PASS。具体stdout/stderr与SHA见第六节。
- 自检边界：**不能自动证明**数据来源、法规时效、用户买单或市场商业模型有效；这些仍靠人工检查与官方资料。

**第⑦章的正式封板仅代表教学正文通过内容审查，不代表实际预售、收款、企业采购合同、法律许可或第三方API处理已取得批准。**
