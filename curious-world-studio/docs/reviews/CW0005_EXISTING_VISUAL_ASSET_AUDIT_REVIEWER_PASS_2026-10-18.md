# CWS｜CW0005 既有视觉素材盘点：独立Reviewer结论（2026-10-18）

**正式裁决：`PASS_EXISTING_ASSET_AUDIT_ONLY`。** 含义仅为现存素材盘点、映射、权利及缺口分类报告达到本轮有界Gate的文本/已有证据验收条件；**不能解释为图像可直接用于视频、⑤真实材料画面呈现PASS、⑭故事连续性PASS或制片/发布授权**。

- Gate：[`CWS-CW0005-EXISTING-VISUAL-ASSET-AUDIT-20261018`](../CWS_CW0005_STORYFIT_ASSET_AUDIT_GATE_2026-10-18.md)。
- Executor提交：[PR #152](https://github.com/entropy-student/project/pull/152)，HEAD `907204c306a55af0951a8ddacdd182d7530ae50b`，仅两文件、100新增行、0删除；**PR本身仍未合并，不具自动合并授权**。
- Reviewer评论：[PR #152 独立审核](https://github.com/entropy-student/project/pull/152#pullrequestreview-5562410938)；本文件为main的正式Reviewer验收记录，具体Executor台账与追加Evidence仍在未合并PR。
- 实际直接检查：PR路径及补丁、`main` R2验收旁白与10镜头、3+1素材/全项目视频唯一性约束、现行Gate、V5.6.2冻结HTML blob `33aabc3ff2e48877493277eb1a86274818e3c769`；公开论文 `Popcorn: critical temperature, jump and sound` 中Figure 1、3a与6与分镜用途对应。
- 报告质量：S01–S10逐镜均有画面目的、候选来源及缺口；旧R3的Pexels #854959和Pixabay #2793明确 `BLOCKED_ALREADY_USED`，历史R3合成视频/抽帧不作为新来源；15视频/70图片是本机catalog记录而非85件实物；PeerTube/Commons弱相关素材不冒充有效镜头；Figure 1/3a/6在受审本机目录中未找到实体文件/图像，全部保持`CONTENT_NOT_VERIFIED / RIGHTS_UNKNOWN`。
- 关键证据边界：GitHub与论文文本为Reviewer直接核验；**本机文件搜索结果、现存帧所见、文件SHA和FFprobe是Executor报告，Reviewer未直接检查其实际媒体字节或Windows文件系统。** 因此“没有Figure”仅限Executor列明的本机范围，不等于官方论文没有图。不能以本轮PASS宣称已亲自看图或已经取得合法商用权。Figure 3的(b)/(c)含第三方改编内容，未来应针对需要的3a面板核实其准确权利与可读性。
- 复核缺口仍在：①真实论文图/许可/来源行；②开场尚未使用的真实相关动作镜头；③T4/T5实际内容可读性与⑭整段视觉叙事；④真实4–6分钟自动生成及TTS/Cue/SRT/MP4闭环。
- 后续只做最小新Gate提案：先针对官方论文Figure 1/3a/6审阅原图、credit/许可和播放器布局（不下载/渲染，除非另获授权），再定向补充未使用的真实实拍，最后通过Owner单独批准的30–60秒视觉样片Gate测试Story-Fit。不得为了本次盘点重复V5.6.2冻结技术审核或R3旧执行。
- 当前权限：`CW0005_R3_RETURN_OWNER_VISUAL_STORYFIT / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH / RIGHTS_PARTIAL` 原样保持。Owner本次无需新转交，后续新下载、付费、AI生图、制片、合并PR和发布均单独决定。
