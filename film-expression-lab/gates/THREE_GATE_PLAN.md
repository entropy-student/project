# Film Expression Lab — 三 Gate 精简执行路线
状态：ACTIVE PLAN · 2026-10-23 · 治理：当前 GitHub canonical VNEXT.md

已接受的 G0/G1/G1B/G1C/G1D **不重跑**。Owner 本轮明确指定未来最多三大阶段（以实际风险必要检查点为限）。

## S1 · FEL-S1-STYLE · 风格定稿（当前）
GATE_ID: FEL-S1-STYLE-20261023
OBJECTIVE: 用可审阅的离线动态样板收敛频道风格和播放/暂停/回放视觉语法，促成一次 Owner 选择。
MAX_ENDPOINT_THIS_ROUND: `style/STYLE_REVIEW.md`、`style/style-preview.html`，及项目 Gate/Handoff/Evidence 的限定修改；不进入影视制作。
MANDATORY_REVIEW_STOP: 设计候选落 GitHub 并读回，向 Owner 展示两套对照；最终选择留给 Owner。
TARGET_AND_SCOPE: 仅 `film-expression-lab/` 下指定文档与一个可离线打开的 HTML；父仓库其他项目不可改。
APPLICABLE_CRITICAL_CONSTRAINTS: 原片优先、三时钟、旧品牌已否、Human Writing 用于未来正式旁白/频道文案；不上传片源、不装全局技能、不调用供应商、不生成影像冒充实际片源。
PREFLIGHT: 核对 main/repo/path、读取 Governance universal + trigger scan + 12/13、现有 Handoff/Owner 格式纠正和相应证据；仅 GitHub 文本写入，确认没有外部接口或实际媒体。
REQUIRED_EVIDENCE: 设计对比、原速观看状态、暂停标注状态、回看状态、离线响应式预览可静态审查；改动路径/分支 SHA、读回。
ACCEPTANCE_CRITERIA: S1 的「候选方案制作」经 Reviewer 读回可 PASS；「风格定稿」只能在 Owner 选择后 PASS。两者不可混淆；不把设计示意当成试产通过。
ROLLBACK_STATUS_OR_PLAN: 本次仅新增样板/项目文档；反向提交即可撤销，不删除既有历史设计或父仓库内容。
OWNER_ONLY_ACTIONS: 风格最后选择、正式名称；试片付费/API/上传/发布另审。
REVIEWER_TO_EXECUTOR_RELAY: 当前 Reviewer 负责设计稿与记录；不派 Executor、不要求本机路径。以后 S2 的 Executor 从已冻结 S2 relay 起步。
EXECUTOR_TO_REVIEWER_RELAY: N/A（S1 无执行 Agent；Reviewer 直接提交候选与静态 QA）。

## S2 · FEL-S2-TEST · 单段真实试产（S1 后）
现有 `gates/G2_TEST_VIDEO.md` 作为 S2 **唯一详细执行 Gate**，不另拆预处理、配音、剪辑、字幕、QA 等小 Gate。经 Reviewer 激活后仍以该文件最新合同及本精简路线为边界。
目标：一段 Owner 指定影视场景 → 一条真实可看的顺序陪伴式拉片视频 + 文本/来源/claims/timeline/render/QA 证据；Executor 最多到 PASS_CANDIDATE，Reviewer 独立查证。
Preflight 集中在 S2 内：可读素材、确定源 SHA、运行时/低内存小段试渲染、Human Writing、云 TTS 本次授权与确切价格额度；若无法证明关键前提就准确 RETURN，不擅自扩张工具安装范围或付费。
最大终点：一段完整测试节目与其审阅包，**不公开发布**。验收门槛沿用 `RUNBOOK.md` 八项硬门槛，源片 first-pass 完整原序、完整可听看测试、评分目标 ≥80。若测试失败，仅限 S2 内针对具体根因修复，明显变更授权/风险边界才回 Owner。
回滚：输入只读、每次新 episodes/<run-id>，TTS 请求不自动重试，不覆盖已接受音频；完整输出与证据可保留。

## S3 · FEL-S3-FINAL · 完整一期成品（S2 PASS 后）
GATE_ID: FEL-S3-FINAL
目标：在 S2 被接受的风格与工具链上完成一期完整视频（场景/段落长度由作品与研究决定），汇总声音、字幕、引证、封面、渲染源、可回溯数据与复盘。
边界：只对 S2 暴露的问题修复，不重开频道定位，不自动扩张到网站/交互页；Owner 对最终选片、付费调用限额、版权/公开上传/平台操作保留独立授权决定。
验收：完整视频真实可听可看；逐条主张可验证；片源覆盖、声音字幕、来源/权利、发布前核查全部完成；Reviewer 检查后正式 PASS。
终点：可交付的成品媒体及证据包。**公开发布不是自动授权**，若需要发布，S3 内追加有界 Owner 检查点，不默认发布。

## 明确不新拆 Gate 的事项
命名/头像设计、独立字幕制作、TTS 适配、研究工具、视频剪辑、封面制作、QA、低内存试段都纳入各自所处 S1/S2/S3。**只有发生不能共享授权、回滚或安全边界的真实风险时才新设单独 Gate**（例如公网上线、凭据轮换、VPS 共用基础设施变更）；普通返工留在当前 Gate。

已冻结：顺序陪伴式拉片、真实证据解释、不大量裁原片、不设固定90–180秒、旧品牌不采用、Human Writing、无自动公开上传、G2 前置事实必须真实验证。
