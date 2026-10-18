# CWS｜CW0005 PR#155真实交付独立Reviewer报告（2026-10-18）

> **正式判定：`RETURN_PROCESS_COMPLIANCE`（Owner预锁）、`TECHNICAL_VIDEO_PASS`、`IMAGEGEN_PARTIAL_PASS`、`STORYFIT_PRELIMINARY_IMPROVED_OWNER_UNVERIFIED`、`VOICE_BY_EAR_UNVERIFIED`、`RIGHTS_PARTIAL / NO_PUBLISH`。** 本轮流程退回不因MP4成功或画面有所改进而转PASS，亦不能据此否定已接受的模板/成片解码技术。
>
> **证据来源**：Owner本对话上传`CWS_CW0005_POST_PR153_TARGETED_VISUAL_REPAIR_20261018.zip`；[PR#155](https://github.com/entropy-student/project/pull/155)的执行报告HEAD `23e28fb52a8e67064aa83cab94ec81369fecd33d`，一文件52行纯脱敏记录，当前Open/未合并；[Reviewer正式PR评论](https://github.com/entropy-student/project/pull/155#pullrequestreview-5563112017)；[Owner已锁定流程审计决议](CW0005_MEDIA_SEARCH_DOWNLOAD_PROCESS_COMPLIANCE_RETURN_2026-10-18.md)与[3+1正式取材合同](../VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)、[项目C类图强制规则](../AI_IMAGE_GENERATION_EFFICIENCY_REUSE_GUIDE_2026-10-16.md)、[既有工具文档](../MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)。

## 1. 规范与实际交付完整性

- 上轮已独立获取、核SHA、扫描项目**159/159份**文本，见[覆盖清单](CWS_FULL_PROJECT_DOCUMENT_COVERAGE_MANIFEST_2026-10-18.md)。本轮再次遍历GitHub最新`main`得到**162份文本**，与清单Blob对比：**154份逐字不变、8份新增/发生变更**，后者再次获取并核对；上位`spike.skill/vps-project-governance/VNEXT.md`为**609行**、blob `3917c88a7f36df7a53758b3879a92703d659ef9d`。**这里区分机器全文获取/摘要和人工对关键现行制度逐项核验；不虚称逐句核改154份旧史稿的事实正确性。**
- Owner提供ZIP：Reviewer独立算得`9d81ff112bd634f7418b5ec568a731847246a84995dfd918a62960e67e6027dd`，与上报完全一致；66成员，`SHA256SUMS.txt`的65个成员逐个对照均PASS，ZIP内部成员路径不越界。
- 正式MP4 `CW0005_TARGETED_VISUAL_REPAIR_INTERNAL.mp4`：Reviewer实际读字节SHA-256 `acd29f628d5fb83ac3bf817cc522b7e0ad1b5183c38ea21634ef6c887011ca24`、8,051,145 bytes；FFprobe 1920×1080、H.264、30fps、59.933333秒、AAC mono，独立FFmpeg全片解码PASS。第一版是另一个有独立哈希的59.933秒候选，仅存在于ZIP`media/superseded`；交付称因S06文字暗示的运动强于静图而修正，**累计两次渲染，没有第三次渲染证据**。
- ZIP中的`evidence/browser-playback.json`记录Executor在隔离Edge 1倍速播放到ended、单调currentTime；Reviewer本地未重演Owner Windows独立Edge，不能把其报告冒作Reviewer实测。交付中有原版和去静音WAV/SRT/ASS，录音`VOICE_BY_EAR_UNVERIFIED`未改变，不能视为已听审PASS。
- V5.6.2冻结Mac HTML Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`保持，PR#155无任何正式代码、视频、生成图片等Git变动；不是自动构成完整生成链可复现PASS。

## 2. Reviewer实看画面结果（不改变Owner审批）

- 直接从最终真实MP4跨片段抽检0.5、2、4、5.4、6.4、9.9、13、16.5、20.4、24.7、26.7、29.2、33.9、38、41.3、44.4、48.9、52、55.6、59.7秒等帧，另直读三张AI原图。相较PR#153单一锅内视频背景42.966秒，此片**真实看到Research Aqua桌面/研究文件→QuickTime打开→最后关窗返回桌面**，科研图被置为画面主体，不再把整个科学解释伪装成库存Pexels实拍。
- S01 Pexels #7677397是粉色爆米花在黑色背景下落的库存慢动作，画面标`辅助素材/非研究录像`，没有谎称真实研究跳跃录像。
- S02–S03 T6可读`170°C 17/50`与`180°C 48/50`且明确是统计样本而非每颗确定阈值。S04–S06 T5以真实3张不同静态示意表现脚形成、压缩、回弹；没有PR#153那种橙色火箭尾焰。**S06回弹示意仍显示足部接触板面，不能单凭这张图证明完全腾空**；执行者的第二次渲染把措辞收窄为“回弹、颗粒开始上移”，比原候选谨慎。三态在影片里持续约22.133秒（形成7.740/压缩1.789/回弹12.604秒），**整体视觉仍偏静态，最终节奏/审美须Owner实际观看**。
- S07–S08 T6确实显示**第二次破裂100ms、声音开始106ms、差值+6ms**，标明独立声学实验；S09–S10以左右信息比较区别研究解释与作者声源假说，收束清楚。视频没有复制论文原Figure或电子补充研究视频。
- 仅据实际截图可以确认视觉结构/画面内容，**不能替代真实听辨或发布许可审查**。故`VISUAL_REVIEW_IMPROVED`，不是`G1_PASS / OWNER_STORYFIT_PASS`。

## 3. C类静态生图独立分项

- ZIP`concepts/foot-formed.png`, `foot-compressed.png`, `foot-rebound.png`三个真实文件，各自SHA分别`01feb9028de95d89ebbebd80e562bdda35d901462a76c5b6e150ef893fab0e63`、`337a9a623806b1257edf3456ca5cfbc5fe6d9ed3cad800933495e026d395c828`、`954ca9bbf2eeda70ea11add8822080738d4e354912c4c3f6e50a3d24bc4b0843`，与`imagegen-efficiency.csv`吻合。均1672×941，仍为可按16:9裁切/contain的源图，未因原生非1080p而无效重生。
- `IMAGEGEN_DECISION_REGISTER.md`描述检查旧图→拒绝含火箭射流旧稿→只有必要三态才新生成；`IMAGEGEN_WORKFLOW_AND_CALLS.md`/`imagegen-efficiency.csv`记录`output_hint`ID、明确SourcePath已在私有前缀下脱敏、源/目标SHA一致、每张1次、编辑0、重试0、最大并发2；`fastpath-fixtures.json`提供6个parser正负例PASS。**可核验证据较PR#153明显增强**，不过真实Codex并发/网络调用、官方返回原始控制台、复制时点及原源文件源hash均不能从ZIP独立重放，因此`IMAGEGEN_PARTIAL_PASS`（本期范围的低浪费策略有报告支撑），不能证明“实测最低Token”。Token/付费/单次耗时均未计量，按项目准则诚实标`TOKEN_SAVING_NOT_MEASURED`。

## 4. 决定性流程缺口（Owner已预锁RETURN）

| 子环节 | 当前实际证据 | 本次独立结论 |
|---|---|---|
| 原已验收库存先查、旧四条视频作品级不复用 | 报告/分镜指出R3/PR#153四源禁重复，本片仅新#7677397 | `PARTIAL_PASS`，历史禁止使用已遵守；跨平台近似同源查重无独立系统证据 |
| 多平台候选发现 | **仅留Pexels #7677397最终URL**；没有原始关键词、SearXNG/4get、OpenMontage/Pixabay候选列表/结果数/失败降级 | **`RETURN_DISCOVERY_PROVENANCE_MISSING`** |
| 候选比较/实际内容预览/相关性排序 | 有五张Pexels预览、1条真实素材和使用理由；没有多平台及各候选排除表 | **`RETURN_CANDIDATE_SELECTION_UNVERIFIED`** |
| 下载与源媒体技术QA | Pexels正常Free按钮动作由Executor描述，曾有一次隐藏下载定位器超时；已存源文件报告SHA`c2600c7...`、1920×1080/25fps/9.84s、解码PASS；ZIP只有5帧和转入成片的片段，无原源媒体 | `PARTIAL`：真素材与规格及画面可核，原始请求、选源ID、重定向/时间日志不可独立复算 |
| 七层数量闭环 | 缺`FOUND→DEDUPED→PROBED→DOWNLOADED→FULL_DECODE→ACTION_VERIFIED→RIGHTS_VERIFIED`源/平台分层统计 | **`RETURN_SEVEN_STAGE_EVIDENCE_GAP`** |
| 媒体出处/版权 | Pexels官方[作品页面](https://www.pexels.com/video/flatlay-popcorn-on-table-7677397/)显示Mikhail Nilov、1920×1080/25fps；[官方Pexels License](https://www.pexels.com/license/)允许一般免费媒体使用与编辑，仍受其约束；第三方权利/节目正式审核未完成 | `GENERAL_PROVIDER_LICENSE_CHECKED / PROJECT_RIGHTS_PARTIAL`，不自动上升发布权限 |
| 生产链再现性 | ZIP交`storyboard-v2.json`、媒体清单、关键帧/QA，但缺所有已用工具版本/完整可重放运行命令、外部视频源下载请求 | `REPRODUCIBILITY_PARTIAL`，后续只读找旧日志，不为补证据另渲 |

**原则**：3+1是三种可能的获取**路径**，不是必须每期三个渠道各使用一条；但Owner明确要求过“按镜头需求多平台并行搜集→合并去重/实看→选用→定向补搜”，无留存查询与候选比选证据便不能判该流程合规。**缺日志≠独立证明完全未调用SearXNG/4get或其它服务**，所以不可编造其运行失败或从未使用。

## 5. 边界、下一步

1. **正式锁定`RETURN_PROCESS_COMPLIANCE`，但不要求回滚/删除两条59.933秒片、三张图、音轨或现有成果。** Codex的`PASS_CANDIDATE`仅有界承认有效交付和技术候选，不代表内容/素材制作通过。
2. **仅需精确补齐来源证据/下轮执行合同**：优先只读查此次既有`.local`查询索引、浏览器特定素材页关联日志、OpenMontage/MEDIA已有候选台账，若真的没有就标`HISTORICAL_UNVERIFIABLE`；**不得为编造历史而重搜/重下载**。后续已获新媒体授权时按每镜头真实缺口选最小相关平台候选，将多来源搜索/去重/逐个动作预览/权利/SHA七层台账固化为报告，只有仍不够才补搜，禁止“每集强制三路/80站”。科学及样式问题依Owner实际看本条视频后决定。
3. `PR#155`只有真实证据报告，保留Open/未合并，不能因技术成功而将其标为合规PASS/自动合并。此前关闭的PR#154不恢复。
4. 项目正式状态不变：`V562_TEMPLATE_TECH_PASS / CW0005_55S_MP4_TECH_PASS / CW0005_59S_MP4_TECH_PASS / RETURN_PROCESS_COMPLIANCE / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH / RIGHTS_PARTIAL`；`VOICE_BY_EAR_UNVERIFIED`。

**审查独立性**：同一个ZIP的哈希、图片像素、MP4画面与直接媒体探测属于本Reviewer直接证据；关于Owner Windows浏览器播放、网络调用、实际并发及源文件完整SHA仍属于Executor报告，绝不混淆。
