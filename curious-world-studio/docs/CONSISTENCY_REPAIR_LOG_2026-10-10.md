# Curious World Studio｜全项目一致性 Review 第一批修复记录

**2026-10-10**，Owner 同意自主整理**交接文档与业务状态元信息**，要求任何实质业务逻辑修改必须**事先说明并征求确认**。

## 本次确实执行（非业务逻辑）

| 项目 | 改动 | 允许范围 |
|---|---|---|
| 统一当前进度 | 新增 [CURRENT_STATE.md](CURRENT_STATE.md)；AGENTS/README/Reviewer/Project Handoff/STATUS 各自指向此页，旧记录保留为历史快照 | 信息同步，不变更正式工作流 |
| 题库字段冲突 | [SCHEMA_COMPATIBILITY_REVIEW.md](../research/topic-bank/SCHEMA_COMPATIBILITY_REVIEW.md) 记录 WORKFLOW 与 JSON 对应字段、不可等价字段、缺口和待裁决问题 | **只读映射**，不变更 Schema、不迁移 |
| 题库 scope | 仅更正 `TOPICS_V1.json` 顶层 `scope` 元数据，从错误的“3项定向核实”改为“历史21 + 定向新增15、整体覆盖 PARTIAL” | 36 条题目/所有评分/状态/ID 不变 |
| 旧版来源表 | `research/SOURCE_REGISTRY_V1.md` 明示仅历史候选，与正式 `SOURCE_SYSTEM_FINAL_V1.md` 区分 | 不改变九源结构 |
| OpenMontage | 以 Owner 技术交接记录“本地 READY / 仓库未集成 / 长视频质量未验证”；生产前 Owner 硬停点统一入当前状态 | 不安装、不调用、不生产 |
| B 音频 QA | [P2-E_AUDIO_QA_EVIDENCE_INDEX](../research/topic-bank/batches/2026-10-10_P2E_AUDIO_QA_EVIDENCE_INDEX.md) 只保存 Actions 运行证据及局限，**不合并源码/音频/工作流** | 只归档事实 |
| Codex 相对路径 | `visual/retro-mac-v1.2/docs/CODEX_HANDOFF.md` 统一成 `curious-world-studio/` 项目根相对路径 | 仅修正阅读入口 |

## 已审查并刻意未修改（需 Owner 先裁决）

- `research/topic-bank/WORKFLOW_V1.md` 的 18 个字段合同、STORY-FIT 对 SHORTLIST 的限制、四轴含义与高中低准入规则。
- HF-FIND 唯一协议、九大信息源正式规则、采集器、已运行的 Actions 工作流、Mac v1.2 视觉参数与 QA 硬约束。
- `TOPICS_V1.json` 中每一条 `topics` 记录、`counts`、`schema` 和 `BOARD_V1.md`；不新增 B/D 编号，不使任何选题自动晋级。
- P3 旧 B 比 D 更适合故事的判断只是**历史阶段编辑假设**；P3-R1 的 M1/M2/M3 也只是待实测的研究候选，**均未变成新业务逻辑**。
- 是否新增 `STORY_PROTOTYPE`、是否拆分 PROGRESSION 为“证据推进/观看推进”、是否改变 SHOW/GO/NO-GO 合同及视觉评分定义，留待 P3-R2 结束后与 Owner 一起裁决。

## 验收要求

- `TOPICS_V1.json` 可解析：36 条、11 SHORTLIST / 15 VERIFY / 9 HOLD / 1 REJECTED。
- `topics` 和 `counts` 与 main 基线逐字节/语义一致，仅元数据 `scope` 发生改变。
- 两个原业务文件 `research/HF_有趣发现_唯一主协议.md`、`research/topic-bank/WORKFLOW_V1.md`，以及视觉锁定文件内容不变。
- 所有新文档链接解析到项目中已存在的文件或有明确 GitHub Actions 外部目标；README/AGENTS/交接的当前状态入口同一页。
- **没有视频、音频生成、额外 API 调用、模型安装或其他一级项目修改。**
