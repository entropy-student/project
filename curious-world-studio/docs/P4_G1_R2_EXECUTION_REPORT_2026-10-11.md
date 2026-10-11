# P4-G1-R2 本机执行报告 — 2026-10-11

**结论：`G1_CONDITIONAL / NOT_PASS`。** R2 实际 MP4 已渲染，机器 QA 与静帧视觉检查通过，Fig. 8 字幕遮挡已修复，音轨与 WAV 的相关性检查无累积漂移。最终 MP4 尚无完整真人播放/试听证据；本会话明确不支持音频输入，不能把机器波形比对或字幕源 WAV 的听审记录冒充为最终成片的真人试听，因此未通过最终 G1 验收，也不进入 G2。

## 1. 主线版本与本轮范围

- GitHub 最新 `main`：`entropy-student/project` commit `a839767ddd55119b805e1a6af170b9c4aa1cfc78`。
- 按任务书完整读取：`curious-world-studio/docs/CURRENT_STATE.md`、`P4_G1_EXECUTION_REPORT_FINAL_2026-10-11.md`、`P4_G1_REVIEW_POST_RENDER_AND_R2_PLAN_2026-10-11.md`、`p4-g1/LOCAL_CODEX_G1_TASK.md`、`p4-g1/LOCAL_CODEX_G1_R2_TASK_2026-10-11.md`、`scripts/render_windows.ps1`、`scripts/build_g1.py`、`remotion/ResearchEpisode.tsx`。
- R2 repo checkout：`C:\Users\34707\AppData\Local\Temp\cws-g1-r2-20261011-0e139b0d\repo`；`git status --short` 为空。没有修改或提交 GitHub 工程。
- R2 工作区：`C:\Users\34707\AppData\Local\Temp\cws-g1-r2-20261011-0e139b0d\work`。与 R1 隔离，未复制旧 `out`。
- 仅为本次 R2 私有复渲复用已授权缓存；没有安装/升级软件、下载浏览器或论文素材、调用云模型/TTS、改工具配置、改系统/网络设置或启动 G2。

## 2. 浏览器与渲染运行时 preflight

- 仅在授权缓存目录 `C:\Users\34707\Tools\OpenMontage\remotion-composer\node_modules\.remotion\chrome-headless-shell` 内查找，恰好找到 **1** 个 `chrome-headless-shell.exe`。
- 实际路径：`C:\Users\34707\Tools\OpenMontage\remotion-composer\node_modules\.remotion\chrome-headless-shell\win64\chrome-headless-shell-win64\chrome-headless-shell.exe`。
- `--version`：`Google Chrome for Testing 149.0.7790.0`。
- EXE SHA-256：`ec76dc3e69ffab9daddf0bbe7bf0a9e0a034b2d086741a0ae2ef6358a597537b`。渲染后复核 SHA 相同；未触发浏览器下载/解压/升级。
- 已有 Remotion / CLI：`4.0.484 / 4.0.484`；使用 `C:\Users\34707\Tools\OpenMontage\remotion-composer\node_modules\.bin\remotion.cmd`，未用 `npx`。
- 浏览器信息及显式参数证据：`out\browser_runtime_preflight.json`。

## 3. 输入复用与审核门禁

从 R1 `C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c` 原样复制至 R2 工作区；各 SHA 与任务书记录完全一致：

| R2 输入 | SHA-256 | 核验 |
|---|---|---|
| `assets/fig07.png` | `3bd76561dc2674cb3506627696ed62a81b89ce7ff69d093110601b9388f2555d` | 内容为论文原 Fig. 7，未缩放替代、未重下 |
| `assets/fig08.png` | `80af1515e6b4e5dfa1dce0065929a424620d7aed3666b96a16c246f505749dbc` | 内容为论文原 Fig. 8，未缩放替代、未重下 |
| `audio/narration.wav` | `72cf2cf8982af5e23bfa82ba74eb3f987fc847f0efe25789a846d85b6059de0f` | 原 PCM 单声道 16-bit / 22,050 Hz / 493,826 samples，未重录 |
| `captions.reviewed.json` | `0f5ff266f8fedf53dcdfa6c37401eaeadd338387e9d54dce0ab291bb5deefe09` | 原样复制，未改文本或时间码 |
| `rights.reviewed.json` | `93606d4444dc961f42aa341023bbce5944cf441e9ee7ba3835e9980fe23d938d` | 原样复制，未改权利审核状态 |

字幕 JSON 的**文件级**状态为 `REVIEWED`、`human_reviewed=true`，方法 `human_audio_listening_with_waveform_assist`；其 notes 明确记载操作员逐一听审并确认全部 8 个字幕边界与精确 WAV 相符。八个 caption 对象本身没有独立 `status` / `human_reviewed` 字段；未伪造逐条字段。剧本 stripped UTF-8 SHA 为 `2a336893b0c17e795ab9dae7434c954d2ea1fe637c8c0a7a9fd36b5a1e27cbaa`，与审核 JSON、最新 main 的剧本文本一致；音轨 SHA 同样匹配。

