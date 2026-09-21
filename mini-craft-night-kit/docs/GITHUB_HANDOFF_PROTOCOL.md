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


## 7. Mandatory Diagnostic Evidence Packet

For any diagnostic RETURN, conflict-isolation Gate, compatibility investigation, runtime failure, or nontrivial root-cause claim, Executor must include a compact but sufficient `DIAGNOSTIC_PACKET` in `EXECUTOR_HANDOFF.md` and detailed supporting evidence in `EXECUTION_EVIDENCE.md`.

A diagnostic handoff is incomplete if it contains only a conclusion label such as `NETWORK_FAILURE`, `PLUGIN_CONFLICT`, `LOCAL_REQUEST_FAILURE`, or `COMPATIBILITY_ISSUE` without the supporting observations.

Minimum packet:

```text
DIAGNOSTIC_PACKET
GATE=<gate>
ENVIRONMENT=<runtime/version/target>
TRIGGER=<exact sanitized symptom/error>
REPRODUCTION=<exact bounded command/route/action, sanitized>
OBSERVED=<HTTP/status/error type/timing/CPU/etc.>
CONTROL_OR_BASELINE=<comparison result, if any>
HYPOTHESES_RULED_OUT=<evidence-backed exclusions>
HYPOTHESES_REMAINING=<ranked candidates, not conclusions>
ARTIFACTS=<safe local evidence/helper paths + hashes when relevant>
SECRETS_REDACTED=YES
NEXT_DISCRIMINATING_TEST=<single smallest next test>
STOP_REASON=<why Executor stopped>
```

For exceptions, include sanitized exception class/category, stage marker, and HTTP status when available. Do not include credentials, tokens, cookies, authorization headers, raw sensitive response bodies, or secret-bearing command lines.

Reviewer must not promote a diagnostic conclusion to formal truth if the packet lacks enough evidence to distinguish it from adjacent hypotheses. In that case, return for evidence completion rather than inventing the missing chain.

This rule is project-local trial governance. Global promotion still requires a separate Governance Change Gate.


## 8. Owner Checkpoint Artifact Readiness

Before Executor returns an Owner-run command, every referenced local artifact must still exist at the final stop point and the exact Owner command must be dry-run validated through the same staging path without credentials.

Minimum readiness evidence:

```text
OWNER_CHECKPOINT_READINESS
COMMAND=<exact sanitized Owner command>
LOCAL_ARTIFACTS_PRESENT=PASS
CONTAINER_STAGING_PATH=PASS|N/A
POST_CLEANUP_EXISTENCE_CHECK=PASS
NO_SECRET_DRY_RUN=PASS
EXPECTED_PRE_AUTH_STAGE=<stage reached without credentials>
CLEANUP_AFTER_OWNER_RUN=<what is removed and when>
```

Executor must not delete or move any helper needed by the Owner before the Owner checkpoint is completed. Cleanup may remove container-temporary copies only if the Owner wrapper deterministically recreates them from a retained local source on every run and that exact path is verified after cleanup.

A syntax/lint check alone is not sufficient for Owner checkpoint readiness. The exact wrapper/staging chain must be validated after cleanup.
