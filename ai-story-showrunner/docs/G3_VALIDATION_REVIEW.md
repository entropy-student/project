# G3 Validation Review — Story → Script / SRT MVP

## Reviewer Decision

`G3 = PASS`

Date: 2026-09-20

本 Gate 验证的是 Writer quality / contract，不代表 programmatic orchestration runtime 已经打通。

---

## 1. Writing System Used

G3 不单独迷信某一种写作理论，而采用四层组合：

1. **McKee Causality** — desire → action → expectation/result Gap → progressive complication → turning point → payoff；
2. **Narrative Transportation** — 具体人物、动作、场景、物件、情绪反应，让观众进入故事；
3. **Short-form Retention** — 第一拍进入事件、每个 beat 推进、承诺兑现、避免重复解释；
4. **Jingsui Voice** — 具体事件优先、观点后置、口语、梗母题、反演讲腔。

Canonical contract: `docs/WRITER_QUALITY_CONTRACT.md`

---

## 2. Project-specific Overrides Confirmed

景岁 native 规则不是全部照搬。

本项目正式覆盖：
- 不强制“大家好，我是……”；
- 不强制英文尾签；
- 不强制第一人称 narrator；固定演员宇宙允许第三人称故事 narrator；
- 不继承 150–240s 长稿默认；
- Writer 不拥有 Visual Beat / prompt / edit authority；
- 术语 reveal 由故事直觉形成后再出现；
- 一条视频仍只解释一个 locked mechanism。

---

## 3. Validation Episodes

| Episode | Selected title | Estimated duration | Term reveal | Script↔SRT | Result |
|---|---|---:|---|---|---|
| MCP | AI什么都会，为什么每进一个软件都像第一次来？ | ~74s | very late | exact | PASS |
| Agent | 你是在问AI，还是已经把工作交给AI？ | ~75s | late-middle | exact | PASS |
| Context / Memory | AI刚才还记得你，为什么转头就像忘了？ | ~78s | late | exact | PASS |

Planning speed: `5.0 spoken Chinese chars/s`。

真实 TTS/配音生成后，必须用真实音频覆盖估算时间。

---

## 4. MCP Review

### Why it passes
- 第一拍直接进入“下午五点招万能秘书”；
- 冲突不是概念解释，而是老板为了省事反而加班；
- complication 从库存扩展到差旅/财务/合同；
- turning point 来自老板意识到“每扇门都要重新教”；
- MCP 术语接近结尾才出现；
- 最后用“一扇新门 / 一门方言”回扣主梗。

### Main risk
MCP 天然容易写成接口教程。本稿目前通过，但 G4 导演不能把最后技术 reveal 做成大量信息卡。

---

## 5. Agent Review

### Why it passes
- 两个助理收到相同任务，天然形成行为对照；
- 第一位“写攻略”与第二位“推进任务”形成清晰 Gap；
- 大额退款让故事出现真正控制权边界，而不是只展示 Agent 很强；
- Agent 定义从行为中长出来，而不是先给“模型+工具+指令”三要素。

### Main risk
后续不得把最后 20 秒扩写成 Agent 架构课程。

---

## 6. Context / Memory Review

### Why it passes
- 办公桌是可视、可操作的 context mental model；
- 桌面塞满 → 摘要旧材料形成自然 complication；
- 长期笔记本解决的是另一类问题，因此 turning point 清楚；
- 术语只在故事已经自行解释清楚后出现。

### Main risk
“办公桌 / 笔记本”只是 mental model，不能在后续旁白或画面里暗示所有产品内部实现完全相同。

---

## 7. Cross-topic Findings

### A. 70–85s is a useful initial calibration range

三个故事在 ~74–78s 时均能保留：
- inciting incident；
- Gap；
- complication；
- turning point；
- technical reveal；
- payoff。

若强压到 45–60s，目前最可能被删掉的是 complication，故事会重新退化成比喻解释。

因此首轮生产暂采用 `70–85s`，真实 retention 数据出来后再改。

### B. “好文案”不是金句密度，而是状态推进密度

每个 beat 最重要的问题是：
> 事情有没有变化？

而不是：
> 这一句够不够漂亮？

### C. Explanation should arrive after intuition

三个样本都证明：先让观众看见行为差异，再命名技术概念，比从定义开始更符合本项目。

### D. Jingsui is useful as a voice layer, not a story authority

其 event-first / thesis-delay / concrete-person / riff 规则有价值；
但第一人称、固定签名、英文尾签、Visual ownership 都不适合直接继承。

### E. Story motif repetition remains upstream responsibility

三个 validation story 都存在老板/秘书关系，不能因此连续发布。

Writer 不应擅自为去重重写 locked StoryPremise；真实发布前由 Topic/Story Ledger 做 motif gate。

---

## 8. Mechanical QA

- Script / SRT exact text match: 3 / 3 PASS；
- 演讲腔 blacklist: 0 hits；
- Writer changed locked mechanism: NO；
- Writer inserted unverified factual claims: NO material issue found；
- Tutorial regression: NO；
- Forced CTA: NO；
- Forced self-introduction: NO；
- Forced English sign-off: NO。

---

## 9. Writer Adapter Admission

Decision:

`JINGSUI_WRITER_ADAPTER = QUALITY_VALIDATED / MANUAL_ORCHESTRATION`

解释：
- 三种不同 mechanism episode 已通过 writer quality contract；
- 因此可作为本项目 canonical Writer policy / Worker candidate；
- 但当前仍是 Showrunner 按 Adapter contract 调用/执行，**尚未证明 programmatic runtime orchestration**；
- 程序化 orchestration 仍留到后续 G8。

---

## 10. G3 Result

`PASS_G3_STORY_TO_SCRIPT_SRT_MVP`

Next Gate:

`G4 — Script/SRT → Director / Shot Compiler MVP`

G4 要验证：
> locked script 如何自动变成“每一个小镜头一张图”的低层视觉状态序列，而不是重新做成 PPT 或逐句配图。