# Curious World Studio｜唯一当前状态（2026-10-15）

> **2026-10-15最新Reviewer裁决：`MEDIA_OPERATIONS_INTEGRATION_RETURN_FOCUSED_FIX`。** [PR #131](https://github.com/entropy-student/project/pull/131)已实现统一JSON CLI并保持OPEN未合并；Windows报告51项测试通过，独立Reviewer复核ZIP（SHA256 `adad9a05a389be07173a939d20b482cc45131a3576654cabf94b6600ebb5fd42`，30项SHA/29项manifest）、在Linux复跑50 PASS/1项Windows专项SKIP。**实际搜索仅4get成功，SearXNG video/image连接中断；部分搜索仍ok:true/exit0可能误导代理；真实运行中中断清理尚未实测。**已将3项定向返工写在PR Review评论，当前**未获Gate PASS、未合并**。旧项目G2–G4技术PASS不受影响，CW-0005继续HOLD。

> **此前Owner授权本轮（现在已实施为PR，待修复/Review）**：`MEDIA-OPERATIONS-INTEGRATION`，仅将现有素材搜索/筛选/显式ID下载/QA、按需Docker启停封装成**供Codex统一调用的轻量CLI**，不做Owner常用GUI、VPS或常驻后台。正式执行范围见[唯一Gate](MEDIA_OPERATIONS_AGENT_ENTRY_GATE.md)。后续真实实现须Windows Codex隔离分支PR+独立Reviewer验收；`MEDIA_OPERATIONS_INTEGRATION_PASS`**尚未成立**，正式制作仍HOLD。

> **最高优先级事实入口，替换此前逐轮叠加的“最新状态”段落。** 主线状态：`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。**MEDIA素材技术闭环已通过，正式制作没有放行**。下次协作先读本页与[当前Reviewer交接](REVIEWER_HANDOFF_CURRENT.md)；旧执行合同/旧报告保留为历史，不再以其中“待执行”口吻发起任务。
>
> **运行路线定案**：Windows 11本机 Docker Desktop，SearXNG + 4get **按需启动/用后停止**；Python/yt-dlp/FFprobe/FFmpeg/CWS在Windows运行；**不部署VPS、不要求Docker长期开启**。Ubuntu-24.04已依执行端证据安全备份后注销，仅保留所需WSL2和Docker后端。

## 1. 项目整体进度与权威入口

| 轨道 | 当前可证实进展 | 不可误报/真实缺口 |
|---|---|---|
| 频道定位 | 不露脸、跨领域知识视频、B站主阵地；“知识小众，问题大众；证据真实，承诺兑现”[已确定](CHANNEL.md) | “世界有点意思”只是名称候选，频道品牌未最终定稿 |
| 研究/选题 | 九源→发现→初筛→正式题库→STORY-FIT的流程已建立；[正式题库](../research/topic-bank/BOARD_V1.md) **36条：SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1** | 九源不是完整稳定全量扫描；SHORTLIST不等于故事或制作GO |
| 叙事/脚本 | 三种叙事机制与多个文字原型、自然时长/不注水原则完成研究 | 纸面评估并非受众盲测/真实口播，也非已批准完整剧本 |
| 视觉 | [STYLE_LOCK v1.2](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)：A简短Tiger Aqua桌面→B铺满画面的QuickTime 7式播放器，1920x1080/30fps，单行字幕；原型、9秒技术渲染证据已有 | HTML预览和单片段测试**不是**约5分钟的音画字幕成片系统；M2历史渲染稳定性/正式Gate未通过 |
| MEDIA素材研究 | R1发现、R2索引/下载/QA、R3国际站普查、R4+R5独立来源扩展及受控清理完成历史测试 | R4+R5综合仍是`R4R5_PARTIAL_ACCEPT`；来源多不代表镜头动作匹配/商业权利 |
| MEDIA代码集成 | [PR #129](https://github.com/entropy-student/project/pull/129)经Reviewer修复验收合并`main`，独立`media-pipeline/`支持候选索引、横屏过滤、按ID下载和FFmpeg QA | 工具是可选模块；**本轮Docker Compose/生命周期脚本尚未作为经PR验收的正式可复用代码进入main** |
| Windows G2–G4 | **`G2_G3_G4_TECHNICAL_ACCEPT`**：Ubuntu备份卸载、Docker双搜索服务、真实搜索→下载→解码→浏览器预览→关闭 | 同轮样本仅两个不同PeerTube实例（同平台家族）+一张图片；无爆米花爆裂动作证据/授权 |
| MEDIA-R6、R7 | 均未开始：R6真正视觉动作定位/时间码/近似去重；R7逐分镜候选素材包 | **待Owner明确单独授权** |
| PROD正式制片 | 爆米花 CW-0005的R1研究、R2条件故事与R2-M1库存视频预检有历史成果；另有OpenMontage短片技术底座 | `CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`；未获R3联调/R4完整草片/发布授权 |

## 2. 最新G2–G4实测：机器做到哪一步

- **G2 Ubuntu安全卸载**：执行端先导出、完整读取验证并SHA核对`Ubuntu-24.04`备份，之后才`wsl --unregister`此指定发行版；备份**1,522,626,560字节**，SHA256 `5F870E83109F3D976C4D2BF24843D9AC59C4520E8C1CA65897CE071B9FC48276`；WSL2/Docker Desktop仍可用。**备份tar留Owner本地，Reviewer未亲自尝试恢复tar**。
- **G3 Docker按需搜索**：只绑定`127.0.0.1`的SearXNG与4get对视频/图片四组实时API调用返回非空结果；**316条原始结果，去重后77条视频、135张图片候选**。上游引擎有局部失败；停机后CWS端口释放、项目容器及缓存卷保留以便下次启动。**现状是停止状态，不是服务常驻**。
- **G4真实素材技术链**：两个不同**PeerTube托管实例（同技术家族）**的视频、一张图片已按人工指定ID下载，FFprobe、FFmpeg完整解码、SHA检查有证据；CWS HTML展示与Edge播放由Owner手动确认两段视频画面正常、时间推进。旧G1A播放缺口亦已由Owner确认，不必重复以前的旧文件测试。
- 独立Reviewer核实本轮ZIP SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`，**50条SHA256SUMS和49项manifest一致**；ZIP中的**2原片+1浏览器兼容预览视频+1图片**在Reviewer环境独立完整解码成功。Owner Edge实际观看**没有独立录屏**，不能记为Reviewer本人看过或机器自动化完成。
- **权限与内容差异**：本轮视频帧未证实爆米花爆裂，媒体权利仍`UNKNOWN_TEST_ONLY`。下载、完整解码、画面动作吻合、许可是互相独立的Gate。PR#129对私网目标有有限保护，但DNS连接未钉死、yt-dlp重定向非完整SSRF沙箱，限本机显式ID/有界下载。

## 3. MEDIA长期架构、质量门槛与运行方式

`选题动作/关键词 → Docker按需SearXNG+4get → CWS候选索引/去重 → 大陆平台与非横屏过滤 → 人工选择ID/yt-dlp → FFprobe/FFmpeg完整QA/原片SHA → HTML本地素材页 → 停止本项目容器`

- 默认排除中国大陆视频平台，排除全球方形/竖屏；判定以SAR/旋转修正后真实显示宽高比**≥4:3**，优先1080p横屏；未知先有限探测并保留拒绝原因。正式制作如必须使用极少数非横屏第一手证据，只能按[3+1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)由Owner另批例外。
- 技术播放验收今后默认由Codex在**授权的隔离浏览器测试会话**自动验证加载、`play()`、`currentTime`增长和画面，保留证据并清理进程；不附着Owner个人Edge会话、不绕过明确的安全停止；没有自动化权限就如实记录阻塞。**Owner只承担内容匹配、审美和授权类人工判断**。
- 工具代码[media-pipeline](../media-pipeline/README.md)已入main；G3/G4中成功运行的Docker Compose/一键脚本仍在本机执行工件，**尚未正式集成、review或合并**。旧Git工作树的3项未提交更改、2个缓存目录及历史中断材料受保护，禁止reset/clean/全局prune。
- 历史R3：153次合格站点成功中151是PeerTube实例、仅PBS/ARD为非PeerTube；R4+R5：**10个非PeerTube站点**（PBS、ARD、DVIDS、NPS、DW、USGS、NOAA、NASA SVS、Wikimedia Commons、Mixkit）通过当轮技术获取验证。技术家族、真实镜头内容、可用许可均需另外计数。
- 更完整[技术架构及阶段映射](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)；历史[G2–G4执行合同与验收边界](MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md)；正式[3+1来源和动效合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)。

## 4. 唯一当前交接决定与后续候选

**最新已完成Gate：`G2_G3_G4_TECHNICAL_ACCEPT`。新的`MEDIA-OPERATIONS-INTEGRATION`已由Owner授权，但执行/Review尚未完成。** 后续按价值优先：

1. **MEDIA-OPERATIONS-INTEGRATION（已授权，待本机执行及Reviewer验收）**：在隔离分支把经过实测的Docker Compose、Windows按需启动/停止和隔离浏览器技术QA变成可重复运行的正式工具；重跑资源/端口/错误/停止回归，PR交独立Reviewer后再决定合并。**无需重新注销Ubuntu或重复G2–G4全量验收**。
2. **MEDIA-R6（建议、未授权）**：围绕真正分镜目标，定位视频中实际动作出现的时段、比对不同来源技术家族与内容匹配率，补足`CW-0005`爆裂/压缩/回弹真实镜头缺口；不得标题匹配就算动作出现。
3. **MEDIA-R7（建议、未授权）**：输出镜头级视频/时间码/来源/预览/内容与权利状态/缺口说明，供正式PROD另行审查。

正式制片的`PROD-R1～R4`与工具`MEDIA-R1～R7`**不是同一组R编号**。旧[四轮制片泳道](P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)仅是生产目标路线，不构成已获准制作。

## 5. 交接、证据和历史保留策略

- **Owner**决定执行范围、付费、删除、外联、版权、正式Gate、发布；**Windows Codex**动手并交一个脱敏原始证据ZIP+外层SHA；**ChatGPT Reviewer**只在真实证据范围内独立检查并给PASS/PARTIAL/RETURN/HOLD；Review不能替代Owner对删除/制作的授权。
- GitHub `main`只存**已批准的稳定源码、协议、当前状态与交接**，不是放原片、备份tar、逐轮日志或每轮多个重复报告的地方；正式代码改动分支PR→Reviewer→合并。当前不把尚未入库的本机Compose脚本描述为已正式上线。
- 证据：`CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip`（SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`）；`Ubuntu-24.04`备份tar本地保留。前轮G1A、PR#129/R1–R5证据在[交接](REVIEWER_HANDOFF_CURRENT.md)追溯。历史文档“旧最新/下一步”的时态不得覆盖本页。
- [旧CURRENT_STATE原样Git快照](https://github.com/entropy-student/project/blob/61baf38618117325aee6d25b755e8f64f765f20b/curious-world-studio/docs/CURRENT_STATE.md)，供需要复盘的Reviewer查阅，无须复制冗长历史叙述到main。

**一句话：素材的“检索→过滤→人工指定下载→技术QA→预览”已在本机Docker方案实测；真正的镜头动作定位、版权清理、正式生产与复用尚未通过。**
