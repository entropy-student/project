# Topic Bank｜字段映射：历史审查与 Schema v1.1 技术修复

> **最新状态（2026-10-10）**：经 Owner 授权执行技术对齐；下方原有“不修改/待决定”属于**此前审查的历史快照**，不再表示当前仍未实施。正式 WORKFLOW 的**第 3 节机器字段合同**已与 JSON v1.1 对齐；第 0–2 节业务流程、四轴含义、分级标准和晋级门槛没有变化。详见 [Schema v1.1 迁移记录](SCHEMA_V1_1_CHANGELOG.md)。

**现已完成的动作**：原 18 个既有记录字段保持不变，补齐 4 个可空元数据 `original_url`、`discovered_on`、`published_on`、`next_action`；原来 15 条拥有的资料链接/日期保留，缺少的历史事实统一置为 `null`；未重新打分、未自动填审核动作。增加只读 `validate_topic_bank.py` 与单元测试。此处的“`original_url`”只是早期人工登记的候选来源链接，可能是新闻/列表页，不能视作原论文已核对。

**日期**：2026-10-10；**性质**：数据结构核对备忘；**不修改任何业务协议、数据字段或题目状态**。正式流程仍以 [WORKFLOW_V1](WORKFLOW_V1.md) 为准。

经读取 `TOPICS_V1.json` 全部 36 条：共 18 个固定顶层字段（示例包括 `id,title,ratings,story_beats`）；36 个 ID 唯一，`BOARD_V1.md` 与 JSON 的 36 个 ID 和四类状态数量一致。

| WORKFLOW 所列“每条至少”字段 | JSON 当前存在的同义信息 | 兼容性判断 |
|---|---|---|
| `id`, `area`, `discovery_source`, `status`, `batch_id`, `evidence_state` | 同名字段 | 可直接读取 |
| `question` | `title` | **可能同义**，但“问题”与“标题”是否强制相同尚未作为 Schema 合同批准 |
| `original_source`, `links` | `source_url`, `source_originality`, `video_link` | **不等价**：单条链接及来源原创性标记不能证明已经存储完整原始研究/研究新闻/项目页的多地址表 |
| `date` | `batch_id`, 全局 `last_updated` 以及批次报告 | **缺独立逐题日期字段**；批次日期不是论文发布日期 |
| `story_angle` | `title`, `story_beats` | 有切入点/节点，但未定义独立角度字段的合同 |
| `hook,surprise,progression,visual` | `ratings.hook`, `ratings.surprise`, `ratings.progression`, `ratings.visual` | 现有四轴在嵌套对象中；**没有改分值与阈值** |
| `competitor_check` | `bilibili_competitors` | 语义相近，状态字段名不同，尚无标准化枚举合同 |
| `media_state` | `video_link`, `video_content`, `media_rights` | **需要保留三个独立关口**，不应压缩为一个“已找到视频”标志 |
| `caveat` | `critical_caveat` | 同义可能性高，仍需明确映射 |
| `next_action` | 各期 `batches/*.md` 报告 | **JSON 逐题字段不存在**，无法假设所有批次都能完整替代 |

**核对结果**：WORKFLOW 约定的 18 个字段中，有 13 个在 36 条机读条目中均**没有同名字段**；其中多数是改名/嵌套，`date` 与 `next_action` 等有实质缺口。**不能报告为“36 条全部内容缺失”或“已完成 Schema 对齐”。**

**待 Owner 决定的业务/接口设计（禁止本轮擅自执行）**：
1. 批准 `TOPICS_V1.json` 实际结构作为新正式 Schema，还是调整题库迁移以符合 WORKFLOW 的原合同？
2. 决定 `question` 与 `title`、`story_angle` 与 `story_beats` 是否应独立保存；日期是发现/发表/验证哪个时点。
3. 将 `original_source/links` 和 `next_action` 作为强制字段时，缺失如何补证，不能凭报告或猜测填空。
4. 统一校验器、迁移回滚和“BOARD 同步”合同；升级必须同时保证 36 条 ID 与状态不变，之后再另行讨论内容分数修订。

**本次只创建映射文档，不重命名字段、不创建校验器、不改 WORKFLOW。**