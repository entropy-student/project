# Curious World Studio｜视频生成系统整体规划（只讨论，不生成、不测试）
**日期**：2026-10-10 · **阶段**：P4-P0 生产架构预审 / `PLAN_ONLY` · **决策性质**：供 Owner 评审的建议方案，**非最终技术选型批准或生产授权**。

> **一句话架构**：沿用已经安装在 Owner Windows 上、短片链路据交接已通过的 OpenMontage 作为素材与制作编排底座；优先**复用其 Remotion/FFmpeg 能力**生成稳定的逐帧视频，将本仓 `retro-mac-v1.2` 外观提取为一套专有的 A→B 合成层。真正的时间轴由**定稿音频与经校核的中文对齐数据**确定，素材、字幕与证据标签共用同一套时间基准。**这套“接入”尚未实现和验证，不应报为已完成。**

## 0. 本方案的输入与不可逾越的边界

本仓已有效并经过 Owner 确认的文件：
- [当前状态](CURRENT_STATE.md)：P3-R6 叙事研究纸面通过，声音/观众验证未运行；Owner 本地 OpenMontage 的 12 秒技术闭环由其交接报告记载为 READY，**并非本机版本、所有 pipeline、完整长片均通过**。
- [CHANNEL](CHANNEL.md)：研究事实、观众承诺、非露脸、好奇朋友口吻；不强制时长、不能拖沓。
- [STYLE_LOCK v1.2](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)、[design-tokens](../visual/retro-mac-v1.2/config/design-tokens.json)、[HTML外观原型](../visual/retro-mac-v1.2/preview/index.html)：视觉已锁 A 短桌面、B 满幅 QuickTime 风格播放器、无 C，1920×1080 30fps、单行字幕。
- [D-B 试讲 V1](../research/story-fit/prototypes/2026-10-10_P3R4_D_B_FULL_READTHROUGH_V1.md)、[J-B 试讲 V1](../research/story-fit/prototypes/2026-10-10_P3R4_J_B_FULL_READTHROUGH_V1.md)：仅为供比较的研究文本；没有批准它们立即制作、上云/买素材或入正式题库。
- [已采纳的外部审稿建议](../research/reports/2026-10-10_P3R4_ADOPTED_REVIEW_FINDINGS_AND_TEST_PLAN.md)、[单独保留的不采纳事项](../research/reports/2026-10-10_P3R4_NOT_ADOPTED_AND_PENDING_LOG.md)、[P3-R5 时长分析](../research/reports/2026-10-10_P3R5_READTHROUGH_TIMING_AND_AUDIENCE_TEST_PROTOCOL.md)、[P3-R6 不凑时长](../research/reports/2026-10-10_P3R6_CONTENT_FIRST_DURATION_AND_NARRATIVE_GATE.md)：**历史均保留，不能用“完整视频准备好了”覆盖尚未完成的试读/观众验证**。
- [正式 WORKFLOW](../research/topic-bank/WORKFLOW_V1.md)：阶段5 STORY-FIT → 阶段6剧本/权利 → 阶段7制作 QA/发布；不得修改四轴或自动晋级任何题目。

**本轮禁止**：安装/升级本地 OpenMontage/Remotion/Node/Python、调用任何外部音频/生图/视频模型、下载商用素材、跑渲染/容器/测试、触碰 VPS/网络/VPN、建立公开视频或“已准备生产”的假事实。本仓**不提供对 Owner Windows 工具目录的直接读取能力**；下述关于 OpenMontage 能力依据其**公开上游文档**，本机实际版本与路径需下轮只读核对。

## 1. 模板审查：什么是真的完成，什么只是网页预览

