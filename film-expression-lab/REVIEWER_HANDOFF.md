# 当前项目状态

PROJECT_GOAL: 建立长期影视隐藏表达频道；下一轮只给执行 agent 一段提示词和一个片段，得到可审阅的本地测试视频。
PROJECT_STAGE: 已接受 G0/G1/G1B/G1C/G1D；Owner 指定后续仅 S1风格/S2测试/S3最终三大 Gate；S1候选预览已制作，待 Owner 风格选择；S2真实试产尚未激活。
SYSTEM_MAP: 本机 Windows + PowerShell7.6.5 + Node24.19.0 + FFmpeg9.0 + HyperFrames0.8.186(npx缓存)。Python 复用 OpenMontage venv；其受保护 .env 只供项目 TTS 适配器在内存读取。Exa/Crossref 做有界研究；Human Writing 强制。无 frontend/backend/worker/scheduler/数据库/公网端口/域名/Docker 业务依赖，无当前在线资源。
CURRENT_ACCEPTED_STATE: Owner已纠正产品为顺序展开的陪伴式拉片，播放/暂停解读/回看/继续，保留所选场景完整原速播放；取消90至180秒目标。名称必须含“拉片”，旧“再看一幕”和灰色画框视觉被否决。详见FORMAT_REVISION_20261023。当前没有源片、节目或受众实测。
CURRENT_GATE: FEL-S1-STYLE-20261023 为当前 Gate；style/STYLE_REVIEW.md + style/style-preview.html 为待 Owner 审阅候选；S2沿用 gates/G2_TEST_VIDEO.md 详细执行合同，S3见 gates/THREE_GATE_PLAN.md。
CRITICAL_CONSTRAINTS: 父仓库其他项目不变；不自动发布/上传片源；不重开定位；事实与解读区分；三种时间码；旁白必须 Human Writing；TTS no-retry/no-fallback/no-secret-output；Executor 不自批 PASS。
DEFAULT_EXECUTION_CHANNEL: 当前本机 PowerShell/exec + Python + 固定版本 npx，GitHub 读取用当前插件；没有接受远程/云端执行作为默认。
CURRENT_ROLLBACK_STATUS: 新增本项目目录、不覆盖源输入；没有生产运行与真实供应商生成，无生产回滚对象。不自动删除任何缓存/其他项目。正式测试产物每次独立 run，保留证据。
UNRESOLVED: Owner 尚未最终选择 A电影资料馆 / B导演批注；正式名称、品牌素材未冻结；源片未提供、百炼真实权限/价格/额度/合成UNVERIFIED、真实视频渲染及完整听看UNVERIFIED；本机技能更新可能触及项目外，需Reviewer先处理；发布平台/频率/完整成片选片未定。
NEXT_STEP: Owner 一次选择 S1 风格（可直接选 A / B），即冻结样式；然后提供一段可访问片源并按既有 G2 执行提示词有界授权启动 S2 单段试产；S2 PASS 后开展 S3 最终一期，不另拆品牌/声音/字幕/QA Gate。
OWNER_ACTION_REQUIRED: 当前仅一次风格选择（A电影资料馆 / B导演批注或指定最小组合）；现阶段无需片源、凭据或费用授权。S2 时才提供片源及真实有界调用授权。
EVIDENCE_POINTERS: 原 E001–E007；三Gate计划 gates/THREE_GATE_PLAN.md；候选风格 style/STYLE_REVIEW.md 和 style/style-preview.html；本轮执行事实为 E008（提交/读回核验单独追加）。

品牌新候选包括“一幕拉片室”“慢慢拉片”“逐场拉片”等，未查重/确认；视觉候选为导演批注、电影资料馆、私人放映室、影像杂志。Agent Reach1.6.0已验证的事实不重测。此前6至8GiB空闲是保守预算，不是本节目实际最低要求；不能因此直接要求升级硬件。主框架不静默更换，轻量顺序处理为待实测的优化候选。

## 全项目路线

G0–G1D 既有准备/归档 PASS → S1风格定稿 IN_PROGRESS（候选已制作，待Owner选定） → S2单段真实试产 NEXT → S3完整一期 PENDING。

## 下轮 Reviewer 治理加载

从 GitHub 当前 canonical 读取通用部分与所有专项触发表，按新一轮实际动作加载命中专项。不得以本地 Gate/手册替代 Governance，也不固定沿用本轮 commit。B 本机/秘密、C 资源、E 供应商在视频测试中适用；其他逐项判断。Executor 无需重读规范。
