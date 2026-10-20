# CWS｜PR #159 Owner重新上传附件后独立复审（2026-10-20）

> **技术Gate正式结论：`PASS_SAFE_DYNAMIC_DIRECT_MEDIA_CANARY_SCOPED`；整体项目仍为 `PARTIAL / HOLD`；PR 合并建议：`MERGE_HOLD_F15903_AND_OWNER_AUTH`。** 本次为全新Reviewer从Owner新上传ZIP原始字节开始的独立复核，不沿用先前PASS。没有修改生产源码、没有重启Executor、没有合并PR或正式制片。

## 1. 身份、授权及基线
- 仓库：[entropy-student/project](https://github.com/entropy-student/project)，GitHub本轮读取到main先为 `a81eadde4ba29f69d4e6919d7615e5c4754f0da6`；相对交接main `f773ab95f0378acbd9c4af9c4d6e5a3d480e9ee4` 的唯一增量仅第三板块知识库文档，未改变CWS代码。
- [PR#159](https://github.com/entropy-student/project/pull/159) Head `bfddbbf86c9d5fa9a8c93513c1ea5c2d7b62dea8`，仍OPEN、未合并、mergeable=true，六文件；3 commits（`38f8183`、`59f427d`、`bfddbbf`）。[PR#157](https://github.com/entropy-student/project/pull/157) 和 [PR#158](https://github.com/entropy-student/project/pull/158) 仍OPEN/未合并，分别是混合DNS负例测试和固定Blender夹具代理技术路径，不将其独立PASS扩大为一般下载。
- 治理规范：`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7；本轮权限仅Reviewer审核及结论归档，旧执行Gate已关闭。

## 2. ZIP实测与历史PASS交叉核验
| 核验点 | 本轮Reviewer亲自执行 | 历史是否一致 |
|---|---|---|
| ZIP身份 | Owner重新上传 `CWS_PR159_CACHE_DEADLINE_REAL_SMALL_MEDIA_CANARY_20261020(1).zip`，实际2,732,845字节，SHA-256 `dd2875f7adf2ce3f41cf948267b54c27ab5bd11824691058d68d22b78b1f0ae5` | **SAME_BYTES**，整个ZIP SHA相同，非仅同名 |
| 压缩包健康 | 38成员；ZIP CRC `testzip=None`；37/37 SHA256SUMS匹配，未见路径穿越或symlink风险 | 一致 |
| 非空源码增量 | `source-increment.patch` 20,616字节，审查旧 `59f427d` → 新 `bfddbbf` 1提交/5文件增量 | 一致 |
| ZIP五份Git源码/测试 | `git hash-object` 分别为 `f34f5c755ac94888e6171922e6a12732fffed15f`、`20ef50bdd5fcc9b5bd2b69afbaba86878b09e118`、`ce0618a51d19a6fa8378ef7710ab9f2a0e6598c6`、`da784098650b872fb01971287aa2ab6830c806b0`、`8e4bee22a2054bbbd2fe4a7ddd7a9b5ed44b35df`，与GitHub HEAD逐一一致 | 一致 |
| 第六个文件 | 从GitHub独立获取 `media_pipeline.py`；新旧HEAD Blob均 `1dea21e2764c2f8169b07e7d3ac43dbd1c610390`，本次小补丁没改此文件 | 完成本轮六文件核验 |
| 下载媒体 | ZIP内MP4 2,669,379字节，独立SHA `5dfc7ff258428e5c09c15f809792af9f1fc285d459bdfc2c407a24351d1de1d6` | 一致 |
| FFprobe | H.264、1920×1080、60/1fps、23.366667s、0音频、`-count_frames`=1402 | 一致 |
| FFmpeg | 本Reviewer独立 `ffmpeg -nostdin -v error -xerror -i <mp4> -f null -`，exit0且stderr空；另从原MP4提取9秒帧并肉眼确认为OSIRIS-APEX轨道图 | 一致 |
| Windows全量单测 | ZIP的 `evidence/unittest-final.log` 显示84/84 PASS，**仅Executor日志证据** | 未在Owner Windows独立运行 |
| Reviewer独立单测 | 本轮 `python -m unittest -v test_safe_proxy` **13/13通过**，同时两次出现F159-03清理异常；再运行3项额外本地独立测试（多种保留地址拒绝、真实socketpair慢滴流、显式close缺flush）均PASS | 13/13一致，缺陷更明确 |
| 网络流量 | 读回 `nasa_primary_safe_head.json`：Executor报告HTTP200、video/mp4、2669379B、无Location、公网 `169.154.143.10:443` CONNECT、原始域名 `svs.gsfc.nasa.gov` TLS SNI与证书验证、TLS1.3；读取真实CWS `safe_fetch_command_record.json` exit0+QA+SHA | **EXECUTOR_EVIDENCED**，未进入Owner Windows自行抓包重现；不能把JSON变成直接网络观测 |
| CI/合并性 | 本轮GitHub读回无关联Actions运行、0 check runs、0 commit statuses；mergeable=true | **CI_NOT_REPORTED ≠ CI_PASS** |

## 3. 六文件核心代码独立判断
1. `cws_media.py`：第413行 `cached=None if args.safe_direct else cached_result(...)` 已阻断旧普通下载的缓存捷径。第418–430行校验视频种类并路由到safe-direct，不借yt-dlp提取成功虚报；同名已存在输出在 `media_pipeline.py` 第658–663行fail-closed。普通下载旧SHA缓存路径未改变。ZIP真实CLI负例日志是Executor证据；本轮单独源码复核，不冒充当前容器跑通完整CLI。
2. `media_pipeline.py`：第602–724行仅接受catalog筛选后、已知横屏尺寸的单文件HTTPS视频，显式代理，单文件≤30,000,000B，累计≤60,000,000B；状态仅HTTP200、视频MIME/容器签名、identity编码、长度上限通过后创建 `.part`；拒绝301/302及意外存在文件；失败时清理 `.part` 和本轮已创建目标；第548–596行用本地file协议白名单FFprobe/FFmpeg及完整解码。该文件来自GitHub HEAD，不存在于ZIP五份源快照中。
3. `safe_proxy.py`：第110–158行严格HTTPS域名、443、无IP字面量/凭据/敏感query、回环HTTP代理；第308–348行独立DoH A/AAAA、递归CNAME和混合公网/私网拒绝；第166–234行通过已验证公共数字IP执行CONNECT，TLS仍使用原域名SNI及默认系统CA/hostname验证；第235–369行拒绝其他HTTP方法、禁自动跟跳转，并用单一monotonic deadline覆盖DoH→CONNECT→TLS→header→body。未放宽通用yt-dlp路径的普通DNS拦截；无显式子manifest/分片下载支持。
4. `tests/test_cws_media.py`：本次新增原普通视频+图片旧缓存，CLI safe-direct无法复用而误报的负例；保持普通缓存命中语义。
5. `tests/test_integration.py`：本次新增safe-direct慢滴流累计超时、部分文件清理负例，并保留redirect、cap、QA与FFmpeg file-protocol白名单。
6. `tests/test_safe_proxy.py`：本次新增慢status与慢body的期限负例、已验证公网IP CONNECT及CA/SNI、混合DNS/CNAME等安全负例；13项本轮实际独立运行PASS。

## 4. F159缺陷和证据分级
| 编号 | 级别 | 证据/反例 | Reviewer结论和最小动作 |
|---|---|---|---|
| **F159-01** | 原Blocking，现已修 | `cws_media.py:413` 不再从旧 `FULL_DECODE_PASS` SHA缓存返回安全模式成功；Windows CLI负例报告普通缓存=CACHED、safe-direct+拒绝代理非零且不损坏旧媒体 | **FIX_ACCEPTED**，没有理由重构缓存 |
| **F159-02** | 原Blocking，现已修 | `safe_proxy.py:28-107,166-369` 绝对deadline传播；本轮亲自在socketpair持续滴流中验证deadline中止，且仓库有部分文件清理负例 | **FIX_ACCEPTED**，仅这一单文件网络路径 |
| **F159-03** | 对本Gate Non-blocking；对合并清理建议HOLD | `safe_proxy.py:37-107,251` 自定义 `_DeadlineSocketReader` 缺 `flush()`。Python3.13中两项既有单测出现 `Exception ignored in HTTPResponse.close`；本轮显式 `response.close()` 又独立复现同一AttributeError | **REPRODUCED**。第369行finally调用底层`tls.close()`，当前没有证明逃过SSRF守卫或实际网络连接遗留；但清理异常真实存在。仅在同PR补完整文件接口或显式可靠close+1条回归，不改协议架构、无需重新下载NASA |
| **UNKNOWN-01** | 证据限制 | 首次CLI错workdir只留摘要JSON，原始stdout/stderr不完整；结果记为 `NOT_IN_CATALOG`，但无法独立核对全历史网络GET次数 | 不以此伪造“确证只有一次请求”；不影响真实媒体与最终成功命令的内容实测 |
| **UNKNOWN-02** | 环境限制 | 无法连接Owner Windows原代理/TUN，`169.154.143.10` CONNECT及证书身份来自执行端脱敏材料 | 明确 `EXECUTOR_EVIDENCED`，非本Reviewer现场网络抓包；若要求强审计，可下一轮只读补原始脱敏网络记录，但**不需要重做媒体GET** |
| **UNKNOWN-03** | 环境限制 | ZIP缺独立完整 `media_pipeline.py` 及运行依赖的整仓工作树；本轮仅完整独立运行13项代理测试和3项新反例，Windows84来自执行端 | 不能称 `REVIEWER_RAN_ALL_84`，GitHub HEAD已补齐第六个代码来源和读审 |

### 其他安全判断
- 当前safe-direct没有通用网页提取、CDN manifest、多分段请求或自动HTTP重定向；因此不存在“所有yt-dlp网站已修复”的可接受主张。
- URL和安全DNS均fail closed；本轮额外测试保留/私网IPv4+IPv6、metadata `169.254.169.254` 与Fake-IP `198.18.x.x` 混合公共DNS答复被拒。代理内部实际转发路径无法在离线Reviewer机器上直接证明。
- `manifest.json`、程序/网络证据、ZIP清单未发现明文密码、Bearer、私钥或cookie；零长度stderr文件是有限证据而非“全过程网络完全无异常”的证明。

## 5. 结果、合并建议、下一步
- **结果：`PASS_SAFE_DYNAMIC_DIRECT_MEDIA_CANARY_SCOPED`。** 再次独立验证真实NASA MP4完整可解码、源码身份、绝对截止和主要安全路径，支持“catalog动态HTTPS单文件MP4/WebM直链技术能力已实现”这一**受限**结论。节目整体仍是`PARTIAL/HOLD`。
- **合并意见：`MERGE_HOLD_F15903_AND_OWNER_AUTH`**。GitHub显示当前代码可合并只说明Git层面无已知冲突，零CI不可充当通过；先完成同PR最小F159-03清理和直接对应单测，再由Reviewer核最新Head/此类回归/必要可用CI，Owner明确批准后才可合并。本轮没有合并授权。
- **最小下一步：** 一项小的HTTPResponse文件接口/显式close修复 + 1条失败清理测试 + 相关已接受13项与能运行的既有测试 + 最终HEAD/CI读回。**不重做NASA下载、Blender、274页搜索，不再研究整套SSRF设计**。
- **冻结边界**：`CURRENT_GATE=NONE`、`NEXT_EXECUTOR_NOT_AUTHORIZED`、`CW0005_VISUAL_STORYFIT_HOLD`、`G1_NOT_PASS`、`G2_NOT_AUTHORIZED`、`R4_NOT_AUTHORIZED`、`RIGHTS_PARTIAL`、`NO_PUBLISH`、`VOICE_BY_EAR_UNVERIFIED`；NASA仅 `UNKNOWN_TEST_ONLY`，绝非爆米花节目正式可用素材。未修改Owner Clash/TUN/DNS/全局网络。
- 历史[旧PARTIAL](CW0005_PR159_GENERAL_SAFE_PROXY_EGRESS_INDEPENDENT_PARTIAL_20261019.md)和[旧PASS](CW0005_PR159_SAFE_DIRECT_REAL_MEDIA_INDEPENDENT_PASS_20261020.md)均完整保留；本报告是Owner要求的**重新完整审核后的新审查记录**，不重写历史。

## 6. 本次Reviewer独立运行记录（可复算命令）
```text
python: 3.13.5
sha256(zip), ZipFile.testzip(), SHA256SUMS 37/37, git hash-object five snapshots
python -m unittest -v test_safe_proxy                  => 13 OK; 2 cleanup warnings
python pr159_reviewer_focused_tests.py                 => 3 OK (12 reserved-address subcases + slow socketpair + explicit close)
ffprobe -v error -show_entries stream=... -of json ... => H264,1920x1080,60/1,0 audio
ffprobe -v error -select_streams v:0 -count_frames ... => 1402
ffmpeg -nostdin -v error -xerror -i <file> -f null -  => exit 0, stderr 0 bytes
ffmpeg -ss 9 -i <file> -frames:v 1 ...                  => inspected real orbital frame
```