| 模块 | 仓库实证 | 对真实视频的缺口 / 风险 | 推荐处理 |
|---|---|---|---|
| A 桌面短开场 | CSS/DOM 的 Tiger Aqua 桌面、Finder 文件/Dock/双击和 B 切换交互 | 属网页交互，不是可由时间线逐帧决定的确定性动画 | 将开窗动画抽为 `A` 场景，默认 1.5–3s；如冷开场更有吸引力，允许缩短或直接开始 B，不因此添时长 |
| B 主体播放器 | `.stage.player .quicktime` 约 99cqw、接近满幅，内有标题栏/控制条/主 `.screen` | 实际 1920×1080 无黑边/漏桌面、素材视口大小、证据和字幕位置未成片复核 | 在 Remotion 合成中做 `RetroAquaChrome` 和 `ResearchViewport`；保留两态、不新增 C；按视觉锁定对比关键帧 |
| demo 时序 | HTML JS 的 `segments` **固定 4 段 / 总 64 秒**；`requestAnimationFrame` 驱动 | 与真实脚本、音频/SRT/素材时序没有关系；浏览器交互时钟不能作为确定性生产时钟 | **废弃四段硬编码作为生产时间源**；改由毫秒/30fps帧表控制镜头与字幕 |
| 本地导入视频 | `URL.createObjectURL` 导入，视频默认 `muted=true`、`loop=true`，仅出现在首个演示场景 | 仅供预览，可能与旁白音轨、时间轴脱离；独立循环/视频起点会错位 | 生产按镜头的 `source_in/out` 与时间轴在主播放器裁剪，素材自带原音默认为静音，仅审定时保留 |
| 占位研究图 | 假论文英文标题、图表占位、假条形柱已明确注明 | 不得拿占位当论文证据；影片不能用装饰图给出假参数 | 全部接真实可溯论文图或数据自制重绘；标记“论文证据/示意画面”等 |
| 字幕 | 4条固定文本，非音轨识别/校准；CSS `nowrap` | 长字幕可能溢出/过小；没法保证字幕对应真声音 | 正文强制对齐后按语义分短句，**严格单行**，以音频起止显示，移动端抽样审查 |
| 许可 | NovusGFX Aqua CSS MIT notice 保存 | 只有 Aqua 相关 CSS 的 MIT；**不涵盖任何论文音视频、Apple 图片/商标或图库片段** | 保留许可，视觉借鉴非官方组件；逐素材留权利记录 |

**结论**：现有 v1.2 是“正确的视觉蓝图 + 可交互网页 demo”，**不是可直接导出正式 MP4 的模板**。保留其 CSS/tokens，尽量少量重构为可供 Remotion 逐帧使用的组件，**不复制浏览器的点击/暂停/本地导入/64秒自播逻辑到生产路径**。无需重写整套 Finder，更不可套通用大字卡把复古播放器吞掉。

## 2. 选型比较与建议

| 可选方案 | 优点 | 与当前项目的关系 | 结论 |
|---|---|---|---|
| **OpenMontage + 已有 Remotion + FFmpeg** | 上游具备 `explainer`、素材检索与 `documentary-montage` 管线，支持 scene_plan、asset_manifest、edit_decisions、分层字幕、音频和输出；OpenMontage 本机基础链路已有交接 | 最贴现有工具；专用 Retro Chrome 与研究材料真实性要自己明确配置/接入；本地到底安装了哪些组件**未知** | **首选，优先扩展现有而非另开工程** |
| 独立 Remotion React 程序 | 组件与时间线可完全受控，HTML/CSS 风格复用灵活；能传入 JSON props 渲染，方便复查 | 若 OpenMontage 内已有渲染器，另起完整工程会造成重复维护 | **仅在其原生组合器实在无法承载 v1.2 时退路启用** |
| OpenMontage HyperFrames / HTML+GSAP | 接近现有 HTML/CSS，理论上更容易做 UI 运动 | 上游 documentary-montage 链存在绑定 Remotion 的限制，且本地是否安装未核实；切换要受控 | **备选，不为省改 CSS 而不经审查换引擎** |
| Abekyo Editor / 另一套 Remotion 编辑器 | JSON timeline + Web editor 人工修正能力 | 将引入全新服务、代码路径、存储和许可审核，当前不缺手工 UI 编辑器 | **暂不引入，只有后期“最后10%人工调整”成为瓶颈再评估** |
| 纯 FFmpeg concat/filtergraph | 成本低、稳定，适合编码/混音和简单裁切 | 复杂 Aqua/UI 排版、字幕与上下文标签实现维护成本高 | **保留为后处理/兜底，不作为唯一视觉主引擎** |

