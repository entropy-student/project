# P4-G1｜原论文在线素材 + Retro Mac A/B Remotion 20–30 秒技术样片

**Status**: `G1_SCOPE_APPROVED / G1_IMPLEMENTATION_PREPARED / G1_LOCAL_RENDER_NOT_RUN`. 本目录是**候选执行包**，不是已经跑通的视频；不改题库、P3 剧本或已锁定视觉样式。

2026-10-11 Owner 允许直接从现有网站/论文信息源获取素材，不必在本地已有素材；同意继续制作技术短片。此批准仅覆盖小范围、无付费、不公开视频的 G1 实验。尚未授权读取秘钥、云端 Qwen 付费调用、安装模型/工具、无许可转载原始视频或扰动既有 VPS/网络。

## 为什么选 J-B

研究原始论文 [Shimoyama et al., 2026, PLOS ONE](https://doi.org/10.1371/journal.pone.0350612) 有明确来源的 Fig. 7、Fig. 8，分别是 2 类互动果冻视频的**论文内部截图/画面概要**，能直观验证 B 主视口的 `contain`、标签和字幕。正文注明 1094 名受试者是**看视频并打分**、没有真的把果冻吃掉；本技术片摘录 [P3-R4 J-B 试讲稿](../research/story-fit/prototypes/2026-10-10_P3R4_J_B_FULL_READTHROUGH_V1.md) 中一个连续段落，**不是正式 SCRIPT 或题目晋级**。

两张图片可从文章的公开下载端点申请获取，文章文字注明 CC BY / attribution。但 **看到论文的授权声明 ≠ 已逐张图验证版权例外，≈ 更不代表附录所链实验视频可以直接商用**。`source_manifest.json` 初值均为 `content_verified=NOT_VERIFIED / reuse_rights_verified=UNKNOWN`；下载后先看图并核实署名与图像权利，然后才允许用于 G1。

## 工程最小结构

`remotion/entry.tsx`、`ResearchEpisode.tsx` 定义 A→B 两状态、1920×1080/30fps、单行中文字幕、音频单偏移和图像 `contain`。A 默认 1.8秒且静音；B 在满屏研究播放器中轮播论文 Fig. 7→Fig. 8。实际时长由音频精确长度决定；如未落在20–30秒则如实报 BLOCKED，不偷偷变速或补写旁白。没有BGM和C状态。

本包不引入新的 npm 依赖，预期在 Owner **已有的** OpenMontage `remotion-composer` Node/Remotion 4.0.484 环境内通过**独立添加的** `projects/cws-g1` 与 `public/cws-g1` 路径运行。所有写入路径先进行不覆盖检查。现有上游 `video_compose.py`、`Root.tsx`、`.env`、旧视频及其他项目不修改。实际可运行性尚无证明。

## 执行入口（给本机 Codex）

**完整步骤与停止条件**：[LOCAL_CODEX_G1_TASK.md](LOCAL_CODEX_G1_TASK.md)。

1. 从当前 `main` 取得此目录，建立**全新独立 G1 工作区**，不向公开仓库提交隐私素材。
2. 已有 Python 运行 `scripts/fetch_figures.py --work <workspace>`，仅拉取两张论文 Fig. 7/8；下载后核对真实像素、出处和权利。
3. 为最终旁白准备一份真 WAV。若本机**已经**安装中文 SAPI 声线，可先采用 `scripts/create_sapi_audio.ps1` 产生临时技术朗读；否则停在 `G1_AUDIO_BLOCKED`，不触发 Qwen 云 TTS。
4. 按**真人听审**填写 `captions.reviewed.json`；根据下载 SHA 填 `rights.reviewed.json`。两份模板默认故意不通过，防止伪造对齐或商业许可。
5. `scripts/render_windows.ps1 -PilotRoot <repo/p4-g1> -Work <workspace>` 在一切审查通过后生成时间轴/SRT、加法式 staging、调用本地 Remotion、输出 MP4/ffprobe/关键帧。
6. 将**实际执行结果**返回 Reviewer，不把孤立的 TSX/下载/初次 MP4 等同于视频技术全链路 PASS；真人完成看听审查、字幕对齐和画面语义检查后才能判断 G1 结果。

## 核心验收

- `1920×1080 / 30fps`、真实音频与视频同一时间轴，A 1.8秒 → B 无 C、B 满幅、科研画面 `contain`。
- 研究画面只用真实 Fig 7/8，标 `论文证据`，不将图库/想象素材冒充实验录像。
- 所有字幕**一行、56px 左右、不逐词高亮**，忠于 J-B 原文，一句可拆多条，音轨与字幕哈希一致。
- 每幅图 `LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED` 分开记录，署名来自原文。
- 记录所有新增临时路径、声线、本地渲染缺陷、下载失败、许可疑点及是否等待 Owner 手动检查。
- **没有公开视频、没有逐件视频商业转载许可结论、没有自动对齐通过声明。**
