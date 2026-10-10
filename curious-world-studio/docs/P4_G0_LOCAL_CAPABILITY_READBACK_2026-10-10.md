# P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md

**日期：** 2026-10-10（Asia/Shanghai）  
**审计状态：** `G0_CONDITIONAL`  
**审计范围：** 按 [G0 任务书](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md) 做 Windows 本机只读核查，并对照 `entropy-student/project` 的 `main` 分支文档。下文 OpenMontage 源码证据来自本机；上游静态报告只用于比较。

## 一句话结论

建议把 **OpenMontage 的素材/音频编排与 CWS 自有 Remotion A/B 视觉层**保留为首选方案：本机可见 OpenMontage、Remotion 4.0.484、Node、FFmpeg 和 atelier 入口，支持方案层面的接入设计；但安装目录没有 Git 元数据，中文已定稿文案强制对齐能力未证实，Qwen 配置不能核验，且没有做任何运行或渲染验证。因此目前只能给出**条件式集成设计**，不能称为已直接接入或生产就绪。

## 1. 本机环境矩阵

`OM_ROOT` 指 `C:\Users\34707\Tools\OpenMontage`。除该根目录和任务指定的 Skill 路径外，不展开私人文件或素材内容。

| 项目 | 状态 | 本机证据与边界 |
|---|---|---|
| OpenMontage 根目录 | **PRESENT** | `Test-Path` 命中 `OM_ROOT`；仅读根目录清单。 |
| 本机 Git 仓库、commit、origin、源码改动状态 | **UNKNOWN** | `OM_ROOT\.git` 不存在；`git rev-parse`、`git status --short` 未提供仓库信息。无法确认来源、提交 SHA 或相对上游的改动。 |
| 本机声明版本 | **PRESENT** | `setup.py` 声明 `openmontage` 版本 `0.1.0`；这不是可核实的 Git 版本。 |
| 本机许可证文件 | **PRESENT** | `LICENSE` 开头为 GNU AGPL 第 3 版。因 origin/commit 未知，不能据此确认其对应的确切上游仓库或源码状态。 |
| OpenMontage Codex Skill | **PRESENT** | `C:\Users\34707\.agents\skills\openmontage\SKILL.md` 存在，声明可通过 `$openmontage` 明确调用，并指向 `OM_ROOT`。Skill 声明默认中文 TTS 为 DashScope `qwen-audio-3.1-tts-flash`、`longzhe_v3.1`、`zh`。 |
| Skill 指向的 Python 虚拟环境 | **PRESENT** | `OM_ROOT\.venv\Scripts\python.exe` 存在，版本查询为 Python 3.10.11。未运行 preflight。 |
| `.env` / Qwen 凭据配置 | **UNKNOWN** | 根目录清单显示存在 `.env` 文件名；Skill 声明其中有 Workspace 配置。但按任务要求没有读取 `.env`，所以实际配置是否存在、是否可用均不能核实。没有调用 TTS。 |
| Node / npm / npx | **PRESENT** | `Get-Command` 可见；Node `v24.19.0`、npm `11.17.0`。版本只表示命令可查询，不证明具体渲染可运行。 |
| Remotion Composer 与依赖 | **PRESENT** | `remotion-composer\package.json`、`node_modules` 存在；manifest 依赖范围为 `^4.0.484`，本机包 `remotion`、`@remotion/cli`、`@remotion/captions` 均为 `4.0.484`。目录存在不等于构建或渲染通过。 |
| FFmpeg / ffprobe | **PRESENT** | `Get-Command` 可见；版本查询为 FFmpeg/ffprobe `9.0`。未执行编码、探测媒体或合成。可执行文件位置已核实，但报告不复述用户配置目录下的完整程序路径。 |
| `video_compose.py` / atelier 接口 | **PRESENT** | `tools\video\video_compose.py` 存在；只读检查了运行时可用性条件、路由、atelier 与 `get_info`。未调用这些函数。 |
| 工作流文件 | **PRESENT** | `pipeline_defs\animated-explainer.yaml`、`pipeline_defs\documentary-montage.yaml` 均存在；具体约束见第 3 节。 |
| 上游工件 schema | **PRESENT** | `schemas\artifacts\asset_manifest.schema.json` 与 `edit_decisions.schema.json` 存在，二者 `version` 常量均为 `1.0`，顶层 `additionalProperties: false`。 |
| 实际 episode manifest、SRT、音频主轨 | **UNKNOWN** | 只按文件名筛选清单，没有打开用户素材；筛选结果没有发现实际 episode 工件。被忽略目录或其他位置是否存在这些文件，不能据此断言。 |
| 中文转录/对齐代码 | **PRESENT** | `tools\analysis\transcriber.py`、`tools\subtitle\subtitle_gen.py` 存在；代码能力边界见第 3 节。 |
| faster-whisper / WhisperX 在 OpenMontage venv 中 | **MISSING** | `OM_ROOT\.venv\Lib\site-packages` 的限定名称检查未发现 `faster_whisper`、`whisperx` 或 `stable_whisper`。其他全局 Python 环境中的模块状态未核查。 |
| CWS 本地仓库 | **MISSING** | 当前工作区不是 `entropy-student/project` 克隆；当前工作区下无 `.git`、`curious-world-studio` 或其 `docs` 目录。未克隆或新建本地项目。 |

