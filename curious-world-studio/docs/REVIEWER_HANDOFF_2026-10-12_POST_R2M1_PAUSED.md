# Curious World Studio｜下一位 Reviewer 完整交接（2026-10-12）

> **当前生效 / Owner 最新指示：先不换题，暂停后续选题与制作推进。** CW-0005「爆米花为什么会跳、还会响」已完成 R1 多轮核证、R2 条件性故事设计与 R2-M1 两条库存媒体获取/解码预检；最终状态为 **`CW0005_VISUAL_STORYFIT_HOLD`**。**不可**宣称 `STORYFIT_GO` / `R2_MEDIA_CANDIDATE` / `PRODUCTION_READY` / `G1_PASS`，**不可进入 R3**。此前 Reviewer 曾建议转查 CW-0004／CW-0008；**Owner 于本次交接明确“先不换题了”**，故该建议与相应未下发的提示词不再是当前待执行任务。新 Reviewer 首先确认停在这里，不应自作主张派发任务。
>
> **证据属性说明**：本交接综合 GitHub 正式规范、Owner 提交的真实 R1/R2/R2-M1 验收 ZIP 及前任 Reviewer 的独立验收结论。ZIP SHA 和内部清单曾经独立复核；媒体文件本身没有随 R2-M1 ZIP 提交，所以 Reviewer 独立核查了日志、FFprobe、6 张实际抽帧，但**未亲自重解码两份完整 MP4、未听完整音轨**。必须维护“执行端回报”与“Reviewer 自己核验”的界限。旧文档带有历史时态，遇到冲突以本交接和 Owner 新指示为准，正式设计/版权规则仍以仓库权威合同为准。

## 0. 最短接手路径（请按顺序）

