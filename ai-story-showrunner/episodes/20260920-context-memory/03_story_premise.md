# 03 — Context / Memory StoryPremise

## Status
`STORY_GATE = PASS_CANDIDATE_MEMORY`

## Story Without Jargon

老板给秘书配了一张特别大的办公桌。

每天开始工作时，老板会把今天要处理的文件全摊在桌面上。

客户资料、订单、会议记录、老板刚交代的话——只要还在桌上，秘书都记得清清楚楚。

老板非常满意：

> “这人记性真好。”

但项目越来越大，桌上的纸也越来越多。

终于有一天，桌面塞不下了。

秘书只能把一部分旧纸收走，把重要内容浓缩成几张摘要，留下今天真正需要的东西。

老板开始抱怨：

> “你不是都看过吗？怎么现在又不知道了？”

秘书说：

> “我不是没看过，是那些东西现在已经不在我的桌面上。”

老板想了想，又给秘书配了一本长期笔记本。

“以后我的习惯、项目规则、重要约定，别只放桌上。挑真正值得长期留的，记进这里。”

几周后，老板开始了一个新项目。

桌上没有上个月的旧聊天。

秘书却翻开笔记本：

> “你上次说过，这类报告你不要 PPT 风，要先给结论。”

老板这才明白：

能放在桌上的东西有多少，和一个人能不能跨几个月记住重要事情，是两件完全不同的事。

## McKee-style Structure

### Protagonist
把 AI 当长期助手使用、但一直分不清“当前上下文”和“长期记忆”的老板。

### Desire
希望助手既能理解当前复杂任务，又能长期记住自己的偏好和项目规则。

### Inciting Incident
老板发现秘书在一个长项目里开始“忘掉”早期信息。

### First Action
老板不断往当前桌面塞更多历史材料，以为只要桌子够大就能解决所有记忆问题。

### Gap
桌面再大仍然是有限工作区；材料增加后必须取舍、压缩或重新组织。

### Progressive Complications
旧材料被收走 → 老板误以为“看过就应该永远记得” → 新任务开始时旧桌面并不会自动完整复原。

### Turning Point
老板意识到“现在能看到什么”和“以后还能找回什么”不是同一个系统问题。

### Recognition / Rule
Context 是当前工作台；长期 Memory 是在工作台之外保存和选择重要信息，并在需要时重新带回。

### Choice / Payoff
老板不再要求秘书把所有历史永久摊在桌面，而是把长期规则、偏好和关键事实写进可持续更新的笔记系统。

## Mechanism Mapping

- 办公桌 = context window
- 桌上当前文件 = active input/context
- 把旧文件浓缩成摘要 = compaction / summarization
- 长期笔记本 = persistent memory layer
- 下一次翻笔记本 = retrieval / re-injection of relevant memory

## No-name Test

删掉 context、memory、token、AI 等术语，故事仍成立：
> 一个秘书的办公桌只能放当前工作的材料；想跨很长时间记住重要东西，需要另一本长期笔记，并在需要时重新翻出来。

结果：`PASS`

## Accuracy Boundary

不表达：
- “Context 满了就永久失忆”；
- “Memory 会保存每一句话”；
- “所有 AI 产品都使用同一种 Memory 实现”。

只保留一个核心 mental model：
> 当前工作区与长期持久记忆是不同层。
