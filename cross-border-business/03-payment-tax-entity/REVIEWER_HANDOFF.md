# 第三板块《支付、税务与经营主体》｜唯一现行 Reviewer 交接

> **UPDATED：2026-10-20｜Owner授权Reviewer定点修复、复查并冻结完整G1**
> **STATUS：G1_FRAMEWORK_FROZEN / G2_CHAPTER1_KICKOFF / BOARD_NOT_CLOSED**
> **冻结：唯一核心1 / 一级10 / 二级52 / 三级113；二级直接成节4处。**
> **正文：第1—10章均未写成新版正式正文；第一章G2现已启动准备，G3/G4尚未发生。**

## 一、权威依据和Owner决定

先遵循 [全库唯一项目SOP](../PROJECT_WORKFLOW_SOP.md)，再读本文件与 [唯一完整正式冻结问题树](docs/FROZEN_FRAMEWORK_V1_20261020.md)。

历史决策顺序：
1. Owner于2026-10-20通过唯一核心问题“**做跨境生意，钱怎么收、税怎么交？**”和十个一级问题，批准记录为阶段冻结。
2. Owner后正式通过综合V3的52条二级问题，与既有核心/一级逐字同序冻结。
3. 独立Writer提交101道三级+4处二级直接成节；Reviewer此前独立提出150道三级候选，对双稿逐题审查，判定部分规则表述误导，出具RETURN_FOR_TARGETED_FIX报告。
4. Owner最新授权：“**这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。**” 本轮Reviewer在既有候选上定向修复并回归，形成正式三级**113题**，继承4处直接成节。是Reviewer直修，不应写成Writer返稿或独立第三方复审。

### 冻结范围和工程验收

| 问题层级 | 正式数量 | 审批与验收 |
|---|---:|---|
| 唯一核心 | 1 | Owner批准、原文不动 |
| 一级问题 | 10 | Owner批准、原文、顺序与编号不动 |
| 二级问题 | 52 | Owner批准、全部父题逐字原文不动 |
| 三级问题 | 113 | Owner授权Reviewer定点修复并正式冻结；一一映射Writer101题，新增12个必要独立问法 |
| 二级直接成节 | 4 | 5.2、7.5、8.1、10.3；原因见唯一框架 |
| 全书正式正文 | 0/10 | 没有把框架PASS冒充章节完成 |

Writer的101题以原顺序进入定点修复，新补12题均有已冻结二级父题。修复重点包括：Stripe真实生产测试与沙箱边界、个人结售汇年度便利化额度、Visa VAMP非统一1%门槛、争议费因机构而异、会计档案保管10/30年等类别、3DS有条件责任转移、疑似欺诈订单不强制立刻退款、各类税收和美国州税门槛不套统一规则、W-8与协定待遇需要真实资格。**框架只是冻结问题及知识边界，尚不是所有动态规则已完成正文级事实核验。**

离线审核输入保留在本轮会话和下载工作包：
- Writer首稿：`03_payment_tax_entity_l3_framework.md`（101题+4直接成节）；
- Reviewer独立V1：`第三板块_G1_Reviewer三级问题独立完整候选_V1_20261020.md`（150题+2直接成节）；
- Reviewer独立双稿报告：`第三板块_G1_L3_双稿独立Reviewer审核报告_20261020.md`；
- Reviewer直修审计：`CB03_G1_L3_Review_Fix_Audit_20261020.md`（逐题Writer→终版映射、P0/P1纠偏、QA指纹），随Owner工作包可单独获取；不作为第二份并行冻结框架。
- 早期仅核心+L1、核心+L1+L2的阶段文件已退出仓库当前树，仅保留Git历史；旧未批准PR#160已关闭。
- 本轮正式PR及main提交SHA：以本交接最终合并记录和Git历史为准，未合并不声称写入main。

## 二、历史保护与跨板块职责

原独立《现代商业支付系统》继续 **CLOSED / UNCHANGED**： [旧唯一交接](../../modern-commercial-payment-guide/REVIEWER_HANDOFF.md)、[原V6冻结7/29/42题](../../modern-commercial-payment-guide/docs/FROZEN_FRAMEWORK_V6_20261016.md)、[七章正文](../../modern-commercial-payment-guide/docs/)。它不是此新版完整十章正文；不得直接覆盖或搬迁。

第一板块负责市场机会，第二板块网络，第四板块产品/订单/履约实现，第五板块获客；本第三板块只解决经营主体、支付金融事实、收结汇、账务和境内外税务。支付与产品、银行到账与账务收入、法律卖方与平台代收等应相互引用而不重复全文。

## 三、后续工作｜第1章G2启动

当前**进入第1个一级问题**（第一章《做跨境生意，我需要注册公司吗？》）的**G2章节Writer工作包和首稿设计**。此章含已冻结**6个二级及15个三级**，无“二级直接成节”例外。

G2 Writer需产出真正的整章知识正文而非再设计问题。先讲清概念、权利责任和判定，再覆盖实操决策、三类业务具体案例、反例、适用地区及有时效性的官方来源；确保全部6+15问逐项答到，并严格不改题目编号与父子关系。旧项目第一章有主体选型素材但因旧项目CLOSED仅作为**只读参考**；不得当作新章已经完成，也不得直接复制过时税务或收款准入事实。

**下一个Gate：** Writer第1章完整首稿 → Reviewer独立G3审核（特别核验主体责任、地区/税收与支付资格）→ Owner决定是否G4封板；不得未审即开始第2章正式正文，也不得提前做HTML/PDF或支付系统操作。

## 四、官方事实核验提示

- 支付测试服务商规则：https://docs.stripe.com/testing
- 个人跨境电商年度结售汇便利化额度说明：https://www.safe.gov.cn/shanghai/2026/0402/2412.html
- 会计档案类别期限：https://www.mof.gov.cn/gp/xxgkml/tfs/201512/t20151214_2510365.htm
- 卡组织风险监控动态门槛（渠道说明）：https://docs.adyen.com/risk-management/dispute-and-fraud-monitoring
- 欧盟VAT/OSS/IOSS：https://vat-one-stop-shop.ec.europa.eu/
- 美国预提税表与协定资格：https://www.irs.gov/individuals/international-taxpayers/claiming-tax-treaty-benefits

**停点：G1 COMPLETE FROZEN；G2 CHAPTER1 STARTED；章节正文未封板，Owner无需重新批准已冻结问题。**
