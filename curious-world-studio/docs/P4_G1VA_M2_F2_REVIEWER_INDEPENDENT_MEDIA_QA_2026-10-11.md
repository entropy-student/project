# P4-G1V-A-M2-F2｜单轮回归与真实 MP4｜Reviewer 独立复核（2026-10-11）

> Reviewer disposition: **`F2_PASS_CANDIDATE_ONE_OBSERVABLE_REGRESSION`**，可以结束本轮兼容性测试并进入 M2 **源码差异 PR 审查**。  
> **非** `M2_FORMAL_PASS` / `G1_PASS` / `G2_AUTHORIZED`。历史 M2 首次未诊断重试导致的 RETURN 不被追溯改写，间歇性渲染故障根因仍 UNKNOWN。  
> Owner 在 2026-10-11 已单独授权 Codex 完成这一轮受控渲染；Reviewer 这里验证的是本轮实际上传证据，不代表直连 Owner Windows 进程。

## 证据对象与独立检查

Owner 此轮实际上传了七份 F2 报告/日志/补丁以及一支真实 MP4，Reviewer 在沙盒计算完整 SHA-256：

| 上传项 | Reviewer SHA-256 | 关键结论 |
|---|---|---|
| `cws-g1va-v2-media-m1(1).mp4` | `d1e25a34ad41ba87a8e7ee836c4f44a54d39ac52c511861f350e340da6ba2516` | 文件直接审查；与历史 M1 通过的成片完全同哈希 |
| `render.log` | `74851ce2ed319a16c700b9ec1ef3bdbede17e491feb7226dbe61923980df43bc` | 看到旧 frame184 正常推进至 frame270/270，编码至270 |
| `g1va_m2_source_diff(1).patch` | `4c5df1ad6a5acea1f74fa26f76d9038d0d7e62b48a1b98c2bd8a678392554482` | 与此前 M2 五文件补丁完全同哈希 |
| `run_report.md` | `7895590a1e2b3bd7700f2a8f54bc30962c00e7df33417c310f6845a34ad4f674` | 前后细节、错误和边界 |
| `invocation.json` | `0eeb4b23e9c951f0a975d9b160f0ff5cbb93627507cd62cba15e0647965e6b52` | 本轮 launcher/runner/Remotion 实际参数有记录 |
| `invoke_result.json` | `687eb8ef0247b3a632837682b6f2d27b02886067fd2078ae956c488754716464` | `renderer_exit_code=0`、`runner_script_exit_code=0` |
| `machine_qa.json` | `6eb981afd793c0bad703b2d2ec3c33011cbbde2968e13fed83187f2951fc5873` | 原位尺寸、时长、解码/黑帧/画面匹配 QA |
| `resource_samples.jsonl` | `cb7e85b7e674f146e77a78c4277d477905c93d30924bb4da67bba2dbe919890a` | 15条内存/CPU/进程/磁盘采样 |

## 核实的结果

