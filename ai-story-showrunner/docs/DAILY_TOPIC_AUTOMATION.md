# Daily Topic Radar Automation Contract v0.1

## Goal

每天运行一次选题雷达，并维护 GitHub 中的**滚动 7 天内容排期**。

该任务是 Editorial Planner，不是 Publisher。

## Canonical Inputs

- `docs/TOPIC_OPERATING_SYSTEM.md`
- `topic-ledger/topic-registry.jsonl`
- `topic-ledger/EVERGREEN_BANK.md`
- `topic-ledger/calendar/YYYY-MM.md`
- `topic-ledger/daily/YYYY-MM-DD.json`

## Daily Execution

1. 获取当天最新公开 AI signals。
2. 优先使用一手来源确认事实；聚合项目/新闻只负责发现。
3. 将同一事件聚类，去掉转载重复。
4. 对候选执行 Human Relevance / Mechanism / Storyability / One Mechanism / Non-trivial Payoff / Audience Fit Gates。
5. 查询 Topic Registry，执行 D1–D4 去重。
6. 若存在合格 HOT candidate：它拥有最近未锁定排期槽位的抢占权。
7. 若不存在合格 HOT：从 Evergreen Bank 选择未重复的高质量问题。
8. 维护未来 7 天 rolling schedule。
9. 写入当天 `daily/YYYY-MM-DD.json`。
10. 更新当月 `calendar/YYYY-MM.md`。
11. 仅在候选首次进入计划时更新 Registry 为 `scheduled`；绝不自动标记 `published`。

## Calendar Status

- `planned`：自动排期，可被未来热点抢占。
- `locked`：已进入 G3+ 制作，不允许 Daily Radar 自动替换。
- `published`：真实发布，只能由发布/人工证据更新。
- `skipped`：明确跳过，保留历史。
- `validation`：系统验证样本，不属于发布排期。

## Hot Override Rule

热点只能抢占 `planned`，不能抢占：

- `locked`
- `published`
- 当天已经进入制作的 episode

若热点进入：
- 被挤出的 Evergreen 不删除，退回候选池；
- 日历 Notes 写明 `HOT_OVERRIDE` 与被替换 topic_id。

## Rolling Horizon

默认维持：

`today + next 6 calendar days`

不是要求每天都必须发布；这是候选生产排期。未来如果账号实际发布频率改变，只改 Calendar Cadence，不改 Topic Radar 核心。

## Output Minimum

每日 GitHub 必须可见：

### Daily Snapshot
- Hot signals
- Candidate shortlist
- Duplicate matches
- Rejected reasons
- Selected topic
- Evergreen fallback
- Evidence refs

### Calendar
| Date | Topic | Lane | Content Job | Status | Why Now / Human Problem | Notes |

## Safety / Governance

- 不自动发布平台内容。
- 不自动生成 `published`。
- 不因为热点热度高而跳过知识准确性 Gate。
- 不因 GitHub 写入失败伪造成功。
- 写入冲突时 fresh read-back 后再更新。
- Daily task 只能修改 Topic Ledger / Calendar 相关文件；不得自行推进 G3+。

## Automation Classification

`DAILY_TOPIC_RADAR = ENABLED`

运行时间由 ChatGPT scheduled task 管理；GitHub repository 负责保存长期状态和排期。

## Owner View

Owner 平时只需查看：

`topic-ledger/calendar/YYYY-MM.md`

需要知道当天为什么这样选时，再打开：

`topic-ledger/daily/YYYY-MM-DD.json`