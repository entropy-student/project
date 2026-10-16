# 现代商业支付系统｜当前有效文档索引

> 2026-10-16 Reviewer同步。**唯一权威状态/冻结问题/Gate在** [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)，本索引不自建项目状态。旧版本/废弃Gate已从main移走，需要恢复时查 [../DECISION_LOG.md](../DECISION_LOG.md) 固定清理前Commit，不直接调用历史工作稿。

| 当前文件 | 作用 | 状态 |
|---|---|---|
| [REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md) | 唯一项目交接：目标、全书7/29/42正式冻结问题、当前进度、下一写作Gate、恢复路径 | **ACTIVE** |
| [FROZEN_FRAMEWORK_V6_20261016.md](FROZEN_FRAMEWORK_V6_20261016.md) | Owner冻结完整V6问题框架快照 | **KEEP / FROZEN** |
| [P1_STRUCTURE_COVERAGE_ACCEPTED_ARCHIVE.md](P1_STRUCTURE_COVERAGE_ACCEPTED_ARCHIVE.md) | P1七章结构覆盖已通过的审计证据；虽为历史成果但具备当前必要的验收追溯价值 | **KEEP / ACCEPTED EVIDENCE** |
| [P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md](P2_CHAPTER1_OWNER_ADOPTED_REWRITE_20261016.md) | **Owner已正式通过的第一部分①正文**：外部Agent稿+事实修正；后续引用此版，不再引用旧PR教学候选 | **KEEP / OWNER FINAL PASS** |
| [P3_KNOWLEDGE_INTEGRATION_PLAN_20261016.md](P3_KNOWLEDGE_INTEGRATION_PLAN_20261016.md) | 知识点按七章分配、明确首次解释/跨章引用，避免冗余和独立百科 | **KEEP / P3 REVIEWER PLAN PASS** |
| [DECISION_LOG.md](../DECISION_LOG.md) | Owner最终接受、写作三Skill退役、历史文件恢复锚点 | **KEEP** |
| [EXECUTION_EVIDENCE.md](../EXECUTION_EVIDENCE.md) | 本轮清理与后续规划的主干执行证据；旧PR分支Evidence不是本文件 | **KEEP / APPEND ONLY** |

## 已关闭的旧流程

- [PR #132](https://github.com/entropy-student/project/pull/132)：`CLOSED / NOT MERGED / SUPERSEDED`。旧稿、过程证据、旧写作Skill实验仅供Git历史追溯，不再作为现行写作底本。
- 清理前main固定恢复点 `f6d3aa43785e1c0671bef4fce2807aa739f0689e`，可恢复main已删15份历史/过期文档。**删除的是main当前文件，不是抹除Git历史**。
- 项目文件库 `/现代商业支付系统/` 现行只保留正式第一部分修订稿及纠错记录；原4份旧文档已移至回收状态，完整ZIP备份存于 `/项目历史归档/现代商业支付系统_清理前历史文档备份_20261016.zip`。
- `human-writing`、`copy-editing`、`humanizer` **停止作为必经写作Skill**，旧`plain-language`非强制；写作由外部Agent独立完成。

## 下一步

**②《收款开通与接入》写作交接**：按Handoff的当前Gate，先由Reviewer提供**实际含完整参考资料的ZIP + 单独提示词**交Owner，由Owner发给独立外部Agent。新Agent默认只输出单个UTF-8 Markdown文件，先Review，再决定是否接受到main；无需给它GitHub权限、不启动HTML。
