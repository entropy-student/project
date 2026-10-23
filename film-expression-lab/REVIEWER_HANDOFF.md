# 当前项目状态

PROJECT_GOAL: 建立长期影视隐藏表达频道；下一轮只给执行 agent 一段提示词和一个片段，得到可审阅的本地测试视频。
PROJECT_STAGE: G0 已 PASS；G1 本地规划准备 PASS；G1B 品牌/运营草案已完成，Agent Reach 主程序1.6.0与web实测通过，默认B站依赖 PARTIAL；G2 CANDIDATE，未执行。PASS 不涵盖真实 TTS 或视频生产。
SYSTEM_MAP: 本机 Windows + PowerShell7.6.5 + Node24.19.0 + FFmpeg9.0 + HyperFrames0.8.186(npx缓存)。Python 复用 OpenMontage venv；其受保护 .env 只供项目 TTS 适配器在内存读取。Exa/Crossref 做有界研究；Human Writing 强制。无 frontend/backend/worker/scheduler/数据库/公网端口/域名/Docker 业务依赖，无当前在线资源。
CURRENT_ACCEPTED_STATE: Owner已纠正产品为顺序展开的陪伴式拉片，播放/暂停解读/回看/继续，保留所选场景完整原速播放；取消90至180秒目标。名称必须含“拉片”，旧“再看一幕”和灰色画框视觉被否决。详见FORMAT_REVISION_20261023。当前没有源片、节目或受众实测。
CURRENT_GATE: FEL-G1D-REMOTE-HANDOFF-20261023归档PASS；完整快照51864905f07f1eebd390070ca182b109e8ed2fa7已写main并逐文件blob核验。回执后续提交只补充归档事实。网页端首读WEB_HANDOFF.md；G2仍未激活。
CRITICAL_CONSTRAINTS: 父仓库其他项目不变；不自动发布/上传片源；不重开定位；事实与解读区分；三种时间码；旁白必须 Human Writing；TTS no-retry/no-fallback/no-secret-output；Executor 不自批 PASS。
DEFAULT_EXECUTION_CHANNEL: 当前本机 PowerShell/exec + Python + 固定版本 npx，GitHub 读取用当前插件；没有接受远程/云端执行作为默认。
CURRENT_ROLLBACK_STATUS: 新增本项目目录、不覆盖源输入；没有生产运行与真实供应商生成，无生产回滚对象。不自动删除任何缓存/其他项目。正式测试产物每次独立 run，保留证据。
UNRESOLVED: 源片未提供；真实百炼权限/价格/额度/合成仍UNVERIFIED；音画实际播放/听审能力须在G2证实；完整影视渲染未测；可用内存曾偏低但实际最低需求未测；general-video技能更新机制可能修改项目外技能，现Gate未授权该范围，须Reviewer先处理；新名字/视觉/正式片长/发布平台/更新频率未定。远端仓库已由Owner确定，不再UNKNOWN。
NEXT_STEP: Owner转到网页端，先按WEB_HANDOFF继续讨论播放/解读节奏、含拉片名称和新视觉；不擅自开始制作。收到片段及EXECUTOR_PROMPT有界授权后才激活G2。真实TTS前核实价格/额度，实际渲染仍要低内存试片与证据核验。
OWNER_ACTION_REQUIRED: 本轮 NONE；名称/头像是候选，暂不要求决定；下一轮提供片段，使用 EXECUTOR_PROMPT。若当前价格/额度不能自行核验，届时只请求缺失的确切信息，不要求用户调试工具或转交密钥。
EVIDENCE_POINTERS: EXECUTION_EVIDENCE E001至E006；preparation-validation.json与round2-validation.json为历史快照；format-revision-validation.json为当前文档快照；FORMAT_REVISION_20261023.md；gates/G2_TEST_VIDEO.md；EXECUTOR_PROMPT.md；brand/仅为旧视觉，不应用。

品牌新候选包括“一幕拉片室”“慢慢拉片”“逐场拉片”等，未查重/确认；视觉候选为导演批注、电影资料馆、私人放映室、影像杂志。Agent Reach1.6.0已验证的事实不重测。此前6至8GiB空闲是保守预算，不是本节目实际最低要求；不能因此直接要求升级硬件。主框架不静默更换，轻量顺序处理为待实测的优化候选。

## 全项目路线

Discovery PASS → 本地规划准备 PASS → 单段视频 NEXT → 模板修订 PENDING → 完整一期 PENDING → 交互伴随页 PENDING → 稳定栏目 PENDING。

## 下轮 Reviewer 治理加载

从 GitHub 当前 canonical 读取通用部分与所有专项触发表，按新一轮实际动作加载命中专项。不得以本地 Gate/手册替代 Governance，也不固定沿用本轮 commit。B 本机/秘密、C 资源、E 供应商在视频测试中适用；其他逐项判断。Executor 无需重读规范。
