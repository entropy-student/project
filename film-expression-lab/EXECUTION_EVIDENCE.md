# 执行证据

本文件只追加，修正需注明被修正项；工具输出存在不等于业务链验收。

## E001 2026-10-23 G0 Discovery

AUTHORIZED_GATE: FEL-G0-20261023；Owner 要求立项规划、核对本地工具与准备下一轮。
PREFLIGHT_FACTS: DIRECT_READBACK。本机 Windows PowerShell 7.6.5，身份由 whoami 核对为当前 34707 用户；cwd/Git root 为 C:/Users/34707/Documents/ChatGPT/兴趣视频，branch codex/payment-v14-g1r，HEAD 19769028c9d5216215d51b642a76c4afc4c62394。已有其他支付项目/归档及未跟踪文件。
ACTUAL_CHANGES: G0 无目标源码写入；只读 GitHub/本地文件/配置布尔值及公开搜索。
OBJECTIVE_READBACK: GitHub 插件读取 v0.2.7 Governance；main commit 16e33384dc569629a1527d1c9ec0060823af09ce，VNEXT blob 3917c88a7f36df7a53758b3879a92703d659ef9d。规则不在本地持久复制。
VALIDATION: Node v24.19.0；FFmpeg 9.0；OpenMontage venv 的 requests/dotenv/Pillow 可导入，faster_whisper/whisperx 不存在；.env 文件及两项百炼配置非空，仅布尔值输出；原始 TTS 实现已读，确认环境变量与签名 URL 文件行为。
EVIDENCE_ARTIFACTS_AND_PURPOSE: TOOLCHAIN.md 保存工具路径/界限；PROJECT_CHARTER.md 保存确认目标；发现过程工具输出在本聊天，可由上述命令复核；不是供应商生成成功证据。
ANOMALIES: agent-reach 在 PATH 不可见，但已找到 venv module 并运行 help/doctor。初始 `npx --no-install hyperframes --version` 失败，原文 `npx canceled due to missing packages and no YES option: ["hyperframes@0.8.186"]`。误查的 core/references/brief-format.md 与 brief-contract.md 不存在，随后在 hyperframes/references 定位到正确文件；属于查找失败，不是目标源码损坏。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: 0 次 TTS/ASR/图像生成，0 次媒体上传/部署；Exa 一次有界检索返回 Bordwell 官方资料；Crossref GET /works 返回 200、两条带 DOI 的书目（10.24114/gr.v11i2.37425、10.7312/siko19592-005）。书目不是已读全文。
ROLLBACK_EFFECT: 只读，无源片/生产数据改变。
EXECUTOR_RESULT: PASS_CANDIDATE（发现范围）。
REVIEWER_DECISION: PASS；当前 Reviewer 已检查上述返回，接受为本轮准备的事实基线。

## E002 2026-10-23 G1 本地准备

AUTHORIZED_GATE: FEL-G1-20261023；仅本地规划/工具准备，不进入正式媒体制作。
PREFLIGHT_FACTS: 新目录 film-expression-lab，与父仓库无关工作隔离。Windows 本地路径创建后 Get-Item 回读成功；不修改父分支、系统网络、OpenMontage 或用户凭据。
ACTUAL_CHANGES: 新建章程、工具清单、研究/制作/验收手册、三份 Gate、决策记录、执行提示词、项目入口、TTS 内存适配及合同测试。通过固定版本 npx 下载/运行 hyperframes 0.8.186，仅 npm 常规缓存及运行日志。
OBJECTIVE_READBACK: `npx --yes hyperframes@0.8.186 --version` 返回 0.8.186；doctor JSON 中 Node/FFmpeg/FFprobe/Chrome 检查成功。Chrome 路径指向既有 hyperframes 缓存，不宣称本轮新装。
VALIDATION: `python -m unittest discover -s scripts -p test_bailian_voice.py` 实际运行 4 项离线测试全部通过；覆盖缺失授权无网络请求、超时不重试/不重放、下载失败无签名链接落盘、模拟成功保存 WAV。未调用真实 TTS，不证明真实 API/音色或价格可用。
ANOMALIES: doctor 的 JSON `ok=false`，虽然命令退出码为 0。关键原因是可用内存仅 1.6GB/总15.3GB；可选 whisper-cpp/MusicGen 未安装。不能写成 doctor 全通过。render help 已确认 `--low-memory-mode` 固定单 worker，下一轮强制使用并先小段试渲染。总内存自动策略不会代替当前可用内存判断。
EVIDENCE_ARTIFACTS_AND_PURPOSE: preparation-validation.json 保存文件/hash、测试输出与检查结果；实际文件即审阅对象。CLI/doctor 本轮结果写在本文，未存原始 Provider 日志或敏感配置。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: 固定 CLI 的 npm 缓存新增；未计量缓存增量，UNKNOWN。没有 TTS/ASR/付费素材/图像请求、没有影视片源/成片/公网服务、无业务数据变化。
ROLLBACK_EFFECT: 全部新增项目文件可停止使用；保留父工作区和输入不变，不自动清缓存/删除目录；云端生成不存在，无费用回滚问题。
EXECUTOR_RESULT: PASS_CANDIDATE（规划准备限定范围）。
REVIEWER_DECISION: 待本轮最终回读；只有准备包可 PASS，生产全链保持 UNVERIFIED。

