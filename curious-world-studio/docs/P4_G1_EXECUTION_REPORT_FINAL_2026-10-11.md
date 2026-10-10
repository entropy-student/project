# P4-G1 本机执行报告（续跑）— 2026-10-11

**结果：G1_CONDITIONAL / NOT PASS。** 已产出真实 MP4、SRT、时间轴、权利账本、ffprobe 与关键帧；规格和部分机器 QA 通过。但 Fig. 8 底部证据被字幕遮挡、渲染音轨未完成真人试听，且 Remotion 未经预检查自动下载 Chrome Headless Shell，违反本轮“不安装/下载新运行时”的边界。不得把本次称为 G1_TECH_PASS。

## 运行来源与输入

- GitHub main 的只读 checkout：entropy-student/project commit dfe2e0708f36bf5b8849a85ecfc89b7cdd8192f7；使用其 curious-world-studio/p4-g1 工程与脚本。源码 checkout 的 git status --short 为空。
- 原工作区：C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c。
- 下载目录最新且唯一的字幕导出：C:\Users\34707\Downloads\captions.reviewed.json。复制到工作区 captions.reviewed.json，复制前后 SHA-256 相同：0f5ff266f8fedf53dcdfa6c37401eaeadd338387e9d54dce0ab291bb5deefe09。
- 字幕文件级状态 REVIEWED、human_reviewed=true、8 条字幕；记录的方法为 human_audio_listening_with_waveform_assist。未修改导出、未补写听审字段。
- 字幕文本按顺序拼接与当前 main 的 fixture_script.txt 精确一致；剧本 SHA-256 2a336893b0c17e795ab9dae7434c954d2ea1fe637c8c0a7a9fd36b5a1e27cbaa。
- narration WAV SHA-256 72cf2cf8982af5e23bfa82ba74eb3f987fc847f0efe25789a846d85b6059de0f，与听审文件及 Composer staging 中复制的 WAV 一致；PCM mono、16-bit、22,050 Hz、493,826 samples、22.3957 秒。没有重录或重新下载音频。
- 8 条时间码均为正数、递增、非重叠、在 WAV 范围内；C003/C004 在 8260 ms 相接，C006/C007 之间有 80 ms 间隔。最长字幕 17 字符（门禁上限 25），均无换行。最后结束时间 21,630 ms，短于音轨 22,395.7 ms。
- 复用 Fig. 7/8 与 rights.reviewed.json，未重新下载。两图 SHA-256 分别为：
  - Fig. 7：3bd76561dc2674cb3506627696ed62a81b89ce7ff69d093110601b9388f2555d
  - Fig. 8：80af1515e6b4e5dfa1dce0065929a424620d7aed3666b96a16c246f505749dbc
  A001/A002 的 link_found=LINK_FOUND、content_verified=CONTENT_VERIFIED、reuse_rights_verified=REUSE_RIGHTS_VERIFIED，账本引用 CC BY 4.0 署名。范围仅覆盖论文原始图像的私有 G1 样片；未使用或下载 PLOS 补充实验视频。

## 执行记录

1. 运行前确认工作区 out 不存在，OpenMontage Composer 的 projects/cws-g1 与 public/cws-g1 均不存在。
2. 将最终听审 JSON 原样复制入工作区并核对 SHA。
3. 只执行一次 main 内的 scripts/render_windows.ps1 -PilotRoot <main checkout>\curious-world-studio\p4-g1 -Work <原工作区>；没有预先单跑 build_g1.py。脚本门禁输出：8 captions、2 rights-verified assets、音轨 22,396 ms、726 帧。
4. Remotion 4.0.484 完成 CWSG1 H.264 渲染，编码器报告 Rendered 726/726。中止信号发出时渲染已完成，最终文件随后由 ffprobe/FFmpeg 正常解码。
5. 未修改 main 工程脚本、OpenMontage Composer 源码或其配置；没有调用云模型、付费 TTS 或安装包管理器。

## 真实产物

工作目录：C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out

| 文件 | 位置 | SHA-256 / 结果 |
|---|---|---|
| MP4 | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\g1-j-b-preview.mp4 | 014fc85ecff6d5b576e852f77b7daeb710360204a2481f02e4bd032a195dcc18；2,029,995 bytes |
| SRT | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\subtitles.srt | 311a3a6d5840d3d77167ee7e0ae46abf0d6d6d6c68ae159a069ec7668eadb7d3 |
| 时间轴 | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\episode_timeline.json | f452d595bcd618e10878d6d0d7c6ed0538e55998b77f5eb5c974a94bbec507d5 |
| 权利账本 | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\rights_ledger.json | 6eb37df254ab9b5bf7afd75a386748914a66b9a424cda02f26aadab40861741f |
| ffprobe | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\ffprobe.json | 5e0cd6daf3bf1da0591aca48bc679b9e24af4f6a662e681db6195fa0515ee453 |
| A 桌面关键帧 | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\frame-A.png | 92c8c78bfe51035d2e3074f77293b69516bc18fbcf7e879f4076819fece2d11f |
| B / 08 秒关键帧 | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\frame-B-08.png | 98bc340f31a4bbb48f3ba98c30bf0b473b147fe3af4dd9b9c2977582c5b2a631 |
| B / 18 秒关键帧 | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\frame-B-18.png | 03f9961625afc489c24a8a6c43eafec7856350c97c7738268f0f1b748dbe4319 |
| C005 额外画面抽检 | C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\out\frame-QA-C005.png | 1,155,948 bytes |

