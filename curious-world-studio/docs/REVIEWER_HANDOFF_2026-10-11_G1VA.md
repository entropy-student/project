# Curious World Studio｜2026-10-11 Reviewer 完整接手（P4-G1V-A）

> **当前 Reviewer**：本次 ChatGPT 继续担任，直到 Owner 另行指定；**用途**：下一位 Reviewer 从 `main` 直接接手，不依赖旧聊天记录、临时分支或模型记忆。  
> **唯一当前事实入口**：[CURRENT_STATE.md](CURRENT_STATE.md)；本页提供证据导航、先后关系、已锁决策与下一阶段接口，不取代正式 `WORKFLOW_V1` / `STYLE_LOCK`。

## 0. 一句话状态

**Owner 已选定 Assistant V2 Research Aqua 作为 G1V-A 桌面动画的唯一当前视觉参考；它是可重复查看的真实9秒动画，但独立 Canvas HTML 尚未移植到可复用 Remotion 视频素材输入接口。Codex 的7秒旧版本已真实渲染、机器 QA 通过，却不采纳其视觉/交互实现。G1 整体视觉仍未PASS，G2/G3 禁止推进。**

## 1. 权威文件按此顺序阅读

1. [CURRENT_STATE.md](CURRENT_STATE.md)，保持唯一动态阶段状态。
2. [本页 Reviewer Handoff](REVIEWER_HANDOFF_2026-10-11_G1VA.md) 与 [双版独立 Review](P4_G1VA_CODEX_VS_ASSISTANT_V2_VISUAL_REVIEW_2026-10-11.md)。
3. [官方 STYLE_LOCK v1.2](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md) 与 [V2 源码与状态语义](../p4-g1/visual-reference/README.md) → [真实 HTML](../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html)。
4. [V2 QA manifest](../p4-g1/visual-reference/V2_QA_manifest_2026-10-11.json) 和 [离线渲染脚本参考](../p4-g1/visual-reference/render_reference.py)；源脚本在 Linux `/usr/bin/chromium` 跑，**不是 Windows 可直接运行的 Remotion 生产代码**。
5. [Codex VA 原始执行报告](P4_G1VA_CODEX_LOCAL_EXECUTION_REPORT_2026-10-11.md) 与 [机器 QA](P4_G1VA_CODEX_MACHINE_QA_2026-10-11.md)。
6. [下一步本地 Codex 精确任务](../p4-g1/LOCAL_CODEX_G1VA_V2_MEDIA_ADAPTER_TASK_2026-10-11.md)。
7. 后续若要追溯 G0/G1R1/G1R2：先看 [G1R2 复核](P4_G1_R2_REVIEWER_INDEPENDENT_QA_AND_OWNER_GATE_2026-10-11.md)、[G1Owner视觉否决](P4_G1V_ORIGINAL_VIDEO_DISCOVERY_RIGHTS_AND_VISUAL_RESET_2026-10-11.md) 与 [原视频只读核验](P4_G1V_SOURCE_SCREENING_READBACK_2026-10-11.md)。再读 [2026-10-10 旧接手文档](REVIEWER_HANDOFF_2026-10-10_P4G0.md) 作为历史进度，不用它重置今天状态。

## 2. 迄今发生过什么（不可互相覆盖的事实）

