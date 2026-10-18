# CWS｜C类AI生图：复用与低浪费执行技巧（2026-10-16）

<!-- CWS_IMAGEGEN_HIGHEST_PROJECT_PRIORITY_20261018 -->
> **【Owner最新决策，2026-10-18：项目级最高优先执行准则之一 / MANDATORY】** 此文档原为“实施参考”，现提升为**CWS所有获授权AI静态生图任务的项目级强制执行规则**，适用于CW0005及后续各题/每轮Gate。顺位：明确Owner决定与仓库权威`vps-project-governance/VNEXT.md`优先于本项目准则；本准则约束CWS生图策略、预算/素材复用与证据，**不修改跨项目Governance、不自动授权无Gate生图/付费/发布**。遇到现行Gate写法较旧的“推荐/可参考”，一律由本条强制流程补齐。原指南下文历史“本轮不授权生图”指2026-10-16的旧阶段，**不能否认2026-10-18已经单独由Owner授权的返修Gate**。

## 最高优先强制准则：在科学准确前提下以最少调用完成最快合格图

对每一个候选C类静态图片，Reviewer或已授权Gate**先锁定具体画面任务**（`beat_id`、需要看见的物理状态、透视/画幅、已知科学依据、禁止误导、输出用途）；Executor只执行任务，不自行发明额外图片或为生图改旁白。优先级依次为：

1. **先查CWS已有图片和已审核完整图/目录；实际打开候选核对画面、物理机制、授权与可读性。** 可完全适配则`EXACT_FRAME`零生成；可保留POV/主体几何、只需一处主要状态变化则`DERIVE_EDIT`；仅作为构图参考记`REFERENCE`（仍计新生成）；不合用才`GENERATE`。不许为了省调用将科学错误图片硬凑进镜头。**不得把已用视频的“全项目一次性禁复用”规则错误应用到静态图片**。
2. **先最小化图数，再最小化生成次数。** 对S04–S06评估能否用已有许可图或兼容编辑覆盖“形成→受压→回弹”，实际需要1/2/3张就做1/2/3张，不为了配额固定生成3张；多状态须在视觉上真正区分。批准范围内先一次批量编译所有不可复用图的完整任务要求，减少边生成边改意图导致返工。
3. **调用路径必须复用`spike.skill/comic-narrative/tools/imagegen-fast-path`已验收实现**，不新造缓存扫描脚本/图片传输协议：`imagegen -> 官方output_hint -> consume_output_hint.ps1 -> official_hint_parser.ps1 -> 明确SourcePath -> local_copy.ps1 -> hash/尺寸/视觉QA`。当前本机版本需在执行前做**只读接口/路径/兼容预检**；如源版本接口发生实际漂移，以最小兼容修复和有界零图片夹具校验为先，**不为验证流程额外生成试验图片**，不能直接把原项目PASS冒称CWS已验证。
4. **并发最多2**；对2张及以上独立任务采用2路流水并行，某一路进入保存/QA就可填充下一个任务；单张图只执行1路，**不要为了“双并发”制造不必要第二张图**。不运行3路或以上；不以并发数推断单张模型Token降低。
5. **输出只能用真实官方hint获得的路径**，源/目标sha256验证一致并检查文件存在、可解码、实际尺寸与科学含义；既定输出目录`<run_root>/outputs/<task_id>/<task_id>.png`、QA记录位于`<run_root>/qa/`。禁止通过stdin/TTY/base64在会话中搬运大图，禁止扫描cache按“最新生成文件”猜素材来源。目标成片1920×1080，不要求原生PNG精确1920×1080；宽高或比例/可读性真正不合格才修订，**不得仅因native像素不匹配重生**。
6. **每张图先QA，再决定重试**：重点查“是否画成蒸汽火箭喷射”“形成/压缩/回弹有无物理区分”“是否冒充研究录像/论文原图”“16:9裁切/字幕安全区/文字伪造”。失败记录具体原因，同类失败2次停止该策略、RETURN给Reviewer；不能无限换prompt/重复付费。仅真正合格图才登记到可复用索引；失败版与替代版保留执行溯源但不算正式素材。
7. **逐图登记可核验节省与效率数据**：`beat_id, mode, existing_asset_id, reuse_reason, generated_call_count, edit_call_count, retry_count, concurrency_peak, provider/model_if_known, output_hint_seen, source_path_verified, source_sha256, output_sha256, native_dimensions, QA_status, estimated_or_verified_cost(if_available), elapsed(if_measured)`；生成量=0时也记录`NO_MODEL_CALL`。区分`EXECUTOR_REPORTED`与Reviewer直接验证。没有真实Token账单/独立基线时写`TOKEN_SAVING_NOT_MEASURED`，**禁止宣称绝对最快、最低Token或虚构节省百分比**。
8. **有界授权**：图片生成/编辑不得擅自升级付费模型、超过本期许可数量或输出给公开视频；任何额外付费/材料授权/发布需相应Owner权限。整个项目的成功标准仍是**最少不必要调用、最小等待和可复现QA，同时科学/视觉品质达标**。

**适用读入**：所有CWS Gate涉及C类图像时，`REVIEWER_TO_EXECUTOR_RELAY`必须显式指向**本文件顶部最新强制规则**，并随Gate保留项目原有其他视觉真实性与版权约束。源技术规则的权威取自上位`VNEXT.md §11G`，具体平台Fast Path可用性须检查而不得猜测。


> **用途**：已确认的CWS C类「AI生成静态图片」执行准备参考；不增加素材分类，不扩展13种MW模板，也不授权本轮实际生图、付费、正式R4或发布。**源项目已验收 ≠ CWS集成已验收**。没有经核对的逐图Token/价格基准，不能称「实测最低Token」。

