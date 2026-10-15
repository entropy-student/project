# Curious World Studio｜唯一当前状态与交接入口

> **2026-10-15最新结果｜独立Reviewer：`G2_G3_G4_TECHNICAL_ACCEPT`。** Windows执行端报告G2、G3、G4各PASS；Reviewer已独立核验唯一ZIP `CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip`，SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`，CRC=OK，50项SHA256SUMS及49项manifest全部匹配，4份打包媒体在独立Linux上FFprobe+FFmpeg完整解码成功。两搜索服务响应各包含非空视频和图片，raw 316、去重77视频+135图片；容器/端口已由执行端记录停止。G2完整WSL TAR(1,522,626,560字节)备份存Owner本机且未入ZIP，Reviewer不能独立恢复验证，只确认执行端全量流读取日志、退出码及Docker仍能运行。Edge两段真实视频画面与时间推进由**Owner本人手动反馈PASS**，无独立录屏/Reviewer浏览器重放。**不同源网站均属PeerTube家族；本轮片段代表帧不显示目标爆米花爆裂；权利`UNKNOWN_TEST_ONLY`，正式`CW0005_VISUAL_STORYFIT_HOLD`不变。**
> **技术验收新规则（防止无谓人工重测）**：今后浏览器**能否加载、解码、播放、时间推进、异常和资源释放**由Codex在**隔离的新测试浏览器会话**用许可的Playwright/CDP等直接自动执行并留日志/截图证据；不要控制/附着Owner已打开的私人Edge窗口，也不得借其它自动化方式绕过明确的安全停止。自动化如不可获准运行就标`BROWSER_AUTO_NOT_VERIFIED`并报告原因，**不默认要求Owner重复点视频**；Owner只承担真实内容/动作吻合、审美和正式授权判断。自动化测通不等于镜头内容或版权PASS。

> **2026-10-15 Owner最新执行授权（覆盖同页较旧的无Docker限制）**：采用**Windows Docker Desktop本地按需方案**，在一个受控Codex任务中串行执行**G2 Ubuntu-24.04安全备份与卸载、G3 SearXNG+4get Docker搜索服务、G4关键词→筛选→新媒体下载→QA→Edge播放→关闭容器**。正式合同：[MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md](MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md)。**尚未实际执行，本轮状态`G2_G3_G4_AUTHORIZED_AWAITING_EXECUTION`**。不部署VPS；保留WSL2/Docker后端、旧工作树/中断资料与原片。此前G1A播放已由Owner确认，正式制作仍HOLD。

> **2026-10-15 Owner 决策 / Reviewer 独立核验后的最新状态。** 历史快照只作溯源，不作为下一步命令。**MEDIA-INTEGRATION PR #129 已经经Reviewer修复验收后正式合并main（squash commit `10b369ee5558ed9a0ac2f738aea978623f62ba0f`）**；成为受限的、本地指定ID的媒体获取及QA工具，**并不意味着正式节目生产链已自动接入或无Docker已通过**。
>
> **2026-10-15 Owner最新运行决策**：**以Windows本机按需启动/用毕停止为首选，不部署VPS、不使用Docker、不保持搜索服务常驻。** 之前`MEDIA-DOCKERFREE-ACCEPTANCE`的安装/部署/整链执行被Owner中断，视为**暂停且结果未知**，不是FAIL/PASS。此前先授权[中断后只读现场恢复与按需运行可行性判断](MEDIA_ONDEMAND_RECOVERY_AND_START_STOP_POLICY.md)，其后G0获得证据级接受，G1A本地启停已执行但部分通过；当前不自动授权G1B，不得依旧协议重启部署；不影响已合并PR #129。
>
> **正式制作状态未变**：`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。未批准更换选题、音画生产、发布或素材复用权；Owner 已恢复**素材工具支线的专项研发和验收**，不能再将2026-10-12“全面暂停”的旧快照当成当前命令。

