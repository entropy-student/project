# 第三板块《支付、税务与经营主体》｜唯一现行 Reviewer 交接

> **UPDATED：2026-10-20｜Owner正式批准第三板块四线并行推进及唯一总控**
> **STATUS：G1_FRAMEWORK_FROZEN / CH1—CH10_FINAL_SEALED / G6_OWNER_AUTHORIZED_REVISION_REVIEWED / G7_EDITORIAL_PASS_OWNER_DIRECT_FIX / G8_PASS_CANDIDATE / STOP_AT_OWNER_FINAL_APPROVAL / BOARD_NOT_CLOSED**
> **冻结：唯一核心1 / 一级10 / 二级52 / 三级113；二级直接成节4处。**
> **正文：10/10章均获Owner逐章授权Reviewer基于完整Writer底稿定向修复并按G4正式封板入库；A线1—3章、B线4—5章、C线6—7章、D线8—10章全部章级正文完成。G5全书三份研究报告与独立Reviewer复审完成；Owner本轮明确批准按总控建议完成实质性定向修复并再冻结；G6静态内容复核已完成，G7 Editor V1已独立审查并由Owner明确授权Reviewer直修16项、复验PASS、原文再封板；G8由新Reviewer独立复核发现2项P1及2项P2；经Owner授权由该Reviewer定向直修并作静态复验，现为G8候选通过、正文暂时冻结，仍为`BOARD_NOT_CLOSED`。**

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
| 全书正式正文 | 10/10 | CH1—CH10均获Owner逐章授权G4写入main；G5/G6/G7均已完成，G8已复验为PASS_CANDIDATE，Owner最终CLOSE尚未批准 |

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
| A｜经营准备 | 1—3：主体/法律卖方、渠道选型、开户接入 | **第1—3章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |
| B｜完成交易 | 4—5：买家付款、服务端支付确认 | **第4—5章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |
| C｜资金管理 | 6—7：清算到账、退款/拒付/冻结 | **第6—7章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |
| D｜财务税务 | 8—10：会计利润、境内税务、境外税务 | **第8—10章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |

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

## 四、四线并行章节执行沿革（历史记录，不代表当前Gate）

**A线第1章**含冻结6个二级、15个三级。Writer V1→G3 RETURN R1（18项）→Writer R2→G3 RETURN R2（14项），Owner已直接授权Reviewer基于Writer R2整篇改正并G4封板。最终正式正文为 [docs/CHAPTER1_FINAL_SEALED.md](docs/CHAPTER1_FINAL_SEALED.md)，不是Writer R3；Reviewer纠错闭环、差异及来源自检在Owner本轮独立审计ZIP，原字节SHA-256：`3fc7ff2b60213b726e7ccf91ec7dced127eb1c38907a1ae3305156707e03cbd5`（UTF-8 LF）；正式Git Blob以main回读为准。**A线第2章已由Owner授权Reviewer基于Writer R2完整原稿定点修复后正式封板，第3章《选好收款方式，怎么才能用起来？》G2独立Writer首稿现启动。**


**A线第2章｜G4 Owner授权直修封板补记（2026-10-20）：** Writer V1→G3 R1 `RETURN`（20项）→Writer R2→G3 R2 `RETURN`（15项）；Owner随后明确授权Reviewer以Writer R2**完整底稿**直接最小纠错、复核、正式冻结并入库。没有Writer R3交付，也没有第三轮独立Writer自检。正式正文唯一有效文件：[docs/CHAPTER2_FINAL_SEALED.md](docs/CHAPTER2_FINAL_SEALED.md)，原字节SHA-256 `30941007e8bd6c83467e89752296662766dbec526e3efab0a1d8218ba158f340`，Git Blob `5a2787b3ac81579b9b7417780d322699f605bb30`，UTF-8/LF；冻结L2=6/L3=13逐字同父题同序核验PASS，6幅Mermaid源码围栏和模型60美元→56.84美元、15美元→13.54美元复算PASS。修正实际覆盖逐产品准入与UNKNOWN、MoR责任、授权/确认、备用切换、B2B付款、Shopify额外费用、条件准备金、卖家保障、PCI迁移与公式控制字符；**官方动态费率、真实商户申请/支付/出款均未实测 `NOT_RUN`**。Writer R2原稿、自检、Reviewer R2审计报告、15项直修闭环及全量差异归档于Owner本轮独立审计ZIP，不在仓库docs存过程版本。**下一步：A线第3章（L2=4/L3=10）G2 Writer V1完整离线ZIP已制作、未收到首稿。**

**A线第3章（Owner授权Reviewer直修封板，2026-10-20）：** Writer V1→独立G3 R1 RETURN（22项）→Writer R2→独立G3 R2 RETURN（13项，P0六/P1六/P2一）；Owner明确授权由本Reviewer在R2完整原稿上最小修复，未收到Writer R3，亦未增设第三方G3。最终正文[docs/CHAPTER3_FINAL_SEALED.md](docs/CHAPTER3_FINAL_SEALED.md)；UTF-8 LF原字节SHA256 `4dceaaadf7ab2a3873c254ce239bb94c8a8d633011d396702f52804a65623291`；预期Git Blob `613c58fddbe0fbe63b5c73be10285aabebea3da2`，合并后以main回读为准。冻结L2=4/L3=10逐字同序同父题PASS，7幅Mermaid/14围栏和控制字符静态检查PASS。13项修复覆盖PCI SSC 2025 SAQ A脚本资格/2026 ASV、FinCEN适用边界、非线性账户权限、订单/金额/币种/支付对象服务端核验、Stripe `whsec_`、Shopify China Advanced 0.6%/受邀Early Access、MATCH条件、退款失败与幂等、平台原生支付/插件差异和营销邮件法域条件。真实PCI ASV扫描、商户开户、沙箱/生产付款退款、银行入账均`NOT_RUN`。R2原稿/自检、Reviewer完整审计、差异、官方证据、第5—8章总控跨章复核保存在Owner本轮完整离线ZIP；**A线章级内容完成，不再新开一级章节**。

**B线第4章：** Writer V1→G3 R1 RETURN（22项）→Writer R2→G3 R2 RETURN（12项）→Owner于2026-10-20明确授权Reviewer从Writer R2全文直接纠错并G4封板；正式正文为 [docs/CHAPTER4_FINAL_SEALED.md](docs/CHAPTER4_FINAL_SEALED.md)，**非Writer R3**。全文原字节SHA-256（UTF-8 LF）：`6e2711214b02c7ee9f3673e0d4fd55e4086ea4c118e034e78ae3f6c90a978259`。冻结L1=1、L2=5、L3=10题逐字/同父题/同序PASS；7天试用604800秒与金额算式PASS；12项修复、Writer R2原稿、差异及来源核验归档于本轮Owner审核ZIP（不在docs重复放过程稿）。**第5章已经Writer V1→G3 RETURN→Writer R2→G3 R2 RETURN，后由Owner授权Reviewer直修并G4封板；详见下方独立记录。**

**B线第5章｜G4 Owner授权直修封板（2026-10-20）：** Writer V1→G3 R1 `RETURN`（19项）→Writer R2→G3 R2 `RETURN`（11项，P0六/P1四/P2一），Owner随后明确授权Reviewer直接以Writer R2**完整正文**为底稿完成定向修复、复核、正式冻结并入库。**本轮是Reviewer直修，不是Writer R3，也没有新一轮第三方独立审核。**正式正文唯一有效路径：[docs/CHAPTER5_FINAL_SEALED.md](docs/CHAPTER5_FINAL_SEALED.md)；原字节UTF-8 LF SHA-256：`221dc9a015d8ff8df89aa36546f02e55bd376fb80ea206a088cbddfff23e4fbf`；Git Blob SHA：`c9ca5129e1b51386e5e9a2b766013c6d576e5061`；首次正文写入commit：`622fdb886d9fde1a108f4c5c5b30d487846dea98`。冻结L1=1/L2=5/L3=10、5.2直接成节逐字同序归属PASS；JSON、Python围栏及退款70+70>100、折算15美元、8组逻辑反例静态核验PASS。修复Boleto/OXXO凭单、OXXO MXN货币、退款功能、processing主动补偿、退款事务持久预留、Outbox远程幂等、Refund API、首期/续费订阅状态、capture_before路径及30分钟取消边界。**真实支付、退款、仓储及银行端到端均NOT_RUN**。完整Writer R2原稿/自检、R1/R2审核报告、11项修复审计、全文差异与SHA清单随Owner本轮离线审计ZIP归档，不在docs保留过程版本。跨章协调编号：`X-B05-01`第4/5章凭单状态、`X-B05-02`第5/7章退款能力与法律义务、`X-B05-03`第5/6章支付成功不等于银行到账、`X-B05-04`第5/8章invoice.paid不等于新现金、`X-B05-05`第三/第四板块外部履约幂等；交唯一总控，不擅改其他章。**B线章级内容现已完成，等待全板块G5-G8和跨章复核，不自行开启未授权的新章。**

