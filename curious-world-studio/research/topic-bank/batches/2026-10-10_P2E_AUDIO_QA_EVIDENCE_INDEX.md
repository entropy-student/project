# P2-E｜B 原论文补充音频只读 QA：main 证据索引

**日期**：2026-10-10；**性质**：来自尚未合并的 GitHub 研究分支的**历史实测事实索引**，不是生产资产、版权验收或 STORYFIT_GO。

- 原文 `10.1371/journal.pbio.3004046`；官方补充声音 DOI：<https://doi.org/10.1371/journal.pbio.3004046.s008>。
- 远端 GitHub Actions [#38025311695](https://github.com/entropy-student/project/actions/runs/38025311695) 已运行成功：**5/5 离线测试**、从论文官网获取 **RAR5** 附件（约 15,927,334 字节）、使用临时运行器解析到 **14/14 WAV** PCM 文件元数据。该运行的 JSON artifact 编号 `11659589029`（artifact 有保留期，过期后请以运行记录和此证据索引为限）。
- WAV 规格：约 **0.200–0.202 秒/段**、单声道、16-bit PCM、97,656 Hz；包含 10 个基础声学刺激和 S-Pair1A/B、S-Pair2A/B 两组配对刺激。
- 配对检查：S-Pair 组内 A/B 文件的 SHA256 不同；组内时长/采样率/声道/峰值/RMS 元数据一致。跨组电平可能不同，严禁声称所有声音听感完全一样。
- 原研究核对与工具说明保存在分支 [`cws/p2e-audio-storyfit-preflight-20261010`](https://github.com/entropy-student/project/tree/cws/p2e-audio-storyfit-preflight-20261010/curious-world-studio/research/topic-bank/preflight)，研究报告 [P2-E](https://github.com/entropy-student/project/blob/cws/p2e-audio-storyfit-preflight-20261010/curious-world-studio/research/topic-bank/batches/2026-10-10_P2E_BD_PRE_STORYFIT_AND_AUDIO_QA.md)。
- **只把以上索引写回 main**。未把旧分支中的 `audio_probe.py`、测试、自动 Actions 工作流或原始音频合入 main；更不将源音频视为 OpenMontage 生产输入。

**未核验**：真人耳机/手机播放或平台压缩后的听辨效果；S1 音频单项商业复用/第三方例外；真实观众对题目的兴趣；正式视频价值。**文件解码成功 ≠ 真人听觉效果成功 ≠ 版权成功。**

B 与 D 的过去 STORY-FIT 候选评级只具历史参考意义，最新讲述机制回归见 [P3-R1](../../reports/2026-10-10_P3R1_NARRATIVE_MECHANISM_MARKET_RETROSPECT.md)。**禁止因这份文件自动提升级别、产生配音/视频或安装工具。**