> **2026-10-15最新独立Reviewer裁决：`MEDIA-ONDEMAND-RECOVERY-G0 / G0_RECOVERY_EVIDENCE_ACCEPT`。** Owner提供的G0 ZIP外层SHA `05ff890e6b87c420754a315812c7199c3da6c7c09116db5f5ffb3281c69f8c42`一致，16项SHA256SUMS及15项manifest均匹配；记录显示旧搜索端口无监听，Windows无搜索服务进程，WSL发行版Stopped，G0没有安装/启动/删除/修改Git跟踪文件。**Reviewer仅独立检查提交文件/主线源码，不具有Windows实机直连证据。** 旧运行留下61个文件约1,746,920,513字节（其中WSL VHDX约1,735,393,280字节），当前全部保留。
> **下一步未自动授权执行**：先审查现有`agent-reach / Exa`检索工具是否可以提供合法的媒体候选发现及其结果留存权利；同时保留“人工来源URL导入→现有按ID下载/QA”的零部署退路。Brave普通API对结果持久存储有限制，现有CWS持久索引不可无条件直连；不得注册付费API、安装搜索服务、启动WSL/VPS/Docker、清理VHDX或自行进入G1。G0通过不等于`ONDEMAND_END_TO_END_PASS`或`DOCKER_FREE_MEDIA_PIPELINE_PASS`。

> **LATEST REVIEWER VERDICT 2026-10-15 — `MEDIA-ONDEMAND-G1A / G1A_LOCAL_LIFECYCLE_PARTIAL_ACCEPT`**。Owner交付ZIP `CWS_MEDIA_ONDEMAND_G1A_LOCAL_LIFECYCLE_20261015.zip`，外层SHA256 `4f5d7d7874830feb18597b76e4164f0f2b224ebb60cda4667fbec74e14b0bacc`；ZIP CRC、32条SHA256SUMS、31条manifest均独立复算通过。运行日志支持旧素材2视频/1图片的SHA、FFprobe/FFmpeg退出码0、CWS gallery退出码0；回环HTTP 127.0.0.1:18765上实际HEAD返回HTML及MP4 200，启停/重复启动/占端/非正常退出/端口释放测试记录通过。**原片与播放代理不在ZIP中，因此Reviewer未独立完整解码原片。Edge/Chrome实际播放及currentTime推进因为Computer Use无法确定当前URL而安全停止，`BROWSER_NOT_VERIFIED`；HTTP200不能替代播放器PASS。**未运行关键词搜索，也无G1B接入、无Docker-free整链PASS。G1A仅为**本地生命周期与媒体文件QA的部分验收**；正式制作Gate继续HOLD。下一轮仅建议在Owner许可后补**浏览器实际播放验证**，优先正常用户手动打开本机loopback页面记录播放与时间推进，避免通过替代浏览器自动化绕过Computer Use停止指令；不部署/安装/注册API。

> **2026-10-15最新验收｜G1A浏览器补测完成：`G1A_BROWSER_OWNER_PASS / G1A_LOCAL_LIFECYCLE_ACCEPTED`。** Owner亲自在Edge打开`http://127.0.0.1:18765/index.html`，对已有2个六秒H.264 MP4预览均反馈“**两段都通过**”（画面可见、播放时间持续增加）。执行端HTTP日志同时记录了两条MP4的GET成功；`lifecycle.py`完成服务停止、PID 24568消失、端口18765零监听。Reviewer复核`CWS_MEDIA_G1A_BROWSER_VERIFY_20261015.zip`：外层SHA256=`07b7f169d54b5440bc967d464e2764e34119f98717474a8b92dbfec3ec8337d3`，ZIP CRC无错误、27条SHA清单一致、26条manifest元数据全部匹配；播放HTML机制与Python生命周期脚本通过静态检查。**独立Reviewer没有浏览器录屏、截图或实际原片副本，播放PASS仅为Owner实测确认；Reviewer没有重新完整解码原片**。这次仅结束G1A旧的浏览器缺口，不等于搜索源接入、无Docker整链或成片Gate通过。
> **下一步**：不再反复补浏览器证明；优先推进`G1B-SEARCH-SOURCE`，在不部署VPS/Docker、不启常驻服务的前提下，对搜索接口的**视频/图片覆盖、保存/留存权、费用/配额、与CWS持久索引兼容性**做可判定的选择。**G1B当前尚未执行或获Reviewer PASS**；如需要支付、安装、API接入或Git生产代码修改，仍单独走Owner授权与分支PR。

## 1. 一眼看懂

