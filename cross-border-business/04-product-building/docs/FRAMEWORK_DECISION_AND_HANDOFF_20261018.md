# 第四部分｜产品搭建｜框架决定、证据与 Reviewer 交接（2026-10-18）

> **CURRENT_STATE：CORE_L1_L2_OWNER_APPROVED_FROZEN / L3_CANDIDATE_REVIEW_PENDING / BODY_NOT_STARTED**  
> **仓库：** `entropy-student/project` · **目录：** `cross-border-business/04-product-building/`  
> **唯一冻结范围：** 核心1题 + 一级7题的原文、编号、顺序与归属。  
> **本轮最大终点：** 已冻结的上级落 `main`，生成二级候选与交接文件；停在 Owner/Reviewer 审查，不再自动拆三级。

## 一、当前状态与唯一权威入口

| 对象 | 数量 | 状态 | 唯一入口 |
|---|---:|---|---|
| 核心问题 | 1 | **OWNER_APPROVED / FROZEN** | [核心与一级冻结原文](../FROZEN_FRAMEWORK_CORE_L1_20261018.md) |
| 一级问题 | 7 | **OWNER_APPROVED / FROZEN** | [核心与一级冻结原文](../FROZEN_FRAMEWORK_CORE_L1_20261018.md) |
| 二级问题 | 45 | **CANDIDATE / REVIEW_PENDING** | [45题二级候选及自检](../FRAMEWORK_L2_CANDIDATE_20261018.md) |
| 三级问题 | 0 | NOT_STARTED | NONE |
| 正式知识正文 | 0章 | NOT_STARTED | NONE |
| HTML/产品开发/真实订单 | 0 | NOT_AUTHORIZED / NOT_STARTED | NONE |

**冻结核心：** 产品怎么做、怎么交付？

**冻结一级原文（导航仅引用，不构成另一个编辑入口）：**
1. 我要做网站、软件，还是直接开店？
2. 第一版先做到什么程度？
3. 用现成工具，还是自己开发？
4. 怎么让客户顺利购买和使用？
5. 客户下单后，怎么确保交付到位？
6. 产品上线前，要检查什么？
7. 上线后，怎么维护和改进？

## 二、Owner 决策与可核验执行证据

- **2026-10-18 · OWNER_REPORTED**：原 V1 核心和一级句子过长，Owner 要求改为更像商家会问的问题。
- **2026-10-18 · OWNER_REPORTED**：V2 的七个一级问题经 Owner 明确批准可以冻结；V3 把核心缩短为「产品怎么做、怎么交付？」时仍仅为候选。
- **2026-10-18 · OWNER_REPORTED**：Owner 本轮明确决定「核心问题和1级问题正式冻结并落库」，并要求「开始撰写2级问题同样的要求」。因此 V3 核心改为正式冻结，且一级不再修改。
- **2026-10-18 · DIRECT_READBACK**：冻结文件已写入 `main`，Commit `1029e0dffcef3b3376c58825e6c771b164a4ffcb`，回读核实核心原文及七条 L1 原文存在；冻结文件 Git blob SHA 为 `fbc2b296041aca76827110825510742f7307fc22`。
- **2026-10-18 · DIRECT_READBACK**：二级候选已写入 `main`，Commit `e925896944aef7d39a71df0aa16f8df70fd44dfb`，回读核实45个不同编号，分布 **4/5/6/7/9/6/8**，文件 Git blob SHA 为 `50b588b2b942c3321d717ba4dc5e45867913a02e`。
- **适用规范 · DIRECT_READBACK**：[五板块问题框架通用标准](../../docs/FRAMEWORK_QUESTION_DESIGN_STANDARD_V1_20261018.md)、[第四板块独立任务书](../../docs/04_PRODUCT_FRAMEWORK_AGENT_BRIEF_20261018.md)、[VPS Project Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)。
- **新增/更新后的导航验收**：以 [本板块 README](../README.md) 和 [父项目 README](../../README.md) 的 GitHub `main` 最新回读为准；此条不预先宣称已完成。

## 三、治理状态面板

