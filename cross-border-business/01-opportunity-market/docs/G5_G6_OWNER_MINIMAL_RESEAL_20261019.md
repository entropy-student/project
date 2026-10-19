# 第一部分｜G5/G6 综合深审后 Owner 最小修订与再封板证据（2026-10-19）

> **OWNER_AUTHORIZED / MINIMAL_REPAIR / 8_OF_8_FINAL_SEALED / G7_SOFT_REVIEW_NEXT / BOARD_NOT_CLOSED**  
> 仓库：`entropy-student/project`；唯一权威框架：`docs/FROZEN_FRAMEWORK_V1_20261018.md`（1核心/8H1/34H2/83H3）；第8章8.2继续直接成节，不添加三级。  
> Owner决策：接受两轮Reviewer交叉评价后的最小补强建议，要求“最小化改动原则进行修正然后冻结”；下一步只允许独立Agent进行文字连贯性和可读性的软性审查。

## 一、授权、来源和事实边界

- 两轮Reviewer：总控G5独立研究先提出15项；另一全新独立Reviewer单独提供24项审查报告；交叉评价去重为A01—A19/B01—B08。最终选择为：**A01—A15定点修复或补强，A16—A19在第一板块只加必要初筛，B02、B03、B05的有限提示同步修正**。其余B类纯语言/图表瘦身不执行，留待G7。
- **现有封板八章并非全部重写**；沿用历史Writer与Owner授权Reviewer的既有责任链。本轮新加内容由总控Reviewer基于Owner明确批准**定向修订**；**不存在新独立Writer R3稿**，更不改变旧Writer R2指纹证据的历史属性。
- 研究事实、平台费用和法规结论按2026-10-19已公开资料核查；**模型示例不是现实订单、客户访谈、利润、税费核定或合规批准**。第4章Census官方入口只写了可复现查询方法，**本轮并没有实际下载 Census API 或产出观测 N/F/P 数值**，这不是已完成市场调查。
- G7 Agent 不得将教学校验通过、部分事实复核写成“所有现行法律/市场证据已经验收”；此轮无实际支付、发货或生产环境动作。

## 二、27项建议的处理决定（对应两轮合并编号）

| 编号 | 处理 | 位置与结果 |
|---|---|---|
| A01 | DONE | 5.3.1 Amazon US Consumer Electronics 8% 与 Electronics Accessories 前$100部分15%/以上8%分开；费用类别和最低费明确 |
| A02 | DONE | 4.4、5.3 加入欧盟2026-07-01实施的低值电商过渡期关税检查，区分IOSS VAT与海关税责 |
| A03 | DONE | 6.2.3 CNIL法国部分匿名站内受众测量的严格条件例外 |
| A04 | DONE | 5.3 CAC新客分母、每单成本与复购不能混称 |
| A05 | DONE | 5.3 IAS2存货成本和管理贡献双口径、同额不改变最终贡献 |
| A06 | DONE | 2.1客户访谈最小证据卡、非统计样本量标准 |
| A07 | DONE | 1.1机会线索原始来源/转载/反证记录卡 |
| A08 | PARTIAL_METHOD_ONLY | 4.1 Census CBP真实官方数据入口、具体变量及其含义；未实际取数，保留UNKNOWN，不能宣称“已完成一个有观察数值的真实市场测算” |
| A09 | DONE | 6.2 产品HS/原产地/税率/进口责任四步初筛；具体税务申报不跨板块 |
| A10 | DONE | 5.1 订阅有限期贡献与CAC示例，保留模型假设性质 |
| A11 | DONE | 4.4 双国同SKU比较标准 |
| A12 | DONE | 7.1 实验前登记卡/结果卡，禁止事后改成功标准 |
| A13 | DONE | 7.1 不同业态购买与B2B审批周期边界 |
| A14 | DONE | 8.1 明确MCDA中的证据强度不可二次加权，原X=5.75/Y=6.85不动 |
| A15 | DONE_AS_FRAMEWORK | 8.4 一页最终机会决策书和贯穿八章的透明演示，真实访谈和交易未知，不虚构 |
| A16 | DONE | 6.2四维风险前置索引，不称审核绿灯为官方许可 |
| A17 | DONE | 6.2增加中国两用物项及出口端限制初筛 |
| A18 | DONE | 6.2数字服务按目标国/行业/数据类型条件性核查 |
| A19 | DONE | 5.5最小供应商/渠道依赖检查 |
| B01 | DEFER_G7 | 差评星级的阅读与样本代表性精简 |
| B02 | DONE | 2.3定价自拟系数的教学适用边界 |
| B03 | DONE | 3.3竞争者响应五问 |
| B04 | DEFER_G7 | 第4章重复算式篇幅裁剪 |
| B05 | DONE | 5.4现金跑道的前提与现金低点 |
| B06 | DEFER_G7 | 第7章统计公式呈现次序 |
| B07 | DEFER_G7 | 第8章EVSI教学瘦身 |
| B08 | DEFER_G7 | 八章语言与图表精简（须保证不改变事实和计算） |

