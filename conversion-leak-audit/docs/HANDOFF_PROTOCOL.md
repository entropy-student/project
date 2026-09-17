# Conversion Leak Audit — GitHub Handoff Protocol

目的：让 Reviewer（ChatGPT）与 Executor（Codex / 本地 Agent）通过 GitHub 传递项目状态，避免依赖单个聊天窗口保存上下文。

## 1. Source of Truth Order

```text
1. Owner latest explicit instruction
2. conversion-leak-audit/PROJECT_RECORD.md
3. conversion-leak-audit/CURRENT_STATUS.json
4. docs/REVIEWER_HANDOFF.md
5. docs/EXECUTION_EVIDENCE.md
6. docs/EXECUTOR_HANDOFF.md
7. docs/ROADMAP.md
8. historical chat / old package
```

理论规则另以 `entropy-student/spike.skill/independent-store-operations/` 为权威来源。

## 2. Reviewer → Executor

Reviewer 改变执行目标时，优先更新：
- `PROJECT_RECORD.md`
- `CURRENT_STATUS.json`
- `docs/REVIEWER_HANDOFF.md`
- `docs/EXECUTOR_HANDOFF.md`
- 必要的 Gate 专用文档

Reviewer 在聊天中的默认回报应保持简短，例如：

```text
Reviewer 已完成并写入 GitHub。
请查阅：conversion-leak-audit/docs/REVIEWER_HANDOFF.md
当前 Gate：Gx ...
```

详细结论以 GitHub 文档为准，不在聊天里重复整份报告。

## 3. Executor → Reviewer

Executor 完成一轮后：
1. 提交真实代码；
2. 将事实证据追加到 `docs/EXECUTION_EVIDENCE.md`；
3. 在 commit message 中写明 Gate / change；
4. 如有截图/验收资产，写入约定目录；
5. 不擅自将 Gate 改成 PASS，除非 Reviewer 明确授权。

Executor 在聊天/终端回报也应简短，例如：

```text
执行完成，证据已写入 GitHub。
请查阅：conversion-leak-audit/docs/EXECUTION_EVIDENCE.md
Commit: <sha>
```

详细命令、测试、风险、截图位置均进入 GitHub，不依赖复制聊天内容。

## 4. Required Execution Evidence

```text
Gate:
Commit:
Files changed:
Commands/tests:
Results:
Screenshots / visual evidence:
Known limitations:
Risks:
Next suggested action:
Owner intervention required: YES/NO
```

## 5. Gate Ownership

- Executor：实现、测试、提供证据。
- Reviewer：判断 PASS / RETURN / HOLD / MERGED / CLOSED。
- Owner：付款、Secret、身份授权、重大产品方向、Shared Infra 变更、不可逆操作、生产开启，以及 G3.5 的最终视觉/产品方向确认。

## 6. What Must Never Enter GitHub

- API Secret / payment Secret；
- private key；
- live `.env`；
- account password；
- production database dump containing private user data；
- raw sensitive customer data。

允许记录 Secret 名称、放置位置、runtime reader、存在/验证状态，但不得记录值。

## 7. Avoid State Drift

每个 Gate 正式变化时，至少同步：

```text
PROJECT_RECORD.md
CURRENT_STATUS.json
REVIEWER_HANDOFF.md
ROADMAP.md
```

如果冲突：停止继续开发，先恢复单一真相。

## 8. Do Not Re-run Passed Work

除非有新反例 / 代码回归 / Reviewer reopen：
- theory foundation 不重跑；
- G1 不重搭；
- G2 不重做；
- G3 不重新拆出。

## 9. Current Handoff Point

```text
G1 = PASS
G2 = PASS
G3 = MERGED / CLOSED
G3.5 = NEXT
G4 = PENDING
```

Codex 当前应 HOLD，等待 Reviewer/Owner 完成 `G3_5_UI_GROWTH_FREEZE.md`。

## 10. Promotion to Shared Governance

本协议当前只在 Conversion Leak Audit 项目试运行。

如果 G3.5 → G4 → G4.5 等连续 Gate 能稳定通过，并证明：
- 聊天搬运显著减少；
- 状态漂移减少；
- Reviewer/Executor 能独立通过 GitHub 恢复上下文；
- 证据链完整；

则将该模式整理进通用项目管理规范 Skill，作为标准 Reviewer ↔ Executor 协作协议。
