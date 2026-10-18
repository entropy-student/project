# 第一部分第②章｜Owner特别授权直接修订/复核证据

> **状态：OWNER_AUTHORIZED_DIRECT_REPAIR / FINAL_SEALED（2026-10-18）**
> 本文件为Reviewer对Writer R2已交候选的**追加核验**，不篡改Writer R2历史自评记录，不虚构R3 Writer交付。

## 输入与权限

- 冻结权威：`cross-border-business/01-opportunity-market/docs/FROZEN_FRAMEWORK_V1_20261018.md`，1/8/34/83；本章1 H1、4 H2、8 H3。
- Writer R2完整原稿 SHA256：`e66a29e0df1c308279afcc82e0e9e8c667dd266acf7f34d442aab1c104a83f92`；Writer R2核验记录 SHA256：`ff17542c8d9ae4645f852bc83028130404a542f19338f1953d6403c0c7491e0e`。两者原件留在Owner之前收件ZIP和Reviewer R2返修ZIP。
- Owner正式授权直接修订、封板和启动下一个一级章节；Reviewer执行定向修改、保留主体，不再进行无必要Writer R3轮次。
- 原Reviewer R2结论：`RETURN_R2_RESIDUAL_FACT_AND_MODEL_BOUNDARY`，阻断R2-01到04与轻微编辑N2-01到04。

## 逐项修复映射

| 编号 | 修复事实及处理 | 来源/证据边界 |
|---|---|---|
| R2-01 CPC | 明确在美国境外制造的受规则约束儿童产品由有责任的进口商签发CPC，进口商**可以不在美国境内**；检测机构不签发CPC；根据具体产品规则和豁免/例外检查测试；教学案例不再假定真实已获得检测及证书 | [CPSC CPC FAQ](https://www.cpsc.gov/FAQ/CPC)；[CPSC在线卖家指南](https://www.cpsc.gov/Business--Manufacturing/Online-Sellers-Safety-Guide) |
| R2-02 地域特征 | 将无来源“北美独栋/欧洲城市住宅”结构对比改为按具体地区取证的中立核查清单；明确建筑举例是`MODEL_ASSUMPTION`；ONS仅支持住宅类别占比、美国HVS仅支持空置/自有率；德国32. BImSchV只说具体室外设备、地点和时段，不扩大至所有设备或禁售 | [ONS Census 2021](https://www.ons.gov.uk/peoplepopulationandcommunity/housing/bulletins/housingenglandandwales/census2021)；[德国UBA Gartengeräte](https://www.umweltbundesamt.de/themen/laerm/nachbarschaftslaerm-laerm-von-anlagen/gartengeraete) |
| R2-03 数学/保本 | 将$10/月由“最低保本线”改为**教学中自行设定的探索报价下限**；$3/月仅为单项运行成本示例；保留`max(5*1.5,10)=10`、`min(150*0.20,30)=30`与主观15–19测试价，明确不能证明利润为正 | Writer自设`MODEL_ASSUMPTION`，不是现实费率或保本财务结论，利润需第五章测算 |
| R2-04 FTC | Writer R2证据台账S-06把FTC发货承诺和到货时间混为一谈；此处以**本Reviewer最终证据说明**替代那个历史证据边界：16 CFR 435涉及承诺的**发货期限（ship）**、不能按期发货时的延期同意/取消退款；无承诺一般有30天默认发货基准，并非对所有实际收货日期的统一时限。真实“送达承诺”需独立核实 | [FTC规则](https://www.ftc.gov/legal-library/browse/rules/mail-internet-or-telephone-order-merchandise-rule)；[FTC实操指南](https://www.ftc.gov/business-guidance/resources/business-guide-ftcs-mail-internet-or-telephone-order-merchandise-rule) |
| N2系列 | 概念乘法改为不具量纲的定性判断维度；跨章错误方括号改为纯文本；少数保证口碑/转化的措辞降为条件性判断；经典理论属于分析启发，不是对真实市场销量/复购的实证证明 | 本轮文内附上下文说明，未改变已冻结标题或本章商业知识主体 |

## 完整性与回归

- 原R2字节：`64500`；正式正文UTF8字节：`64534`；**正式SHA256：`efa792420f5db5ff6ff0b5ab58365e62cc9a3d31877c55bab146e933e31ad603`**。
- 修改记录：`15`组局部替换/规范化（非整篇重写）；Writer R2原稿仍可按SHA256追溯。
- H1/H2/H3原题及顺序均与Writer R2一致，共1/4/8；需要再与GitHub唯一冻结框架回读比较。
- 假设价格重新复算：探索价下限`max(5*1.5,10)=10`美元/月；上限`min(150*.2,30)=30`美元/月；15–19美元/月由经营者主观用于试价；**这些不是统计测得售价、利润下限或最终定价**。
- 相关法规全部是当地/产品特定条件的初步科普，不是合法上市准入意见；动态变化后须重新核对。
- **Owner批准的正文封板是知识内容/问题框架的接受，不代表真实海外销售、用户访谈或认证已经发生。**

## 后续

第①章仍为FINAL_SEALED，本章正式入库后为FINAL_SEALED；第③章进入独立Writer Gate，4个二级9个三级，不代表Writer已交稿。不启动第④章或HTML。