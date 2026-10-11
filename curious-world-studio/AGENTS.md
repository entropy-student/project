<!-- CWS-20261011-YTDLP-THIRD-TEST-PASS-LATEST -->
> **yt-dlp 支线最新（2026-10-11）**：Owner 已上传真实 Blender 480p MP4及5份诊断材料，Reviewer 独立 SHA、FFprobe、FFmpeg 全解码 PASS。对比本机端口握手报告后，问题源于 `HTTP_PROXY` 把 SOCKS-only 10808 声明为 HTTP，而 Clash mixed 7897 是可用 HTTP 代理；使用 `--proxy http://127.0.0.1:7897` 后**指定 Blender 官方视频实际下载成功**。`DIRECT_MEDIA_DOWNLOAD=PASS_ONE_SOURCE`，不是全部视频站点可用。YouTube 仍有匿名挑战，不准绕过。新建的 `cws-ytdlp.ps1` 只有 Codex 本机语法和哈希报告，**脚本本体未提交供 Reviewer code QA**，不标 `WRAPPER_END_TO_END_PASS`；代理端口变动先读回实际配置，勿改全局代理/VPN。最新 Review：`docs/P4_YTDLP_EXPLICIT_PROXY_DIRECT_DOWNLOAD_PASS_REVIEW_2026-10-11.md`。所有旧支线 RETURN 仅属历史。**主线 M2 patch 仍待独立代码 PR 审查，G1/G2 仍 NOT_PASS**；不重新跑测试片，不清理关键证据或提前执行正式视频生产。

<!-- CWS-20261011-M2F2-NEWEST-REVIEW -->
> **最新主线（2026-10-11）**：Owner 已上传 M2-F2 唯一真实回归 MP4 与7件报告；Reviewer 独立验出 **9秒1920x1080@30/270帧/H.264全解码、黑帧无命中、SHA同历史M1**，Remotion和旧M1 runner exit0；F2为 **PASS_CANDIDATE_ONE_OBSERVABLE_REGRESSION**。新观察器后处理自身exit1、launcher退出记录缺失，记为采集缺口；渲染期间可用RAM最低221.86MiB（6x）须在未来长片控制。历史 M2 返回状态不变、M2 五文件源码仍**未合并**，没有 G1/G2 PASS。**不再重渲这些测试片**。下一步由 Owner 明确转发 `p4-g1/TASK_M2_SOURCE_PATCH_PR_ONLY_2026-10-11.md`，让本地主线只将精确五文件旧 M2 补丁提出代码 PR，**未经 Reviewer 复核不合并，不进入 G2，不清理证据，不动网络或支线**。见 `docs/P4_G1VA_M2_F2_REVIEWER_INDEPENDENT_MEDIA_QA_2026-10-11.md`。以下较早提及 F2 PLAN_ONLY/F1 最新 Gate 的内容均为历史，按本条最新结果解释。

<!-- CWS-20261011-M2F1-NEWEST-GATE-STATUS -->
> **最新 Review/执行边界（2026-10-11）**：M2-F1 只读诊断已回报并由 Reviewer 核对两份完整上传文本 SHA；历史第184帧媒体抽帧失败与本地 /proxy HTTP500 同帧，根因仍 UNKNOWN；因首次 argv/退出码不可从历史资料补齐，`M2-F1=RETURN_DIAGNOSTIC_INCONCLUSIVE` 且**STOP，不再重复该任务**。原 M2 Gate 仍 RETURN、M2 源码 patch 尚未合并。下一选项 `p4-g1/PROPOSAL_M2_F2_ONE_BOUNDED_OBSERVABLE_REGRESSION_2026-10-11.md` 仅为 **PLAN_ONLY / NOT_AUTHORIZED**，不能自动执行新的渲染、重试、清理或 G2。已成功的两支 M2 候选 MP4 不重做；支线 yt-dlp 保持独立。权威审核 `docs/P4_M2_F1_REVIEWER_DIAGNOSTIC_INCONCLUSIVE_AND_STOP_2026-10-11.md`。下文较早“当前仅允许运行 F1 只读 Gate”是历史状态，已被本段覆盖。