独立重核：8 条时间有效、顺序递增、无重叠、均在 WAV 时长范围内；最长 17 字、全部单行。源图权利记录 A001/A002 均为 `LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED`，SHA 对应原图；输出账本保留 CC BY 4.0 署名与限于私有 G1 样片的范围。

## 4. 单次渲染与实际产物

运行前确认新 `work\out` 不存在，Composer 的 `projects\cws-g1-r2` 和 `public\cws-g1-r2` 均不存在。随后**仅运行一次** main 中 `scripts\render_windows.ps1`，参数为：

```text
-PilotRoot C:\Users\34707\AppData\Local\Temp\cws-g1-r2-20261011-0e139b0d\repo\curious-world-studio\p4-g1
-Work C:\Users\34707\AppData\Local\Temp\cws-g1-r2-20261011-0e139b0d\work
-StageSlug cws-g1-r2
-BrowserExecutable C:\Users\34707\Tools\OpenMontage\remotion-composer\node_modules\.remotion\chrome-headless-shell\win64\chrome-headless-shell-win64\chrome-headless-shell.exe
```

脚本内部调用 `build_g1.py`；未提前单独构建。Gate 报告 8 captions、2 个权利审核素材、WAV 22,396 ms、726 frames。Remotion 使用显式 `--browser-executable` 参数，日志显示 `Rendered 726/726` 及 `Encoded 726/726`，未自动换 Edge 或尝试下载浏览器。

- **MP4：** `C:\Users\34707\AppData\Local\Temp\cws-g1-r2-20261011-0e139b0d\work\out\g1-j-b-preview.mp4`
- 大小：1,932,808 bytes；SHA-256：`6ced6981f3bcdcecbc362b729aafd4b8dff6a99740fb26855aa9e872bf8cc0a6`
- 同目录包含 `subtitles.srt`、`episode_timeline.json`、`rights_ledger.json`、`ffprobe.json`、`browser_runtime_preflight.json` 与关键帧。

## 5. QA 结果

| 检查 | 结果 | 证据 / 限制 |
|---|---|---|
| 容器与画面规格 | PASS | FFprobe：H.264 High，1920×1080，30/1 fps，24.200 s，726 frames。 |
| 音频轨 | PASS（机器） | AAC-LC，48 kHz，双声道，24.256 s；末端 AAC/封装尾长 56 ms。 |
| 全片解码 | PASS（机器） | FFmpeg 全片解码返回 0；`nb_read_frames=726`。 |
| 黑帧 | PASS（机器） | `blackdetect=d=0.05:pix_th=0.10` 未检出黑段。 |
| A/B 与时长 | PASS（静帧/时间轴） | 1.8 s Aqua Finder A 开场，之后 QuickTime-style B；无 C；Fig. 7 于 13.0 s 切到 Fig. 8；24.2 s 总长。 |
| 字幕 | PASS（机器/静帧） | 8 条 SRT，单行、序号和区间有效，统一 `+1800 ms`；静帧未见逐词高亮。C003/C004 衔接仍为审核时间码。 |
| Fig. 8 遮挡 | PASS（静帧检查） | R1 的 `frame-QA-C005.png` 中字幕底板压住 Fig. 8 底行；R2 C005（13.5 s）、C006（18 s）、C007（20 s）、C008（22 s）抽帧均显示六个面板、底行标记/时间证据完整可见，字幕位于其下固定轨道，不相交。 |
| Fig. 7 可读 | PASS（静帧检查，有限） | 1920×1080 的 B/08 全图完整；另将实际帧等比例缩至 360 px 手机宽度，三幅照片和 `15/36/76 s` 时间点仍能辨识。手机帧只是缩放 QA 静帧，不是实机播放；更细微纸面细节在手机尺寸自然变小。 |
| 音画同步 | PASS（机器相关性） | 对源 WAV 与最终 AAC 解码 PCM 做 7 个两秒窗口互相关，原音轨 1/4/7/10/13/16/19 s 窗均测得总起点偏移 `+1.84268 s`；相对设计 `+1.800 s` 多 `42.68 ms`。相关系数 `0.99699–0.99853`，测试窗口无累积漂移。此结果不等于主观听审。 |
| 语音末端 / SRT | PASS（机器信号） | `silencedetect -45 dB, 0.2 s`：最终音频末段静音自约 23.447 s 起；最后字幕止于 23.430 s；约 0.81 s 静音尾，无机器可见截断。 |
| 最终 MP4 完整真人播放/试听 | **INCOMPLETE** | 当前 Codex 会话拒绝音频输入（提示 `audio content omitted because you do not support audio input`）；因此不能评普通话自然度、音质、实际听感或真人全片听审。最终 MP4 已请求在 Codex 面板打开（状态 `queued`），但没有证据显示 Owner 已实际完整播放/试听。此项为 G1 最终验收阻塞。 |

