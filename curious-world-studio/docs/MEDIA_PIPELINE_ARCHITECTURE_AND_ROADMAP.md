# CWS｜MEDIA素材架构与阶段路线（长期规范 · 2026-10-15）

> **Owner新规划决定：先做R6L/R7L轻量试跑（已授权，尚未执行）**，不单建逐帧视觉识别系统；镜头相关且够用就停，关键科学事实不能失真。详见[试跑合同](MEDIA_R6L_R7L_FAST_MATCH_PILOT_2026-10-15.md)。

> **最新事实**：Windows本机Docker Desktop按需运行SearXNG+4get的**G2–G4已完成并获`G2_G3_G4_TECHNICAL_ACCEPT`**；旧无Docker、只读恢复、Brave/Exa收费API优先方案不是当前路线。代码PR#129及Codex统一CLI/Compose PR#131**均已合并main**（后者squash commit [`201c39a2`](https://github.com/entropy-student/project/commit/201c39a2b61eae7189cc624d5cb2c18dd671de38)）；运行时上游可部分降级但默认fail-closed。正式视频仍`CW0005_VISUAL_STORYFIT_HOLD`，素材技术通关不能代替权利/内容审查。

## 1. 架构与模块职责

`具体题材/目标动作 → SearXNG与4get（Docker仅按需启动） → CWS索引/去重/来源追踪 → 横屏与平台过滤 → 显式ID探测/yt-dlp获取 → FFprobe/FFmpeg整片技术QA+SHA → HTML预览/本地浏览器 → 关闭本项目容器`

| 模块 | 输入 | 输出/边界 |
|---|---|---|
| 来源/搜索 | 查询词、论文官方材料、非大陆海外站点 | 视频/图片候选URL、来源、缩略图、检索状态；不是可用许可 |
| 去重与过滤 | 索引/metadata | URL、媒体ID/域名/平台家族去重；中国大陆视频平台排除、方形及竖屏排除、缺尺寸待probe |
| 探测/指定获取 | Owner或运行端明确选择的视频/图片ID | yt-dlp等验证路径、实际媒体文件、失败状态；不绕登录/DRM |
| 技术QA | 实际媒体文件 | 旋转/SAR修正后的显示比例、分辨率、帧率、FFmpeg完整解码、SHA及代表帧 |
| 人类查看 | CWS HTML与Windows本机浏览器 | 本地素材与搜索缩略图区分、真实视频播放；**不代表镜头语义、内容核验或权利许可** |
| R6L/R7L（下一轮轻量试跑） | 4个真实画面需求+已有检索索引 | 相关即可的候选短名单+大致片段+来源/版权状态/缺口；不要求逐帧精准时间码 |

**七项指标必须分别记录**：搜索URL、去重URL、可解析视频、真实下载、技术解码、动作吻合、可复用权利。PeerTube多个实例是多个域名，**不能算多个独立技术平台家族**；CDN不能单独算独立来源。

## 2. 永久默认约束

1. **只纳入非大陆视频平台**；按域名/实际平台家族识别，不以标题语言和服务器地理位置简单封锁。
2. **视频必须是横屏**，旋转/SAR修正后实际显示比例≥4:3；排除全球竖屏及方形。源宽高未知先有限核实，不能当非横屏误拒。
3. **优先16:9、1080p以上**；720p备选；测试可按单轮另设较低技术门槛，但不得冒充正式制片质量已过。
4. 搜索发现、下载成功、内容已逐帧核验、权利已确认是不同状态；`reuse_rights=UNKNOWN`不得自动变为PASS。
5. 保存平台/来源、原始URL、媒体ID/文件SHA、失败原因；快速匹配先检查来源ID和片段是否明显重复，**不必为试跑建立复杂视觉近重复识别**；不能仅凭不同SHA断言独立作品。
6. 正式[3+1素材合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)中的罕见竖屏第一手证据例外，不允许MEDIA默认放行；须Owner单独批准该镜头例外。
7. 新稳定代码通过隔离分支PR→Reviewer独立检查→合并；不在main存媒体、备份、日志或敏感配置。CWS有限目标URL约束**并非SSRF沙箱**，不得变公网自动下载服务。
8. 技术视频播放由Codex在获准的独立浏览器自动检查事件与时间推进，缺测试环境需如实标记；Owner主要审查真实动作/故事/审美和权利。

