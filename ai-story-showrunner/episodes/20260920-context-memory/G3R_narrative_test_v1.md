# G3R Context / Memory Narrative Smoke Test v1

## Status
G3R_MEMORY_NARRATIVE_TEST = PASS_CANDIDATE / OWNER REVIEW

## Editorial Mode
STORY_MODEL

## Controlling Question

> AI“现在看得见很多东西”，和“以后还记得重要的东西”，到底是不是一回事？

## Idea / Counter-Idea

IDEA:
> 上下文越大，AI眼前能放的材料越多，长任务越容易连续推进。

COUNTER-IDEA:
> 但当前工作区再大，也不等于跨任务、跨时间的长期记忆。

## Selected Viewpoint

> 真正像“记忆”的，不是把所有东西永远摊在眼前，而是在以后需要的时候，还能把真正重要的东西带回来。

## Title

**我给AI换了张越来越大的桌子，它怎么还是会忘？**

## Spoken Script

我一直有个特别朴素的愿望。

既然 AI 都这么聪明了，那我以后最好一句话都别说第二遍。

我讨厌重复交代东西。

“这个项目不要 PPT 风。”

“先说结论。”

“这个角色别画成人类客服。”

这种话第一次说叫需求。

说到第五次，我就开始怀疑到底谁是谁的助理。

所以在我的脑子里，AI 最理想的状态应该是：

我说过。

它记住。

结束。

为了解决这个问题，我给我的 AI 搭档安排了一张特别大的桌子。

今天的任务、昨天的讨论、十几份资料、改过三版的要求，全往上放。

刚开始效果特别好。

我随手问一句：

“刚才那个价格是多少？”

它知道。

“第三份文档里我删了什么？”

它也知道。

我看着那张桌子，心里只有一个念头：

还能加。

于是桌子越换越大。

资料越堆越多。

到后来它那个工位已经不像办公桌了，像我把整个文件夹直接摊平以后，强行铺了层桌布。

终于有一天，桌面塞满了。

新的文件还在往里进。

AI 搭档只能开始收东西。

这几页今天用不上，先拿走。

前面的讨论太长，压成一张摘要。

几个重复要求，合到一起。

我一看就急了。

“哎，这个别收啊，我前面说过的。”

它看了我一眼。

“你是说哪一个？”

我沉默了一下。

因为我自己也想了两秒。

问题是，这句话它确实看过。

甚至一个小时前还在桌上。

可现在为了继续干活，那堆纸已经被收走、压缩、换成了别的东西。

我第一反应非常直接：

桌子还是不够大。

于是我又给它扩。

如果一张桌子解决不了，那就两张。

两张不够，就把会议桌也搬过来。

只要桌面够大，总有一天可以把我这辈子说过的话全摊上去。

听起来非常合理。

直到第二周，我开了一个新任务。

桌面干干净净。

我问它：

“还是按我喜欢的方式来。”

它回我：

“你喜欢什么方式？”

我盯着那个空桌子。

这下有点尴尬了。

我上周辛辛苦苦扩建的超级办公桌，确实能让我一次摊更多东西。

但它解决的是：

**现在能摆多少。**

不是：

**下个月还记得什么。**

这俩东西长得特别像。

尤其当 AI 刚刚还能接着你上句话往下说的时候，你很容易觉得：

“它记住我了。”

其实很多时候，它只是桌面上还放着那张纸。

后来我没继续给它买桌子。

我在旁边放了一本小笔记。

里面也不是什么都记。

只记那些我不想反复交代、而且过几周还有用的东西。

比如：

“视频先讲故事，不要一上来讲概念。”

“不要 PPT 风。”

“结论能短就别绕三页。”

新任务再开始的时候，桌面还是新的。

但它会先翻一下那本笔记。

“哦，对，你不喜欢 PPT 风。”

这一下我才觉得它是真的“认识我一点”。

也是到这里，我才分清两个很容易被混在一起的东西。

Context 更像现在这张工作台。

你这一刻要处理的资料、刚刚说过的话、当前任务的状态，都得先放到这里，它才能直接用。

桌面满了以后，系统可能要整理、压缩，或者把一部分东西移出去，给新的信息腾位置。

但长期 Memory 更像桌子外面的笔记和档案。

它不是把所有历史聊天永远铺在桌面上。

而是让一些值得长期留下的信息，在以后需要的时候，还能重新回到桌面。

所以现在再看到“上下文更长”，我不会自动把它翻译成“它记性更好了”。

桌子大，当然有用。

但桌子再大，

也还是桌子。

真正让我少说第二遍的，

是它知道什么东西值得留下。

以及下一次，

还知道去哪里把它找回来。

## Timing

- target duration: ~3–4 min after natural delivery and pauses
- no final TTS alignment yet

## Knowledge Boundary

Keeps the locked model:
- context window = finite current working set;
- compaction / summarization may manage long contexts;
- persistent memory is separate from current context;
- relevant memory must be retrieved / reintroduced for later use.

Does NOT imply:
- context overflow means permanent deletion;
- all products implement memory identically;
- every historical utterance is stored;
- long-term memory is equivalent to model training knowledge.
