# P4-G0｜本机报告 Reviewer 接口纠偏与 G1 衔接合同（草案）

**日期**：2026-10-11 · **性质**：对已收到的本机只读证据做非执行性的接口修订；不是生产 Schema、程序代码或 G1 授权。  
**当前结果**：`G0_CONDITIONAL / LOCAL_READBACK_RECEIVED / CONTRACT_REVIEWED / NO_RENDER / G1_NOT_AUTHORIZED`。G0 是否升为 `G0_DESIGN_READY_NO_RENDER` 应按本文件末尾待解决条件另行判定，不能因报告存在而自动升级。

## 0. 证据与优先级

- [CURRENT_STATE.md](CURRENT_STATE.md) 保持唯一当前状态；本文件仅解释 P4 工程合同，不改变频道、正式题库、STORY-FIT、P3 原型或 `STYLE_LOCK`。
- [Owner 本机 Codex 原始报告](P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md) 原样归档：报告称 OpenMontage/Skill、Remotion `4.0.484`、Node `24.19.0`、FFmpeg `9.0` 的相关路径存在，`atelier` 源码路径存在；本机安装无 `.git`、中文定稿文本强制对齐无已证实入口、Qwen 实际配置未知、没有渲染。该报告是本地 Agent 的只读观察，Reviewer **未独立登录 Windows 复测**。
- [上游静态审计](P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md) 与 [本地 G0 原任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md) 对照使用。上游 `asset_manifest v1.0` / `edit_decisions v1.0` 顶层 `additionalProperties: false`；**不得把 CWS 字段塞进上游严格工件**。
- 以下所有 JSON 是 `DRAFT_2` **文字合同示例**；`null` / `NOT_RUN` 表示没有生成素材、音频或时间戳，不代表编译、Schema 校验或渲染通过。

## 1. 纠偏一：A 开场、音频与镜头必须共用唯一坐标合同

原报告同时示意 `audio_offset_ms=0` 和 `a_prefix_duration_ms=1800`，本身不是必然冲突，但必须明确它们并不始终相等。

**唯一采用的坐标解释：**

- `master_audio` 的零点永远是最终旁白文件的 0ms；`lines[].start_audio_ms/end_audio_ms`、`captions[].start_audio_ms/end_audio_ms` 均使用**音轨相对时间**。
- `clock.audio_start_video_ms` 表示音轨在**最终视频时间轴**上的绝对播放起点，仅在 CWS 适配/编译为视频时间轴时**应用一次**：`video_ms = audio_ms + audio_start_video_ms`。
- `clock.a_prefix_duration_ms` 是 A 桌面占用的视频时长，不自动定义旁白起点。**方案甲：A 完全静音**，则 `audio_start_video_ms = a_prefix_duration_ms`；**方案乙：旁白在 A 开始**，则 `audio_start_video_ms = 0`，两者可以不同；**方案丙：直接冷开 B**，二者均为 0。具体选择须在 G1 输入清单锁定，不能由程序暗中推断。
- `shots[].start_video_ms/end_video_ms` 为最终视频坐标；`source_in_ms/source_out_ms` 则为原始媒资内部坐标，不能拿它当最终视频时间轴。`beat_id` 与 `line_id` 可被一个长镜头覆盖，不强制每句切镜。
- 30fps 统一做一次边界转换：`frame = round(video_ms * 30 / 1000)`；每个半开区间 `[start_frame,end_frame)` 从同一套边界计算；镜头覆盖和字幕区间由渲染前 QA 检查，不逐段独立四舍五入累计漂移。
- 最终视频长度从实际音轨有效结束与已审定画面尾段计算，不能强制 4–6 分钟或从 HTML demo 的 64 秒反推。

## 2. 纠偏二：权利账本必须保留三道独立核验

本地报告示意的 `review_status=UNKNOWN` 只能作附加摘要，**不能代替**如下互不蕴含的字段：

