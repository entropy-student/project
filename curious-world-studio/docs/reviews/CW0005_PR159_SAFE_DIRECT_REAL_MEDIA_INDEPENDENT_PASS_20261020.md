# Curious World Studio｜PR #159 动态安全直链真实素材技术验收｜独立Reviewer报告（2026-10-20）

**正式裁决：`PASS_SAFE_DYNAMIC_DIRECT_MEDIA_CANARY`，范围严格限定为CWS通过代理对catalog-ID动态HTTPS单文件MP4/WebM的技术下载及媒体QA。** `GENERIC_YTDLP_EXTRACTOR=NOT_VERIFIED`，`CW0005_VISUAL_STORYFIT_HOLD/G1_NOT_PASS/G2_NOT_AUTHORIZED/R4_NOT_AUTHORIZED/RIGHTS_PARTIAL/NO_PUBLISH`等正式制作限制全部维持。**本报告只接受技术Gate，不合并PR、不开启下一执行Gate。**

## 审核身份与真实证据

- **PR**：[PR #159](https://github.com/entropy-student/project/pull/159)，本次HEAD `bfddbbf86c9d5fa9a8c93513c1ea5c2d7b62dea8`（旧HEAD `59f427d...`）。Reviewer已在GitHub按此HEAD提交[独立Review意见](https://github.com/entropy-student/project/pull/159#pullrequestreview-5580324507)，初始Review的F159-01/F159-02本轮有代码修复和回归证据。PR仍**Open、未合并**。
- **Owner实际上传ZIP**：`CWS_PR159_CACHE_DEADLINE_REAL_SMALL_MEDIA_CANARY_20261020.zip`（非仅Windows磁盘文字路径），总字节`2,732,845`，Reviewer独立SHA256`dd2875f7adf2ce3f41cf948267b54c27ab5bd11824691058d68d22b78b1f0ae5`；38个成员、`SHA256SUMS.txt` 37/37内容SHA匹配、ZIP CRC测试无异常、无路径穿越；20,616B非空本轮增量`source-increment.patch`。全部检查在Reviewer当前容器上读取真实上传字节完成。
- **源码identity**：ZIP五个修订源码及测试的本地`git hash-object`真实结果，与GitHub本HEAD逐一匹配：`cws_media.py=f34f5c755ac94888e6171922e6a12732fffed15f`，`safe_proxy.py=20ef50bdd5fcc9b5bd2b69afbaba86878b09e118`，`tests/test_cws_media.py=ce0618a51d19a6fa8378ef7710ab9f2a0e6598c6`，`tests/test_integration.py=da784098650b872fb01971287aa2ab6830c806b0`，`tests/test_safe_proxy.py=8e4bee22a2054bbbd2fe4a7ddd7a9b5ed44b35df`。第六个未变的`media_pipeline.py`延续PR原实现。
- **真实音视频QA再现**：ZIP`media/nasa_svs_5582_technical_canary.mp4` 2,669,379 B，Reviewer独立SHA256`5dfc7ff258428e5c09c15f809792af9f1fc285d459bdfc2c407a24351d1de1d6`；独立FFprobe实际统计`1920×1080, H.264, 60fps, 23.366667s, 1402 decoded frames, no audio`；FFmpeg`-nostdin -v error -xerror -i ... -f null -`**全片解码exit 0**。实看提供帧为OSIRIS-APEX轨道动画，**不等于爆米花视频素材匹配或版权PASS**。
- **网络真实路径**：`evidence/nasa_primary_safe_head.json`记录NASA 5582直链HTTPS HEAD响应`200`、`video/mp4`、`Content-Length=2669379`、无Location、数字公网`169.154.143.10:443`CONNECT、源主机名`svs.gsfc.nasa.gov`TLS SNI与证书验证通过/TLS1.3，另有IPv6公共DNS地址。`evidence/safe_fetch_command_record.json`记录Owner Windows上的CWS `fetch --safe-direct --ids video-f7edc3186943db35fb2e`、显式loopback HTTP代理、exit0和`FULL_DECODE_PASS`结果，真实文件字节/SHA精确相等。**Reviewer独立复检文件、源码、执行证据，但未进入Owner Windows直接抓包/重跑网络；真实CONNECT仅由Executor现场脱敏证据支撑**。
- **修复F159-01**：`cws_media.py`当`args.safe_direct`明确禁止旧`cached_result()`成功捷径，排除旧普通yt-dlp/图片缓存被误报为本轮安全代理下载。真实CLI子进程回归用例验证旧正常缓存返回CACHED而`--safe-direct`在拒绝代理下失败，不覆盖旧媒体。
- **修复F159-02**：`safe_proxy.py`的单一`time.monotonic()`截止贯穿DoH→固定公网CONNECT→TLS握手→HTTP header→body socket read，慢滴流时检测绝对deadline并关闭底层TLS；对应分层与CWS完整流用例验证慢响应失败并删除part。**回归证据**：Executor Windows本机84/84测试PASS及AST/diff-check记录；Reviewer由ZIP独立运行`test_safe_proxy.py`全部**13/13 PASS**，未重跑Owner Windows全部84项。GitHub当时无关联Actions Workflow/commit statuses，`CI=NOT_REPORTED`。
- **执行诚实性**：报告记录起初指错`.local/workdir`得到`NOT_IN_CATALOG`，此项发生于下载前；该初次尝试原始stdout/stderr未完整留档，所以Reviewer不能独立证明全历史GET次数，但这不影响后续实际下载媒体文件的真实性，不能将首次目录失配误报为下载失败。

## Reviewer附加小问题：F159-03 非阻塞清理兼容性

Reviewer在Linux/Python 3.13复跑13项单元测试时，**两条期限超时模拟场景在`HTTPResponse`对象清理时出现`Exception ignored in HTTPResponse.close`和`AttributeError: '_DeadlineSocketReader' object has no attribute 'flush'`**；测试仍13/13 OK，真实NASA全片解码没有受影响。`_DeadlineSocketReader`为`http.client.HTTPResponse`提供`read/readline/close`，未提供底层`IOBase.close`期间可能使用的`flush`文件接口。已有`open_response.finally`会关闭真实TLS，因此目前无安全边界失效证据，不过显式`response.close()`的调用可能暴露该异常，不能假装不存在。

**处理建议**：记`F159-03_MINOR_FILE_INTERFACE_CLEANUP`，**不推翻本轮已完成的媒体Canary PASS，也不要求重做下载或另起大Gate**。如后续准备合并PR，应在同一分支补极小的文件接口/显式响应关闭修复及对应一条用例，再核HEAD/CI/差异即可；未修前合并建议保持`MERGE_HOLD_MINOR_CLEANUP`。不得借此扩展到通用视频站点重构。

## 最终状态

| Gate/子项 | 最终Reviewer判定 |
|---|---|
| 真实ZIP及内部37项SHA | PASS |
| GitHub PR本Head源码身份 | PASS |
| Windows总测试记录 | `EXECUTOR_EVIDENCED_84_PASS` |
| Reviewer独立代理模块单测 | `PASS_13`，带`F159-03`兼容性提示 |
| F159-01缓存误报修复 | PASS |
| F159-02整体下载超时保护 | PASS（有真实代码路径+负例） |
| 非硬编码NASA HTTPS安全直链 | `PASS_SAFE_DYNAMIC_DIRECT_MEDIA_CANARY` |
| Reviewer真实视频SHA/FFprobe/FFmpeg | PASS |
| 泛用yt-dlp网页/playlist/CDN | NOT_VERIFIED / NO_OPEN_APPROVAL |
| 内容StoryFit/权利/制片/发布 | HOLD |
| PR合并 | 未授权/未执行（待极小F159-03及Owner后续决策） |

此前PR#157混合Fake-IP负例、PR#158固定Blender夹具技术PASS、PR#159旧PARTIAL的历史档案不被覆盖。本轮`CURRENT_GATE=NONE / REVIEWER_COMPLETE / NEXT_EXECUTOR_NOT_DISPATCHED`，等待Owner决定是否进行合并前最小清理或规划下一下载器功能Gate。