## 2. 与上游 P4-G0 静态报告的差异

对照 [CURRENT_STATE](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/CURRENT_STATE.md)、[上游静态审计](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md) 与 [生产架构计划](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md)：

1. **本机路径和 Skill 不再是全 UNKNOWN。** 指定的 OpenMontage 根目录、Skill、Python venv 和 Composer 文件均存在。但源码来源、Git commit 和相对上游是否有改动仍 UNKNOWN。
2. **Remotion/Node/FFmpeg 版本现在可见。** Composer 中 Remotion 相关包为 `4.0.484`；Node `24.19.0`、npm `11.17.0`、FFmpeg/ffprobe `9.0`。`_remotion_available` 所检查的 `npx`、composer manifest、`node_modules` 均存在，**但没有运行该检查或实际渲染**。
3. **atelier 接口得到本机源码确认，并发现写入边界。** `render_runtime=remotion` 加 `composition_mode=atelier`（或 `renderer_family=bespoke`）会走 `_render_via_atelier`；入口、composition ID 和 props 路径均有明确参数。项目文件不在 Composer 内时，atelier 会把源码文件复制到 `remotion-composer\projects\<slug>`；执行渲染也会创建输出目录。因此它并非只读调用，G0 没有调用。
4. **工作流约束比静态报告中的概要更明确。** `animated-explainer` 的脚本审查绑定选定时长 ±10%；资产阶段要求 `tts_selector` 和 `image_selector`；编辑审查要求音乐配置及 ducking；合成审查有时长目标。`documentary-montage` 明确要求 music plan 和 end-tag。它们都不能不加调整地保证 CWS 的自然时长与可无 BGM。
5. **字幕能力从“未知”缩小为“没有证实的定稿文案强制对齐接口”。** 本机转录器核心使用 faster-whisper 的 ASR 字级时间戳；WhisperX 对齐出现在可选 diarization 分支，转录器输入没有定稿文案参数，且相应模块未在 OpenMontage venv 中发现。因此，不能把转录时间戳当作定稿中文强制对齐结果。
6. **Qwen 路由有声明，密钥/配置仍未知。** Skill 与 `tools\audio\dashscope_tts.py` 的源码声明支持 DashScope/Qwen 路径；实际 `.env` 配置按要求未读取，不能确认配置存在或可调用。
7. **许可证线索与静态报告相符，但仓库归属仍未证实。** 本机 `LICENSE` 是 AGPL-3.0，和静态报告对 `calesthio/OpenMontage` 的描述一致；无 Git origin/commit，不能据此断定本机就是该仓库的哪个版本。静态报告关于 Remotion 商用条款需另行审查的提示仍适用。

没有发现足以把本机标为渲染通过、中文字幕已对齐或生产就绪的新证据。

## 3. 集成蓝图与本机接口证据

### 3.1 首选 A：OpenMontage 编排 + CWS 自有 Remotion A/B

**建议作为条件式首选。** 复用 OpenMontage 的素材检索和音频工具；由 CWS 自有时间线/权利账本作为母数据；使用项目级 Remotion 入口表达固定 A/B Chrome 和研究视口。不要将 CWS 字段塞进 OpenMontage 的工件字段。

相关本机路径与行为：

