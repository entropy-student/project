# 01 — Context / Memory Signal & TopicOpportunity

## Status
`TOPIC_GATE = PASS`

## TopicOpportunity

```yaml
topic_id: context-vs-memory
signal: 长任务与长期个性化越来越普遍，但用户仍经常把 context window、conversation state、compaction 和 long-term memory 混成“AI记忆”
why_now: Agent 长时间工作与 ChatGPT 改进版 Memory 都在 2026 年继续发展，“AI为什么刚才记得、过几天却忘了”已成为普通用户可感知问题
human_problem: 为什么 AI 刚才明明记得我说过的话，换个时间或任务又像第一次认识我
human_stakes: 用户会错误判断 AI 到底知道什么、会保留什么，从而重复解释、错误依赖或误把短期上下文当长期记忆
ai_mechanism: Context window 是单次推理可用的有限工作集；长期 memory 是独立的持久化/提炼/检索层，需要在以后重新提供相关信息
one_mechanism_only: true
curiosity_gap: 一个助理为什么能记住桌上刚放的几十张纸，却不一定记得你上个月说过的偏好
story_seed: 秘书有一张有限大小的办公桌和一本长期笔记本；桌上的材料决定他“现在能看到什么”，笔记本决定他“以后还能重新拿回什么”
audience_payoff: 建立“工作台 ≠ 长期记忆”的 mental model，理解长上下文、压缩和跨会话 memory 为什么是不同层
search_anchor: AI context window / AI memory / ChatGPT memory
primary_content_job: TRUST
secondary_content_job: DISCOVERY
conversion_adjacency: HIGH
conversion_path_hypothesis: Context management / personal AI memory / knowledge base / agent workspace / long-running workflow tools
visual_storyability:
  status: PASS
  reason: 办公桌、纸张堆积、旧纸被收走、关键事项写进笔记本、下次重新翻出，都是高度直观的画面动作
novelty_vs_history:
  status: NEW
  reason: G2 第三类验证题，重点是用户已有直觉但概念容易混淆
repetition_risk:
  level: LOW
  repeated_elements: []
uncertainties:
  - 不把具体 ChatGPT Memory 产品实现等同于所有 LLM 系统
  - 不说“超出 context 就一定永久忘记”，因为系统可以压缩、检索或重新注入信息
  - 不把模型权重知识与用户 memory 混为一谈
```

## Hard Gates
- Human Relevance: PASS
- Mechanism Integrity: PASS
- Storyability: PASS
- One Mechanism: PASS
- Non-Trivial Payoff: PASS
