# Topic Bank｜Schema v1.1 技术对齐记录

**日期**：2026-10-10  
**授权范围**：Owner 明确同意按现有 JSON 结构对齐字段、补充可空来源/日期/下一动作、增加只读校验；**任何实际选题判断/业务评分的改变均未授权，也未执行**。

## 一、改了什么

- 保留 `TOPICS_V1.json` 全部 **36 条既有记录字段和原值**，只将 `schema` 标识从 `CW-TOPIC-BANK-1.0` 升级到 `CW-TOPIC-BANK-1.1`。
- **原本 15 条具有的 `original_url`、`discovered_on`、`published_on` 原值不动**；没有这些值的记录现在统一有相应字段且赋为 `null`（共 21 条）。`original_url` 仅表示候选资料定位，并不证明链接是原始论文或已核实全文：有的旧值其实是出版社列表页或研究新闻稿。
- 全 36 条加入 `next_action:null`，明确未经过独立逐题审核，不能把宏观批次建议伪造为每条具体行动。
- [WORKFLOW 第 3 节](WORKFLOW_V1.md) 仅把机器字段名从早期文档草案对齐实际 JSON 的 `title`、`ratings.*`、`story_beats` 等，并说明三个视频状态字段不得合并为一个版权批准状态。
- 新增 [validate_topic_bank.py](validate_topic_bank.py) 与 [test_validate_topic_bank.py](test_validate_topic_bank.py)：检查必备字段、四轴合法枚举、日历日期、空值、重复 ID、状态计数、BOARD 总量和全 ID 覆盖；**不会计算新评分、代替人工选题或判定 STORY-FIT/商用许可**。
- 新增仓库只读 CI [cws-topic-bank-validation.yml](../../../.github/workflows/cws-topic-bank-validation.yml)，只在对应题库/看板/校验器文件变动时触发离线校验；不抓取来源、不修改生产或其他项目。首轮 GitHub Actions [#38032465320](https://github.com/entropy-student/project/actions/runs/38032465320) 显示 **TOPIC_BANK_VALIDATION=PASS**、**Python unittest 11/11 通过**；后续微调测试会重新运行。
- `BOARD_V1.md` 不改：题目数量、ID、标题、评级、状态没有变化。

## 二、日期和来源语义（不可误报）

| 字段 | 存储格式 | 允许 `null` | 语义界限 |
|---|---|---|---|
| `source_url` | HTTP(S) | 不允许 | 当前主要的发现/资料入口，不自动等于原始研究全文 |
| `original_url` | HTTP(S) | 允许 | 历史人工登记的候选“原始资料”链接；准确角色需结合证据状态继续审核 |
| `discovered_on` | YYYY-MM-DD | 允许 | 该次批次记录的发现日期；不从 `batch_id` 猜测 |
| `published_on` | YYYY-MM-DD | 允许 | 原批次记录的资料发表日期，**不能统一认定是期刊论文发表日**，机构新闻需另核 |
| `next_action` | 文本 | 允许 | 有明确逐题依据时才能填写；`null` 只是没有记录，不代表无需后续核验 |

未知一律保留 `null`；新增/补充信息时要有对应可追溯来源。不引入空字符串或不明来源的 `UNKNOWN` 日期。

## 三、明确未触碰

- 四轴的原有 HIGH/MED/LOW/UNKNOWN 值与定义，以及“至少两个高潜力”的 SHORTLIST 条件；
- 七阶段工作流、STORY-FIT 只允许 SHORTLIST 正式深审的规则；
- B/D 仍然不在这 36 条机读母库，不能藉迁移自动晋级；
- 36 条旧记录的 `status`、`storyfit_status`、`owner_selected`、`evidence_state`、`source_originality`、`story_beats`、`critical_caveat`、视频素材状态与任何既有日期/链接；
- HF-FIND 唯一协议、采集器扫描、九源覆盖、Mac v1.2、OpenMontage、本地云 TTS 和生产。

## 四、命令与回滚

从仓库根目录执行：

```powershell
python curious-world-studio/research/topic-bank/validate_topic_bank.py
python -m unittest discover -s curious-world-studio/research/topic-bank -p test_validate_topic_bank.py -v
```

兼容失败时返回非零退出码。回滚时还原本次 PR 修改的 JSON（v1.0）与 WORKFLOW 第 3 节字段合同，删去新工具与测试；旧 36 条数据原本未改变。**不要仅改 schema 版本字符串而留下 v1.1 工具检测 v1.0 的不兼容状态。**

## 五、未来业务决策仍要 Owner 审核

PROGRESSION 是否拆分“证据/观看”双轨、故事机制 M1/M2/M3 是否正式采用，以及改变 SHORTLIST 入选门槛，这些都属于**实际业务逻辑变化**，当前未做。P3-R2 尚待运行。
