# P4-G0｜静态证据与可执行集成蓝图（上游审查已完成，本机只读审查待回报）

**2026-10-10** · **状态：`G0_UPSTREAM_VERIFIED_LOCAL_UNKNOWN`，不是 `G0_PASS`**。用户批准合并 G0＝本机能力审计+设计，限定只读与规划，不安装、不测试、不渲染。本会话只可通过 GitHub Connector 读用户私有仓库和 OpenMontage 公开主仓，**不能访问 Windows 的 `C:\Users\34707\Tools\OpenMontage`**。本地只读执行交接文件：[G0 Codex 任务书](P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md)。拿到真实本机数据后方可评定 G0 PASS/CONDITIONAL/BLOCKED。

## 1. 已核实证据（注明来自哪里）

| 组件/主张 | 可核事实 | 对我们方案的意义 | 本机未证事项 |
|---|---|---|---|
| 用户仓中的视觉模板 | [STYLE_LOCK](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)、[设计 tokens](../visual/retro-mac-v1.2/config/design-tokens.json)、[preview](../visual/retro-mac-v1.2/preview/index.html) 均在 main | A短桌面+B全幅QuickTime，1920×1080/30fps，单行56px附近字幕、5类证据标签、B 内素材 contain | 网页样式进入视频后是否可逐帧复现（**尚未测试**） |
| 视觉 HTML 的真实行为 | JavaScript 固定四段 `segments`：0–19、19–37、37–52、52–64秒，`requestAnimationFrame` 播放；导入本地视频 `muted=true/loop=true`，仅 DEMO 展示；文本字幕占位 | **不是**成片模板，不应把64秒时间轴、浏览器播放时钟带进生产 | 本地是否已有另外的视频版模板 |
| OpenMontage 主仓 | [calesthio/OpenMontage](https://github.com/calesthio/OpenMontage)，main 上 [LICENSE](https://github.com/calesthio/OpenMontage/blob/main/LICENSE) 是 **AGPL-3.0**；名称近似的 [Open-Montage-app/OpenMontage](https://github.com/Open-Montage-app/OpenMontage) 是不同小型仓库、MIT | **必须查明本地是哪份代码/哪个提交**；不能因同名下载站 MIT 而认定核心合成工具全为 MIT | 真正的本机仓库来源与 SHA、是否部分拷贝 |
| OpenMontage 渲染桥接 | [tools/video/video_compose.py](https://github.com/calesthio/OpenMontage/blob/main/tools/video/video_compose.py)、[skills/core/remotion.md](https://github.com/calesthio/OpenMontage/blob/main/skills/core/remotion.md) 明确 `render_runtime=remotion`、`video_compose` 等；Remotion 可用性校验包含 `npx`、`remotion-composer/package.json`、`node_modules` | 先复用桥接，别新建完整视频框架；不允许渲染器静默降级 | npm依赖是否已装、API版本和本地代码是否一样 |
| 默认渲染布局 | [remotion-composer/src/Root.tsx](https://github.com/calesthio/OpenMontage/blob/main/remotion-composer/src/Root.tsx) 有 `Explainer`、`CinematicRenderer` 等，**没有 CWS 的 Aqua+QuickTime 构图** | 必须新建 **CWS 专用视觉组件**，不可直接把模板当素材覆盖在默认卡片视频上 | 本机是否已经自行定制过 |
| 默认字幕 | [Explainer.tsx](https://github.com/calesthio/OpenMontage/blob/main/remotion-composer/src/Explainer.tsx) 使用 `CaptionOverlay`，默认 `wordsPerPage=6` 和逐词高亮样式，适合快节奏短视频 | 不符合 CWS **中文单行、无逐词高亮**：需自己写 `SingleLineSubtitle` 或经适配禁用该组件 | 本机字幕生成/强制对齐、中文表现 |
| OpenMontage 工件 | [asset_manifest.schema.json](https://github.com/calesthio/OpenMontage/blob/main/schemas/artifacts/asset_manifest.schema.json) 和 [edit_decisions.schema.json](https://github.com/calesthio/OpenMontage/blob/main/schemas/artifacts/edit_decisions.schema.json) 顶层 `additionalProperties:false`，并分别限定 assets/cuts 字段 | 不允许往原始工件任意加 `rights_verified`、`beat_id` 等字段。**CWS自有 timeline/rights 旁路工件**经适配器生成上游标准格式 | 本机合同是否已升级/是否真的启用 schema 校验 |
| 更适配的管线 | [animated-explainer.yaml](https://github.com/calesthio/OpenMontage/blob/main/pipeline_defs/animated-explainer.yaml) 主线含脚本、scene/asset/edit/compose，可用 Remotion；[documentary-montage.yaml](https://github.com/calesthio/OpenMontage/blob/main/pipeline_defs/documentary-montage.yaml) 更偏音乐驱动镜头集合，音乐原则上强制、旁白可选 | **建议采用 explainer 作为工作流基底**，但改为 CWS 研究事实优先、自然时长、素材优先、禁止自动重写故事 | 本机实际是否存在相应 pipeline/renderer |
| 自定义渲染候选 | 上游 `video_compose.py` 支持 `composition_mode="atelier"`、`bespoke.entry/composition_id/props_path` 路由到本地自写 Remotion 入口；会检查误引上游 stock UI 组件 | 适合试做 CWS 专用完整 A/B 组件，而不是改通用 Explainer；但上游“atelier”理念是每片 bespoke，**跨期固定模板的使用方式需本机只读审查+未来G1验证** | 上游模式的本地版本/兼容性与权限 |
| 本地既有短片 | [CURRENT_STATE](CURRENT_STATE.md) 只记有 Owner 交接的12秒 OpenMontage 技术闭环 | 可优先复用本地工具与配置 | **这不是上游+本地联合实测**，不能证明长片、Remotion、中文声学对齐完成 |

### 必须纠正的两项旧猜想

1. **不要直接用 `documentary-montage` 默认管线作为频道唯一制作链**：它的默认音乐、LUT 和艺术性剪接定位与本频道“事实来源可追溯、旁白和证据驱动”不一致。可借用其 direct_clip_search 和多源检索做**辅助素材层**。
2. **OpenMontage 已有 Remotion 代码，不等于本地实际可用**：基础 requirements 是 `node_modules`、相关执行入口和实际已安装本地项目。本机会有版本漂移，也不应据上游 README 隐式升级。

## 2. 推荐的“上游工具+本频道组件”接入蓝图（静态提案）

```text
锁定文案（story_beats + line_id） + 事实证据 / 素材权利台账
             │
             ▼
OpenMontage 借用：音频/TTS选路、音频分析、素材候选检索、基础asset交付
             │
             ▼
master_audio.wav (完整音频单一时钟零点)
             │
             ▼
中文强制对齐（工具尚待本机确认，人工抽听验证）
             │
             ├──> 单行字幕表 captions.json + SRT（派生物，不重复维护）
             │
             └──> 按观众理解节点编排真实 shots
                       │
                       ▼
CWS episode_timeline.json + rights_ledger.json（项目唯一高层母数据）
                       │
                       ▼
CWS Adapter ──> OpenMontage 标准 asset_manifest/edit_decisions
                       │            （只含其版本schema允许字段）
                       ▼
CWSRemotionRoot/RetroAquaShell
   ├─ A: 1.5–3s 桌面（可因内容直入B）
   └─ B: 100% QuickTime Chrome
       ├─ ResearchViewport（真实研究/自制示意/合法图库素材）
       ├─ EvidenceLabel（五类状态）
       └─ SingleLineSubtitle（真实音轨句段，同步无高亮）
                       │
                       ▼
G1 授权后：Remotion帧渲染 + FFmpeg封装/音质检查 + 人工看成片
```

**统一时间源**：以 master audio 时间戳（整数毫秒）为基准；有 A 开场时统一应用偏移，所有镜头、字幕和证据标签从一份母时间轴导出 30fps 帧区间。镜头切点必须映射成整数帧后连续，不要每段独立 round 引入重复/黑帧。音频改版必须令字幕和镜头时间码失效并重新对齐。

**不可被默认 OpenMontage 行为覆盖的 CWS 规则**：
- 视频无强制时间，不为适应 pipeline 的固定秒数、固定剪辑密度或结尾CTA故意注水；若默认 pipeline 有 ±10% 目标时长，改以定稿音轨为准（需后续设计/配置，不静默改业务规则）。
- A、B 两状态不增加 C；B 占满16:9，最宽画面服务真实研究视频。
- 字幕严格单行、语义拆句、音轨对齐、不做逐词高亮；标注真实“原始实验/论文证据/独立复现/辅助素材/示意画面”。
- 任何实际实验的视频/图必须核对内容与适用使用权。直接引用 PLOS 开放许可论文图一般可商业重用但需署名；外链演示视频另核版权。不能由 CLIP 高分直接把无关图库变成研究画面。
- 音乐可没有；OpenMontage 的 montage 默认音乐必选 **不适用本频道**。
- 代码/策略输入的科学事实必须来源于审定稿，生产Agent无权偷偷改为更戏剧化的研究结论。

### 计划级数据接口（尚未实现，也不等于上游 schema）

```json
{
  "version": "CWS_EPISODE_TIMELINE_DRAFT_0",
  "fps": 30,
  "canvas": [1920,1080],
  "master_audio": {"path": "audio/narration.wav", "duration_ms": null, "sha256": null},
  "lines": [
    {"line_id":"L001", "text":"你会停一下吗？", "start_ms":null,"end_ms":null,"beat_id":"B01"}
  ],
  "shots": [
    {"shot_id":"S001","beat_id":"B01", "start_ms":null,"end_ms":null,"asset_id":"A001","evidence_label":"示意画面"}
  ],
  "asset_references": [{"asset_id":"A001","ledger_ref":"rights_ledger.json#A001"}]
}
```

**所有 null 是未执行标记，不是漏填后的假时长。** 不在 P4-G0 模拟出“实际配音3分XX”的假证据。

### G0 未通过时的清晰降级路线（只是设计，不自动实施）

- 若本地存在 OpenMontage，但没装 `remotion-composer/node_modules`：报告 `MISSING_DEPENDENCIES`，不运行 `npm install`；由 Owner 决定 G1 是否允许安装。
- 若本地有 FFmpeg 但无 Remotion：可提出“局部独立 Remotion 环境”或 FFmpeg简版，**不自动改 STYLE_LOCK**。
- 若无中文强制对齐工具：人工时间码/声学审听作G1兜底候选，同时把字幕自动化标为 `NOT_IMPLEMENTED`，不以均分字数冒充准确同步。
- 若 OpenMontage 的 schema/atelier 入口不兼容：建议做 CWS 独立组件并以旁路 CLI 调用，同步明确哪些上游资产模块仍复用；不能因为“都有Remotion”假装接口适配已经完成。

## 3. G0 所缺证据与完成条件

**现在已完成**：上游项目静态仓库核实；CWS 视觉模板/叙事/权利约束核对；更适配的管线与精确扩展点选择；上游合同冲突梳理；高层时间轴/素材/视觉组合接口草案；本地 G0 执行任务书。

**仍未完成**：本地 `C:\Users\34707\Tools\OpenMontage` 路径真实存在、Git remote/commit、技能文件、Node/npm、FFmpeg版本、remotion-composer及node_modules、可用的中文对齐库/Qwen云TTS路径、渲染器特殊接口及本地模块冲突等。不得以 Windows 已安装 Qwen TTS 的旧摘要冒充当前输出。

**只有拿到本地只读报告，才能做最终决策**：确认是基于 `animated-explainer` 加自定义 CWS Remotion 组件，还是绕开 `video_compose` 只借其 asset 音频工具。两条方案都须附同一份证据与 rollback/不更改功能边界。

**结束状态**：`G0_PARTIAL_UPSTREAM_STATIC_DONE_LOCAL_EVIDENCE_PENDING`；**没有运行任何本地系统测试、视频生成、TTS、网页素材下载，也没有对 Owner 电脑安装/更改任何软件。**
