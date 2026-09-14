# G2A — Original Test Script + Director SHOTBOOK

> Status: PASS candidate for G2A. Reversible test script chosen to exercise the visual grammar, not a locked content direction.

## 1. Test Topic

**为什么同一个 AI，有时候突然像“变笨了”？**

Reason for selection:
- naturally supports before/after contrast
- contains abstract concepts that require visualization
- supports character performance + metaphor gag + icon cards + repeated composition
- can be understood without complex backgrounds
- suitable for a 30–40 s first prototype

## 2. Provisional Voiceover Script

你有没有这种感觉：同一个 AI，昨天像博士，今天像刚睡醒的实习生。

你问它一个很简单的问题，它先思考半天；真正难的任务，它反而三句话交卷。

更气人的是，你重新开个对话，它又突然正常了。

所以我后来不再只问“它是不是变笨了”，而是看五件事：任务能不能做完、思考有没有异常、输出有没有变空、速度有没有掉、我是不是开始反复重问。

同一天里这几项一起变差，才值得怀疑。

Estimated voice duration: ~34–40 s depending on delivery.

## 3. Director SHOTBOOK v0.1

| # | Provisional time | Spoken beat | Visual class | Visual concept | Asset strategy | Narrative job |
|---:|---:|---|---|---|---|---|
| 01 | 0.0–2.0 | 你有没有这种感觉 | CHARACTER_POSE | 主角盯着电脑，半信半疑 | NEW_ART | hook / orientation |
| 02 | 2.0–4.0 | 同一个 AI，昨天像博士 | METAPHOR_GAG | AI 被画成学术博士，书堆/答题板，主角仰望 | NEW_ART | establish smart extreme |
| 03 | 4.0–6.2 | 今天像刚睡醒的实习生 | METAPHOR_GAG | 同一个 AI 趴桌、头发乱、咖啡洒了 | VARIANT | contrast / joke payoff |
| 04 | 6.2–8.2 | 很简单的问题 | NARRATIVE_TABLEAU | 主角递出一张简单题卡 | NEW_ART | setup |
| 05 | 8.2–10.8 | 它先思考半天 | METAPHOR_GAG | 巨大沙漏/时钟，人物托腮石化 | NEW_ART | exaggeration |
| 06 | 10.8–13.2 | 真正难的任务 | NARRATIVE_TABLEAU | 主角推出厚文件/复杂流程图 | VARIANT | contrast setup |
| 07 | 13.2–15.0 | 它反而三句话交卷 | METAPHOR_GAG | AI 拍下只有三条短横线的答卷 | NEW_ART | punchline |
| 08 | 15.0–17.0 | 更气人的是 | CHARACTER_POSE | 主角额头青筋/捏拳 | NEW_ART | reaction hold |
| 09 | 17.0–19.0 | 你重新开个对话 | ICON_CARD | 巨大“新对话”按钮被按下 | NEW_ART | graphic punctuation |
| 10 | 19.0–21.0 | 它又突然正常了 | METAPHOR_GAG | 复用 S02 博士构图，主角换无语表情 | REUSE+VARIANT | callback / reversal |
| 11 | 21.0–23.5 | 不再只问“是不是变笨了” | CHARACTER_POSE | 主角把巨大问号牌推到一边 | NEW_ART | thesis transition |
| 12 | 23.5–25.0 | 而是看五件事 | ICON_CARD | 五格检查卡 | NEW_ART | section marker |
| 13 | 25.0–27.0 | 任务能不能做完 | SUMMARY_BOARD | 第1格：任务进度 | NEW_ART | criterion 1 |
| 14 | 27.0–29.0 | 思考有没有异常 | SUMMARY_BOARD | 第2格：齿轮状态 | VARIANT | criterion 2 |
| 15 | 29.0–31.0 | 输出有没有变空 | SUMMARY_BOARD | 第3格：气泡状态 | VARIANT | criterion 3 |
| 16 | 31.0–33.0 | 速度有没有掉 | SUMMARY_BOARD | 第4格：速度表 | VARIANT | criterion 4 |
| 17 | 33.0–35.2 | 我是不是开始反复重问 | SUMMARY_BOARD | 第5格：重复问号 | VARIANT | criterion 5 |
| 18 | 35.2–38.5 | 几项一起变差才值得怀疑 | METAPHOR_GAG | 五格同时报警，主角侦探式检查 | NEW_ART | conclusion / payoff |

## 4. Many-to-Many Mapping Proof

### 1 → N
“昨天像博士，今天像刚睡醒的实习生”被拆成 S02/S03 两个视觉状态；“简单问题 vs 真正难任务”被拆成 S04–S07：setup → exaggerated delay → hard task → absurdly short answer。

### N → 1
S12–S17 共用一个五格检查板系统；S10 刻意回调 S02，而不是生成完全新的构图。

## 5. Runtime Motion Policy

- camera: HOLD for all shots
- transition: HARD_CUT for all shot boundaries
- optional micro-motion: NONE by default
- drawn action lines/symbols are part of the still artwork

This intentionally tests the benchmark's strongest observed grammar before adding motion technology.

## 6. Asset Budget

18 shots do not require 18 unrelated artworks. Expected unique major compositions: ~10–12; expected explicit reuse/variant shots: >= 6.

## 7. G2A Review

PASS criteria met: original test narration, 18 visual beats defined before generation, explicit 1→N/N→1 mapping, intentional reuse, mixed visual classes, no wipe/reveal dependency, no runtime-animation dependency.
