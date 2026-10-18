# CWS｜CW0005 PR#153真实样片独立审核（2026-10-18）

**结论：`TECHNICAL_VIDEO_PASS / RETURN_VISUAL_STORYFIT / PAPER_MEDIA_RIGHTS_PARTIAL / NO_PUBLISH`。** 实际MP4已由Owner当前对话上传、Reviewer直接读取并对抽帧目视复核，因此本次不再以“Reviewer看不到视频”作为阻塞。**但本Reviewer未进行本机Chromium1×连续手播或完整配音人工听辨**；这些是Executor技术报告中已完成、尚未被Reviewer独立重演的事项。**Owner审美PASS也未发生**。

## 依据与提交状态

- Gate：[CW0005联合Story-Fit Gate](../CWS_CW0005_COMBINED_STORYFIT_SOURCE_TO_SAMPLE_GATE_2026-10-18.md)；Executor初始PR：[PR #153](https://github.com/entropy-student/project/pull/153)，HEAD `a759bf36dad1c94d6ffaa52a87a6393980dcf2fe`；[独立Review评论](https://github.com/entropy-student/project/pull/153#pullrequestreview-5562613527)。PR仅增一份真实执行者脱敏记录，已按Owner此前“可合并即合并”授权**squash merge 为 `65f079f68fac74ee2bd3abc3df58d39469eb07c5`**。它是执行历史和失败诊断证据的归档，不是Story-Fit认可。
- Owner当前对话上传的实际样片 `CW0005_internal_av_sample(1).mp4`；Reviewer沙盒SHA-256实算`be48565792f94fccdebb95229d8744d044b1edf47a1cdbfa9015dc37e0ebda6c`，与Codex预报`BE48565792F94FCCDEBB95229D8744D044B1EDF47A1CDBFA9015DC37E0EBDA6C`一致。媒体30,225,318 bytes、55.266667s、1920×1080、H.264视频/30fps、AAC mono 24kHz音轨；Reviewer FFmpeg完整解码`PASS`，并从实际字节采样约1秒一帧全段览图和0.4、2、10、21.8、24.8、35、43、46、53.8秒全画幅关键帧；音频流存在且检测到非静音，但并未通过逐字听辨。视频/截帧均不上传Git，避免第三方素材复用风险。
- GitHub独立核查：PR#153 仅一份 `docs/reviews/CW0005_COMBINED_STORYFIT_EXECUTOR_2026-10-18.md`，没有源代码/冻结素材改动；冻结V5.6.2 HTML git blob `33aabc3ff2e48877493277eb1a86274818e3c769`保持。此前PR#152库存盘点仅审计Scope PASS，未变更正式视觉结果。

## 已接受的技术结果

- 整段MP4真实存在、技术解码、1920×1080/30fps、哈希一致`PASS`；R2十句旁白在画面中的字幕及Executor叙述未见已知事实反转；旁白原WAV身份和Chromium一倍速完整播完仍以Executor提供的原始报告为证据，不冒充本次独立复演。
- 新Pexels #1796141 / #35876717的视频来源画面上明确标记“辅助素材、非研究录像”，旧#854959与Pixabay #2793未发现被放入此片；720p源放大成1080p已经如实标识。论文Figure 1/3a/6与官方补充movie S1/S2因获取、许可/像素未验证而未使用，材料重用权继续`PARTIAL/UNKNOWN`。
- S05 右下角小窗“AI概念示意，非研究录像”、S09“作者假说”边界有被标识，属于事实边界正向改进；但标识不自动证明**视觉语义**准确。

## 核心退回原因（真实画面直接核验）

1. **明显重复的视觉功能**：样片约1.5至44.5秒始终是同一源锅内实拍Pexels #1796141，Executor报告原素材连续42.966秒，约占全片**77.7%**。先前Owner明确否决两条类似库存视频支撑83%画面的旧R3；本片尽管形式上满足“每个原视频只出现一次连续区间”，却未解决知识叙事画面缺乏变化的实质。该占比为本片观感诊断，**不是项目硬性上限**。
2. **主要科学解释没有“被看见”**：温度样本比较（170°C17/50 vs 180°C48/50）、淀粉脚形成→受压→回弹、100→106ms声音延迟/另一次声学实验均由顶部小字或旁白带过，而主画面始终为锅内玉米，无法观察到T4/T5作为主体场景实际在片中承担上述内容；论文原图及研究视频明确没有用于成片。
3. **S05插画画面价值有限而且可能反向暗示错误机制**：约21.4–27.3秒的小窗只有一幅爆开爆米花的橙色底座和向上箭头，外观看来类似向上射流；并没有三段不同状态让观众理解“淀粉脚被压缩后回弹”。本篇恰恰要避免暗示蒸汽“火箭”效应，必须改成可视化明确的弹性接触/压缩/回弹机制，且继续标识AI静态概念示意，而不伪装实验图。
4. **未保持既定原始Mac的外壳质量**：开场在0.4秒是普通蓝底+白标题卡而非STYLE_LOCK规定的Research Aqua完整Tiger桌面顶栏/Dock/研究文件双击；播放器有通用金属条但未展示原冻结版完整开窗动画。55秒结束画面尚为爆米花卖场，没有看到返回桌面。应**复用**已冻结模板，不再手工仿制缩水版本。

**相对次要**：720p素材升格导致可能的清晰度限制，但不是主要退回理由；不因为论文图取不到就必须再花一轮无限找精确科研视频，也无需重写已验收旁白。

## 最小返修方向（此处为Review建议，非自动制片新授权）

- 保留R2声音/字幕、全部通过的编码QA、合法新实拍素材与记录；只重建**S01–S10→T1–T6→画面素材/Cue**这一层，以冻结V5.6.2为唯一Mac外壳而非再制作一个“类QuickTime”壳。
- S02–S03直接借现有T6数据可视化真实数字17/50 vs 48/50，不冒充或复制版权未知的Figure1；S04–S06借T5**主体级三态**（脚形成、受压、弹起）的真实许可原图或科学核过的AI静态概念图；S07–S09借T2/T6呈现研究事实“第二次破裂~100ms→音效~106ms”和独立的“作者假说”标记，不虚构音波原始实验；S10用两个结果/假说对照收束。
- 需先审一次具体关键帧视觉语义、实际布局和媒体身份，再有界渲染一个修正版内部样片。禁止再用一条锅片贯穿所有旁白、将结论塞进小字、引入新Mac或新第七模板。固定文案在画面匹配期不变。
- **治理边界**：本轮真实制片发生且已被Reviewer判断视觉RETURN；Governance §5规定“失败的实质性写入后再次实质制作应有新的后果授权”，旧综合Gate不因“有最多两次局部重试”自动无限扩张。下一轮可将关键帧布局复核和单次修正版短片合为一条新Gate，Owner确认后执行；未确认不得自行再渲染或发布。

## 最新工程/业务状态

`CURRENT_ACCEPTED_STATE=V562_TEMPLATE_TECHNICAL_PASS + EXISTING_ASSET_AUDIT_PASS + CW0005_55S_MP4_TECHNICAL_PASS`。

`CURRENT_VISUAL_STATE=RETURN_VISUAL_STORYFIT`（⑤科研视觉/⑭真实叙事未通过，Owner观看验收未完成）。

`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH / PAPER_MEDIA_RIGHTS_PARTIAL`保持。独立Reviewer不批准公开发布、4–6分钟成片、第二选题，也不建议复现已解决的技术链路。
