# B 论文原始 S1 Audio｜只读研究预审工具

此目录用于在 **进入正式 STORY-FIT 或视频制作之前**，对论文 `10.1371/journal.pbio.3004046` 的 S1 Audio 进行安全、可重复的**文件级元数据 QA**。

**绝不生产视频、配音或字幕，也绝不上传论文原始音频**。

- 程序：`audio_probe.py`；Python 标准库 + GitHub 临时运行器上的 7-Zip（RAR）即可。WAV 解析使用标准库 `wave`，无需 `ffprobe`。
- 回归：`python -m unittest discover -v -p "test_*.py"`。
- 推荐操作：GitHub Actions `Curious World Studio — P2 B audio research preflight only` → `Run workflow`（不要在生产机执行）。
- 唯一上传产物：`S1_AUDIO_QA.json`（状态、字节量、哈希、音频编码、采样率、单段时长、电平、S-Pair A/B 配对差值），**不包含任何原始音频**。
- 最新真实运行：[Actions #38025311695](https://github.com/entropy-student/project/actions/runs/38025311695)，5/5 离线用例、RAR5 14/14 WAV PCM 元数据读取、配对 A/B 区分且同电平；artifact `11659589029`。
- 只验证了**格式和元数据**，不证明真人耳机或手机外放可辨认，不证明音频压缩链路无失真或商用复用许可。任何页面的 CC BY 概述必须与具体媒体声明独立核对。
- 研究记录：[P2-E B/D PRE-STORYFIT](../batches/2026-10-10_P2E_BD_PRE_STORYFIT_AND_AUDIO_QA.md)；未更改正式 36 条选题。

**硬停点**：Owner 明确要求**视频生产之前必须通知他**，检查昨晚本地 Codex 成功流程、参考方法与项目 locked visual 规则之间的接口。严禁从本音频 QA 直接触发脚本、渲染或发布。
