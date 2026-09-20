# 04 — Agent Locked Spoken Script

## Status
`SCRIPT_GATE = PASS_CANDIDATE`

## Primary Content Job
`DISCOVERY`

## Selected Title
**你是在问AI，还是已经把工作交给AI？**

## Alternative Titles
- 两个AI助理，一个教我退款，一个已经退完了
- 为什么“会用工具”还不一定算Agent？

## Hook
老板店里每天都有一堆退款邮件。

## Locked Spoken Script

老板店里每天都有一堆退款邮件。
有一天，他招了两个 AI 助理，把同一句话发给他们：“今天这些退款，你们帮我处理掉。”
第一个助理非常认真。
十秒钟后，它交了一份《退款处理指南》：第一步查订单，第二步看规则，第三步决定能不能退，第四步通知客户。
老板看完沉默了两秒：“谢谢。我就是因为不想自己做这四步才找你的。”
第二个助理没写攻略。
它先查订单，再看退款规则，符合条件的直接退款，然后发邮件通知客户。
老板正准备感动，突然跳出来一笔特别大的订单。
第二个助理停了：“这笔超出我的确认范围，你来决定。”
老板这才反应过来。
第一个助理是在告诉他下一步该干什么。
第二个助理是在替他决定下一步，并且真的把工作往前推。
这就是 Agent 最关键的差别。
不是“聊天更聪明”，也不只是“会用几个工具”，而是模型开始控制一段工作流：看现在做到哪了，决定下一步，用工具执行，直到完成，或者在该停的地方把控制权还给你。
所以以后真正要问的，不只是“AI 能不能做”，而是“这件事做到哪一步，我还愿意让它自己决定？”

## Timing
- planning speaking rate: 5.0 spoken chars/s
- estimated spoken chars: 374
- estimated duration: ~75s
- actual TTS/voice timing will override this estimate

## Term Reveal
先让观众看懂两个助理的行为差异，再在后半段正式揭示 `Agent`。

## Claim Map
- 助理A给步骤 → non-agentic assistant
- 助理B自己查订单/执行/通知 → workflow execution + tools
- 大额订单停下 → guardrail / human handoff
- “模型开始控制一段工作流” → locked KnowledgeCore
