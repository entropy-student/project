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

理论规则另以：

`entropy-student/spike.skill/independent-store-operations/`

为权威来源。

## 2. Reviewer → Executor

Reviewer 需要改变执行目标时，优先更新：

- `PROJECT_RECORD.md`（Gate / project state）
- `CURRENT_STATUS.json`（machine-readable state）
- `docs/REVIEWER_HANDOFF.md`（当前验收要求）
- `docs/EXECUTOR_HANDOFF.md`（执行边界 / 下一任务）

Executor 不应仅凭旧聊天继续执行。

## 3. Executor → Reviewer

Executor 完成一轮后：

1. 提交真实代码；
2. 将事实证据追加到 `docs/EXECUTION_EVIDENCE.md`；
3. 在 commit message 中写明 Gate / change；
4. 不擅自把 `CURRENT_STATUS.json` 的 Gate 从 PENDING/NEXT 改成 PASS，除非 Reviewer 已明确授权。

建议回报格式：

```text
Gate:
Commit:
Files changed:
Commands/tests:
Results:
Known limitations:
Risks:
Next suggested action:
Owner intervention required: YES/NO
```

## 4. Gate Ownership

- Executor：实现、测试、提供证据。
- Reviewer：判断 PASS / RETURN / HOLD / MERGED / CLOSED。
- Owner：付款、Secret、身份授权、重大产品方向、Shared Infra 变更、不可逆操作、生产开启。

## 5. What Must Never Enter GitHub

- API Secret / payment Secret；
- private key；
- live `.env`；
- account password；
- production database dump containing private user data；
- raw sensitive customer data。

允许记录：
- Secret 名称；
- Secret 应放在哪里；
- 哪个 runtime reader 需要权限；
- 是否存在 / 是否验证（但不记录值）。

## 6. Avoid State Drift

每个 Gate 正式变化时，至少同步：

```text
PROJECT_RECORD.md
CURRENT_STATUS.json
REVIEWER_HANDOFF.md
ROADMAP.md
```

如果四者冲突：

> 停止继续开发，先恢复单一真相。

## 7. Do Not Re-run Passed Work

除非有新反例 / 代码回归 / Reviewer reopen：

- theory foundation 不重跑；
- G1 不重搭；
- G2 不重做；
- G3 不重新拆出。

## 8. Current Handoff Point

```text
G1 = PASS
G2 = PASS
G3 = MERGED / CLOSED
G4 = NEXT
```

下一轮 Executor 任务应围绕：

`WordPress → Scanner → Top 3 local integration`

展开。
