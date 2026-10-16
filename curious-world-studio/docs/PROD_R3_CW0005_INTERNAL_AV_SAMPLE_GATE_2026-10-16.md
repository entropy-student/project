# PROD-R3-CW0005-INTERNAL-AV-SAMPLE｜当前有界执行 Gate

> STATUS: OWNER_AUTHORIZED_NOT_EXECUTED（2026-10-16）。本Gate授权**本机内部观看的一条真实音画小样**，不代表完整制片、商用版权、公开发布或正式 CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH 已改变。

## 核心合同

**GATE_ID**：PROD-R3-CW0005-INTERNAL-AV-SAMPLE。

**OBJECTIVE**：以[已接受R2旁白和镜头表](CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)及既有两条真实爆米花辅助素材、既有 Qwen TTS longzhe_v3.1、Remotion/FFmpeg、Aqua桌面→QuickTime全幅播放器，做一条确实能看、能听、中文单行字幕的30–60秒内部MP4。

**MAX_ENDPOINT_THIS_ROUND**：只一条30–60秒内部样片及音频/字幕/时间轴/QA。若R2全稿以自然语速超过60秒，允许选一段连贯、科学语义完整的30–60秒进行同Gate验证，不机械提速、不断章取义。最多一次初次TTS及必要一次修正尝试；不自动R4、无正式长片或发布。

**MANDATORY_REVIEW_STOP**：Codex交付一个脱敏ZIP与外层SHA、退出全部本轮临时进程；只报告 PASS_CANDIDATE 或具体 RETURN_*，由独立Reviewer实听实看后决定PASS/RETURN，不自行提升正式G1/G2等Gate。

**TARGET_AND_SCOPE**：Owner原生Windows 11本机 curious-world-studio 项目；本轮只在 ignored .local/prod-r3-cw0005-internal/ 下新建独立运行目录；复用现有 OpenMontage、媒体适配器、Remotion/FFmpeg与来源片，禁止改动共用工具/其他项目或触碰公网部署。

**APPLICABLE_CRITICAL_CONSTRAINTS**：画面“相关、没有明显误导”即可，不要求精准论文高速科研视频。Pexels #854959/Pixabay #2793只作“辅助素材”，具体权利始终PARTIAL、不得充当论文实录；Owner不要求为**本轮内部试片**新开版权调查，但不视为公开/商用许可。3＋1真实素材、允许的2转场/4布局/6信息呈现、1920×1080@30fps、单行字幕、Aqua A→QuickTime B视觉锁有效；禁AI假实验、代码/SVG画实体、重复片段凑时长、未审stock声音伪装科研录音。

**PREFLIGHT**：在触碰文件前证明真的是Owner原生Windows本机、正确Git仓库/HEAD/本地工作树；只读检查R2生效文案、两条本地旧MP4真实存在且SHA分别与R2文件一致、配音账号/额度及工具可用、实际内存/磁盘、目标运行目录不会覆盖旧证据，复核零新付费/订阅需求。若本地素材/环境不满足，应RETURN具体阻塞，不假造素材和PASS。不得更改VPN/Clash/代理、Docker全局配置。

**REQUIRED_EVIDENCE**：实际MP4、旁白音频WAV或源音轨、基于真实声音的字幕/SRT与时间戳、分镜与真实source_in/out及时间轴映射、完整媒体元数据/解码结果、已对齐的单行字幕画面与实际可听声音抽样、片段来源/辅助标签与权利状态、真实本机/资源/原始工作区无关改动的佐证、原始失败和退出码、清理/停止本轮进程记录、ZIP文件SHA/Manifest。若获授权独立测试浏览器可用，用隔离实例核readyState/videoWidth/play/currentTime，不附着Owner私有Edge；若不可用，标BROWSER_AUTO_NOT_VERIFIED。

**ACCEPTANCE_CRITERIA**：有声、稳定可播放，字幕可读且按实际声音同步、严格单行；播放器满幅可读、没有遮挡关键真实画面；镜头实拍相关且不会让观众误以为库存片是科研原录像；论文事实与作者假说区分准确；未修改旧媒体/旧工作树或无关Docker/网络；真实MP4由Reviewer独立查看而非仅靠运行日志。相关即可，不要求逐帧对应论文机制。

**ROLLBACK_STATUS_OR_PLAN**：只写新唯一.local目录，旧MP4、ZIP、tracked改动与缓存仍保留；如中断只停止本轮新进程/本轮独立Compose（若确需开启），不运行git reset --hard/git clean/docker system prune/down -v等清理命令。发现非授权配置漂移、敏感输出或旧证据覆盖，停止并交Reviewer审查；本机真实回滚能力在Preflight时另行证明。

**OWNER_ONLY_ACTIONS**：本Gate批准现有额度内必要TTS调用和内部试片，不批准新充值/付费、媒体购买、外联、正式商业许可判断、全长生产/发布、R4、服务部署/网络变更、敏感删除。第三方明确禁止的使用不得绕过；记录实际素材权利PARTIAL，不冒称授权。

**REVIEWER_TO_EXECUTOR_RELAY**：本文件为唯一有效R3任务；只需按本Gate读取已接受[R2定稿](CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md)、[STYLE_LOCK](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)和[3＋1合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)，按需查相关渲染/配音源码入口；无需重新搜索全项目、重读Governance/历史ZIP或重复G2–G4/PR129/131/R6L。Preflight→Execute→Evidence→Reviewer Stop，不扩范围。

**EXECUTOR_TO_REVIEWER_RELAY**：单一ZIP及SHA；短报“结果、改动、验证、问题、回滚、请Reviewer检查、Owner转交”，详细证据在包内。本轮完成后不得启动新任务。

**当前执行证明**：NONE，未生成真实R3视频；接受目标不得预写PASS。