| 核验字段 | 允许表述 | 判断准则 |
|---|---|---|
| `link_found` | `LINK_FOUND / NOT_FOUND / UNKNOWN / NOT_APPLICABLE_INTERNAL` | 是否有可定位原始媒资链接；自制素材需有内部工程定位 |
| `content_verified` | `CONTENT_VERIFIED / NOT_VERIFIED / UNKNOWN` | 是否真正查看片段、图号/原文及其与旁白的对应关系 |
| `reuse_rights_verified` | `REUSE_RIGHTS_VERIFIED / NOT_VERIFIED / UNKNOWN` | **实际用于本片的那份媒资**能否按许可/授权/适用例外使用，并完成署名义务 |

三者不可因论文是 CC BY、网页能播放、图库搜索得分或软件许可证而自动打通。自制 `NOT_APPLICABLE_INTERNAL` 只是没有外部链接；仍需记录制作来源与第三方输入的权利。

**草案 `CWS rights_ledger.json`：**

```json
{
  "version": "CWS_RIGHTS_LEDGER_DRAFT_2",
  "assets": [{
    "asset_id": "A001",
    "source_kind": "research_figure",
    "evidence_label": "论文证据",
    "source_url": null,
    "source_location": null,
    "creator": null,
    "license_name": null,
    "license_url": null,
    "rights_basis": null,
    "required_attribution": null,
    "verification": {
      "link_found": "UNKNOWN",
      "content_verified": "UNKNOWN",
      "reuse_rights_verified": "UNKNOWN"
    },
    "checked_at": null,
    "checksum_sha256": null
  }]
}
```

五种且仅五种证据标签：**原始实验、论文证据、独立复现、辅助素材、示意画面**。具体来源种类可以更细，但不引入第六种 UI 证据标签。

## 3. 纠偏三：主音轨必须可定位、锁版本、触发下游失效

实际音轨不仅是 `AUD001` 标识。至少需要记录 `path / duration_ms / sha256`、经审定 `script_id/script_sha256`、`voice_version` 与对齐版本/结果状态。

**草案 `CWS episode_timeline.json`（示例无实际时长）**：

```json
{
  "version": "CWS_EPISODE_TIMELINE_DRAFT_2",
  "episode_id": "CWS-EP-EXAMPLE",
  "canvas": {"width": 1920, "height": 1080, "fps": 30},
  "script": {"id": null, "version": null, "sha256": null},
  "master_audio": {
    "asset_id": "AUD001",
    "path": null,
    "duration_ms": null,
    "sha256": null,
    "voice_version": null
  },
  "alignment": {
    "method": null,
    "status": "NOT_RUN",
    "audio_sha256": null,
    "script_sha256": null,
    "human_reviewed": false
  },
  "clock": {
    "a_prefix_duration_ms": null,
    "audio_start_video_ms": null,
    "line_and_caption_timebase": "audio_relative_ms",
    "shot_timebase": "video_relative_ms"
  },
  "lines": [{
    "line_id": "L001",
    "beat_id": "B01",
    "text": "经审定的旁白文本",
    "start_audio_ms": null,
    "end_audio_ms": null
  }],
  "captions": [{
    "caption_id": "C001",
    "line_id": "L001",
    "text": "经审定的旁白文本",
    "start_audio_ms": null,
    "end_audio_ms": null,
    "highlight": "none"
  }],
  "shots": [{
    "shot_id": "S001",
    "beat_id": "B01",
    "asset_id": "A001",
    "start_video_ms": null,
    "end_video_ms": null,
    "source_in_ms": null,
    "source_out_ms": null,
    "fit": "contain",
    "evidence_label": "论文证据"
  }],
  "asset_references": [{
    "asset_id": "A001",
    "rights_ledger_ref": "rights_ledger.json#A001"
  }]
}
```

