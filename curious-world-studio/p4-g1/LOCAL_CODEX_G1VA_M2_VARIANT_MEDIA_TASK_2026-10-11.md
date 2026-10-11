# P4-G1V-A-M2｜Research Aqua 多规格本地媒体适配 Gate

> Date: 2026-10-11  
> STATUS: REVIEWER_GATE_READY / EXECUTION_NOT_STARTED  
> G1: NOT_PASS · G2/G3: NOT_AUTHORIZED  
> Owner 反馈：2026-10-11「我没啥问题，可以继续推进」。记录为 **OWNER_NO_OBJECTION_TO_PROCEED**；未提供其实际完整观看 M1 MP4 的独立证明，**不登记 M1_OWNER_FULL_VIEWING_PASS**。

## 0. Gate 识别与授权边界

- **GATE_ID**: `P4-G1V-A-M2_VARIANT_MEDIA_INPUT`
- **OBJECTIVE**: 复用 M1 已获证的 **Assistant V2 Research Aqua HTML** 与本地 Remotion，将单个测试 MP4 输入从固定规格扩展到两种受控、无声、自制测试视频；验证 source FPS/尺寸/时长与输出30fps 的转换、首帧冻结、真实播放、画面 contain，保留 M1 兼容性。
- **MAX_ENDPOINT_THIS_ROUND**: 仅限 M2 适配代码/本地受控生成的两段测试片 + M1 兼容性回归 + 机器/人工可审证据。**不得**导入真实研究视频、做科研 B 段、配音、完整 G1 及 G2/G3。
- **MANDATORY_REVIEW_STOP**: Executor 输出 `PASS_CANDIDATE_M2` 或精确 `RETURN_*` 后即停止。只有 Reviewer 完整检查全部证据，才能出具正式 M2 Gate PASS；不得自动启动下一步。
- **TARGET_AND_SCOPE**: `entropy-student/project` 的 `curious-world-studio/p4-g1/m1-media-adapter/` 与新的 **M2 专用本机隔离 staging**。GitHub main 不供 Executor 直接写入；允许在干净项目级隔离 worktree / 独立分支提出最小代码变更，交 Reviewer PR/patch。
- **OWNER_ONLY_ACTIONS**: 新成本、软件/浏览器下载安装、研究原视频获取/商用许可、账号或 Secret、改 Windows 权限/VPS/VPN、对外发布、任何 G2/G3/生产操作均未获授权；需要时立即 RETURN。

## 1. 已接受事实与不得改变的约束

- GitHub `main` 起点：`d8b63657a4c61d70d41e20098a3e9049c1c303a2`；M1 已经通过**一个** 1920×1080、30fps、6s、静音自制素材的 Reviewer 技术 QA。无需重演其历史 Gate。
- **视觉实现真源**：`curious-world-studio/p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`，已锁 Git blob `acb0ee80264527bd11160e0ae277ce24528c4a03`；**不要按截图另画桌面**。`STYLE_LOCK v1.2` 上位，固定 A→B 无 C、输出 1920×1080@30、B contain、单行字幕约束（本 Gate 无字幕）。
- M1 可用实现：`p4-g1/m1-media-adapter/ResearchAquaMediaAdapter.tsx`、`entry.tsx`、`render_m1_windows.ps1`、`generate_test_fixture.ps1`；其当时 Git blob SHA 分别是 `bc20a83cbbf84a697dcf19679343b3a15d3bce9a`、`e79a58f37b4d62ee03b372fc379b880edb0bd00e`、`bb4284c43f7a374ba6e8071166286d7e159c58b2`、`ffb01ec91f05a3389c7e47d750c86252685a95ff`。
- 原 M1 runner 将 `assetFrameCount` 用于 `Sequence durationInFrames`，与目标 composition 30fps 不同的素材有**秒/帧单位错配风险**；`OffthreadVideo` 裁切参数的实际语义以**本地安装的 Remotion 4.0.484 API/类型及渲染结果**为准，不以参数名称猜测；输出时钟唯一来源是 composition frame/fps。
- 原 M1 9s/270 帧只是视觉演示外壳，不是素材时长；播放器时间与进度 `played_seconds / probed_source_duration_seconds`。在点击播放前必须保持**同源文件实际首帧**，不允许隐性推进。
- 研究材料权利、`LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED` 彼此独立；此次两段片仅是明确标记「示意画面」的**本地自制测试夹具**，不创建科研事实。

