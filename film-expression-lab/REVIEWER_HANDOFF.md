# 当前项目状态

PROJECT_GOAL: 建立长期影视隐藏表达频道；下一轮只给执行 agent 一段提示词和一个片段，得到可审阅的本地测试视频。
PROJECT_STAGE: 已接受 G0/G1/G1B/G1C/G1D；Owner 指定后续仅 S1风格/S2测试/S3最终三大 Gate；S1候选预览已制作，待 Owner 风格选择；S2真实试产尚未激活。
SYSTEM_MAP: 本机 Windows + PowerShell7.6.5 + Node24.19.0 + FFmpeg9.0 + HyperFrames0.8.186(npx缓存)。Python 复用 OpenMontage venv；其受保护 .env 只供项目 TTS 适配器在内存读取。Exa/Crossref 做有界研究；Human Writing 强制。无 frontend/backend/worker/scheduler/数据库/公网端口/域名/Docker 业务依赖，无当前在线资源。
CURRENT_ACCEPTED_STATE: Owner正式确认频道名称小克拉片；陪伴式拉片（原片顺序完整原速播放/暂停解读/回看/继续，取消90–180秒限制）不变。Owner估计3GB运行内存够用，明确不以历史6–8GiB建议/doctor单独内存警告停工；3GB未实测。视觉、头像、封面、片头片尾尚未确定，旧“再看一幕”和灰框已否决。
CURRENT_GATE: FEL-S1-STYLE-20261023，正式频道名小克拉片；视觉尚未定稿。六风格的真实视频参考及12条16:9片头片尾生成提示词已整理到style/INTRO_OUTRO_REFERENCE_RESEARCH_20261023.md，未调用外部视频模型。S2详见gates/G2_TEST_VIDEO.md。
CRITICAL_CONSTRAINTS: 频道名称小克拉片；内存不作预先阻断，3GB仅Owner未验证估计且实际OOM需诊断；父仓库其他项目不变；不自动上传/发布片源；原片完整原速原序、三时钟；Human Writing；事实与推论分开；TTS no-retry/no-fallback/no-secret-output；Executor不自批PASS。
DEFAULT_EXECUTION_CHANNEL: 当前本机 PowerShell/exec + Python + 固定版本 npx，GitHub 读取用当前插件；没有接受远程/云端执行作为默认。
CURRENT_ROLLBACK_STATUS: 新增本项目目录、不覆盖源输入；没有生产运行与真实供应商生成，无生产回滚对象。不自动删除任何缓存/其他项目。正式测试产物每次独立 run，保留证据。
UNRESOLVED: 风格A电影资料馆/B导演批注与其他视觉候选、头像、封面、片头片尾均未定；片源未提供；百炼真实权限/价格/合成、影视渲染、3GB运行峰值与完整音画验收UNVERIFIED；本机global技能更新范围待Reviewer处理；发布平台/频率/正式选片未定。频道名已确认，不属UNRESOLVED。
NEXT_STEP: Owner观看本轮六种风格的真实动态参考及各自片头片尾方案，后续明确选择风格再制作；当前只完成研究与提示词，不默认批准风格/视频生成/费用/上传。其余待定事项不替Owner决定；S2独立等待片源与有界授权。
OWNER_ACTION_REQUIRED: 本轮NONE；频道名小克拉片已定。视觉等未决事项不代Owner选择，后续S2启动需可读取片源与当轮TTS有界授权。
EVIDENCE_POINTERS: 原E001–E012；本轮style/INTRO_OUTRO_REFERENCE_RESEARCH_20261023.md及E013；三Gate计划gates/THREE_GATE_PLAN.md。

过去命名候选（“一幕拉片室”等）仅是历史记录，现正式频道名为小克拉片；视觉候选包括导演批注、电影资料馆、私人放映室、影像杂志，尚无一项被确认。Agent Reach1.6.0已验事实不重测。Owner预计约3GB内存足够，旧6–8GiB空闲预算不再是推进条件；真实峰值以S2试段为准，不静默换框架。

## 全项目路线

G0–G1D 既有准备/归档 PASS → S1风格定稿 IN_PROGRESS（候选已制作，待Owner选定） → S2单段真实试产 NEXT → S3完整一期 PENDING。

## 下轮 Reviewer 治理加载

从 GitHub 当前 canonical 读取通用部分与所有专项触发表，按新一轮实际动作加载命中专项。不得以本地 Gate/手册替代 Governance，也不固定沿用本轮 commit。B 本机/秘密、C 资源、E 供应商在视频测试中适用；其他逐项判断。Executor 无需重读规范。