1. **视频真实文件**：Reviewer 通过 `ffprobe -count_frames` **独立验证** 1920×1080、30/1 fps、9.000s、H.264、270帧、**1路视频/0路音频**，497,395B；`ffmpeg -v error -xerror -i uploaded.mp4 -f null -` 全片解码成功；`blackdetect=d=0.05:pix_th=0.10` 无黑帧命中。与历史 M1 成片 SHA `d1e25a34...` 精确一致，因此原先对同哈希 M1 视频的视觉评价可继承。
2. **唯一实际渲染**：上传的 `render.log` 已从 frame0 至 270/270、Encoded270/270；concurrency **6x**，frame184 未发生前次 `No frame found`，`invoke_result.json` 两级退出码均为 0。此前有一次**观察脚本准备阶段**在未调用 renderer 前因 JSON 字段赋值出错而失败，后修复观察脚本才进行唯一一次渲染。按此次 Owner 授权，不能把准备阶段中止偷换为第二次渲染。
3. **观察器不是全 PASS**：渲染已成功后，新增的汇总观察器因 PowerShell 布尔字面值写法错误退出 **1**，未持久化外层 `Start-Process.ExitCode`；此缺口不抹去真实 renderer/runner 0 及有效 MP4，但观察链路本身**不能声明完全通过**。以后可修复观察器脚本的静态错误，**无需重跑此成片来补历史**。
4. **基本兼容性**：Runner 保持旧 M1 参数，未提供 `assetFileName`/`assetRightsBasis`，本机执行报告与补丁静态分析支持走 legacy branch。此结论只覆盖旧 M1 测试素材输入，不覆盖任何已采购/论文真实内容。
5. **视频时钟**：机器报告中的首帧对应源图 SSIM 0.987784、暂停跨时段 SSIM 0.999622、播放后源1秒 SSIM 0.978587，均超过预定门槛；Reviewer 当前可独立验证已上传 MP4 文件与历史视频同哈希，但当前附件里没有源 poster/source 原件用于重新计算 SSIM，因此逐项 SSIM 指标归于**Owner 本机机验报告**，不得冒充本轮独立源帧复测。
6. **补丁范围**：上传补丁 `git apply --stat` 独立核查**恰好 5 个 `p4-g1/m1-media-adapter` 文件**（1 TSX 变更+4 PS1/PSM1 新增，约551 insertions/17 deletions）。GitHub `main` 上现存 TSX blob `bc20a83cbbf84a697dcf19679343b3a15d3bce9a` 与 patch 原始 `index bc20a83..` 匹配，**候选代码尚未合并**。静态补丁中的 `assetRightsBasis='self_generated_local_test_only'` 限定了 M2 为**自造无声测试素材适配**；正式研究视频需要后续另行设计真实媒体权利/schema/旁白与字幕，不能直接把 M2 test adapter 称为生产可用完整生成系统。
7. **资源警示（新发现）**：15次本机报告样本：preflight available RAM ~3,231 MiB，渲染期间**最低可用内存221.86 MiB**；匹配进程树峰值工作集 **3,891.34 MiB**，CPU 最高约58.94%（12逻辑核容量），C盘最低空闲128.43 GiB。**低内存是实际资源风险信号，但与之前 frame184 proxy500 不构成已证因果**。若以后运行更长的真实视频，应独立设内存安全预算/并发上限，不能直接沿用 6x 并认为足够安全。

## Reviewer 结果与下一步

- `F2_CANDIDATE_MEDIA_QA=PASS`；`F2_RENDERER_AND_RUNNER_EXIT=0`；`F2_OBSERVER=POST_RENDER_RETURN_WITH_EXPLICIT_EVIDENCE_GAP`；整体 `F2_PASS_CANDIDATE_ONE_OBSERVABLE_REGRESSION`。
- 旧 `M2_F1=RETURN_DIAGNOSTIC_INCONCLUSIVE / STOP`、`M2=RETURN_UNDIAGNOSED_RENDER_FAILURE` 历史保留；**不得宣称一次新成功已经证明旧偶发故障根治**。
- 现有 M2 两支候选视频（landscape_24, portrait_30）前一轮**已经独立文件级 QA 通过**，不重做。M2 patch 目前为 Windows 本地未经提交、未推送、未合并的候选。
- **下个实际开发步骤**：把经上传哈希核对的 M2 五文件 patch **原样**构成单独代码 PR（不得把本轮报告/渲染 stage/二进制/原始 Windows 绝对路径提交进源代码），Reviewer 对照 patch SHA、主分支基线、源码白名单、兼容性及失败即停进行 diff 审查；通过后才考虑合并。**此文只批准进入代码审查，不是 Owner 的 GitHub 写入/合并授权，也不额外批准重渲染。**
- 后续正式视频必须分别解决：真实横屏优先的授权素材、研究事实/素材对应、中文旁白与单行字幕音画同步、长片资源/稳定性、自动化编排；正式制作前执行已记录的项目自有旧测试文件清理 Gate（先审核精确列表，Owner 单独确认删除）。不必因 yt-dlp Wikimedia/Blender 下载失败而中断其它合法素材规划。

**本轮未修改生产源码、Windows 环境、VPN、yt-dlp、正式素材或既有视频。**
