# 第三板块《支付、税务与经营主体》｜唯一现行 Reviewer 交接

> **UPDATED：2026-10-20｜Owner正式批准第三板块四线并行推进及唯一总控**
> **STATUS：G1_FRAMEWORK_FROZEN / CH1_CH4_CH6_CH8_FINAL_SEALED / A_CH2_G2 / B_CH5_G2_WORKPACK / C_CH7_G2_WORKPACK / BOARD_NOT_CLOSED**
> **冻结：唯一核心1 / 一级10 / 二级52 / 三级113；二级直接成节4处。**
> **正文：4/10章正式封板（第1、4、6、8章，均经Owner逐章授权Reviewer直修后G4入库）。A线第2章G2、B线第5章G2、C线第7章G2继续独立推进；D线第8章正式封板，第9章G2离线Writer工作包启动，第10章未启动。**

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
| 全书正式正文 | 4/10 | CH1、CH4、CH6、CH8分别获Owner授权G4；其余章仍需独立审核与逐章Owner授权 |

Writer的101题以原顺序进入定点修复，新补12题均有已冻结二级父题。修复重点包括：Stripe真实生产测试与沙箱边界、个人结售汇年度便利化额度、Visa VAMP非统一1%门槛、争议费因机构而异、会计档案保管10/30年等类别、3DS有条件责任转移、疑似欺诈订单不强制立刻退款、各类税收和美国州税门槛不套统一规则、W-8与协定待遇需要真实资格。**框架只是冻结问题及知识边界，尚不是所有动态规则已完成正文级事实核验。**

离线审核输入保留在本轮会话和下载工作包：
- Writer首稿：`03_payment_tax_entity_l3_framework.md`（101题+4直接成节）；
- Reviewer独立V1：`第三板块_G1_Reviewer三级问题独立完整候选_V1_20261020.md`（150题+2直接成节）；
- Reviewer独立双稿报告：`第三板块_G1_L3_双稿独立Reviewer审核报告_20261020.md`；
- Reviewer直修审计：`CB03_G1_L3_Review_Fix_Audit_20261020.md`（逐题Writer→终版映射、P0/P1纠偏、QA指纹），随Owner工作包可单独获取；不作为第二份并行冻结框架。
- 早期仅核心+L1、核心+L1+L2的阶段文件已退出仓库当前树，仅保留Git历史；旧未批准PR#160已关闭。
- 本轮正式PR及main提交SHA：以本交接最终合并记录和Git历史为准，未合并不声称写入main。

## 二、Owner批准四线并行及跨章协调标准（2026-10-20）

**Owner明确授权：** 在总控提出“四条线独立写作、独立Review、集中交接、逐章封板、全书联合复审”方案后，Owner回复“我批准，开始吧”。授权调整工作调度，不改变已经冻结的完整问题树、不豁免SOP的G2/G3/G4，不授予Writer或分线Reviewer直接更改GitHub main、重新设计题目或自行封板的权限。

| 线 | 一级章节及主责 | 当前工作及真实证据 | 后续顺序 |
|---|---|---|---|
| A｜经营准备 | 1—3：主体/法律卖方、渠道选型、开户接入 | **第1章CHAPTER1_FINAL_SEALED（Owner授权Reviewer直修；基于Writer R2），第2章G2_WORKPACK_READY / WRITER_V1_PENDING** | 3 |
| B｜完成交易 | 4—5：买家付款、服务端支付确认 | **第4章 CHAPTER4_FINAL_SEALED（Owner授权Reviewer直修Writer R2）；第5章 G2_WORKPACK_READY / WRITER_V1_PENDING** | 第5章G2 Writer |
| C｜资金管理 | 6—7：清算到账、退款/拒付/冻结 | **第6章 CHAPTER6_FINAL_SEALED（Owner授权Reviewer基于Writer V2全文直接定向修复并回读）；第7章 G2_WORKPACK_READY / WRITER_V1_PENDING** | 7章独立Writer首稿 |
| D｜财务税务 | 8—10：会计利润、境内税务、境外税务 | **第8章 CHAPTER8_FINAL_SEALED**（Writer R2底稿经Owner授权Reviewer定向直修，G4回读通过）；第9章 G2_WORKPACK_READY / WRITER_V1_PENDING | 第9章G2 Writer，随后10 |

**不新增四份正式交接：** 本文件是整个第三板块唯一当前状态表。各Agent的离线ZIP、报告和工作包仅是对应Gate的证据，不能当作并行权威框架；除Owner批准G4的正式正文外，不上传过程稿至docs作为FINAL。