## 3. 已验证的各阶段

| 阶段 | 证据进度 | 限制 |
|---|---|---|
| MEDIA-R1 | 历史合并1,533去重视频URL、813图片URL；4get特定对照视频增量74、图片476 | 这些都是搜索候选，不是成片资源 |
| MEDIA-R2 | 22视频、31图片本地获取、预览与技术QA已测 | 真实跨题动作适配PARTIAL |
| MEDIA-R3 | 300域名盘点、197站实测尝试、153成功（**151 PeerTube实例、PBS、ARD**），135个不同文件SHA | 不应宣传成153种视频网站技术 |
| MEDIA-R4+R5 | CWS独占You-Get/Lux旧资源清理约643MiB；10个非PeerTube来源技术验证：PBS、ARD、DVIDS、NPS、DW、USGS、NOAA、NASA SVS、Wikimedia、Mixkit | 原独立Reviewer综合`R4R5_PARTIAL_ACCEPT`仍保留 |
| MEDIA-INTEGRATION | [PR#129](https://github.com/entropy-student/project/pull/129)已合并main，Windows36/36测试；含受控搜索索引/格式探测/显式ID下载/QA | 独立CLI工具，不等于已替换正式OpenMontage/制片入口 |
| MEDIA-RECOVERY-G0/G1A | 旧无Docker探索中断后恢复现场；本地静态HTTP/Edge手播G1A通过 | 旧探索仅作历史，不是当前G2/G3/G4要重复的工作 |
| **G2-G4（最新）** | **Ubuntu-24.04已备份注销；Docker SearXNG+4get四组API非空；raw316→77视频/135图片；下载两PeerTube实例视频+一图片、全解码、Edge手动播放、最终停止端口释放；技术PASS** | Ubuntu tar恢复未由Reviewer亲自操作，浏览器是Owner实测，不是自动化；样本动作及版权不通过 |

G2–G4的唯一证据ZIP：`CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip`，SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`，50文件SHA/49manifest匹配；Reviewer独立完整解码4个附件媒体。本轮Ubuntu tar仅本地归档，不上传GitHub。

## 4. 未来阶段与已授权范围

| 阶段 | 目的 | 当前状态 |
|---|---|---|
| **MEDIA-OPERATIONS-INTEGRATION** | 在Codex可调用的`cws_media.py`统一CLI中按需启停Docker搜索、索引/显式ID下载/QA/图库、错误及Ctrl+C清理 | **技术验收`PASS_WITH_UPSTREAM_DEGRADATION`，PR #131已合并main**；浏览器自动测试记录仅在已获许可的隔离实例进行 |
| **MEDIA-R6L/R7L FAST-MATCH PILOT** | 复用现成CLI；CW-0005仅4个画面需求，每需求先看3–5候选、最多两轮，确认“相关且够用”即止；同轮输出来源/粗略区间/内容与权利状态、缺口 | **Owner已授权小试验，尚未执行**；[唯一合同](MEDIA_R6L_R7L_FAST_MATCH_PILOT_2026-10-15.md)。先验证效率，再决定是否需要新代码 |
| **大规模R6/R7产品化** | 逐帧定位/全库视觉识别/复杂剪辑索引，仅当轻量试验确实证明必要才考虑 | **未授权，不是当前默认路线** |
| **PROD-R1～R4** | 真实选题/证据→剧本与画面→30–60秒音画字幕联调→完整内部草片 | 与MEDIA完全独立，CW-0005 HOLD，未放行新制作 |
| **发布** | 播放成品、字幕质量、权利和Owner最终批准后发布 | 未授权 |

**原“MEDIA-R4+R5”和“PROD-R4”编号完全不同。** 未来不再为了凑站点数无限遍历PeerTube；先服务真正缺的研究动作。当前不要重复G2 Ubuntu卸载或已经验收的两段Edge技术播放。

[最新状态](CURRENT_STATE.md) · [Reviewer交接](REVIEWER_HANDOFF_CURRENT.md) · [G2-G4原合同](MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md) · [3+1正式素材合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)。
