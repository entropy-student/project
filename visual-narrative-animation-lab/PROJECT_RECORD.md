# Visual Narrative Animation Lab — PROJECT RECORD

> Long-term project record. Gate-level technical truth remains in `REVIEWER_HANDOFF.md`.

## 1. Final Goal

建立一套低成本、可重复、可批量扩展的画面叙事动画生产系统：

```text
口播稿 + 配音
→ AI/Human Director
→ Visual Beat SHOTBOOK
→ 复用已有资产 / 仅补缺失画面
→ 时间轴表演
→ 字幕 / SFX / 图形层
→ MP4
```

长期目标是把已经人工验证的导演规则、资产解析和镜头执行封装成可复用 Skill / Workflow。

## 2. Why This Project Exists

已有 `story-to-handdrawn-video` 一类方案的主要问题是过于固定：一句话对应一张图、统一 reveal/wipe、镜头与 Pose 变化不足，最终更像动态绘本或 PPT。

本项目关注的是“画面如何参与叙事”：什么时候换构图、换 Pose、做视觉比喻、复用旧画面、停顿、硬切，以及一段声音如何映射到多个 Visual Beats。

## 3. Completed

- P0：项目立项与治理框架完成。
- G1A：建立基准视频分析量表和镜头表模板。
- G1B：完成一条 159.38 秒参考视频的逐镜拆解；检测约 62 个镜头，中位镜头时长约 2.2 秒。
- Visual Beat Grammar v0.1：确认硬切、Pose、视觉比喻、回调复用比持续运镜更关键。
- G2A：完成原创 30–40 秒测试稿和 18 Beat SHOTBOOK。
- G2B：锁定原创主角方向、表达式/Pose 方向和 Art Bible v0.1。
- G2C1：完成镜头资产解析，18 Beat 收敛为少量主构图 + 复用/裁切/叠加。
- G2C2：已形成主要生产构图与 16:9 裁切资产。
- G2C3：已输出第一条约 38 秒 Animatic v0 作为质量验证基线。
- Project Library：项目已整理进 `entropy-student/project/visual-narrative-animation-lab`，根目录中英文导航均已登记。
- Asset Recovery：关键二进制资产、Animatic 与完整工作快照的 SHA-256 已进入仓库。

## 4. Current Stage

`G2C4 — Owner/Reviewer Visual Comparison`

需要回答的不是“图好不好看”，而是：

1. 当前样片有没有明显比“一句一图”更有叙事感；
2. 仍然像 PPT/图集的地方具体是什么；
3. 缺的是新构图、Pose 表演、动态层、音效节奏，还是导演规则；
4. 哪些规律值得进入 G3/G4 固化。

## 5. Locked Decisions

- 不以持续运镜作为主要生命力来源。
- 不按标点机械拆镜头。
- 允许一句台词多个镜头，也允许多句台词共用一张图。
- 角色身份保持固定，Pose 与表情服务语义。
- AI 生图不负责正式正文文字；所有可读内容统一后期叠加简体中文。
- Remotion / Live2D / PSD2Live 均属于后续执行层候选，不是当前导演层核心。
- 自动化不得降低人工验证基线的叙事质量。

## 6. Next Actions

1. 审看当前工作快照中的 `renders/G2C_animatic_v0/G2C_animatic_v0.mp4`。
2. 对照 `docs/g1/G1_VISUAL_BEAT_GRAMMAR_v0.1.md` 记录缺失层。
3. PASS：进入 G3，正式建设 Character / Pose / Scene / Prop Asset System。
4. RETURN：只针对明确缺失项修正 G2，不扩大范围。

## 7. Important Files

- `REVIEWER_HANDOFF.md` — 当前 Gate、事实、UNKNOWN 与正式下一步。
- `docs/g1/G1_VIDEO_A_DECONSTRUCTION.md` — 基准视频拆解。
- `docs/g1/G1_VISUAL_BEAT_GRAMMAR_v0.1.md` — 第一版画面叙事语法。
- `docs/g2/G2A_TEST_SCRIPT_AND_SHOTBOOK.md` — 原创测试脚本与 18 Beat 设计。
- `docs/g2/G2B_ART_BIBLE_v0.1.md` — 角色/画风锁定。
- `docs/g2/G2C_SHOT_ASSET_MANIFEST.md` — 镜头资产解析。
- `docs/g2/G2C_TIMELINE_EVIDENCE.md` — Animatic 时间轴证据。
- `assets/ASSET_SNAPSHOT_MANIFEST.md` — 当前二进制工作集的用途、大小与哈希。
- `ASSET_HASHES.sha256` — 恢复工作快照时的文件身份校验。

## 8. Asset / Copyright Boundary

- 原创主角、AI 生成角色/场景和项目样片可作为项目资产保存。
- 第三方创作者视频仅用于研究和比较；原视频与逐帧截图不进入本项目仓库。
- 仓库保留派生的结构化分析、镜头时间数据和方法论总结。
- 当前高分辨率二进制工作文件不进入普通 Git 历史；先用哈希 + manifest 锁定，后续再决定 Git LFS / Release Asset 托管。

## 9. Current Working Snapshot

- Package: `visual-narrative-animation-lab.zip`
- SHA-256: `d1a01cedbfa39add0c8f7d9c6344be45996f3dd21276e6188f550d149284568a`
- Includes project documents, original/AI-generated assets and the current Animatic v0.

## 10. Resume Checklist

重新接手项目时：

```text
README.md
→ PROJECT_RECORD.md
→ REVIEWER_HANDOFF.md
→ assets/ASSET_SNAPSHOT_MANIFEST.md
→ docs/g1/G1_VISUAL_BEAT_GRAMMAR_v0.1.md
→ docs/g2/G2C_TIMELINE_EVIDENCE.md
→ restore/verify binary snapshot with ASSET_HASHES.sha256
```
