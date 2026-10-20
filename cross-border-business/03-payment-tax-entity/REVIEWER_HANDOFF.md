# 第三板块《支付、税务与经营主体》｜唯一现行 Reviewer 交接

> **UPDATED：2026-10-20｜Owner正式批准第三板块四线并行推进及唯一总控**
> **STATUS：G1_FRAMEWORK_FROZEN / CH1_CH2_CH4_CH5_CH6_CH7_CH8_CH9_FINAL_SEALED / A_CH3_G2 / B_LANE_CONTENT_COMPLETE / C_LANE_CONTENT_COMPLETE / BOARD_NOT_CLOSED**
> **冻结：唯一核心1 / 一级10 / 二级52 / 三级113；二级直接成节4处。**
> **正文：8/10章正式封板（第1、2、4、5、6、7、8、9章均获Owner逐章授权并按G4入库）。B线4—5章、C线6—7章章级完成；A线第3章G2进行中，D线第9章已由Owner授权Reviewer以Writer R2全文直修封板，第10章G2离线Writer工作包已启动，尚未提交首稿。全板块未CLOSE。**

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
| 全书正式正文 | 8/10 | CH1、CH2、CH4、CH5、CH6、CH7、CH8、CH9均获Owner授权写入main；CH3、CH10未正式封板 |

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
| A｜经营准备 | 1—3：主体/法律卖方、渠道选型、开户接入 | **第1章及第2章均CHAPTER_FINAL_SEALED；第2章为Owner授权Reviewer基于Writer R2完整底稿纠错；第3章G2_WORKPACK_READY / WRITER_V1_PENDING** | 3 |
| B｜完成交易 | 4—5：买家付款、服务端支付确认 | **第4章 CHAPTER4_FINAL_SEALED；第5章 CHAPTER5_FINAL_SEALED（Owner授权Reviewer基于Writer R2全文直修，静态G3复核与G4回读；非Writer R3）** | B线章级内容完成，待唯一总控全板块跨章复核 |
| C｜资金管理 | 6—7：清算到账、退款/拒付/冻结 | **第6、7章 CHAPTER_FINAL_SEALED；第7章由Owner授权Reviewer基于Writer V2直修、静态复验并回读GitHub** | C线章级完成，待唯一总控跨章复核 |
| D｜财务税务 | 8—10：会计利润、境内税务、境外税务 | **第8章、第9章均 CHAPTER_FINAL_SEALED**；第9章Writer V1→G3 R1 RETURN（20项）→Writer R2→G3 R2 RETURN（14项）→Owner授权Reviewer直接定向修复并G4回读；**第10章 G2_WORKPACK_READY / WRITER_V1_PENDING** | 第10章G2 Writer，D线随后待统一总控跨章复核 |

**不新增四份正式交接：** 本文件是整个第三板块唯一当前状态表。各Agent的离线ZIP、报告和工作包仅是对应Gate的证据，不能当作并行权威框架；除Owner批准G4的正式正文外，不上传过程稿至docs作为FINAL。

**七项统一纪律：**
1. 每个Writer离线ZIP均包含完整正式冻结框架、第n章逐字原文、章级任务/知识边界、跨章归属及术语、参考来源入口与状态、可复制提示词、自检模板和原字节SHA-256清单。Writer回传完整正文+完整来源自检+ZIP；不交Patch。
2. 每章分线Reviewer须冷读、逐字核对冻结标题、实查官方事实和适用法域、验证数学/风险边界；RETURN同轮给完整返修ZIP与提示词。总控另负责跨章矛盾、版本检查和集中入库；Writer自检不能代替独立Review。
3. 当上游新章尚未封板，其他章只能引用该章的**冻结问题与既定职责**，不能引用不存在的正式正文或称其未审结论已PASS；冲突进入跨线待协调清单，待总控裁定。
4. 统一知识主归属：①主体与法律卖方；②收款方式选型；③开户和支付接入；④买家结账/支付失败；⑤真实支付核验与订单对接；⑥平台结算换汇与银行入账；⑦退款/拒付/欺诈/冻结；⑧收入成本/现金流与对账；⑨中国税务；⑩海外税务。接口可简单解释，禁止跨章全篇重复。
5. 统一概念：MoR/法律卖家不等于PSP；买家授权/捕获不等于提现或银行到账；退款不等于银行拒付；销售额、会计收入和现金入账不同；VAT/GST/销售税不同于所得税；5万美元便利化额度不是经营收汇绝对上限。动态费率、资质及税务门槛必须逐法域、时点、主体重新核实。
6. 各线以一组统一的教学案例**设定**作为协作锚点（中国个人软件开发者、中国实体独立站小卖家、中国B2B服务商），每次出现未核实的假设数值须标MODEL_ASSUMPTION，不得变为真实行业数据；不硬性要求每章照搬案例。
7. **单写入者：** 四线Writer/Reviewer只回传ZIP；GitHub main正式修改集中由总控完成，需在提交前重取main HEAD、检查目标文件Git Blob、并发差异，PR合并后回读文件及冻结题干。每章Owner明确批准后才G4封板。全书完成后仍需G5/G6/G7/G8。