- `OM_ROOT\tools\video\video_compose.py:234-247`：`_remotion_available` 只检查 `npx`、Composer、`package.json` 与 `node_modules` 是否存在。
- `OM_ROOT\tools\video\video_compose.py:267-284`：`get_info` 整理 render engines；未调用。
- `OM_ROOT\tools\video\video_compose.py:933-1044`：`_render_via_atelier` 接收 `bespoke.entry`、`composition_id`、可选 `props_path` 等，并组装 `npx remotion render` 命令。
- `OM_ROOT\tools\video\video_compose.py:1539-1582`：需要显式 `render_runtime`；Remotion atelier 请求才进入该分支，没有静默切换 runtime。
- `OM_ROOT\tools\video\video_compose.py:1114-1187`：项目不在 Composer 中时会复制源码到 Composer 的 `projects` 子目录。
- `OM_ROOT\tools\video\video_compose.py:1204-1253`：检查 atelier 项目是否导入 stock creative registry，并要求声明 art direction。
- `OM_ROOT\remotion-composer\src\Root.tsx:138-144`：已有标准 `Explainer` composition，1920×1080、30fps。`Root.tsx` 注册的标准画面不是 CWS 的 Aqua/QuickTime 构图；`Explainer` 默认字幕组件也不符合 CWS 的无逐词高亮要求。

atelier 的源码说明将其设计成每片 bespoke，要求新的视觉方向，并且会写入 Composer staging 目录。这与“跨集固定 A/B Chrome”存在治理和复用上的张力。未来如选择 A，需由 Owner 在 G1 单独授权该写入和固定外壳复用方式；否则改用 B。无需预先修改 OpenMontage 的 `Root.tsx` 或通用 renderer。

### 3.2 备选 B：独立 CWS Remotion 入口

若后续确认 atelier 复用规则不适合固定 Chrome，或其依赖/运行时不支持，可在 CWS 项目内独立维护 Remotion 入口与 A/B 组件，继续把 OpenMontage 用于素材检索、音频处理及经批准的资产生产。

增量工作包括：CWS 自有 package/入口和时间线 props 适配器；资产路径与权利台账映射；单行字幕与时间轴组件；独立输出及验证流程。它避免修改 OpenMontage 源码和 atelier 自动 staging，但独立项目的依赖解析、Remotion 许可审查及 QA 接口都未核验；如需安装，必须另获 Owner 授权。本轮没有创建这些代码。

### 3.3 四份工件合同草图

以下为**设计草图，不是现存文件，也没有验证过的 JSON Schema**。CWS 自有文档可自定义字段；上游 `asset_manifest v1.0`、`edit_decisions v1.0` 按本机 schema 白名单输出，不增设 `beat_id`、`rights_verified` 等字段。

**`CWS episode_timeline.json`**

```json
{
  "version": "CWS_EPISODE_TIMELINE_DRAFT_1",
  "episode_id": "CWS-EP-EXAMPLE",
  "canvas": { "width": 1920, "height": 1080, "fps": 30 },
  "clock": {
    "master_audio_asset_id": "AUD001",
    "audio_offset_ms": 0,
    "a_prefix_duration_ms": 1800
  },
  "lines": [
    {
      "line_id": "L001",
      "beat_id": "B01",
      "text": "经审定的旁白句子",
      "start_ms": 0,
      "end_ms": 1800
    }
  ],
  "shots": [
    {
      "shot_id": "S001",
      "beat_id": "B01",
      "asset_id": "A001",
      "start_ms": 1800,
      "end_ms": 4200,
      "source_in_ms": 0,
      "source_out_ms": 2400,
      "fit": "contain",
      "evidence_class": "论文证据"
    }
  ],
  "subtitles": [
    {
      "line_id": "L001",
      "text": "经听审后确定的单行字幕",
      "start_ms": 0,
      "end_ms": 1800,
      "highlight": "none"
    }
  ]
}
```

**`CWS rights_ledger.json`**

```json
{
  "version": "CWS_RIGHTS_LEDGER_DRAFT_1",
  "assets": [
    {
      "asset_id": "A001",
      "evidence_class": "论文证据",
      "source_url": "<source-url>",
      "creator": "<creator-or-institution>",
      "rights_basis": "<license-or-permission-basis>",
      "required_attribution": "<attribution-text>",
      "review_status": "UNKNOWN",
      "checked_at": null
    }
  ]
}
```

**`asset_manifest v1.0`**（仅示意上游允许字段）

```json
{
  "version": "1.0",
  "assets": [
    {
      "id": "A001",
      "type": "image",
      "path": "assets/A001.png",
      "source_tool": "cws_adapter",
      "scene_id": "S001",
      "original_url": "<source-url>"
    }
  ]
}
```

