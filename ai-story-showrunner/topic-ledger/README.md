# Topic Ledger

本目录是 AI Story Showrunner 的长期选题记忆，不是普通发布日历。

## 目录

- `topic-registry.jsonl`：canonical topic 历史与语义指纹；防止同题同角度重复。
- `daily/YYYY-MM-DD.json`：每日 Hot / Evergreen 候选快照。
- `daily/TEMPLATE.json`：每日雷达输出模板。
- `calendar/YYYY-MM.md`：编辑日历，只记录计划/发布状态。
- `EVERGREEN_BANK.md`：未依赖单日热点的长期候选母池。

## 三者区别

`Daily Radar` 回答：今天大家在关心什么、出现了哪些人类生活/文化/平台/AI 信号，以及其中哪些值得转成 WHY？

`Topic Registry` 回答：这个机制/人类问题/回报过去是否已经讲过？用了什么故事母题？

`Calendar` 回答：哪天准备发布哪一个已经选定的 Topic？

防重复优先查询 Registry，不允许仅凭 Calendar 判断。

## Canonical fingerprint

v0.2 发现层：
`x_domain + observed_paradox + why_question + human_tension + ai_changed_process`

原核心判重层继续保留：
`mechanism + human_problem + audience_payoff`

表层：
`story_motif + hook_pattern + visual_motif`

历史 registry entry 不追溯补字段；新 entry 有信息时再记录 v0.2 字段。

## Status

- `candidate`：候选
- `validation`：系统验证样本，不等于已发布
- `scheduled`：已进入日历
- `published`：真实发布
- `hold`：暂存
- `rejected`：未通过 Gate
- `revisit_allowed`：满足明确重讲条件

任何自动任务都不得自行把状态写成 `published`。