<!-- CWS-20261011-LANDSCAPE-PREPROD-CLEANUP-YTDLP -->
> **Owner 2026-10-11 最新决定**：正式视频里的源素材**默认选 16:9 横屏**，竖版仅在有必要且内容真实/权利可核时用 B 内 `contain` 或 4 类布局，不拉伸、不裁切关键证据。**首支正式完整视频开始生产前需要受控清理 Gate**，先做目录/引用/证据/备份盘点、Owner 授权精确删除清单，**本轮绝不清理**。合同 `docs/PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md`。
> **yt-dlp 已收到安装及下载回报**：Owner 上传测试 ZIP，Reviewer 已核对官方 Release digest 与本机安装报告，工具安装可认定获证；Wikimedia 媒体请求失败，返回 `RETURN_YTDLP_MEDIA_REQUEST_FAILED`，没有下载或媒体解码。见 `docs/P4_YTDLP_INSTALL_REVIEW_AND_MEDIA_REQUEST_RETURN_2026-10-11.md`。**不能因为测试失败就删除工具、改 VPN、重新安装，不能在 M2-F1 Gate 里继续 yt-dlp 测试**。

<!-- CWS-20261011-M2-RETURN-CURRENT-REVIEW -->
> **现行 Gate 已更新（2026-10-11）**：Owner 上传两支 M2 MP4，经 Reviewer 独立文件 QA 通过；但 M1 runner 初次 frame184 渲染故障后未经诊断直接重试，原 M2 Gate **RETURN_UNDIAGNOSED_RENDER_FAILURE**。**当前仅允许运行** `p4-g1/LOCAL_CODEX_M2_M1_RENDER_FAILURE_READONLY_GATE_2026-10-11.md` 的只读日志诊断；不得重跑 M2、改码、清理、借新安装授权跑 yt-dlp、推进 G2。正文旧 M2 Gate relay 属历史。最新结论见 `docs/P4_G1VA_M2_REVIEWER_UPLOAD_QA_AND_RETURN_2026-10-11.md`。

<!-- CWS-20261011-246-MOTION-AND-YTDLP-AUTHORITY -->
> **Owner 最新动效选择：只要 2/4/6 三大类**——2 转场衔接；4 双画面/分屏/画中画布局；6 真实来源、证据标签和单行字幕的信息呈现。禁止镜头推拉平移、动态局部放大/圈注追踪、定格快慢放、新滤镜和另造界面特效。保留 Research Aqua A/B 已选外壳的原有鼠标/窗口行为。权威限制见 `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`。**Owner 已向本地 Codex 下发一份独立的 yt-dlp 安装与合法测试视频下载/解码提示词**，仅该独立任务获授权安装特定官方程序；不要把此许可套用到 M2，现已获得执行回报：本机安装校验获证，但真实下载未成功。原文件下方提到的“不得擅自下载安装”仍适用于其他未授权任务。

<!-- CWS-20261011-3PLUS1-ACTIVE-POLICY -->
> **最新 Owner 授权素材政策**：正式视频必须遵守 `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`：研究/实验一手素材、OpenMontage视频检索、yt-dlp 合规视频提取三路按需选；Codex **只可做少量真实素材后期强调/转场**。禁止 AI 生图/生视频、代码/SVG/Canvas画果冻等实体、重复或循环镜头。**当前已派发 M2 Gate 只测自制几何测试片，范围和验收保持不变。** yt-dlp 的本机能力 `UNVERIFIED`，不得基于历史 Edge 播放视频假定工具已安装，不得擅自下载安装。

<!-- CWS-20261011-M2-CURRENT-NAV -->
> **Reviewer/Executor 现行入口**：`docs/CURRENT_STATE.md` → `docs/REVIEWER_HANDOFF_2026-10-11_M2.md` → `p4-g1/LOCAL_CODEX_G1VA_M2_VARIANT_MEDIA_TASK_2026-10-11.md`。本文件以下原「P4-G0唯一执行边界」是 **2026-10-10 历史块，现已被 M2 Gate 取代**，不得据此禁止已经获得授权的受控 M2 本机验证，也不得据旧块重做 G0。M2 仅允许本地自制24fps横屏/30fps竖屏夹具的隔离测试和 M1 代码改后回归，**不安装/下载/付费/研究原视频/G2**。Owner 表示可以继续不等于亲自观看 M1 MP4 的证明。Executor 启动只读取 Gate relay 指定文件，不扫历史。