**启动/衔接规则：** A线第1/2章、B线第4/5章、C线第6章和D线第8/9章均按对应Owner特定授权封板。**B线第5章通过本轮Owner直修及G4，B线当前没有下一章Writer Gate**；A/D线保持各自状态，C线第7章已在本轮由Owner明确授权G4封板，所有跨章纠纷由唯一总控处理。

## 三、历史保护与跨板块职责

原独立《现代商业支付系统》继续 **CLOSED / UNCHANGED**： [旧唯一交接](../../modern-commercial-payment-guide/REVIEWER_HANDOFF.md)、[原V6冻结7/29/42题](../../modern-commercial-payment-guide/docs/FROZEN_FRAMEWORK_V6_20261016.md)、[七章正文](../../modern-commercial-payment-guide/docs/)。它不是此新版完整十章正文；不得直接覆盖或搬迁。

第一板块负责市场机会，第二板块网络，第四板块产品/订单/履约实现，第五板块获客；本第三板块只解决经营主体、支付金融事实、收结汇、账务和境内外税务。支付与产品、银行到账与账务收入、法律卖方与平台代收等应相互引用而不重复全文。

## 四、后续工作｜四线并行

**A线第1章**含冻结6个二级、15个三级。Writer V1→G3 RETURN R1（18项）→Writer R2→G3 RETURN R2（14项），Owner已直接授权Reviewer基于Writer R2整篇改正并G4封板。最终正式正文为 [docs/CHAPTER1_FINAL_SEALED.md](docs/CHAPTER1_FINAL_SEALED.md)，不是Writer R3；Reviewer纠错闭环、差异及来源自检在Owner本轮独立审计ZIP，原字节SHA-256：`3fc7ff2b60213b726e7ccf91ec7dced127eb1c38907a1ae3305156707e03cbd5`（UTF-8 LF）；正式Git Blob以main回读为准。**A线第2章已由Owner授权Reviewer基于Writer R2完整原稿定点修复后正式封板，第3章《选好收款方式，怎么才能用起来？》G2独立Writer首稿现启动。**


**A线第2章｜G4 Owner授权直修封板补记（2026-10-20）：** Writer V1→G3 R1 `RETURN`（20项）→Writer R2→G3 R2 `RETURN`（15项）；Owner随后明确授权Reviewer以Writer R2**完整底稿**直接最小纠错、复核、正式冻结并入库。没有Writer R3交付，也没有第三轮独立Writer自检。正式正文唯一有效文件：[docs/CHAPTER2_FINAL_SEALED.md](docs/CHAPTER2_FINAL_SEALED.md)，原字节SHA-256 `30941007e8bd6c83467e89752296662766dbec526e3efab0a1d8218ba158f340`，Git Blob `5a2787b3ac81579b9b7417780d322699f605bb30`，UTF-8/LF；冻结L2=6/L3=13逐字同父题同序核验PASS，6幅Mermaid源码围栏和模型60美元→56.84美元、15美元→13.54美元复算PASS。修正实际覆盖逐产品准入与UNKNOWN、MoR责任、授权/确认、备用切换、B2B付款、Shopify额外费用、条件准备金、卖家保障、PCI迁移与公式控制字符；**官方动态费率、真实商户申请/支付/出款均未实测 `NOT_RUN`**。Writer R2原稿、自检、Reviewer R2审计报告、15项直修闭环及全量差异归档于Owner本轮独立审计ZIP，不在仓库docs存过程版本。**下一步：A线第3章（L2=4/L3=10）G2 Writer V1完整离线ZIP已制作、未收到首稿。**