机器/静帧 QA 关键帧：`frame-A.png`、`frame-B-08.png`、`frame-B-18.png`、`frame-QA-C005-Fig8.png`、`frame-QA-C006.png`、`frame-QA-C007.png`、`frame-QA-C008.png`、`frame-B-08-mobile-360.png`。C006 抽帧与 18 s 关键帧落在同一画面，SHA 相同。

## 6. 重要执行副作用与保全

- R1 原 MP4 渲染后 SHA 仍为 `014fc85ecff6d5b576e852f77b7daeb710360204a2481f02e4bd032a195dcc18`；R1 `out` 未覆盖。
- 本轮新建且保留：`C:\Users\34707\Tools\OpenMontage\remotion-composer\projects\cws-g1-r2`、`...\public\cws-g1-r2` 与上述 R2 Temp 工作区。未清理 R1 staging、输出或 Chrome Headless Shell。
- 渲染日志出现 `Webpack config change detected. Clearing cache...`，这是 Remotion bundler 在发现配置变化时自动输出的缓存失效提示；本轮没有执行手工清理命令。Chrome 浏览器缓存的版本和 SHA 在渲染前后不变。由于没有渲染前 Webpack 缓存清单，无法量化这条自动缓存处理影响了哪些既有 bundler 文件，作为本轮副作用记录。
- R1 曾发生未批准浏览器下载是历史事实；本次仅按 Owner 新授权复用该缓存，不将其追认或隐去。
- 没有其他项目/GitHub 文件改动；无外传私有 WAV、MP4 或浏览器缓存。没有清理动作，也没有启动 G2。

## 7. 文件索引与 SHA-256

所有以下文件均在 `C:\Users\34707\AppData\Local\Temp\cws-g1-r2-20261011-0e139b0d\work\out`：

| 文件 | SHA-256 |
|---|---|
| `g1-j-b-preview.mp4` | `6ced6981f3bcdcecbc362b729aafd4b8dff6a99740fb26855aa9e872bf8cc0a6` |
| `subtitles.srt` | `311a3a6d5840d3d77167ee7e0ae46abf0d6d6d6c68ae159a069ec7668eadb7d3` |
| `episode_timeline.json` | `7031a665abf6ce30251fa1521bb522a2c83436304b0ee8918fdc3a273a271810` |
| `rights_ledger.json` | `6eb37df254ab9b5bf7afd75a386748914a66b9a424cda02f26aadab40861741f` |
| `ffprobe.json` | `5fde1db7d8e142de9c2abed776462bf32bc5fddd96d08c00384f82e7ad477f58` |
| `browser_runtime_preflight.json` | `be69235ce2a51dfaf9d17b37c5c7462010931e932cf2b64e2e72f010d7d55a7f` |
| `frame-A.png` | `fb5ae2a19c14d91720fca5cb6e1a41835cf5eb37f8b1ea2ced69c813abe6587c` |
| `frame-B-08.png` | `6fe0a0af2c07bc0aadbabb8dff0937dab2f4208b24223dfce4f8842e5d3ab538` |
| `frame-B-18.png` | `2cd57a68fb9dc75060a10d6291ea9ac6eac3e5c04f6c328603397e5459603823` |
| `frame-QA-C005-Fig8.png` | `06a82e186f152ddcbe4d9b716bd1f9b841407ad58072824ae1e9b6eb80abda17` |
| `frame-QA-C006.png` | `2cd57a68fb9dc75060a10d6291ea9ac6eac3e5c04f6c328603397e5459603823` |
| `frame-QA-C007.png` | `84c71cbb6e530fb209944aa88536e55350dfeeca8197804fa003203150523835` |
| `frame-QA-C008.png` | `1ead05a8f0a5b3753af847d0f7a71666584dccc56bb82b380e03fe7fc563d925` |
| `frame-B-08-mobile-360.png` | `e2df75c1fd61700cb512b02699a24507fd20a67f785b5318d006b61975a3fe3c` |

### 最终状态

`G1_CONDITIONAL / NOT_PASS`。主要的 Fig. 8 遮挡缺陷已解决；Fig. 7 的主体证据在桌面与 360 px 缩放静帧中可辨；同步机器测量通过。解除阻塞仍需要 Owner 对**最终 MP4 文件本身**完整播放并试听，确认普通话自然度、字幕声学切点、开头/结尾及整体听感。完成此步骤之前，不得宣称 G1 PASS，不启动 G2。

## 附：试听输入适配文件

为尝试进行音频听感检查，曾从最终 MP4 导出 0–6 秒、16 kbps 单声道 MP3 诊断片：`out\qa-audio-00-06.mp3`（12,496 bytes，SHA-256 `4dc17821bed1cc3f943ad19dd67fc0aebb66937da7c8289ace4b0f30a1b05720`）。Codex 音频输入能力返回不支持提示，未能听辨该片；它不是重新配音，也不能替代完整 MP4 的 Owner 真人试听。