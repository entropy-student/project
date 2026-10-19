# 第一部分 第六章 R2 资料核验与逐项返修记录

## 1. 交付元数据与状态声明

* **文档标识**：`CB01-CH6-INDEPENDENT-OFFLINE-R2-REVISION-20261019`
* **执行角色**：独立 Writer（第一板块 第⑥章《这门生意有哪些不能忽视的门槛？》R2 最小定向返修）
* **对应正文**：`第一部分_第六章_独立Writer_R2完整候选稿.md`
* **基线文件**：基于 Reviewer R1 返修包之 `02_Writer_R1完整正文原样保留.md` 与 `03_Writer_R1资料核验原样保留.md`
* **返修依据**：严格落实 `01_独立Reviewer_R1完整审核报告.md`（R1-01 至 R1-12）及 `05_官方事实核验与支持边界.md`
* **终结停点**：`CANDIDATE_FOR_REVIEW / STOP_AT_REVIEWER`
* **返修原则**：
  * **最小修改原则**：保留原稿有价值的知识架构、检索路径、四业态准入分析、Mermaid流程图与综合决策矩阵；
  * **逐字保留冻结题树**：1个一级标题、3个二级标题、10个三级标题（共14个核心标题）原文、层级、顺序与归属绝对不变；
  * **官方事实一致性**：所有法律法规、监管标准、时效时点与例外豁免均以一手权威公报为准，同步修正正文与核验台账；
  * **规范模型与未知标注**：教学算例与推演标注 `[MODEL_ASSUMPTION]`，前置期无法确证的事项标注 `[UNKNOWN]` 并提供第二验证路径；
  * **代码与格式严密性**：修复全部公式与箭头转义错误，全文保持零制表符（`\t`），代码脚本明确实际检验边界。

---

## 2. 14个已冻结标题 100% 逐字同序比对表

| 序号 | 层级 | 冻结标题原文 | R2正文对应标题 | 归属与顺序一致性 | 状态 |
| :---: | :---: | :--- | :--- | :---: | :---: |
| 1 | H1 | `# 6. 这门生意有哪些不能忽视的门槛？` | `# 6. 这门生意有哪些不能忽视的门槛？` | 完全一致 | 命中 |
| 2 | H2 | `## 6.1 怎么知道自己的产品有没有侵权风险？` | `## 6.1 怎么知道自己的产品有没有侵权风险？` | 完全一致 | 命中 |
| 3 | H3 | `### 6.1.1 名称、品牌、外观和技术方案，哪些权利需要提前查？` | `### 6.1.1 名称、品牌、外观和技术方案，哪些权利需要提前查？` | 完全一致 | 命中 |
| 4 | H3 | `### 6.1.2 使用图片、字体、音乐或开源代码时，授权范围怎么核对？` | `### 6.1.2 使用图片、字体、音乐或开源代码时，授权范围怎么核对？` | 完全一致 | 命中 |
| 5 | H3 | `### 6.1.3 自己查不到侵权记录，就能放心卖了吗？` | `### 6.1.3 自己查不到侵权记录，就能放心卖了吗？` | 完全一致 | 命中 |
| 6 | H2 | `## 6.2 想卖到某个国家，需要符合哪些规定？` | `## 6.2 想卖到某个国家，需要符合哪些规定？` | 完全一致 | 命中 |
| 7 | H3 | `### 6.2.1 实体商品进入目标国家前，哪些安全、标识和进口规则可能适用？` | `### 6.2.1 实体商品进入目标国家前，哪些安全、标识和进口规则可能适用？` | 完全一致 | 命中 |
| 8 | H3 | `### 6.2.2 包装、电池、电子产品等还可能承担哪些环保回收义务？` | `### 6.2.2 包装、电池、电子产品等还可能承担哪些环保回收义务？` | 完全一致 | 命中 |
| 9 | H3 | `### 6.2.3 软件、数字产品和在线服务需要留意哪些用户与数据规则？` | `### 6.2.3 软件、数字产品和在线服务需要留意哪些用户与数据规则？` | 完全一致 | 命中 |
| 10 | H3 | `### 6.2.4 规定因国家和时间不同而变化，我该怎样找到可靠的现行依据？` | `### 6.2.4 规定因国家和时间不同而变化，我该怎样找到可靠的现行依据？` | 完全一致 | 命中 |
| 11 | H2 | `## 6.3 哪些产品不能卖，哪些需要特殊资质？` | `## 6.3 哪些产品不能卖，哪些需要特殊资质？` | 完全一致 | 命中 |
| 12 | H3 | `### 6.3.1 法律允许卖的东西，平台或应用商店也一定允许上架吗？` | `### 6.3.1 法律允许卖的东西，平台或应用商店也一定允许上架吗？` | 完全一致 | 命中 |
| 13 | H3 | `### 6.3.2 哪些商品或服务在经营前必须取得资格或特殊批准？` | `### 6.3.2 哪些商品或服务在经营前必须取得资格或特殊批准？` | 完全一致 | 命中 |
| 14 | H3 | `### 6.3.3 产品合法，却没有可行的运输或交付方式怎么办？` | `### 6.3.3 产品合法，却没有可行的运输或交付方式怎么办？` | 完全一致 | 命中 |

*比对结论：全章仅包含上述14个 `#`、`##`、`###` 标题，正文中所有细分段落标题均规范使用 `####`（H4）或粗体，层级结构100%无缝吻合。*

---

## 3. R1-01 至 R1-12 逐项返修对照记录

