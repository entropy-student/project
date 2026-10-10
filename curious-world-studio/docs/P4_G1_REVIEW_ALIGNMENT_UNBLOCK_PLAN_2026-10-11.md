# P4-G1 Reviewer｜本机执行回读核验与字幕听审解阻（2026-10-11）

**最终状态：`G1_BLOCKED_ALIGNMENT / NO_MP4 / NO_G1_PASS`。** 本文件不会自动授权新云模型、系统软件安装、公开视频，也不能替 Owner 完成真实听审。

## 1. 已收到的本机只读/执行证据

- [Codex 原始执行回读](P4_G1_LOCAL_EXECUTION_READBACK_2026-10-11.md)：两幅指定 PLOS ONE 论文图下载成功且已核对；Microsoft Huihui Desktop SAPI 输出真实普通话 PCM WAV；字幕 `captions.reviewed.json` 状态 `NOT_REVIEWED` 且没有起止时点，`build_g1.py` 正确拒绝构建，未创建 `out`，未渲染 MP4/SRT/时间轴/关键帧；OpenMontage `cws-g1` staging 未创建。
- [原本机素材权利核验账本](../p4-g1/evidence/rights_ledger.local_review_2026-10-11.json) 单独保全。`A001` 原始本机 PNG 应为 3300×691，SHA `3bd76561dc2674cb3506627696ed62a81b89ce7ff69d093110601b9388f2555d`；`A002` 为 2400×1076，SHA `80af1515e6b4e5dfa1dce0065929a424620d7aed3666b96a16c246f505749dbc`。这些状态属于原始本机像素文件，不能自动外推到其它版本。
- Reviewer 独立读取本轮上传的 `narration.wav`：PCM mono 22,050 Hz / 16-bit，493,826 样本 = **22.395737s**，SHA `72cf2cf8982af5e23bfa82ba74eb3f987fc847f0efe25789a846d85b6059de0f`，与本机回读吻合。增加 1800ms 的无旁白 A 前缀后，理论时长 **24.195737s**，以 30fps 向上取整 **726 帧**。这是计算，不是实际 MP4。
- **聊天上传图片被缩放、字节有别**：Reviewer 当前容器读取到的 Fig 7 是 2048×428，SHA `30df4f5a61bd211bf0881951296cd8829151e20119c495f26b383a37c4084816`；Fig 8 是 2048×918，SHA `22f924b48dcd1bbe054ea022db9fa50d98b49286ee3a8d5b3d994156cfe10723`。与原本机 PNG 字节不同，**不可用上传缩放版覆盖 TEMP 原图或带原 SHA 的 rights 记录去运行门禁**；留在本机的原 PNG 才是本次应使用资产。差异并不推翻原本机下载/审核报告。
- PowerShell SAPI 成功之后的 `$LASTEXITCODE` 误报是调用包装层问题；已经通过独立 WAV 格式/哈希核实，不应据此再生成一遍音频。后续应检查 `$?`、文件存在、WAV header/哈希，而非过时的 `$LASTEXITCODE`。

## 2. Reviewer 做到哪一步：波形候选，不是假强制对齐

用音频本身的短时能量和停顿进行**离线候选定位**，提出 8 条字幕草案（[`DRAFT_NOT_REVIEWED` 文件](../p4-g1/evidence/captions.waveform_draft_NOT_REVIEWED_2026-10-11.json)）。明显停顿约在 2.2 / 5.4 / 10.1 / 12.1 / 14.8 / 19.4 / 21.7 秒；其中 8.26、17.23 秒的内部字幕分界更依赖语速推断，**不能视为听审完成**。文件保持 `human_reviewed=false`、`status=DRAFT_NOT_REVIEWED`，与构建门禁仍不兼容是正确设计。

| 字幕 | 相对真实音轨候选 start–end | 备注 |
|---|---|---|
| C001 | 0.120–2.160s | 首句 |
| C002 | 2.660–5.400s | 首句续 |
| C003 | 5.910–8.260s | 内部分界待听 |
| C004 | 8.260–10.100s | 与 C003 核对 |
| C005 | 11.090–14.800s | 含句内停顿，是否拆分可由真实字幕视觉再定 |
| C006 | 15.280–17.230s | 内部分界待听 |
| C007 | 17.310–19.410s | 与 C006 核对 |
| C008 | 19.900–21.630s | 末句 |

**全部为音轨相对毫秒**，不得在文件中自行加 1800ms；`build_g1.py` 统一将 1.8s A 前缀施加一次。此文件不叫 `captions.reviewed.json`。

## 3. 最短的下一步（不用再下载素材、重生成音频或重做 G0）

1. 使用本次 Reviewer 提供的独立**浏览器听审工具**：读取与 SHA 匹配的原 WAV，8 条字幕时间由上表预填；点逐句试听、调节起止、分别确认，最后导出 `captions.reviewed.json`。工具本身不能替用户或确实能听声校准的审稿人完成逐条听审。
2. 本机 Codex 将已核实的审核 JSON 写到**原隔离 TEMP 工作区** `captions.reviewed.json`，保持 `audio_sha256` 与 `script_sha256` 匹配已锁定的 `narration.wav`/`fixture_script.txt`。**不得单改状态位绕门禁**。
3. 本机 Codex 重新调用 `build_g1.py --work <原TEMP工作区>`。通过后再运行 `render_windows.ps1` 和 QA。遇到 staging 冲突、Remotion 入口错误或素材 SHA 改变，按真实错误报告，不自行重装或静默改技术路线。
4. 交付实际 MP4、SRT、timeline、ffprobe、关键帧、 rights ledger 和试听/视觉缺陷报告。技术成功之后才评估 G1 PASS；**没有实际视频就继续是 BLOCKED**。

## 4. 仍未完成的评估

- 真正的视频渲染与 Remotion 路由、A/B 视觉一致性、图像是否因 3300×691 超宽比例而在 16:9 画面里**看不清**，全部尚未验证。画面清晰度需要查看 MP4 抽帧，不能仅因为 `contain` 就报 PASS。
- 当前是微软默认 SAPI 普通话音色，**仅证明有成本为零的临时技术配音**；不代表未来节目的音色质量满意或中文自动强制对齐能力成熟。
- 许可证账本仅覆盖两张核对过的论文图；原始外链实验视频、任何第三方音乐/人物权利以及商业正式发布均未包含在内。
- 本地 Codex 因网络重置通过 GitHub raw 重建文件、没有本地 Git SHA，**可复现性为 CONDITIONAL**，不应虚报固定 commit 执行。下一轮无需重下素材，只需保全当前本机执行文件、尽可能记录每份输入的 SHA。

**Reviewer 结论：`G1_BLOCKED_ALIGNMENT` 是正确且应保持的门禁结果。产生听审后的真正 JSON 再继续渲染。**
