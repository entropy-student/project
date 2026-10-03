# Round Timing Retrospective（轮次耗时与超时复盘）

> 目的：单独记录本项目每轮 Executor 的预计耗时、实际耗时、超时原因和可复用优化措施。
>
> 本文件只记录执行效率与流程改进，不替代 `REVIEWER_HANDOFF.md`、`EXECUTION_EVIDENCE.md` 或 `DECISION_LOG.md` 的项目真相、证据和决策职责。

## 记录原则

- Reviewer 在每轮 Gate 中给出端到端预计耗时区间。
- Executor 记录开始时间、结束时间、实际耗时、是否超时。
- 超时本身不等于 Gate 失败；只要执行仍正常推进，不因为超时中断技术工作。
- 超时原因优先来自已有 Evidence；原因不明显时只做一次针对慢阶段的有界排查。
- 真实请求、远端写入或其他 consequential action 不得因为 Git rebase / push 冲突而自动重放。
- 后续逐步补充阶段耗时，但不能为了计时增加明显执行负担。

## 历史轮次

| 轮次 | 预计耗时 | 实际耗时 | 是否超时 | 主要原因 / 结论 | Evidence |
|---|---:|---:|---|---|---|
| G2-C private REALITY compatibility canary（curl 35） | 25–45 分钟 | 未记录 | UNVERIFIED | 首轮启用 timing observability 后，Executor 漏记实际耗时。技术结果仍有效，但这是一次观测记录缺失。 | Reviewer review of commit `450a3d18...` |
| G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1 | 15–30 分钟 | 24m29s | NO | 处于预计区间内；完成握手目标检查、一次私网请求、脱敏错误分类和 cleanup。 | main `e2e89aa9...` / diagnostic `c45a0968...` |
| G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2 | 10–20 分钟 | 25m12s | YES | 主要不是 VPN 技术阶段变慢，而是执行期间共享 `main` 多次前进，首次 push 被拒后需要 fetch / rebase / retry。 | main `0d9249ad...` |
| G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 attempt 1 | 20–35 分钟 | 55m10s | YES | 两类开销叠加：① 本地 PowerShell helper 在最后启动 curl 前才暴露空 `--noproxy` 参数绑定问题，导致前面的远端准备已完成后再回头诊断/修复；② 执行期间共享 `main` 前进，需要同步协调。真实 OpenAI 请求数为 0。 | commit `f2a02ca6...` |
| G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 retry | 15–25 分钟 | PENDING | PENDING | 已将本地 no-network empty-argument fixture 前置到任何远端启动之前；本轮用于验证优化是否有效。 | current Gate |

## 已确认的主要耗时来源

### 1. 本地 runner 问题发现过晚

R3 attempt 1 的主要流程是：

```text
远端资产准备
→ 服务端配置与启动
→ 私网 listener 验证
→ Windows Mihomo 客户端准备
→ 准备启动 curl
→ 才发现 PowerShell 参数绑定拒绝空 --noproxy 值
```

问题本身很小，但出现位置太靠后，导致前面的远端准备时间全部已经投入。

**改进：把所有纯本地、无网络、无 Secret 的 runner 验证前置。**

标准顺序调整为：

```text
AST / 语法
→ 参数绑定 fixture
→ 进程启动参数 dry fixture
→ 配置静态校验
→ 本地 PASS
→ 才允许 SSH / 下载 / 启动远端临时服务
```

当前 R3 retry 已落实第一项：empty-argument no-network fixture 必须先 PASS。

### 2. 共享 GitHub main 的并发推进

R2 与 R3 都出现过：

```text
本轮开始时 main=A
→ 其他项目/Agent 推进 main
→ VPN 本轮完成
→ push rejected / branch behind
→ fetch
→ reconcile / rebase
→ retry push
→ fresh read-back
```

这不会改变网络测试结果，但会显著放大总耗时。

**改进：把 Git 同步集中到轮次边界，而不是执行中途追逐 main。**

推荐模型：

