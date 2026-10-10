# G0 本地 Codex 一次执行任务书｜能力只读审计 + 集成蓝图（严禁测试/生成）

**状态**：用于让 Owner 的 Windows 本地 Codex 接管本次 G0 的**尚未完成的本机证据核查**。本任务已获 Owner 2026-10-10“合并G0后进入下一步”的计划授权，但 **不含任何生产/测试/改环境/自动发布的授权**。不要把仓库的上游静态研究当作本机证据。

## 你应该收到的上下文

- 私有仓：`entropy-student/project` 的 `curious-world-studio`。
- 首先只读：`docs/CURRENT_STATE.md`、`docs/VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md`、`docs/P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md`、`visual/retro-mac-v1.2/docs/STYLE_LOCK.md`、`visual/retro-mac-v1.2/preview/index.html`。
- Owner 本地可能的安装：`C:\Users\34707\Tools\OpenMontage`，技能位置 `C:\Users\34707\.agents\skills\openmontage\SKILL.md`；**这两条来自较早本地技术交接，不保证当前仍存在**。
- OpenMontage 主仓可能是 [calesthio/OpenMontage](https://github.com/calesthio/OpenMontage)（AGPL-3.0）；[Open-Montage-app/OpenMontage](https://github.com/Open-Montage-app/OpenMontage) 是另一仓。**先核本地 git 信息，不要假设版本、重装或自动更新**。
- 频道：B站不露脸的研究发现故事；A Tiger桌面短开场，B QuickTime全幅播放器，无 C；单行中文、不逐字高亮；事实/素材版权需区分；不强制视频分钟数、不为凑时间增文案。

## A. 严格执行约束

1. **本机只读**：不得安装、卸载、更新、清理、删除、覆盖、备份搬运、改变 PATH、启动 web 服务、运行编译/渲染/模型/TTS/素材下载、调用有费用的 API、触碰 VPS/SSH/Clash/VPN/WG/HY2。也不得运行 `npm install`、`npx` 自动下载、`pip install`、`ffmpeg` 编码、`remotion render`、`pytest` 或作品生产。
2. 可以执行只读查询（`Test-Path`、`Get-Item`、`Get-ChildItem`（限制特定目录） 、`Get-Content`（仅读非密钥源码）、`Get-Command`、`git status --short`、`git rev-parse HEAD`、`node --version`、`npm --version`、`ffmpeg -version` 前几行）。**不要读取或输出 `.env`、用户令牌、API密钥、配置密码、代理地址、cookies，甚至不要打印整个环境变量**。如果 git URL 里有凭据，截掉凭据部分再写报告。
3. **不改 OpenMontage 现有目录和任何生产配置**。你可在私有项目仓库 `curious-world-studio/docs/` 新增**文字 G0 报告**，如果已存在仓库并且你有权限，则新建文档分支 PR；如果没有项目仓库本地克隆或无 GitHub 权限，直接向 Owner 返回报告内容，**不擅自 clone 或新建本地项目**。不能为了提交报告影响用户当前运行工具。
4. 不要将旧的12秒短片测试再运行一遍，也不要把其历史 PASS 当作今天这台机器全流程 PASS。
5. 不准自动进入新 G1（20–30s样片），即使本机检测一切存在；那一步必须再得到 Owner 单独批准。

## B. 同一次审计里查询和填写（未找到就 UNKNOWN，不报虚假 PASS）

### B1. 本机环境 + 版本矩阵

针对上述**具体路径**及有限范围 `$HOME\Tools` / `$HOME\.agents\skills\openmontage`：

| 条目 | 只读证据 | 回答点 |
|---|---|---|
| OpenMontage 项目根目录 | `Test-Path`, 仅读根目录清单，若是Git仓：`git rev-parse HEAD`、`git status --short`，origin URL 脱敏 | 真实路径、commit、版本、是否有源码改动、原仓来源 |
| Codex OpenMontage Skill | `Test-Path` + `SKILL.md`（仅非敏感部分） | 能否以 `$openmontage` 接受调用；声明的动作/依赖与源码根目录 |
| Remotion | `remotion-composer/package.json`，`node_modules` 是否存在、`Get-Command node/npm/npx` 与 `node/npm --version` | 版本是否符合；**node_modules存在≠运行通过** |
| Python/FFmpeg | `Get-Command python/py/ffmpeg/ffprobe`;版本查询 | 可执行文件路径和版本是否可见 |
| 视频组合器 | 仅读 `tools/video/video_compose.py`（若存在）里的 `render_runtime`、`_remotion_available`、`_render_via_atelier`、`get_info` | 本地是否支持 `composition_mode=atelier`，`bespoke.entry` 与props；有无特殊限制 |
| 工作流 | 本地 `pipeline_defs/animated-explainer.yaml`、`documentary-montage.yaml` 是否存在 | 是否可复用 explainer 的 script/asset/edit/compose 而不带强制时长/音乐 |
| 资料/素材 | 只读文件名与已有 manifest/schemas，不打开用户素材或私人文件 | 是否已有 asset_manifest、字幕、音频主轨接口，原仓 schemas 的版本 |
| 中文字幕 | `tools/video/transcriber.py` 或 `tools/analysis/transcriber.py`、`subtitle_gen`、WhisperX/faster-whisper或可用模块（仅查源码及存在，不载入模型） | 中文强制对齐究竟存在、安装状态未知还是只有转录粗时间码 |
| 云TTS | 从安装文档/源码判断 Qwen/TTS 具体 provider（如 DashScope 路径），仅报告配置信息**是否存在**，不得查看秘钥值或调用 | 与历史交接中的“已配置 Qwen 云 TTS”是否一致 |
| 许可 | 本地 `LICENSE` 顶部、repo commit 的类型；如本地只有发行包无法认定归属则 UNKNOWN | AGPL-3.0/其他许可与未来产品化约束 |

### B2. 在读完真实本机接口后，同一轮输出最小集成设计

- 选择 **A 首选**：现有 OpenMontage 的资产编排 + CWS Remotion 自制固定 A/B chrome，通过其标准合成接口或 `atelier` 项目入口调用；具体标注所依赖的**本地代码函数路径**。说明是否要改原仓源码，优先不改。
- **B 备选**：若 `atelier` 或 npm安装状态无法承载，则独立 CWS Remotion 组件调用，仍沿用 OpenMontage asset检索和音频工具；列明增量工作、限制，**不在G0新建代码**。
- 只写下列合同草图并展示字段对照：`CWS episode_timeline.json`、`CWS rights_ledger.json`、`asset_manifest v1.0`、`edit_decisions v1.0`。确保 `additionalProperties:false` 的上游 schema 不被擅自扩字段而导致失败。
- 记录 `line_id / beat_id / shot_id / asset_id` 映射；master audio 的毫秒时钟，A桌面前缀偏移，30fps整数帧切点；`SingleLineSubtitle` 无逐词高亮，按实测音轨强制对齐；B player `contain`，所有关键研究证据图保持完整。
- 区分五类画面：原始实验、论文证据、独立复现、辅助素材、示意画面。图库/论文视频/自己制作按 source URL、权利依据、出处、核查状态入版权台账。不要只因为“网友上传”认定CC BY。
- 给新 G1 **拟议**的最小 20–30秒测试清单和预计依赖、费用、回滚措施；不实际做测试、不提前下载素材。

### B3. 最终报告的验收合同

输出一份 `P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md` 的完整 Markdown，至少包含：

1. **一句话结论**：建议 OpenMontage + Remotion 是否可直接接入；列出事实与猜测。
2. **本机环境矩阵**：每项 `PRESENT / MISSING / UNKNOWN`；带证据文件位置/命令摘要，不写敏感信息。
3. **上游版本偏差**：和仓库 P4-G0 静态报告不同处逐条列出。
4. **具体集成蓝图**：数据合同、A/B组件、字幕/音轨/素材/权利流，附本机相关源码行/路径。
5. **逐项风险与依赖**：绝不写“已经完成字幕对齐/渲染”。
6. **新 G1 短片验证计划**：只给后续的测试输入、验收指标和回滚策略。
7. **结果状态**：若关键本机信息齐全、蓝图可执行可标 `G0_DESIGN_READY_NO_RENDER`；否则 `G0_BLOCKED_MISSING_LOCAL_EVIDENCE` 或 `G0_CONDITIONAL`，不可写 `PRODUCTION_READY`。
8. **变化声明**：列本轮创建的文字报告及git提交/PR（如果有），明确没有安装、测试、渲染或触碰其他项目/系统。

**最终只回报摘要＋报告路径/PR，不输出任何 API secret、私人完整路径之外的额外敏感系统信息。**
