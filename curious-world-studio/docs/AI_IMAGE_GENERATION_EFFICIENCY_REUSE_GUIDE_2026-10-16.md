# CWS｜C类AI生图：复用与低浪费执行技巧（2026-10-16）

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