**依赖失效原则：** 旁白音频内容哈希改变 → 旧对齐与全部字幕时间码 `STALE`，需要重新校时；经审定文案文本或顺序改变 → 对齐亦失效；如果对应 `beat` 的实际语义或时间改变，镜头/证据标签时间码也必须复查。不得仅替换 WAV 文件而继续使用旧 SRT。所有 SRT/VTT 均由同一 `captions` 母数据导出，不能二次人工维护另一份主时间轴。

## 4. 纠偏四：允许一条旁白对应多条连续单行字幕

- `line_id` 是审定文案的稳定语义单元，`caption_id` 是屏幕单条字幕。**一对多**，允许一句长旁白被拆为 `C001/C002` 等多条，依真实发音依次显示；长镜头可以跨越多条字幕。
- 每条字幕严格单行、不可溢出、不可逐词高亮；`STYLE_LOCK` 的 18–22 全角字仅为参考，真正是否可容纳由画框和手机观看验证。不可为满足字数机械切开词义。
- 用定稿文本和主音轨做强制对齐（若已获证实），或在 G1 明确采用**人工逐句标点、真人试听核校兜底**。`faster-whisper` 的 ASR 时间戳不得冒充定稿文案强制对齐。
- 字幕须有 `caption_id → line_id → beat_id` 可追踪路径。按顺序拼接的字幕必须忠实于已审定的旁白，不得由转录器擅自更改科研结论；标点/停顿与文字变体做明示人工校核。
- 视频时间 `subtitle_video_ms = caption_audio_ms + audio_start_video_ms`，仍**只偏移一次**。音轨静音处字幕不滞留，且不能存在重叠多行。

## 5. 上游投影边界与推荐实现路线（仍未实现）

`episode_timeline`、`rights_ledger` 是 CWS 自有母数据，不能假称为上游工具已经接受的 JSON Schema。

| CWS 母数据 | 仅映射到本机上游已准许的字段 |
|---|---|
| `asset_id` 与合法媒资路径 | `asset_manifest.assets[].id / path` 等 schema v1.0 白名单字段 |
| `shot_id` 与原媒资内部裁切时间 | `edit_decisions.cuts[].id / source / in_seconds / out_seconds` 等白名单字段 |
| `line_id / beat_id`、音轨零点、视频切点与字幕 | 保持在独立 CWS timeline 与 Remotion props，不写入严格上游 cuts |
| 权利与证据状态 | 保持在 CWS ledger；只有明确合法的上游字段可投影 |
| `render_runtime` / `composition_mode` / `bespoke` | 仅当本地 schema 和路由允许，才在审批后的 G1 发起调用 |

**方案 A 候选**：沿用 OpenMontage asset/audio 编排；CWS 固定 A/B chrome 作为自定义 Remotion 项目，谨慎使用 `atelier`。本机报告指向 `tools/video/video_compose.py` 的 atelier 路由与 staging 复制副作用。G1 前须 Owner 显式同意允许写入 `remotion-composer/projects`、输出目录及其跨集固定 Chrome 用法。**本轮不触发它**。

**方案 B 回退**：CWS 工程自己的 Remotion 入口，仍调用获准的 OpenMontage 音频与资产子模块；不修改 OpenMontage 源码和现有 Composer 的生产配置。若需要安装额外依赖，先获 Owner 同意。

**避免直接套默认管线**：本机 `animated-explainer` 的目标时长 ±10%、音频/选图及音乐配置检查，以及 `documentary-montage` 的强制音乐/end-tag，都与频道“自然时长、允许无 BGM、剧本不可被生产 Agent 改写”不同。G1 只复用可控阶段；不要为了通过 pipeline 评分而改变频道叙事规则。

## 6. G1（另行批准）20–30 秒最小验收合同

**只建议，不启动。** 优先使用 Owner 已经有权使用的 **本地现成音轨+本地自制/已证据核验素材**，降低云推理与媒体授权变量；是否使用、费用和具体输入必须单独获批。

