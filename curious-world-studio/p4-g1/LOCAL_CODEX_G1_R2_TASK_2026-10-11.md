# P4-G1-R2｜已批准复用 Chrome Headless Shell 的本地执行任务书

**Owner 授权更新**：2026-10-11 Owner 明确同意**保留并复用已下载的 Chrome Headless Shell 缓存**，用于本次私有 G1-R2 复渲，并指定今后 Remotion 视频制作**优先使用专用 Chrome Headless Shell**；Edge 继续用于日常浏览。未来任何浏览器版本下载/升级均需单独获批。此授权不是对 R1 未经批准下载行为的追认、不是放宽原源素材许可、不是 G2/G3 生产授权。

**当前 Gate**：`G1_CONDITIONAL / NOT_PASS`。本任务仅为 R2 的隔离复渲与视听 QA，绝不预先声明 PASS。

## 证据与输入（不重复下载、不重新配音）

在 repo 最新 main 中依次读取：

1. `docs/CURRENT_STATE.md`、`docs/P4_G1_EXECUTION_REPORT_FINAL_2026-10-11.md`、`docs/P4_G1_REVIEW_POST_RENDER_AND_R2_PLAN_2026-10-11.md`。
2. `p4-g1/LOCAL_CODEX_G1_TASK.md`（初轮技术条款，已执行的内容不重复）。
3. `p4-g1/scripts/render_windows.ps1`、`build_g1.py` 与 `remotion/ResearchEpisode.tsx`（须使用 R2 修复版）。

R1 本机工作区：

`C:\Users\34707\AppData\Local\Temp\cws-g1-20261011-8f3a2c`

必要原输入和已核定哈希：

| 文件 | R1 内容 SHA-256 |
|---|---|
| `assets/fig07.png` | `3bd76561dc2674cb3506627696ed62a81b89ce7ff69d093110601b9388f2555d` |
| `assets/fig08.png` | `80af1515e6b4e5dfa1dce0065929a424620d7aed3666b96a16c246f505749dbc` |
| `audio/narration.wav` | `72cf2cf8982af5e23bfa82ba74eb3f987fc847f0efe25789a846d85b6059de0f` |
| `captions.reviewed.json` | `0f5ff266f8fedf53dcdfa6c37401eaeadd338387e9d54dce0ab291bb5deefe09` |
| `fixture_script.txt`，trim 后 UTF-8 SHA | `2a336893b0c17e795ab9dae7434c954d2ea1fe637c8c0a7a9fd36b5a1e27cbaa` |

复用 R1 的 `rights.reviewed.json`，由现有 Gate 校验其中每件原图的对应 SHA/权利状态，禁止以聊天中缩放的 Fig 图替代。

## 已下载浏览器的授权界限

既有缓存目录：

`C:\Users\34707\Tools\OpenMontage\remotion-composer\node_modules\.remotion\chrome-headless-shell`

1. 只在**此缓存目录内**进行有限只读查找，要求 **恰好一个** `chrome-headless-shell.exe`；运行 `--version` 预期版本 `149.0.7790.0`，记录可执行文件 SHA-256 与版本。
2. 复渲时必须显式传入 `-BrowserExecutable <真实 exe 绝对路径>`；R2 脚本检查文件存在、位于上述允许目录、文件名准确、版本符合预期，再向 Remotion CLI 传入 `--browser-executable`。使用现有本地 `node_modules/.bin/remotion.cmd`，不能用 `npx` 自动找包。
3. **不允许新浏览器下载/解压/更新**；也不允许为了令渲染成功静默改用 Edge、安装新 Chromium 或修改机器默认浏览器/代理设置。如未找到二进制、版本不符、多个同名可执行文件或 Remotion 拒绝显式可执行文件，记录 `G1_R2_BROWSER_BLOCKED` 并停止，不试探自动下载路线。
4. Chrome 缓存、旧的 `projects/cws-g1`、`public/cws-g1` 以及旧 `out` **全部保留**；未经 Owner 后续授权不作递归删除。记录 R2 新增路径作未来可追溯清理依据。

