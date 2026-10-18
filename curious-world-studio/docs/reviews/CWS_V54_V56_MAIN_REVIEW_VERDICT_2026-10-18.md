# Curious World Studio｜V5.4–V5.6 联合独立审核：主 Reviewer 裁决与下一任交接

> 日期：2026-10-18 ｜角色：项目主 Reviewer ｜**正式裁决：PARTIAL / RETURN_TARGETED_FIXES**。本轮仅 Review＋持久化，**未修改任何 HTML 业务源码**，未合并 PR，也未批准正式制片。
>
> **完整原始证据**：[外部Reviewer完整报告及主Reviewer浏览器原始复现](CWS_V54_V56_EXTERNAL_REPORT_AND_RECHECK_2026-10-18.md)。外部审核ZIP SHA-256：`0f0f48d3cc56b6f0ad9243452b7ead6b5d2f870444c70cab90d9c4a15e16e1ae`，原始报告 SHA-256：`7c4a36b5836499b2289f4aba1fc9c01cb30552fd659b3917268d4a08678831b4`；本仓库归档的是完整文本和复现JSON，**原ZIP里的测试截图、脚本和合成媒体未上传Git**。如需完整视觉证据，由Owner提供原ZIP。

## 1. 已证实的源码身份和权威状态

| 资产 | Git blob SHA-1 | 当前角色 |
|---|---|---|
| Research Aqua V2原版 | `acb0ee80264527bd11160e0ae277ce24528c4a03` | 唯一外壳视觉真源，不改 |
| main V5.2 `visual/frozen/storyboard-v5-2-20261017.html` | `f002fd3a3fea24352c8eddb63d8f265014a9e93b` | **唯一已冻结基线**，禁止覆盖 |
| Draft PR#144 V5.3.1 | `c74567d1c399d58ab96fb81303cf381250ab2ee2` | 八项既有修复候选 |
| Draft PR#144 V5.4 | `b7b880db77d42a9e35dcf3a833a68924cd4ef4df` | ⑬ 分镜JSON和素材映射候选 |
| Draft PR#144 V5.5 | `bbc6f40c1dd6bf1cc4b1c8ab4f55f49e0a13881f` | ⑩ 多句Cue及单旁白轨候选 |
| Draft PR#144 V5.6 | `a0213f7991968fabd3f36be99363310d27324422` | ⑨ T6通用数据候选，本轮审核对象 |

PR#144：[链接](https://github.com/entropy-student/project/pull/144)，状态已回读为 **Open / Draft / 未合并**。V5.6确切SHA-256 `aec92e0dda0cb3de3236b200189dcfaf797e9a27827536865efcefeb0d31ee83`，主Reviewer本轮本地文件按Git blob算法与仓库一致。

## 2. 联合审核最终判定

| 阶段 | 外部Reviewer结果 | 主Reviewer裁决与证据边界 |
|---|---|---|
| ⑬ V5.4 导入与素材映射 | PARTIAL | **接受**。导入/导出/原子拒绝、素材ID登记及精确文件名匹配有效；具体MIME子类型不核对，错误文件可静默改写登记，主Reviewer独立复现。 |
| ⑩ V5.5 多Cue及旁白 | PASS | **接受局部PASS**。旧V1→V2兼容、多Cue时间、WAV播放暂停跳转通过外部实测；它是**已给定时码的同步播放器**，不代表自动语音强制对齐/TTS/SRT或正式成片。 |
| ⑨ V5.6 T6数据 | PARTIAL | **接受**。四比较模式、负值、数据校验基本成立，但统计单位/极小值展示错误；主Reviewer独立复现。 |
| 三版本兼容 / Mac | PASS | **接受外部测试证据**：单Canvas、无第二播放器、9帧Canvas相等、V1/V2输入兼容；不要误解为长片制片验证通过。 |
| V5.6最终31.06秒1× | PASS | **外部Reviewer独立完成的实测PASS**：从0到31.06s停在原桌面、JS错误0、外网请求0；测试文件SHA-256明确对应最终字节。主Reviewer没有再重复整段31秒，证据等级标为“外部独立实测、主Reviewer检查报告与SHA”。 |
| 307.06秒压力测试 | PASS（跳转层） | 外部实测60镜头在40/150/298s仍显示播放器，并在307.06s关闭；**不等于五分钟有声MP4真实导出**。 |

## 3. 五项遗留问题——主Reviewer独立判断

