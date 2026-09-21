# Mini Craft Night Kit — GitHub Reviewer / Executor Handoff Protocol

Last reviewed: 2026-09-18  
Status: **TRIAL APPROVED**

## 1. Goal

减少 Owner 在聊天中复制粘贴长日志与文档。

GitHub `entropy-student/project/mini-craft-night-kit/` 作为 Mini Craft 项目的长期可查阅记录面。

## 2. Reviewer-owned documents

Reviewer 维护：

- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
- `docs/*DECISION*.md`
- Gate / architecture / acceptance truth

Reviewer 聊天回复默认简化为：

> Reviewer 已完成，可查阅 `mini-craft-night-kit/REVIEWER_HANDOFF.md`。

如果有专项 Decision，则附对应文档名。

## 3. Executor-owned documents

Executor / Codex 维护：

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- 必要的 manifest / evidence index
- 当前 Gate 的实现代码与可安全提交的测试证据

Executor 聊天回复默认：

> 执行完成，可查阅 `mini-craft-night-kit/EXECUTION_EVIDENCE.md` 与 `EXECUTOR_HANDOFF.md`。

## 4. Secret Boundary

GitHub 永远不得写入：

- .env；
- password；
- token；
- private key；
- Provider Secret；
- cookies；
- credential dump；
- production customer sensitive data。

Evidence 只记录：
- Secret 是否存在；
- Secret 配置位置类别；
- read-back 成功/失败；
- 必要的非敏感标识。

## 5. PASS Boundary

Executor 只能写：

`PASS_CANDIDATE`

只有 Reviewer 能写正式：

`PASS`

## 6. Promotion to Global Governance

当前先在 Mini Craft 项目试运行。

满足以下条件后再写入全局 Governance：

- 至少连续 3 个 Gate 顺利；
- Reviewer 能直接从 GitHub 接管；
- Executor 不覆盖 Reviewer Truth；
- Owner 不需要搬运长日志；
- Secret / evidence boundary 无事故；
- 历史记录可追踪。

成功后建立 Governance Change Gate，将其推广到其他项目。
