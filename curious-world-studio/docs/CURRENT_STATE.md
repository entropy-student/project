# Curious World Studio｜唯一当前状态（2026-10-15）

> **2026-10-15独立Reviewer最终运行裁决：`MEDIA_OPERATIONS_INTEGRATION_TECHNICAL_PASS_WITH_UPSTREAM_DEGRADATION`，PR [#131](https://github.com/entropy-student/project/pull/131)已通过独立Review，并由Owner授权以squash方式合并main（commit [`201c39a2`](https://github.com/entropy-student/project/commit/201c39a2b61eae7189cc624d5cb2c18dd671de38)）。最终ZIP `CWS_MEDIA_PR131_FINAL_RUNTIME_VERIFY_20261015.zip` SHA256 `8881c72b8b9823978080feace136c4dafceee1db6f1731d8867830f046922d30`，CRC正常，23项SHA256SUMS与22项manifest均独立检查吻合。Windows60/60测试由执行端提供日志（Reviewer之前独立复核本轮CLI代码单测）。本轮内存实测2,680/2,410MiB>1,664MiB门槛；SearXNG视频88/图片110、4get视频15/图片81，合计294次查询级记录、去重190候选（93视频/97图片）；**上游Google视频403、Brave解析失败、Vimeo/Pinterest超时仍存在**，所以CLI正确`PARTIAL_SEARCH / ok:false / exit 1`，可选`--allow-partial`显式使用降级结果，**不是全部上游成功**。另有真正Windows PTY Ctrl+C及ESTABLISHED搜索socket记录：CLI`INTERRUPTED`；三个本项目容器exited(0)、18080/15050端口释放、无本轮Python残留、无关容器ID不变。Reviewer检查的是提交证据，不是亲自连接Owner Windows。**本轮未核验190条候选画面、下载、复用许可或动作匹配**；正式`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`不变。不需为第三方上游完全无错误而阻塞本地工具技术验收，但不得把默认exit1宣传为全源PASS。

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
| MEDIA代码集成 | [PR #129](https://github.com/entropy-student/project/pull/129)基础索引/过滤/下载/QA + [PR #131](https://github.com/entropy-student/project/pull/131) Codex统一JSON CLI、Docker按需启动/停止、异常清理，**均已正式合并main** | 允许外部搜索引擎部分降级；仅本机受控显式ID下载，**不代表精准镜头、商用权利或正式制片通过** |
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
- [media-pipeline](../media-pipeline/README.md)基础代码和Codex统一入口`cws_media.py`、Docker Compose/配置模板、Windows自动启停及测试**均已合并main（PR #129、#131）**。旧Git工作树的3项未提交更改、2个缓存目录及历史中断材料受保护，禁止reset/clean/全局prune。
- 历史R3：153次合格站点成功中151是PeerTube实例、仅PBS/ARD为非PeerTube；R4+R5：**10个非PeerTube站点**（PBS、ARD、DVIDS、NPS、DW、USGS、NOAA、NASA SVS、Wikimedia Commons、Mixkit）通过当轮技术获取验证。技术家族、真实镜头内容、可用许可均需另外计数。
- 更完整[技术架构及阶段映射](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)；历史[G2–G4执行合同与验收边界](MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md)；正式[3+1来源和动效合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)。

## 4. 唯一当前交接决定与后续候选

**最新完成Gate：`G2_G3_G4_TECHNICAL_ACCEPT`；统一Codex CLI已完成`MEDIA_OPERATIONS_INTEGRATION_TECHNICAL_PASS_WITH_UPSTREAM_DEGRADATION`，PR #131于本轮正式合并main。** 后续按价值优先：

1. **MEDIA-OPERATIONS-INTEGRATION（完成并合并main）**：Codex已可统一调用`doctor / discover / catalog / fetch / gallery`、按需Docker启动/停止与故障上报。实际搜索可能因上游降级而默认返回`PARTIAL_SEARCH`非零退出；如允许部分候选需显式`--allow-partial`。不再重复此基础设施建设。
2. **MEDIA-R6（建议、未授权）**：围绕真正分镜目标，定位视频中实际动作出现的时段、比对不同来源技术家族与内容匹配率，补足`CW-0005`爆裂/压缩/回弹真实镜头缺口；不得标题匹配就算动作出现。
3. **MEDIA-R7（建议、未授权）**：输出镜头级视频/时间码/来源/预览/内容与权利状态/缺口说明，供正式PROD另行审查。

正式制片的`PROD-R1～R4`与工具`MEDIA-R1～R7`**不是同一组R编号**。旧[四轮制片泳道](P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)仅是生产目标路线，不构成已获准制作。

## 5. 交接、证据和历史保留策略

- **Owner**决定执行范围、付费、删除、外联、版权、正式Gate、发布；**Windows Codex**动手并交一个脱敏原始证据ZIP+外层SHA；**ChatGPT Reviewer**只在真实证据范围内独立检查并给PASS/PARTIAL/RETURN/HOLD；Review不能替代Owner对删除/制作的授权。
- GitHub `main`只存**已批准的稳定源码、协议、当前状态与交接**，不是放原片、备份tar、逐轮日志或每轮多个重复报告的地方；正式代码改动分支PR→Reviewer→合并。PR #131的Compose与CLI现已合并main，但只是本机可调用工具，**并非公网服务或正式视频生产上线**。
- 证据：`CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip`（SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`）；`Ubuntu-24.04`备份tar本地保留。前轮G1A、PR#129/R1–R5证据在[交接](REVIEWER_HANDOFF_CURRENT.md)追溯。历史文档“旧最新/下一步”的时态不得覆盖本页。
- [旧CURRENT_STATE原样Git快照](https://github.com/entropy-student/project/blob/61baf38618117325aee6d25b755e8f64f765f20b/curious-world-studio/docs/CURRENT_STATE.md)，供需要复盘的Reviewer查阅，无须复制冗长历史叙述到main。

**一句话：给Codex复用的“检索→过滤→显式ID下载→技术QA→预览→关闭Docker”统一本机工具已正式合并；真正的镜头动作定位、权利核查、逐镜头素材包与完整视频制作仍未通过。**