## 2. M2 受控输入与定值

保持 composition `1920×1080, 30fps, 9.000s/270 frames, no audio`，A→B 时间轴与 V2 保持一致（播放起点依现有代码约 frame=143 / 4.7667s）。准备**恰好两种新的、由本地 FFmpeg 确定性生成、具有可识别时间运动的夹具**：

| id | source clip | 目的 | 预期播放器1秒进度 |
|---|---|---|---|
| `landscape_24` | 1280×720, CFR 24/1fps, 8.000s, 192frames, H.264, 无音轨 | 源帧率≠输出帧率；正确按秒抽帧而不是按 source 帧数推进 | ≈ 1/8 |
| `portrait_30` | 1080×1920, CFR 30/1fps, 9.000s, 270frames, H.264, 无音轨 | 竖屏 contain，中央素材、可接受黑边、不拉伸/不裁切 | ≈ 1/9 |

实际元数据必须 `ffprobe` 读回；任何尺寸/时长不吻合均不得以表格推定 PASS。两个夹具都长于实际4.23秒素材播放窗口，**不声称视频播至素材末尾**；输入若不符合规定要立即 fail-closed。每个 clip 各自独立 stage slug，绝不覆盖 M1 文件。

## 3. Preflight

1. 先证明当前真实 Windows 目标 machine/user/PowerShell、Git root/branch/revision、项目路径和非目标 worktree 状态。不得把沙盒路径当 Owner Windows 实盘；源基线不一致或夹杂其他项目未提交修改则 `RETURN_PREFLIGHT_DRIFT`。
2. 核已安装 Node/FFmpeg/Remotion 与唯一批准的 Chrome Headless Shell，沿用 M1 runner 固定浏览器版本 `149.0.7790.0` 与已接受 SHA `ec76dc3e69ffab9daddf0bbe7bf0a9e0a034b2d086741a0ae2ef6358a597537b`；显式 `--browser-executable`。不得 `npx` 在线下载、自动安装、浏览器替换或云 TTS。
3. `git hash-object` 实核选定 V2 HTML blob；确认前述 M1 基线，先区分历史已验收事实与**代码修改后的新回归**。任何目标路径已存在则停止/更换全新 M2 slug，禁止清空旧 stage。
4. 只使用干净的隔离工作目录与项目拥有的路径。先验干扰、旧样片/文件、回滚到 M1 blob 的路径及足够磁盘/RAM；低资源时串行渲染。
5. 明确本次不接收外部来源素材/音轨/秘密信息；单一视频流 + 视频规范及权利元数据必须通过白名单预检。

## 4. 执行指令（小范围改造，不重写 UI）

- 在 M1 适配器上进行最小参数化：不再硬编码 `local-demo.mp4`、9s 文案所暗示的媒体总时长、单 M1 stage 名；生成版本化 `input_manifest.json`、`episode_timeline.json`，其中分别保留 source FPS（有理数）、output FPS、source duration、source frame count、render play frame、asset local timestamp、fit policy、source SHA、poster SHA、rights basis。
- 统一采用**秒/毫秒**判断播放采样和播放器进度；明确每个输出帧对应的预期 source presentation timestamp。在源24fps case，一秒后应对应**约源第24帧而非第30帧**；容差按实际时间采样最多 ±1 source frame，需日志证明而非只看视频动了。
- 保留旧 V2 画布行为，原有 first-frame poster 必须由**这次同一个 MP4 文件**解码提取；首次播放前暂停两帧源 local time=0。播放后用媒体真实 duration 更新进度；不得因单一外壳9s导致错误标尺。
- 竖版不得占满后被拉伸/剪裁；录制 contain 的版心、尺寸及至少一组不同位置的标记以证明无关键内容被遮蔽。
- 本轮不测试带声音、多轨、VFR、第三方编码或真实媒体授权；这些均维持 UNKNOWN，不能泛化为“任意MP4”。
- 对参数丢失、FPS=0、stage 冲突、素材权利未知/音轨存在、首帧海报与源不一致等做 fail-closed 负向夹具/静态门禁验证，不产生旧输出副作用。
- 不可写回 main；先输出 patch/source hash/本机产物，交 Reviewer 独立检查之后再考虑合并。

## 5. REQUIRED_EVIDENCE / ACCEPTANCE_CRITERIA

