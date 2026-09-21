# Low-Level Execution Package v0.3

## 1. Purpose

本文件定义 Showrunner 交给 Antigravity 的**低层剪辑指令包**。

Antigravity 当前定位：

> **受限 Execution Agent，不是导演，不负责改编，不负责补故事，不负责重新设计镜头。**

它只执行：

1. 按指定 Prompt / Reference 批量生成图片；
2. 按指定时间码把图片放到时间线；
3. 按指定转场 / 字幕 / 音频规则合成；
4. 输出成片与执行结果。

如遇指令缺失、冲突或无法执行，必须 RETURN，不得自行发挥。

## 2. Production Model

Voice / Audio Master + Shot Timeline + One Shot ≈ One Image → Batch Image Generation → Exact Timeline Placement → Simple Cuts → Subtitle / Audio → Final Video

不把“镜头运动”默认交给视频模型。需要动作感时，优先用多张静态图表达状态 A → B → C。

Nano Banana 生图成本低，因此默认策略是：**优先增加图片数量降低执行复杂度，而不是为了节省图片强行复用一张图做复杂运动。**

## 2A. Upstream Source of Truth

This package consumes accepted outputs from:

- G4 Director / Shot Compiler;
- G5 Image Asset Package Compiler.

G4 decides what each Visual Beat means and when it appears.
G5 provides the exact image-generation row and reference package.

Antigravity must not reinterpret either layer.

Canonical visual baseline:
`docs/PRODUCTION_VISUAL_STYLE.md`

Canonical recurring-character identity:
`docs/CHARACTER_IDENTITY_LOCK.md`

## 3. Package Structure

- 00_EXECUTION_ORDER.md
- 01_SCRIPT.md
- 02_SUBTITLES.srt
- 03_AUDIO.*（AUDIO_MODE=A 时必有）
- 04_CHARACTER_BIBLE.md
- 05_SCENE_BIBLE.md
- 06_STYLE_BIBLE.md
- 07_SHOT_TIMELINE.csv
- 08_IMAGE_GENERATION.csv
- 09_EDIT_INSTRUCTIONS.md
- 10_OUTPUT_SPEC.md
- references/characters/
- references/scenes/
- references/props/
- references/style/

其中 `07_SHOT_TIMELINE.csv` 和 `08_IMAGE_GENERATION.csv` 是 Antigravity 最核心的施工文件。

## 4. Audio Mode — CURRENTLY OPEN

### AUDIO_MODE=A — Upstream Audio

上游先把锁定文案 / SRT 转成最终配音，再交给 Antigravity。Antigravity 不重写、不重新 TTS，以现成音频为唯一主时间轴。

### AUDIO_MODE=B — Executor TTS

Antigravity 使用 locked script / SRT 和指定 voice config 生成语音；生成后先锁最终音频长度，再严格按音频更新时间线。不得改字或自行增删停顿文案。

当前：`AUDIO_MODE = TBD`，等真实 Antigravity PoC 后再决定。

## 5. Character Consistency Contract

人物一致性必须由输入包解决，不能交给 Executor“尽量保持”。每个正式角色建立唯一 Character ID，例如 `CHAR_001`。

每个角色至少锁定：canonical front / 3/4 / side references、脸型、五官、发型/发色、年龄/成熟度、身材比例、固定服装、固定配饰、固定主色、禁止变化项、可变化的表情/姿势/朝向。

对 `CHAR_IP_001`：
- 必须明确读作成年青年男性；
- 不允许少年化 / 童颜化 / Q版化；
- 不允许放大眼睛、缩短圆化下颌、弱化鼻部结构；
- 不允许成人比例被缩成少年/吉祥物比例；
- 不允许酒红色米白领上衣被 hoodie 等其他服装替换。

风格简化只能减少绘制细节，不能简化身份解剖。

任何包含该角色的新图：

1. 必须引用同一个 Character ID；
2. 必须携带 canonical reference image；
3. Prompt 必须复述 identity lock；
4. 连续镜头可再附上一张上一镜通过图作为 continuity reference；
5. `DERIVE_EDIT` 仍必须携带 canonical identity reference，source frame 不可单独作为人物真源；
6. 若上一张已发生年龄/脸型/服装漂移，不得继续派生，必须回到最近一张通过图；
7. 不允许 Executor 自己重新设计人物。

身份漂移：`RETURN_CHARACTER_DRIFT`，不得继续剪辑。

## 6. Scene Consistency Contract

重复场景建立 Scene ID，例如 `SCENE_HOME_001`。每个场景锁定空间布局、主要摄像机方向、墙面/地面、核心家具、道具、时间/光线、色调、可变化项和禁止变化项。

