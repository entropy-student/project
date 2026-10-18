# 第四部分｜一级、二级暂时解冻及独立 Writer 全树盲写任务（2026-10-18）

> **DECISION：OWNER_AUTHORIZED_TEMP_REOPEN**  
> **CURRENT_STAGE：CORE_FROZEN / L1_L2_TEMPORARILY_REOPENED / L3_OLD_CANDIDATE_ONLY / OFFLINE_PACKET_READY / WRITER_PENDING**  
> **当前Gate：04-INDEPENDENT-WRITER-BLIND-FRAMEWORK-REWRITE-20261018**  
> **本轮最大终点：GitHub状态与文件索引更新 + 离线ZIP及提示词交给Owner。STOP at WRITER_PENDING。**

## 一、Owner决定与授权

2026-10-18，Owner 明确要求：“**一级问题和二级问题暂时解冻，我计划让writer重新撰写全部一级至三级问题，返回之后和你的对比看下，请你准备工作包以及提示词，注意writer没有权限查看我们的仓库，所以背景项目信息或者其他信息如果你认为要提供可以一块提供。**”

精确权限解读：
- **唯一核心问题“产品怎么做、怎么交付？”继续 FROZEN**。本轮没有授权改核心。
- 旧一级 **7题** 与旧二级 **45题**：变为 **TEMPORARILY_REOPENED / COMPARISON_BASELINE_ONLY**。旧 Owner PASS 和冻结快照仍是真实历史记录，但不能再阻止本轮新结构重写。
- 旧三级 **118题**：从未正式冻结，继续 **HISTORICAL_CANDIDATE / COMPARISON_BASELINE_ONLY**。
- 独立 Writer 允许全新设计一级、二级、三级的**题量、问句、章节组织、顺序、父子归属**；Writer 交付仅 `CANDIDATE`，不能修改GitHub、宣布PASS或冻结。
- 旧问题树、旧题数、现有章节顺序**禁止放入Writer工作包**，防止独立样稿受到先入为主的影响。
- 在Writer返回、Reviewer比较、Owner明确作出新决定之前，不自动恢复旧版冻结，不直接用Writer稿覆盖旧稿，不启动正式教学正文、HTML或真实产品建设。

## 二、现有对比基线（仅Reviewer/Owner，不交给Writer）

| 文件 | 历史状态 | 本轮用途 |
|---|---|---|
| [历史正式1/7/45问题树](../FROZEN_FRAMEWORK_CORE_L1_L2_20261018.md) | 历史OWNER_PASS及REVIEWER_PASS | 唯一旧版一级7和二级45的比较快照；核心问句仍有效 |
| [原三级118题候选](../FRAMEWORK_L3_CANDIDATE_20261018.md) | 从未正式冻结 | 旧版三级比较基线 |
| [旧阶段1/7快照](../FROZEN_FRAMEWORK_CORE_L1_20261018.md) | 早期正式冻结历史 | 历史证据 |
| [原45题L2候选](../FRAMEWORK_L2_CANDIDATE_20261018.md) | 旧稿形成过程 | 历史版本 |
| [上轮复核PASS和L3结构自检](L2_REVIEW_PASS_AND_L3_SELF_REVIEW_20261018.md) | 上轮事实 | 非本轮新稿质量结论 |

**保护要求：** 不删除、不重命名、不改写任何旧文件的内容或历史状态字段，新增的 Owner 临时解冻决策在时间上覆盖其中过时的现行约束。新框架尚未产生，旧文本只是比较基线。

## 三、独立Writer离线交付包

- **ZIP：** `第四部分_独立Writer全框架重写工作包_20261018.zip`
- **SHA256：** `7012b8271a5ebc58383827b373a96256dcb120ef9307df2318bdf963b0bd0db5`
- **交付方式：** ChatGPT会话内提供给Owner，由Owner转交Writer。此ZIP不是通过GitHub上传的；仓库中只登记名称、组成、校验摘要和重建所需的任务要求。
- **本轮本地核验：** ZIP包含7个UTF-8 Markdown文件，ZIP完整性测试通过、内容可解码且不含旧7/45/118的历史问题树。
- **离线文件清单：**
  1. `00_先读_任务与停点.md`
  2. `01_背景_受众_五板块职责.md`
  3. `02_一级二级三级问题设计规范.md`
  4. `03_知识覆盖与边界自检.md`
  5. `04_交付格式_模板与验收.md`
  6. `05_给Writer的转交提示词.md`
  7. `MANIFEST_文件清单及校验.md`

