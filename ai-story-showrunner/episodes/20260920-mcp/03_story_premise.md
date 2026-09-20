# 03 — MCP StoryPremise

## Status

`STORY_GATE = PASS_CANDIDATE_MCP`

## Story Without Jargon

一个小老板终于招到一个传说中什么都会的万能秘书。

第一天，他让秘书去查库存。秘书走到仓库门口，看不懂仓库的登记系统，只能回来问老板。

第二天，他让秘书去订差旅。秘书又发现差旅部门有完全不同的一套表格和操作规则。

第三天换成财务、物流、客服，结果每开一扇新门，老板都要重新教秘书“这个部门到底怎么说话、有哪些按钮、数据在哪”。秘书越来越聪明，老板却越来越忙。

老板终于发现，问题不是秘书不会干活，而是公司里的每个部门都要求一套不同的接头方式。

于是他没有继续培训秘书，而是让每个部门在门口设一个统一规格的“服务窗口”：窗口会告诉秘书这里能查什么、能做什么、需要什么参数。

以后公司再开一个新部门，只要这个部门也有这种标准窗口，秘书就不用从头学一门新方言。

## McKee-style Structure

### Protagonist
想靠 AI 秘书减少自己在各种系统之间来回操作的小老板。

### Desire
只告诉秘书目标，让它自己去各部门把事情办完。

### Inciting Incident
秘书第一次被派去查库存，却停在仓库系统门口。

### First Action
老板手把手给秘书做一套仓库专用连接方法。

### Gap
库存问题解决后，差旅系统又完全不同；之前的连接经验无法直接复用。

### Progressive Complications
财务、物流、客服相继出现，每增加一个系统，就新增一套专用接线和维护成本。

### Turning Point
老板意识到真正的瓶颈不是秘书能力，而是每个外部系统都没有用统一方式告诉秘书“我有什么、我能做什么、怎么调用”。

### Recognition / Rule
不要继续给秘书写 N 套专用翻译；让每个部门通过统一协议暴露能力。

### Choice / Payoff
公司改为标准服务窗口。以后新增系统时，只需增加一个符合标准的窗口，秘书的应用侧就能用相同协议发现并调用它。

## Mechanism Mapping

- 万能秘书应用 = MCP host / client side mental model
- 部门标准服务窗口 = MCP server
- 窗口公布“能做什么” = tools capability / discovery
- 窗口公布“有哪些资料” = resources
- 统一办事语言 = MCP protocol

## Important Accuracy Boundary

故事中不说“有了标准窗口就自动拥有所有门的权限”。授权、用户同意、真实系统权限仍单独存在。

## Term Reveal Strategy

先让观众完整经历“聪明秘书 + 每个系统不同接法”的摩擦；在 Turning Point 之后再揭示：这种给 AI 应用和外部工具建立标准连接方式的协议，就是 MCP。

## G2 Notes

该 StoryPremise 通过 No-name Test：删掉 MCP 一词，故事仍然成立；AI mechanism 仍然真实驱动剧情。

下一步不是写成稿，而是拿 Agent / Context-Memory 两个不同机制题复跑同一 Contract，确认不是只对 MCP 有效。