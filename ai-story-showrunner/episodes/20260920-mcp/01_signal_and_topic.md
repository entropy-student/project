# DRAFT — 01 — MCP Signal & TopicOpportunity

## Status

`TOPIC_GATE = DRAFT_HOLD_NOT_ACCEPTED`

## Signal

MCP 已从早期集成概念继续演进为面向 agentic workflows 的开放协议。官方 2026-07-28 规范继续扩展协议核心；MCP 官方文档仍将其描述为连接 AI 应用与外部数据源/工具的标准化方式。

Official refs:
- https://blog.modelcontextprotocol.io/posts/2026-07-28/
- https://modelcontextprotocol.io/
- https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/server/tools.mdx

## TopicOpportunity

```yaml
topic_id: mcp-standard-connection
signal: AI 正从只回答问题继续走向调用外部工具和数据；MCP 协议仍在快速演进
why_now: 当 AI 要连接越来越多真实应用时，一对一自定义集成会成为摩擦；MCP 的标准化价值更容易被普通用户实际感知
human_problem: 我以为有了一个聪明的 AI 助手，就应该能替我在不同软件里办事，为什么每接一个系统还要重新折腾一次
human_stakes: 工具越多，连接成本越高；用户仍然在应用之间复制粘贴，AI 的聪明无法自然变成行动能力
ai_mechanism: AI host/client 与 MCP server 使用标准协议发现并访问 server 暴露的 tools/resources/prompts
one_mechanism_only: true
curiosity_gap: 为什么一个明明会思考的万能助手，走到每一个部门门口却都像第一次来
story_seed: 老板招了万能秘书，但公司每个部门都有完全不同的窗口和办事规则；每新增一个部门都要重新给秘书培训一套接口，直到所有部门都设立同一种标准服务窗口
audience_payoff: 理解 MCP 真正解决的是 AI 应用与外部能力之间的标准化连接问题，而不是让模型突然变聪明
search_anchor: MCP / Model Context Protocol
primary_content_job: DISCOVERY
secondary_content_job: TRUST
conversion_adjacency: HIGH
conversion_path_hypothesis: Agent / AI workflow / tool integration / automation 类工具与教程
visual_storyability:
  status: PASS
  reason: 可以连续表现秘书在多个部门碰壁、重复培训、标准窗口出现、快速接入新部门
novelty_vs_history:
  status: NEW
  reason: 本项目首个正式验证 episode
repetition_risk:
  level: LOW
  repeated_elements: []
uncertainties:
  - 不把 MCP 简化成权限系统
  - 不暗示 MCP 消除了底层服务 API 或授权要求
```

## Hard Gates

- Human Relevance: PASS
- Mechanism Integrity: PASS
- Storyability: PASS
- One Mechanism: PASS
- Non-Trivial Payoff: PASS

## Why DISCOVERY

技术词 MCP 的自然认知门槛高，因此本期主任务不是深讲规范细节，而是先让陌生观众通过一个日常冲突理解“为什么需要标准连接层”。