**B线第4章：** Writer V1→G3 R1 RETURN（22项）→Writer R2→G3 R2 RETURN（12项）→Owner于2026-10-20明确授权Reviewer从Writer R2全文直接纠错并G4封板；正式正文为 [docs/CHAPTER4_FINAL_SEALED.md](docs/CHAPTER4_FINAL_SEALED.md)，**非Writer R3**。全文原字节SHA-256（UTF-8 LF）：`6e2711214b02c7ee9f3673e0d4fd55e4086ea4c118e034e78ae3f6c90a978259`。冻结L1=1、L2=5、L3=10题逐字/同父题/同序PASS；7天试用604800秒与金额算式PASS；12项修复、Writer R2原稿、差异及来源核验归档于本轮Owner审核ZIP（不在docs重复放过程稿）。**第5章已经Writer V1→G3 RETURN→Writer R2→G3 R2 RETURN，后由Owner授权Reviewer直修并G4封板；详见下方独立记录。**

**B线第5章｜G4 Owner授权直修封板（2026-10-20）：** Writer V1→G3 R1 `RETURN`（19项）→Writer R2→G3 R2 `RETURN`（11项，P0六/P1四/P2一），Owner随后明确授权Reviewer直接以Writer R2**完整正文**为底稿完成定向修复、复核、正式冻结并入库。**本轮是Reviewer直修，不是Writer R3，也没有新一轮第三方独立审核。**正式正文唯一有效路径：[docs/CHAPTER5_FINAL_SEALED.md](docs/CHAPTER5_FINAL_SEALED.md)；原字节UTF-8 LF SHA-256：`221dc9a015d8ff8df89aa36546f02e55bd376fb80ea206a088cbddfff23e4fbf`；Git Blob SHA：`c9ca5129e1b51386e5e9a2b766013c6d576e5061`；首次正文写入commit：`622fdb886d9fde1a108f4c5c5b30d487846dea98`。冻结L1=1/L2=5/L3=10、5.2直接成节逐字同序归属PASS；JSON、Python围栏及退款70+70>100、折算15美元、8组逻辑反例静态核验PASS。修复Boleto/OXXO凭单、OXXO MXN货币、退款功能、processing主动补偿、退款事务持久预留、Outbox远程幂等、Refund API、首期/续费订阅状态、capture_before路径及30分钟取消边界。**真实支付、退款、仓储及银行端到端均NOT_RUN**。完整Writer R2原稿/自检、R1/R2审核报告、11项修复审计、全文差异与SHA清单随Owner本轮离线审计ZIP归档，不在docs保留过程版本。跨章协调编号：`X-B05-01`第4/5章凭单状态、`X-B05-02`第5/7章退款能力与法律义务、`X-B05-03`第5/6章支付成功不等于银行到账、`X-B05-04`第5/8章invoice.paid不等于新现金、`X-B05-05`第三/第四板块外部履约幂等；交唯一总控，不擅改其他章。**B线章级内容现已完成，等待全板块G5-G8和跨章复核，不自行开启未授权的新章。**