**C线第6章：** Writer V1→G3 R1 RETURN（22项）→Writer V2→G3 R2 RETURN（12项）；Owner于2026-10-20授权本C线Reviewer在Writer V2完整底稿上直修、复核、正式冻结并写入项目库。正式唯一版本为 [docs/CHAPTER6_FINAL_SEALED.md](docs/CHAPTER6_FINAL_SEALED.md)，**不是Writer V3**。冻结L1=1、L2=5、L3=11逐字同父题同序PASS；1000→785.50美元的MODEL_ASSUMPTION算例复算PASS；ISO 20022、外汇现行法规、9610、VAMP、账户及追踪边界等R2 12项定点修复；实际结汇/银行卡入账测试`NOT_RUN`。正文归一化UTF-8 LF SHA-256 `d9b12880dc5a78367f946fe3d634de3ede96b549e0619b9a01bd2b4871ca1322`；Git Blob `ef9097eed65fab73b9e8b76e3b2855e869f16bf1`；实际入库Commit [`2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c`](https://github.com/entropy-student/project/commit/2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c)。逐项修复、原版V2、自检和完整差异在Owner审核离线归档ZIP；未将其当成独立Writer V3或未经审校直接PASS。已与正式第1章卖方/MoR及第4章买家支付问题做接口核对；第5、7、8等未封板正文不可虚构交叉通过，跨章待总控后续复核。**本句为第6章封板当时的历史启动信息；第7章已于2026-10-20另经Owner授权Reviewer直修封板，见后续独立记录。**

**C线第7章（Owner授权直修封板，2026-10-20）：** Writer V1→G3 R1 RETURN（23项）→Writer V2→G3 R2 RETURN（14项：P0五项、P1八项、P2一项）；Owner于本轮授权Reviewer基于V2完整正文定向直修、复查、正式封板写回。唯一正式正文：[docs/CHAPTER7_FINAL_SEALED.md](docs/CHAPTER7_FINAL_SEALED.md)，非Writer V3。冻结L1=1/L2=5/L3=10逐字同序、7.5直接成节PASS；算例100→96.80美元、重复50美元收款一笔退款→46.50美元、200→193.90美元等复算PASS。修复Visa VAMP最低1500欺诈及争议事件（非交易数）、Mastercard HECM 3%与300笔、Visa 13.2/13.6、退款业务持久幂等/并发预占、3DS条件、EU SaaS撤回权、ROSCA提醒边界、ARN、卡争议费用、准备金期限及五渠道分流。UTF-8 LF SHA-256：c2f99be265ed31992520b771ca3bdbf7371b9517698047d39643876b288d16d8；Git Blob：6a968aedc9351bbacdbaf6d99c91946652ab2fd4；正式正文创建Commit：[d01f4e5fd190816a9451c95110c93e6b9ff4a211](https://github.com/entropy-student/project/commit/d01f4e5fd190816a9451c95110c93e6b9ff4a211)。本轮为Reviewer直修而非第三轮独立Writer返稿；真实收退款、拒付、SWIFT追款、银行冻款申诉NOT_RUN。V2完整原稿及自检、G3复审报告、14项修复/完整差异和SHA清单归档于本轮离线审计包，不在docs并行存历史候选。跨章留总控：第5/7章退款重试职责、第6/7章准备金及出款接口、第8章模型180天不能等于统一解冻期限、第4/7章续费提醒法律边界。C线章节已结束，后续统一总控跨章复核，不自行重写其他章。

**D线第8章：** Writer V1→G3 R1 RETURN（21项）→Writer R2→G3 R2 RETURN（3项P0、9项P1）；Owner于2026-10-20明确授权D线Reviewer直接以Writer R2全文为底稿做最小必要修订、复核、正式封板及入库。Reviewer完成12项R2定向修复，并额外独立发现80 USD订单利润明细漏列2 USD，补充逐单技术服务成本作为`MODEL_ASSUMPTION`并重新复算。冻结L1=1/L2=5/L3=9、8.1直接成节同序同父题PASS；118 USD资金桥接、80 USD利润压力测试、100 USD保证金双轨、银行余额调节与月度现金跑道等13组算式静态PASS；法律、平台动态事实按法域/版本条件化。**唯一正式全文：** [docs/CHAPTER8_FINAL_SEALED.md](docs/CHAPTER8_FINAL_SEALED.md)，不是Writer R3；原字节UTF-8 LF SHA-256：`61b1042262a32aac36d6f7d3ad55ec79f5504458b1f79418dc365a4610d7aa98`；Git Blob：`fea889c88bd276b2abaa16727335e07d08183ffc`；正文首次入库Commit [`dca1392bc879767eea354d36fcefa2e93d203afb`](https://github.com/entropy-student/project/commit/dca1392bc879767eea354d36fcefa2e93d203afb)。完整Writer R2、自检、G3 R2报告、Reviewer全差异、修复审计及SHA-256随本轮Owner离线证据ZIP归档，**不在docs重复存过程稿**。真实收款结汇或纳税行为`NOT_RUN`；跨章接口：支付/账户主体归1/2/3/6，交易真实状态归5，争议归7，国内税务归9，海外税务归10，由唯一总控集中裁决，不因第8章通过宣称未封板其他章节已通过。**D线下一一级问题为第9章《在国内做跨境生意，要交哪些税？》，仅启动G2独立Writer完整离线工作包、Writer首稿待交；第10章未启动。**

**D线第9章（Owner授权Reviewer直修与G4封板，2026-10-20）：** Writer V1→G3 R1 `RETURN`（20项，9项P0）→Writer R2→G3 R2 `RETURN`（14项：6项P0/6项P1/2项P2）；Owner本轮明确授权D线Reviewer以Writer R2完整底稿按最小必要原则直接纠正、再次静态回归、冻结并写回正式项目库。**这不是Writer R3，也未进行真实税务申报。**唯一正式正文为 [docs/CHAPTER9_FINAL_SEALED.md](docs/CHAPTER9_FINAL_SEALED.md)，冻结L1=1、L2=5、L3=12题同序同父题PASS。重点修复：2026出口退免税5号公告第44/45/48条、出口征税11号公告第7条的70万元含税换算、合法进项抵扣模型、海关稽查条例第2/7/31条、数字服务/应用商店VAT及法律卖方条件、2026税表字段与小额零星采购1000元日次门槛、公司/个体户个税及跨章链接；原`MODEL_ASSUMPTION`与真实合规资格严格分离。出口例假设700000元应税销售额与13%税率，销项税约80530.97元、满足抵扣前提时另以65000元合法进项抵扣，增值税应缴约15530.97元。正式正文UTF-8 LF SHA-256 `bc6cadbc424345554ec30238503260e612d80a92f9e1757bd44e9863d1ddba6b`；Git Blob `2dfcc8682867b9f9744c66522229de05c82438dc`；末次正文归一化/标记更正commit [`37e7874230bf458e2358e815db415e0d32e93a12`](https://github.com/entropy-student/project/commit/37e7874230bf458e2358e815db415e0d32e93a12)。Writer R2、自检、先前R2审核报告、直修差异、静态复核与SHA256另存本轮Owner离线审计ZIP，**不把过程稿存入docs**。实际申报、退税、结汇均为`NOT_RUN`。跨章剩余待总控协调：第8/9章收入确认及销售额/现金入账边界；第6/9章收汇凭证与税务申报分工；第9/10章中国境内税收与目的地VAT/GST/所得税及双重征税抵免；不擅改其他正文。**D线下一一级问题：第10章《卖给海外客户，还要在当地交税吗？》；只开启自包含G2独立Writer完整离线工作包，Writer首稿待回；第10章不是本轮正式封板内容。**

**D线第10章（Owner授权Reviewer直接修复/G4封板，2026-10-20）：** Writer V1→G3 R1 `RETURN`（23项，P0十/P1十/P2三）→Writer R2→G3 R2 `RETURN`（17项，P0七/P1八/P2二）；Owner随后明确授权本D线Reviewer直接以Writer R2**完整正文**为底稿定向修复、静态复验、正式冻结并入库。**不是Writer R3，未进行新一轮第三方Writer自检或真实申报。**唯一正式正文：[docs/CHAPTER10_FINAL_SEALED.md](docs/CHAPTER10_FINAL_SEALED.md)。冻结L1=1/L2=6/L3=13逐字同父题同序，10.3直接成节PASS。17项闭环包括中美协定第5(3)(c)明确包含服务PE（纠正此前R1 Reviewer误判，必须由唯一总控跨章核对）、2026 EU 3欧元按关税分类项目而非件数、10万欧元电子服务地点单证豁免欧盟设立条件、美国来源服务/软件许可区分、W-8/美国忽略实体、进口VAT抵扣资格、香港FSIE非股权资产、CRS NFE分类、Form5472/平台销售税剩余义务及自动化成本案例。关键静态复算：5件同类T恤=3欧元、三件同类T恤+一表=6欧元；5州×4季×35—60美元=700—1200美元；教学方案N133/N134的相对成本比较已核对。UTF-8 LF SHA-256：`506e8cf6e2b26dd6bea80a43e68ff29e7cac163347adc71cffca92cfae6032b6`；Git Blob：`5defb3b707f79491504adaa09424e79a56e27e29`；最终正文Commit [`afbc447f849399f75e6749b0675f77c273f85031`](https://github.com/entropy-student/project/commit/afbc447f849399f75e6749b0675f77c273f85031)。完整Writer R2、自检、两轮G3审查、17项Reviewer直修记录、完整diff和SHA256存于离线审计包 `CB03_CH10_OWNER_DIRECT_FIX_G3_G4_AUDIT_20261020.zip`，不将过程稿放入docs。**银行、真实交易、VAT申报、IRS税表、退税/税额抵免均`NOT_RUN`**。跨章总控待协调：`X-D10-01`第1/3/10章服务PE及此前Reviewer错误；`X-D10-02`第8/10章关税成本和进口VAT；`X-D10-03`第9/10章版税预扣/收入来源/所得税抵免；`X-D10-04`第1/10章美国LLC/5472/W-8；`X-D10-05`第5/7/10章平台/MoR真实税务责任。**第10章为本板块最后一章，D线3/3章完成；转唯一总控，不启动第11章。**

**G4结束时历史下一批Gate（非当前待办）：** A线第1—3章均已G4，等待全书G5—G8；**B线第4/5章均已G4，无下一章Writer Gate，待唯一总控跨章复核**；C线6—7章均已G4封板，进入总控跨章复核；D线第8/9/10章均按Owner逐章特定授权G4封板，四线10/10章级正文完成；下一步由唯一总控开展跨章复核与G5—G8阶段，不自动宣称全板块CLOSED。

## 总控专项｜第5—8章跨章一致性检查（2026-10-20）
**仅只读比对现行第5/6/7/8章正式正文，不等于G5/G6全书审核，未执行真实系统测试，未修改任何已封板章节。** 详见本轮Owner离线审计ZIP的`03_CH05_08_CROSS_CHAPTER_INTERFACE_AUDIT.md`。
- `X-5678-01` 第5章持久化退款预占+稳定幂等键，与第7章退款预占/同业务重试一致；落地时须统一本地退款号、币种最小单位和`reserved/pending/unknown`状态映射。
- `X-5678-02` 第6章正文否认统一准备金期限，但Mermaid“如90—180天期满→可用余额”可能被误读成必然释放；第7章正确写无统一期限或到期保证。列为`FLAG_VISUAL_QUALIFIER_G5`候选，**不擅改第6章**。
- `X-5678-03` 第7章争议费示例15—25美元为`MODEL_ASSUMPTION`；第6章和第8章均按合同、资金交易归期扣实际费用，原则一致，勿重复计算。
- `X-5678-04` PSP锁定的滚动准备金（可用资金）不同于第8章成本模型中预期退款/售后损失准备金（经营/损益），需G5统一术语以防误读；第8章已提示Gross/Signed两种互斥对账法。
- `X-5678-05` 第5章`invoice.paid`可能零金额/余额抵扣而无新增现金，第8章SaaS年费预收跨期确认为收入；三者不同口径，建议术语索引。
- `X-5678-06/07` 第5章服务端付款确认、第6章银行到账、第7章后续拒付及依法退款决定，职责边界基本相容。
**目前没有发现可仅凭上述局部命题断定必须立即解冻第5—8章的严重矛盾。** 两项表达/术语风险待G5/G6统一审查、Owner选择，不降低章节已经确认的G4状态。

## G5全板块研究与Owner决策交接（2026-10-20；仅记录，不改封板章）

**审查固定基线：** 主分支Commit `0400c982df2f9123850fe59dec5cb5faba201b08`，SOP、唯一交接、冻结框架及全部10章正式正文。十章结构核验：52/52道L2与113/113道L3**逐字、编号、父题、顺序一致**，四处二级直接成节保留；相关相对章节链接存在。没有进行支付/银行/税务实测或G6独立盲审。

**完整Owner决策报告：** `CB03_G5_FULL_BOARD_OWNER_DECISION_PACK_20261020.zip`（本次Owner对话交付，含《G5全书独立审查及Owner决策矩阵》，原始固定Git Blob清单、13项定位/原文/官方证据/最小建议/复验标准、SHA256）。不在正式`docs/`增加第二份候选或修改正文。G5矩阵：**P0一项、P1九项、P2三项**，须由Owner明确选择采纳、暂缓或不采纳；不得因报告提出意见就声称已经修改章文。

- **`G5-01 / P0事实错误`**：第10章§10.5.1约L389，W-8BEN-E把中美协定“无现代独立LOB章”的描述引向`No LOB article in treaty`选项；IRS Table4明确中国1986年议定书有限制享惠测试。需核对1986协议及IRS W-8BEN-E Line14b后纠正。官方原件：https://www.irs.gov/pub/irs-lbi/Tax_Treaty_Table_4.pdf ; https://www.irs.gov/pub/irs-trty/china.pdf ; https://www.irs.gov/instructions/iw8bene 。**在Owner批准前不改已封第10章。**
- **`KEEP-PE-10.4.4`**：第10章中美税收协定第5条第3款(c)有关同一/相关项目、人员在另一国服务、任意12个月超过6个月的服务型常设机构讲解为**经官方协定证实正确**。此前“中美无服务PE”审稿判断错误，不得继续传播；不要与个人183天及远程客户订单混为一谈。
- **`G5-02—10/P1`**：MLI不自动修改中美协定、准备金释放流程图、三种不同资金预留概念、12个月订阅的履约收入时点、境外抵免方式选后5年不变、CRS现金被动资产、MoR税务覆盖边界、ETBUS/ECI与PE、间接税抵免与会计区分。详见报告逐项矩阵。
- **`G5-11—13/P2`**：付款确认/银行现金/营业收入术语桥接、进阶技术分层及全书双向路标；建议后续G7处理但需遵守核心事实不改。
- **G4章文全部保持正式冻结**，当前状态仅`G5_RESEARCH_REPORT_DELIVERED / STOP_AT_OWNER_DECISION`。Owner对矩阵逐项决策后交独立全新Reviewer执行G6盲审；只有授权的G6/G5合并修订才按G3/G4复验修改原正文。此阶段不启动G7或G8，也不宣布CLOSED。

## G6｜Owner批准的G5/G6综合意见已实施，G7纯文字Gate开启（2026-10-20）

**Owner最新明确批准：** “按照你的建议来，完成后正式冻结这几篇文章。记得记录相关文档。然后开启下一个gate，让另一个agent帮我们review下这几章文章连贯性与语言可读性等软性信息，核心内容不动。搞一份提示词和工作包。”本轮由唯一总控Reviewer直接在10章**当前正式正文**上作针对性变更、静态独立回归并按Owner授权再封板，不得写成独立Writer新交稿，也不代表真实银行/税局/支付/海关实测。

**权威版本：** 以本轮最终合并并从GitHub `main`回读的唯一`docs/CHAPTER1_FINAL_SEALED.md`—`CHAPTER10_FINAL_SEALED.md`为准；冻结框架Git Blob `332950b8579f25c255595af5b9f12766340e840f`保持不变；**一级10、二级52、三级113全部逐字同父题、同序通过**，27幅Mermaid与代码围栏完整；第三章原文不做无效扩写。

### 已采纳的事实修正与系统性补充

| ID / 原G5来源 | 受影响材料 | 实际处理结果 |
|---|---|---|
| F01 / G5-01 | 第10章10.5.1 | 核验中美1986年议定书对非个人实体享协定待遇的限制，删除从“无现代独立LOB章节”推导`No LOB article in treaty`选项的错误引导；真实Line14b按有效协议及IRS规则核定，不提供统一选项。 |
| F02 | 第9章9.2.2 | 抵免的纳税凭证与税收居民证明分开，补居民个人合格证明、无证明时的合法替代与五年补证追溯；与10.5.2交叉链接。 |
| F03 | 第10章10.2.3 | 非欧盟OSS为自愿集中申报方式，不等于VAT可选缴；根据真实卖方、消费地和B2B/平台角色选择本地或OSS。 |
| F04 | 第9章9.2.1 | 区分外币主营单位依会计法可选择外币记账本位币、财务报表人民币列报与各税种法定折算。 |
| G01、G5-02 | 第10章10.4.4 | 中美服务PE第5(3)(c)保留原正确条款；明示美国非MLI缔约方，MLI不自动引入新中美协定条款。 |
| G03、M02 | 第1、2章 | FinCEN 2026美国BOI主体分类提醒；收款资质至银行/合规结汇六关，区分开户、收单与真正出款。 |
| G04 | 第4、5、7章 | 银行直接借记SEPA/ACH的Mandate、延迟与授权追索窗口，避免将银行扣款误套卡式争议与立即发放不可撤销权益。 |
| G05、G5-04/05 | 第6、8章 | 第6章Mermaid准备金释放改为**合同条件+风控核验**，非固定天数必然释放；第8章补法律卖方/平台代征/MoR会计主要责任人与总额/净额判断及SaaS非统一12月等额摊销。 |
| G06、G5-06 | 第9、10章 | 企业境外抵免两种方式一经选择五年内不得变更，区别居民个人抵免；复核教学算例原币种与人民币单位。 |
| G07 | 第9章 | 2026年第16号跨境电商出口退运、原状六个月、监管代码、非食品以及已退税补缴的退款/物流/税务证据闭环。 |
| M01、G02有限、M04—M11选择性 | [PRACTICAL_PATHS_APPENDIX.md](PRACTICAL_PATHS_APPENDIX.md) | 三种大陆经营者端到端演练、合同/支付/银行/税务归属、数据库字段与检查表、SEPA/ACH、关联交易五问、税目逆例、关停与动态政策索引；全为`MODEL_ASSUMPTION`及`NOT_RUN`。 |

**未采纳或明确后置：** 大幅重写10章、新增第11章、修改冻结问题原文或父子关系、把跨国集团全球最低税/Pillar Two作为个人必修、部署企业级支付编排、不核实资格就宣称某服务商已提供实测支持。纯语言润色与长段落结构优化全部交下轮G7独立Editor，不在内容Gate越权更改。

**实操附录定位：** 为避免将已封板十章扩成多份重复课件，Owner此次允许在板块根目录保留**一份明确的非冻结、非第11章**的`PRACTICAL_PATHS_APPENDIX.md`。该附录是十章共用工作单；所有条款仍以各章正式正文、官方法规和实际合同为准，G8归档时再核对其长期保留安排。

**审批与Gate停点：** `G6_OWNER_AUTHORIZED_CONTENT_REVISED / G6_STATIC_QA_PASS / 10_CHAPTERS_RESEALED / G7_EDITOR_WORKPACK_READY / G7_INDEPENDENT_EDITOR_PENDING / BOARD_NOT_CLOSED`。独立Editor只负责跨章过渡、重复压缩与可读性，不得改核心事实/公式/代码/法规/模型标签/冻结标题；不得修改GitHub，先返回完整候选ZIP，由总控G7复审、Owner再定最终G8。封板内容**无真实支付/出款/退运/纳税实测，NOT_RUN**。

## G7｜Owner授权Reviewer直修、独立复验并正式再封板（2026-10-20）

**审批与身份边界：** 独立Editor提交`CB03_G7_EDITOR_DELIVERY_20261020.zip`完整10章候选和附录；G7独立R1审核`RETURN`，共有**16项（P0五/P1九/P2二）**。Owner在本轮明确要求Reviewer直接修复、复查、通过后不再做额外修改。**本轮由Reviewer以G6固定正文与Editor V1全文为依据直修，不存在Editor R2交付，也不冒称新一轮独立G6事实审查或外部交易测试。**

**结果：G7 PASS / 内容与编辑均正式再封板；第1—10章继续`CHAPTER_FINAL_SEALED`。** 经逐条审查仅保留不改变含义的语言过渡和纯文档状态修正，撤回Editor V1新增的16位卡号、Webhook“加密签名且权威即最终”、卡组织“法定”争议程序、退款“无条件”、支付机构余额“托管账户”、MoR法定身份及主体准入等越权表述。第9章删除“第10章尚未开始”的过时文字、第8/10章亦清理了旧Gate编辑注记；跨章实操附录后一个“七”更正为“八”。**第1、2、3、5、7章正文与G6固定版原字节一致，不为凑修改而改写。**

**全文静态复验：** 10章冻结题目`52 L2 + 113 L3`逐字、编号、父题与顺序一致；4处L2直接成节保留；11份（10章+实操附录）正式稿与G6基线对照，**72个完整代码围栏块、27幅Mermaid图、历史G7记录35个块公式（口径未明；本轮G8按`$…$`配对计41处）、所有原来源URL、`MODEL_ASSUMPTION/UNKNOWN/NOT_RUN`标记和代码内容**均严格保持；ZIP原字节SHA-256与Git Blob均归档。G7完成的是**编辑不变性静态校验**，不是支付、银行或税务生产实测。

**实际更新的正式内容：** 第4、6、8、9、10章及`PRACTICAL_PATHS_APPENDIX.md`共6份；再维护本唯一交接、本板块README和父级README。G7完整直修/逐项16条闭环及Diff证据：`CB03_G7_OWNER_DIRECT_FIX_FINAL_SEAL_EVIDENCE_20261020.zip`（Owner对话独立留档，不并列上传多套正式稿至docs）。以本次GitHub合并后`main`回读的实际Commit和Git Blob为准。

**G7历史停点（现已由G8记录取代）：** `10/10_CHAPTER_FINAL_SEALED / G7_EDITORIAL_PASS_OWNER_DIRECT_FIX / G8_FINAL_ARCHIVE_PENDING_OWNER / BOARD_NOT_CLOSED`。正式教材文字层面按Owner决定不再开启G7修改；G8仅执行最终归档与关闭检查，**未经Owner特别批准不因G8发起内容改写或宣称CLOSE**。HTML、PDF、真实商户测试、税务申报均不属本轮。

## G8｜Owner授权四项定向修复、归档复验与暂时冻结（2026-10-20）

**授权/流程：** 新任Reviewer先对GitHub固定`8f4629ceda0ad713ea0d1f85db471bdc1ca14017`只读独立审核，给出`RETURN_G8_TARGETED_FACT_AND_ARCHIVE_REPAIR`（P1×2、P2×2、P0×0）。Owner随即要求“请你开始修复，完成后暂时冻结，然后汇报一下第三部分的文档架构”。**同一Reviewer**按授权直接最小范围修复并静态回归，不冒称新Editor R2或额外独立第三方Review。本轮正文/导航修订固定GitHub提交：[29a206cb3c21f33d823d12e8d850cf49b30abd4f](https://github.com/entropy-student/project/commit/29a206cb3c21f33d823d12e8d850cf49b30abd4f)。

| 编号 | 精确处理及复验标准 | 结果 |
|---|---|---|
| G8-01 P1 | 第10章§10.5.2仅纠正流转税在会计上不必然计入损益的括号说明，区分代收税款负债、可抵扣进项税与符合条件的成本/资产；与第8章§8.1一致。新增财政部《增值税会计处理规定》官方链接，保留“流转税不能作为境外所得税抵免”的原有结论。 | 静态PASS |
| G8-02 P1 | 更新板块及父级README中B/C待复核过时状态；下列最新原字节SHA-256及Git Blob表与修订提交固定内容对应，历史章级/G5/G6/G7旧指纹不再被当作当前版本。 | 静态PASS |
| G8-03 P2 | G7审核历史写35处数学块且口径不明；现在统一按`$…$`成对公式计**41处**，章2=11、5=4、6=1、7=1、8=13、9=6、10=5；未改任何公式正文。 | 静态PASS |
| G8-04 P2 | 第9章四处电子税务局菜单导航删除多余的`$ → # 第三板块《支付、税务与经营主体》｜唯一现行 Reviewer 交接

> **UPDATED：2026-10-20｜Owner正式批准第三板块四线并行推进及唯一总控**
> **STATUS：G1_FRAMEWORK_FROZEN / CH1—CH10_FINAL_SEALED / G6_OWNER_AUTHORIZED_REVISION_REVIEWED / G7_EDITORIAL_PASS_OWNER_DIRECT_FIX / G8_PASS_CANDIDATE / STOP_AT_OWNER_FINAL_APPROVAL / BOARD_NOT_CLOSED**
> **冻结：唯一核心1 / 一级10 / 二级52 / 三级113；二级直接成节4处。**
> **正文：10/10章均获Owner逐章授权Reviewer基于完整Writer底稿定向修复并按G4正式封板入库；A线1—3章、B线4—5章、C线6—7章、D线8—10章全部章级正文完成。G5全书三份研究报告与独立Reviewer复审完成；Owner本轮明确批准按总控建议完成实质性定向修复并再冻结；G6静态内容复核已完成，G7 Editor V1已独立审查并由Owner明确授权Reviewer直修16项、复验PASS、原文再封板；G8由新Reviewer独立复核发现2项P1及2项P2；经Owner授权由该Reviewer定向直修并作静态复验，现为G8候选通过、正文暂时冻结，仍为`BOARD_NOT_CLOSED`。**

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
| 全书正式正文 | 10/10 | CH1—CH10均获Owner逐章授权G4写入main；G5/G6/G7均已完成，G8已复验为PASS_CANDIDATE，Owner最终CLOSE尚未批准 |

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
| A｜经营准备 | 1—3：主体/法律卖方、渠道选型、开户接入 | **第1—3章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |
| B｜完成交易 | 4—5：买家付款、服务端支付确认 | **第4—5章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |
| C｜资金管理 | 6—7：清算到账、退款/拒付/冻结 | **第6—7章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |
| D｜财务税务 | 8—10：会计利润、境内税务、境外税务 | **第8—10章已封板，G5—G7审核完毕** | G8_PASS_CANDIDATE，待Owner最终批准 |

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

## 四、四线并行章节执行沿革（历史记录，不代表当前Gate）

**A线第1章**含冻结6个二级、15个三级。Writer V1→G3 RETURN R1（18项）→Writer R2→G3 RETURN R2（14项），Owner已直接授权Reviewer基于Writer R2整篇改正并G4封板。最终正式正文为 [docs/CHAPTER1_FINAL_SEALED.md](docs/CHAPTER1_FINAL_SEALED.md)，不是Writer R3；Reviewer纠错闭环、差异及来源自检在Owner本轮独立审计ZIP，原字节SHA-256：`3fc7ff2b60213b726e7ccf91ec7dced127eb1c38907a1ae3305156707e03cbd5`（UTF-8 LF）；正式Git Blob以main回读为准。**A线第2章已由Owner授权Reviewer基于Writer R2完整原稿定点修复后正式封板，第3章《选好收款方式，怎么才能用起来？》G2独立Writer首稿现启动。**


**A线第2章｜G4 Owner授权直修封板补记（2026-10-20）：** Writer V1→G3 R1 `RETURN`（20项）→Writer R2→G3 R2 `RETURN`（15项）；Owner随后明确授权Reviewer以Writer R2**完整底稿**直接最小纠错、复核、正式冻结并入库。没有Writer R3交付，也没有第三轮独立Writer自检。正式正文唯一有效文件：[docs/CHAPTER2_FINAL_SEALED.md](docs/CHAPTER2_FINAL_SEALED.md)，原字节SHA-256 `30941007e8bd6c83467e89752296662766dbec526e3efab0a1d8218ba158f340`，Git Blob `5a2787b3ac81579b9b7417780d322699f605bb30`，UTF-8/LF；冻结L2=6/L3=13逐字同父题同序核验PASS，6幅Mermaid源码围栏和模型60美元→56.84美元、15美元→13.54美元复算PASS。修正实际覆盖逐产品准入与UNKNOWN、MoR责任、授权/确认、备用切换、B2B付款、Shopify额外费用、条件准备金、卖家保障、PCI迁移与公式控制字符；**官方动态费率、真实商户申请/支付/出款均未实测 `NOT_RUN`**。Writer R2原稿、自检、Reviewer R2审计报告、15项直修闭环及全量差异归档于Owner本轮独立审计ZIP，不在仓库docs存过程版本。**下一步：A线第3章（L2=4/L3=10）G2 Writer V1完整离线ZIP已制作、未收到首稿。**

**A线第3章（Owner授权Reviewer直修封板，2026-10-20）：** Writer V1→独立G3 R1 RETURN（22项）→Writer R2→独立G3 R2 RETURN（13项，P0六/P1六/P2一）；Owner明确授权由本Reviewer在R2完整原稿上最小修复，未收到Writer R3，亦未增设第三方G3。最终正文[docs/CHAPTER3_FINAL_SEALED.md](docs/CHAPTER3_FINAL_SEALED.md)；UTF-8 LF原字节SHA256 `4dceaaadf7ab2a3873c254ce239bb94c8a8d633011d396702f52804a65623291`；预期Git Blob `613c58fddbe0fbe63b5c73be10285aabebea3da2`，合并后以main回读为准。冻结L2=4/L3=10逐字同序同父题PASS，7幅Mermaid/14围栏和控制字符静态检查PASS。13项修复覆盖PCI SSC 2025 SAQ A脚本资格/2026 ASV、FinCEN适用边界、非线性账户权限、订单/金额/币种/支付对象服务端核验、Stripe `whsec_`、Shopify China Advanced 0.6%/受邀Early Access、MATCH条件、退款失败与幂等、平台原生支付/插件差异和营销邮件法域条件。真实PCI ASV扫描、商户开户、沙箱/生产付款退款、银行入账均`NOT_RUN`。R2原稿/自检、Reviewer完整审计、差异、官方证据、第5—8章总控跨章复核保存在Owner本轮完整离线ZIP；**A线章级内容完成，不再新开一级章节**。

**B线第4章：** Writer V1→G3 R1 RETURN（22项）→Writer R2→G3 R2 RETURN（12项）→Owner于2026-10-20明确授权Reviewer从Writer R2全文直接纠错并G4封板；正式正文为 [docs/CHAPTER4_FINAL_SEALED.md](docs/CHAPTER4_FINAL_SEALED.md)，**非Writer R3**。全文原字节SHA-256（UTF-8 LF）：`6e2711214b02c7ee9f3673e0d4fd55e4086ea4c118e034e78ae3f6c90a978259`。冻结L1=1、L2=5、L3=10题逐字/同父题/同序PASS；7天试用604800秒与金额算式PASS；12项修复、Writer R2原稿、差异及来源核验归档于本轮Owner审核ZIP（不在docs重复放过程稿）。**第5章已经Writer V1→G3 RETURN→Writer R2→G3 R2 RETURN，后由Owner授权Reviewer直修并G4封板；详见下方独立记录。**

**B线第5章｜G4 Owner授权直修封板（2026-10-20）：** Writer V1→G3 R1 `RETURN`（19项）→Writer R2→G3 R2 `RETURN`（11项，P0六/P1四/P2一），Owner随后明确授权Reviewer直接以Writer R2**完整正文**为底稿完成定向修复、复核、正式冻结并入库。**本轮是Reviewer直修，不是Writer R3，也没有新一轮第三方独立审核。**正式正文唯一有效路径：[docs/CHAPTER5_FINAL_SEALED.md](docs/CHAPTER5_FINAL_SEALED.md)；原字节UTF-8 LF SHA-256：`221dc9a015d8ff8df89aa36546f02e55bd376fb80ea206a088cbddfff23e4fbf`；Git Blob SHA：`c9ca5129e1b51386e5e9a2b766013c6d576e5061`；首次正文写入commit：`622fdb886d9fde1a108f4c5c5b30d487846dea98`。冻结L1=1/L2=5/L3=10、5.2直接成节逐字同序归属PASS；JSON、Python围栏及退款70+70>100、折算15美元、8组逻辑反例静态核验PASS。修复Boleto/OXXO凭单、OXXO MXN货币、退款功能、processing主动补偿、退款事务持久预留、Outbox远程幂等、Refund API、首期/续费订阅状态、capture_before路径及30分钟取消边界。**真实支付、退款、仓储及银行端到端均NOT_RUN**。完整Writer R2原稿/自检、R1/R2审核报告、11项修复审计、全文差异与SHA清单随Owner本轮离线审计ZIP归档，不在docs保留过程版本。跨章协调编号：`X-B05-01`第4/5章凭单状态、`X-B05-02`第5/7章退款能力与法律义务、`X-B05-03`第5/6章支付成功不等于银行到账、`X-B05-04`第5/8章invoice.paid不等于新现金、`X-B05-05`第三/第四板块外部履约幂等；交唯一总控，不擅改其他章。**B线章级内容现已完成，等待全板块G5-G8和跨章复核，不自行开启未授权的新章。**

**C线第6章：** Writer V1→G3 R1 RETURN（22项）→Writer V2→G3 R2 RETURN（12项）；Owner于2026-10-20授权本C线Reviewer在Writer V2完整底稿上直修、复核、正式冻结并写入项目库。正式唯一版本为 [docs/CHAPTER6_FINAL_SEALED.md](docs/CHAPTER6_FINAL_SEALED.md)，**不是Writer V3**。冻结L1=1、L2=5、L3=11逐字同父题同序PASS；1000→785.50美元的MODEL_ASSUMPTION算例复算PASS；ISO 20022、外汇现行法规、9610、VAMP、账户及追踪边界等R2 12项定点修复；实际结汇/银行卡入账测试`NOT_RUN`。正文归一化UTF-8 LF SHA-256 `d9b12880dc5a78367f946fe3d634de3ede96b549e0619b9a01bd2b4871ca1322`；Git Blob `ef9097eed65fab73b9e8b76e3b2855e869f16bf1`；实际入库Commit [`2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c`](https://github.com/entropy-student/project/commit/2a2f15071f5f8ceefeb8f628e0db47a7f3adb39c)。逐项修复、原版V2、自检和完整差异在Owner审核离线归档ZIP；未将其当成独立Writer V3或未经审校直接PASS。已与正式第1章卖方/MoR及第4章买家支付问题做接口核对；第5、7、8等未封板正文不可虚构交叉通过，跨章待总控后续复核。**本句为第6章封板当时的历史启动信息；第7章已于2026-10-20另经Owner授权Reviewer直修封板，见后续独立记录。**

**C线第7章（Owner授权直修封板，2026-10-20）：** Writer V1→G3 R1 RETURN（23项）→Writer V2→G3 R2 RETURN（14项：P0五项、P1八项、P2一项）；Owner于本轮授权Reviewer基于V2完整正文定向直修、复查、正式封板写回。唯一正式正文：[docs/CHAPTER7_FINAL_SEALED.md](docs/CHAPTER7_FINAL_SEALED.md)，非Writer V3。冻结L1=1/L2=5/L3=10逐字同序、7.5直接成节PASS；算例100→96.80美元、重复50美元收款一笔退款→46.50美元、200→193.90美元等复算PASS。修复Visa VAMP最低1500欺诈及争议事件（非交易数）、Mastercard HECM 3%与300笔、Visa 13.2/13.6、退款业务持久幂等/并发预占、3DS条件、EU SaaS撤回权、ROSCA提醒边界、ARN、卡争议费用、准备金期限及五渠道分流。UTF-8 LF SHA-256：c2f99be265ed31992520b771ca3bdbf7371b9517698047d39643876b288d16d8；Git Blob：6a968aedc9351bbacdbaf6d99c91946652ab2fd4；正式正文创建Commit：[d01f4e5fd190816a9451c95110c93e6b9ff4a211](https://github.com/entropy-student/project/commit/d01f4e5fd190816a9451c95110c93e6b9ff4a211)。本轮为Reviewer直修而非第三轮独立Writer返稿；真实收退款、拒付、SWIFT追款、银行冻款申诉NOT_RUN。V2完整原稿及自检、G3复审报告、14项修复/完整差异和SHA清单归档于本轮离线审计包，不在docs并行存历史候选。跨章留总控：第5/7章退款重试职责、第6/7章准备金及出款接口、第8章模型180天不能等于统一解冻期限、第4/7章续费提醒法律边界。C线章节已结束，后续统一总控跨章复核，不自行重写其他章。

**D线第8章：** Writer V1→G3 R1 RETURN（21项）→Writer R2→G3 R2 RETURN（3项P0、9项P1）；Owner于2026-10-20明确授权D线Reviewer直接以Writer R2全文为底稿做最小必要修订、复核、正式封板及入库。Reviewer完成12项R2定向修复，并额外独立发现80 USD订单利润明细漏列2 USD，补充逐单技术服务成本作为`MODEL_ASSUMPTION`并重新复算。冻结L1=1/L2=5/L3=9、8.1直接成节同序同父题PASS；118 USD资金桥接、80 USD利润压力测试、100 USD保证金双轨、银行余额调节与月度现金跑道等13组算式静态PASS；法律、平台动态事实按法域/版本条件化。**唯一正式全文：** [docs/CHAPTER8_FINAL_SEALED.md](docs/CHAPTER8_FINAL_SEALED.md)，不是Writer R3；原字节UTF-8 LF SHA-256：`61b1042262a32aac36d6f7d3ad55ec79f5504458b1f79418dc365a4610d7aa98`；Git Blob：`fea889c88bd276b2abaa16727335e07d08183ffc`；正文首次入库Commit [`dca1392bc879767eea354d36fcefa2e93d203afb`](https://github.com/entropy-student/project/commit/dca1392bc879767eea354d36fcefa2e93d203afb)。完整Writer R2、自检、G3 R2报告、Reviewer全差异、修复审计及SHA-256随本轮Owner离线证据ZIP归档，**不在docs重复存过程稿**。真实收款结汇或纳税行为`NOT_RUN`；跨章接口：支付/账户主体归1/2/3/6，交易真实状态归5，争议归7，国内税务归9，海外税务归10，由唯一总控集中裁决，不因第8章通过宣称未封板其他章节已通过。**D线下一一级问题为第9章《在国内做跨境生意，要交哪些税？》，仅启动G2独立Writer完整离线工作包、Writer首稿待交；第10章未启动。**

**D线第9章（Owner授权Reviewer直修与G4封板，2026-10-20）：** Writer V1→G3 R1 `RETURN`（20项，9项P0）→Writer R2→G3 R2 `RETURN`（14项：6项P0/6项P1/2项P2）；Owner本轮明确授权D线Reviewer以Writer R2完整底稿按最小必要原则直接纠正、再次静态回归、冻结并写回正式项目库。**这不是Writer R3，也未进行真实税务申报。**唯一正式正文为 [docs/CHAPTER9_FINAL_SEALED.md](docs/CHAPTER9_FINAL_SEALED.md)，冻结L1=1、L2=5、L3=12题同序同父题PASS。重点修复：2026出口退免税5号公告第44/45/48条、出口征税11号公告第7条的70万元含税换算、合法进项抵扣模型、海关稽查条例第2/7/31条、数字服务/应用商店VAT及法律卖方条件、2026税表字段与小额零星采购1000元日次门槛、公司/个体户个税及跨章链接；原`MODEL_ASSUMPTION`与真实合规资格严格分离。出口例假设700000元应税销售额与13%税率，销项税约80530.97元、满足抵扣前提时另以65000元合法进项抵扣，增值税应缴约15530.97元。正式正文UTF-8 LF SHA-256 `bc6cadbc424345554ec30238503260e612d80a92f9e1757bd44e9863d1ddba6b`；Git Blob `2dfcc8682867b9f9744c66522229de05c82438dc`；末次正文归一化/标记更正commit [`37e7874230bf458e2358e815db415e0d32e93a12`](https://github.com/entropy-student/project/commit/37e7874230bf458e2358e815db415e0d32e93a12)。Writer R2、自检、先前R2审核报告、直修差异、静态复核与SHA256另存本轮Owner离线审计ZIP，**不把过程稿存入docs**。实际申报、退税、结汇均为`NOT_RUN`。跨章剩余待总控协调：第8/9章收入确认及销售额/现金入账边界；第6/9章收汇凭证与税务申报分工；第9/10章中国境内税收与目的地VAT/GST/所得税及双重征税抵免；不擅改其他正文。**D线下一一级问题：第10章《卖给海外客户，还要在当地交税吗？》；只开启自包含G2独立Writer完整离线工作包，Writer首稿待回；第10章不是本轮正式封板内容。**

**D线第10章（Owner授权Reviewer直接修复/G4封板，2026-10-20）：** Writer V1→G3 R1 `RETURN`（23项，P0十/P1十/P2三）→Writer R2→G3 R2 `RETURN`（17项，P0七/P1八/P2二）；Owner随后明确授权本D线Reviewer直接以Writer R2**完整正文**为底稿定向修复、静态复验、正式冻结并入库。**不是Writer R3，未进行新一轮第三方Writer自检或真实申报。**唯一正式正文：[docs/CHAPTER10_FINAL_SEALED.md](docs/CHAPTER10_FINAL_SEALED.md)。冻结L1=1/L2=6/L3=13逐字同父题同序，10.3直接成节PASS。17项闭环包括中美协定第5(3)(c)明确包含服务PE（纠正此前R1 Reviewer误判，必须由唯一总控跨章核对）、2026 EU 3欧元按关税分类项目而非件数、10万欧元电子服务地点单证豁免欧盟设立条件、美国来源服务/软件许可区分、W-8/美国忽略实体、进口VAT抵扣资格、香港FSIE非股权资产、CRS NFE分类、Form5472/平台销售税剩余义务及自动化成本案例。关键静态复算：5件同类T恤=3欧元、三件同类T恤+一表=6欧元；5州×4季×35—60美元=700—1200美元；教学方案N133/N134的相对成本比较已核对。UTF-8 LF SHA-256：`506e8cf6e2b26dd6bea80a43e68ff29e7cac163347adc71cffca92cfae6032b6`；Git Blob：`5defb3b707f79491504adaa09424e79a56e27e29`；最终正文Commit [`afbc447f849399f75e6749b0675f77c273f85031`](https://github.com/entropy-student/project/commit/afbc447f849399f75e6749b0675f77c273f85031)。完整Writer R2、自检、两轮G3审查、17项Reviewer直修记录、完整diff和SHA256存于离线审计包 `CB03_CH10_OWNER_DIRECT_FIX_G3_G4_AUDIT_20261020.zip`，不将过程稿放入docs。**银行、真实交易、VAT申报、IRS税表、退税/税额抵免均`NOT_RUN`**。跨章总控待协调：`X-D10-01`第1/3/10章服务PE及此前Reviewer错误；`X-D10-02`第8/10章关税成本和进口VAT；`X-D10-03`第9/10章版税预扣/收入来源/所得税抵免；`X-D10-04`第1/10章美国LLC/5472/W-8；`X-D10-05`第5/7/10章平台/MoR真实税务责任。**第10章为本板块最后一章，D线3/3章完成；转唯一总控，不启动第11章。**

**G4结束时历史下一批Gate（非当前待办）：** A线第1—3章均已G4，等待全书G5—G8；**B线第4/5章均已G4，无下一章Writer Gate，待唯一总控跨章复核**；C线6—7章均已G4封板，进入总控跨章复核；D线第8/9/10章均按Owner逐章特定授权G4封板，四线10/10章级正文完成；下一步由唯一总控开展跨章复核与G5—G8阶段，不自动宣称全板块CLOSED。

## 总控专项｜第5—8章跨章一致性检查（2026-10-20）
**仅只读比对现行第5/6/7/8章正式正文，不等于G5/G6全书审核，未执行真实系统测试，未修改任何已封板章节。** 详见本轮Owner离线审计ZIP的`03_CH05_08_CROSS_CHAPTER_INTERFACE_AUDIT.md`。
- `X-5678-01` 第5章持久化退款预占+稳定幂等键，与第7章退款预占/同业务重试一致；落地时须统一本地退款号、币种最小单位和`reserved/pending/unknown`状态映射。
- `X-5678-02` 第6章正文否认统一准备金期限，但Mermaid“如90—180天期满→可用余额”可能被误读成必然释放；第7章正确写无统一期限或到期保证。列为`FLAG_VISUAL_QUALIFIER_G5`候选，**不擅改第6章**。
- `X-5678-03` 第7章争议费示例15—25美元为`MODEL_ASSUMPTION`；第6章和第8章均按合同、资金交易归期扣实际费用，原则一致，勿重复计算。
- `X-5678-04` PSP锁定的滚动准备金（可用资金）不同于第8章成本模型中预期退款/售后损失准备金（经营/损益），需G5统一术语以防误读；第8章已提示Gross/Signed两种互斥对账法。
- `X-5678-05` 第5章`invoice.paid`可能零金额/余额抵扣而无新增现金，第8章SaaS年费预收跨期确认为收入；三者不同口径，建议术语索引。
- `X-5678-06/07` 第5章服务端付款确认、第6章银行到账、第7章后续拒付及依法退款决定，职责边界基本相容。
**目前没有发现可仅凭上述局部命题断定必须立即解冻第5—8章的严重矛盾。** 两项表达/术语风险待G5/G6统一审查、Owner选择，不降低章节已经确认的G4状态。

## G5全板块研究与Owner决策交接（2026-10-20；仅记录，不改封板章）

**审查固定基线：** 主分支Commit `0400c982df2f9123850fe59dec5cb5faba201b08`，SOP、唯一交接、冻结框架及全部10章正式正文。十章结构核验：52/52道L2与113/113道L3**逐字、编号、父题、顺序一致**，四处二级直接成节保留；相关相对章节链接存在。没有进行支付/银行/税务实测或G6独立盲审。

**完整Owner决策报告：** `CB03_G5_FULL_BOARD_OWNER_DECISION_PACK_20261020.zip`（本次Owner对话交付，含《G5全书独立审查及Owner决策矩阵》，原始固定Git Blob清单、13项定位/原文/官方证据/最小建议/复验标准、SHA256）。不在正式`docs/`增加第二份候选或修改正文。G5矩阵：**P0一项、P1九项、P2三项**，须由Owner明确选择采纳、暂缓或不采纳；不得因报告提出意见就声称已经修改章文。

- **`G5-01 / P0事实错误`**：第10章§10.5.1约L389，W-8BEN-E把中美协定“无现代独立LOB章”的描述引向`No LOB article in treaty`选项；IRS Table4明确中国1986年议定书有限制享惠测试。需核对1986协议及IRS W-8BEN-E Line14b后纠正。官方原件：https://www.irs.gov/pub/irs-lbi/Tax_Treaty_Table_4.pdf ; https://www.irs.gov/pub/irs-trty/china.pdf ; https://www.irs.gov/instructions/iw8bene 。**在Owner批准前不改已封第10章。**
- **`KEEP-PE-10.4.4`**：第10章中美税收协定第5条第3款(c)有关同一/相关项目、人员在另一国服务、任意12个月超过6个月的服务型常设机构讲解为**经官方协定证实正确**。此前“中美无服务PE”审稿判断错误，不得继续传播；不要与个人183天及远程客户订单混为一谈。
- **`G5-02—10/P1`**：MLI不自动修改中美协定、准备金释放流程图、三种不同资金预留概念、12个月订阅的履约收入时点、境外抵免方式选后5年不变、CRS现金被动资产、MoR税务覆盖边界、ETBUS/ECI与PE、间接税抵免与会计区分。详见报告逐项矩阵。
- **`G5-11—13/P2`**：付款确认/银行现金/营业收入术语桥接、进阶技术分层及全书双向路标；建议后续G7处理但需遵守核心事实不改。
- **G4章文全部保持正式冻结**，当前状态仅`G5_RESEARCH_REPORT_DELIVERED / STOP_AT_OWNER_DECISION`。Owner对矩阵逐项决策后交独立全新Reviewer执行G6盲审；只有授权的G6/G5合并修订才按G3/G4复验修改原正文。此阶段不启动G7或G8，也不宣布CLOSED。

## G6｜Owner批准的G5/G6综合意见已实施，G7纯文字Gate开启（2026-10-20）

**Owner最新明确批准：** “按照你的建议来，完成后正式冻结这几篇文章。记得记录相关文档。然后开启下一个gate，让另一个agent帮我们review下这几章文章连贯性与语言可读性等软性信息，核心内容不动。搞一份提示词和工作包。”本轮由唯一总控Reviewer直接在10章**当前正式正文**上作针对性变更、静态独立回归并按Owner授权再封板，不得写成独立Writer新交稿，也不代表真实银行/税局/支付/海关实测。

**权威版本：** 以本轮最终合并并从GitHub `main`回读的唯一`docs/CHAPTER1_FINAL_SEALED.md`—`CHAPTER10_FINAL_SEALED.md`为准；冻结框架Git Blob `332950b8579f25c255595af5b9f12766340e840f`保持不变；**一级10、二级52、三级113全部逐字同父题、同序通过**，27幅Mermaid与代码围栏完整；第三章原文不做无效扩写。

### 已采纳的事实修正与系统性补充

| ID / 原G5来源 | 受影响材料 | 实际处理结果 |
|---|---|---|
| F01 / G5-01 | 第10章10.5.1 | 核验中美1986年议定书对非个人实体享协定待遇的限制，删除从“无现代独立LOB章节”推导`No LOB article in treaty`选项的错误引导；真实Line14b按有效协议及IRS规则核定，不提供统一选项。 |
| F02 | 第9章9.2.2 | 抵免的纳税凭证与税收居民证明分开，补居民个人合格证明、无证明时的合法替代与五年补证追溯；与10.5.2交叉链接。 |
| F03 | 第10章10.2.3 | 非欧盟OSS为自愿集中申报方式，不等于VAT可选缴；根据真实卖方、消费地和B2B/平台角色选择本地或OSS。 |
| F04 | 第9章9.2.1 | 区分外币主营单位依会计法可选择外币记账本位币、财务报表人民币列报与各税种法定折算。 |
| G01、G5-02 | 第10章10.4.4 | 中美服务PE第5(3)(c)保留原正确条款；明示美国非MLI缔约方，MLI不自动引入新中美协定条款。 |
| G03、M02 | 第1、2章 | FinCEN 2026美国BOI主体分类提醒；收款资质至银行/合规结汇六关，区分开户、收单与真正出款。 |
| G04 | 第4、5、7章 | 银行直接借记SEPA/ACH的Mandate、延迟与授权追索窗口，避免将银行扣款误套卡式争议与立即发放不可撤销权益。 |
| G05、G5-04/05 | 第6、8章 | 第6章Mermaid准备金释放改为**合同条件+风控核验**，非固定天数必然释放；第8章补法律卖方/平台代征/MoR会计主要责任人与总额/净额判断及SaaS非统一12月等额摊销。 |
| G06、G5-06 | 第9、10章 | 企业境外抵免两种方式一经选择五年内不得变更，区别居民个人抵免；复核教学算例原币种与人民币单位。 |
| G07 | 第9章 | 2026年第16号跨境电商出口退运、原状六个月、监管代码、非食品以及已退税补缴的退款/物流/税务证据闭环。 |
| M01、G02有限、M04—M11选择性 | [PRACTICAL_PATHS_APPENDIX.md](PRACTICAL_PATHS_APPENDIX.md) | 三种大陆经营者端到端演练、合同/支付/银行/税务归属、数据库字段与检查表、SEPA/ACH、关联交易五问、税目逆例、关停与动态政策索引；全为`MODEL_ASSUMPTION`及`NOT_RUN`。 |

**未采纳或明确后置：** 大幅重写10章、新增第11章、修改冻结问题原文或父子关系、把跨国集团全球最低税/Pillar Two作为个人必修、部署企业级支付编排、不核实资格就宣称某服务商已提供实测支持。纯语言润色与长段落结构优化全部交下轮G7独立Editor，不在内容Gate越权更改。

**实操附录定位：** 为避免将已封板十章扩成多份重复课件，Owner此次允许在板块根目录保留**一份明确的非冻结、非第11章**的`PRACTICAL_PATHS_APPENDIX.md`。该附录是十章共用工作单；所有条款仍以各章正式正文、官方法规和实际合同为准，G8归档时再核对其长期保留安排。

**审批与Gate停点：** `G6_OWNER_AUTHORIZED_CONTENT_REVISED / G6_STATIC_QA_PASS / 10_CHAPTERS_RESEALED / G7_EDITOR_WORKPACK_READY / G7_INDEPENDENT_EDITOR_PENDING / BOARD_NOT_CLOSED`。独立Editor只负责跨章过渡、重复压缩与可读性，不得改核心事实/公式/代码/法规/模型标签/冻结标题；不得修改GitHub，先返回完整候选ZIP，由总控G7复审、Owner再定最终G8。封板内容**无真实支付/出款/退运/纳税实测，NOT_RUN**。

## G7｜Owner授权Reviewer直修、独立复验并正式再封板（2026-10-20）

**审批与身份边界：** 独立Editor提交`CB03_G7_EDITOR_DELIVERY_20261020.zip`完整10章候选和附录；G7独立R1审核`RETURN`，共有**16项（P0五/P1九/P2二）**。Owner在本轮明确要求Reviewer直接修复、复查、通过后不再做额外修改。**本轮由Reviewer以G6固定正文与Editor V1全文为依据直修，不存在Editor R2交付，也不冒称新一轮独立G6事实审查或外部交易测试。**

**结果：G7 PASS / 内容与编辑均正式再封板；第1—10章继续`CHAPTER_FINAL_SEALED`。** 经逐条审查仅保留不改变含义的语言过渡和纯文档状态修正，撤回Editor V1新增的16位卡号、Webhook“加密签名且权威即最终”、卡组织“法定”争议程序、退款“无条件”、支付机构余额“托管账户”、MoR法定身份及主体准入等越权表述。第9章删除“第10章尚未开始”的过时文字、第8/10章亦清理了旧Gate编辑注记；跨章实操附录后一个“七”更正为“八”。**第1、2、3、5、7章正文与G6固定版原字节一致，不为凑修改而改写。**

**全文静态复验：** 10章冻结题目`52 L2 + 113 L3`逐字、编号、父题与顺序一致；4处L2直接成节保留；11份（10章+实操附录）正式稿与G6基线对照，**72个完整代码围栏块、27幅Mermaid图、历史G7记录35个块公式（口径未明；本轮G8按`$…$`配对计41处）、所有原来源URL、`MODEL_ASSUMPTION/UNKNOWN/NOT_RUN`标记和代码内容**均严格保持；ZIP原字节SHA-256与Git Blob均归档。G7完成的是**编辑不变性静态校验**，不是支付、银行或税务生产实测。

**实际更新的正式内容：** 第4、6、8、9、10章及`PRACTICAL_PATHS_APPENDIX.md`共6份；再维护本唯一交接、本板块README和父级README。G7完整直修/逐项16条闭环及Diff证据：`CB03_G7_OWNER_DIRECT_FIX_FINAL_SEAL_EVIDENCE_20261020.zip`（Owner对话独立留档，不并列上传多套正式稿至docs）。以本次GitHub合并后`main`回读的实际Commit和Git Blob为准。

**G7历史停点（现已由G8记录取代）：** `10/10_CHAPTER_FINAL_SEALED / G7_EDITORIAL_PASS_OWNER_DIRECT_FIX / G8_FINAL_ARCHIVE_PENDING_OWNER / BOARD_NOT_CLOSED`。正式教材文字层面按Owner决定不再开启G7修改；G8仅执行最终归档与关闭检查，**未经Owner特别批准不因G8发起内容改写或宣称CLOSE**。HTML、PDF、真实商户测试、税务申报均不属本轮。

美元符号（共8段），箭头和操作原意保留。 | 静态PASS |

**当前唯一正式内容指纹（固定修订提交`29a206cb...`；UTF-8/LF原字节SHA-256，Git Blob为Git SHA-1，不能混称）：** 包含全部10章、唯一冻结框架、唯一非冻结实操附录及板块README。交接本文件自身的指纹以最终main回读为准，不在自身文件中设置循环式指纹。

| 本板块相对路径 | SHA-256（原字节） | Git Blob SHA-1 |
|---|---|---|
| `README.md` | `e05be6e04ffc75dec04fc464ed4b4125eb8c49751486c24eda7303e472bd0e44` | `165e9ab921a5ce60f5d931bb71ef7893627a513a` |
| `PRACTICAL_PATHS_APPENDIX.md` | `afaa5607bb49601b18e6d4bf466706cab187143f53ab900812744cb603d21f6c` | `80d1bb18dcfc2097ae93c3227d484584aa610d7d` |
| `docs/FROZEN_FRAMEWORK_V1_20261020.md` | `42649959c4fcdaa7149a0838b009b011bfc04b2d5213cdd25cda88935ed527df` | `332950b8579f25c255595af5b9f12766340e840f` |
| `docs/CHAPTER1_FINAL_SEALED.md` | `2246f7668e6fb27aa8e30fb2206e2ff74339ec210fa5ee992343ad0eb0a1d848` | `5f0f7c08c359d78d2e7ed5deb129cf8b57c360bf` |
| `docs/CHAPTER2_FINAL_SEALED.md` | `fb0cc683ad16dbc9f6775ee91b867fd861eef50d23b1b406f086eae79317821e` | `93ce625e042e33e487f2df6a2116a79130980e31` |
| `docs/CHAPTER3_FINAL_SEALED.md` | `4dceaaadf7ab2a3873c254ce239bb94c8a8d633011d396702f52804a65623291` | `613c58fddbe0fbe63b5c73be10285aabebea3da2` |
| `docs/CHAPTER4_FINAL_SEALED.md` | `f5a1378ccde9cdabe6a3aa88942ec813acfae9c41737d81272637a18eadb5fd8` | `918570400bd504207592e6d75f5315f86ee504b2` |
| `docs/CHAPTER5_FINAL_SEALED.md` | `ddea80d6b74b9b24ba121d3983710656f8509b7e9040e40b06bfb769dc3dfb7f` | `ee2cecf038585d9f3655be34f4b545b43716fa64` |
| `docs/CHAPTER6_FINAL_SEALED.md` | `f9b065871cddfbf34fea5a948823a513326beb970602eeb6a9ebfe578d54e987` | `009ce04ddd7d9076bc7d58cf112c64868e2aaf20` |
| `docs/CHAPTER7_FINAL_SEALED.md` | `45d36616f0fe6a54c796b4ad4d73ec7b5164f6472f9838428256a58c923a9bc5` | `b743600d6e5ea7fceee28c15824edd665b152b29` |
| `docs/CHAPTER8_FINAL_SEALED.md` | `93bd6b5f9770d5fdebce8af037a14977b469a3cb829c90483cf3b0a8e938fb55` | `e61de30d6ab1650b21fa2023fa78896d1eb3444d` |
| `docs/CHAPTER9_FINAL_SEALED.md` | `ee8a67d16221d236604e47e5a4685bd6cee480e14be6fa1ab899422aac905ab4` | `b0a1796ba964a2c54694c4d08f30d58f68027e81` |
| `docs/CHAPTER10_FINAL_SEALED.md` | `b6c7a076ee9509f1c5baa0e9300a808a9e48009df1cdd201498b3002e00115a3` | `64dac56575a7c64a7fd50ab41728ff56d0ee1740` |

**统一复验与真实性：** 冻结L2=52/52、L3=113/113逐字同父题同序，4处二级直接成节保留；72个完整围栏（Mermaid 27）、`$…$`数学块41；G6/G7采纳的LOB、OSS、境外所得税抵免凭证、记账本位币、MoR、资金准备金、支付状态及中美服务型PE关键边界均保留。本轮第9/10章所有冻结标题、代码围栏与原数学公式不变，已有外链保留（第10章纠错新增1条官方来源）。内部相对路径与重点官方来源抽检PASS，**未逐个HTTP请求核验全部外部链接**；真实支付、退款、结汇、开户、海关退运、税务申报、生产Webhook均`NOT_RUN`。案例数字属于`MODEL_ASSUMPTION`；实际适用资格未核验者为`UNKNOWN`。

**归档唯一性与历史：** 根目录`README.md`（导航）、`REVIEWER_HANDOFF.md`（唯一当前交接）、Owner G6明确批准的非冻结`PRACTICAL_PATHS_APPENDIX.md`（非第11章），以及`docs/`下唯一正式冻结框架、CH1—CH10各一份正文。冻结框架结尾“下一Gate为G2”是其G1时点原始说明，不能取代本交接最新状态，故不改冻结文件。不可变Git历史：[G5基线`0400c982`](https://github.com/entropy-student/project/commit/0400c982df2f9123850fe59dec5cb5faba201b08)、[G6封板`0570aabc`](https://github.com/entropy-student/project/commit/0570aabcc2ebde31e1606fedc59e239f3bf3a38e)、[G7直修`8f4629ce`](https://github.com/entropy-student/project/commit/8f4629ceda0ad713ea0d1f85db471bdc1ca14017)、[G8内容修订`29a206cb`](https://github.com/entropy-student/project/commit/29a206cb3c21f33d823d12e8d850cf49b30abd4f)。历史完整Writer/Editor/Reviewer离线ZIP由Owner持有，本轮没有逐一实际回读、重验所有离线ZIP，其离线完整性记`UNKNOWN`，不能声称已迁入Git；Git固定Commit中的历史正文可恢复。

**现行停点：`G8_PASS_CANDIDATE / STOP_AT_OWNER_FINAL_APPROVAL / BOARD_NOT_CLOSED`。** 2个P1阻断与2个P2整理均已定向闭环，**不是`BOARD_CLOSED`**。本轮仅临时冻结知识正文和附录；最终`BOARD_CLOSED / FINAL_SEALED`须Owner下一次明确结项许可和必要最终GitHub回读。不得自动启动扩写、重写或HTML/PDF制作。

## 五、官方事实核验提示

- 支付测试服务商规则：https://docs.stripe.com/testing
- 个人跨境电商年度结售汇便利化额度说明：https://www.safe.gov.cn/shanghai/2026/0402/2412.html
- 会计档案类别期限：https://www.mof.gov.cn/gp/xxgkml/tfs/201512/t20151214_2510365.htm
- 卡组织风险监控动态门槛（渠道说明）：https://docs.adyen.com/risk-management/dispute-and-fraud-monitoring
- 欧盟VAT/OSS/IOSS：https://vat-one-stop-shop.ec.europa.eu/
- 美国预提税表与协定资格：https://www.irs.gov/individuals/international-taxpayers/claiming-tax-treaty-benefits

**现行停点：`10/10 CHAPTER_FINAL_SEALED / G8_PASS_CANDIDATE / STOP_AT_OWNER_FINAL_APPROVAL / BOARD_NOT_CLOSED`；正文暂时冻结，等待Owner最终结项决定。**
