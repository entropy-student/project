# 跨境业务｜五板块总项目库

> **PROJECT_STATUS：STRUCTURE_READY / 02_FRAMEWORK_FROZEN / 01_04_05_FRAMEWORK_PREPARATION**（2026-10-18）  
> **唯一导航入口：本文件**｜**当前执行 Gate：NONE**｜**HTML：不在本轮范围**

## 项目目标

建立面向中国大陆个人开发者、独立站经营者与跨境卖家的完整跨境业务知识及实践框架：**判断机会 → 搭建可靠网络环境 → 经营主体、支付与财税合规 → 设计和交付产品 → 获客与增长**。

这是业务知识和项目工作的**父项目**，不是把五个板块写成一份冗长文档。每个板块有自己的边界，后续可独立研究和扩充。

## 五大板块

| 顺序 | 板块 | 覆盖内容 | 状态及入口 |
|---|---|---|---|
| 01 | **机会挖掘与市场判断** | 需求与痛点、市场/用户、竞争与定价、商业模式、机会验证 | [规划入口](01-opportunity-market/README.md) · PLANNED |
| 02 | **网络环境搭建** | 跨境网站/账号所需网络连接、稳定性、设备与访问环境、运维和合规边界 | [正式框架与Writer流程](02-network-environment/README.md) · **8/44/93 FROZEN；第一章Writer待交稿** |
| 03 | **支付、税务与经营主体** | 合法经营主体、支付方案、交易接入、结算提现、退款拒付、财税合规 | [封板板块](03-payment-tax-entity/README.md) · **FROZEN（禁止修改）** |
| 04 | **产品搭建** | 选型、建站/应用、用户体验、订单与自动履约、质量和服务交付 | [规划入口](04-product-building/README.md) · PLANNED |
| 05 | **获客与用户增长** | SEO、内容、广告、主动触达、转化、裂变、复购与增长实验 | [规划入口](05-acquisition-growth/README.md) · PLANNED |

## 第一、第四、第五板块的统一框架撰写规范（2026-10-18）

- **[一级、二级、三级问题通用撰写与审核标准](docs/FRAMEWORK_QUESTION_DESIGN_STANDARD_V1_20261018.md)**：适用于①④⑤的独立候选框架，包含层级职责、卖家式问句、递进/合并/去重、覆盖与审核标准、跨板块边界和交付规则；**不规定章数或题数，不冻结新框架**。
- **[① 机会挖掘与市场判断·离线Agent任务书](docs/01_OPPORTUNITY_FRAMEWORK_AGENT_BRIEF_20261018.md)**
- **[④ 产品搭建·离线Agent任务书](docs/04_PRODUCT_FRAMEWORK_AGENT_BRIEF_20261018.md)**
- **[⑤ 获客与用户增长·离线Agent任务书](docs/05_GROWTH_FRAMEWORK_AGENT_BRIEF_20261018.md)**

给外部Agent时，只需下发“**通用标准 + 对应任务书**”，无须开放GitHub。Agent仅起草一二三级完整候选并自检；经独立Reviewer审查和Owner批准后才可正式冻结，不得直接写正文。上述任务书不意味着各板块框架已有成果或已PASS。

## 第三板块：已封板的正式子项目

正式子项目为 **《现代商业支付系统｜如何收钱更快、更省、更安全？》**：

- [唯一正式项目交接（CLOSED）](../modern-commercial-payment-guide/REVIEWER_HANDOFF.md)
- [V6 冻结框架：7 章、29 个二级问题、42 个三级问题](../modern-commercial-payment-guide/docs/FROZEN_FRAMEWORK_V6_20261016.md)
- [七章 Markdown 正文目录](../modern-commercial-payment-guide/docs/)
- [七章正式正文 ZIP](https://github.com/entropy-student/project/archive/refs/heads/payment-guide-seven-sealed-chapters-20261017.zip)

**冻结协议**：以上 9 份现有正式文件、Git 路径、章节编号、封板决定及正式 ZIP 均**只读、不可由父项目任务修改或迁移**。第三板块当前作为“**逻辑子项目**”接入父项目；**不做文件复制、不移动旧目录、不建立第二套正文**。今后其他四板块扩充，也不能以“整体结构统一”为理由重新编辑支付指南或解除其 CLOSED/FROZEN 状态。如确有需要修改，必须先取得 Owner 针对第三板块的独立明确授权。

> **范围提醒**：支付指南是第三板块当前已完成的核心成果；父项目没有声称其已经覆盖所有国家、税种和经营资格，也不会在本轮自动补写剩余主题。

## 工作规则与恢复方式

1. **整体结构由本文件导航**；各板块的知识和任务留在本板块，不跨板块复制正文。
2. **第二板块已有8/44/93正式/暂时冻结框架，第一章独立Writer包已发布但尚无正文**；01、04、05目前只有独立框架撰写规范与Agent任务书，尚无框架候选和冻结成果。不得把链接到现有其他项目等同于迁入本库。
3. **第三板块永远优先遵守冻结约束**：不编辑、重命名、移动、归档、删除，也不借由“保持一致”改写其原文件。
4. ①④⑤已有可供Owner转交外部Agent的框架撰写标准和独立任务书；各Agent交稿后再独立审核，未经Owner明确批准不写入正式冻结框架或启动教学正文。
5. 项目文件当前位于 GitHub `entropy-student/project/cross-border-business/`，与已有其他业务源码仓库 `CrossBorder` 不混用。本轮不操作或迁移任何源码仓库。

**当前下一步：** Owner将通用标准分别搭配①/④/⑤专属任务书交给独立Agent起草完整三级问题树；②继续第一章Writer候选等待；③保持CLOSED/FROZEN。