## E003 版本检查

Agent Reach `check-update` 成功，本机 v1.5.0，工具报告新版 v1.6.0。本轮没有更新；不影响已实测 Exa/Crossref 入口。该更新不属于测试视频必要前提。

## E004 Reviewer 最终核对

E002 的待审状态由本项新证据取代，保留原始记录。当前 Reviewer 回读 13 项必需文件并生成 preparation-validation.json；4 项离线合同测试复跑通过，准备包满足 G1 的范围与停止边界，判定 G1 PASS。真实 TTS/影视渲染/完整音画人工验收仍 UNVERIFIED，G2 保持 CANDIDATE。G2 已补入低内存单 worker、小段试渲染以及 JSON/退出码双检要求。当前无 Owner 需当场批准的动作；下一轮提示词的预算文字在被实际发送前不构成付费授权。

## E005 2026-10-23 Agent Reach 更新与频道运营草案

AUTHORIZED_GATE: FEL-G1B-20261023；用户明确要求更新与品牌/运营思考，未授权发布或付费生成。
PREFLIGHT_FACTS: 当前Git root/branch/HEAD与G0一致，父仓库无关未跟踪文件保留。GitHub插件重新读取当前Governance通用/触发表/B/C/F，12/13；无SSH、VPS、付费Provider与图像生成。头像采用简单原创SVG/几何绘制，符合imagegen技能的代码原生图形例外。
ACTUAL_CHANGES: uv tool install --force 官方GitHub release ZIP，安装1.6.0；官方setup刷新用户技能及Claude/OpenClaw/Gemini副本；更新用户PATH；只从 .agent-reach-venv 卸载旧Agent Reach包，保留共享venv；独立bili.exe与 .agent-reach/venv 经Test-Path仍存在。新增本项目运营方案、品牌文案、SVG/PNG及绘制源。
OBJECTIVE_READBACK: 新入口 version JSON ok=true、version1.6.0、install_method=uv；web search ok=true、backend=exa，返回Bordwell官网/加州大学出版社两条结果；doctor --text读回B站needs_setup、web已接入待独立check状态；以真实search结果证明搜索，不用doctor替代。
VALIDATION: 官网update指引要求从install第0步迁移；先备份旧技能至 .agent-reach/tools/upgrade-backup-20261023-01。已检查legacy.find仅列 .agent-reach-venv、remove代码仅pip卸载该包；非pipx整目录删除。setup实际old_copies.removed与之吻合。Human Writing应用于简介，check_prose退出0、禁用项0；静态视觉大图及48px头像已查看，片头末帧观察点避开文字后重新输出。
ANOMALIES: setup顶层ok=true但默认4/5；B站错误原文 `bili-cli:pip_packages failed: ERROR: No matching distribution found for bilibili-cli==0.6.2`。setup --help不受支持返回BAD_INPUT；有界诊断uv pip index不支持该子命令，没有改变依赖。此后遵守新版维护规则停止，不反复setup/切源/修上游；主程序升级和B站依赖完整性分别判定。原始安装报告已按原文展示/保存，报告不是逐平台功能实测。
EVIDENCE_ARTIFACTS_AND_PURPOSE: AGENT_REACH_INSTALL_REPORT_20261023.md为官方原始报告；round2-validation.json为本轮文件与品牌产物检查；OPERATING_PLAN.md为策略草案，brand/为可审阅候选，不是正式动画。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: Win32_OperatingSystem瞬时TotalVisibleMemorySize=16020952KB、FreePhysicalMemory=1518824KB。uv安装16个包，0次TTS/图像生成/付费ASR，0个新增公开站点，无登录动作。未对新程序作全渠道内存峰值benchmark，预算建议不当作实测需求。
ROLLBACK_EFFECT: 旧技能有非秘密备份； .agent-reach/venv保留可核对旧包；配置未复制到项目或输出。新增品牌和运营文件独立可弃用，无原片/业务数据变化。
EXECUTOR_RESULT: 主程序/实测web与品牌草案 PASS_CANDIDATE；B站默认依赖 PARTIAL。
REVIEWER_DECISION: 已检查版本/setup/search/代码边界/视觉与文案结果，接受主程序升级及草案，B站保持PARTIAL。G2仍待源片与授权，不被本轮替代。