注意：初次未批准下载是**客观违反约束**的历史事实，保留在报告中；本次获准复用不消除那条事实记录。

## 本轮实际执行序列

1. 确认最新版 GitHub main 已包含此修复版代码，按当前 main commit 记录版本。新建一个**不存在的**隔离 R2 TEMP 工作区，例如 `C:\Users\34707\AppData\Local\Temp\cws-g1-r2-20261011-<unique>`；禁止使用 R1 原目录作为 `-Work`。不能覆盖任何现存路径或原始输入。
2. 将 R1 的 `assets/fig07.png`、`fig08.png`、`audio/narration.wav`、`captions.reviewed.json`、`rights.reviewed.json` 复制到新工作区同样的子目录；逐件核对 SHA 与 REVIEWED 门禁，**不得复制 `out`、重录声音、重新下载图片或编辑时间码**。
3. 只读定位上文批准的 `chrome-headless-shell.exe`，确认版本、SHA、唯一性与来源路径；记录浏览器 preflight。确认新 stage `remotion-composer/projects/cws-g1-r2` 和 `public/cws-g1-r2` 不存在（如已存在则使用另一唯一 `cws-g1-r2-<id>`，或停止人工审查）。
4. 仅执行**一次** `scripts/render_windows.ps1`，传入 `-PilotRoot <最新仓库 p4-g1 目录>`、`-Work <新 TEMP>`、`-StageSlug cws-g1-r2`、`-BrowserExecutable <准确 Chrome Headless Shell exe>`；脚本**内部**调用 `build_g1.py`，勿再单独执行一次以造成 `out` 冲突。
5. 检查 `g1-j-b-preview.mp4`、`subtitles.srt`、`episode_timeline.json`、`rights_ledger.json`、`ffprobe.json`、`browser_runtime_preflight.json` 与关键帧。将 R2 MP4 与 R1 MP4 作视觉对比：特别查看 Fig. 8 **最底行所有研究图注/时间点**和 C005 字幕，确认所有证据在字幕出现的任意时间都不被盖住；Fig. 7 全图细节在 1920×1080 及缩小到手机观看宽度时应能辨识，不仅仅“没裁剪”。
6. 真人完整播放**最终输出 MP4**并试听：检查配音自然、字幕声学切点、有没有首尾截断/音画漂移、画面移动/字幕安全区是否影响阅读。A 1.8秒 → B、无 C、无逐词高亮、30fps、24秒左右，以及客观报告的 42.7ms 编码偏移由同一份 QA 如实核对。
7. 记录新增路径与输出 SHA、总帧数、浏览器 SHA/版本、视频+AAC 音轨 FFprobe、关键帧及真人听审结论，形成 `P4_G1_R2_EXECUTION_REPORT_2026-10-11.md`。如果 Fig. 7 仍太细小/缺少实际内容可读性，明确 `G1_CONDITIONAL_VISUAL_LEGIBILITY`，不要为赶进度伪造 PASS。

## 生产规范（今后同理）

- **Remotion 渲染默认**：沿用已有专用 Chrome Headless Shell 的**显式可执行路径**，由工程配置或受控 CLI 传递，不依赖 Remotion 自动发现/下载；版本、二进制 SHA 和 Remotion 版本共同记入每次渲染审计日志。以后不用日常 Edge 渲染。
- **升级**：仅当兼容性、安全性、修复需求需要，先评估并申请明确的下载/升级权限；不能永久保证旧版 `149.0.7790.0` 与所有未来 Remotion 版本适配。
- **其他边界**：不动 VPN、VPS、其他项目；不改 G2 正式剧本/题库/视觉锁定；不上传 WAV/MP4/私有素材/缓存进入 GitHub；本次仅用于 G1-R2。