| 阻断编号 | 问题分类 | 原R1存在问题与影响 | R2最小定向修改措施与正文对应位置 | 权威依据来源与支持边界 |
| :---: | :---: | :--- | :--- | :--- |
| **R1-01** | GPL/AGPL开源许可边界 | 将AGPLv3第13条误解为“SaaS调用即强制公开完整独立后端源码”；将GPL静态链接或组合一律定性为必然传染整个商业项目。 | 1. 修正 6.1.2 许可证图示（Mermaid）及正文；<br/>2. 阐明AGPL第13条仅在**修改受保护程序**并通过网络向交互用户提供服务时，触发提供该修改版及对应源码（Corresponding Source）的义务，独立未修改的后端服务通过网络通信不被强制传染；<br/>3. 明确GPL派生作品与独立程序的IPC/Socket解耦边界；<br/>4. 同步修正 6.3.3 总结矩阵中的定性。 | GNU AGPLv3 Text Section 13 (`https://www.gnu.org/licenses/agpl-3.0.html`); GNU GPL FAQ (`https://www.gnu.org/licenses/gpl-faq.en.html`). |
| **R1-02** | 知识产权程序与法定赔偿 | 将美版权法定最高15万美元赔偿及律师费写成无条件主张；将专利18个月保密写成无例外；将EUIPO检索说成覆盖27国全部独立国家商标；断言Aypod必被法庭瞬间认定侵权。 | 1. 6.1.1 明确 17 U.S.C. § 504(c) 标准法定赔偿区间为750~30,000美元，最高15万美元仅限法官裁量之**故意侵权（Willful）**，且受 § 412 登记时限约束，律师费依 § 505 裁量；<br/>2. 补充 35 U.S.C. § 122(b) 申请人主动提前公开及未在外国申请时的“不公开请求”例外；<br/>3. 明确 EUIPO eSearch 检索欧盟商标（EUTM），检索成员国本国商标需通过 TMview；<br/>4. 将 Aypod 案例标注 `[MODEL_ASSUMPTION]` 并改为混淆可能性多要素测试分析。 | US Copyright Office Title 17 §§ 411, 412, 504, 505 (`https://www.copyright.gov/title17/92chap4.html`); USPTO MPEP § 1120 (`https://www.uspto.gov/web/offices/pac/mpep/s1120.html`); TMview (`https://www.tmdn.org/tmview/`). |
| **R1-03** | TRO与缺席判决程序 | 把法院一律秘密签发TRO、冻结划扣、自动缺席判决写成普遍流程；将律所费用1~3万美元及和解率30%~70%冒充“统计中位数”；给出规避冻结的指引。 | 1. 修正 6.1.3 流程图与正文，阐述 FRCP 65(b) 单方TRO需满足“即时不可弥补损害”严格宣誓举证；<br/>2. 明确单方TRO法定期限通常不超过14天，初步禁令需经通知（Rule 65(a)）；<br/>3. 厘清 FRCP 55 缺席认定与判决的两步走程序；<br/>4. 将和解比例与诉讼费用严格标注为教学模拟情景 `[MODEL_ASSUMPTION]`，删除“统计中位数”表述；<br/>5. 删除资产回避引导，替换为通过 PACER 调取案卷、核验权利凭证、申请变更动议（Rule 65(b)(4)）或理性协商等合法途径。 | Federal Rules of Civil Procedure Rule 65 & Rule 55 (`https://www.law.cornell.edu/rules/frcp/rule_65`, `https://www.law.cornell.edu/rules/frcp/rule_55`). |
| **R1-04** | 美国产品认证与FDA条件 | CPC证书无条件限定全项测试且核验表误写实验室代签；将铅/邻苯限制普适化；MoCRA化妆品遗漏小微企业豁免；FDA医疗规费沿用FY2025且武断断定一词定性。 | 1. 6.2.1 明确CPC由负责的国内制造商或进口商自行签发（基于认可实验室报告），修正原核验表冲突；<br/>2. 补充 16 CFR Part 1500.91 未经处理天然木材/棉花等总铅测试豁免，明确邻苯主要针对玩具及护理品可塑化塑料；<br/>3. 补充 MoCRA（FD&C Act § 612）3年销售额低于100万美元之小微企业设施登记与列名豁免及高风险排除；<br/>4. 6.3.2 由Reviewer按2026-10-19核验修正为 FY2027 $13,785（FY2026 $11,423），并补合格小企业非首次注册豁免及缴费主体，解释 21 CFR § 801.4 预期用途综合判定标准。 | CPSC CPC FAQs (`https://www.cpsc.gov/FAQ/CPC`); CPSC 16 CFR Part 1500.91; FDA MoCRA Guidance (`https://www.fda.gov/cosmetics/cosmetics-laws-regulations/modernization-cosmetics-regulation-act-2022-mocra`); FDA MDUFA User Fees (`https://www.fda.gov/medical-devices/premarket-submissions-selecting-and-preparing-correct-submission/medical-device-user-fee-amendments-mdufa`). |
| **R1-05** | 欧盟CE/GPSR与国别标签 | 将CE写为所有商品进EEA通行证；GPSR要求所有卖家必买欧代；英国CE承认范围扩大化；美国Made in China标签遗漏J-List豁免。 | 1. 6.2.1 强调CE仅适用于特定协调指令管辖品类（约25项），非受控品禁止打CE；<br/>2. 阐明 GPSR 与专门协调指令之特别法（Lex specialis）补充关系；<br/>3. 依据 GPSR 第16条明确欧盟境内责任人可以为欧盟进口商（清关进口商依法自担责任，无需另聘代表）、授权代表或履约服务商；<br/>4. 明确英国 DBT 承认CE仅涵盖其管辖的18项具体法规，北爱尔兰遵循温莎框架；<br/>5. 补充美国 19 CFR § 134.32 原产国标记法定豁免（J-List等）。 | EU CE Marking Guide (`https://commission.europa.eu/single-market/goods/building-blocks/ce-marking_en`); EU GPSR Q&A (`https://webgate.ec.europa.eu/safety/consumers/consumers_safety_gate/obligationsForBusinesses/documents/Q%26A.pdf`); UK DBT Guidance (`https://www.gov.uk/guidance/using-the-ukca-marking`); US 19 CFR Part 134. |
| **R1-06** | EPR与电池法规豁免 | 德国EPR将所有外国卖家统一为生产者且混淆包装类别；电池法2027年便携电池拆卸遗漏Art 11法定例外；法国Triman罚款虚构“每件1.5万欧”。 | 1. 6.2.2 区分德国 VerpackG 生产者定义与B2C/B2B包装类型，明确LUCID注册与双元制系统参与合同的适用差异；<br/>2. 准确标注欧盟新电池法规 (EU) 2023/1542 Article 11 用户拆卸要求于 **2027年2月18日** 适用，详列防溅水/水下防水设备、专业医疗诊断及持续供电保障等法定例外（允许专业人员更换）；<br/>3. 依法国《环境法典》第 L. 541-9-4 条，更正 Triman 标识违规罚款为自然人最高3,000欧、法人最高15,000欧（按违规行为裁量，非每件商品累加）。 | Regulation (EU) 2023/1542 Article 11 (`https://eur-lex.europa.eu/eli/reg/2023/1542/oj`); ZSVR VerpackG Guidance (`https://www.verpackungsregister.org/en/`); French Code de l'environnement Art. L. 541-9-4. |
| **R1-07** | 数据与数字服务法规适用条件 | 图示CCPA写为“禁止出售”；COPPA遗漏法定例外；EAA 2025年时态错乱且微企豁免解释不准；AI Act Art 50未区分提供者/部署者及数字水印例外。 | 1. 6.2.3 图示与正文更正 CCPA/CPRA 为“退出/限制个人数据出售与共享权”，列明2500万美元营收等管辖门槛；<br/>2. 补充 COPPA（16 CFR § 312.5(c)）仅用于直接通知家长、单次响应儿童特定请求等免于事前VPC的例外；<br/>3. 明确 EAA 已于 **2025年6月28日强制施行**，微企纯服务豁免仅免除线上服务要求，不免除受控硬件制造标准；<br/>4. 依据 AI Act Article 50 细分提供者（生成内容机器可读标记，免除辅助文本编辑）与部署者（深度伪造披露，免除艺术讽刺创作）；<br/>5. 补充 GDPR 第五章除SCCs外之其他合法跨境机制。 | EU AI Act Article 50 (`https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-50`); European Accessibility Act (`https://commission.europa.eu/strategy-and-policy/policies/justice-and-fundamental-rights/disability/european-accessibility-act-eaa_en`); FTC COPPA FAQs (`https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions`). |
| **R1-08** | App Store与卡组织风控政策 | 苹果IAP外链政策过时，忽视美区与欧盟DMA调整；卡组织拒付0.9%被断言必进MATCH、永久封杀；Stripe一律禁止VPN。 | 1. 6.3.1 更新苹果 Guideline 3.1.1 现状：按Apple 2026-10-16官方指南，美区外链无需该Entitlement；12%/27%旧外链费不能作为现行统一规则，欧盟支持DMA第三方应用市场与外链；<br/>2. 明确Visa原VDMP属于历史旧制，现行VAMP替代后须按地区和收单机构文件核对指标、收单行处罚与保证金要求；澄清 MATCH 系协议终止时的同业警示库，非单次波动的全网永久封杀；<br/>3. Stripe 政策区分绝对禁止品与受限审查品，明确正规合规VPN不属于禁售范畴。 | Apple Review Guidelines (`https://developer.apple.com/app-store/review/guidelines/`); Apple News Update (`https://developer.apple.com/news/?id=92th7e5i`); Stripe Restricted Businesses (`https://stripe.com/legal/restricted-businesses`). |
| **R1-09** | 美国EAR加密管制泛化 | 仅使用GitHub/AWS或加密库即断言受EAR管辖，称所有用AES的App每年必须向BIS报送自分类报告。 | 1. 6.3.2 依据 15 CFR § 734.3 厘清 EAR 实际管辖连接点（美国境内物项、美国原产、超25%最低成分等），说明无限制开源软件不受EAR管辖（§ 734.7）；<br/>2. 依据 15 CFR § 740.17(b)(1) 解释大众市场加密软件 ENC 许可例外；<br/>3. 明确年度自分类报告（§ 740.17(e)(3)）仅适用于未获 CCATS 正式分类的特定出口实体，说明应用商店问卷中仅使用操作系统标配加密（如 HTTPS）免于提报。 | BIS Encryption Controls (`https://www.bis.gov/learn-support/encryption-controls/encryption-items-not-subject-to-ear`); BIS Annual Self-Classification (`https://www.bis.gov/learn-support/encryption-controls/annual-self-classification`). |
| **R1-10** | 锂电、磁性与雷西法案口径 | 仅以100Wh作是否第9类危险品界限；磁场换算错误（0.00525高斯算错4个数量级）；雷西法案将包装纳入申报且沿用失效纸质申报。 | 1. 6.3.3 明确锂电池全系属于第9类危险品（UN 3480/3481），区分PI965 IA/IB、PI966及PI967 I/II的不同包装说明和2026 SoC要求；纯电池（PI 965）仅限货机且荷电不超过30%；<br/>2. 纠正 IATA DGR PI 953 磁场物理换算：**0.00525 高斯在空气中约为 0.418 A/m（或 0.525 μT）**；<br/>3. 依据 16 U.S.C. § 3372(f)(3) 明确专用于支承保护货物的包装材料（纸箱、托盘）法定豁免植物申报；<br/>4. 更新 USDA APHIS 现行政策：**自2026年1月1日起全面废除纸质 PPQ 505 表格**，统一采用 CBP ACE 或 APHIS LAWGS 电子申报。 | IATA Lithium Battery Guidance 67th Edition (`https://www.iata.org/en/programs/cargo/dgr/lithium-batteries/`); APHIS Lacey Act Declaration (`https://www.aphis.usda.gov/plant-imports/file-lacey-act-declaration`); APHIS Requirements (`https://www.aphis.usda.gov/plant-imports/file-lacey-act-declaration/requirements`). |
| **R1-11** | 2026年OFAC叙利亚制裁现状 | 仍将叙利亚列为全面制裁国家，宣称一律禁运并强制SaaS部署全球IP阻断。 | 1. 6.3.3 流程图、正文及总结表全面更新：**OFAC已于2025年7月1日终止叙利亚全面制裁法规（31 CFR Part 542），并于2026年8月进一步取消相关涉恐限制**；<br/>2. 明确当前全面领土禁运管辖仅限于：古巴、伊朗、朝鲜及乌克兰受冲突影响地区（克里米亚、顿涅茨克、卢甘斯克）；<br/>3. 阐明针对叙利亚转为特定名单制裁（SDN）及出口管制，明确出海SaaS合规重点在于交易对手名单筛查与风险防控，非无差别IP全面切断。 | OFAC Syria Sanctions FAQs (`https://ofac.treasury.gov/faqs/1220`); OFAC PAARSS Syria Country Information (`https://ofac.treasury.gov/sanctions-programs-and-country-information/syria-sanctions`). |
| **R1-12** | 资料核验台账同口径重构 | 来源仅给首页、事实冲突、模型标记与未知标记单一且未覆盖正文、公式箭头转义错误（`$ightarrow$`）、测试脚本过度断言。 | 1. 全面重构核验记录，逐项提供法条精确条号、具体子页面URL、管辖范围与生效日期；<br/>2. 修正 6.2.4 中数学公式箭头为规范的 `→`；<br/>3. 正文与核验记录同步标注 `[MODEL_ASSUMPTION]`（Aypod近似案、TRO和解场景、额定能量电学换算）与 `[UNKNOWN]`（私模在先冲突状态、特定软件加密分类状态、木制品树种未定状态）；<br/>4. 更新自动化脚本，准确定义校验范围（标题、格式、结构、特征锚点）。 | 全文24项一手官方条文比对，两份交付文档全面咬合。 |