| 阶段 | 真实产物/可确认事实 | 有效结论 |
|---|---|---|
| P4-G0 | 上游 OpenMontage/本地只读报告与接口草案 | `G0_CONDITIONAL`；有工具路径≠全部自动管线就绪 |
| G1-R1/R2 | J-B 果冻 Fig.7/8 + 临时 SAPI + SRT，R2真实24.2秒 MP4，固定音轨相关性很高，字幕不再遮图 | **工程有能力渲染**，但 Owner 认为静态开场/拼接论文图观看体验极差，`G1_VISUAL_REJECTED` |
| G1V 源视频调查 | 三段真实实验视频在原播放器观看；720p、部分玩具/制作动作、摆动不清晰、许可无证据 | 原视频 `RIGHTS_UNKNOWN_PERMISSION_REQUIRED`；不能擅自剪入成片 |
| Owner新默认决策 | 默认不使用研究原视频，改用**来源/使用权明晰的替代素材/自制示意**；科学事实仍须靠论文真实证据 | 不再以研究视频授权作为 A 动画的前置依赖；绝不将示意视频伪称原始实验 |
| Codex G1V-A 7s | Remotion 1920×1080@30 210帧，SHA `26b76c85dc229447b3120a6cc3e45c31e80ffaf90cdf3abcf6d84cc981cc514a`；帧解码、无黑帧、8事件帧 | `RENDERED / MACHINE_QA_PASS`；UI没有 Owner 选择，2s后鼠标消失、全屏和播放自动切换 |
| Assistant G1V-A V2 9s | Research Aqua & Classic Aqua 两个1920×1080@30 270帧、无声原型；所选 Research SHA `914a4a7b4dd5dfd542561e2a89a5d65a5c8fbf78d322b5c35afb93a2092a96d2` | Owner明确更喜欢**Research Aqua**。V2 的开窗时自绘同素材第0帧冻结，`PLAY_START=4.76s` 后再播放，假设示例总长12s；**尚不支持输入任意真实 MP4** |
| GitHub G1VA 视觉定版 | PR #102 合并 V2 可编辑 HTML、主线状态与对照 Review | `G1VA_VISUAL_REFERENCE_SELECTED=ASSISTANT_V2_RESEARCH_AQUA`，不是 `G1_FULL_PASS` |

**机器规格对不等于内容与视觉通过；Owner常速观看评价具有最终视觉否决权。** 不要让下一任 Reviewer 误以为 Codex“无故没使用实验视频”——旧任务明确禁止原研究视频并要求抽象占位，两版都遵守此限制。

## 3. 视觉合同：哪一套不许被下一轮重新设计

- **从可编辑实现复用，不要模仿截图另造 UI**：V2 HTML 是桌面墙纸、macOS Tiger 风菜单栏/Dock、文件图标、鼠标选中双击、窗口弹出、绿色控制按钮、QuickTime B 全屏和播放按钮状态变更的正式视觉参考。`STYLE_LOCK` 仍为上位风格边界。
- V2 默认 **Research Aqua** 壁纸，Classic Aqua 仅为历史备选。
- A→B 因果链必须有实际鼠标操作；静止桌面→直接切图或光标在放大前消失的原型已被 Owner 不采纳。
- B 内需显示真实**输入素材文件自身的第0帧**直到点击播放；播放器时钟=被播放素材已播放时间，进度=`asset_play_elapsed / asset_duration`，**不是整条“桌面+开窗”外部成片时长**。
- 当前B自绘果冻只是标 `示意画面` 的技术占位，不表示 B 的叙事视觉机制/版权/科研内容已通过。
- 继续维护 `1920×1080,30fps,A/B无C,QuickTime满幅,单行中文字幕52–58px/默认56,contain/科研证据清晰可读`。

## 4. 下载、版权、工具权限

- Owner 允许使用**已经存在**的 Chrome Headless Shell 专用缓存作 Remotion 运行时；应显式通过 `--browser-executable`、记录版本和哈希，**不自动下载或升级**。Edge 是日常浏览器。
- `yt-dlp` 为下一轮潜在下载工具候选、本机尚未安装；**不因本页自动获得安装/下载原实验片段的授权**。
- 默认不使用研究原视频；可按权利状态选替代素材或本地生成示意，但合法获得素材≠可以把它标为“原始实验”。仍要为每条素材单独记录 `link_found/content_verified/reuse_rights_verified` 或内部自制证明。
- 新的云TTS、图片/视频生成付费服务、Windows权限更改、VPS/VPN修改、媒体发布、G2/G3 均没有被本次选择授权。
- 保留旧 R1/R2 与 Codex 7s 独立本机数据目录；历史违反下载浏览器的记录不因后来合法复用而消除。

## 5. 本轮保留的文件与未复制的东西

