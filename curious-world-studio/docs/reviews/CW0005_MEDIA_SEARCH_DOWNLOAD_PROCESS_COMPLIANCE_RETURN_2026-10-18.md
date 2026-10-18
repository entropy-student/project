# CWS｜CW0005素材搜索与下载流程独立审计（2026-10-18）

**Owner预先裁决并正式保留：`RETURN_PROCESS_COMPLIANCE`。** 本轮只处理素材生产方法是否遵循现行项目合同与证据，不重新评价已经通过的MP4编码技术、固定模板，也不把这次RET​​URN描述为画面审美FAIL。先前单独判定的`RETURN_VISUAL_STORYFIT`作为历史视觉事实并行保留，但**此次原因是流程**。

## 一、完整读入和证据身份

- Reviewer已从GitHub权威 `spike.skill/main:vps-project-governance/VNEXT.md` 读取**v0.2.7全文609行**，按§0–13及11A–11G核触发；审查涉及Owner Windows文件证据、MEDIA Docker资源/联网生命周期及图像处理。未修改跨项目Governance。
- 递归遍历CWS `main`源码树并对**159/159份Markdown/文本、JSON、YAML和HTML材料**逐份获取完整Blob及核对SHA，无失败；另外列明26个非文档扩展名源文件，其中重点检查`media-pipeline/cws_media.py` / `media_pipeline.py`与README。全量路径/哈希/大小在[文档覆盖清单](CWS_FULL_PROJECT_DOCUMENT_COVERAGE_MANIFEST_2026-10-18.md)。**全文程序扫描不同于对每份历史研究稿的逐句人工作事实核验**；现行规范/核心执行报告已人工全文核读，避免声称对旧研究稿逐句事实复核。
- 直接核查：`docs/VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md`、`docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`、`docs/MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md`、`docs/MEDIA_PIPELINE_WINDOWS_USAGE.md`、`docs/MEDIA_OPERATIONS_AGENT_ENTRY_GATE.md`、`media-pipeline/README.md`、`docs/MEDIA_R6L_R7L_FAST_MATCH_PILOT_2026-10-15.md`、`docs/CWS_CW0005_COMBINED_STORYFIT_SOURCE_TO_SAMPLE_GATE_2026-10-18.md`、`docs/CWS_CW0005_POST_PR153_TARGETED_STORYFIT_REPAIR_GATE_2026-10-18.md`、`docs/reviews/CW0005_COMBINED_STORYFIT_EXECUTOR_2026-10-18.md`与PR#153。
- **证据强度边界**：PR#153只有Executor文字报告，Reviewer可查GitHub提交和Owner先前上传的完整成片；**本次不能直接访问其Windows历史浏览器/搜索API日志/缓存/下载CLI事件**。所以“没有调用SearXNG/4get”是`NOT_EVIDENCED`，**不是**“经独立证明从未调用”；要靠下一轮本机只读追溯判别。

## 二、逐项合规对照（事实与未知分开）

| 序号 | 权威项目要求 | PR#153实际可见证据 | 本轮判断 |
|---|---|---|---|
| 1 | 以已冻结R2的S01–S10划分视觉需求，搜索中不得为素材改文案 | Executor称复用原R2十句及既存WAV/SRT | `PASS_BY_RECORD`，逐镜头需求到候选关系不完整 |
| 2 | 多平台并行发现候选，合并去重、按实看动作/差异排序，未覆盖缺口才定向补搜 | 仅写“一个Pexels结果页+三个Pexels直接素材页面”，没有其它来源的搜索统计、失败或选择原因 | `RETURN_EVIDENCE_MISSING`；不是“3条来源渠道必须各用一次” |
| 3 | 首先查询已验收既存素材/来源与研究原图，区分可用及不足；不盲重复全库 | 已说明论文Figure 1/3a/6/S1/S2因来源访问受限未使用、旧R3素材被禁复用 | `PARTIAL`：论文限制及旧源记录成立，既有多站候选/索引是否先查未证明 |
| 4 | 技术搜索入口 `cws_media.py discover` 按需启用SearXNG/4get并记录每引擎类别、候选与退化；若需跳过，明确原因 | 无`discover/catalog`运行证据、引擎计数、`PARTIAL_SEARCH`或有根据的`NOT_APPLICABLE`记录 | `UNVERIFIED`；工具已在main完成技术验收，但未证明这次成片实际调用 |
| 5 | URL/源身份去重、整个项目原视频一源一用；不同文件名、站点、剪切不产生新身份 | 报告选Pexels #1796141/#35876717各连续一次，未复用旧#854959/#2793 | `PARTIAL`：当前已知四源无直接冲突，未有系统性跨来源作品身份/转载校验的本轮审计记录 |
| 6 | 候选选择前核验画面、来源、作者、内容与出版权限；图片/视频为不同资产类型 | 浏览器实际预览三条Pexels，#3752542因不相关排除，两条视频标签为“辅助素材”，权利PARTIAL | `PARTIAL`：单站三个候选有内容初检；跨来源比较、许可与署名的逐件决定仍不足 |
| 7 | 明确选定ID后才有限下载，视频默认横屏≥4:3、优先1080p，未知格式探测；最后真实格式读回 | 3条Pexels媒体已下载/探测，#1796141实际720p，另两条1080p；报告承认720p并放大 | `PARTIAL`：720p备选不是自动违规，缺“为什么无1080p更合适方案”和显式选型/下载通道及例外记录 |
| 8 | 搜索URL→去重→可探测→真实下载→技术解码→内容吻合→复用权利七层分开计数和结论 | 真实下载3/选用2、实际画面预览及FFprobe/FFmpeg结果，缺完整的搜索基数、跨源去重数、探测失败数/来源权利清单 | `RETURN_EVIDENCE_MISSING` |
| 9 | SearXNG/4get按需启动后正确清理仅属于本项目的容器/端口；直接网页路径则标`NOT_USED`及原因 | PR报告只记录临时视频Gallery HTTP 127.0.0.1服务已停止，不足以代替MEDIA查询服务使用/清理审计 | `NOT_EVIDENCED_OR_NOT_APPLICABLE`，待本机检查 |
| 10 | 原论文版权及可读性，视频上传/公开发布单独审查 | 论文图及S1/S2未纳入成片，明记RIGHTS_PARTIAL/UNKNOWN/NO_PUBLISH | `BOUNDARY_PRESERVED` |