---

## 4. 官方来源与证据边界登记表（关键问题核实至2026-10-19；不得理解为所有法规已全量核准）

| 序号 | 监管机构 / 组织 | 法规标准名称 / 检索系统 | 具体条号 / 系统入口 | 官方权威来源 URL | 适用地区与对象 | 核心合规要点与豁免条件 |
| :---: | :---: | :--- | :--- | :--- | :---: | :--- |
| 1 | 美国 (USPTO) | Trademark Search System / Lanham Act | 15 U.S.C. § 1125(a) | `https://www.uspto.gov/trademarks/search` | 美国全境 | 官方商标库；2025年1月18日施行新规费（电子基础申请费350美元/类）；先使用原则保护普通法权利。 |
| 2 | 欧盟 (EUIPO) | eSearch Plus / EUTM 体系 | 欧盟商标法规 | `https://euipo.europa.eu/eSearch/` | 欧盟27国 | 检索全境有效的欧盟商标（EUTM）；先申请原则。 |
| 3 | 国际联合 (TMview) | TMview 多局商标统一检索门户 | 成员国及地区联合库 | `https://www.tmdn.org/tmview/` | 全球多国/欧盟成员国 | 一站式检索欧盟27个成员国各自独立的国家级注册商标及国际组织商标。 |
| 4 | 国际 (WIPO) | Global Brand Database / 马德里协定 | 马德里国际注册体系 | `https://www.wipo.int/reference/en/branddb/` | WIPO成员国 | 跨国商标检索；覆盖马德里国际注册及部分同步国家局数据。 |
| 5 | 美国 (USPTO) | 35 U.S.C. § 122(b) 专利公布规则 | 35 U.S.C. § 122(b)(1)-(2) | `https://www.uspto.gov/web/offices/pac/mpep/s1120.html` | 美国发明专利 | 优先权日起满18个月公布；申请人可主动提早公布；未在国外申请者可递交不公开请求。 |
| 6 | 美国 (USCO) | 17 U.S.C. §§ 411, 412, 504, 505 | 版权救济与法定赔偿 | `https://www.copyright.gov/title17/92chap4.html` | 美国版权诉讼 | 诉前登记为起诉前置；法定赔偿标准为750~30,000美元；故意侵权上限15万美元由法官裁量；登记时限影响法定赔偿。 |
| 7 | 开源基金会 (FSF) | GNU AGPLv3 / GPLv3 | Section 13 (Remote Network) | `https://www.gnu.org/licenses/agpl-3.0.html` | 开源与SaaS软件 | 修改版AGPL程序通过网络提供交互时，须向交互用户提供该修改版及对应源码；独立未修改后端服务不被强制传染。 |
| 8 | 美国联邦法院 | Federal Rules of Civil Procedure | Rule 65 & Rule 55 | `https://www.law.cornell.edu/rules/frcp/rule_65` | 联邦民事诉讼 | Rule 65(b) 单方TRO须举证不可弥补损害且最长14天；初步禁令须通知；Rule 55 缺席认定与判决分步审查。 |
| 9 | 美国 (CPSC) | CPSIA (15 U.S.C. § 2051) / CPC规则 | 16 CFR Part 1500.91 & 1307 | `https://www.cpsc.gov/Business--Manufacturing/Business-Education/childrens-products` | 12岁及以下儿童产品 | 境内生产由国内制造商、境外生产由负责的进口商签发CPC；外国制造商的测试资料符合条件时可供进口商利用；天然木材/棉花等特定总铅测试例外；邻苯限用于玩具及护理品可塑化部件。 |
| 10 | 美国 (FCC) | Title 47 CFR Part 15 | SDoC & Certification | `https://www.fcc.gov/engineering-technology/laboratory-division/general/equipment-authorization` | 射频与电子设备 | 无意发射体适用SDoC；有意发射体（Wi-Fi/蓝牙等）强制取得FCC ID并在系统完成备案。 |
| 11 | 美国 (FDA) | MoCRA 2022 化妆品现代化法案 | FD&C Act §§ 607, 612 | `https://www.fda.gov/cosmetics/cosmetics-laws-regulations/modernization-cosmetics-regulation-act-2022-mocra` | 输美化妆品设施与产品 | 设施登记与成分列名；过去3年年销售额低于100万美元之小微企业享豁免（高风险接触品除外）。 |
| 12 | 欧盟 (EU) | GPSR 通用产品安全法规 (EU) 2023/988 | Regulation (EU) 2023/988 | `https://eur-lex.europa.eu/eli/reg/2023/988/oj` | 欧盟非食品消费品 | 2024年12月13日强制实施；与专门指令互为补充；强制指定欧盟责任人（欧盟进口商依法自担责任）；实物与网页双重披露。 |
| 13 | 欧盟 (EU) | CE 标志体系指令 (LVD, EMC, RED, RoHS) | 2014/35/EU 等 | `https://commission.europa.eu/single-market/goods/building-blocks/ce-marking_en` | 欧洲经济区工业消费品 | 仅适用于约25项特定协调法规覆盖产品；需具备10年技术卷宗（TCF）与符合性声明（DoC）。 |
| 14 | 英国 (DBT) | UKCA 演进政策与CE认可 | DBT Guidance | `https://www.gov.uk/guidance/using-the-ukca-marking` | 英国大不列颠 (GB) | 针对管辖的18项法规无限期承认欧盟CE标志；北爱尔兰依据温莎框架遵循欧盟单一市场规则。 |
| 15 | 德国 (ZSVR) | VerpackG 包装法 / LUCID 体系 | VerpackG § 9 & § 7 | `https://www.verpackungsregister.org/en/` | 投放德国市场的包装物 | 首次商业投放者需注册LUCID；B2C销售包装须签订双元制系统参与合同并履行双向年度数据申报。 |
| 16 | 法国 (ADEME) | AGEC 法案 / Triman 标识体系 | Code de l'env. Art. L. 541-9-4 | `https://www.ademe.fr/` | 投放法国市场的受控品 | 加入环保组织取得IDU编号；包装强制印刷Triman及Info-tri分选图标；违规行政罚款法人最高15,000欧元。 |
| 17 | 欧盟 (EU) | 新电池法规 Regulation (EU) 2023/1542 | Article 11 (Removability) | `https://eur-lex.europa.eu/eli/reg/2023/1542/oj` | 电池全生命周期 | 便携电池终端用户可拆换要求自 **2027年2月18日** 适用；防水防溅设备、专业医疗诊断及持续供电保障享法定豁免。 |
| 18 | 欧盟 (EU) | GDPR 个人数据保护法规 (EU) 2016/679 | Article 3(2), Chapter V | `https://eur-lex.europa.eu/eli/reg/2016/679/oj` | 涉及欧盟用户数据 | 长臂管辖；非必需Cookie事前明示同意（Prior Opt-In）；数据跨境可采用标准合同条款（SCCs）等合法机制。 |
| 19 | 美国 (FTC) | COPPA (16 CFR Part 312) | 16 CFR § 312.5(c) | `https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions` | 13岁以下儿童在线服务 | 原则上需家长可核实同意（VPC）；明确仅用于直接通知家长、单次响应儿童特定请求等法定豁免情形。 |
| 20 | 欧盟 (EU) | 欧洲无障碍法案 (EAA) 2019/882 | Directive (EU) 2019/882 | `https://eur-lex.europa.eu/eli/dir/2019/882/oj` | 电商网站及数字服务 | **已于2025年6月28日强制施行**；符合 EN 301 549 规范；员工少于10人且营收低于200万欧的微型企业纯服务享豁免。 |
| 21 | 欧盟 (EU) | 人工智能法案 (EU AI Act) 2024/1689 | Article 50 (Transparency) | `https://ai-act-service-desk.ec.europa.eu/en/ai-act/article-50` | AI系统提供者与部署者 | 生成式AI输出机器可读标记（Art 50(2)，文本辅助编辑除外）；深度伪造内容强制披露（Art 50(4)，艺术讽刺作品除外）。 |
| 22 | 苹果 (Apple) | App Store Review Guidelines | Guideline 3.1.1, 2.4, 2.5 | `https://developer.apple.com/app-store/review/guidelines/` | iOS应用生态 | 美国区按Apple Guideline 3.1.1(a)允许外链且无需外链Entitlement；不得套用历史12%/27%旧费；其他地区另查授权及商务条款。 |
| 23 | 支付 (Stripe) | Restricted & Prohibited Businesses | Prohibited/Restricted Lists | `https://stripe.com/legal/restricted-businesses` | 独立站与SaaS收单 | 禁止非法金融、侵权协助工具、成人；正规VPN可作为受限业务审查；Visa现行VAMP已取代旧VDMP监控方案，阈值须查适用地区和收单文件；MATCH并非单次拒付波动后的自动永久禁用。 |
| 24 | 美国 (BIS) | EAR Export Administration Regulations | 15 CFR §§ 734.3, 740.17 | `https://www.bis.gov/learn-support/encryption-controls/annual-self-classification` | 涉及美国两用加密物项 | 厘清EAR管辖连接点；大众市场商业加密适用许可例外ENC；年度自分类报告适用于未获CCATS分类的特定出口实体；标配加密享免除。 |
| 25 | 国际航协 (IATA) | Dangerous Goods Regulations (DGR 第67版) | PI 965/966/967, PI 953 | `https://www.iata.org/en/programs/cargo/dgr/lithium-batteries/` | 航空国际货运 | 锂离子电池分PI965 IA/IB、PI966 I/II、PI967 I/II；2026年PI966 Section I和II>2.7Wh原则上≤30% SoC；磁性物2.1米与4.6米分开判定，0.00525高斯约合0.418 A/m。 |
| 26 | 美国 (APHIS) | Lacey Act 雷西法案植物申报 | 16 U.S.C. §§ 3371-3378 | `https://www.aphis.usda.gov/plant-imports/file-lacey-act-declaration` | 输美木质与植物制品 | 依据HTS编码申报；用于支承保护货物的包装材料（纸箱/托盘）法定豁免；**自2026年1月1日起全面停用纸质表，统一电子申报**。 |
| 27 | 美国 (OFAC) | OFAC 经济制裁清单与国别指引 | 31 CFR Part 500 et seq. | `https://ofac.treasury.gov/faqs/1220` | 涉及美金清算与出海业务 | 维持全面禁运地区：古巴、伊朗、朝鲜及乌克兰受冲突影响地区；**叙利亚全面制裁已于2025年7月终止、2026年8月进一步调整，转为特定SDN名单制裁**。 |
| 28 | 美国 (FDA) | FY2027 MDUFA设施年度注册费用 | 2026-10-01—2027-09-30 | `https://www.fda.gov/industry/fda-user-fee-programs/medical-device-user-fee-amendments-mdufa-fees` | 适用医疗器械设施（而非所有销售者） | FY2027 $13,785；FY2026 $11,423；合格SBD小企业可在符合财务困难条件时申请非首次注册年费豁免，首次注册不豁免。 |

