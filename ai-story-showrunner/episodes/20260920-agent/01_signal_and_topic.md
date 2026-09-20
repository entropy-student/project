# 01 — Agent Signal & TopicOpportunity

## Status
`TOPIC_GATE = PASS`

## TopicOpportunity

```yaml
topic_id: agent-delegated-workflow
signal: AI 正从单次回答走向能够长时间运行、调用工具、执行多步任务的 agentic systems
why_now: 2026 年 agent 产品与基础设施持续推进，用户越来越常遇到“让 AI 替我做完”而不是“告诉我怎么做”
human_problem: 我到底什么时候是在问 AI，什么时候已经是在把事情交给 AI
human_stakes: 一旦 AI 从建议变成代执行，错误不再只是“回答错了”，而可能变成真实退款、发信、改文件或其他外部动作
ai_mechanism: Agent 由 LLM 控制 workflow execution，根据当前状态选择工具和下一步，在 guardrails 内代表用户完成多步任务
one_mechanism_only: true
curiosity_gap: 同一句“帮我处理一下”，为什么有的 AI 只给你一份步骤，有的 AI 已经把事情做完了
story_seed: 老板招了两个助理，一个每次只告诉老板“下一步应该做什么”，另一个拿到目标后会自己查订单、判断流程、调用工具并把任务推进到结束
audience_payoff: 理解 Agent 的核心不是“回答更聪明”，而是把工作流控制权部分交给模型，让它代表你推进任务
search_anchor: AI Agent / Agentic AI
primary_content_job: DISCOVERY
secondary_content_job: TRUST
conversion_adjacency: HIGH
conversion_path_hypothesis: Agent workflow / automation / approval / guardrail / tool-use products
visual_storyability:
  status: PASS
  reason: 两个助理对同一个任务的行为差异天然可视化，且能通过真实动作而不是定义解释 Agent
novelty_vs_history:
  status: NEW
  reason: G2 第二类验证题，重点是行动与控制权
repetition_risk:
  level: LOW
  repeated_elements:
    - assistant metaphor, but conflict and mechanism differ materially from MCP
uncertainties:
  - 不把“Agent”定义成单纯会调用工具
  - 不把高度自主当成必然要求；重点是模型控制 workflow execution
  - guardrails 作为执行边界出现，但不另开一条“安全教程”
```

## Hard Gates
- Human Relevance: PASS
- Mechanism Integrity: PASS
- Storyability: PASS
- One Mechanism: PASS
- Non-Trivial Payoff: PASS