## E006 2026-10-23 Owner纠正拉片形式

AUTHORIZED_GATE: FEL-G1C-FORMAT-20261023，完整Gate在FORMAT_REVISION_20261023.md；Owner要求解释内存/片长/样式并改为含拉片的名称、新视觉方向。
PREFLIGHT_FACTS: GitHub插件重新读取v0.2.7通用/触发表/B/C/12/13；当前Handoff/G2/提示词/章程已读。本轮无运行时安装、付费/秘密/图像生成/媒体写入。
ACTUAL_CHANGES: 取消默认90至180秒测试，加入完整所选场景原速播放覆盖/顺序验收；保留原TTS预算；旧品牌标为否决；新增四类视觉与含拉片名称候选、两分钟源片展开五分钟的假想时间线。
OBJECTIVE_READBACK: 章程/Gate/提示词/RUNBOOK与运营当前段落一致，不再以短影评/大量裁源作为默认。历史证据/旧品牌文件不删除或回写成新事实。
VALIDATION: 文本回读与源区间编排检查见format-revision-validation.json；假想首次原速区间[0,35)、[35,80)、[80,120)连续覆盖120秒，回放和解读相加得到300秒。不是实际影片分析或渲染证据。
ANOMALIES: 先前由Reviewer自行设定的90秒方向偏离Owner原本需求；6至8GiB预算不等于实际最低内存，已澄清。不用技术工具的限制倒推节目长度。
EVIDENCE_ARTIFACTS_AND_PURPOSE: FORMAT_REVISION_20261023.md为新当前格式；format-revision-validation.json为回读；新名称/视觉只有方向规格，无新动画/头像定稿。
ROLLBACK_EFFECT: 可逆文档修订，源片/其他项目/工具/凭据不变。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: 无渲染、无供应商调用、无新增发布。
EXECUTOR_RESULT: PASS_CANDIDATE（格式修订限定范围）。
REVIEWER_DECISION: 接受Owner纠正并完成文档对齐，格式修订PASS；G2仍待实片，实际成片质量UNVERIFIED。

## E007 2026-10-23 main归档与网页端交接

