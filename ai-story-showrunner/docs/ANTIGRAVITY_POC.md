# Antigravity Execution PoC v0.1

## 1. Current Integration Classification

`integration_level = MANUAL_EXECUTOR`

含义：

- Showrunner 可以生成完整、结构化、可直接交付的 Execution Package；
- 当前尚未验证 Showrunner 能通过稳定 API / connector 自动启动 Antigravity；
- 因此不能标 `PROGRAMMATIC`；
- 但也不再标 `UNKNOWN`，因为执行边界和 handoff 方式已经明确。

状态：`NOT_YET_POC_VALIDATED`。

## 2. PoC Goal

只验证一个问题：

> Antigravity 能否在**不自行创作**的前提下，读取低层施工包，批量生成指定图片，并按 exact timeline 组装成视频。

不在 PoC 阶段优化美术质量、流量或完整 Story。

## 3. Minimal Test

使用 8–12 秒、4–6 个 shot 的 synthetic package。

每个 shot：
- exact start/end；
- one image；
- locked character reference；
- locked scene reference；
- final prompt；
- exact transition；
- exact subtitle。

## 4. Pass Criteria

同时满足：

1. shot count 完全一致；
2. 不自行合并/删除/新增镜头；
3. 图片文件和 image_id 对得上；
4. 人物核心 identity 不漂；
5. timeline start/end 在允许误差内；
6. 未指定效果不新增；
7. 字幕不改字；
8. 能返回执行结果或至少可复核的产物清单。

## 5. Audio A/B

### PoC-A — UPSTREAM_TTS

输入最终音频 + SRT + shot timeline。

目的：验证最稳定时间轴。

### PoC-B — EXECUTOR_TTS

输入 locked script/SRT + voice config，由 Antigravity 生成 TTS，再按最终音频长度执行。

额外 Pass：
- 不改字；
- voice config 可重复；
- TTS 后 timeline 可稳定重编译。

## 6. Decision Rule

如果 A 与 B 都通过，优先比较：

- 时间线稳定性；
- 执行复杂度；
- 重跑成本；
- 音色一致性；
- 是否需要人工介入。

不是默认选择“一口气更多”的 B；只选**更稳定、更少人工**的一条。

## 7. Failure

- `RETURN_EXECUTOR_CHANGED_CONTRACT`
- `RETURN_TIMELINE_MISMATCH`
- `RETURN_CHARACTER_DRIFT`
- `RETURN_EXECUTOR_TTS_DRIFT`
- `RETURN_EXECUTION_ENVIRONMENT_UNRESOLVED`

PoC 失败不推翻内容系统，只返回 Production Adapter 层。