---

## 5. `[MODEL_ASSUMPTION]` 建模假设与算例清单

本章教学案例与自由参数须标注 `[MODEL_ASSUMPTION]`；物理单位换算属于可核对的客观公式，不作为虚拟商业假设，杜绝将个案模拟误导为普遍统计数据：

1. **商标混淆近似教学推演案例（Aypod）**：
   * 正文标注位置：`### 6.1.1 名称、品牌、外观和技术方案，哪些权利需要提前查？`
   * 假设内容：模拟某企业将蓝牙耳机起名为“Aypod”，展示读音近似与商品竞争重合时的法律风险逻辑。
   * 假设依据：用于课堂教学的多要素比对场景，不构成对任何特定司法判决的预测。
2. **TRO 应诉与和解模拟区间**：
   * 正文标注位置：`### 6.1.3 自己查不到侵权记录，就能放心卖了吗？`
   * 假设内容：在涉案受限资金较小时，诉讼成本与和解谈判在涉案受限款项的 30%~70% 区间模拟权衡。
   * 假设依据：教学推演模型，明确指出该比例取决于涉案侵权商品的历史销售流水、利润及冻结金额个案事实，**非任何法定判决比率或行业统计中位数**。
3. **锂电池额定能量物理转换公式**：
   * 正文标注位置：`### 6.3.3 产品合法，却没有可行的运输或交付方式怎么办？`
   * 公式逻辑：$$\text{Wh} = \text{V} \times \frac{\text{mAh}}{1000}$$
   * 假设说明：标准电工学物理换算公式，用于演示电量计算；具体包装Section取决于PI965/966/967和电芯/整组阈值，不能一律归IA。