## QA 结果

| 检查 | 结果 | 证据 |
|---|---|---|
| 实际视频存在且可解码 | PASS | H.264；2,029,995 bytes；Rendered 726/726；ffprobe/FFmpeg 解码全程返回 0。 |
| 视频规格 | PASS | 视频流 1920×1080、30/1 fps、24.200 s、726/726 帧；16:9。 |
| 音频流 | CONDITIONAL | AAC-LC、48 kHz、双声道；MP4 音轨时长 24.256 s（AAC 尾部/封装长度，比视频流多 56 ms）。音轨静音检测首段至 1.981 s；末段有声至约 23.447 s。SRT 统一加 1800 ms，来源 WAV 在 Composer staging 中 SHA 一致。音轨 PCM 交叉相关尝试的最高值只有 0.080（约 1835 ms 偏移），不作为成功证明；缺少对最终 MP4 的真人完整试听，真实听审验收未通过。 |
| 黑帧 / 解码连续性 | PASS（机器） | FFmpeg blackdetect=d:0.05、pix_th=0.10 未报黑段；ffprobe 读到 726/726 帧。 |
| A/B / STYLE_LOCK | CONDITIONAL | A 为 1.8 s Aqua 桌面；B 为满宽 QuickTime-style 研究播放器；13.0 s 硬切 Fig. 7→Fig. 8；没有 C 状态；图像按 contain 呈现。三张任务要求关键帧及 C005 抽检已实际查看。 |
| 单行 / 无高亮 | PASS（静帧） | SRT 8 cues；8 条均一行且长度门禁通过；Remotion 组件用 white-space:nowrap，未发现逐词高亮。 |
| 论文图完整可读 | FAIL | Fig. 7 画面完整。Fig. 8 纵向占满播放器区域，底行面板标记/图注被字幕黑底遮住；C005 抽检也覆盖论文图底部。图没有裁剪，但关键内容被字幕覆盖，不能判为完整可读。 |
| 音画 / 人工视听 | INCOMPLETE | A-prefix / 音轨起点 / SRT 时间均使用 1800 ms 单次偏移；活动音段与字幕边界大致吻合。模型可视检查限于所列抽帧；最终 MP4 已在 Codex 预览中排队，但此运行环境未提供可审计的真人耳听结果。Owner 对精确 WAV 的听审标记可信地保留为 REVIEWED，不能替代成片 AAC 的独立试听。 |

## 约束偏差与副作用

- **未经批准的浏览器下载（重要）：**Remotion 发现可执行渲染浏览器缺失后，自动从 Remotion/Google Chrome 下载 chrome-headless-shell 149.0.7790.0。日志显示压缩包 113.3 MB；解压后生成 291 个文件，共 282,143,443 bytes，路径为：  
  C:\Users\34707\Tools\OpenMontage\remotion-composer\node_modules\.remotion\chrome-headless-shell  
  这是本轮未授权的新增运行时下载，违反“不安装/下载新运行时”约束。我在发现后发出中断信号，但渲染在信号到达前完成。清理该目录的递归删除命令被工具策略拒绝；**该缓存目前仍保留**。没有继续调用它，也没有更改工具配置。请将其视为待人工清理项。
- 本轮新建的 OpenMontage staging 保留（按任务书不自动删除）：  
  C:\Users\34707\Tools\OpenMontage\remotion-composer\projects\cws-g1  
  C:\Users\34707\Tools\OpenMontage\remotion-composer\public\cws-g1
- G1 out、最终听审字幕副本和额外 C005 QA 抽帧均在原临时工作区。Figures/WAV 复用既有副本。GitHub main checkout 没有源文件改动；未发布 MP4 或本机媒资。
- 因 staging 与 out 已由本轮生成而存在，按任务书不能安全覆盖重渲染；未尝试第二次构建或渲染。

## 未解决事项与验收结论

1. 应在人工协调后重新排版 Fig. 8 的字幕安全区，使整张证据图完整可读；随后需用新隔离输出/经人工协调的 staging 路径渲染，不覆盖现有证据。
2. 需要在本机实际播放并完整试听 MP4，确认普通话清晰、音画对齐和尾部；当前环境没有真人试听证据。
3. Remotion 自动下载的浏览器缓存仍位于上列路径；需人工清理或明确后续授权使用。不能把它描述成“未下载”。
4. 本报告不授权发布、商用或 G2/G3，也不代表 STORY-FIT GO、永久素材复用权或生产就绪。

**最终验收：G1_CONDITIONAL / G1_NOT_PASS。** 虽有真实 24.2 秒 MP4 与机器证据，视觉遮挡、成片试听缺口和越界下载均未解决；不宣布 G1 PASS，停止于 G1。