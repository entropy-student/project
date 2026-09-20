# 02 — Agent KnowledgeCore

## Status
`KNOWLEDGE_GATE = PASS`

## One Locked Mechanism

> Agent 是由 LLM 控制工作流执行的系统：它不仅生成建议，还会根据当前任务状态决定下一步、选择工具并在约束内代表用户推进多步任务。

## Key Claims

1. 普通 LLM 应用如果只是回答、分类或生成文本，但不控制 workflow execution，不应因为“用了大模型”就称为 Agent。
2. Agent 的核心组件通常包括模型、工具和明确 instructions / guardrails。
3. Agent 会根据任务状态动态决定下一步，并判断任务是否完成、是否需要纠错或把控制权交回用户。
4. 工具让 Agent 能读取外部信息或执行真实动作。
5. Guardrails / human-in-the-loop 是可靠执行的重要边界，但本期不把它扩展成独立安全主题。

## Misconceptions to Block

- Agent ≠ 更聪明的聊天机器人。
- Agent ≠ 只要会 function calling 就自动是 Agent。
- Agent ≠ 必须完全无人监督。
- Agent ≠ 多 Agent 才算 Agent。

## Ordinary-Person Mental Model

聊天助手：
> “你应该这样处理退款。”

Agent：
> “我先查订单 → 对照规则 → 调用退款工具 → 发通知 → 确认完成；遇到超出授权范围的情况再停下来找你。”

## Source Refs

- OpenAI practical guide to building agents:
  https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/
- OpenAI workspace agents:
  https://openai.com/academy/workspace-agents/
- OpenAI Agents API:
  https://openai.com/index/introducing-the-agents-api/

## Scope Boundary

本期不展开：
- multi-agent architecture；
- tracing / evals；
- Agents SDK / API 教程；
- MCP；
- memory；
- autonomous agents 的未来预测。
