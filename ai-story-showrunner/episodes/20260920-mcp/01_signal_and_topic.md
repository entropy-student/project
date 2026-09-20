# 01 — MCP Signal & TopicOpportunity

## Status

`TOPIC_GATE = PASS`

## Signal

MCP 当前官方规范为 `2026-07-28`。官方将 MCP 定义为连接 LLM 应用与外部数据源、工具和能力的开放协议，并继续把它作为 agentic workflows 的数据与交互基础设施演进。

Official refs:
- https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/index.mdx
- https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/server/index.mdx
- https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/server/tools.mdx
- https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/blog/content/posts/2026-07-28-spec-ga/index.md

## TopicOpportunity

```yaml
topic_id: mcp-standardized-connection
signal: AI 正从只回答问题走向调用外部数据和工具；MCP 继续演进为面向 agentic workflows 的标准协议
why_now: AI 应用连接的真实系统越来越多，逐个做专用接线的成本与碎片化更容易被用户和开发者感知
human_problem: 我已经有一个很聪明的 AI 助手，为什么每让它进入一个新软件或新系统，都像重新教一个新人
human_stakes: 系统越多，用户和开发者花在接线、复制粘贴和维护集成上的时间越多；AI 的推理能力并不会自动变成跨系统行动能力
ai_mechanism: MCP 让 host/client 通过统一协议发现并使用 MCP server 暴露的 tools/resources/prompts
one_mechanism_only: true
curiosity_gap: 为什么一个什么都懂的万能秘书，到了公司每一扇门前都突然不会办事
story_seed: 老板给万能秘书一个跨部门任务，却发现每个部门都有自己的“方言”和办事窗口；老板一开始逐个培训，最终发现应该标准化部门对外暴露能力的方式
audience_payoff: 理解 MCP 解决的是 AI 应用与外部能力之间的标准化互操作，而不是让模型突然变聪明，也不是自动授予权限
search_anchor: MCP / Model Context Protocol
primary_content_job: DISCOVERY
secondary_content_job: TRUST
conversion_adjacency: HIGH
conversion_path_hypothesis: Agent / AI workflow / tool integration / automation 类工具与教程
visual_storyability:
  status: PASS
  reason: 可以连续表现秘书跨部门办事、反复碰壁、老板加班手把手接线、统一窗口出现、后续新部门快速接入
novelty_vs_history:
  status: NEW
  reason: 本项目首个正式 G2 验证样本
repetition_risk:
  level: LOW
  repeated_elements: []
uncertainties:
  - 不把 MCP 简化成权限系统
  - 不暗示 MCP 消除了底层 API、业务逻辑或授权
  - 不把 MCP 讲成“所有工具语义都统一”，标准化的是协议与交互方式
```

## Hard Gates

- Human Relevance: PASS
- Mechanism Integrity: PASS
- Storyability: PASS
- One Mechanism: PASS
- Non-Trivial Payoff: PASS

## Why DISCOVERY

“MCP”本身是高门槛术语，本期首先要让完全不知道 MCP 的观众通过一个具体冲突理解“为什么 AI 需要标准化连接层”。术语负责搜索与认知锚点，不负责开场。