**七项统一纪律：**
1. 每个Writer离线ZIP均包含完整正式冻结框架、第n章逐字原文、章级任务/知识边界、跨章归属及术语、参考来源入口与状态、可复制提示词、自检模板和原字节SHA-256清单。Writer回传完整正文+完整来源自检+ZIP；不交Patch。
2. 每章分线Reviewer须冷读、逐字核对冻结标题、实查官方事实和适用法域、验证数学/风险边界；RETURN同轮给完整返修ZIP与提示词。总控另负责跨章矛盾、版本检查和集中入库；Writer自检不能代替独立Review。
3. 当上游新章尚未封板，其他章只能引用该章的**冻结问题与既定职责**，不能引用不存在的正式正文或称其未审结论已PASS；冲突进入跨线待协调清单，待总控裁定。
4. 统一知识主归属：①主体与法律卖方；②收款方式选型；③开户和支付接入；④买家结账/支付失败；⑤真实支付核验与订单对接；⑥平台结算换汇与银行入账；⑦退款/拒付/欺诈/冻结；⑧收入成本/现金流与对账；⑨中国税务；⑩海外税务。接口可简单解释，禁止跨章全篇重复。
5. 统一概念：MoR/法律卖家不等于PSP；买家授权/捕获不等于提现或银行到账；退款不等于银行拒付；销售额、会计收入和现金入账不同；VAT/GST/销售税不同于所得税；5万美元便利化额度不是经营收汇绝对上限。动态费率、资质及税务门槛必须逐法域、时点、主体重新核实。
6. 各线以一组统一的教学案例**设定**作为协作锚点（中国个人软件开发者、中国实体独立站小卖家、中国B2B服务商），每次出现未核实的假设数值须标MODEL_ASSUMPTION，不得变为真实行业数据；不硬性要求每章照搬案例。
7. **单写入者：** 四线Writer/Reviewer只回传ZIP；GitHub main正式修改集中由总控完成，需在提交前重取main HEAD、检查目标文件Git Blob、并发差异，PR合并后回读文件及冻结题干。每章Owner明确批准后才G4封板。全书完成后仍需G5/G6/G7/G8。

**启动/衔接规则：** A线第1章、B线第4章、C线第6章分别经Owner明确授权Reviewer直接修复并封板；A线第2章、B线第5章以及C线第7章进入G2。D线第8章已获Owner授权Reviewer直修G4并经GitHub回读；第9章仅开启G2首稿准备，不提前撰写或封板第9/10章；各线不代为改变彼此未获证据支持的进度。

## 三、历史保护与跨板块职责

原独立《现代商业支付系统》继续 **CLOSED / UNCHANGED**： [旧唯一交接](../../modern-commercial-payment-guide/REVIEWER_HANDOFF.md)、[原V6冻结7/29/42题](../../modern-commercial-payment-guide/docs/FROZEN_FRAMEWORK_V6_20261016.md)、[七章正文](../../modern-commercial-payment-guide/docs/)。它不是此新版完整十章正文；不得直接覆盖或搬迁。

第一板块负责市场机会，第二板块网络，第四板块产品/订单/履约实现，第五板块获客；本第三板块只解决经营主体、支付金融事实、收结汇、账务和境内外税务。支付与产品、银行到账与账务收入、法律卖方与平台代收等应相互引用而不重复全文。

## 四、后续工作｜四线并行

**A线第1章**含冻结6个二级、15个三级。Writer V1→G3 RETURN R1（18项）→Writer R2→G3 RETURN R2（14项），Owner已直接授权Reviewer基于Writer R2整篇改正并G4封板。最终正式正文为 [docs/CHAPTER1_FINAL_SEALED.md](docs/CHAPTER1_FINAL_SEALED.md)，不是Writer R3；Reviewer纠错闭环、差异及来源自检在Owner本轮独立审计ZIP，原字节SHA-256：`3fc7ff2b60213b726e7ccf91ec7dced127eb1c38907a1ae3305156707e03cbd5`（UTF-8 LF）；正式Git Blob以main回读为准。**A线现启动第2章《海外客户的钱，我该怎么收？》G2首稿**，第3章未开始。

**B线第4章：** Writer V1→G3 R1 RETURN（22项）→Writer R2→G3 R2 RETURN（12项）→Owner于2026-10-20明确授权Reviewer从Writer R2全文直接纠错并G4封板；正式正文为 [docs/CHAPTER4_FINAL_SEALED.md](docs/CHAPTER4_FINAL_SEALED.md)，**非Writer R3**。全文原字节SHA-256（UTF-8 LF）：`6e2711214b02c7ee9f3673e0d4fd55e4086ea4c118e034e78ae3f6c90a978259`。冻结L1=1、L2=5、L3=10题逐字/同父题/同序PASS；7天试用604800秒与金额算式PASS；12项修复、Writer R2原稿、差异及来源核验归档于本轮Owner审核ZIP（不在docs重复放过程稿）。**第5章 G2_WORKPACK_READY，Writer首稿未提交。**

