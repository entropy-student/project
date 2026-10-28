# 实操型视频文案实验 · REVIEWER HANDOFF
记录日期：2026-10-28
Governance：VPS Project Governance v0.2.7 / ACTIVE_PROVISIONAL；本轮 GitHub read-back blob `3917c88a7f36df7a53758b3879a92703d659ef9d`。不创建新的治理规范。

## PROJECT_GOAL
**规划、试验并逐步沉淀一套实操型自媒体视频的叙事文案与对应配画面方法**：如何用情境引入、具体问题、研究/操作/验证过程、可信证据和结果构成值得观看的内容；同时逐单元说明观众要看什么、素材在哪里获得或怎么制作。Mac mini 是第一期试验题材，不是项目的永久选题边界。Human Writing Skill + 精简语料库是候选风格方法，尚待比较验证，而非已冻结方案。

## PROJECT_STAGE
`RESEARCH_PLAN_READY / G1_DRAFT_PENDING`。G0 的 ZIP 清单校验作为历史源发现有效，但最初「静态 HTML 教程建设项目」定位已由 Owner 2026-10-28 指令纠正，不再用于确定交付边界。**当前研究方案是 CANDIDATE，不是已经得到观众或 Owner 对格式的最终验证。**

## SYSTEM_MAP
| 项目 | 当前已知情况 |
|---|---|
| 创作产物 | 自媒体实操视频的**口播脚本 + 语义单元配画面/素材计划** |
| 首期题材 | Mac mini 到手后如何少花不必要的配件费、完成开机和必要设置 |
| 原始输入 | Owner 上传 `Macmini实操指南.zip`，4 文件：原 HTML、封面 PNG、Apple 示意图 PNG、打磨记录 MD；只作为参考 |
| 风格输入 | Human Writing Skill 与用户语料的使用可行性待 Codex 实际检查；不得虚构已经有效 |
| 首轮审稿输出 | **一个独立 HTML**：封面概念、完整口播、对应画面与素材缺口；HTML 不是产品 |
| 运行环境 | 无后台/数据库/Docker/VPS/域名/部署要求；不需要移动端适配或 HTML 设计专项 |
| 网络/来源 | 影响事实准确性的官方资源需要有来源；不能把别人素材视为自由转载 |
| 视频制作 | 本轮不剪片、不配音、不生图、不生成最终封面；交付可供后续制作的脚本和镜头需求 |
| 共享资源 | GitHub `entropy-student/project` 项目专属目录，不动其他项目 |

## CURRENT_ACCEPTED_STATE
- `OWNER_EXPLICIT`：用户希望先由 Reviewer 调研、提出适合实操型视频的写作格式，再向 Codex 下发首轮文案创作提示词；最终根据样稿反馈修订方法。
- `OWNER_EXPLICIT`：没有选定最终视频叙事/格式/配图方式；HTML 单文件仅供自己审阅，不要求移动端或单独打磨页面。
- `DIRECT_READBACK`：原 HTML 是 6 个操作章节的图文教程，18 个正文 p，2 个 figure，**不是已验收的视频脚本**。
- `REVIEWER_RESEARCH / CANDIDATE`：首轮建议测试「问题驱动的探索式叙事」，对比清单式和过程纪录式；证据与适用范围详见 `docs/RESEARCH_SCRIPT_FORMAT.md`。
- `DIRECT_READBACK`：原 ZIP 4 个成员 CRC 通过、源哈希见 `docs/SOURCE_MANIFEST.md`；男主形象参考图不在 ZIP。
- `UNVERIFIED`：该叙事结构对目标观众的真实吸引力；Human Writing + 语料是否提升个人风格；Mac mini 实机步骤、素材权利和最终画面表现。

## CURRENT_GATE
`G1_VIDEO_SCRIPT_AND_VISUAL_BEATS_PILOT_20261028`：`docs/G1_SCRIPT_PILOT_GATE.md`。这是**下一轮 Codex 的唯一 Gate**；旧 `docs/G1_SOURCE_IMPORT_GATE.md` 已在运行前被 Owner 要求纠偏，状态 `SUPERSEDED / DO_NOT_EXECUTE`。

## CRITICAL_CONSTRAINTS
- 不把原 HTML 六章目录、4:3 封面方向或「逐步讲解」变成视频脚本的硬规定；任何视觉封面设定仍是素材参考、不是首轮必达目标。
- 第一轮先要一个**能够口播的视频文案**，连带每个主要信息单元的画面方案、实际素材/缺口；不只交提纲、网页或普通文章。
- 不编造本人已经拥有/使用/测试 Mac mini；官方资料、推测与实操必须分开。
- HTML 只需一个可独立打开的文件供审稿，避免额外移动端/HTML 美术/前后端/部署迭代。
- Human Writing Skill 与语料作为可验证选项；不强称一定有效；表达自然，不堆梗。
- 原始 ZIP 和旧文件保留不改；不公开发布、乱转第三方素材、不修改其他项目或共享服务。

## DEFAULT_EXECUTION_CHANNEL
下一轮由 Codex 在真实可读的**本地**工作区使用 Owner 提供的 ZIP 或工作包生成草稿；GitHub 专用工作分支用于文本治理与必要 evidence。Codex 的本地实际路径尚未 verified。

## CURRENT_ROLLBACK_STATUS
当前仅方案/项目治理变更，Draft PR 可回退；原 ZIP 仍是内容基线。无生产发布、生产回滚或业务数据迁移。

## UNRESOLVED
- 第一版叙事与配图是否符合审美需要等 Codex 样稿，尚不作 PASS。
- Human Writing Skill/精简语料库是否可供 Codex 当前会话读取，以及实际效果，尚不明确。
- 实机资料与可公开复用素材仍要在内容中逐项区分；本轮不强制解决最终版权与封面设计。
- 单文件 HTML 本地打开未执行，属于下一 Gate 检查。

## NEXT_STEP
把 `docs/G1_SCRIPT_PILOT_GATE.md` 末尾的自包含提示词交给 Codex；Codex 输出**两种开场、一版完整口播、相应画面/素材计划，以及单文件 HTML**。Reviewer 逐项审稿并据此只修改真正影响内容质量的格式/提示词问题，不启动网站工程。

## OWNER_ACTION_REQUIRED
启动 Codex 下一轮时提供可读取的原 ZIP/工作包路径；如果要比较私人语料风格，再提供允许使用的精简语料。**当前无部署、付费或发布操作。**

## EVIDENCE_POINTERS
- `docs/RESEARCH_SCRIPT_FORMAT.md`：Reviewer 调研、结构对照、首轮叙事假设与配图规格。
- `docs/G1_SCRIPT_PILOT_GATE.md`：下一轮 Codex Gate 与可复制提示词。
- `docs/SOURCE_MANIFEST.md`：历史原包清单，仅用于定位原素材，不再是主线验收重点。
- `DECISION_LOG.md`：Owner 纠偏及范围修订。
- `EXECUTION_EVIDENCE.md`：G0 原包证据与本轮研究范围修订。