同一场景不同镜头优先引用 Scene canonical reference；需要时再附前一张通过图作为 continuity reference。

## 7. Shot Timeline — One Row = One Shot

默认：**一个小镜头一张图。** 不为了节约图片，把多个明显视觉状态塞进一张图。

推荐字段：

| Field | Meaning |
|---|---|
| shot_id | 唯一镜头编号 |
| start | 精确开始时间 |
| end | 精确结束时间 |
| duration | 时长 |
| narration | 对应口播 |
| character_ids | 出镜角色 |
| scene_id | 场景 |
| action | 这一镜发生什么 |
| expression | 表情 |
| composition | 景别/构图 |
| camera_angle | 角度 |
| image_id | 使用的图片 |
| transition_in | 进入方式 |
| transition_out | 离开方式 |
| subtitle | 对应字幕 |
| notes | 禁止项/注意项 |

Antigravity 不自行改 start/end。若最终音频改变导致时间轴不匹配：`RETURN_TIMELINE_MISMATCH`，由上游重新编译 Shot Timeline。

## 8. Image Generation Sheet

每一张待生成图片单独一行。最低字段：

| Field | Meaning |
|---|---|
| image_id | 唯一图片编号 |
| shot_id | 服务哪个镜头 |
| execution_mode | GENERATE / DERIVE_EDIT / COMPOSITE_CROP |
| prompt | GENERATE 时的完整最终 Prompt |
| source_frame_ref | DERIVE_EDIT 的已通过源图 |
| identity_lock | 人物身份/成熟度/服装 Hard Lock |
| negative_constraints | 禁止项 |
| character_refs | 人物参考图 |
| scene_refs | 场景参考图 |
| prop_ui_refs | 道具/UI/文档参考 |
| style_refs | 风格参考 |
| continuity_ref | 上一镜参考 |
| aspect_ratio | 比例 |
| resolution | 分辨率 |
| text_render_mode | NONE / IMAGE_NATIVE / POST_OVERLAY |
| output_name | 文件名 |
| acceptance | 验收条件 |

Prompt / Edit 指令必须是可直接执行版本。Antigravity 不负责改 Prompt、补美术方向、猜角色身份、猜场景或猜构图。

Owner image-production policy:
- 人物 / 场景 / UI / 表格 / 证据页的视觉资产仍以生图/图像编辑模型为主；
- `COMPOSITE_CROP` 只裁切/组合已经通过 QA 的图像源；
- 不把 HTML / SVG / Pillow 等代码绘制 UI/表格作为当前默认生产路径；
- exact text 仍可按 `POST_OVERLAY` 规则后期覆盖。

## 9. Motion Policy

默认只允许简单编辑：hard cut、明确指定时 dissolve、simple hold、以及只有指令明确时的固定 zoom/pan。

但默认优先用多张图片表达状态变化。例如 3 秒内“坐着 → 抬头 → 震惊”，拆成三个 shot、三张图，而不是要求一个复杂动画镜头。

## 10. Edit Instructions

编辑指令必须显式指定：timeline resolution/fps、每张图起止时间、cut/transition、音频位置、字幕轨、字幕样式、BGM/SFX（如有）、黑场/停顿（如有）、export spec。

没有写的效果默认：`DO_NOT_ADD`。宁可简单，不允许 Executor 自己加“高级感”。

## 11. Executor Freedom = Near Zero

Antigravity 只可自行决定不改变结果的工具操作细节，以及 API/UI 技术错误时的等价重试。

它无权自行：改故事、改文案、改字幕、改镜头数量、合并镜头、调整镜头时间、改角色、改场景、改 Prompt、加运镜、加转场、加 BGM/SFX、改视频比例、删除图片。

任何 contract 无法执行：`RETURN_EXECUTION_CONTRACT_UNRESOLVED`。

## 12. Output

最低交付：`final_video.mp4`、`generated_images/`、`execution_result.md`。

`execution_result.md` 至少记录：成功/失败图片数、retry、每个 shot 实际 image_id、timeline 是否匹配、音频模式、export 参数、未执行项、RETURN / PASS_CANDIDATE。

## 13. Current Principle

> **上游思考尽可能充分，下游执行尽可能愚蠢。**

Showrunner 把导演决策编译成低层施工指令；Antigravity 按单施工。

目标不是复杂视频，而是：角色稳定、场景稳定、时间可控、结果可复现、失败容易定位；生图便宜时直接用更多图换取更低的剪辑复杂度。