<!-- CWS-STABLE-WORKFLOW-20261011 -->
> **当前有效入口**：[docs/CURRENT_STATE.md](docs/CURRENT_STATE.md)。**R1多轮、R2条件设计与R2-M1均已独立Review；当前`CW0005_VISUAL_STORYFIT_HOLD`，Owner决定先不换题并暂停所有新任务**；不可按旧的CW0004/CW0008建议自动切题，见[完整交接](docs/REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)；CWS本地清理审计+纠错已Reviewer通过，安全可删0B，实际删除0项。Mac动效支线停止新增开发，Owner Windows`file://`与最后视觉签收仍待确认。**G1未正式PASS、G2未授权。**
>
> **固定交接**：默认只把Reviewer的**文字任务提示词**发给本地Codex；Codex交付一个包含证据、manifest与SHA的ZIP，由Owner转给Reviewer。无需再把Reviewer的ZIP反向传给Codex，除非特定不可重建的输入必须传递。普通报告不进GitHub；经批准的长效规范/生产代码/重大决策才提交。
>
> **本地常用文档**：若本机已存在Git checkout，先读本地Git受控规范；Codex从**后续获得工作区写权限的任务**起可将必要工作笔记、源权利台账、RUN索引及ZIP存在 `curious-world-studio/.local/`（受项目`.gitignore`保护），不得将其当成另一份正式规范；**R2/M1已在本地`.local/`交接；Owner当前没有授予新的执行权限**。未经Owner单独批准不付费、不外联、不删除、不改变版权状态、不发布。

# Agent 入口（本项目唯一）

本项目目录用于保存频道研究与视觉规范，不是执行一次全自动视频制作。

## 读文件优先级
1. **唯一当前状态、ZIP任务交接、读文件最短路径：`docs/CURRENT_STATE.md`**；项目简介 `README.md`。`docs/STATUS_AND_DECISIONS.md` 与历次 Reviewer 报告仅历史溯源。
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
