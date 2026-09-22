# Character Reference Strategy Note

Date: 2026-09-22  
Episode: `blind-search-answer`  
Status: `DISCUSSION_NOTE / NO_RUNTIME_CHANGE`

## 1. 当前发现的问题

当前 G5 参考包中的 `characters/` 下有三张人物相关图片：

- `CHAR_IP_001_identity.jpg`
- `CHAR_IP_001_turnaround.jpg`
- `TEMP_ANALOGY_ACTOR_001.jpg`

其中：
- 前两张都属于主角 `CHAR_IP_001`；
- 第三张是通讯录类比段落中的临时配角，不属于主角。

问题在于：

1. `CHAR_IP_001_identity.jpg` 与 `CHAR_IP_001_turnaround.jpg` 并非完全一致；
2. 如果生图执行器将两张略有差异的主角参考图同时、等权输入，可能导致脸型、发型、年龄感、服装细节或身体比例被模型折中，增加人物漂移；
3. 当前执行规则虽然存在 reference precedence 和 identity lock，但尚未显式规定“哪一张图负责身份、哪一张负责身体/角度”这一层 Reference Role Binding；
4. 多人物镜头若同时输入多张角色参考图，也存在串脸、串衣服或角色归属不清的风险。

## 2. 当前项目的最快推荐解法

对于本期 44 个 Visual Beat，优先采用：

> **一人一张唯一 Master Reference + 连续镜头优先 DERIVE_EDIT。**

主角建议：

- 以 `CHAR_IP_001_turnaround.jpg` 作为本期主角唯一 Master Reference；
- `CHAR_IP_001_identity.jpg` 暂时退出正式生图输入，仅保留为历史/人工比对资料；
- 独立新镜头只输入主角唯一 Master；
- 连续镜头优先使用“主角唯一 Master + 上一张已通过画面”进行 `DERIVE_EDIT`；
- 第一人称手部/局部镜头只要求保持可见服装与身体线索，不强行加入脸部参考。

配角建议：

- `TEMP_ANALOGY_ACTOR_001.jpg` 继续作为一次性 sequence-local 配角参考；
- 当前只用于 `SRCH_VB023`、`SRCH_VB024`、`SRCH_VB025` 三个 Beat；
- 不与主角参考图混作同一人物身份真值；
- 若未来更换该配角，影响范围仅限这三个 Beat。

## 3. 长期推荐方案

长期更稳的方案是建立统一角色表（Character Sheet / Character Bible），其能力高于单纯三视图。

每个长期角色维护一个唯一 Master，统一锁定：

- 正面 / 3/4 / 侧面 / 背面；
- 脸型、五官、发型；
- 成年感 / 年龄感；
- 身体比例；
- 服装；
- 常用表情；
- 必要姿势或角度。

多人场景遵循：

- 谁出镜，只输入谁的 Master；
- 双人镜头输入 A + B，各自角色明确；
- 多人镜头可额外维护 group lineup / cast sheet，用于身高差、体型差、站位关系和服装区分；
- 连续镜头仍优先 edit / derive，而不是每张从零重生。

## 4. 当前执行决定

本轮**不修改现有 G5 生图指令、参考包或执行规则**。

先让 Antigravity 按原计划跑出第一版 Asset Gate 产物，再根据真实生成结果判断：

- 人物是否发生明显漂移；
- 两张主角参考是否确实造成冲突；
- 多人物镜头是否串脸/串衣；
- 是否需要在下一轮正式引入唯一 Master Reference 或更完整 Character Sheet。

因此本文件仅记录问题与推荐解法，不改变当前运行状态。
