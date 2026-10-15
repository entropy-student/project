# CWS｜当前Reviewer交接（2026-10-15）

> **新的唯一执行授权（2026-10-15）**：Owner批准`MEDIA-OPERATIONS-INTEGRATION`，要求统一给Codex调用的**轻量本机CLI**，封装已验收的Docker SearXNG/4get按需生命周期及main的媒体搜索/选ID下载/QA/图库；不是给Owner使用的GUI。请按[新Gate](MEDIA_OPERATIONS_AGENT_ENTRY_GATE.md)执行。**当前没有真实实现/PR/Reviewer PASS证据**；G2-G4维持既有TECHNICAL_ACCEPT，R6/R7/PROD未授权。

> **唯一当前交接，不叠加历史“最新”状态。** 首读[CURRENT_STATE](CURRENT_STATE.md) → 本页 → [MEDIA架构](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md) → [正式素材3+1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)。旧Gate、历史仓库报告只作证据索引。**媒体技术状态：`G2_G3_G4_TECHNICAL_ACCEPT`；正式节目：`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。**

## 1. 接手时必须记住的事实

- 项目不是自动成片应用，而是不露脸、观点/好奇心驱动的跨领域知识频道；频道名未定、B站主阵地、视频叙述时长不硬凑。视觉[STYLE_LOCK](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)锁A短Mac Aqua桌面开场→B全幅QuickTime播放器、单行字幕。
- 研究：[36条题库](../research/topic-bank/BOARD_V1.md)，11 SHORTLIST / 15 VERIFY / 9 HOLD / 1 REJECTED；仅部分九源采样，未经正式STORYFIT_GO。P3叙事原型是纸面成果，不能算已受众测或已配音。
- 正式视频素材：严格按[3+1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)；搜得到、能下载、FFmpeg能解码、动作真实出现、与旁白匹配、商用可复用**六件不同的事**。
- 生产：CW-0005爆米花R1研究/R2条件故事/R2-M1库存短素材有历史证据，但爆裂/压缩/回弹科研动作和权利未消缺；`G1_NOT_PASS / G2_NOT_AUTHORIZED`，未授权切题、R3音画联调、R4首个完整草片或发布。
- MEDIA工具：独立可选Python工具通过[PR #129](https://github.com/entropy-student/project/pull/129)合并main（commit `10b369ee5558ed9a0ac2f738aea978623f62ba0f`）；36/36项Windows单测，Reviewer针对失败退出码和有限私网地址防护修复接受；**不是完整SSRF沙箱、也没有自动接入OpenMontage制作**。
- Owner Windows运行决策：**Docker Desktop/WSL2本机按需搜索，SearXNG+4get容器、Python+yt-dlp+FFmpeg在Windows，非VPS，非24h常驻**。Ubuntu-24.04已被安全备份并注销；保留Docker后端。前期无Docker/Brave/Exa方案只作历史探索，不是当前待执行路径。

## 2. 最新G2/G3/G4裁决（逐项说明证据责任）

| Gate | 目前证据及结论 | 不可夸大 |
|---|---|---|
| **G2** | 执行端先导出、读验完整`Ubuntu-24.04` tar，SHA `5F870E83109F3D976C4D2BF24843D9AC59C4520E8C1CA65897CE071B9FC48276`，1,522,626,560字节，注销指定发行版且Docker WSL2后端可用；**技术接受** | tar在Owner本地，Reviewer**未独立恢复该tar**；不删Docker与其它WSL数据 |
| **G3** | 本机Compose SearXNG/4get仅127.0.0.1监听，视频/图片四类API实际非空；raw316，视频去重77、图片去重135；端口停止释放，容器和缓存卷留存；**技术接受** | 局部上游引擎错误仍存在，HTTP200≠每种媒体搜索都正常 |
| **G4** | 实际两PeerTube实例视频+一JPEG下载、哈希和FFprobe/FFmpeg完整解码；Owner在Edge手动确认两段播放，视频时间推进；**技术接受** | PeerTube实例不等于独立平台家族；样片动作不适配爆米花，权限`UNKNOWN_TEST_ONLY`；Reviewer无Owner浏览器录屏 |

本轮唯一ZIP `CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip`，SHA256 **`651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`**；独立Reviewer核过**50条SHA/49项manifest**及所附**2原视频、1预览视频、1张图片**的完整解码。没有把大Ubuntu备份装入ZIP，未证明Reviewer已验证实地恢复。CWS搜索服务最后为停止态，而非持续在线。

早前经验：`G0_RECOVERY_EVIDENCE_ACCEPT`；`G1A_LOCAL_LIFECYCLE_PARTIAL_ACCEPT`历史遗留的`BROWSER_NOT_VERIFIED`已由Owner手动Edge补测解决（ZIP `CWS_MEDIA_G1A_BROWSER_VERIFY_20261015.zip`，SHA256 `07b7f169d54b5440bc967d464e2764e34119f98717474a8b92dbfec3ec8337d3`）。**未来自动浏览器测试不能拿旧Owner手动记录冒充机器测试**。

## 3. 当前环境、保全与审查纪律

- 保护旧本机工作树**3项tracked未提交修改和2项未追踪缓存目录**；保留中断材料、合法备份tar与旧媒体；不能用`reset --hard`、`git clean`、`docker system prune`、`down -v`覆盖/清理。
- **本机Docker Compose配置及一键生命周期脚本目前是执行端本地工件**：真实验收过，不等于已经推Git、经PR审查或作为通用工具发布；下一次正式入库必须从最新main开隔离分支，保留旧树。
- 网络：不改Windows系统代理、VPN/Clash、OpenMontage及别的项目Docker容器；仅本CWS Compose项目操作；服务只绑127.0.0.1、不自动常驻。
- 今后技术性浏览器播放由Codex在**获明确授权的隔离浏览器**自动测试`video.play()`、`currentTime`、实际帧和错误/资源回收；不要附着Owner私有Edge窗口，也不能绕过Computer Use明确的安全停止。无法自动运行则写`BROWSER_AUTO_NOT_VERIFIED`，**不要把用户当重复的浏览器单测员**。Owner仍有真实镜头/审美/许可决策权。
- 所有素材与截图只做`UNKNOWN_TEST_ONLY`技术实验；证据里不得放凭据、Cookie、SSH令牌或私密用户路径，媒体在权限不明时不作为Git附件或发布物。协议的“3+1”例外必须经Owner许可。

## 4. 下轮建议（**只有OPERATIONS-INTEGRATION已获新授权；R6/R7/PROD仍未授权**）

**Owner已授权：`MEDIA-OPERATIONS-INTEGRATION`（当前仍未实现/Review）**——整理可复用的Windows Docker Compose+一键启停脚本、失败/资源保护和隔离浏览器自动QA，在独立分支形成PR交Reviewer，合并前确认不影响共享服务。G2本身不用重做。随后才考虑`MEDIA-R6`目标动作/时间码、内容近重复、非PeerTube多家族检验和`MEDIA-R7`逐分镜素材包。不得擅自推进R6/R7、购买API/部署VPS或切换正式制作Gate；OPERATIONS-INTEGRATION仅在新合同范围内执行。

**制片轨道**：`PROD-R1→R2→R3→R4`与`MEDIA-R*`独立；只有论文/真实镜头/权利及Owner视觉审查过关后才能恢复正式节目制作。

## 5. 可用文件与历史证据

- [项目唯一当前状态](CURRENT_STATE.md)、[MEDIA阶段与架构](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)、[G2-G4执行合同（已完成，保留安全约束）](MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md)、[Windows媒体工具使用说明](MEDIA_PIPELINE_WINDOWS_USAGE.md)、[正式3+1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)。
- [早期CW-0005叙事/素材长交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)；[PROD四轮泳道](P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)；[MEDIA-R3/R4+R5统计及历史材料](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)。历史Gate使用当时语态，不是现在的操作许可。
- [2026-10-15合并前旧CURRENT_STATE Git快照](https://github.com/entropy-student/project/blob/61baf38618117325aee6d25b755e8f64f765f20b/curious-world-studio/docs/CURRENT_STATE.md)、[旧Reviewer交接快照](https://github.com/entropy-student/project/blob/61baf38618117325aee6d25b755e8f64f765f20b/curious-world-studio/docs/REVIEWER_HANDOFF_CURRENT.md)。不在main重复复制过时的每轮前言。

**一句话交接：CWS已完成本机Docker素材发现/下载/技术QA可用性验证，但正式Compose启停工具尚未PR入库、镜头动作/权利未通过、正式成片仍HOLD。**