<!-- CWS-20261010-HISTORY-NAV -->
> **历史 2026-10-10 入口（已过时）**：`docs/CURRENT_STATE.md`，**新聊天完整交接**读 `docs/REVIEWER_HANDOFF_2026-10-10_P4G0.md`。`docs/PROJECT_HANDOFF_2026-10-10.md` 和 `REVIEWER_HANDOFF.md` 为历史交接增量，其中旧“下一步”不再代表当前。原选题 WORKFLOW / HF-FIND / STYLE_LOCK 的业务权威不变。

# Agent 入口（本项目唯一）

本项目目录用于保存频道研究与视觉规范，不是执行一次全自动视频制作。

## 读文件优先级
1. 当前状态 `docs/CURRENT_STATE.md`；项目说明 `README.md`、历史决策 `docs/STATUS_AND_DECISIONS.md`。
2. **研究任务唯一权威协议** `research/HF_有趣发现_唯一主协议.md`。严禁把旧 v1/v2/v3 报告当成并行命令。
3. **视觉任务唯一权威规范** `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`，参数在 `visual/retro-mac-v1.2/config/design-tokens.json`；当前 HTML 仅作预览参考。
4. 频道气质 `docs/CHANNEL.md`；只有存在具体冲突时才向 Owner 请求裁决。
5. 本项目位于项目库 `project/curious-world-studio/`，不修改其他一级项目。

## 历史 P4-G0 执行边界（当前 M2 不适用）

- 已完成的是 **OpenMontage 上游源码静态审计**；Owner Windows **本机安装状况尚未只读回报**，不得把 G0 误报PASS。
- 本地 Codex 下一步任务书：`docs/P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md`；先读 `docs/P4_G0_UPSTREAM_STATIC_AUDIT_AND_INTEGRATION_BLUEPRINT_2026-10-10.md`。
- G0 只能做本机只读查询与集成设计的文字报告；**禁止安装/下载/运行测试/TTS/渲染/改网络**。新 G1 20–30秒音画样片、G2成片、G3复用均属后续授权。

## 命令分流
- `HF-FIND` / 日常发现 / 回归测试：按研究主协议执行，扫描 HF Daily Papers 并出两套榜单；不写剧本、剪辑、部署。
- `STYLE-REVIEW`：只审查/对照视觉样式和现有原型。未经明确要求，不擅自开发视频渲染器。
- `PROJECT-STATUS`：只读说明当前定稿与待决定事项。

## 必须遵守
- 选题系统只保留 **一份主协议**；建议先积累反馈，连续系统偏差时经 Owner 同意再改版。
- 不因论文技术领域相似就剔除具体故事不同的候选。
- 标题承诺不得超出实际可定位的证据；将论文事实、作者解释和编辑类比分开。
- 源视频 `LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED` 互不替代。
- 视频固定为 A（简短桌面）+ B（边到边播放器，素材/文献/字幕在内部轮播）；无额外 C 主体模式。
- 标记“名称候选”为待决定，不能自行注册、改名或公开发布。
- 不要将本仓视觉 HTML 原型误报为完整成片系统。Owner 交接中的本地 OpenMontage 技术底座 READY，但本仓未集成、长片素材语义匹配未验收；视频生产前必须取得 Owner 明确批准。

## TOPIC-BANK｜跨领域选题正式流程
- **Owner 已确认顺序**：九大信源→批量发现→筛选评价→正式选题库→STORY-FIT→剧本与素材→成片 QA。该工作流见 `research/topic-bank/WORKFLOW_V1.md`。
- 指令 `TOPIC-BANK` /「批量发现与入库」：先读 `research/SOURCE_SYSTEM_FINAL_V1.md` 与 `research/topic-bank/WORKFLOW_V1.md`，然后新建带日期和覆盖量的批次日志，更新 `TOPICS_V1.json` 并同步 `BOARD_V1.md`。
- 每次触及 `TOPICS_V1.json` / `BOARD_V1.md` 时，先跑 `python curious-world-studio/research/topic-bank/validate_topic_bank.py` 与 `python -m unittest discover -s curious-world-studio/research/topic-bank -p test_validate_topic_bank.py`；两项仅核字段、ID、日期格式及看板同步，不修改业务评分或晋级。
- `SHORTLIST` 只代表准入下一阶段，不能说 `STORYFIT_GO`；资源商用授权、B 站竞争和逐片实测必须分开记录。
- 不要因为 Owner 喜爱某些标题就夸大观众好感，也不因某项研究技术性强就简单淘汰。HF-FIND 仍只按原唯一主协议扫描 HF。