本机 schema 的 `assets` item 必需字段为 `id`、`type`、`path`、`source_tool`、`scene_id`；许可、提供方等只能按 schema 已列字段映射。权利核查状态和证据类别保留在 CWS 自有 ledger/timeline。

**`edit_decisions v1.0`**（仅示意合法的 atelier 路由字段）

```json
{
  "version": "1.0",
  "cuts": [
    {
      "id": "S001",
      "source": "assets/A001.png",
      "in_seconds": 0,
      "out_seconds": 2.4
    }
  ],
  "render_runtime": "remotion",
  "composition_mode": "atelier",
  "bespoke": {
    "entry": "projects/cws-episode/entry.tsx",
    "composition_id": "CWSAB",
    "props_path": "<CWS episode props path>"
  }
}
```

本机 schema 要求 `version`、`cuts`、`render_runtime`；`cuts` 必需字段为 `id`、`source`、`in_seconds`、`out_seconds`。`composition_mode` 与 `bespoke` 是已列字段。`cut` 没有 CWS 的 `line_id`、`beat_id` 或直接输出时间轴字段，因此它们留在 CWS 时间线 props 内。适配器负责将 `asset_id` 解析到 manifest 路径，并把源素材裁切时间转换成秒；不能误把源内裁切时间当成完整输出时间轴。

| CWS 字段 | 上游映射/处理 |
|---|---|
| `asset_id` | `asset_manifest.assets[].id`；由适配器映射到 `cuts[].source` 可解析路径。 |
| `shot_id` | `edit_decisions.cuts[].id`。 |
| `source_in_ms` / `source_out_ms` | `cuts[].in_seconds` / `out_seconds`，毫秒转秒。 |
| `line_id` / `beat_id` / `start_ms` / `end_ms` | 保留在 CWS 时间线和传给 Remotion 的 props；不向严格上游对象扩字段。 |
| `source_url` / 权利依据 / 署名 / 核查状态 | CWS `rights_ledger.json`；只有 schema 已列字段才投影到上游 manifest。 |
| renderer 配置 | 使用 schema 已有的 `render_runtime`、`composition_mode`、`bespoke.entry`、`composition_id`、`props_path`。 |

### 3.4 时间轴、A/B、字幕与证据素材

- **单一主时钟：**以最终 `master_audio` 的整数毫秒为基准。`audio_offset_ms` 明确音轨相对视频的起点；若旁白从视频第 0 毫秒开始则为 0，若 A 桌面作为静音前缀则设为其实际时长。只在适配时应用一次偏移，禁止在字幕、镜头、组件中各自追加偏移。
- **帧边界：**集中将毫秒映射为 `round(video_ms * 30 / 1000)` 的整数帧；用统一边界和半开帧区间 `[start_frame, end_frame)`，避免逐段独立取整产生黑帧或重叠。
- **A/B：**A 为 1.5–3 秒桌面前缀，可按故事冷开场缩短或跳过；B 为满幅 QuickTime 风格播放器，所有主素材在播放器屏幕内切换；不设 C。B 中素材 `contain`，保留图表和研究证据完整。
- **字幕：**CWS `SingleLineSubtitle` 必须由最终音轨对齐结果驱动；单行、语义断句、无逐词高亮。现有 subtitle generator 默认最多 42 字符/每 cue 8 词，虽支持 `highlight_style=none`，仍需为 CWS 覆盖长度和版面策略。不得把 ASR 或旧 SRT 标为完成的强制对齐。
- **五类画面：**只使用 `原始实验`、`论文证据`、`独立复现`、`辅助素材`、`示意画面` 标签。图库片段、论文视频、原创图分别按来源 URL、作者、权利依据、署名要求和核查状态登记。不能因为网友上传或论文许可就推断另一段视频可商用；辅助素材和示意图不得标成原实验。

## 4. 逐项风险与依赖

