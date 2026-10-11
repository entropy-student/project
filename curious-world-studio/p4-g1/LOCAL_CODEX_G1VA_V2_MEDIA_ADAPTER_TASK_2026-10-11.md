# P4-G1V-A-M1｜将已选 V2 Research Aqua 视觉模板接入真实媒体文件

**状态：TASK_READY / IMPLEMENTATION_NOT_STARTED / G1_NOT_PASS / G2_NOT_AUTHORIZED**  
**Owner 已确认**：V2 Research Aqua 为首选视觉方案。**执行者**：本地 Codex，只做工程移植与本地视频输入功能；**Reviewer**：当前 ChatGPT，必须在收到真实证据后复核。  
**原则**：本任务不重新设计 UI，不使用原论文实验视频，不使用 Fig.7/8 拼图作主视频，不改变正式剧本或 STORY-FIT。

## A. 必读的唯一源码与事实

1. `curious-world-studio/docs/CURRENT_STATE.md`（现状，可能随 PR 更新）。
2. `curious-world-studio/docs/REVIEWER_HANDOFF_2026-10-11_G1VA.md`（当前完整接手与优先级）。
3. `curious-world-studio/visual/retro-mac-v1.2/docs/STYLE_LOCK.md`（不修改）。
4. `curious-world-studio/p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`（**视觉行为的实现真源**；`window.renderAt(t)` 与 `window.prototypeState(t)` 可检查）。
5. `curious-world-studio/p4-g1/visual-reference/README.md` 和 `V2_QA_manifest_2026-10-11.json`、`render_reference.py`（后者是 Linux/Chromium 下的历史渲染参考，不可直接当 Windows Remotion 模块）。
6. `curious-world-studio/docs/P4_G1VA_CODEX_VS_ASSISTANT_V2_VISUAL_REVIEW_2026-10-11.md`；Codex 7秒旧版源码在原本机保留，**仅作为已跑通 Remotion 的工程依据，不采纳它的 UI**。
7. `curious-world-studio/p4-g1/LOCAL_CODEX_G1_R2_TASK_2026-10-11.md` 与 `scripts/render_windows.ps1`（保留既有浏览器授权/安全 staging 条款；不得在旧目录重复构建）。
8. `curious-world-studio/docs/P4_G1V_SOURCE_SCREENING_REVIEW_AND_NEXT_GATES_2026-10-11.md`（研究动态视频存在但不作为默认素材）。

## B. 本轮实现目标（不做 B 正式内容）

**交付一份可以换视频文件的 V2 Research Aqua 视觉模板**，只做最小演示；保留视频素材是测试占位的明确标识：

1. A 桌面、Finder/Aqua菜单栏、Dock、文件图标选中→双击、窗口从文件的位置打开、鼠标点击绿色窗口按钮、B 全屏、鼠标点击播放；**动作、坐标与操作逻辑以选中 V2 HTML 源码为准**。不允许重画成新设计。
2. B 所显示的是**输入素材文件的真实第0帧**。在文件窗口出现到点击播放之间**完全保持0帧**，不是近似绘制的海报，也不是编码后的下一个画面，更不能在暂停状态偷偷运行底层视频。
3. 点击播放后素材从0秒开始前进；**播放器内的秒数和进度条由素材真实时长决定**，外部 MP4 的9秒视觉演示长度不是素材总时长。准确区分 `outer_video_time`、`asset_play_start_video_time`、`asset_local_time`。
4. 素材解码尺寸/帧率、总帧数、素材 SHA/来源、音轨策略进入版本化 `input_manifest.json`。播放器 B 对研究证据/替代镜头使用 `contain` 保证主体不被任意裁掉；演示字幕安全区与控制条互不覆盖。
5. 可以使用**现有 FFmpeg/本地程序自行生成一段非科研测试动画 MP4**（几秒有明显运动的几何/色块即可），用于测真正的本地视频首帧接入；它只能标 `示意画面`，不得放入正式题材成为剧情或冒充原始实验。请**不要**再为此重画一版花哨的果冻 UI，也不要下载版权未知的网络素材。
6. 先用**一个真正本地 MP4 文件**从头到尾贯通。若后续需要测试另一种尺寸/帧率，列作下一轮，不因测试多格式而拖延首个可验收结果。