**公开技术依据**：OpenMontage 上游 [README](https://github.com/Open-Montage-app/OpenMontage)、[Remotion 核心桥接](https://github.com/calesthio/OpenMontage/blob/main/skills/core/remotion.md)、[explainer 编辑规则](https://github.com/calesthio/OpenMontage/blob/main/skills/pipelines/explainer/edit-director.md)；Remotion [CLI props渲染](https://www.remotion.dev/docs/cli/render) 与 [SRT 导入](https://www.remotion.dev/docs/captions/importing)。Remotion 有**特殊许可条件**：小型团队/个人通常免费商用，较大团队及自动化商业产品需按[官方 License FAQ](https://www.remotion.dev/docs/license/faq)审查；不是无条件 MIT 模块。OpenMontage 上游版本与 Owner 本地版本可能不同。

**渲染引擎决策暂定**：Remotion，视频 1920×1080/30fps/H264 MP4；最终音轨通常 48kHz AAC、`yuv420p`，具体码率与字幕展示等在下阶段技术计划确认。勿将此“推荐格式”写成机器已运行 PASS。

## 3. 生产数据管线：从故事到视频（单一时间基准）

```text
P3-R6合格的故事/观众承诺 + 来源事实清单
      |
      v
分句旁白脚本（每句有稳定 line_id） + 行为/证据 beat_id
      |
      v
配音主音轨 WAV（实际时长作为本期时间基准） ← 在真正执行前另行批准
      |
      v
中文文本-音频强制对齐（segment/word timestamps）
      |
      +----> 字幕轨：按语义合并、最长单行、SRT/VTT派生（不按每3秒切）
      |
      +----> 故事镜头槽 beat/line_id -> in/out_ms -> 素材候选
                       |
                       +-- 研究论文/原始演示 + 许可证核验
                       +-- OpenMontage stock/corpus 及片段检索
                       +-- 自制示意/代码图/复现实录/AI生成辅助素材
                       |
                       v
              权利与事实检查 asset_manifest
                       |
                       v
              timeline.json（唯一确定性镜头编辑决策）
                       |
                       v
              A/B QuickTime Remotion合成（字幕、标签、转场）
                       |
                       v
              FFmpeg封装、音量、字幕/视频质量检查
                       |
                       v
              逐帧+试听审阅 → 待Owner决定是否正式发布
```

**关键架构约束：音频完成后时间轴才最终锁定。** `line_id`/ `beat_id` 永远跟旁白语义对应；对齐给出实际 `start_ms/end_ms`；所有字幕、镜头节点、证据角标以**同一套音轨毫秒坐标**导出帧序号（例如 `frame = round(ms*30/1000)`），不要多个工具各用自己的零点；若 A 片头占用时间，应只在合成级应用一个全局偏移或将其包含在 master timeline 中。**音频重生成后不能复用未经更新的字幕/SRT/分镜时间码**。

### 下轮建议实施的最小数据合同（说明性伪 JSON，尚未创建机器schema）

```json
{
  "episode_id": "CWS-EP-EXAMPLE",
  "format": {"width": 1920, "height": 1080, "fps": 30},
  "master_audio": {"asset_id": "narration_master", "duration_ms": 210000},
  "lines": [{"id": "L001", "text": "你会停一下吗？",
    "start_ms": 2000, "end_ms": 3800, "beat_id": "B01"}],
  "shots": [{"id": "S001", "start_ms": 0, "end_ms": 6000,
    "beat_ids": ["B01"], "asset_id": "illustration_01",
    "asset_in_ms": 0, "asset_fit": "contain", "label": "示意画面"}],
  "asset_manifest": [{"id": "illustration_01", "source_type": "self_made",
    "evidence_class": "illustration", "license_state": "REUSE_RIGHTS_VERIFIED"}]
}
```

示例时间和 ID 纯占位，**没有创建真实素材/审查通过任何许可**。方案采用两级ID：`beat_id` 是观众理解更新，`line_id` 是声音最小文本单元，`shot_id` 是一个连续镜头；改变表演节奏时优先调整 shot 时机而非改写科学结论。

## 4. 音画对齐及字幕路线

1. **先确定旁白文本版本**（D-B/J-B 目前只是待真实听感验证的 V1）；配音选定后输出主音轨，标记实际秒数、采样率、音量；避免一边合成一边不断改TTS导致后续漂移。
2. **强制对齐不是“再识别一次就完事”**：用正确的最终剧本文字 + 实际音轨求 `start_ms/end_ms`；OpenMontage 上游可接 WhisperX，中文场景需确认使用的对齐模型与质量；可选的 `stable-ts` 支持带文本对齐（[上游](https://github.com/jianfch/stable-ts)）。这一步不是让ASR擅自把正确文稿改成幻觉转写。
3. 中文**单行字幕**为固定要求：不要使用 OpenMontage 默认的 word-by-word TikTok 式高亮；按语气语义拆分、每条字数以播放器1080p/移动端实际可读为准（STYLE_LOCK 建议18–22全角字只是参考，不应强切断句）。跨越多句话的原始长句允许在实际发声点逐条依次出现。
4. 每段字幕有单一 `start_ms/end_ms`；不得重叠、多行、离声音太早/晚，静音段不滞留旧字幕。SRT是**生成输出**，不是独立重新写一套伪时间轴。
5. 镜头可以跨多个字幕持续展示；字幕的频率**不决定切镜频率**，以真实动作是否结束/观众是否需要看到新证据为准。辅助素材的原声默认禁用，以免与旁白串音。
6. BGM/SFX：如需加，仅低存在感可许可素材，遵循人声优先、自动ducking/淡入淡出，**无适合音乐时允许无BGM**。版权记录同其他素材。
7. 未来技术 QA：配音时长与总视频时长、音轨起点、subtitle首尾、每帧shot覆盖、缺帧黑屏、句段是否漏词、口播在剪辑点是否被截断；自动检测 + 真人抽样复核，**不能把纯自动对齐标成“100%人工听过”**。

## 5. 素材策略：根据“此句要让观众看到什么”选，而不是先堆图库

| 优先路径 | 用途 | 采用门槛 | 失败/空缺时的替代 |
|---|---|---|---|
| **A. 原论文/研究机构原始演示** | 展示研究真实的对象、动作、声学或关键结果；尽量支撑最关键发现 | **确认为这一项研究的实际内容**；来源 URL、视频内的对应时间段、使用许可和署名要求逐件核查。论文 CC BY 不能自动推断另一个官网/YouTube 演示也获授权 | 标“示意画面”的原创解释性重绘；不可冒充研究录像 |
| **B. 论文正文图/表/补充附件** | 验证核心研究结论；截取重点数据而非论文页面停留一分钟 | 图号、页码/ DOI、许可/第三方信用、正确解读；PLOS 一般 CC BY，有来源署名义务，研究附件仍需逐件查明 | 基于核实数字自绘清晰信息图，并注明来源和重新绘制 |
| **C. OpenMontage Pexels/Pixabay/Archive/NASA/Wikimedia 素材** | 日常气氛、人物非研究现场动作、过渡镜头 | 搜索结果必须先看到具体内容并核时长/比例，再录授权与作者/原地址；**只作“辅助素材”，绝不表示原实验实况** | 直接用 B 内的原创 UI/图形/无版权风险抽象动作 |
| **D. 自制可验证示意/屏幕录制/少量代码动画** | 最适合 D 三按钮、J 勺子等观众锚点与对比结构；复用美术代码 | 自制图明确标“示意画面”；如果独立复现实测，需要如实给条件、与论文区别、设备与结果 | 更简单的静态对比、局部重点标注 |
| **E. 生成图/视频** | 补齐完全无法实际拍摄且非核心科学证据的说明性镜头 | 明确“示意画面/AI生成辅助”、记录模型/版本/提示词或其他可追溯生成方法；不得制造“论文实际演示”的假画面 | 自制简图或合法图库，不因要炫技强制生成 |

**素材资产清单每条至少需要**：`asset_id`、所服务的 `beat_id/line_id`、`source_type`、`source_url`、`original_author`、`content_verified`、`license_name/license_url`、`reuse_rights_verified`、`attribution_text`、`evidence_label`、`source_in/out`、本地路径及校验值、转换/裁切记录、失败时备用镜头。形式上保留既有 `LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED` **三项分离的状态**；任何关键素材不可在权限未知时标记 production-ready。

**版权依据**：[PLOS licenses](https://journals.plos.org/plosone/s/licenses-and-copyright)（CC BY 重用需署名，第三方内容单独注意）、[Pexels license](https://www.pexels.com/license/)、[Pixabay license](https://pixabay.com/service/license-summary/)（可商用亦有商标/肖像/误导性使用限制）。

**素材选择算法建议（将来实现）**：
`voice sentence -> story beat & target observable action -> evidence requirement -> candidate retrieval -> semantic AND factual AND rights review -> ranking -> shot selection -> fallback`。
其中 semantic match 应判“**画面具体对应文案哪一项行为/证据**”，不只是CLIP分数高。不能机械每3秒换画面；单个真实动作/关键研究图可以持续更久。

## 6. 专用渲染流程（为什么先用 OpenMontage Remotion）

- **项目编排**：由 Agent/Codex 读取固定文案、视觉 tokens 和各类 JSON；OpenMontage 负责其已支持的素材查询、基础场景规划、资产清单、既有配音及 edit_decisions（本地接口有待核对）。**禁止在构建镜头时自行改剧本文字/重写结论**，任何创意偏离需重新审稿。
- **Remotion**：将 Aqua外壳分 A 桌面、B 全幅播放器；B 中 `EvidenceBadge`/`AssetViewport`/`SingleLineCaptions` /`ChromeControls` 依全局 frame + timeline 数据渲染。视频转场优先干净硬切，少量短溶解，图片缩放最多 1.03。不做“章节大字PPT”，不增加新 C 模式。
- **FFmpeg**：仅在已完成分层合成后统一音视频编码/封装、音量/淡入淡出与 QA；不以 ffmpeg 运行时长代替实际音轨和视觉 QA。
- **素材视频**：Remotion 通过时间轴确定真实 `in/out`、音轨是否静音、合适采样；静态图片最长显示多久取决于正在讲什么，不强制固定最大停留秒数。
- **一次可重复生产**：固定一份 `episode manifest + frozen media assets + renderer version + voice version`，可导出同内容 MP4、SRT、source/license ledger、render_report 和关键帧 contact sheet；更换口播/镜头会改变版本号并触发依赖失效。

## 7. 分阶段落地计划（以下全是**待批准的未来动作**）

| 关口 | 下一阶段工作 | 有证据才算通过 |
|---|---|---|
| **G0 只读本地适配审计** | 在 Owner Windows 由本地 Codex 检查 OpenMontage 实际版号、`$openmontage`技能、remotion-composer、npm、Node、FFmpeg、Qwen TTS 是否配置、实际 pipeline/schemas与权限；**只读，不安装/调用** | 环境清单、版本/路径/是否已有本地 project/render，确定能否原位复用 |
| **G1 生产数据合同 + 模板移植设计** | 决定谁持有 `timeline.json`、line/beat/shot/asset 字段、Audio->SRT、B 内播放器样式，画出技术接口和失效机制 | 与 STYLE_LOCK v1.2 一一对齐的 schema 评审；仍不需要生成视频 |
| **G2 极短真实“音画一致性”验证** | **仅获新授权后**，用已明确可用的临时/许可素材、短示例旁白做20–30秒 A→B 一段，并测音画字幕；无需修改正式研究成果 | 30fps/1920×1080、无掉帧、音轨时长、字幕单行/对齐、五类证据标签、来源/授权状态可读 |
| **G3 两篇中的一篇完整低成本成片试制** | 由 Owner 选 D 或 J（**不因D成本低自动锁首发**）；先取得关键研究媒资许可，再配音→中文对齐→分镜→单次渲染→QA | 真实观看承诺兑现、无拖沓、图文证据真实、素材语义匹配、安全使用权、最终全片听感与版权复核 |
| **G4 可复制生产** | 仅 G3 通过后模板化生成，允许不同题材复用A/B、标签、字幕、声学时序、素材账本 | 重复两类不同题材，人工可控补镜率与反复渲染成本透明，支持不露面的稳定产能 |

**不能省略的人工决策点**：关键事实确认、论文视频权限、最终配音音色、重要视觉锚点选材、成片真实观看感受与是否发布。

## 8. 当前待定的问题（必要，不要求一次全决定）

1. **本地 OpenMontage 版号及真正集成的Remotion渲染路径未知**：公开上游能做，并不等于本机的 12 秒短片验收涵盖全部内容。先做 G0 静态只读回报，否则过早选独立新程序。
2. **原始研究视频权利与可获取性**：特别是 J 的可食用交互果冻，最吸引人的真实动作素材尚未做逐片权利验证；B 原声音频虽文件级 QA 通过，真人可听性与商业复用权另待核。找不到时需要可标识的“示意”视觉路线。
3. **中文对齐工具是否已经在 OpenMontage 本地可用**：WhisperX 普通话模型/依赖（Windows CPU运行速度）、替代 stable-ts 的实际误差都没有测试；不指定这些工具已通过。
4. **渲染用CSS能否复用到逐帧且 B 真正 edge-to-edge**：当前网页定位 `cqw`、交互状态和局部转场必须经渲染对照，不能只看 HTML 截图自认为已达标。
5. **真实声音配置**：本地既有 Qwen TTS 是否可复用、目标语速与声音适配仍要实际听；不为凑时长降低语速，不在未授权时调用。
6. **最终 BGM 是否必要**：清晰旁白优先；免费音乐是否合适及许可、短片风格一致性未选，不是 G0/G1 阻塞项。
7. **资源与许可证**：Owner 笔记本现有显卡可用性未知，Remotion一般可CPU/浏览器渲染但成本、内存、Windows依赖都需要实测；Remotion license 请与使用方式对应核对。

**总体建议**：本轮先获得 Owner 对**架构路线与阶段优先级**的认同；下一轮才进入 G0 只读本地适配审计。即使工具均在，也不能跳过研究素材权利审查，更不应从“一句话调用OpenMontage”直接发布完整研究视频。
