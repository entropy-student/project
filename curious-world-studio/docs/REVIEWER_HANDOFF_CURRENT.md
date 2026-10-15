# CWS｜当前Reviewer交接（2026-10-15）

> **最新接手点（2026-10-15）**：经独立Reviewer接受的[PR #129](https://github.com/entropy-student/project/pull/129) **已合并到main**（squash commit `10b369ee5558ed9a0ac2f738aea978623f62ba0f`），MEDIA工具具备Windows搜索/指定ID下载/FFprobe+FFmpeg QA的实证基础。Owner已中断上一轮**MEDIA-DOCKERFREE-ACCEPTANCE**部署探索，改为**Windows按需启动/用毕停止、无VPS/无Docker/无常驻**；G0已得到Reviewer证据级接受；G1A随后执行本地启停与媒体QA并被独立Reviewer评为 **`G1A_LOCAL_LIFECYCLE_PARTIAL_ACCEPT`**，浏览器播放未验，**仍没有Docker-free或按需完整搜索链PASS证据**。正式节目仍`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。
>
> 阅读顺序：[CURRENT_STATE](CURRENT_STATE.md) → [MEDIA技术架构与阶段映射](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md) → [按需运行恢复Gate](MEDIA_ONDEMAND_RECOVERY_AND_START_STOP_POLICY.md) → [暂停的旧无DockerGate](MEDIA_DOCKERFREE_RUNTIME_AND_ACCEPTANCE.md) → [AGENTS](../AGENTS.md) → 需要科研/版权历史时再读[2026-10-12制片交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)。

## 最新G1A局部验收（2026-10-15，优先于旧G0建议）

- **Reviewer裁决：`G1A_LOCAL_LIFECYCLE_PARTIAL_ACCEPT / BROWSER_NOT_VERIFIED / SEARCH_NOT_IN_SCOPE`。** 接受本地生命周期管理和媒体QA的执行证据，不升级完整G1A或完整MEDIA搜索链。ZIP `CWS_MEDIA_ONDEMAND_G1A_LOCAL_LIFECYCLE_20261015.zip`，SHA256 `4f5d7d7874830feb18597b76e4164f0f2b224ebb60cda4667fbec74e14b0bacc`；CRC通过，32条SHA256SUMS+31项manifest一致；脚本可静态解析。
- 复用**两段原有视频、1张图片，未重新下载**。提供了来源文件SHA、FFprobe JSON、FFmpeg完成且退出0的日志；原片不在ZIP，Reviewer没有独立重新完整解码这3份媒体。6秒浏览器预览副本也未入ZIP。
- Windows本机`127.0.0.1:18765`实际服务和自检：占端不接管、重复启动不重开、常规关闭、异常子进程退出、关闭后端口释放，日志/JSON一致；HTTP HEAD对目录页、索引页、1段MP4资源返回200，**不证明浏览器真的播放**。
- Edge/Chrome播放及`currentTime`推进 **BLOCKED / NOT_VERIFIED**：Computer Use因不能可靠确认当前Edge URL而停止；不允许为了凑PASS绕过安全停止。下轮如果Owner同意，以Owner本人**人工**打开127.0.0.1页面、实际观察两个视频时间推进并交非敏感证据优先；只补缺口，不重复建立搜索服务。
- 原旧工作区3个tracked修改、两处缓存与61项中断资料继续保留；本轮脚本/HTML只在本机隔离目录，**未形成正式PR，勿误认其已经进main**。Exa未调用且数据存储权利未知；MEDIA-R6/R7、制片Gate维持HOLD。

## 最新G0恢复现场验收（2026-10-15，优先于下方历史“正在进行G0”叙述）

- Reviewer verdict: **`G0_RECOVERY_EVIDENCE_ACCEPT`**；只接受中断现场调查与低复杂度路线评估，**不授权自动开始G1**。提交ZIP：`CWS_MEDIA_ONDEMAND_G0_2026-10-15.zip`，SHA256 `05ff890e6b87c420754a315812c7199c3da6c7c09116db5f5ffb3281c69f8c42`；ZIP完整，16项SHA清单与15项manifest独立匹配。
- 执行端只读证据：本机旧端口18080/15050/18765无监听；无活动本地SearXNG/4get；Windows Python/yt-dlp/FFmpeg可用；Ubuntu-24.04、docker-desktop WSL当前Stopped。**不可从这些本机结果外推所有远端服务均不存在。**
- 中断运行遗留61项约1.747GB，含1.735GB WSL VHDX；均保留，未授权删除。旧Git工作区停留`codex/cws-media-integration-windows-20261015`、HEAD `4a14f024`，存在三个tracked变更和两个未跟踪__pycache__目录；需保护，切勿reset/clean/pull覆盖。
- 当前CWS `media-pipeline`只能用SearXNG/4get HTTP endpoint检索，既不能无服务直接关键词搜索，也不控制服务的启动与退出。已验证“本地媒体获取/QA能力”，**未验证无Docker/零常驻完整搜索链路**。
- Brave Search API当前普通条款允许操作所需瞬时存储，但未授予通常意义的搜索结果持久库权利；CWS的持久catalog不应直接保存未获许可的Brave响应。Exa的留存权利与媒体专用检索覆盖尚未知。G0已证实Codex有`mcporter / agent-reach / Exa`资料搜索路径，**只能作为G1前的候选，不能假定可长期存储或具备视频搜索能力**。
- 建议优先短路径：检查既有合法搜索工具的接口与存储许可（只读），并评估人工来源URL导入作为完全零搜索服务的保底模式；正式G1安装、API密钥、费用、真实媒体下载与Git代码改动仍要后续授权。

## 一、项目目的与角色

CWS（Curious World Studio）是Owner的不露脸、观点驱动、跨领域真实问题视频制作项目，B站为主；Research Aqua A→B视觉参考、3+1真实素材合同、36条题库仍有效。不是一个现成第三方软件。ChatGPT充当主编/独立Reviewer，本地Windows Codex负责实际执行，Owner决定费用/删除/外联/正式Gate/发布；普通实验以一个ZIP、SHA和原始日志交接，正式生产代码需分支PR及Reviewer核验。

## 二、截至2026-10-15确实做了什么

1. **搜索发现**：SearXNG + 4get；历史对照视频合并1,533个去重URL，图片813个；4get对比SearXNG额外增74个视频URL和476个图片URL，但当时视频来源增量域名为0。这是URL数量不是可用素材数。
2. **媒体闭环**：批量候选、浏览/抽帧、选择性yt-dlp下载、FFprobe/FFmpeg QA和HTML本地素材库实测；22段视频+31张图片新增，跨题咖啡动作不匹配，`ACTION_MATCH_PARTIAL`。
3. **网站覆盖**：前次R3 300个网站标识入表、197站真实下载尝试、153站成功，151个PeerTube实例+PBS/ARD；135个不同文件SHA。网站数不能冒充家族数。
4. **最新R4+R5**：经受控清理删22,639个CWS独占You-Get/Lux文件、674,230,911字节（约643MiB）；76个注册域名进入探测，18次下载/QA尝试，**10个非PeerTube网站成功**（PBS/ARD复验+8个相对历史基线新增）；10个不同文件SHA。来源：PBS、ARD、DVIDS、NPS、DW、USGS、NOAA、NASA SVS、Wikimedia Commons、Mixkit。
5. **画质**：最近10份原片中2条1080p、5条720p、3条低于720p；本轮最高1920×1080@30fps；R3历史最高实测4K。
6. **规则**：本地MEDIA排除大陆平台、所有竖屏和方形，按旋转/SAR修正判断至少4:3横屏，未知画质先核实；过滤8/8与QA12/12独立回归通过。**该规则已进入main的可选MEDIA工具入口，尚未替换正式节目制作链**。
7. **删除边界**：只确认CWS隔离文件，保留yt-dlp/FFmpeg/SearXNG/4get/OpenMontage/历史证据；以前的零删除审计属于2026-10-11不同范围，不得覆盖2026-10-15确实删除的记录。

## 三、2026-10-15新接受的MEDIA-INTEGRATION与下一轮

- PR #129：Windows搜索、过滤、手动ID下载和QA闭环已验证；初版发现批量错误退出码与远端私网URL校验不足，集中修复后Windows 36/36测试通过；独立Linux 35通过+1 Windows限定跳过；集中修复结论 `PR129_FOCUSED_FIX_ACCEPT`，合并commit `10b369ee`。
- 真实媒体：前一轮NASA SVS+Commons两视频及1图片完整解码曾在Reviewer环境独立执行；最后的PR集中修复回归取Commons 640×440、721帧，**原片未随最终ZIP上传，只能确认执行日志、SHA、代表帧，不能宣称独立重解码最后一轮原片**。NASA未知尺寸未计成功。
- 安全：本工具仅本地、人工ID、限定下载；DNS与实际socket未绑定，yt-dlp可能进行嵌套跳转，**非完整SSRF沙箱**，不能开放成公网站或无人值守任意URL处理。
- **Owner后续变更（覆盖上一条执行计划）**：上一轮Docker-free方案被强行中断；目前不继续VPS/原生搜索服务部署，也不要求常驻运行；只批准**Windows ONDEMAND只读恢复与技术选择评估**，详见[新Gate](MEDIA_ONDEMAND_RECOVERY_AND_START_STOP_POLICY.md)。不宣布Docker-free PASS，不启动MEDIA-R6或制片。

## 四、旧R4+R5历史Reviewer结论（仍保留）

- 总裁决：`R4R5_PARTIAL_ACCEPT / NON_PEERTUBE_10_SITE_TARGET_MET / CLEANUP_EVIDENCE_PASS / FORMAL_CWS_INTEGRATION_NOT_DONE`。
- G0清理PASS（基于执行端回读）；G1本地过滤PASS；G2历史修复PARTIAL；G3非PeerTube十站PASS；G4失败复盘PARTIAL；G5看板PARTIAL；G6证据PASS。
- Reviewer核算清理明细22,639项与金额字节，ZIP中141项文件SHA及十段真实视频短预览独立全片解码通过。完整约330.25MiB原片没装入ZIP，原片SHA/完整解码**只是本机执行端证据**；不能说Reviewer也重解码过完整原片。HTML看板独立浏览器受策略拦截，不能写为已完成浏览器交互验收。
- 66个非合格域名中32个缺正确单视频样本页，不代表66个下载失败。Archive低清视频可解码但未达测试门槛，ZDF部分HLS损坏，NRK/RaiPlay/Democracy Now未真正下载，5个站点统一错误类别尚缺；4get清理后HTTP200/零搜索结果需再测。
- MEDIA技术成功不等于研究真实动作匹配，不等于可正式复用或已获得制片授权。

## 四、最新Owner决策与下一轮安排

已确定：从新素材采集开始默认**排除大陆视频平台、全球竖屏/方形视频；优先1080p横屏；保留严格QA和可追溯拒绝原因**。已确认独占的无效实验文件可有边界清理、不可碰共享工具。SearXNG与4get继续互补，yt-dlp为主下载器，FFmpeg/FFprobe作技术QA，OpenMontage不删除。

**R4+R5已执行，PR #129 MEDIA-INTEGRATION也已合并。不要再次执行这两轮。** 此前Owner曾许可无Docker整链验收，但执行中被Owner强制终止，新决定是按需即用即停、Windows本机优先且不部署VPS；只先检查中断现场及现有搜索服务真实依赖，再由Reviewer决定是否发起受限的本地启停闭环。之后是否进入`MEDIA-R6`动作/时间码精准匹配与`MEDIA-R7`分镜素材包，须另行授权。旧“R4四轮主线”是`PROD-R4`，正式制片仍HOLD。

## 五、证据包与溯源

- `CWS_MEDIA_SEARCH_BENCHMARK_R1_20261013.zip` + `CWS_MEDIA_SEARCH_R1_REVIEWER_DECISION_2026-10-13.md`
- `CWS_MEDIA_PIPELINE_R2_20261013.zip` + `CWS_MEDIA_PIPELINE_R2_REVIEWER_DECISION_2026-10-13.md`
- `CWS_INTERNATIONAL_VIDEO_SITE_COVERAGE_R3_20261013.zip` + `CWS_INTERNATIONAL_VIDEO_SITE_COVERAGE_R3_REVIEWER_DECISION_2026-10-14.md`
- 最新`CWS_R4R5_CLEANUP_DIVERSIFICATION_20261015.zip`，外层SHA-256：`b6c5117305d3d7d824af99b55920ca7fb738d799f5a60f14e708425ec883ddd1`；对应`CWS_R4R5_REVIEWER_DECISION_2026-10-15.md`。
- 证据/大媒体存Owner Windows本机和Reviewer上传ZIP，不应该上传Git仓库；恢复工作前核实每个文件的真实本机位置，不能假设沙箱路径即Owner路径。旧[主线完整交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)的科研权利与视觉细节仍有效。
- 新Reviewer不要反复跑同一300站/153预览、不要重新测You-Get/Lux；只在Owner授权的明确Gate内动手。

## 六、接手一句话

**PR #129已合并main，CWS的独立本地MEDIA工具已代码验收，但正式制片未接入且无Docker整链未实际验收。Owner当前仅推进MEDIA-ONDEMAND-RECOVERY-G0，下一步本机启停验收需另行批准，之后才考虑R6/R7；CW-0005与G1/G2继续HOLD。**