AUTHORIZED_GATE: FEL-G1D-REMOTE-HANDOFF-20261023。Owner明确选择“提交到entropy-student/project/main的film-expression-lab/”。
PREFLIGHT_FACTS: 本地无origin，先通过GitHub插件列可见仓库并向Owner澄清，确认后读取目标main/root。base commit 8d70e4bc12f0a658eede2243f2465f9a1f3397bf，base tree e5c87164c38ea8cda0458e0f8030fc8a2dcab481。远端没有同名目录；新tree只加本目录，不从本地支付分支推送。
ACTUAL_CHANGES: 上传30项文本与3项PNG，包括WEB_HANDOFF、34条需求覆盖清单、章程/执行/Gate/证据/工具/运营、TTS适配/测试和被否决历史品牌。无凭据、原片、全局技能源码或pycache。
OBJECTIVE_READBACK: archive commit 51864905f07f1eebd390070ca182b109e8ed2fa7，root tree 4bf2420744e39585ffd206f43d6065bf13ad9e78。插件update_ref采用force=false和expected_sha原main，随后main读取确为该commit。
VALIDATION: 远端新root对比base仅新增film-expression-lab，27个原root条目sha不变。目标子tree递归读取未截断，33个文件；清单中32项文件Git blob ID逐项匹配，manifest另存一项；WEB_HANDOFF头22行实际回读确认已定/纠正/待议口径。回执补充提交不改原归档清单的历史含义。
ANOMALIES: 本地读取大文本最初因Python默认输出编码导致JSON提取失败；分类为证据提取失败，改为显式UTF-8后读回成功，未重放远端写操作。没有GitHub插件失败或浏览器替代。
EVIDENCE_ARTIFACTS_AND_PURPOSE: REMOTE_PACKAGE_MANIFEST.json为归档文件字节/Git blob清单；REMOTE_PUBLICATION_RECEIPT.json为远端实际核验结果；DISCUSSION_COVERAGE_CHECKLIST.md覆盖34项对话诉求；WEB_HANDOFF为网页端入口。
ROLLBACK_EFFECT: 不覆盖原项目目录，无本地分支变更；如需撤回归档另提交只移除新增目录的正常commit，不force reset共享main。无生产服务或付费生成。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: 新增33项归档文件及后续非秘密回执；0个PR，0次部署/TTS/媒体发布；本地文件与缓存保留。
EXECUTOR_RESULT: PASS_CANDIDATE（归档与交接限定范围）。
REVIEWER_DECISION: 初始main归档已验证PASS；本条及回执补充后再读main/ref及变更文件，才能结束本轮。影视视频/品牌定稿不在本PASS内。

## E008 2026-10-23 S1 风格候选制作（写前记录）

AUTHORIZED_GATE: FEL-S1-STYLE-20261023；Owner 要求后续压缩为风格定稿→单段测试→最终成品，不拆过多 Gate。
PREFLIGHT_FACTS: DIRECT_READBACK。GitHub canonical Governance v0.2.7 universal/11 trigger/12/13 已读取；项目 main head 为 8030270c82a05f4b36e32181feaa0dad5fef62c7，root tree 为 3d6db8304cdd85020a6bb84a154abf94a0e63b6a。原项目 G0/G1/G1C/G1D 状态和 Owner 形式纠正已核对。本轮专项触发均未命中实际执行：无宿主机/SSH/Secret、部署、真实自动化动作、付费 Provider、结项或 Codex 图像生成；HTML 用 CSS 抽象占位。
ACTUAL_CHANGES: S1 两套风格（A资料馆、B导演批注）离线预览 + 设计候选 + 三 Gate 方案，范围仅 film-expression-lab；更新 README/WEB_HANDOFF/Handoff/G2 的路由说明。
VALIDATION: 风格从旧灰框方案独立重新设计；正片无包装/暂停单点解读/回放撤标/源完整覆盖的规则分别核查；没有真实影视素材，也没有真实渲染。GitHub 最终提交 SHA 和读回验证由后续 E009 追加，不在此项提前声称完成。
ANOMALIES: 正式人声/影片内容版权与视频实际播放均不在本轮范围；当前正式名称、风格选择是 Owner 决策。
ROLLBACK_EFFECT: 纯本项目文本/HTML变更，可用正常前向回退提交；不改生产媒体、凭据或其他父仓库目录。
EXECUTOR_RESULT: S1候选稿由Reviewer直接制作；风格最终定稿等Owner选择，非 S1 终局 PASS。

## E009 2026-10-23 S1 候选远端验收回执