| 轨道 | 最新已证实结果 | 仍未完成 |
|---|---|---|
| 频道与研究 | 跨领域、不露脸、B站主阵地；题库36条；Research Aqua A→B与“3+1”素材合同仍在 | 无正式 `STORYFIT_GO`；CW-0005关键科研动作/视频复用权仍未通过 |
| 素材发现（MEDIA） | SearXNG与4get历史测试：合并1,533条去重视频URL、813条图片URL；4get增量视频74条、图片476张；PR #129 Windows实测7次搜索、460条记录和413个去重候选 | URL不等于可用作品；运行环境切换后仍须分别验证引擎搜索非零及服务来源 |
| 选片与下载（MEDIA） | 本地索引/预览/指定下载/yt-dlp、FFprobe/FFmpeg已实测；一轮新增22段视频、31张图片 | 跨题材动作匹配部分通过；完整本机原片未被Reviewer逐条重新解码 |
| 网站覆盖（MEDIA） | 2026-10-13 R3：153成功站（151 PeerTube实例、PBS和ARD），135个不同文件SHA，153段预览独立解码通过 | 153站不是153种平台技术；大量实例运营地区未知 |
| 清理与海外来源（MEDIA-R4+R5） | 清理22,639个CWS独占You-Get/Lux文件/674,230,911字节（约643MiB）；非PeerTube本轮成功10站（PBS/ARD复验+新增8站） | 历史 `R4R5_PARTIAL_ACCEPT` 仍保留；后来PR #129正式集成了新过滤入口，但不追溯改变R4+R5原Gate |
| MEDIA-INTEGRATION | PR #129 经36/36项Windows回归、独立Reviewer集中修复验收，已合并 `main`；具备显式ID探测/下载、QA、HTML生成 | **不是无Docker验收**；任意不可信URL防护非完整沙箱；浏览器播放在独立环境尚未验收 |
| MEDIA-ONDEMAND-G1A | 生命周期与本地素材文件QA由执行端验证；Owner手动在Edge确认两段6秒H.264预览正常显示、currentTime推进；HTTP GET和退出证据一致 | **G1A范围内验收完成（Owner确认播放）；本机独立启停脚本尚未以PR纳入Git；关键词搜索/G1B仍未开始** |
| 制片（PROD） | R1多轮素材审查、R2条件脚本设计及R2-M1两条库存媒体已实测，保留旧成果 | 正式G1没有PASS；尚无获准的R3联调或R4整片 |

## 2. 已确认的素材基础设施架构

`选题/搜索词 → SearXNG + 4get（搜索发现）→ CWS候选聚合/索引/去重 → 过滤与格式待核 → yt-dlp等已验证公开获取路径 → FFprobe/FFmpeg真实分辨率/完整解码/抽帧 → HTML本地素材库/证据台账 → [未来：分镜动作匹配和交付]`。

- **SearXNG、4get**只是发现层，不是视频下载器，也不是生产授权来源。SearXNG在历史对照中视频来源更广；4get主要贡献图片和部分YouTube视频补充；二者实际效果随配置与网络变化。
- **yt-dlp**是主下载器；You-Get/Lux的**CWS隔离安装**已按执行端删除记录清理；不意味着其他项目的安装一并删除。FFmpeg/FFprobe用于QA；OpenMontage仍保留作既有库存/制作链。
- **2026-10-15确定的MEDIA默认过滤**：中国大陆视频平台排除；全球竖屏与方形视频排除；判定依据为旋转与SAR修正后的**实际显示比例**，合格横屏至少4:3，优先16:9及1080p+；画质未知先有限核实，禁止仅因元数据缺失提前误拒。搜索、候选、下载和导出应一致应用，保留拒绝原因。
- 上述规则已由独立Review接受的本地**可选MEDIA工具模块**写入GitHub `main`：[`media-pipeline/`](../media-pipeline/)；**未替换OpenMontage/正式制作入口，也未验证脱离Docker运行**。正式节目“3+1”真实来源、内容核验与素材权利Gate仍分别执行；技术下载不等于正式可使用。

详见[素材技术架构与阶段映射](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)与[当前Reviewer交接](REVIEWER_HANDOFF_CURRENT.md)。

## 3. 轮次重新命名：两条轨道不可混用

