# 03 — Agent StoryPremise

## Status
`STORY_GATE = PASS_CANDIDATE_AGENT`

## Story Without Jargon

老板店里每天都有一堆退款邮件。

他招了两个助理，让他们都做同一件事：

> “今天这些退款，你们帮我处理掉。”

第一个助理看了半天，很认真地给老板写了一份《退款处理指南》：

第一步查订单。
第二步看规则。
第三步决定能不能退。
第四步通知客户。

老板说：

> “谢谢，我就是因为不想自己做这四步才找你的。”

第二个助理没写攻略。

他先去查订单，再看退款规则，符合条件的直接处理，然后发邮件通知客户。

老板本来很开心。

直到他碰到一个金额特别大的订单。

第二个助理停了下来：

> “这个超出我能自己决定的范围，你来确认。”

老板这时候才发现：

第一个助理是在**教自己工作**。

第二个助理是在**替自己推进工作**。

区别不是谁更会说。

而是谁拿到了“接下来该做什么”的控制权。

## McKee-style Structure

### Protagonist
每天被重复退款流程占用时间的老板。

### Desire
把“处理退款”这个完整目标交出去，而不是继续亲自执行每一步。

### Inciting Incident
老板把同一句“帮我把退款处理掉”同时交给两个 AI 助理。

### First Action
助理 A 生成完整操作步骤，老板以为任务会被解决。

### Gap
老板发现自己仍然必须亲手按步骤做完所有事情。

### Progressive Complications
助理 B 开始查订单、看政策、调用退款动作、通知客户；任务真的向前推进。

### Turning Point
一个高金额退款出现，助理 B 停下来要求老板确认。

### Recognition / Rule
“Agent”不是无限自主，而是模型在明确边界内接管 workflow execution：决定下一步、选工具、判断何时完成或交还控制权。

### Choice / Payoff
老板以后不再问“你能不能告诉我怎么处理”，而是明确哪些 workflow 可以被委托，以及哪些节点必须回到自己。

## Mechanism Mapping

- 助理 A = non-agentic LLM application / chatbot
- 助理 B = Agent
- 查订单 / 退款 / 发邮件 = tools
- 决定下一步 = LLM-controlled workflow execution
- 大额退款停止 = guardrail / human handoff boundary

## No-name Test

删掉 Agent、LLM、tool 等术语，故事仍成立：
> 一个助理只告诉老板该怎么干，另一个真正接过任务推进；遇到越权事项再交回老板。

结果：`PASS`

## Accuracy Boundary

本故事不暗示 Agent 必须全自动，也不把工具调用本身当成完整定义。核心是：
> 模型控制工作流推进，并通过工具代表用户行动。
