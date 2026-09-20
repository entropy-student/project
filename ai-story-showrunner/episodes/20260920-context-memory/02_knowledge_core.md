# 02 — Context / Memory KnowledgeCore

## Status
`KNOWLEDGE_GATE = PASS`

## One Locked Mechanism

> Context window 是模型一次推理能够直接使用的有限工作区；长期 Memory 是在当前窗口之外保存、提炼或检索信息，并在以后需要时重新把相关内容带回工作区的机制。

## Key Claims

1. Context window 是一次模型请求可使用的最大 token 工作范围，通常包含输入、输出，推理模型还需要考虑 reasoning tokens。
2. 对话越来越长时，系统必须管理上下文；可以删除低价值内容、总结或 compaction，以便继续工作。
3. 长期运行的 Agent 可以跨多个 context window，通过 context management / compaction 保留关键状态。
4. ChatGPT Memory 属于跨会话的持久化个性化层，帮助未来对话从共享上下文开始，而不是把所有历史聊天原样永久塞进当前 context window。
5. Memory 不等于“记住所有东西”；系统会选择、综合和更新有用信息。

## Misconceptions to Block

- Context window 大 ≠ 永久记忆强。
- 超出 context ≠ 信息一定永久消失；外部状态、压缩、检索可以重新带回。
- Memory ≠ 所有历史聊天逐字常驻。
- 模型训练知识 ≠ 用户 Memory。

## Ordinary-Person Mental Model

- Context window = 你现在摊在办公桌上的文件。
- Compaction = 桌子快满时，把旧材料浓缩成一份摘要。
- Long-term memory = 桌子旁的长期笔记/档案，需要时再拿回桌面。

## Source Refs

- OpenAI conversation state / context window:
  https://developers.openai.com/zh-Hans/api/docs/guides/conversation-state
- OpenAI Agents API context management:
  https://openai.com/index/introducing-the-agents-api/
- OpenAI Dreaming / improved Memory:
  https://openai.com/index/chatgpt-memory-dreaming/
- OpenAI Memory FAQ:
  https://help.openai.com/zh-hans-cn/articles/8590148-memory-faq

## Scope Boundary

本期不展开：
- 各模型具体 token 数；
- embedding / vector database 教程；
- ChatGPT Memory 设置教学；
- RAG；
- 模型训练与 fine-tuning；
- context rot benchmark。