**特别纠偏**：
- “3+1”是合法取材**可选渠道**而非“每期须同时使用三个渠道”；不可为完成形式而强制下载多站冗余素材。
- “多平台并行检索”属于Owner已经生效的**发现与选择流程**。既有聚合器`SearXNG/4get`自身未必代表多个实际**来源平台家族**；需记录不同站点/平台家族及有效候选，而非只显示启动两个聚合器。
- `media-pipeline/cws_media.py`在当前源码中依次调用两个搜索引擎，并非可以据此声称两个请求物理并发；Owner的“多平台并行”应理解为合并候选搜集与比较策略，是否真实同时网络并发按实际实现留证，不能虚报。
- `cws_media.py`只是可复用可选搜索工具，不自动替代OpenMontage、论文第一手素材和正式制片选择器；**对未使用工具要求按事实记录`NOT_USED + 原因`**，不能把未调用直接判为运行时功能FAIL。
- 本次流程RETURN也包含Reviewer原Gate设计不充分：上一版联合Gate仅说“有限搜索/优先复用工具”，未将各站候选比较、平台家族、七层分开计数和有效跳过条件逐项冻结为强制验收；不应把缺项全归因于Executor个人。

## 三、需纠正的不是画面质量，而是可审的链路

**最小必须恢复的链路**：

`锁定画面需求→查已有库存与研究首手材料→按需对多个真实来源做候选检索（包括既有SearXNG/4get/OpenMontage等合规入口）→记录各站/各搜索引擎结果、失败/退化→合并去重→实看相关动作→作品级使用记录/权利→显式挑ID/核横屏/分辨率→合法下载→FFprobe/FFmpeg/SHA→分镜选用与排除原因→停止临时服务`。

最低审计材料：
1. 关键S01–S10视觉缺口→关键词/检索来源矩阵，提供每个实际使用平台/聚合器的时间、成功/失败、候选数量、平台家族与退出码；未使用的模块提供原因。
2. 四阶段候选集合（搜索结果、去重、内容预览、最终选用），仅保留可审的脱敏小表，不要求大规模缓存/下载。
3. 下载的真实提供方、所选ID、下载方式/退出码、落盘SHA/实际分辨率、权限状态、为何接受720p的说明和技术QA结果。
4. 历史四条已用视频项目级不再进入后续新成片；新的同源身份及是否与库存重复的依据。
5. 提供可独立检查的运行证据：GitHub报告可记录清理后的脱敏索引、结构化JSON/manifest与本机日志路径/指纹；如历史原日志不存在，应承认`HISTORICAL_PROCESS_NOT_RECONSTRUCTIBLE`，后续用**最小非生产演练**在新授权后证明流程，而不是编造历史调用。

## 四、锁定裁决与下一步边界

- **本轮独立裁决：`RETURN_PROCESS_COMPLIANCE`**；依据为Owner提前冻结该结论、当前PR#153搜索/下载过程证据对现行流程的覆盖不足。不是`RETURN_VIDEO_QUALITY`，也不是推翻`CW0005_55S_MP4_TECHNICAL_PASS`。
- 前一份2026-10-18尚未下发的`CWS_CW0005_POST_PR153_TARGETED_STORYFIT_REPAIR_GATE_2026-10-18.md`暂停执行，不能在未复核素材流程前制作新MP4/重新下载；Owner原先批准的**后续返修目标继续有效**，实际执行顺序和边界由新的流程审计Gate明确。
- **下一Gate只能先进行本机read-only取证与执行映射**：检查本地旧日志、catalog、CLI事件及源/下载证据，给出最小改进计划和实际可验证的下一次执行合同；**不新下载、不重搜整网、不生图、不渲染、不动源代码/共享服务**。如证据确实不存在，明确指出缺口，不为补历史而重试。
- 后续再合并合规候选搜取与视觉返修样片制作（如风险/权限兼容），避免四五轮形式化审批；但必须在当前`RETURN`的证据空缺已被分类且有新的实际写入边界时才能执行。
- 当前主状态仍`V5.6.2_TEMPLATE_PASS / CW0005_55S_MP4_TECH_PASS / RETURN_VISUAL_STORYFIT / RETURN_PROCESS_COMPLIANCE / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH / RIGHTS_PARTIAL`。