---

## 6. `[UNKNOWN]` 未知事项与次级核验路径

针对跨国实务中因特定商业上下文未确定而无法断言的客观事项，统一标注为 `[UNKNOWN]` 并提供第二路径验证指引：

1. **供应链代工厂私模的知识产权真实状态**：
   * 状态：`[UNKNOWN]`（在工厂未提供全套原始工程图纸、研发底稿，且未在目标销售国完成独立外观与发明 FTO 检索之前，无法单方面认定其没有潜在在先侵权风险）。
   * 次级核验路径：要求工厂在供货合同中设立明确的《知识产权瑕疵担保与损失追偿条款》；提取产品3D工程图与核心特征，委托专业代理人通过 Google Patents、EUIPO DesignView 开展检索。
2. **自研商业软件特定加密功能之 EAR ECCN 分类与申报豁免状态**：
   * 状态：`[UNKNOWN]`（在未对全套依赖库、算法架构与实际分发方式开展技术密码学审查前，无法断言其是否完全免于申报）。
   * 次级核验路径：梳理所用加密套件清单；比对 BIS 商业管制清单第5类第2部分技术参数；若无法明确，向 BIS 递交正式商品分类申请（CCATS）以获得确定性官方结论。
3. **复杂复合木制品树种成分之雷西法案（Lacey Act）申报归属**：
   * 状态：`[UNKNOWN]`（在未取得原木供应商出具的林权证明及材质检验单前，无法确定特定复合木料的准确拉丁学名与采伐合法性）。
   * 次级核验路径：向上游供应链索要精准拉丁属名和种名资料；对照 USDA APHIS 现行实施阶段目录确认具体 HTS 编码是否落入当期申报范围。