每个新夹具分别提供：
1. `source.mp4`、`poster.png`、最终 `9s output.mp4` 的**真 SHA-256**、文件路径、FFprobe streams/尺寸/FPS/duration/frame count；来源与权利 `self_generated_local_test_only`。
2. 从同一 source 独立生成 frame0 并**像素逐点比较** poster；B 暂停期 4.400s、4.733s 与源 frame0 的独立对照；播放后1s、3s 抽帧与按实际 source time 解码的对照（24fps case 特别记录24/72帧）。若做 SSIM，必须说明裁剪坐标/缩放方式，不能拿不同方法的 SSIM 当同一值。
3. 输出全片解码成功、H.264、1920×1080@30、270帧、无音轨、无异常黑段；A 桌面鼠标/窗口/全屏/播放事件保留的关键截图至少 8 张；可人眼识别的色块/刻度无拉伸裁切。
4. 播放前进度=0；play_start frame / source local time / video clock 同一时间基准；后1s/3s 进度分别符合 `1s/duration`、`3s/duration`，并且真实视频已推进。
5. 源码 diff（严格限项目目录）、类型/构建/测试和完整命令退出码、已授权浏览器版本与预/后 SHA、隔离目录清单、无安装/下载/服务消费证明、负向测试结果、可执行的恢复/回滚说明。
6. **M1 code-change regression**：新实现针对旧 `1920×1080@30,6s` 在**新隔离 stage**做有界回归（不重评历史 Gate、不覆盖已验收 M1）；验证首帧、冻结、播放时钟和 UI 行为仍正常，尽量复用已存在旧 fixture（找不到则先只读核对再根据批准的本地生成器重造，不能声称 SHA 与旧文件一致）。
7. 最终报告区分 `DIRECT_READBACK`、`OWNER_REPORTED` 与 `INFERRED`。Executor 仅给 `PASS_CANDIDATE_M2` 或精确 `RETURN_*`；Reviewer **实际可访问/检查所有必须证据**并给正式判断。无证据、无法核实或视觉明显偏离 V2 即 RETURN。

## 6. ROLLBACK_STATUS_OR_PLAN / STOP

- M1 原四份源码 blob、V2 HTML、旧测试片均为只读的当前恢复基线；M2 只在隔离 worktree/stage 修改/输出，并有 source diff、哈希、原路径。回滚 = 不合并 M2 patch，保留原 M1；如隔离运行时发生异常，先 read-back staging 与旧资源引用，不盲目删除。
- 浏览器校验失败、权限不一致、现有配置被写、下载触发、数据/Secret/研究素材边界不明、渲染失败或结果不明确时，立即止步；不得盲目重试。两次近似失败先缩小 fault domain 再诊断。
- 公共生产、正式选题、TTS、B 内容、版权、G2/G3 不在回滚/验收范围。

## 7. REVIEWER_TO_EXECUTOR_RELAY（直接复制给本机 Codex）

> 执行 **P4-G1V-A-M2_VARIANT_MEDIA_INPUT**，只读本文件、`docs/CURRENT_STATE.md` 最新顶栏、`p4-g1/m1-media-adapter/` 四个 M1 源文件、`p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html` 和 `visual/retro-mac-v1.2/docs/STYLE_LOCK.md` 中与本 Gate 直接相关的 A/B约束，以及现有 M1 Reviewer QA 中的已接受事实。不得重读 Governance/项目历史大包，不得自行重启 M1 或扩到 G2。先做完整 Preflight，目标是仅在 Owner Windows 隔离 worktree 生成两段合法自制测试视频，按本 Gate 改造并实际渲染，验证24fps与竖屏 contain，做旧 M1 的**代码变更回归**，输出全部真实 MP4/日志/manifest/source diff。不得安装/下载、调用云模型、触及 VPN/VPS、真实研究素材、其他一级项目。只执行本 Gate 最大端点；失败返回精确原因，成功仅为 PASS_CANDIDATE。交 Reviewer 审阅后停止。

## 8. EXECUTOR_TO_REVIEWER_RELAY

固定短报：`结果`、`改动`、`验证`、`问题`、`回滚`、`请 Reviewer 检查`、`Owner 转交`（无则 NONE）。附 source patch/commit、两个视频和回归文件、manifest、完整 QA Evidence 路径与哈希。**不要直接修改 CURRENT_STATE / REVIEWER_HANDOFF，也不要替 Reviewer 宣布 PASS。**
