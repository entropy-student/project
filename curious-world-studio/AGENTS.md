<!-- CWS-STABLE-WORKFLOW-20261015 -->
> **2026-10-15最新**：先读[唯一当前状态](docs/CURRENT_STATE.md)、[当前Reviewer交接](docs/REVIEWER_HANDOFF_CURRENT.md)、[MEDIA架构/阶段规划](docs/MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)和[当前按需运行/中断恢复规范](docs/MEDIA_ONDEMAND_RECOVERY_AND_START_STOP_POLICY.md)（原[无Docker验收协议](docs/MEDIA_DOCKERFREE_RUNTIME_AND_ACCEPTANCE.md)暂停）。**PR#129已合并main（commit `10b369ee`）**，独立本地工具有Windows36/36与Reviewer接受的修复；**尚未获得无Docker整链PASS，也未接入正式制片**。正式制作仍`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。
> **编号不可混淆**：`MEDIA-R4+R5`是素材工具清理/海外来源扩展；`MEDIA-INTEGRATION`已经合并；**旧`MEDIA-DOCKERFREE-ACCEPTANCE`部署执行已被Owner中断并暂停；当前唯一新任务为`MEDIA-ONDEMAND-RECOVERY-G0`只读**。`PROD-R4`是第一版完整草片；`MEDIA-R6/R7`均未授权。
> **Owner已锁定的MEDIA获取默认**：排除大陆视频平台及全球竖屏/方形，显示比例≥4:3，未知先核实，优先1080p横屏，保留每次拒绝原因；这些规则已在`main`的独立MEDIA模块中，但不自动替换正式节目入口。**3+1与Research Aqua不变；下载成功与制作许可/内容核验分开**。
> 普通ZIP验收留本机，重大决策/架构/正式稳定代码才进Git；获准修改生产代码须分支PR/Reviewer核查。不得再把2026-10-12“Owner暂停所有新任务”的旧快照覆盖上述已恢复的MEDIA工具工作；不自动升级制作Gate或发布。

# Agent 入口（本项目唯一）

本项目目录用于保存频道研究与视觉规范，不是执行一次全自动视频制作。

## 读文件优先级
1. **唯一当前状态：`docs/CURRENT_STATE.md`**、`docs/REVIEWER_HANDOFF_CURRENT.md`、`docs/MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md`、`docs/MEDIA_DOCKERFREE_RUNTIME_AND_ACCEPTANCE.md`；项目简介 `README.md`。`docs/STATUS_AND_DECISIONS.md` 与历次 Reviewer 报告仅历史溯源。
2. **研究任务唯一权威协议** `research/HF_有趣发现_唯一主协议.md`。严禁把旧 v1/v2/v3 报告当成并行命令。
3. **视觉任务唯一权威规范** `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`，参数在 `visual/retro-mac-v1.2/config/design-tokens.json`；当前 HTML 仅作预览参考。
4. 频道气质 `docs/CHANNEL.md`；只有存在具体冲突时才向 Owner 请求裁决。
5. 本项目位于项目库 `project/curious-world-studio/`，不修改其他一级项目。

## 历史 P4-G0 执行边界（当前 M2 不适用）

- 已完成的是 **OpenMontage 上游源码静态审计**；Owner Windows **本机安装状况尚未只读回报**，不得把 G0 误报PASS。
- **历史**本地G0任务书：`docs/P4_G0_LOCAL_CODEX_READONLY_TASK_2026-10-10.md`，只能作历史溯源。当前MEDIA下一Gate请读`docs/MEDIA_ONDEMAND_RECOVERY_AND_START_STOP_POLICY.md`，仅可做中断恢复G0只读现场调查，不得按旧无Docker部署Gate启动任务。
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
