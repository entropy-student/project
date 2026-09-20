# 02 — MCP KnowledgeCore

## Status

`KNOWLEDGE_GATE = PASS`

## One Locked Mechanism

> MCP 是一套开放的 client/server 协议，使 AI 应用能够用标准化方式发现并使用 MCP server 暴露的工具、资源与提示能力。

## Key Claims

1. MCP 是开放协议，不是某一个模型或厂商专属功能。
2. MCP 官方架构包含 Host、Client、Server；Host 负责更复杂的编排，Client 与 Server 通过 MCP 通信。
3. Server 可以暴露 Tools、Resources、Prompts 等能力。
4. Tools 是模型可调用的函数能力，可用于访问 API、数据库、计算等外部系统。
5. Resources 为应用/模型提供可读取的上下文数据或内容。
6. MCP 的核心价值是标准化互操作方式；它不会自动替代底层系统已有的 API、业务规则、认证和授权。
7. Tool 的用户确认/人机控制属于应用与安全设计的一部分，不能把 MCP 本身等同为“权限系统”。

## Misconceptions to Block

### Wrong: MCP = 权限系统

MCP 规范包含授权相关机制，但“谁有权做什么、是否需要用户确认”不能被压缩成 MCP 的唯一或核心定义。

### Wrong: MCP = 一个万能 API，底层 API 都不需要了

MCP Server 仍可能封装真实 API、数据库或其他服务。标准化的是 AI 应用与 MCP Server 之间的协议层。

### Wrong: MCP = 有了它模型就更聪明

MCP 改善的是外部能力接入与互操作，不直接提高模型本身的推理能力。

### Wrong: MCP = 每个工具都变成一样的功能

不同 Server 仍暴露不同工具与 schema。统一的是发现、描述、调用这些能力的协议方式，而不是把业务语义抹平。

## Ordinary-Person Mental Model

以前：
- AI 想去库存系统办事，要学一套接法；
- 想去财务系统，又是一套；
- 再换一个应用，又重新做一次。

MCP mental model：
- 各系统通过 MCP Server 用同一种“对外办事协议”描述自己有哪些资料、有哪些工具、这些工具需要什么参数；
- AI 应用侧通过 MCP Client 用相同协议去发现和使用这些能力。

## Source Refs

- Specification 2026-07-28: https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/index.mdx
- Server primitives: https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/server/index.mdx
- Tools: https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/server/tools.mdx
- Architecture: https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/docs/specification/2026-07-28/architecture/index.mdx
- 2026-07-28 release: https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/blog/content/posts/2026-07-28-spec-ga/index.md

## Scope Boundary

本 episode 不展开：
- JSON-RPC / transport 细节；
- 2026-07-28 stateless core；
- authorization 规范细节；
- sampling / elicitation / extensions；
- SDK / Server 开发教程；
- MCP Apps / Skills over MCP。

这些内容全部留给其他 episode，确保本期 one mechanism only。