1. 在独立 CWS 工作目录创建专用 A/B Remotion 组件、CWS 适配器与版本化工件；不覆盖原始报告、剧本、素材和已安装工具。
2. 测试 A（可短或跳过）→ B、B内至少一段含真实可核出处的素材和一次镜头变化；逐项检查 `1920×1080 / 30fps`、满幅 B、五类标签中本样片实际用到的标签、`contain` 与单行字幕。
3. 选定 `audio_start_video_ms`、`a_prefix_duration_ms` 后锁定，不重复平移；至少一条长旁白拆成两条字幕，抽听真实起止；若无已验证自动强制对齐，先采用**人工声学标注**作为 G1 兜底，并把自动对齐标为 `NOT_IMPLEMENTED`。
4. 生成/核对一份 `episode_timeline.json`、`rights_ledger.json` 及上游投影工件；检查媒资链接、内容、权利三状态不混淆，且输出 `MP4` 与派生 `SRT` 的时间一致。
5. 机器和真人共同检查画面无黑帧/明显卡顿、字幕单行/无高亮/无溢出、无音画漂移、镜头视频帧半开覆盖连续；保留测试日志、渲染输入摘要、关键帧和手工问题清单。
6. 如果选择 `atelier`，事先列明 staging 写入路径、可清理的**本轮新增文件**和不动原工具/配置的回退办法；不允许因渲染失败自动安装、升级、切换技术路线。
7. 任何云 TTS/下载素材/付费 API/Remotion 商用许可购买以及视频公开发布，均不包含在本 G1 候选范围，需明确的额外许可或费用审批。

**G1 技术通过不自动证明：** 自动中文字幕强制对齐成熟、正式故事 STORY-FIT GO、长期稳定生产、研究外链素材可商用，或已能公开视频。首条完整 G2 与规模化 G3 另行推进。

## 7. G0 剩余条件、Reviewer 判定及保全声明

| 剩余事项 | 当前实证边界 | 是否可在无 G1 运行下处理 |
|---|---|---|
| 本机来源、确切仓版本 | 安装目录无 `.git`，仅 `setup.py` / AGPL 文件，不可冒充官方某 commit | 可在将来的只读审计补确切来源或对关键文件做校验值；**不得为了取 SHA 重装** |
| 中文定稿强制对齐 | WhisperX/faster-whisper/stable-whisper 未在该 OM venv 的限定名称检查中发现，ASR 非强制对齐 | 可设计人工 G1 兜底；算法精度必须另获授权后跑音频才知道 |
| Qwen 凭据可用性 | Skill/源码路由存在；`.env` 内容未读、未运行 | 使用 Owner 提供的现成音轨即可把它列为 G1 非阻塞；实际云调用另行批准 |
| 本机 renderer 运行成功 | Node/Composer/依赖/atelier 入口存在，尚未实际 render | **必须 G1 单独授权**，不能作为 G0 验收硬条件 |
| G1 渲染路径与副作用 | atelier staging 写入与跨片固定 Chrome 的兼容性未证 | G1 前需要 Owner 决定 A 写入边界或 B 独立工程 |

**Reviewer 结论**：文档级四项纠偏完成后，仍保留 `G0_CONDITIONAL`：真实本机版本谱系与中文自动强制对齐仍有未知；这不妨碍形成**可供 Owner 审议的 G1 最小实验方案**，但不能擅自把项目标成 `PRODUCTION_READY`。是否将 G0 标为 `G0_DESIGN_READY_NO_RENDER`，须先明确接受实验环境的来源不确定性、对齐人工兜底与渲染路线选择，且再次确认所有审定输入；本文件不替 Owner 决策。

**变更边界**：本文件是设计文字。未经授权未安装、更新或运行音频、视频、模型、素材下载或渲染；不改 `TOPICS_V1.json`、`BOARD_V1.md`、`WORKFLOW_V1.md`、P3稿件、`STYLE_LOCK`、本地 OpenMontage 与 Windows/VPS/代理。