---

## 7. 代码级自动化校验脚本与断言报告

本章所有结构、制表符、标题同序性均通过如下内嵌 Python 脚本完成自动化断言检验。脚本明确验证文本格式规范、14个核心标题完全同序、LaTeX公式闭合及关键证据链锚点。

```python
# -*- coding: utf-8 -*-
import re
import sys
import os

def verify_chapter6_r2_draft(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        text = f.read()

    errors = []

    # 1. 检验零制表符
    if "\t" in text:
        errors.append("制表符校验失败：正文中存在制表符，必须全部替换为空格！")

    # 2. 检验 14 个核心冻结标题完整性与顺序
    frozen_headers = [
        "# 6. 这门生意有哪些不能忽视的门槛？",
        "## 6.1 怎么知道自己的产品有没有侵权风险？",
        "### 6.1.1 名称、品牌、外观和技术方案，哪些权利需要提前查？",
        "### 6.1.2 使用图片、字体、音乐或开源代码时，授权范围怎么核对？",
        "### 6.1.3 自己查不到侵权记录，就能放心卖了吗？",
        "## 6.2 想卖到某个国家，需要符合哪些规定？",
        "### 6.2.1 实体商品进入目标国家前，哪些安全、标识和进口规则可能适用？",
        "### 6.2.2 包装、电池、电子产品等还可能承担哪些环保回收义务？",
        "### 6.2.3 软件、数字产品和在线服务需要留意哪些用户与数据规则？",
        "### 6.2.4 规定因国家和时间不同而变化，我该怎样找到可靠的现行依据？",
        "## 6.3 哪些产品不能卖，哪些需要特殊资质？",
        "### 6.3.1 法律允许卖的东西，平台或应用商店也一定允许上架吗？",
        "### 6.3.2 哪些商品或服务在经营前必须取得资格或特殊批准？",
        "### 6.3.3 产品合法，却没有可行的运输或交付方式怎么办？"
    ]

    extracted_headers = []
    for line in text.splitlines():
        line_clean = line.strip()
        if re.match(r"^#{1,3}\s+", line_clean):
            extracted_headers.append(line_clean)

    if extracted_headers != frozen_headers:
        errors.append(f"标题树校验失败！期望数量: {len(frozen_headers)}, 实际提取数量: {len(extracted_headers)}")
        for i, (exp, act) in enumerate(zip(frozen_headers, extracted_headers)):
            if exp != act:
                errors.append(f"  位置 [{i}] 匹配失败：\n    期望: {exp}\n    实际: {act}")

    # 3. 检验关键官方URL与R2关键概念覆盖
    required_keywords = [
        "https://www.uspto.gov/trademarks/search",
        "https://euipo.europa.eu/eSearch/",
        "https://www.tmdn.org/tmview/",
        "https://eur-lex.europa.eu/eli/reg/2023/988/oj",
        "https://www.cpsc.gov/",
        "https://www.verpackungsregister.org/en/",
        "https://eur-lex.europa.eu/eli/dir/2019/882/oj",
        "https://stripe.com/legal/restricted-businesses",
        "https://sellercentral.amazon.com/help/hub/reference/external/200164330",
        "https://www.iata.org/en/programs/cargo/dgr/lithium-batteries/",
        "https://ofac.treasury.gov/faqs/1220",
        "[MODEL_ASSUMPTION]",
        "[UNKNOWN]"
    ]

    for kw in required_keywords:
        if kw not in text:
            errors.append(f"关键要件缺失：正文中未包含预期关键词/URL: '{kw}'")

    # 4. 检验展示级数学公式块闭合性
    math_blocks = re.findall(r'\$\$(.*?)\$\$', text, re.DOTALL)
    dollar_count = text.count('$$')
    if dollar_count % 2 != 0:
        errors.append(f"LaTeX数学公式块未对称闭合：$$ 出现次数为 {dollar_count}")

    # 5. 检验严禁伪链接与外链跨章节 Markdown 跳转
    pseudo_links = re.findall(r'\[(?:第[1-8]章|上一章|下一章)[^\]]*\]\([^)]+\)', text)
    if pseudo_links:
        errors.append(f"发现跨章节伪链接跳转：{pseudo_links}，依据规范必须使用纯书名号文本《第X章...》！")

    return errors

if __name__ == "__main__":
    if os.path.exists("第一部分_第六章_独立Writer_R2完整候选稿.md"):
        target = "第一部分_第六章_独立Writer_R2完整候选稿.md"
    elif "__file__" in globals() and os.path.exists(os.path.join(os.path.dirname(__file__), "..", "第一部分_第六章_独立Writer_R2完整候选稿.md")):
        target = os.path.join(os.path.dirname(__file__), "..", "第一部分_第六章_独立Writer_R2完整候选稿.md")
    else:
        target = os.path.join("..", "第一部分_第六章_独立Writer_R2完整候选稿.md")
    target = os.path.abspath(target)
    errs = verify_chapter6_r2_draft(target)
    if not errs:
        print("STRUCTURE_TEXT_CHECK_PASSED: 仅标题/格式/关键词等自动检查通过；不证明法规事实与政策最新状态")
    else:
        print("ASSERTION_FAILURES:")
        for e in errs:
            print(" -", e)
        sys.exit(1)
```