| 风险/依赖 | 影响与处理 |
|---|---|
| 来源和版本不明 | 本机无 `.git`；无法确认究竟属于哪个 OpenMontage 仓库或是否本地改过。定版前需 Owner 确认来源、提交与许可。 |
| 定稿中文强制对齐 | `tools\analysis\transcriber.py` 的输入是音频路径、模型和语言；实际用 faster-whisper 转录并产出词级 ASR 时间戳。可选 WhisperX 路径位于 diarization 分支，且相关模块未在 OM venv 发现。**本机未证实定稿文本对音频的中文强制对齐能力。** |
| TTS 配置和费用 | Skill 声明 DashScope Qwen 默认路线，但 `.env` 未读取，不能确认配置可用。任何 TTS 云调用或费用都需后续 Owner 单独批准；本报告没有调用。 |
| 工作流绑定 | `animated-explainer` 的目标时长审查、TTS/image required tools 与音乐配置审查不适合原样套用；`documentary-montage` 另有强制音乐/end-tag。只复用可控工具或经批准调整的阶段，不能自动改写故事规则。 |
| atelier 写入和复用约束 | atelier 渲染会生成输出并可能复制源码到 OpenMontage Composer 目录；其 per-video art-direction / stock-import 检查也需与固定 CWS 外壳协调。G0 未调用。 |
| 字幕视觉行为 | CWS 固定单行无高亮与 OpenMontage 默认 Explainer 字幕风格不同，必须由 CWS 组件掌控。 |
| 素材和商用许可 | 本轮没有读取用户素材，也没有逐件审核图库、论文视频或图表许可。本机 AGPL LICENSE 不证明第三方素材可商用；Remotion 商业使用条件也仍需在正式产品化前审查。 |

## 5. 新 G1 短片验证计划（仅提案，未执行）

**不启动 G1。** [CURRENT_STATE](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/CURRENT_STATE.md) 要求另获 Owner 批准；旧 12 秒短片不重跑，也不作今天本机全链路通过证据。

- **输入：**Owner 单独批准的一段 20–30 秒审定旁白及对应最终音频；Owner 提供或已核准的本地论文图/自制示意图。使用到的素材逐件登记；没有权利确认的外部素材不加入。
- **费用假设：**用 Owner 提供音轨与本地素材，不调用云 TTS、不购入图库素材，则预计新增 API/素材支出为 **0**；不含电力、人工以及尚未审查的 Remotion 商用许可。若需要 TTS、下载或购买素材，先另行确认报价和授权。
- **依赖：**现存 Node/Remotion、FFmpeg、CWS 时间线和 rights adapter；并先由 Owner 决定强制对齐工具/人工听审方案。缺少对齐时不得用转录粗时间码冒充通过。
- **验收指标：**输出为 1920×1080、30fps；A 前缀符合提案时长或获批冷开场，随后 B 满幅且无 C；素材 contain 保留证据；字幕严格单行无高亮，逐句对最终音轨听审；时间轴映射为连续整数帧、没有空帧/黑帧或音画错位；每项素材有正确类别标签和权利状态。
- **回滚：**只在单独的 CWS G1 工作目录写入，渲染输出使用独立目录，不覆盖源音频/素材。若采用 atelier，其 staging 会写到 OpenMontage 目录，须在 G1 授权中明确这一副作用；不接受时改用独立 CWS Remotion 方案。失败时停在隔离目录，不自动安装、升级或切换渲染器。

## 6. 结果状态与变化声明

**结果：`G0_CONDITIONAL`。** 本机路径和关键文件可见，蓝图可以继续评估；但来源/commit、中文定稿强制对齐、实际 TTS 配置和渲染运行状态仍缺本机证据。不得标记 `G0_DESIGN_READY_NO_RENDER` 或 `PRODUCTION_READY`。

本轮报告通过聊天完整 Markdown 交付，**未写入磁盘、未提交 GitHub、未创建分支或 PR**：当前工作区没有 `entropy-student/project` 本地克隆；按任务书未克隆或新建项目。除只读文件/版本查询和读取指定 GitHub `main` 文档外，本轮没有安装、下载到本机、测试、渲染、生成音视频、调用云模型/付费 API、读取 `.env`、触碰其他项目或修改系统配置。

**参考文档：**[上游静态审计](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md)、[生产架构计划](https://github.com/entropy-student/project/blob/main/curious-world-studio/docs/VIDEO_PRODUCTION_ARCHITECTURE_PLAN_2026-10-10.md)、[STYLE_LOCK](https://github.com/entropy-student/project/blob/main/curious-world-studio/visual/retro-mac-v1.2/docs/STYLE_LOCK.md)、[视觉预览](https://github.com/entropy-student/project/blob/main/curious-world-studio/visual/retro-mac-v1.2/preview/index.html)。