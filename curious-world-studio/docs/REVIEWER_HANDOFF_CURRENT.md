# CWS｜当前Reviewer交接（2026-10-15）

> **最新接手点**：素材基础设施多轮专项验收已完成，最后是`R4R5_PARTIAL_ACCEPT / NON_PEERTUBE_10_SITE_TARGET_MET`；2026-10-12的“所有后续工作暂停”仅是当时快照，不再阻止Owner已授权完成的MEDIA实验。**但正式节目仍**`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。
>
> 阅读顺序：[CURRENT_STATE](CURRENT_STATE.md) → [MEDIA技术架构与阶段映射](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md) → [AGENTS](../AGENTS.md) → 有关具体编辑/来源/视觉问题再读历史[2026-10-12主线交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)。

## 一、项目目的与角色

CWS（Curious World Studio）是Owner的不露脸、观点驱动、跨领域真实问题视频制作项目，B站为主；Research Aqua A→B视觉参考、3+1真实素材合同、36条题库仍有效。不是一个现成第三方软件。ChatGPT充当主编/独立Reviewer，本地Windows Codex负责实际执行，Owner决定费用/删除/外联/正式Gate/发布；普通实验以一个ZIP、SHA和原始日志交接，正式生产代码需分支PR及Reviewer核验。

## 二、截至2026-10-15确实做了什么

1. **搜索发现**：SearXNG + 4get；历史对照视频合并1,533个去重URL，图片813个；4get对比SearXNG额外增74个视频URL和476个图片URL，但当时视频来源增量域名为0。这是URL数量不是可用素材数。
2. **媒体闭环**：批量候选、浏览/抽帧、选择性yt-dlp下载、FFprobe/FFmpeg QA和HTML本地素材库实测；22段视频+31张图片新增，跨题咖啡动作不匹配，`ACTION_MATCH_PARTIAL`。
3. **网站覆盖**：前次R3 300个网站标识入表、197站真实下载尝试、153站成功，151个PeerTube实例+PBS/ARD；135个不同文件SHA。网站数不能冒充家族数。
4. **最新R4+R5**：经受控清理删22,639个CWS独占You-Get/Lux文件、674,230,911字节（约643MiB）；76个注册域名进入探测，18次下载/QA尝试，**10个非PeerTube网站成功**（PBS/ARD复验+8个相对历史基线新增）；10个不同文件SHA。来源：PBS、ARD、DVIDS、NPS、DW、USGS、NOAA、NASA SVS、Wikimedia Commons、Mixkit。
5. **画质**：最近10份原片中2条1080p、5条720p、3条低于720p；本轮最高1920×1080@30fps；R3历史最高实测4K。
6. **规则**：本地MEDIA排除大陆平台、所有竖屏和方形，按旋转/SAR修正判断至少4:3横屏，未知画质先核实；过滤8/8与QA12/12独立回归通过。**尚未进Git正式生产素材入口**。
7. **删除边界**：只确认CWS隔离文件，保留yt-dlp/FFmpeg/SearXNG/4get/OpenMontage/历史证据；以前的零删除审计属于2026-10-11不同范围，不得覆盖2026-10-15确实删除的记录。

## 三、最新独立Reviewer结论

- 总裁决：`R4R5_PARTIAL_ACCEPT / NON_PEERTUBE_10_SITE_TARGET_MET / CLEANUP_EVIDENCE_PASS / FORMAL_CWS_INTEGRATION_NOT_DONE`。
- G0清理PASS（基于执行端回读）；G1本地过滤PASS；G2历史修复PARTIAL；G3非PeerTube十站PASS；G4失败复盘PARTIAL；G5看板PARTIAL；G6证据PASS。
- Reviewer核算清理明细22,639项与金额字节，ZIP中141项文件SHA及十段真实视频短预览独立全片解码通过。完整约330.25MiB原片没装入ZIP，原片SHA/完整解码**只是本机执行端证据**；不能说Reviewer也重解码过完整原片。HTML看板独立浏览器受策略拦截，不能写为已完成浏览器交互验收。
- 66个非合格域名中32个缺正确单视频样本页，不代表66个下载失败。Archive低清视频可解码但未达测试门槛，ZDF部分HLS损坏，NRK/RaiPlay/Democracy Now未真正下载，5个站点统一错误类别尚缺；4get清理后HTTP200/零搜索结果需再测。
- MEDIA技术成功不等于研究真实动作匹配，不等于可正式复用或已获得制片授权。

## 四、最新Owner决策与下一轮安排

已确定：从新素材采集开始默认**排除大陆视频平台、全球竖屏/方形视频；优先1080p横屏；保留严格QA和可追溯拒绝原因**。已确认独占的无效实验文件可有边界清理、不可碰共享工具。SearXNG与4get继续互补，yt-dlp为主下载器，FFmpeg/FFprobe作技术QA，OpenMontage不删除。

**R4+R5已执行，不要再把“去运行合并R4+R5提示词”当下一步。** 当前只是Owner要求**更新GitHub长期文档和交接**，不下发新开发任务。未来如Owner授权，优先`MEDIA-INTEGRATION`把本地通过的规则接入正式素材入口，采用分支PR；随后`MEDIA-R6`动作/时间码精准匹配，再`MEDIA-R7`分镜素材包。旧“R4四轮主线”是`PROD-R4`，正式视频制作仍HOLD。

## 五、证据包与溯源

- `CWS_MEDIA_SEARCH_BENCHMARK_R1_20261013.zip` + `CWS_MEDIA_SEARCH_R1_REVIEWER_DECISION_2026-10-13.md`
- `CWS_MEDIA_PIPELINE_R2_20261013.zip` + `CWS_MEDIA_PIPELINE_R2_REVIEWER_DECISION_2026-10-13.md`
- `CWS_INTERNATIONAL_VIDEO_SITE_COVERAGE_R3_20261013.zip` + `CWS_INTERNATIONAL_VIDEO_SITE_COVERAGE_R3_REVIEWER_DECISION_2026-10-14.md`
- 最新`CWS_R4R5_CLEANUP_DIVERSIFICATION_20261015.zip`，外层SHA-256：`b6c5117305d3d7d824af99b55920ca7fb738d799f5a60f14e708425ec883ddd1`；对应`CWS_R4R5_REVIEWER_DECISION_2026-10-15.md`。
- 证据/大媒体存Owner Windows本机和Reviewer上传ZIP，不应该上传Git仓库；恢复工作前核实每个文件的真实本机位置，不能假设沙箱路径即Owner路径。旧[主线完整交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)的科研权利与视觉细节仍有效。
- 新Reviewer不要反复跑同一300站/153预览、不要重新测You-Get/Lux；只在Owner授权的明确Gate内动手。

## 六、接手一句话

**已把素材“找得到/下载/解码”的测试底座做出来，最新非PeerTube真实成功10站并完成受控清理；正式生产入口尚未接入最新过滤/素材索引；下一步建议小范围集成，然后做动作匹配和分镜交付；CW-0005制片与授权仍HOLD。**