**C线第6章：** Writer V1→G3 R1 RETURN（22项）→Writer V2→G3 R2 RETURN（12项）；Owner于2026-10-20授权本C线Reviewer在Writer V2完整底稿上直修、复核、正式冻结并写入项目库。正式唯一版本为 [docs/CHAPTER6_FINAL_SEALED.md](docs/CHAPTER6_FINAL_SEALED.md)，**不是Writer V3**。冻结L1=1、L2=5、L3=11逐字同父题同序PASS；1000→785.50美元的MODEL_ASSUMPTION算例复算PASS；ISO 20022、外汇现行法规、9610、VAMP、账户及追踪边界等R2 12项定点修复；实际结汇/银行卡入账测试`NOT_RUN`。正文归一化UTF-8 LF SHA-256 `d9b12880dc5a78367f946fe3d634de3ede96b549e0619b9a01bd2b4871ca1322`；Git Blob `ef9097eed65fab73b9e8b76e3b2855e869f16bf1`；实际入库Commit [`2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c`](https://github.com/entropy-student/project/commit/2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c)。逐项修复、原版V2、自检和完整差异在Owner审核离线归档ZIP；未将其当成独立Writer V3或未经审校直接PASS。已与正式第1章卖方/MoR及第4章买家支付问题做接口核对；第5、7、8等未封板正文不可虚构交叉通过，跨章待总控后续复核。**本句为第6章封板当时的历史启动信息；第7章已于2026-10-20另经Owner授权Reviewer直修封板，见后续独立记录。**

**C线第7章（Owner授权直修封板，2026-10-20）：** Writer V1→G3 R1 RETURN（23项）→Writer V2→G3 R2 RETURN（14项：P0五项、P1八项、P2一项）；Owner于本轮授权Reviewer基于V2完整正文定向直修、复查、正式封板写回。唯一正式正文：[docs/CHAPTER7_FINAL_SEALED.md](docs/CHAPTER7_FINAL_SEALED.md)，非Writer V3。冻结L1=1/L2=5/L3=10逐字同序、7.5直接成节PASS；算例100→96.80美元、重复50美元收款一笔退款→46.50美元、200→193.90美元等复算PASS。修复Visa VAMP最低1500欺诈及争议事件（非交易数）、Mastercard HECM 3%与300笔、Visa 13.2/13.6、退款业务持久幂等/并发预占、3DS条件、EU SaaS撤回权、ROSCA提醒边界、ARN、卡争议费用、准备金期限及五渠道分流。UTF-8 LF SHA-256：c2f99be265ed31992520b771ca3bdbf7371b9517698047d39643876b288d16d8；Git Blob：6a968aedc9351bbacdbaf6d99c91946652ab2fd4；正式正文创建Commit：[d01f4e5fd190816a9451c95110c93e6b9ff4a211](https://github.com/entropy-student/project/commit/d01f4e5fd190816a9451c95110c93e6b9ff4a211)。本轮为Reviewer直修而非第三轮独立Writer返稿；真实收退款、拒付、SWIFT追款、银行冻款申诉NOT_RUN。V2完整原稿及自检、G3复审报告、14项修复/完整差异和SHA清单归档于本轮离线审计包，不在docs并行存历史候选。跨章留总控：第5/7章退款重试职责、第6/7章准备金及出款接口、第8章模型180天不能等于统一解冻期限、第4/7章续费提醒法律边界。C线章节已结束，后续统一总控跨章复核，不自行重写其他章。

**D线第8章：** Writer V1→G3 R1 RETURN（21项）→Writer R2→G3 R2 RETURN（3项P0、9项P1）；Owner于2026-10-20明确授权D线Reviewer直接以Writer R2全文为底稿做最小必要修订、复核、正式封板及入库。Reviewer完成12项R2定向修复，并额外独立发现80 USD订单利润明细漏列2 USD，补充逐单技术服务成本作为`MODEL_ASSUMPTION`并重新复算。冻结L1=1/L2=5/L3=9、8.1直接成节同序同父题PASS；118 USD资金桥接、80 USD利润压力测试、100 USD保证金双轨、银行余额调节与月度现金跑道等13组算式静态PASS；法律、平台动态事实按法域/版本条件化。**唯一正式全文：** [docs/CHAPTER8_FINAL_SEALED.md](docs/CHAPTER8_FINAL_SEALED.md)，不是Writer R3；原字节UTF-8 LF SHA-256：`61b1042262a32aac36d6f7d3ad55ec79f5504458b1f79418dc365a4610d7aa98`；Git Blob：`fea889c88bd276b2abaa16727335e07d08183ffc`；正文首次入库Commit [`dca1392bc879767eea354d36fcefa2e93d203afb`](https://github.com/entropy-student/project/commit/dca1392bc879767eea354d36fcefa2e93d203afb)。完整Writer R2、自检、G3 R2报告、Reviewer全差异、修复审计及SHA-256随本轮Owner离线证据ZIP归档，**不在docs重复存过程稿**。真实收款结汇或纳税行为`NOT_RUN`；跨章接口：支付/账户主体归1/2/3/6，交易真实状态归5，争议归7，国内税务归9，海外税务归10，由唯一总控集中裁决，不因第8章通过宣称未封板其他章节已通过。**D线下一一级问题为第9章《在国内做跨境生意，要交哪些税？》，仅启动G2独立Writer完整离线工作包、Writer首稿待交；第10章未启动。**

**D线第9章（Owner授权Reviewer直修与G4封板，2026-10-20）：** Writer V1→G3 R1 `RETURN`（20项，9项P0）→Writer R2→G3 R2 `RETURN`（14项：6项P0/6项P1/2项P2）；Owner本轮明确授权D线Reviewer以Writer R2完整底稿按最小必要原则直接纠正、再次静态回归、冻结并写回正式项目库。**这不是Writer R3，也未进行真实税务申报。**唯一正式正文为 [docs/CHAPTER9_FINAL_SEALED.md](docs/CHAPTER9_FINAL_SEALED.md)，冻结L1=1、L2=5、L3=12题同序同父题PASS。重点修复：2026出口退免税5号公告第44/45/48条、出口征税11号公告第7条的70万元含税换算、合法进项抵扣模型、海关稽查条例第2/7/31条、数字服务/应用商店VAT及法律卖方条件、2026税表字段与小额零星采购1000元日次门槛、公司/个体户个税及跨章链接；原`MODEL_ASSUMPTION`与真实合规资格严格分离。出口例假设700000元应税销售额与13%税率，销项税约80530.97元、满足抵扣前提时另以65000元合法进项抵扣，增值税应缴约15530.97元。正式正文UTF-8 LF SHA-256 `bc6cadbc424345554ec30238503260e612d80a92f9e1757bd44e9863d1ddba6b`；Git Blob `2dfcc8682867b9f9744c66522229de05c82438dc`；末次正文归一化/标记更正commit [`37e7874230bf458e2358e815db415e0d32e93a12`](https://github.com/entropy-student/project/commit/37e7874230bf458e2358e815db415e0d32e93a12)。Writer R2、自检、先前R2审核报告、直修差异、静态复核与SHA256另存本轮Owner离线审计ZIP，**不把过程稿存入docs**。实际申报、退税、结汇均为`NOT_RUN`。跨章剩余待总控协调：第8/9章收入确认及销售额/现金入账边界；第6/9章收汇凭证与税务申报分工；第9/10章中国境内税收与目的地VAT/GST/所得税及双重征税抵免；不擅改其他正文。**D线下一一级问题：第10章《卖给海外客户，还要在当地交税吗？》；只开启自包含G2独立Writer完整离线工作包，Writer首稿待回；第10章不是本轮正式封板内容。**

**下一批Gate：** A线第3章Writer V1→G3；**B线第4/5章均已G4，无下一章Writer Gate，待唯一总控跨章复核**；C线6—7章均已G4封板，进入总控跨章复核；D线第9章已经Owner授权G4封板，第10章G2独立Writer V1待交；各章仍需Owner逐章授权G4。

## 五、官方事实核验提示

- 支付测试服务商规则：https://docs.stripe.com/testing
- 个人跨境电商年度结售汇便利化额度说明：https://www.safe.gov.cn/shanghai/2026/0402/2412.html
- 会计档案类别期限：https://www.mof.gov.cn/gp/xxgkml/tfs/201512/t20151214_2510365.htm
- 卡组织风险监控动态门槛（渠道说明）：https://docs.adyen.com/risk-management/dispute-and-fraud-monitoring
- 欧盟VAT/OSS/IOSS：https://vat-one-stop-shop.ec.europa.eu/
- 美国预提税表与协定资格：https://www.irs.gov/individuals/international-taxpayers/claiming-tax-treaty-benefits

**停点：G1 FRAMEWORK_FROZEN；A-CH1/CH2 FINAL_SEALED / A-CH3 G2_WRITER_V1_PENDING；B-CH4/CH5 FINAL_SEALED / B_LINE_CHAPTER_CONTENT_COMPLETE；C-CH6/CH7 FINAL_SEALED / C_LINE_CHAPTER_CONTENT_COMPLETE；D-CH8/CH9 FINAL_SEALED / D-CH10 G2_WORKPACK_READY；正式正文8/10；其他章仍需Owner授权G4，BOARD_NOT_CLOSED。**
