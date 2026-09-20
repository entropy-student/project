# G2 Validation Review — Topic → Human Problem → Story MVP

## Reviewer Decision

`G2 = PASS`

Date: 2026-09-20

G2 只验证上游内容模型，不验证 Writer、SRT、图片或视频执行。

## Validation Set

| Episode | Concept Type | Primary Job | Conversion Adjacency | Topic Gate | Knowledge Gate | Story Gate |
|---|---|---|---|---|---|---|
| MCP | abstract protocol / interoperability | DISCOVERY | MEDIUM | PASS | PASS | PASS |
| Agent | delegated action / workflow control | DISCOVERY | HIGH | PASS | PASS | PASS |
| Context / Memory | user intuition / cognitive model | TRUST | HIGH | PASS | PASS | PASS |

## 1. MCP

### Human translation
“为什么一个什么都懂的 AI，到了每个软件门口都像第一次来？”

### Locked mechanism
MCP 标准化 AI application client 与 MCP server 之间发现/使用 tools、resources、prompts 的协议交互。

### Story
老板招了万能秘书，本来想省时间，却因为每个部门都有不同办事方式一直培训到深夜；最后把各部门对外能力改成统一规格的服务窗口。

### PASS reason
- No-name Test 成立；
- 协议机制真正造成故事冲突；
- 不依赖观众预先知道 MCP；
- 能明确阻止“权限系统 / 万能 API / 模型变聪明”等误解。

### Open concern
与 Agent 样本都使用老板/助理关系。作为 G2 验证允许；进入真实发布前必须做 Visual / Story Repetition 检查。

---

## 2. Agent

### Human translation
“我是在问 AI 怎么做，还是已经把事情交给 AI 做？”

### Locked mechanism
Agent 由 LLM 控制 workflow execution，根据状态决定下一步、选择工具并在 guardrails 内代表用户推进多步任务。

### Story
两个助理收到相同退款任务：一个给老板写操作指南，一个真的查订单、执行退款、通知客户，并在高金额订单处把控制权交回老板。

### PASS reason
- “回答 vs 代执行”是普通人无需术语也能理解的冲突；
- 工具调用不是孤立功能，而是 workflow execution 的组成部分；
- guardrail 只作为执行边界，没有抢走本期核心机制；
- 故事结局自然导向“哪些任务可以委托、哪里必须交回控制权”。

### Open concern
G3 写稿时不能把故事后半段变成“Agent 三要素：模型+工具+指令”的课程总结。

---

## 3. Context / Memory

### Human translation
“为什么 AI 刚才记得，过一阵又像忘了？”

### Locked mechanism
Context window 是当前推理的有限工作区；长期 Memory 是窗口之外的持久化/提炼/检索层，需要在未来重新把相关信息带回工作区。

### Story
秘书有一张很大的办公桌：桌上的材料他都看得到，但桌面始终有限；老板后来给他一本长期笔记本，才真正解决跨项目、跨时间保留重要信息的问题。

### PASS reason
- 用户已有强烈现实直觉；
- “桌面 vs 笔记本”区分两个层次非常稳定；
- 能自然解释 compaction，而无需进入向量数据库/RAG；
- No-name Test 成立。

### Open concern
必须持续强调这是 mental model，不暗示所有产品使用完全相同的 Memory 实现。

---

## 4. Cross-Topic Findings

### Finding A — L3 → L2 → L1 works

三种完全不同的技术题都能先转为人类处境，再回到技术机制：

```text
MCP:
每个系统都要重新接线
→ interoperability problem
→ MCP

Agent:
我还得亲手做每一步
→ delegated workflow execution
→ Agent

Memory:
刚才记得，过段时间忘了
→ working context vs persistence
→ Context / Memory
```

因此 Audience Middle Layer 在 G2 获得首轮证据支持。

### Finding B — One Mechanism Gate is necessary

三个题都存在“顺手多讲一点”的诱惑：

- MCP → permissions / auth / transport / Apps；
- Agent → tools / memory / multi-agent / guardrails；
- Memory → RAG / embeddings / model context limits。

强制 one mechanism 后，故事因果明显更干净。

### Finding C — Story-first is feasible, but metaphor reuse is a real risk

MCP 与 Agent 很容易都落到“助理”隐喻。这证明固定演员可以降低理解成本，也同时证明 Visual Repetition Gate 必须保留。

结论：
- 可复用角色；
- 不可机械复用冲突结构；
- Content Ledger 必须记录 story motif，不只记录 topic。

### Finding D — Conversion adjacency must be audience-relative

技术热门不等于商业邻近度高。

- MCP：普通用户为 MEDIUM；builder audience 可更高。
- Agent：HIGH，因为自然靠近自动化/委托/审批工作流。
- Memory：HIGH，因为自然靠近个人 AI、知识管理、长期工作流。

因此未来 Topic Worker 必须按目标 audience 判断 conversion adjacency，而不是按技术热度判断。

### Finding E — The three content jobs are useful

- MCP / Agent 更适合作为 DISCOVERY：先让陌生人理解一个变化。
- Context / Memory 更适合作为 TRUST：观众已有体验，内容价值在于把模糊直觉解释准确。

SOLUTION 不应为了商业目的强行占比例；需要真实需求与产品承接后再使用。

## 5. G2 Acceptance Criteria

- [x] 三个题目都有 valid TopicOpportunity
- [x] 三个题目都有 one locked KnowledgeCore
- [x] 三个 StoryPremise 删除术语后仍成立
- [x] Human Relevance / Mechanism / Storyability / One Mechanism / Non-Trivial Payoff 均通过
- [x] primary_content_job 与 conversion_adjacency 已记录
- [x] 关键技术事实经过最新官方来源核验
- [x] 已记录跨题型失败风险与下一 Gate 的约束

## 6. Reviewer Result

```text
PASS_G2_TOPIC_TO_HUMAN_PROBLEM_TO_STORY_MVP
NEXT_GATE = G3 Story → Script / SRT MVP
```

G3 的核心问题不是继续证明故事结构，而是：

> 在不破坏 locked KnowledgeCore / StoryPremise 的情况下，Jingsui Writer Adapter 能不能把它写成真正好看的口播故事，而不是重新变回 AI 科普稿。