AUTHORIZED_GATE: FEL-S1-STYLE-20261023（仅候选制作与归档）。
PREFLIGHT_FACTS: base commit 8030270c82a05f4b36e32181feaa0dad5fef62c7；提交新 tree 0433d2a78c95d3a972f83edf743b0015a1df4686；非强制 fast-forward，expected_sha 与原 main 一致。
ACTUAL_CHANGES: Git commit 043773d0b12aedadf17bd7e8a8c68a5a313dad71；仅 film-expression-lab/ 下8项文本/HTML路径变更：EXECUTION_EVIDENCE.md、README.md、REVIEWER_HANDOFF.md、WEB_HANDOFF.md、gates/G2_TEST_VIDEO.md、gates/THREE_GATE_PLAN.md、style/STYLE_REVIEW.md、style/style-preview.html。
OBJECTIVE_READBACK: main ref 回读为 043773d0b12aedadf17bd7e8a8c68a5a313dad71；API commit 文件清单准确8项且全部在当前项目路径；五个关键文件按 commit SHA 读回，HTML 9646字节、风格候选1960字节、三Gate方案2416字节、Handoff及Evidence均存在。
VALIDATION: HEAD匹配、路径隔离、候选声明、style HTML 预设四状态、三Gate最终阶段、Handoff当前 Gate 与 E008 记录，八项远端检查全部为 true。HTML 仅静态源码与控件检查；浏览器渲染/画面听审仍 UNVERIFIED，不以此冒称真实观感 PASS。
ANOMALIES: 未能在 Reviewer 本次环境获得本机 GUI 的真实浏览器打开记录；设计待 Owner 选择。无实际影片/配音/渲染/公开发布。
ROLLBACK_EFFECT: 本项目文件的普通反向提交可以回滚；未改共享仓库的非目标文件，未强制改写历史。
REVIEWER_DECISION: S1 候选稿制作及 GitHub 归档 PASS；**S1 风格定稿仍 IN_PROGRESS，待 Owner 选 A/B**；S2 尚未激活。

## E010 2026-10-23 S1 旧章程路线对齐

AUTHORIZED_GATE: FEL-S1-STYLE-20261023，当前三Gate文档归一化修正，不扩张执行范围。
PREFLIGHT_FACTS: 远端 S1 候选及 E009 已回读；发现 PROJECT_CHARTER.md 的旧 G0→G6 路线仍可能让后续 Agent 错误拆 Gate。
ACTUAL_CHANGES: 仅更新 PROJECT_CHARTER.md 的“路线与出口”，保留长期交互页、稳定栏目为产品愿景，后续执行统一收敛为 S1风格→S2试产→S3成品。
OBJECTIVE_READBACK: 远端 commit 0f3d33cf97b181f73bdb827c7c5b90b7c1d72755 为 GitHub main；新 PROJECT_CHARTER.md blob 0954b8bdeb3dd786172c176468a46284d8bbac70，精确存在三个 Gate 路线，不再含旧“G3 根据真实测试修订模板”顺序。
VALIDATION: main ref 与目标commit一致，文件直接回读通过，未改代码/工具/其他项目；样板浏览器实际渲染与视频试产未在本轮测试。
ROLLBACK_EFFECT: 可通过项目范围普通前向修正撤销；无主机/媒体/Provider变更。
REVIEWER_DECISION: S1 设计候选制作及项目文档对齐完成，等待 Owner 确认风格；不宣布整阶段风格定稿。

## E011 2026-10-23 Owner正式命名与内存判断同步

AUTHORIZED_GATE: FEL-S1-STYLE-20261023中的有界Owner决定记录，不完成S1风格选择。
PREFLIGHT_FACTS: OWNER_REPORTED。Owner决定频道名称小克拉片、3GB为预计可用内存、内存不应阻断推进。GitHub main基线6c1de31a3b0e3354babfbdc5215f7405243059bf、tree 0442134853df1b47f3f169dcd7d512309190f64e；Reviewer已读取治理v0.2.7通用、全部专项触发器与12/13、当前Gate/Handoff/Evidence；本轮仅文档及HTML标题变更，非本机/Provider/Secret操作；资源专项11C和主机边界11B已读取，无其他专项实际触发。
ACTUAL_CHANGES: 统一章程、Handoff、三个阶段路线、S2 Gate、工具、品牌候选、网页交接、运营说明、执行提示词、README、旧格式修订的最新注释、HTML样板标题；追加DECISION_LOG D010。保留旧设计/既有Evidence历史，不替Owner选风格。
OBJECTIVE_READBACK: 远端commit/ref验证留待本轮E012追加，本条不宣称读回成功。
VALIDATION: 名称归为Owner已确认；视觉CANDIDATE未定；3GB是OWNER_REPORTED/UNVERIFIED，不作为硬上限、实测性能或豁免费用/权限/Secret审查；doctor单独内存警告不触发停工但真实OOM需定向处理。未做实际影视渲染。
ANOMALIES: 实际3GB峰值表现未知；无影视片源。
EVIDENCE_ARTIFACTS_AND_PURPOSE: D010为决策记录，当前Handoff与S2 Gate为操作入口，E011保存本轮变更事实。
ROLLBACK_EFFECT: 仅本项目文档/视觉预览标签可逆；不变更运行系统或其他项目。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: 0次配音、视频渲染/上传、公开发布；GitHub仅改动项目文档。
EXECUTOR_RESULT: Reviewer直接同步Owner决策，风格定稿仍待Owner选择。