- **PROJECT_GOAL：** 帮助中国大陆独立开发者和跨境卖家回答如何选择产品形态、快速搭建、可靠购买/交付、测试上线及维护；最终产出系统化知识框架及后续教程。
- **PROJECT_STAGE：** 核心与L1已冻结；L2候选待审；L3和正文未启动。
- **SYSTEM_MAP：** 纯 Markdown 文档项目；无独立服务器、网站、后台、数据库、真实客户数据、Secret、支付网关或 Docker 运行时；GitHub `main` 是唯一持久化目标。
- **CURRENT_ACCEPTED_STATE：** [冻结快照](../FROZEN_FRAMEWORK_CORE_L1_20261018.md)；二级候选非 accepted。
- **CURRENT_GATE：** `04-L2-OWNER-REVIEW-20261018`。目标：审核二级45题的表达、独立性、广度、去重和跨板块边界；最大终点为 Owner 作出 PASS / 返修决定，不进行自动冻结或下级写作。
- **CRITICAL_CONSTRAINTS：** 上级7题原文及核心冻结不可更改；①1/8/34/83与②8/44/93冻结不动；③ CLOSED/FROZEN 不动；不写网络配置、支付金融、获客增长教程；不凭候选目录断言现实产品具备特定功能。
- **DEFAULT_EXECUTION_CHANNEL：** GitHub 连接器操作 `entropy-student/project` 的 `main`，纯文档小范围读写；下一轮默认 Reviewer 审核，未授权修改其他项目目录。
- **CURRENT_ROLLBACK_STATUS：** 文档变更可由 Git 历史按具体 Commit 和路径进行新的逆向提交；不强制重置/改写共享 `main` 历史；本轮无生产状态或数据恢复需求。
- **UNRESOLVED：** 45道候选是否保留/合并/改写仍待 Owner 审查；不同国家法律、平台商业许可及具体服务商细则留待未来正文章节核验，不能从题目断言已符合。
- **NEXT_STEP：** Owner/Reviewer 审核 L2 → 必要的最小返修 → Owner 明确批准 → 单独建立正式 L2 冻结快照 → 才开始 L3 候选。
- **OWNER_ACTION_REQUIRED：** 审核 [二级45题](../FRAMEWORK_L2_CANDIDATE_20261018.md) 并决定通过或指出需改之处；无需工具安装或转交材料。
- **EVIDENCE_POINTERS：** 上述 Commit/SHA、冻结文件、候选文件及此交接；项目父/子 README 仅负责导航，不构成另一套状态原文。

## 四、恢复工作顺序与重点复核

**Reviewer 必读顺序：** ① [本板块 README](../README.md) → ② [冻结快照](../FROZEN_FRAMEWORK_CORE_L1_20261018.md) → ③ [L2 候选](../FRAMEWORK_L2_CANDIDATE_20261018.md) → ④ [通用标准](../../docs/FRAMEWORK_QUESTION_DESIGN_STANDARD_V1_20261018.md) → ⑤ 本交接。

**Reviewer 优先复核：** 4.5九题的拆分是否必要；4.4与第五板块成交问题的界限；4.3/4.7两类成本、迁移题是否重复；实体、数字、SaaS、服务是否都能用这套目录完成真正可交付的产品；首版人工处理与自动化是否都有清晰的质量和失败边界。

## 五、Gate / 风险 / 停点

- **GATE_ID：** `04-CORE-L1-FREEZE-AND-L2-CANDIDATE-20261018`
- **OBJECTIVE：** 归档 Owner 已批准核心及L1，完成L2候选与项目交接。
- **MAX_ENDPOINT_THIS_ROUND：** `main` 中上级正式冻结 + L2候选 + 项目文档；**MANDATORY_REVIEW_STOP：L2 Owner/Reviewer 审核**。
- **TARGET_AND_SCOPE：** 仅 `cross-border-business/04-product-building/` 的纯文档，外加父项目 `cross-border-business/README.md` 导航。无其他板块或仓库的写权限。
- **PREFLIGHT：** 已核对 GitHub 主仓库与目标文件路径、通用标准和相邻第五板块归档实践；无生产部署、账户/Secret/付款/数据操作。
- **REQUIRED_EVIDENCE：** 正式问题原文、L2完整表格与编号统计、跨板块边界、相关文档 Commit 与 fresh read-back。
- **ACCEPTANCE_CRITERIA：** 上级逐字冻结，二级有唯一父题且不提前 PASS；导航与状态无矛盾；GitHub `main` 目标文件可回读。
- **ROLLBACK_STATUS_OR_PLAN：** GitHub 以追加逆向 Commit 恢复目标文档；不破坏共享历史。
- **OWNER_ONLY_ACTIONS：** L2的正式批准/冻结，以及任何改动既有冻结上级。
- **REVIEWER_TO_EXECUTOR_RELAY：** NONE（本轮已由当前执行者完成文档设计，不需要另找 Executor）。
- **EXECUTOR_TO_REVIEWER_RELAY：** 当前 Commit 与目标文件见第二节；L2 状态仅 `PASS_CANDIDATE / REVIEW_PENDING`。
- **STOP：** 不自动启动三级、知识正文、HTML 或任何实际产品建设。