```text
ROUND START
fresh-read main
→ 固定本轮 base / project-scoped worktree
→ 执行当前 Gate
→ 中间不因为无关 main 提交而重启 Gate
→ 保留 consequential result
→ ROUND END 单次 fetch/reconcile
→ commit/push
→ fresh read-back
```

关键约束：**Git 同步冲突绝不能触发真实网络请求或其他 consequential action 的重放。**

### 3. 缺少阶段级耗时

目前只有总耗时，因此能确认 R2/R3 的主要超时类别，但无法精确判断每一阶段分别占了多少分钟。

后续在不明显增加复杂度的前提下，逐步记录：

```text
LOCAL_PREFLIGHT
LOCAL_FIXTURE
REMOTE_PREPARE
SERVER_READY
CLIENT_READY
REAL_REQUEST
CLEANUP
GIT_PERSISTENCE
TOTAL
```

只记录阶段开始/结束或 elapsed；不为计时引入新的复杂 telemetry。

## 当前优化方案

### A. Shift-left：本地问题先于远端工作发现

**状态：ACTIVE**

- PowerShell AST / helper 参数绑定 / no-network fixture 前置。
- 配置模板尽量在本地先做 parse/check。
- 可以在本地证明的问题，不等到远端服务已经启动后再发现。

预期收益：把“最后一步才发现 runner 错误”变成“几秒到几分钟内 fail-fast”。

### B. Project-scoped worktree + 轮次边界同步

**状态：RECOMMENDED / PARTIALLY_ACTIVE**

- VPN 每轮使用独立、项目范围清晰的 worktree。
- 开始时固定 base。
- 结束时再统一 reconcile 最新 `main`。
- 无关项目推进不得导致当前 Gate 重跑。
- 若 push 失败，优先持久化已保留的执行事实，不重新执行真实动作。

预期收益：减少共享 monorepo 多 Agent 并发导致的 rebase / retry 时间。

### C. 轻量阶段耗时

**状态：NEXT**

- 在现有 phase marker 基础上记录少量 elapsed。
- 只在超出区间时重点看最慢阶段。
- 正常轮次不做额外性能诊断。

预期收益：以后能直接回答“慢在下载、SSH、服务启动、请求、cleanup 还是 Git”。

### D. 估时滚动校准

**状态：ACTIVE**

估时不固定使用同一个模板数字，而根据最近同类 Gate 实际数据修正：

- 新 runner / 新 server core / 新 Secret 生命周期：预留开发与验证余量。
- 已存在 runner 的同 Gate retry：缩短预计区间。
- 共享 `main` 活跃期：额外留少量 Git reconcile 余量，但不把异常 rebase 时间无限计入正常预算。

当前 R3 retry 已从 20–35 分钟调整为 **15–25 分钟**。

## 不建议为了提速做的事情

以下做法会让数字变快，但不值得：

- 跳过 cleanup / post-readback；
- 跳过 Secret 安全边界；
- 为减少下载时间而未经 Gate 设计长期残留临时二进制或 Secret runtime；
- 因为 push 冲突重新执行真实请求；
- 为了“赶时间”取消 private-first 验证直接开放公网 443；
- 大幅减少 Evidence 导致 Reviewer 无法 formal PASS。

优化目标是减少**无价值等待、重复工作和过晚发现的本地错误**，不是削弱验收。

## 后续更新规则

每个出现以下任一情况的 Executor round 都在本文件追加一行：

- 有正式预计耗时与实际耗时；
- `TIME_OVERRUN=YES`；
- 出现新的可复用耗时根因；
- 已实施的流程优化被验证有效/无效。

若超时原因只是一次性业务/网络偶发现象，记录事实即可；只有可复用的流程改进才进入“当前优化方案”。

## 当前观察

截至 2026-10-03：

- R1 在预计区间内；
- R2 的主要流程损耗是 GitHub shared-main concurrency；
- R3 attempt 1 的最大可避免损耗是**本地 runner 错误发现过晚**，其次仍有 shared-main reconciliation；
- 因此当前最高优先级的效率优化是：**本地 fixture 前置 + project-scoped worktree + round-boundary Git reconciliation + 轻量阶段计时**。