| ID | 类别与严重度 | 已验证现象/根因 | 本轮建议 |
|---|---|---|---|
| **R-01** | T6统计准确性 P1，**必修** | 已导入`unit:" % "`且与另一项相同，校验只比较`trim()`后的单位，而T6显示依据原字符串与`'%'`严格相等；主Reviewer实测结果`+35 %`，应是`+35 个百分点`。**真正修复应归一化数据字段并让渲染及校验共同使用归一化值**，不是仅文字替换。 |
| **R-02** | 素材映射 P2，**建议修** | 注册`video/webm`，批量上传`video/mp4`能够绑定且登记被静默覆写成mp4；主Reviewer亲自以File API复现。批量自动关联应比较**完整规范MIME**，人工主动替换可明确征询/显示转换记录；MIME标签仍不是媒体字节或权利的真实性证明。 |
| **R-03** | T6精度与知识正确性 P2，**与R-01同轮必修** | 两值100000000和100000001用`change`，实际变化率0.000001%，`dataPrecision=3`却显示`+0%`；主Reviewer实测一致。非零数被四舍五入成0时应显示小于当前精度的正/负有界值（含符号），严禁称确为零；计算精度保留。 |
| **R-04** | T6默认柱尺度 P2，**建议同轮修** | 0.001与0.01两值`dataScaleMax`自动设至少1，导致柱宽0.1%和1%；主Reviewer已实测，外部Reviewer此前只有源码推断。应依据最大非零绝对值自动缩放，保留明确设置的刻度，全部零用安全回退；不能为获得视觉差异篡改数值。 |
| **R-05** | 编辑器元数据 P3，**顺手修** | V5.6页面仍显示“V5.5”，V2内容导出名为`CWS_STORYBOARD_V1.json`；源码已核对。仅改文字及下载文件名，保持Schema本身`CWS_STORYBOARD_V2`，勿破坏旧V1导入。 |

优先级决策：R-01和R-03影响科学统计表述准确，应在T6用于真实知识节目**之前**修；R-02和R-04是低成本但重要的可靠性修复，建议同一有界返修Gate执行；R-05随手修，不单开任务。暂不将长标签在极端条件下省略号显示升格成新阻断：外部截图和CSS说明它可能被省略，但未建立正常节目场景中产生严重误读的事实，实制片时再用证据图判断。

## 4. 下一轮唯一建议Gate（尚未获新一轮Owner执行授权）

- **目标**：只修R-01～R-05，保留Research Aqua原版外壳、一个Master Clock、六布局、V5.4素材导入、V5.5 cue/旁白和V5.6四比较模式；另存V5.6.1/后续新候选，**不覆盖已冻结V5.2或早期候选**。
- **测试要求**：单位前后空格、`%`百分点vs变化率、负差、接近零非零变化、极小/全零柱数据、严格MIME正反例及手动替换路径、V1→V2兼容/JSON原子拒绝、4比较模式、T5真视频与WAV时码、0→31.06秒实速及Mac Canvas像素基线；新增缺陷须独立留证。
- **本轮停点**：由Owner决定是否授权下一轮小修。当前审核结果不能直接解释为合并PR、启动正式视频制作、发片或修改权限。
- **回滚**：PR保持Draft，main冻结V5.2是可恢复基线；新候选不动原件；无生产容器、外部服务/支付、素材下载及删除动作。

## 5. 尚未处理但已知的非本轮问题

- 原14项之⑤真实T4论文/档案素材、⑭完整知识叙事Story-Fit，需要真实题材、不同合法媒体、脚本与音画联合验证；不是当前T6数据接口bug。
- ⑪ QuickTime进度显示时间语义仍为低优先级、Owner暂不处理，不要借此次Review擅自调整。
- **真实4–6分钟节目**的自动合法素材搜集和复用权、配音制作、逐句音频时标生成、SRT文件、Remotion/FFmpeg MP4输出、长片端到端稳定性全部尚未验收。
- 素材版权`PARTIAL`；CW0005 `R3_RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`持续。不能把模板技术PASS转换为正式片PASS。

## 6. 下一位Reviewer最小接手索引

先读本文件及[完整原始外部报告＋独立JSON](CWS_V54_V56_EXTERNAL_REPORT_AND_RECHECK_2026-10-18.md)，再读 `docs/CURRENT_STATE.md` 与 `docs/REVIEWER_HANDOFF_CURRENT.md` 顶部最新条目及[Governance v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)。随后**精确读取** Draft PR#144 V5.6 Git blob；不得从V5.2或旧V4重做Mac。若需要外部测试截图、完整复现脚本，Owner持有上述SHA-256归档ZIP，按需转交即可。

**CURRENT_REVIEW_GATE：`JOINT_REVIEW_PARTIAL / TARGETED_REPAIR_RECOMMENDED / WAIT_OWNER_DECISION`。当前模板源码本轮未改，已接受的 main 冻结基线也未修改。**