## 三、再次冻结的八章文件指纹（Git Blob SHA-1）

| 章节 | 当前正式Blob SHA-1 | 冻结标题数 |
|---|---|---:|
| 1 | `8fa4f10f864cf9cdda80f602e40356847e71a4fd` | 1/4/9 |
| 2 | `99e16901e68026c1355463f3c2cd729bead176ff` | 1/4/8 |
| 3 | `12e6f27b0ee2d39d8c1905c73358380241685fbe` | 1/4/9 |
| 4 | `6ef7d7781b0cdd4b4369b7a4577a9b26d55ea76b` | 1/5/11 |
| 5 | `913e9a651d1a53e1c91e832a5b8b0f63cac8ae42` | 1/5/15 |
| 6 | `66ff32d0cdba9e45651fe6c3a0749c2906b98659` | 1/3/10 |
| 7 | `82b751ed3b123252b266a6a10de371bf2f7e1632` | 1/5/14 |
| 8 | `2c522fa7df5a395d0afded5e68b4f0b0972bda2a` | 1/4/7 |

> 注意：以上是**Git Blob SHA-1**而非文件SHA-256；它们不可相互冒称。Github最终正式Commit及文件哈希以本次main最新回读为准。审查前后逐章 H1/H2/H3 标题**逐字同序一致**（合计8/34/83），代码围栏数量分别为20/22/28/30/18/22/28/22且偶数闭合；第8章 MCDA 原式5.75/6.85未改。**Python自检脚本在本轮未重新执行；静态结构通过≠所有数值反例/法规事实已复跑**。

## 四、本轮关键官方一手来源
- Amazon US实际收费类目：<https://sell.amazon.com/pricing>
- 欧盟 Council Regulation (EU) 2026/382：<https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32026R0382>
- 欧盟DG TAXUD VAT区分：<https://vat-one-stop-shop.ec.europa.eu/eur-3-customs-duty-vat-guidelines-2026-06-16_en>
- 法国CNIL测量型追踪豁免：<https://cnil.fr/fr/cookies-solutions-pour-les-outils-de-mesure-daudience>
- IAS2：<https://www.ifrs.org/issued-standards/list-of-standards/ias-2-inventories/>
- 美国Census CBP 2023：<https://www.census.gov/data/datasets/2023/econ/cbp/2023-cbp.html>
- 中国两用物项出口管制：<https://exportcontrol.mofcom.gov.cn/article/zcfg/gnzcfg/gzjgfxwj/202410/1057.html>

## 五、当前停点与下一环

**当前G5/G6综合研究、独立对照与Owner许可的最小补强已形成现行八章再封板版本**；未开始G7润色，也未进入G8联合验收和BOARD_CLOSED。G7仅接受独立编辑Reviewer的**软性建议/独立完整润色候选**，不得触碰现行`main`，须由总控Reviewer对固定Commit逐项复核，Owner决定是否采用并正式落库。未另外授权HTML。
