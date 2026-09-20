# Governance Adaptation — AI Story Showrunner

## 1. Baseline

本项目治理基线不是自创流程，而是：

```text
entropy-student/spike.skill/vps-project-governance
Core: v0.1.6
+ active operational addenda
```

该规范原本覆盖 VPS / Docker / 自动化 / Browser Agent /生产项目。本项目属于**内容编排 + 自动化系统**，因此采用语义适配，而不是机械复制所有 VPS 条款。

## 2. 保留的核心治理规则

以下规则全部保留：

1. Owner / Reviewer / Executor 三角色；
2. Reviewer 是唯一正式 PASS / RETURN 决策者；
3. `PASS_CANDIDATE != PASS`；
4. 先读后写，UNKNOWN 不猜；
5. Gate 必须有单一目标、允许范围、禁止范围、验收标准；
6. Evidence before PASS；
7. 已 PASS Gate 默认不重跑，除非 material drift / 新证据推翻；
8. Owner 最小介入；
9. 相邻 Gate 可压缩，但不得降低 Evidence 标准；
10. current project truth 由唯一 `REVIEWER_HANDOFF.md` 维护；
11. Executor 只执行当前 Gate，不擅自扩大 scope；
12. 失败使用 RETURN 并回到最近可修复 Gate；
13. 真实外部动作必须 fail-closed；
14. Secret / account /不可逆动作保持 Owner-only；
15. 换聊天 / 换 Agent 不依赖记忆，先恢复 Handoff / Evidence。

## 3. 当前不适用的条款

在没有部署/runtime 前，以下标记为 N/A，而不是删除：

- Shared VPS storage layout；
- SSH / host identity；
- Docker / image identity；
- ports / Caddy / cloudflared；
- DB backup / restore；
- production provider canary；
- disk / BuildKit resource baseline。

一旦项目引入对应能力，自动恢复 canonical Governance 对应条款，不需要重写本适配文档。

## 4. 内容项目里的角色映射

### Owner

负责：

- 内容大方向 / 品牌方向；
- 重大产品选择；
- 外部账号授权；
- Secret；
- 真实发布 / 自动发布授权；
- 不可逆删除；
- 是否允许大规模自动化。

Owner 不负责：

- Worker 怎么串；
- schema 怎么设计；
- 选哪个现有 Skill 执行某个 Stage；
- ordinary Gate 技术判断。

### Reviewer / Showrunner

负责：

- 项目地图；
- Worker routing；
- Stage contract；
- Gate；
- accepted baseline；
- Evidence review；
- PASS / RETURN；
- `REVIEWER_HANDOFF.md`；
- 内容系统层面的 Story / Knowledge / Visual / Production QA。

注意：Showrunner 是业务编排角色，Reviewer 是治理角色。当前可由同一 Assistant 承担，但**概念上必须分层**：Showrunner 产生候选方案，Reviewer 决定 Gate 是否通过。

### Executor / Worker

包括：

- Codex；
- 独立 Execution Agent；
- Skill；
- 渲染脚本；
- 生图执行器；
- 外部自动化 Worker。

它们只拥有当前 Contract 授予的修改权。

## 5. Content Evidence

本项目 Evidence 不以命令日志为中心，而以可复核内容事实为中心。

### Topic / Research Evidence

- source URL / date；
- freshness window；
- fact / analysis / uncertainty 分离；
- content history duplicate check。

### Story Evidence

- No-name Test；
- Human-stakes Test；
- Story causality；
- mechanism 是否真实驱动事件；
- story summary without jargon。

### Script Evidence

- locked KnowledgeCore 没有被改变；
- claim map；
- Script ↔ SRT 一致性；
- target duration / audio alignment。

### Director Evidence

- Visual Beat many-to-many；
- beat change reason；
- reuse / generate decision；
- shotbook ↔ script refs。

### Asset Evidence

- Character / Style Lock；
- provider / reference asset；
- asset manifest；
- identity / continuity QA。

### Render Evidence

- timeline；
- audio master；
- resolution / duration；
- subtitle alignment；
- final Story / Knowledge / Visual / Production QA。

### Publish Evidence

- actual publish state；
- actual platform metrics；
- no fake analytics；
- learning 写回 Content Ledger。

## 6. Gate Status Language

统一使用：

```text
IN_PROGRESS
BLOCKED
PASS_CANDIDATE
PASS
RETURN_<CAUSE>
HOLD
BLOCKED_BY_REAL_INPUT
```

禁止使用“差不多完成”“基本跑通”“最后一步”等无法审计的状态代替正式 Gate 状态。

## 7. Documentation Model

```text
REVIEWER_HANDOFF.md
= 当前唯一 Reviewer 项目真相

PROJECT_RECORD.md
= 长期决策 / 历史 / 目标 / 里程碑

EXECUTION_EVIDENCE.md
= 可复核的执行与 read-back 事实

EXECUTOR_HANDOFF.md
= 只有在存在独立 Executor 时才维护其当前执行事实

CURRENT_STATUS.json
= 供机器读取的当前 Gate 镜像，不凌驾于 Reviewer Handoff
```

## 8. Bootstrap Reconciliation

本项目最初建立 README / PROJECT_RECORD / architecture docs 时，尚未先建立 `REVIEWER_HANDOFF.md`。

处理方式：

- 不删除已有历史；
- 不伪造“当时已有 Executor Evidence”；
- 通过 fresh GitHub read-back 核验当前仓库事实；
- 建立 `REVIEWER_HANDOFF.md`；
- 在 `EXECUTION_EVIDENCE.md` 记录这次治理对账；
- P0 以“治理对账后的当前事实”为基线重新 PASS。

该例外只处理项目 bootstrap 历史，不成为后续跳过 Governance 的先例。

## 9. Reviewer Minimum Report

每轮对 Owner 至少汇报：

```text
整体进展
最终目标
当前 Gate
已确认事实
UNKNOWN
本轮完成
验收结果
风险 / rollback
下一步
注意事项
是否需要 Owner 介入
```

默认简洁，不为了模板制造长篇重复。