- **MEDIA-R1** 搜索工具实测 → **MEDIA-R2** 素材获取闭环 → **MEDIA-R3** 国际横屏逐站普查 → **MEDIA-R4+R5** 本地清理与非PeerTube扩展（最新：核心目标达到，总体PARTIAL）。
- **MEDIA-INTEGRATION**：独立可选工具已Windows测试、Reviewer接受并通过PR #129合并 `main`；不意味着已成为正式制作引擎。**当前 `MEDIA-ONDEMAND-RECOVERY-G0` 已获独立Reviewer接受（只读证据层面）**：Codex先核查被中断进程/工作树/现有搜索服务真正来源及即用即停方案，不安装/部署/迁移/停服；[新决策与交接](MEDIA_ONDEMAND_RECOVERY_AND_START_STOP_POLICY.md)。旧[DOCKERFREE整链验收](MEDIA_DOCKERFREE_RUNTIME_AND_ACCEPTANCE.md)暂停，之后如确有可行本机路径再另行授权闭环测试。
- **MEDIA-R6**（待Owner单独授权）：实际画面/动作匹配、时间码定位、近似内容去重及1080p优先选择。
- **MEDIA-R7**（待Owner单独授权）：逐分镜素材包，输出真实原片、精准时段、来源、预览及内容/权利状态，再交接正式制作。
- **PROD-R1** 选题/研究/真实素材/权利 → **PROD-R2** 剧本/分镜/Research Aqua设计 → **PROD-R3** 30–60秒真实音画字幕联调 → **PROD-R4** 第一版完整内部草片。旧[四轮泳道](P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)指**PROD**，不是MEDIA-R4。发布另有授权。

**不要因为素材MEDIA工程通过，自动晋级CW-0005、PROD制作Gate或商用授权。**

## 4. 最新Reviewer裁决与证据边界

- R4+R5原轮次裁决：`R4R5_PARTIAL_ACCEPT / NON_PEERTUBE_10_SITE_TARGET_MET / CLEANUP_EVIDENCE_PASS`，不追溯修改。
- 新进展：PR #129 `PR129_FOCUSED_FIX_ACCEPT / MEDIA_INTEGRATION_CODE_QA_PASS / MERGED_MAIN`。Windows修复后36/36；独立Linux35通过+1项Windows专用跳过。修复了失败假成功退出码和部分私网地址探测边界，残留DNS未socket绑定、yt-dlp嵌套跳转风险；只按人工选ID、有限下载、本地隔离用途接受。`DOCKER_FREE_MEDIA_PIPELINE_PASS` **尚未建立**。
- 成功10站：PBS、ARD、DVIDS、NPS、DW、USGS、NOAA Ocean Exploration、NASA SVS、Wikimedia Commons、Mixkit；**这不是10个彼此独立的技术栈**。本轮2条1080p、5条720p、3条低于720p，最高1920×1080/30fps；此前R3曾实际拿到4K，二者不是互相否定。
- 76个已记录注册域名中10成功、66未得到合格结果；其中32个没有准确的单视频样本页，**不能等同于下载器失败**；Archive的低清媒体可解码但不达门槛，ZDF损坏片段需修复；4get零结果需回归。
- ZIP内部141项哈希全部匹配，10个短预览被Reviewer独立完整解码；约330.25MiB完整原片保留Owner本机，原片SHA/解码为执行端日志证据。网页看板独立浏览器被访问安全策略阻挡，不能写为独立交互PASS。

**重要证据文件**（ZIP不放入Git）：`CWS_R4R5_CLEANUP_DIVERSIFICATION_20261015.zip`，SHA-256 `b6c5117305d3d7d824af99b55920ca7fb738d799f5a60f14e708425ec883ddd1`；Reviewer裁决 `CWS_R4R5_REVIEWER_DECISION_2026-10-15.md`。更早来源见[当前交接](REVIEWER_HANDOFF_CURRENT.md)。旧2026-10-12的完整首期历史交接仍在[这里](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)。

## 5. 长期协作与文件治理

- **Owner**明确授权目标/必要删除/费用/外联/正式Gate；**Windows本地Codex**执行并交一个含原始证据与SHA的ZIP；**独立Reviewer**复核并给PASS/PARTIAL/RETURN/HOLD；普通验收不等于批准下一阶段。
- GitHub `main`保存**已确定的长期规范、状态、架构和获准可复用代码**。各轮大ZIP、原片与运行日志保存在本地`.local`与Owner备份，**不为每轮测试新增GitHub报告**。
- 本轮允许的清理仅针对经确认CWS独占、无依赖的隔离测试文件，不构成今后任意路径的通用删除许可；旧[受控清理合同](PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md)的保护和授权原则仍适用。
- PR #129已经把经过Review的**独立工具源码**正式纳入Git；产生的素材、运行证据继续只保留在`.local`。本轮文档更新只是记录已生效的事实和下一轮验收协议；**不安装/重启实际搜索服务，不修改OpenMontage/其他项目，不暗示节目授权PASS**。

[2026-10-12原状态（历史Git快照）](https://github.com/entropy-student/project/blob/9e58d202d66b831fd1ffeadf4e534307f49d74d9/curious-world-studio/docs/CURRENT_STATE.md)。