## E012 2026-10-23 Owner决定GitHub读回核验

AUTHORIZED_GATE: FEL-S1-STYLE-20261023，跟进E011持久化核验。
PREFLIGHT_FACTS: 正式项目仓库entropy-student/project，main在提交前为6c1de31a3b0e3354babfbdc5215f7405243059bf，本轮只更新film-expression-lab目录，无本机Secret/运行服务调用。
ACTUAL_CHANGES: 提交6dd2aa444b8f118f31e03699b63a5a9a88be1d61包含14个项目文档/离线预览文件。本次再补TOOLCHAIN.md标题中的正式频道名称与本核验回执，其他目录不变。
OBJECTIVE_READBACK: GitHub main首轮提交读回为6dd2aa444b8f118f31e03699b63a5a9a88be1d61，commit清单14项全部在film-expression-lab/；README、Handoff、D010、G2、三Gate、风格候选、执行提示词、TOOLCHAIN及WEB_HANDOFF共9个关键文件按commit直接读回。Handoff显示频道名已确认；G2明确doctor单独内存告警不得RETURN；风格候选仍等待Owner选择。
VALIDATION: 原风格A/B、头像、封面、片头片尾等没有被Owner确认；3GB仅OWNER_REPORTED估算不作已验证最低要求。新改TOOLCHAIN及E012的最终GitHub读回在提交后验证。
ANOMALIES: TOOLCHAIN属于工具文件，初轮验收时不包含频道名称；本补丁标题补齐，非能力变化。S2真实渲染未验证。
ROLLBACK_EFFECT: 文档范围内可恢复，未修改父项目或运行环境。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: 0次真实渲染、TTS付费调用、账号操作或公开上传。
REVIEWER_DECISION: 已确认本轮名称与资源策略记录有效；S1风格仍IN_PROGRESS，S2未激活。

## E013 2026-10-23 S1六风格动态参考与生成提示词

AUTHORIZED_GATE: FEL-S1-STYLE-20261023。Owner要求六种风格各自参考视频、片头片尾拍法和16:9外部生成模型提示词，待选择后才调用生成。
PREFLIGHT_FACTS: GitHub main edc14cbe9f9ab36ddd6c4f1919cff1ca23341e08；当前治理v0.2.7 universal/11 triggers/12–13、当前Handoff/Gate已审阅。七专项逐项扫描：本轮仅外部公开参考检索和文档写入，无实际宿主机/SSH/Secret、部署、自动化、Provider收费、结项或图像生成。
ACTUAL_CHANGES: 新增style/INTRO_OUTRO_REFERENCE_RESEARCH_20261023.md（六套×2条真实在线视频参考及六套×片头片尾提示词），更新Handoff。形式为原创剪辑风格和镜头描述，不提供版权影视素材。
OBJECTIVE_READBACK: 远端提交与文件内容读回单列E014；不提前声称通过。
VALIDATION: 六组风格名称、十二个来源链接、十二条提示词，均含16:9/1920×1080及后期准确叠字指令。参考来源经站点检索/简介核验，完整视频并未逐帧观看；六种视觉依旧CANDIDATE。
ANOMALIES: 未确定视频生成供应商、模型、付费额度，也没有任何生成样片。无平台公开发布。
ROLLBACK_EFFECT: 项目文档可正常前向回退，不影响其他项目。
RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT: 0次视频生成、0次TTS、0次付费调用。
EXECUTOR_RESULT: Reviewer直接完成S1有界研究；风格最终选择仍待Owner。