## C. 输入数据合同（建议，可在报告中注明实际实现字段）

```json
{
  "schema": "CWS_G1VA_MEDIA_ADAPTER_V1",
  "asset_id": "OWNER_APPROVED_LOCAL_FIXTURE",
  "source_file": "work/assets/approved_demo.mp4",
  "source_sha256": "<actual SHA>",
  "rights_basis": "self_generated_local_test_only",
  "evidence_label": "示意画面",
  "source_width": 1920,
  "source_height": 1080,
  "source_fps": "30/1",
  "source_duration_ms": 6000,
  "poster_source": "first_decoded_frame_of_same_source_file",
  "asset_play_start_video_ms": "<determined by actual V2 click animation>",
  "render_fps": 30,
  "audio_policy": "muted_visual_gate"
}
```

上面所有具体数值是**演示字段示例，不是已经验证的素材元数据**；必须通过 FFprobe 从测试视频实际读取，源码不得信任占位数字。真实媒体读入和播放时间由单一适配器提供给播放器 UI。

## D. 技术边界

- 仅使用 Owner Windows **已安装**的 Node、FFmpeg、Remotion 和**已获批准缓存**的 Chrome Headless Shell；Chrome 二进制路径与 SHA/版本必须按已有安全任务书预检并显式传入。**不得自动下载浏览器/升级工具/调用云模型**。
- 新隔离 TEMP 工作区与**未使用过的** `cws-g1va-v2-media-<nonce>` staging；不覆盖 G1R1、G1R2、Codex 7秒 VA、Assistant 9秒 V2 的原始结果。旧 OpenMontage 源码、`.env`、项目设置与生产路径不直接改写。
- 技术可选：直接在已安装 Remotion 中移植 V2 组件和状态机；或形成受控 HTML 渲染适配。两者须**注明复用所选 V2**，不要只看视频图片后重新手写其他美术效果。首次优先复用现有 Remotion Composer 环境、避免新依赖。
- **不批准**：yt-dlp 安装/使用、研究作者原视频下载/引用、付费素材、音色/配音生成、完整 G1/G2/G3、商业发布、默认修改正式频道样式规范。
- 最终内容可以用替代公开视频素材/自制动画，但每件仍需 `source_kind` 与 `reuse_rights` 独立核查；本轮仅允许自制测试素材作为工程输入，不能将其包装成正式科研发现。

## E. QA 必须证明“不是假第一帧”

- 记录真实输入 MP4 SHA、`ffprobe` 时间与尺寸；用 FFmpeg/可靠解码从**同一个文件**提取首帧，与开窗期截图的**素材内容区域**做像素/视觉对账（允许因最终H.264二次编码产生小误差，需说明容忍度），不能比较不同UI覆盖层。
- 开窗后的至少两个时间点 `asset_local_time=0`、进度=0、内容帧没有运动；点击播放后一秒 `asset_local_time≈1.0s`、B 素材确实运动、进度≈`elapsed/source_duration`。快门帧与播放器更新时间必须由单一时钟派生；不出现旧 Codex 半自动切换时那种不含鼠标点击的状态变化。
- 提供 MP4、至少8张动作关键帧、一个包含“首帧/暂停/播放”的抽帧对照、真实 `manifest`、机器 QA 和完整本机执行报告；记录帧率、帧数、黑段/解码、渲染命令、浏览器 SHA、所有新增路径。
- **Owner 完整观看后评价“真的像在电脑里点开并播放一个视频”**，才可能通过下一层视觉试验。不准因 FFmpeg/Remotion 技术测试通过就直接打 `G1_FULL_PASS`。
- 如环境没有本机素材可用，**只生成自制测试素材**而不为拿研究视频绕权利门禁；如缺环境或发生新浏览器下载请求，立即 `BLOCKED` 并交还 Owner。

## F. 按证据推进、全部回主线

完成后在原本机输出目录保留真实 MP4 和数据；向 Reviewer 提交实际片、关键帧、源码与报告。**先由 Reviewer 核查**，再 docs/code-scoped PR 合并入 `main`，更新唯一 `CURRENT_STATE.md`。不得留唯一有效记录在无 PR 的短命分支，也不要擅自删除不同 Gate 的历史证据。

**本文件本身只是下一轮执行合同，不代表该任务已运行或通过。**