---

## 8. 章节边界隔离 8 点自检承诺

1. **未越界至第二板块（网络环境搭建）**：本章不提供海外VPS购买、多开防关联浏览器安装或自建专线教程，仅从合规角度解析SaaS软件网络与数据安全义务。
2. **未越界至第三板块（财税、主体与收款实操）**：本章不代写美国LLC注册、英国公司设立、海外EIN税号申请或VAT申报教学，所有商业主体仅作为法律责任人概念引用。
3. **未越界至第四板块（产品开发与落地）**：本章不提供具体硬件CAD开模规范或软件全栈代码编写，仅提供SBOM依赖扫描与技术文档TCF的合规指引。
4. **未越界至第五板块（海外投放与营销增长）**：本章不提供Facebook/Google广告投放跑单教程，仅解析商用音乐与图片版权的边界。
5. **未越界至《第7章：怎么用最少的钱，验证客户真的会买？》**：本章严格坚守准入筛查定位，明确定性“通过合规门槛不等于有人买单”，将付费验证逻辑完整交接给第7章《怎么用最少的钱，验证客户真的会买？》。
6. **未越界至《第8章》（多商业机会最终打分决策）**：本章不提供跨项目综合决策矩阵，仅提供单一项目“进/改/退”的准入过滤器。
7. **无绝对化与虚假保证断言**：全文彻底根除“包过认证”、“必定免税”、“全球通用”、“法庭绝对管不到”等违背专业常识的表述，所有风险均提示法律不确定性并建议咨询持牌律师。
8. **无事实虚构与自制标准**：自动化测试仅证明结构、关键字符串和格式满足设定规则；法规事实已对本轮列明的关键修订点作官方页面人工核对，其他跨国规则仍有需要按具体经营情境再次核验的范围，不声称100%穷尽核实。

