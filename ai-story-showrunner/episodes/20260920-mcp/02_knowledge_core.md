# 02 — MCP KnowledgeCore

## Status

`KNOWLEDGE_GATE = PASS`

## One Mechanism

> MCP 为 AI 应用与外部能力提供一套标准化 client/server 协议，使客户端能够发现并使用服务器暴露的工具、资源和提示能力。

## Key Claims

1. MCP 是开放协议/标准化连接方式，不是某一个模型专属功能。
2. MCP 采用 host / client / server 架构；server 可暴露 tools、resources、prompts 等能力。
3. Tools 可让模型通过 MCP 调用外部系统动作或查询，例如 API、数据库或计算。
4. Resources 用于向客户端暴露可作为上下文的数据/content。
5. MCP 解决的是**标准化互操作接口**；它不会自动替代每个底层系统自己的 API、业务逻辑或身份授权。

## Misconceptions to Block

### Wrong: MCP = AI 的权限系统

权限、用户同意、授权由 host/application 与具体实现负责；MCP 本身不能被简化成“权限开关”。

### Wrong: MCP = 一个万能 API，把所有软件 API 都消灭

MCP server 往往仍需与真实数据库/API/应用交互。标准化发生在 MCP client ↔ MCP server 这一层。

### Wrong: 有 MCP，模型就变聪明了

MCP 改善的是外部能力接入与互操作，不改变模型本身的推理能力。

## Ordinary-Person Mental Model

以前：每接一个新系统，都要给 AI 应用单独做一次“翻译/接线”。

现在的 mental model：不同系统可以通过 MCP server 用同一种协议向 AI 应用说明“我有哪些资源、我能做哪些动作”。

## Source Refs

- MCP Introduction: https://github.com/modelcontextprotocol/docs/blob/main/introduction.mdx
- MCP 2026-07-28 Tools: https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/server/tools.mdx
- MCP Server Primitives: https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/server/index.mdx
- MCP 2026-07-28 release: https://blog.modelcontextprotocol.io/posts/2026-07-28/

## Scope Boundary

本 episode 不展开：
- transport 细节；
- 2026 spec stateless core 的实现细节；
- authorization specification；
- sampling / elicitation / extensions；
- SDK 比较；
- server 开发教程。

这些都留给其他 episode，确保 one mechanism only。