## 1. 生成前先省掉不必要的调用（最重要）

每一个已冻结的视觉节拍，**先明确观众需要看见什么**（事件、物理状态、POV、图解重点、字幕的对应对象）；不为配合现有图片或省钱修改原文案。优先查询已验收**完整图片**库，仅打开相关候选，检查实际画面和文件、hash、可用范围及授权：

1. **直接复用 EXACT_FRAME**：构图、状态、必要物理事实与该节拍一致时直接使用已有完整图，生成调用=0；不是只看标签/关键词相似。此规则适用于静态图，不放宽「原始视频项目级只用一次」。
2. **单图衍生编辑 DERIVE_EDIT**：找一张已验收、POV、主体几何与布局都兼容的完整底图，仅明确**一个主要状态变化**，写清保持不变部分，减少重绘与身份漂移；旧图与目标不兼容时不能硬凑。编辑依然可能实际产生模型调用，**不等于零成本**。
3. **仅参考 REFERENCE**：旧图只为构图、人物/物体连续性或风格提供有限参考，真正输出仍是新图，**不能误记为免费复用**。
4. **全新 GENERATE**：没有兼容已验收图时才生成；先统一16:9和最终展示需求，集中编译同一批节拍的提示词、参考图、物理事实、禁止内容及输出路径，避免多轮边聊边修改提示词与重复调用。

相关已验收来源：[Part4.5 图片库与复用](https://github.com/entropy-student/spike.skill/blob/main/comic-narrative/part4_5/ASSET_REUSE_LIBRARY.md)；[Part4 图片执行合同](https://github.com/entropy-student/spike.skill/blob/main/comic-narrative/part4/IMAGE_ASSET_EXECUTION.md)。

## 2. 复用既有快速生图执行器（不得在CWS重新发明）

**源项目已封板验证的技术路径**（Windows Codex内置imagegen）：

```text
生成任务 → 两任务并行提交（不擅自升至3+）
→ imagegen返回官方 output_hint
→ consume_output_hint.ps1 → official_hint_parser.ps1
→ 精确的 SourcePath（.codex/generated_images 下）
→ local_copy.ps1 复制到 <run_root>/outputs/<task_id>/<task_id>.png
→ 源/目标 SHA-256、图像实际尺寸和视觉事实 QA
→ 登记结果/参考素材，下一次可检索
```

- **并发=2**是源项目确实测试过的上限/默认，不把它误称单图Token更少。新环境先做兼容性预检与小范围验收；不要无Owner授权运行新模型测试。
- **直接使用返回路径**，不把整张PNG变成base64/TTY/stdin消息来回传递；也不大范围扫描缓存并凭修改时间猜哪张是新图。路径解析必须来自真实官方output_hint，若返回格式漂移，先暂停解析并修复预检。
- **不因原生像素未恰好等于1920×1080就重生**：源项目以16:9构图、1920×1080最终画布为目标，但native pixel target = NONE。真正失败应来自内容、方向/比例、清晰度不足或QA缺陷，而不是原生像素数值差异本身。
- **保存与核查可复用**：固定任务ID→图片路径、hash、尺寸、内容/状态、来源、审核状态；每次只保存一份可信成品，失败版不得偷偷进入可复用库。避免将无意义的多次尝试算作素材资产。
- **最小可用记录**：`beat_id / mode / refs / prompt_or_edit / preserved / forbidden / source_path / output_path / sha256 / native_size / qa / failure_reason`；源文件路径必须取自本轮真实返回，不能从历史示例猜测。

经过Reviewer审核：[fast-path复用脚本/规范](https://github.com/entropy-student/spike.skill/blob/main/comic-narrative/tools/imagegen-fast-path/README.md)、[双并发真实调用验收](https://github.com/entropy-student/spike.skill/blob/main/comic-narrative/reviews/imagegen-speed/IMAGEGEN_OFFICIAL_HINT_PARSER_TWO_CONCURRENT_LIVE_CANARY_R2R1V_REVIEW.md)、[完整执行可靠性封板](https://github.com/entropy-student/spike.skill/blob/main/comic-narrative/reviews/imagegen-speed/IMAGEGEN_SYNTHETIC_SOURCE_CLEANUP_CLOSEOUT_R2R2R3_REVIEW.md)。

## 3. CWS接入约束

- 新分类仍只有**A素材视频 / B已有素材图片 / C AI生图**；不因衍生编辑、参考图、复合画面而增设D/E/F。13种MW动作仅是后期呈现/窗口操作。
- **C图须科学事实正确且显著标明「AI示意」**，不能作为原论文的摄影证据、不能制造仿真的研究实验录像；AI生视频仍禁止。C类图确实需要时可用，不能为了省生成调用使用错误旧图。
- **实际使用有界授权**：检查CWS制作Gate/成本、图像来源与权利、输出目标和当前本机环境，才可迁移脚本、实际生图或正式渲染。当前只是对成功经验的归档/复用建议。
- **成本指标分开**：直接复用通常减少调用次数；编辑可能降低返工但也消耗调用；双并发减少排队耗时；路径直存减少传输/解析成本；避免无谓尺寸重试可减少生成次数。**这些与模型实际Token计费不是同一数据，没有证据就不写「节省X% Token」**。

> **来源版本**：`entropy-student/spike.skill/main` 于2026-10-16读回 `16e33384dc569629a1527d1c9ec0060823af09ce`；迁移时需以当时实际版本重新核对接口，无需重播源项目已正式验收的历史长链。