**C线第6章：** Writer V1→G3 R1 RETURN（22项）→Writer V2→G3 R2 RETURN（12项）；Owner于2026-10-20授权本C线Reviewer在Writer V2完整底稿上直修、复核、正式冻结并写入项目库。正式唯一版本为 [docs/CHAPTER6_FINAL_SEALED.md](docs/CHAPTER6_FINAL_SEALED.md)，**不是Writer V3**。冻结L1=1、L2=5、L3=11逐字同父题同序PASS；1000→785.50美元的MODEL_ASSUMPTION算例复算PASS；ISO 20022、外汇现行法规、9610、VAMP、账户及追踪边界等R2 12项定点修复；实际结汇/银行卡入账测试`NOT_RUN`。正文归一化UTF-8 LF SHA-256 `d9b12880dc5a78367f946fe3d634de3ede96b549e0619b9a01bd2b4871ca1322`；Git Blob `ef9097eed65fab73b9e8b76e3b2855e869f16bf1`；实际入库Commit [`2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c`](https://github.com/entropy-student/project/commit/2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c)。逐项修复、原版V2、自检和完整差异在Owner审核离线归档ZIP；未将其当成独立Writer V3或未经审校直接PASS。已与正式第1章卖方/MoR及第4章买家支付问题做接口核对；第5、7、8等未封板正文不可虚构交叉通过，跨章待总控后续复核。**C线下一个一级问题：第7章《遇到退款、拒付或资金冻结怎么办？》G2离线Writer工作包启动，Writer V1未交。**

**D线第8章：** Writer V1→G3 R1 RETURN（21项）→Writer R2→G3 R2 RETURN（3项P0、9项P1）；Owner于2026-10-20明确授权D线Reviewer直接以Writer R2全文为底稿做最小必要修订、复核、正式封板及入库。Reviewer完成12项R2定向修复，并额外独立发现80 USD订单利润明细漏列2 USD，补充逐单技术服务成本作为`MODEL_ASSUMPTION`并重新复算。冻结L1=1/L2=5/L3=9、8.1直接成节同序同父题PASS；118 USD资金桥接、80 USD利润压力测试、100 USD保证金双轨、银行余额调节与月度现金跑道等13组算式静态PASS；法律、平台动态事实按法域/版本条件化。**唯一正式全文：** [docs/CHAPTER8_FINAL_SEALED.md](docs/CHAPTER8_FINAL_SEALED.md)，不是Writer R3；原字节UTF-8 LF SHA-256：`61b1042262a32aac36d6f7d3ad55ec79f5504458b1f79418dc365a4610d7aa98`；Git Blob：`fea889c88bd276b2abaa16727335e07d08183ffc`；正文首次入库Commit [`dca1392bc879767eea354d36fcefa2e93d203afb`](https://github.com/entropy-student/project/commit/dca1392bc879767eea354d36fcefa2e93d203afb)。完整Writer R2、自检、G3 R2报告、Reviewer全差异、修复审计及SHA-256随本轮Owner离线证据ZIP归档，**不在docs重复存过程稿**。真实收款结汇或纳税行为`NOT_RUN`；跨章接口：支付/账户主体归1/2/3/6，交易真实状态归5，争议归7，国内税务归9，海外税务归10，由唯一总控集中裁决，不因第8章通过宣称未封板其他章节已通过。**D线下一一级问题为第9章《在国内做跨境生意，要交哪些税？》，仅启动G2独立Writer完整离线工作包、Writer首稿待交；第10章未启动。**

**下一批Gate：** A线第2章Writer V1→G3；B线第5章G2独立Writer V1→G3；**C线第7章G2独立Writer V1→G3**；D线第8章已G4封板、第9章G2 Writer首稿待交。第7章不因第6章封板而自动PASS，后续仍逐章Owner授权G4。

## 五、官方事实核验提示

- 支付测试服务商规则：https://docs.stripe.com/testing
- 个人跨境电商年度结售汇便利化额度说明：https://www.safe.gov.cn/shanghai/2026/0402/2412.html
- 会计档案类别期限：https://www.mof.gov.cn/gp/xxgkml/tfs/201512/t20151214_2510365.htm
- 卡组织风险监控动态门槛（渠道说明）：https://docs.adyen.com/risk-management/dispute-and-fraud-monitoring
- 欧盟VAT/OSS/IOSS：https://vat-one-stop-shop.ec.europa.eu/
- 美国预提税表与协定资格：https://www.irs.gov/individuals/international-taxpayers/claiming-tax-treaty-benefits

**停点：G1 FRAMEWORK_FROZEN；A-CH1 FINAL_SEALED / A-CH2 G2_WRITER_PENDING；B-CH4 FINAL_SEALED / B-CH5 G2_WORKPACK_READY / WRITER_V1_PENDING；C-CH6 FINAL_SEALED / C-CH7 G2_WORKPACK_READY / WRITER_V1_PENDING；D-CH8 FINAL_SEALED / D-CH9 G2_WORKPACK_READY / WRITER_V1_PENDING；正式正文4/10；未授权其他章G4，BOARD_NOT_CLOSED。**
