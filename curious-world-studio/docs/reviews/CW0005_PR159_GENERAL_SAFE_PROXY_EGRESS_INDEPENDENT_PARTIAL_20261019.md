# CWS｜PR #159 动态素材URL安全代理出口独立审核（2026-10-19）

> **正式Reviewer结论：`PARTIAL_SAFE_PROXY_EGRESS_VERIFIED_NO_MEDIA_CANARY`。** 定向代理IP固定CONNECT、SNI/TLS证书验证及大小/重定向安全停线有可信证据，**但没有任何真实新媒体文件、全片解码或SHA，也无通用yt-dlp页面提取PASS**。新增两处最小代码缺口须先补强，**`MERGE_HOLD_MINIMAL_CORRECTIONS`**。之前PR#158仅固定Blender夹具`PASS_FIXTURE_PROXY_COMPAT`保留；CW0005`VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH`均不改变。

## 一、审核来源与独立读回

1. [PR #159](https://github.com/entropy-student/project/pull/159)，HEAD `59f427d37591d2c6c8aa67033ddc4cfe401a933a`，来自main基线`9ad183e5c2cd2ba6d0ad36a304ca4314278b646a`，审核时OPEN、mergeable、NOT_MERGED，实际差异六文件：`media-pipeline/cws_media.py`、`media_pipeline.py`、新增`safe_proxy.py`及三份相关测试。新直链分支未替换旧`_validate_public_url`/yt-dlp网页提取器，未调整Clash/TUN/DNS/系统代理。
2. Owner实际上传`CWS_MEDIA_GENERAL_FAKEIP_SAFE_PROXY_EGRESS_20261019.zip`。Reviewer独立重算外层SHA256 `2effd016b53667d6c6dd4156bf312cf6bfb252142d86c4eb98b07a2cefadfe07`，字节数26,129，**14成员/13项SHA256SUMS全部核对PASS**，完整ZIP CRC无错误；`source-diff.patch`长50,729字节，并非上一轮空diff。
3. Reviewer从ZIP diff重建新增`safe_proxy.py`，Windows CRLF重建得到Git Blob SHA `a12cc9b40c062c0166a2dc1afbe387d9bb9f95c3`，与PR真实模块Blob**完全一致**。同时提取该文件和`test_safe_proxy.py`至隔离目录，**Reviewer独立执行11/11项该模块测试PASS**（`python -m unittest -v test_safe_proxy`）；**整套80项Windows测试、6模块语法测试及diff-check结果来自Executor真实日志**，不是Reviewer在Owner Windows重跑。GitHub本HEAD未报告Actions runs/commit statuses，`CI=NOT_REPORTED`。
4. 本次没有得到媒体源文件，Reviewer无法自行FFprobe/FFmpeg或哈希验证NASA/JPL的实际视频正文，故`MEDIA_BODY_QA=NOT_RUN`绝不写PASS。原始DNS精确IP、端口与Clash内部真实转发均经Owner侧脱敏，Reviewer核代码与记录，不谎称能够独立监听Owner出站连接。

## 二、冻结的事实统计与裁决

| 项目 | 证据 | Reviewer结论 |
|---|---|---|
| 本机内存与TUN | Executor日志报告4707MiB可用、TUN UP，不改网络系统配置 | `HOST_REPORTED_OK` |
| 动态直链代理路径 | `safe_proxy.py`固定Cloudflare 1.1.1.1公网DoH TLS引导，A/AAAA和CNAME递归检查全局IP；CONNECT请求数字公网IP，原hostname用于TLS SNI/CA/证书名，HTTP Host保持原名；拒绝HTTP/IP字面量、本地后缀、含凭据/sensitive query | `CODE_POLICY_PASS_SCOPED / LIVE_CONNECT_TLS_EXECUTOR_EVIDENCED` |
| 真实NASA SVS HEAD与CWS GET | [NASA SVS页面](https://svs.gsfc.nasa.gov/5101/)，已记录200`video/mp4`、`Content-Length=87,626,655`，CWS真实`fetch --safe-direct`上限`30,000,000`B，返回`SAFE_RESPONSE_SIZE_LIMIT`，记录正文`0`B | `PASS_FAIL_CLOSED_SIZE`，不是媒体下载PASS |
| JPL第二候选 | HTTPS头部HTTP301，未跟随，实际下载`NOT_RUN`；内容权利UNKNOWN | `PASS_NO_UNVALIDATED_REDIRECT`，不是媒体PASS |
| 真实新媒体 | 0文件，`FFprobe/FFmpeg/SHA=NOT_RUN` | `NOT_PASS_MEDIA_CANARY` |
| 通用yt-dlp/多CDN视频 | 原`probe_one/download_one`仍走严格本地DNS守卫，新path只支持单段MP4/WebM | `GENERIC_EXTRACTOR_NOT_VERIFIED` |
| PR状态 | OPEN、NOT_MERGED、mergeable；独立[Review意见](https://github.com/entropy-student/project/pull/159#pullrequestreview-5572746741) | `KEEP_OPEN_MERGE_HOLD` |

## 三、源码审查发现的两项最小缺口

**F159-01 `SAFE_DIRECT_CACHE_TRANSPORT_PROVENANCE_GAP`｜实际CLI缓存捷径可能产生误报。** `media-pipeline/cws_media.py`的`fetch`循环先调用`cached_result(workdir,key,item)`，然后才分流`args.safe_direct`、媒体种类、代理安全网络调用。该缓存函数只看`status=FULL_DECODE_PASS|IMAGE_DECODE_PASS`、文件路径、既有SHA匹配，**不校验产生缓存时的transport类型**，也不会确保新`--safe-direct`命令实际走安全路径；返回`status=CACHED`且没有`success=false`，最终`failed`只检查`status=FAILED`或显式`success is False`，因此**旧普通yt-dlp下载的已校验媒体缓存能够使`fetch --safe-direct`返回整个命令成功，但没有发生所声称的安全代理请求**。这是验收来源/执行报告缺口，不是触发私网请求的新SSRF漏洞。最小改法：在safe-direct模式只接受同传输方式且有可核验transport/proof记录的缓存，或直接跳过跨传输缓存；先按CLI模式校验video和显式loopback proxy，新增真实`fetch`分支负例，禁止旧缓存冒充safe-direct网络PASS。

**F159-02 `SAFE_DIRECT_WALL_CLOCK_TIMEOUT_GAP`｜总耗时守卫不足。** `safe_proxy.open_response(..., timeout)`给socket单次操作设等待上限；`download_safe_direct_candidate`的正文循环以固定字节上限读取，但没有在循环中比较整体运行`time.monotonic()`与绝对deadline。若远端长期每次socket超时之前发送少量字节，单次读取从不超时但总耗时可以远远超出指定`--timeout`。已有单元测试覆盖一次读超时/清理，不覆盖慢速滴流累积总耗时。最小补强为整个下载含DoH/CONNECT/本体的明确wall-clock截止策略，有限最小实现加连续慢速响应负例；不为了修这里扩展特权代理或替换全部网络模块。

两处改动属于**正式合并前的必要小修**，不会改变本轮已记录的NASA大小拒绝、JPL重定向拒绝及公网IP绑定位点测试结论。未发现代码直接调用外部未知URL绕过普通yt-dlp的`NON_PUBLIC_MEDIA_ADDRESS`拦截；程序新增独立`fetch --safe-direct`模式，不得以为“普通网页型候选视频全部可用”。

## 四、下一轮最小决议建议（本次Review不自动授权执行）

- **仅补F159-01/F159-02相关代码和回归测试**；保留PR#159已有六文件和80项测试成果，PR仍留在隔离分支；不反复重做Blender或泛化搜索274 URL。
- 对真实媒体Canary先从**官方已有的低分辨率/较短版本、相同已知可信渠道**小范围挑文件：在已验证的安全HTTP HEAD下确认`HTTP200`、`video/mp4`或`video/webm`、`Content-Length≤30MB`且不301/302，再按照catalog ID经CWS安全路径实际获取**最多一段新非Blender**，保存文件并完成FFprobe/FFmpeg完整解码/真实画面/文件SHA。当前NASA文件`87.6MB`不能偷涨额度，JPL的301不能偷跟跳转。
- 安全负例、缓存来源隔离、绝对总超时、动态源真实下载QA和新PR Head最终确定后再由独立Reviewer裁决`PASS_SAFE_DYNAMIC_DIRECT_MEDIA`或精确RETURN。**即使单段直链PASS，yt-dlp普通网页提取、分片/CDN、节目版权与G1/G2/R4依旧独立。**
- 本轮`CURRENT_GATE=NONE / REVIEWER_COMPLETE / NEXT_EXECUTOR_NOT_AUTHORIZED`，旧PR#157/#158已受理事实和未合并状态不动；不自行merge或重新发布。

此报告与[PR#159独立审查意见](https://github.com/entropy-student/project/pull/159#pullrequestreview-5572746741)共同构成本轮权威`Reviewer Evidence`。