---

## 9. 自检总结与交付状态

本章 R2 资料核验与逐项返修记录已全面归档。
14个正式标题及本轮6组Reviewer定向修订已经完成结构和关键事实对照；现有脚本只测格式与文本存在性，不代表自动证明任何法律和监管事实准确。

当前工作正式停止于：
**`CANDIDATE_FOR_REVIEW / STOP_AT_REVIEWER`**


---

## 10. Owner授权Reviewer最终修订对照（2026-10-19，优先于上文R2历史执行记录）

> 本节为**Reviewer依据Owner特别授权**在Writer R2候选之上直接追加的最终审计记录；上方“Writer R2执行清单”属于原作者当时声明，并非独立证明，也未产生不存在的Writer R3。最终正确口径以下表及已封板正文为准。

| 审核点 | 封板版最小修正 | 直接核验来源 | 边界 |
|---|---|---|---|
| R2-01 CPC | 境外制造受儿童规则约束的进口商品由负责的进口商签发；不要求进口商本人必须位于美国境内；可依法利用境外制造商的检测资料 | https://www.cpsc.gov/FAQ/CPC | 对实际进口主体、CPC和适用检测/豁免单独核定 |
| R2-01 FDA FY2027 | 当前FDA医疗器械设施年费为**$13,785**（2026-10-01起FY2027）；FY2026为$11,423；特定SBD财务困难小企业有非首次注册豁免路径 | https://www.fda.gov/industry/fda-user-fee-programs/medical-device-user-fee-amendments-mdufa-fees ; https://www.fda.gov/medical-devices/premarket-submissions-selecting-and-preparing-correct-submission/reduced-or-waived-medical-device-user-fees-small-business-determination-sbd-program | 不是所有销售商一律交设施年费；豁免审批不等于自动免交 |
| R2-02 Apple US | 2026-10-16 Guideline 3.1.1(a)美区外链无需StoreKit Entitlement；不再引用旧12%/27%外链佣金作为现行普遍义务 | https://developer.apple.com/app-store/review/guidelines/ ; https://developer.apple.com/news/?id=92th7e5i | 不推导所有交易免费或各国同规则 |
| R2-03 Visa | 旧VDMP指标不作2026现行统一红线；实际VAMP依地区、收单机构要求 | https://corporate.visa.com/en/sites/visa-perspectives/security-trust/introducing-visa-acquirer-monitoring-program.html | 不据单一指标推定自动罚款、保证金或MATCH |
| R2-04 IATA 2026 | 单独PI965为IA/IB；随设备PI966为I/II，2026新增相应SoC；装机PI967为I/II，降低SoC主要为建议 | https://www.iata.org/en/programs/cargo/dangerous-goods/lithium-batteries/ | IATA 2026 Battery Guidance只是指导资料，正式承运依适用DGR全文和实际承运人条件 |
| R2-04 磁性货物 | 区分2.1米罗盘偏转与4.6米场强；磁场0.00525G≈0.418A/m的换算不等于2.1米测试阈值；某些更强磁性包件有主管机关批准路径 | https://www.phmsa.dot.gov/regulations/title49/interp/09-0084 | 美国49 CFR另有4.5米限制，需依法域选标准 |
| R2-05 IRS | 收费准备联邦税表者通常须持PTIN，不强制全部CPA/EA；代理权/具体州资格不同 | https://www.irs.gov/tax-professionals/understanding-tax-return-preparer-credentials-and-qualifications | 不意味着任何人在各州可以无条件开展全部税务代表业务 |
| R2-06 台账 | 移除“100%法律事实自动校验”的声明；区分Writer原始结构脚本、Reviewer官方事实复核、未知事项 | 本核验记录及GitHub封板证据 | 非穷尽法务意见、非现行全球所有产品许可证明 |

**结构及回归校验**：H1=1、H2=3、H3=10，编号、文本和顺序必须与唯一冻结题树逐字一致；保留Mermaid/文章结构；在`CHAPTER6_SEAL_EVIDENCE_20261019.md`核对所有文件SHA256。**没有进行任何真实商品认证、实际App上架、危险品托运或财税代理行为。**