离线内容已自包含：中国大陆个人开发者与中小跨境商家的读者需求、五板块职责、唯一冻结核心、场景范围、三层设计标准、知识深度与去重、交付格式；**无需GitHub权限或任何其他项目文件**。

## 四、Writer应如何交稿及回来后的比较

Writer提交：
1. `第四部分_产品搭建_独立Writer完整框架_V1.md`：固定核心 + 自行设计的一级、二级、三级完整问题树，全部编号、知识覆盖、唯一父子归属、拆解理由和数量统计；不限制章节/题量。
2. `第四部分_独立Writer_设计与自检报告.md`：逻辑、去重、遗漏、各经营模式的适用性、专业知识边界、不确定事项、需要Reviewer核验的争议点。
3. 把两份Markdown打成 `第四部分_产品搭建_独立Writer_V1交付.zip`，附简短摘要。只有候选状态，不能冻结。

收到新稿后 Reviewer 分两步：
1. **先不看旧稿，独立审核新稿**：是否是商家真实问题，一级职责和二三级父题是否清晰，是否覆盖实体、数字、SaaS、服务、不同开发能力，是否有机械凑题或同义重复，是否越界。
2. **再与旧版7/45/118比较**：按知识责任映射比较新旧独有、共同、重复、遗漏和表达质量；不要按旧编号强行对应，也不能只看题数多寡。
3. 以读者价值、知识系统性、问题自然性、独立性、低成本/可复用思路、实际交付完整性为依据，建议**保留旧版 / 采用新版 / 融合两版**，并标出理由。
4. 若RETURN，给Owner一并提供最小定向返修ZIP与可复制提示词；Writer依旧无仓库权限。
5. 仅在Owner进一步明确批准后建立新的正式冻结问题树，旧稿原始证据继续保留。

## 五、治理Gate与权限边界

- **PROJECT_GOAL：** 面向中国大陆跨境商家的产品搭建和交付知识框架。
- **SYSTEM_MAP：** 只有GitHub Markdown文档与会话离线ZIP，没有部署、数据库、账号、网络或支付操作。
- **PREFLIGHT：** 已从GitHub `main` 回读第四板块当前README、交接、历史1/7/45正式快照及L3候选，并参照五板块标准及第五板块同类盲写流程；当前仓库具有多个活跃板块并发写入，父README更新须先读最新SHA、只作第四板块精确补丁。
- **TARGET_AND_SCOPE：** 仅 `cross-border-business/04-product-building/` 文档与 `cross-border-business/README.md` 第四板块导航。其他①②③⑤一律只读，第三板块CLOSED。
- **REQUIRED_EVIDENCE：** 明确Owner授权、ZIP文件列表和SHA、历史问题树保留、第四板块最新状态、read-back。
- **ACCEPTANCE_CRITERIA：** 核心固定、旧L1/L2明确暂时解冻、L3保留候选、独立Writer无旧版锚定且资料自足；未提前将Writer稿视为正式。
- **CURRENT_ROLLBACK_STATUS：** 纯文档新增及状态修改，可通过精确反向Git提交恢复；不重写Git历史，不删除旧快照。
- **MATERIAL_UNCERTAINTY：** Writer完成时间、模型和新各级题数均 `UNKNOWN`；未收到任何Writer新稿，不得报告比较结果。
- **OWNER_ONLY_ACTIONS：** 新稿采纳、重新冻结、改动唯一核心问题（本轮未授权）。
- **REVIEWER_TO_EXECUTOR_RELAY：** NONE，当前只等待Writer交稿。
- **EXECUTOR_TO_REVIEWER_RELAY：** ZIP及当前文档证据；不代表Writer写作已开始。
- **MANDATORY_STOP：** `WRITER_PENDING`；不启动正文或实际商业系统。

**Owner当前需要做的事：** 下载离线ZIP，连同提示词转发Writer；收到完整交付后发给Reviewer。
