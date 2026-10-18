# 跨境业务｜五板块总项目库

> **PROJECT_STATUS：STRUCTURE_READY / 01_FRAMEWORK_FROZEN_BODY_NOT_STARTED / 02_FRAMEWORK_FROZEN / 03_CLOSED**（2026-10-18）  
> **唯一导航入口：本文件**｜**当前执行 Gate：NONE**｜**HTML：不在本轮范围**

## 项目目标

建立面向中国大陆个人开发者、独立站经营者与跨境卖家的完整跨境业务知识及实践框架：**判断机会 → 搭建可靠网络环境 → 经营主体、支付与财税合规 → 设计和交付产品 → 获客与增长**。

这是业务知识和项目工作的**父项目**，不是把五个板块写成一份冗长文档。每个板块有自己的边界，后续可独立研究和扩充。

## 五大板块

| 顺序 | 板块 | 覆盖内容 | 状态及入口 |
|---|---|---|---|
| 01 | **机会挖掘与市场判断** | 需求与痛点、市场/用户、竞争与定价、商业模式、机会验证 | [核心冻结及候选框架](01-opportunity-market/README.md) · **核心1/一级8/二级34/三级83已正式FROZEN；正文未启动** |
| 02 | **网络环境搭建** | 跨境网站/账号所需网络连接、稳定性、设备与访问环境、运维和合规边界 | [正式框架与Writer流程](02-network-environment/README.md) · **8/44/93 FROZEN；第①②章正式封板；第③章独立Writer工作包已发布** |
| 03 | **支付、税务与经营主体** | 合法经营主体、支付方案、交易接入、结算提现、退款拒付、财税合规 | [封板板块](03-payment-tax-entity/README.md) · **FROZEN（禁止修改）** |
| 04 | **产品搭建** | 选型、建站/应用、用户体验、订单与自动履约、质量和服务交付 | [规划入口](04-product-building/README.md) · PLANNED |
| 05 | **获客与用户增长** | SEO、内容、广告、主动触达、转化、裂变、复购与增长实验 | [规划入口](05-acquisition-growth/README.md) · PLANNED |

## 第一、第四、第五板块的框架撰写规范

- [通用问题设计与审核标准](docs/FRAMEWORK_QUESTION_DESIGN_STANDARD_V1_20261018.md)：适用于①④⑤的独立候选框架；不规定数量，也不触及②③冻结成果。
- **[① 唯一正式完整冻结框架（1/8/34/83）](01-opportunity-market/docs/FROZEN_FRAMEWORK_V1_20261018.md)**：完整问题树，8.2不另设三级，Owner已PASS。
- [① 历史核心及一二级冻结快照](01-opportunity-market/FROZEN_FRAMEWORK_L1_L2_20261018.md)：保留原始8/34批准记录。
- [① 三级综合修订V2原始稿（83题）](01-opportunity-market/FRAMEWORK_L3_INTEGRATED_V2_20261018.md)：已被Owner批准，旧稿原始待审标记仅属历史版本；正式版本以上述完整冻结框架为准。
- [① 综合V2自检报告](01-opportunity-market/docs/L3_INTEGRATED_V2_SELF_REVIEW_20261018.md)：检查独立必要性、知识覆盖、编号及跨板块边界。
- [① 历史三级候选V1（99题）](01-opportunity-market/FRAMEWORK_L3_CANDIDATE_20261018.md)：已复查RETURN，保留历史比对。
- [① 三级V1后续复查](01-opportunity-market/docs/L3_AUTHOR_RECHECK_RETURN_STRUCTURE_20261018.md)：31/34父题恰好3题，内容RETURN。
- [① 原三级自检报告](01-opportunity-market/docs/L3_SELF_REVIEW_20261018.md)：34/34二级覆盖、99题归属核对和跨板块审查。
- [① 历史离线独立Agent任务书](docs/01_OPPORTUNITY_FRAMEWORK_AGENT_BRIEF_20261018.md)：历史参考，L1/L2征稿任务已结束。
- [① 已淘汰的历史7/32候选](01-opportunity-market/FRAMEWORK_L1_L2_CANDIDATE_20261018.md)：保留用于审查回溯；不得替代已冻结的8/34。
- [① 决策与交接记录](01-opportunity-market/docs/FRAMEWORK_DECISION_AND_HANDOFF_20261018.md)：版本与Owner批准轨迹。
- [④ 产品搭建 · 离线Agent任务书](docs/04_PRODUCT_FRAMEWORK_AGENT_BRIEF_20261018.md)
- [⑤ 获客与用户增长 · 离线Agent任务书](docs/05_GROWTH_FRAMEWORK_AGENT_BRIEF_20261018.md)

**状态优先级：** ①核心问句、8个一级、34个二级、83个三级均已由Owner正式PASS/FROZEN（8.2直接成节）；①正文未启动。②③保持原有冻结与封板，④⑤状态不变。

## 第三板块：已封板的正式子项目

正式子项目为 **《现代商业支付系统｜如何收钱更快、更省、更安全？》**：

- [唯一正式项目交接（CLOSED）](../modern-commercial-payment-guide/REVIEWER_HANDOFF.md)
- [V6 冻结框架：7 章、29 个二级问题、42 个三级问题](../modern-commercial-payment-guide/docs/FROZEN_FRAMEWORK_V6_20261016.md)
- [七章 Markdown 正文目录](../modern-commercial-payment-guide/docs/)
- [七章正式正文 ZIP](https://github.com/entropy-student/project/archive/refs/heads/payment-guide-seven-sealed-chapters-20261017.zip)

**冻结协议：** 以上 9 份现有正式文件、Git 路径、章节编号、封板决定及正式 ZIP 均**只读、不可由父项目任务修改或迁移**。第三板块当前作为“逻辑子项目”接入父项目；不复制、不迁移既有正文。今后其他四板块不能以“整体结构统一”为理由编辑支付指南或解除其 CLOSED/FROZEN 状态。

> **范围提醒**：支付指南是第三板块当前已完成的核心成果；父项目没有声称其已经覆盖所有国家、税种和经营资格，也不会在本轮自动补写剩余主题。

## 工作规则与恢复方式

1. **整体结构由本文件导航**，各板块留在各自目录；不跨板块复制正文。
2. 第二板块8/44/93正式/暂时冻结框架、第三板块CLOSED/FROZEN保持原状。
3. 第三板块的已有正式文件、路径及历史提交禁止本任务编辑、重命名、删除。
4. 第一板块正式冻结核心1/一级8/二级34/三级83的全问题树；正文未启动。
5. ①离线资料无需仓库权限；④⑤仍使用原独立任务书。项目所在GitHub路径为 `entropy-student/project/cross-border-business/`，不操作其他业务源码仓库。

**当前下一步：** ①框架已封板，待Owner指令启动第①章独立Writer工作包/正文；②第①②章已封板，进入第③章独立Writer首稿；③维持封板；④⑤各自待独立规划。