1. 读本交接，确认目前是 **PAUSED / HOLD**，既不自动换题，也不继续追查爆米花原视频。
2. 看 GitHub 实际最新 `main`：[`curious-world-studio/docs/CURRENT_STATE.md`](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/CURRENT_STATE.md)、[`AGENTS.md`](https://github.com/entropy-student/project/blob/main/curious-world-studio/AGENTS.md)，再读下方列出的素材和 Style Lock 合同。不要拿 2026-10-11 的旧 M2/Mac `LATEST` 时间线覆盖本交接。
3. 如要做新的独立验收，请用 Owner 提供的 **R2-M1 原始 ZIP**（本交接包同时备份）读取 19 项 SHA 清单、六张关键帧、逐句镜头表、台账和执行日志；有必要再回溯其他四个 R1/R2 ZIP。
4. **当下无需让 Codex 执行任何新任务。** Owner 以后主动恢复，再根据其明确方向选择一个有界动作；不假设已同意新选题或更改“3＋1”素材合同。

## 1. 项目是什么、Owner 希望得到什么

- 项目代号 **Curious World Studio**；候选中文名 **「世界有点意思」**，**未正式定稿**。目标是长期可复用的、不露脸的、跨领域真实研究/现象探索频道；**B 站主阵地，小红书/抖音辅助**。
- 频道承诺：发现一个**近但未深思**、足以令人好奇的真实问题，找到一手证据，给观众**看到**真实现象，并解释研究证明什么、没有证明什么。原则：**知识小众，问题大众；行为具体，过程有趣；证据真实，承诺兑现**。
- 长期偏好是观察、追问、理解、表达，避免纯教程、反复追热点、机械手工剪辑和 PPT 式说教；采用可复用模板、代码合成，尽量降低 Owner 重复操作。不露脸，旁白可用经批准的云音色。
- 频道时长**不需要强凑 4–6 分钟**：自然、节奏好、故事承诺兑现优先。曾有 2:39 粗样 / 原型，仅为历史实验，不代表正式一期已制作完成。
- 研究系统已建：九类信息源、七阶段选题机制，**正式题库 36 条**（SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1）；Hugging Face Daily Papers 为重要发现源，但**频道不局限 AI 科技**。这一批尚无经正式批准的 `STORYFIT_GO`，原题库静态等级也不自动升级。

## 2. 三方职责与交接流程（已经锁定）

- **Reviewer（ChatGPT）**：负责编辑决策、研究/权利/叙事/视觉独立QA、明确 GO/HOLD/RETURN、编写**可直接转发的纯文字 Codex 指令**；通常代 Owner 处理普通编辑选择。
- **Codex（Owner Windows 本机）**：执行具体可授权的读写/渲染/测试，产出**单一验收 ZIP + SHA256 + manifest + 原始证据 + 交接**，保留原始失败/归档；不能用自己报告 PASS 取代 Reviewer 的独立验收。
- **Owner**：传递文字指令给 Codex、将 Codex 输出 ZIP 上传 Reviewer；仅在创意/审美关键点及外联、费用、版权特殊风险、实际文件删除、正式 Gate 晋级/发布等事项作独立授权。预期主要正式审美签收两次：**R2 故事+视觉**、**R4 第一版完整草片**；目前首期 R2 **没有 Owner 正式视觉签收**。
- **永不默认为 Reviewer→Owner→Codex 反向下载一个 Reviewer ZIP**。Reviewer 的反馈写进下一轮文字指令；只有不可从原始输入重建的特殊人工修改，才额外给必要附件。
- GitHub 留**正式代码、协议、经批准复用模板、关键里程碑**；普通轮次 QA 证据和视频留本机 `.local/handoff-zips/` 并由 Owner 上传 Reviewer。Codex 已建立或可以沿用 `curious-world-studio/.local/notes/PROJECT_BRIEF.md`、`RUN_INDEX.md`、`SOURCE_RIGHTS_LEDGER.md`；整个 `.local/` 被项目 `.gitignore` 忽略。正式规范以 Git 主线为准，私有笔记仅是方便执行的缓存。
- 不要为每个新 ZIP 另开 GitHub PR/新增审查报告；本交接属于跨聊天重大状态整理。

## 3. 已锁定的视觉、真实素材与制作边界

### 3.1 画面 / 模板

- **Research Aqua V2**：A = 经典 Mac OS X Tiger/Aqua 桌面、Finder/文件和鼠标真实动效；B = QuickTime 7 风格的大尺寸真实视频播放器，尽量铺满屏幕；不额外发明第三 C 状态。
- **1920×1080、30fps、横屏、单行中文字幕**；正式素材默认优先 16:9，必要的真实竖屏证据可 `contain` 或合规分栏，不能拉伸/裁掉关键科研事实。
- `STYLE_LOCK.md` 及 V2 reference HTML 是正式视觉真源；`P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md` 中的 2/4/6 Aqua 对齐是规则/设计提案，不等于节目样片视觉 PASS。

### 3.2 素材「3＋1」（Owner ACTIVE，禁止自行换合同）

1. **① 研究第一手**：原论文、研究作者/实验室/机构的真实录像、补充媒体与原图；逐项核来源、内容、实际影像时码、具体复用权。
2. **② OpenMontage**：通过已有 Pexels/Pixabay 等适配器取**真正相关、可合法使用的实拍素材**。不能冒称论文实验。
3. **③ yt-dlp**：对**已知有适当获取/复用许可**的页面和视频作元数据提取/下载的工具，**不是独立素材库或许可证明**，可与①重合。
4. **＋1 Codex 后期仅允许 2/4/6**：2 转场衔接、4 画面布局/对照、6 信息和来源呈现/字幕。已决定**默认不采用** 1 镜头运动、3 聚焦强调、5 变速/重复等时间控制、7 额外滤镜/UI特效；已有 A→B 桌面固定行为例外。

**严格禁止**：AI 生图/生视频填缺口；用代码/SVG/Canvas画真实物体、动物、实验装置或机制伪装真实证据；用重复/镜像/变速/循环或长段静态PPT来凑镜头；把 stock 视频/音轨冒充论文实验；未获明确授权就付费、外联、发布、下载权利未知的研究媒体、改VPN/系统工具或删除文件。

**每条素材的三项独立状态**：`LINK_FOUND`（页存在）≠ `CONTENT_VERIFIED`（真实看见所需动作）≠ `REUSE_RIGHTS_VERIFIED`（具体素材合法复用）；“能播放/能下载/论文开放获取”不自动授权发表或商用。需要 `source_url`、作者、具体输入/输出时码、标签（原始实验/论文证据/独立复现/辅助素材/示意）、许可、去重、credit等。

## 4. 首期的实际经过与独立 Gate（按先后）

| 阶段 | 原始 ZIP（SHA-256 全值） | 交付事实 | Reviewer / 最新状态 |
|---|---|---|---|
| **R1 原研究** | `CWS_MAIN_R1_CW0002_CW0005_READONLY_20261011.zip` · `2ba13a873e78d59114ecacdab151d29128cb492835ffb6e3e8d3726b16f1da28` | 大象 CW-0002 vs 爆米花 CW-0005；原始文献、权利、三段故事，8项文件核对；视频未成功播放 | 研究资料合格，但正式 Story-Fit HOLD |
| **R1 影像补证** | `CWS_MAIN_R1_MEDIA_PLAYBACK_RIGHTS_GATE_20261011.zip` · `aec5116082f67d78aac1758fc1af2f769d8781f33236b933d0f511a972a5f0b7` | 大象 MOESM2 可播放约50s，MOESM3–5 抽样；无法可复核地连续识别注意变化、等待/回应/再示意，研究附件版权未核；爆米花论文 Movie S1/S2 未播；9项核对 | 大象 **CONDITIONAL_SOURCE_GAP / HOLD**，不再围绕同段无限重试 |
| **R1 素材优先三题** | `CWS_MAIN_R1_FINAL_ASSET_FIRST_CW0004_CW0005_CW0008_20261011.zip` · `8c1ae32d7b3cae70a5a5f83bf28fc36c07ff31ffaf51283c58a88ba2d3e38218` | 选项意面 CW-0004、爆米花 CW-0005、手指皱纹 CW-0008；研究和网页候选，所有候选视频未播放，11项核对 | 执行端 `HOLD_ALL`；Reviewer 条件性选择 CW-0005 先做**设计**，不是 STORYFIT_GO |
| **R2 条件设计** | `CWS_MAIN_R2_POPCORN_CONDITIONAL_DESIGN_MEDIA_GATE_20261012.zip` · `af8c517ba4bf4a630804b49749dfdd24e796d7a7fb7b5163d4643acaa9714c74` | 100–112秒故事初稿、逐句镜头表、三个 Aqua 2/4/6 HTML 离线概念稿；Pexels/Pixabay 官方网页能播放，官方下载按钮超时，无本地解码，16项核对 | ZIP PASS，设计初稿 KEEP 待修改；**R2_MEDIA_GATE_HOLD**；三 HTML 仅概念，无正式视觉 PASS |
| **R2-M1 媒体与剧本修正（最近、最重要）** | `CWS_MAIN_R2_M1_MEDIA_PATH_STORY_VISUAL_REVISION_20261012.zip` · `84991ca226e060624eaf7a4ca7c5ade411f8f5f70ab17ee94899e2b0e44b805f` | OpenMontage两个适配器各调用一次；两条 MP4 本机取得、FFprobe/FFmpeg解码并抽六帧；50–60秒新版口播与 S01–S10 镜头缺口，19项核对；**研究跳跃核心画面仍缺** | 技术/包 **PASS**；正式结论 **`CW0005_VISUAL_STORYFIT_HOLD`**；没有 `R2_MEDIA_CANDIDATE`，不制作30秒样段，不进入 R3 |

> R2-M1 中“获取/解码成功”是 Codex Windows 本机日志+FFprobe与六张图片相互验证，Reviewer 独立复核文件哈希/图片、没有拿到真实 MP4 全片。历史 R1/R2 各包可重建完整证据；新 Reviewer **不要重新跑完四轮相同调查**。

## 5. CW-0005 爆米花：已证事实、实际素材和剩余硬缺口

### 5.1 论文事实与可讲的三层理解

一手论文：[*The physics of popcorn*（2015，Royal Society Interface）](https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/)。中文工作角度《为什么爆米花会跳起来，还会发出“啪”的声音？》。**全文已读取并设计过两版剧本；不等于节目通过。**

- **节点一**：温度实验是群体统计；每档加热5分钟，170°C **17/50** 粒爆开，180°C **48/50**；不能说单粒有固定开关温度。
- **节点二（必须靠真实画面兑现的核心）**：独立跳跃实验使用约350°C热板和约2,900fps高速摄影。论文事件相对时间约 **6.9ms 裂开、13.8ms 淀粉脚受压、20.7ms 反弹**；研究未观察到“蒸汽火箭式喷射”。这些**是论文事件时间，不是任何 stock 片源的时码**。现在没有获准且能看清“淀粉脚压缩—反弹”的真实连续片。
- **节点三**：声音是另一套实验/麦克风测量，约 **100ms 二次裂开、106ms 响声开始、持续约50ms**；压力变化使空腔振动等仍是**作者假说**，不伪称直接证明或用 stock AAC 音轨作研究声音。

### 5.2 已成功从 OpenMontage 获取并解码的两条普通库存视频

| 资产 | Codex 的原始媒体检查 | 画面能证实什么 | 许可与目前限制 |
|---|---|---|---|
| **Pexels 854959**，[页面](https://www.pexels.com/video/cooking-popcorn-854959/) | `pexels_video` 查询 `cooking popcorn`，ID恰好匹配；20.223s，H.264/AAC，1920×1080，29.97fps，MP4 12,011,169B；SHA `D5CACBD2A8158A8B26C3B4E18F43168533B0D7DDA25EC67DE37A39E864385C78`；0.5/10.0/19.5s抽帧 | 锅中未爆玉米与白色已爆粒；三帧没有单粒破裂→脚受压→弹起的轨迹 | 官方 Pexels 页和平台许可可访问；具体全片、音轨及第三方权利未逐条看完，台账 `PARTIAL`。**仅普通辅助画面候选**。 |
| **Pixabay 2793**，[工具返回页面](https://pixabay.com/videos/id-2793/) | `pixabay_video` 搜 `popcorn popping` 返回作者 jLasWilson、**ID 2793（不是此前指定 37441）**；25.7267s，H.264/AAC，1920×1080，29.97fps，MP4 15,256,111B；SHA `8C6ED307EF0FF4FC666EF169BE2CC410AD91DEC01B1F003C651B9E92D07E43D7`；0.5/13.0/25.0s抽帧 | 锅中有粒子运动、部分离锅，但不形成同一粒的机制证据 | 平台 Content License 摘要可读，资产详情页常规打开失败，具体逐项权利 `PARTIAL`。**不得偷换成 37441，也不批准直接嵌入正式片**。 |

原 MP4 **仅保留在 Codex 的本机忽略目录** `.local/R2-M1/provider-output/`，**不在验收 ZIP 中**；ZIP 内有六张 JPG 帧、两份 FFprobe JSON、日志、修订稿及权利表。两条视频的 API 下载/本机解码属于**已打通的技术能力**，不得再写成“OpenMontage 没有办法下载”。但**仅抽三帧**不能断言两份视频全片每一帧都已经经过视觉检查，更不能推出核心机制已存在。

### 5.3 为什么停下来

- 逐句分镜 S04–S06（约稿件 13–30 秒）必须显示**实验高帧率真实录像、淀粉脚的形成/受压和反弹**；现有 stock 仅有锅内一般活动，**无法代替实验机制**。
- 2015原研究 **Movie S1/S2** 的合法可访问录像及逐文件具体复用权未落实；**状态 UNKNOWN 不等于已被拒绝**，但未授权不能擅自下载/使用。
- R2静态 Aqua 2/4/6 三 HTML 对布局有参考价值；**没有有意义的连续媒体、已完成字幕/配音，也没有 Owner 第一次正式审美签收**。
- 已缩短、修订剧本为约50–60秒；缩短没有消除 S04–S06 的关键影像缺口。因此由 Reviewer 明确认可 Codex 建议：`CW0005_VISUAL_STORYFIT_HOLD`。

## 6. CW-0002 大象、CW-0004 意面、CW-0008 指皱纹：只保留已证结论，不擅自切换

- **CW-0002 大象**：动物认知论文原研究一手核验，部分带动作标签的补充 MP4 已由 Codex 播放；但“视觉注意状态改变”“回应等待”“持续示意”的可复核连续镜头不充分，4个补充 MP4 单独许可未明。`HOLD`，不是坏题或论文错误。论文入口：<https://link.springer.com/article/10.1007/s10071-026-02108-7>。
- **CW-0004 意面断裂**：MIT 等一手机构资料提供理论和图像线索，缺可用的断裂高速实拍和明确可复用许可；2018扭转控制实验与更早弯曲波研究不得混同，原 R1 评估 `HOLD`。
- **CW-0008 泡水手指**：可见皮肤起皱不等于证明特定任务中握力/摩擦差异；视频和实验指标不匹配，原 R1 `HOLD`。
- **前任 Reviewer 曾建议下一次小范围预检 CW-0004/CW-0008，并提供过 Codex 提示词。Owner 最新明确“先不换题”**：此提示词**不是待执行命令**。不得自行重新比较三题或自动替代 CW-0005。

## 7. 技术和视觉支线：已经有什么、尚未达到什么

- **源码**：Remotion/FFmpeg 媒体适配器在 `p4-g1/m1-media-adapter/`，PR [#116](https://github.com/entropy-student/project/pull/116) 已合并，两个源代码 blocker 曾经修复并核对；有独立 M1 9秒1920×1080@30fps H.264 无声样片、M2 横屏24fps/竖屏30fps兼容性测试，以及唯一 F2 再渲染回归。**这些是工程测试，不是正式节目的完整音画/版权/发布 Gate**。
- **历史风险**：旧第184帧偶发读取失败根因仍 UNKNOWN；6x 渲染可用内存低至 221.86MiB；一次 F2 观察器后处理 exit1、并未证明渲染器失败。下一次正式长片前须有可观察的并发/内存/回滚方案，勿反复重跑旧9秒夹具。
- **音频**：Windows 共享 OpenMontage 已有合法 Pexels/Pixabay 适配器；云端 Qwen TTS 音色偏好为 `longzhe_v3.1`，但**正式长视频旁白、音画时码、单行中文字幕同步尚未完成 QA**。不把过去12秒 OpenMontage 工具验收推导成第一期成片就绪。
- **yt-dlp**：历史验证过安装与指定合法测试直链下载（Blender/Sintel），同时存在 YouTube 元数据登录挑战。仅证明具体测试直链与合规工作方式，**不证明任何第三方节目素材复用权或 YouTube 通用下载已PASS**；不擅改代理、VPN、Clash 或登录绕过。
- **Mac窗口动效独立支线**：原 A→B 的V2底座保留；第一批5个和第二批4个 Demo 曾返工/Review，第二批 MW11/MW12/MW13、最终 MW07 为 Reviewer 的 KEEP 候选，**Owner Windows Edge `file://` 常速审美签收尚待确认**。MW07最终包 SHA `57c6644583b4a2d149295a861087fc71c62041ddac7a0ae82192c959311361f2`，HTML SHA `6bd889e5b7487c5ef94fc36693941fb96298023190f9db0422bf1c9854f34551`。**停止新增/无限精修动效**；Demo 不能自动进入正式 B 主影片。
- **本地清理已结束**：723项/71.93MiB 的只读初检、174个保护/候选冲突与74个旧Temp遗漏已通过独立分类纠错复核，**248项纠错核对、证明安全可删0B、实际删除0项**。最新纠错 ZIP `CWS_CLEANUP_AUDIT_CORRECTION_20261011.zip` SHA `921c6414f7babcf23ce6f362f9dd2287971ab1bf0285945ee16896dc25f11ccb`。不再为腾这点空间重做审计；不得删除旧媒体证据或混动其他项目。
- **严格状态**：`M2_CODE_MERGED` ≠ `G1_PASS`，`R2_DESIGN_DRAFT` ≠ `STORYFIT_GO`，`R2-M1_MEDIA_DECODE_PASS` ≠ `VISUAL_STORYFIT_PASS`。**`G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`**。

## 8. 从暂停状态恢复时，应怎样讨论，而不是直接运行

**现在没有下一条 Codex 任务。** 新 Reviewer 不应对 Owner 说“已经切到CW-0004”“接下来立即执行 R3”“继续追爆米花几轮”。如果 Owner 主动要求恢复，再按其新方向讨论以下**可能性**，且不预先视为授权：

- **若继续爆米花**：先确认是否允许一次严格有界的原研究 **Movie S1/S2 许可与实际可见动作**调查。目标只验证“淀粉脚—受压—反弹”的画面是否真实可看且可用；不得靠库存冒充、不无限重试。若仍失败，保留 `HOLD`。
- **若用户改愿意换题**：可从已保留的 CW-0004、CW-0008 等历史证据出发；但必须等待新的明确选择，不自动执行前任提案。
- **若用户重新审视节目表达**：需要 Owner 主动改写3＋1真实素材合同；Reviewer 不得自行启动 AI 图/视频、实体矢量绘制、PPT 替代中段。
- 若有新证据确实满足 Story-Fit 与复用权，**先 Reviewer 独立审核，再交 Owner 第一次 R2 故事/视觉签收，之后才决定是否授权 R3 30–60秒完整真实音画联调**；以后 R4 才是自然时长第一版草片，不代表自动公开发布。

## 9. 权威文件、历史材料与读取顺序

**唯一活状态与规范：**

- [当前状态 `docs/CURRENT_STATE.md`](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/CURRENT_STATE.md)
- [项目 `AGENTS.md`](https://github.com/entropy-student/project/blob/main/curious-world-studio/AGENTS.md)
- [频道定位 `docs/CHANNEL.md`](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/CHANNEL.md)
- [3＋1正式素材合同](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)
- [Research Aqua + 2/4/6规范提案](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md)
- [Style Lock](https://github.com/entropy-student/project/blob/main/curious-world-studio/visual/retro-mac-v1.2/docs/STYLE_LOCK.md)
- [主线R1→R4三方泳道](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)（旧“R1刚下发”描述是历史时态）
- [正式选题流程](https://github.com/entropy-student/project/blob/main/curious-world-studio/research/topic-bank/WORKFLOW_V1.md)、[题库](https://github.com/entropy-student/project/blob/main/curious-world-studio/research/topic-bank/BOARD_V1.md)
- [2026-10-11详细技术历史汇总](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/PROJECT_HANDOFF_2026-10-11_POST_MERGE_CANONICAL.md)（历史快照，不作最新指令）

**下一 Reviewer 最应复查的 ZIP**：R2-M1 → R2 → R1三题 → R1影像补证 → R1最初研究（完整哈希见第4节）。历史独立Mac、M1/M2、清理的大型ZIP留本地/过去对话中，除非专门审它们，不需一开始重新下载。

## 10. Reviewer 接手提醒 / 不可遗漏的未定事项

- 暂时没有获准的正式第一期；CW-0005为**已停止投入的条件性设计成果**，不是完成作品；**Owner 最新不换题 ≠ 强制继续推进 CW-0005**。
- 三个 Aqua HTML 只是概念，不是 30 秒真实节目；R2修订稿仅50–60秒并且 S04–S06 无合法核心影像。
- 正式电影旁白/单行字幕/配乐、授权来源、长期渲染、Owner视觉第一次签收、G1/G2、发布以及实际观众测试均未通过。
- 不要“写了同样的状态”就让 Codex再生成 PR、reviewer ZIP 或多份临时文档；恢复工作时坚持明确目标、停止条件、一个 ZIP 的闭环。
- **本轮只交接，不授权任何新执行。** 下一位 Reviewer 读完文档后，向 Owner 回报“已接手，当前暂停且不换题，等待后续指示”，无需重新问已回答的问题。

---

**一句话总括**：节目定位、Research Aqua 与 3＋1 素材规则已锁；OpenMontage 的两条爆米花库存视频已由 Codex 获取并解码，证明获取链可用；但中心科学现象「淀粉脚受压、反弹」无可信、权利明确的真实连续画面，CW-0005 依照停止规则维持 HOLD，R3/G1/G2 未放行；**Owner 现决定先不换题，项目在此暂停，等待其下一步明确决定。**