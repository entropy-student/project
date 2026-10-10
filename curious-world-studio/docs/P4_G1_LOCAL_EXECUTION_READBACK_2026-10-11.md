# P4-G1 Windows 本机实际样片执行回读 — 2026-10-11

## 验收状态

**G1_BLOCKED_ALIGNMENT（未通过；没有声称 G1 PASS）。** 已取得并逐张核对 Fig. 7、Fig. 8，完成逐件图像权利审阅，并由本机 Microsoft SAPI 生成普通话 PCM WAV。实际 WAV 为 22.396 秒；按任务中的 1.8 秒 A 开场计算，预期片长 24.196 秒，处于 20–30 秒范围。

尚无可记录的真实听审和字幕时点复核。字幕输入保持 `NOT_REVIEWED` / `human_reviewed=false`。按 G1 门禁运行的构建脚本以退出码 1 拒绝继续，提示 `Caption alignment NOT REVIEWED; do not render as G1 pass`，且没有创建 `out`。因此没有 MP4、SRT、正式时间轴、关键帧或 MP4 QA 结果。

## 来源与执行边界

- 按顺序读取了任务书指定的 CURRENT_STATE、G0 合同修正/G1 验收、既有 G0 回读、STYLE_LOCK、P3-R4 J-B 全文，以及 P4-G1 任务包。没有重做 G0。
- 最新内容通过 GitHub `raw.githubusercontent.com/.../main` 当前分支 URL 只读获取。Windows `git clone --depth 1 --branch main` 因 GitHub 连接重置失败；GitHub MCP 也发生传输失败，故没有本地完整 checkout 或可记录的 commit SHA。为完成获准的两张图下载和 SAPI 音频门禁，P4-G1 包内运行文件由已读取的 raw `main` 文本重建到隔离 TEMP；这不是 Git checkout，来源可复现性因此降级，不能把它描述成某个固定 SHA 的执行。
- TEMP 工作区：`C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c`。
- 没有安装/升级软件，没有调用云模型或付费 TTS，没有下载 S3 外部实验视频，没有改动网络/系统配置或原始项目文件。OpenMontage Composer 的 `projects\cws-g1` 与 `public\cws-g1` 在前置检查时均不存在；本次没有创建暂存目录或运行 Remotion 渲染。

## 图像与权利账本

PLOS ONE 论文页将文章标为 CC BY 4.0，并分别将 Fig. 7 标为 Video 1 outline、Fig. 8 标为 Video 2 outline。两条图注附近未见独立第三方权利说明。已核对下载像素内容与图注：

| ID | 本地文件 | 内容核对 | 下载图 SHA-256 |
|---|---|---|---|
| A001 | `assets\fig07.png`（3300×691） | 三格咨询互动图，面板时间为 15s、36s、76s；与 Fig. 7 图注所述 Video 1 一致 | `3bd76561dc2674cb3506627696ed62a81b89ce7ff69d093110601b9388f2555d` |
| A002 | `assets\fig08.png`（2400×1076） | 六格手部/玩具提示及反应图，面板时间为 15s、19s、33s、47s、62s、86s；与 Fig. 8 图注所述 Video 2 一致 | `80af1515e6b4e5dfa1dce0065929a424620d7aed3666b96a16c246f505749dbc` |

逐件权利审阅已写入：

- `C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\rights.reviewed.json`
- `C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\rights_ledger.reviewed.json`

两项状态分别记录为 `LINK_FOUND`、`CONTENT_VERIFIED`、`REUSE_RIGHTS_VERIFIED\)，依据是论文版权声明及逐张图注没有另列排除项；账本含 DOI、署名、SHA 和拟用修改说明。该审阅仅支持本次私有本机 G1 技术样片中的这两张论文图，不构成对外发布或任何其他素材的自动许可结论。CC BY 署名需注明作者、来源、许可和改动；许可页也提示其他隐私、公开权或精神权利可能仍需额外考虑。论文的 S3 视频及其音频均未获取或使用。

## 音频与未渲染的设计时序

- 主音频：`C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c\audio\narration.wav`
- 引擎：已安装 Windows System.Speech / Microsoft Huihui Desktop（zh-CN）；未安装或下载语音包。PCM WAV，单声道，22,050 Hz，16-bit，22.396 秒；SHA-256：`72cf2cf8982af5e23bfa82ba74eb3f987fc847f0efe25789a846d85b6059de0f`。
- `audio\narration-review.mp3` 是为本次试听生成的本地低码率副本，不是主音轨。
- 根据包内构图公式可推导但尚未物化的计划是：A 桌面 0–1.8s；音频从 1.8s 起；B 的 Fig. 7 约 1.8–13.0s；B 的 Fig. 8 约 13.0–24.2s；目标画布 1920×1080、30fps、726 帧。**此为未渲染的公式推导，不是已交付时间轴。**
- 字幕模板共有 8 段、两条原始叙述线；各时点仍为 null。没有用等分字数、ASR 时间戳或推测值填充。没有取得可记录的人类听审/同步核验，所以不能置 `human_reviewed=true`。

## 运行证据与未产出项

- `fetch_figures.py --work <TEMP>`：成功，只下载清单中两张 PLOS PNG；签名/尺寸检查通过并写出 `assets\download_receipt.json`。
- `create_sapi_audio.ps1`：成功创建 WAV，所选音色为 Microsoft Huihui Desktop。
- 调用 SAPI 脚本的 PowerShell 包装命令在脚本完成后检查了未定义/过期的 `$LASTEXITCODE`，因此额外抛出 `G1_AUDIO_BLOCKED`。随后对 WAV 文件本身作了独立读取，确认 PCM 头、帧数、时长和 SHA 均有效；这是包装层误报，不是语音生成失败。
- `build_g1.py --work <TEMP>`：退出码 1；按预期在 NOT_REVIEWED 字幕门禁停止，未创建 `out`。
- `render_windows.ps1` 未运行；没有 MP4、SRT、`episode_timeline.json`、`ffprobe.json`、frame-A / frame-B-08 / frame-B-18，也就没有实际 MP4 的尺寸、帧率、音轨、黑帧、画面连续性或字幕同步 QA 结果。
- 当前可用素材和账本不等于完整样片验收。仍需真实听审并填写与最终 WAV/SHA 绑定的字幕起止时点，再重新执行构建门禁与渲染/QA。

## 来源链接

- [P4-G1 task package（GitHub main）](https://github.com/entropy-student/project/tree/main/curious-world-studio/p4-g1)
- [PLOS ONE article](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0350612)
- [Fig. 7 DOI](https://doi.org/10.1371/journal.pone.0350612.g007)
- [Fig. 8 DOI](https://doi.org/10.1371/journal.pone.0350612.g008)
- [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

## 残留工作区

未自动删除任何 TEMP 文件。该目录保留 raw-main 重建的任务包、下载图、试听副本、WAV、权利审阅账本、未审字幕模板和本回读。没有 OpenMontage Composer 暂存残留。