- **主线 GitHub 永久文字材料**：历史 G0/G1原始报告；G1V视频许可观察；V2 HTML完整源代码；Codex G1VA 原始技术报告与机器 QA；V2 QA manifest/本机离线参考渲染脚本；新任务书；当前状态与本接手文档。
- **不提交 main 的大体积文件**：独立 MP4、壁纸预览 PNG、所有关键帧压缩包、Codex Windows TEMP 包、缓存 EXE 等。原因是 GitHub 本次 connector 文本工作流，视频与图像作为会话文件交付；主线以文件哈希与明确源代码使后续可以核对/重建。**不能声称下一位 Reviewer 单靠 GitHub main 就能直接播放现成9秒 MP4**；若要查看实际画面，可通过运行已存在的HTML / 已保存本地包，必要时 Owner 再提供视频附件。
- [原版 V2 源码](../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html) 自包含可直接用浏览器观看；`render_reference.py` 仅为曾成功工作的参考，需按现有环境另行审核运行。

## 6. 分支与重复记录清理审计

2026-10-11 核对 GitHub 100+ 分支分页、开放 PR 和关闭 PR：CWS **#73 至 #102 对应 PR 均 merged**；CWS 目前无开放 PR。分支本身仍可能保留历史 ref（squash merge 后分支提交图与 main 分叉很正常），**不要因 `ahead_by>0` 就直接把旧分支内容重新合并**。已生效文件应当始终以 main 的内容为准。

两类旧 CWS 分支特别不能恢复：
1. `fix/cws-g1-r2-evidence-safe-caption-browser-guard-20261011`：探索性补丁，其中有效修复与报告已通过 #96/#97 分别进入 main，余下差异非当前设计真源。
2. `cws/p2e-audio-storyfit-preflight-20261010`：含历史音频探测脚本与 GitHub Actions workflow，主线已有 P2-E 的 QA 证据索引，但 **未授权导入历史实验 workflow 到生产**。这不是当下G1V的可直接合并代码。

其他已合并历史 Gate 的文档依然有事实审计价值，**不作为“无效垃圾”批量删除**。无经验证的无效主线文件可安全删除时，维持文件不变。若仓库 GitHub 界面还显示已合并的分支，**只清理确认对应 PR 已 merged 的 CWS 特定分支 ref**，不得碰生日杂志/VPS/别的项目分支；当前接入工具没有删除 ref 的动作，不宣称已删除远端分支。

## 7. 精准下一步与验收边界

**马上要执行的是 [P4-G1V-A-M1：V2 真实视频媒体输入适配](../p4-g1/LOCAL_CODEX_G1VA_V2_MEDIA_ADAPTER_TASK_2026-10-11.md)**。仅使用已有 Remotion/FFmpeg/获批浏览器缓存和本地自制测试视频；从同一视频文件提取原始第0帧→开窗停留→点击播放真正从0帧开始→用实际媒体时长驱动UI进度。**不得改画视觉皮肤**。本机 Codex 完成独立 MP4/源码/时间轴/QA报告后返交当前 Reviewer；Reviewer 独立读实际视频并做语义/布局检查，成功后才申请合并 scoped PR。

**不要把 M1 误命名 G2，也不要宣称素材发现与商业授权自动化已经完成**。下一个真正要主攻的 B 内容视觉机制，要等 M1 可重用适配成立后另行评审。

## 8. 新 Reviewer 可直接复用的接手指令

> 请接手 `entropy-student/project` → `curious-world-studio`；先从 `main` 读 `docs/CURRENT_STATE.md`、`docs/REVIEWER_HANDOFF_2026-10-11_G1VA.md`、`p4-g1/visual-reference/README.md`、`p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`、`p4-g1/LOCAL_CODEX_G1VA_V2_MEDIA_ADAPTER_TASK_2026-10-11.md`。当前 Owner 选择 Assistant V2 Research Aqua 桌面动画，Codex 负责在已有 Remotion 里接入真实本地测试视频的首帧冻结与播放时钟。不要修改正式题库/剧本/STYLE_LOCK，不使用研究原视频，不能因机器 PASS 声称 G1 已完成，不启动 G2。当前 Reviewer 仍为原 ChatGPT；收到 Codex M1 实际报告和 MP4 后独立复核与落 main。
