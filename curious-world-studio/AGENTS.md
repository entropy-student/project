# Agent 入口（本项目唯一）

本项目目录用于保存频道研究与视觉规范，不是执行一次全自动视频制作。

## 读文件优先级
1. 项目说明 `README.md`、确定事项 `docs/STATUS_AND_DECISIONS.md`。
2. **研究任务唯一权威协议** `research/HF_有趣发现_唯一主协议.md`。严禁把旧 v1/v2/v3 报告当成并行命令。
3. **视觉任务唯一权威规范** `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`，参数在 `visual/retro-mac-v1.2/config/design-tokens.json`；当前 HTML 仅作预览参考。\n5. 此项目位于项目库 `project/curious-world-studio/`，不修改其他一级项目。
4. 频道气质 `docs/CHANNEL.md`；只有存在具体冲突时才向 Owner 请求裁决。

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
- 不要将原型能播放视频误报为完成自动素材下载、声学字幕对齐或生产渲染。

## TOPIC-BANK｜跨领域选题正式流程
- **Owner 已确认顺序**：九大信源→批量发现→筛选评价→正式选题库→STORY-FIT→剧本与素材→成片 QA。该工作流见 `research/topic-bank/WORKFLOW_V1.md`。
- 指令 `TOPIC-BANK` /「批量发现与入库」：先读 `research/SOURCE_SYSTEM_FINAL_V1.md` 与 `research/topic-bank/WORKFLOW_V1.md`，然后新建带日期和覆盖量的批次日志，更新 `TOPICS_V1.json` 并同步 `BOARD_V1.md`。
- `SHORTLIST` 只代表准入下一阶段，不能说 `STORYFIT_GO`；资源商用授权、B 站竞争和逐片实测必须分开记录。
- 不要因为 Owner 喜爱某些标题就夸大观众好感，也不因某项研究技术性强就简单淘汰。HF-FIND 仍只按原唯一主协议扫描 HF。
