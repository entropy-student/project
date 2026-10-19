# Curious World Studio｜PR #158 TUN/Fake-IP 受限代理兼容性独立Review（2026-10-19）

> **Reviewer正式裁决：`PASS_FIXTURE_PROXY_COMPAT`**。仅指**固定、明确HTTPS域名的Blender/Sintel MP4通过CWS自己的显式回环HTTP CONNECT代理、安全下载、FFprobe/FFmpeg/SHA全部通过**，**不是泛用媒体下载已修复**。`GENERIC_FAKEIP_MEDIA_DOWNLOAD=NOT_PASS`，旧`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH / VOICE_BY_EAR_UNVERIFIED`继续有效。

## 一、真实来源与独立验收

- Owner上传文件`CWS_MEDIA_TUN_FAKEIP_PROXY_COMPATIBILITY_REPAIR_20261019.zip`，本轮Reviewer从挂载的实际ZIP文件读取、检验解压：大小约4.2 MB，SHA256实际重算`d77fe84d82bfcb64567f1822de5426b74609181ee47943c9a22b99a0297e89f5`；22成员、`SHA256SUMS.txt`列21条Sha256并全部吻合、无CRC错误；对每个归档文件都确认解压路径未越界。
- **独立媒体验证**：ZIP内真文件`media/sintel_trailer-480p.mp4`，4,372,373 B，SHA256`b670602fa00934ca27c4351bb0efe7ea7a07fae57284e44226025eeed7c51254`；Reviewer自己调用FFprobe确认H.264 / AAC、854×480、24fps、52.208333s、1253帧，另以FFprobe`-count_frames`实际读回`nb_read_frames=1253`；自己调用FFmpeg`-v error -xerror -i ... -f null -`完整音画解码返回exit0；检查实际JPEG代表帧确实为Sintel动画画面，技术媒体真实存在，不只是Exit 0文字。
- **Owner Windows网络与程序过程**：`evidence/preflight_sanitized.json`、`dns_and_ytdlp_comparison.json`与`canary_cli_output.json`共同说明Exec主机TUN仍UP、系统代理DISABLED、ambient HTTP代理端口协议不符、实际回环代理通过HTTP CONNECT、主机DNS被判PRIVATE/保留Fake-IP、`_validate_public_url`对通用URL按预期拒绝、CWS子命令`canary-blender-fixture`真报告下载`4372373B`、标准本地QA返回`FULL_DECODE_PASS`。独立文件字节与执行报告精确一致，**但Reviewer没有连接Windows直接重跑系统代理/TUN或DNS观测**，不能冒充主机侧远程直接验证。
- **测试源码/日志**：ZIP附main基线日志60/60 OK和分支日志67/67 OK；GitHub真实PR #158只修改3个文件，新增七项对`mixed Fake-IP + public`在`probe_one`拒绝、私网/回环/保留IPv4/v6、非法SOCKS/非loopback/凭据/路径代理、固定URL/CLI非法URL、跳转、M3U8假MP4、大小上限、timeout等的测试。Reviewer亲自检查**PR实际源码、PR diff与日志**，不声称亲自在Owner Windows跑过67测试。
- **缺失非阻塞证据**：ZIP中`evidence/source-diff.patch`文件实际**0字节**，执行报告称“详情见该diff”不成立。但GitHub [PR #158真实源码差异](https://github.com/entropy-student/project/pull/158/files)可独立读取且已逐项核；因此记`EVIDENCE_PACKAGING_MINOR_EMPTY_DIFF`，不阻挡Scoped PASS，也不要求重跑下载。以后ZIP如diff生成失败应标注缺失而非将空文件当证据。

## 二、三个文件代码审查

| 代码路径 | 结论 |
|---|---|
| `media-pipeline/media_pipeline.py` | 增加固定`TRUSTED_BLENDER_FIXTURE_URL`与`download_trusted_blender_fixture`、`_validated_fixture_proxy`：显式127.0.0.1或::1 HTTP/无认证/强制端口；URL不接受用户控制；仅官方HTTPS固定地址，使用ProxyHandler、禁重定向，核精确HTTP200/Content-Type/长度、10MB最大单文件/读多1字节、MP4`ftyp`、已存在输出拒绝覆盖；额外`qa_media(...,local_only=True)`把FFprobe/FFmpeg协议名单限缩到`file`；原普通`_validate_public_url`不变。 |
| `media-pipeline/cws_media.py` | 增加**独立子命令**`canary-blender-fixture`，提供`--proxy`和只限该固定URL的`--max-bytes/--timeout`，无通用URL输入，无业务下载扩权；失败时json错误码清晰。 |
| `media-pipeline/tests/test_integration.py` | 新增7个本地正反向集成测试，包含PR#157的混合Fake-IP应被拒绝的等价覆盖；最危险反例（任意URL/混合DNS私网/跳转/超限）保持拒绝。 |

代码没有把`198.18.0.0/15`改判公网、没有为任意代理通道放宽通用`probe_one/download_one`安全门槛。固定受信URL经显式HTTPS HTTP CONNECT的安全边界不能自动推广到第三方任意网址；代理出口实际远端IP/分段媒体URL仍没有通用SSRF证据，后续必须单独设计或选择已有受支持的等价安全路径。

## 三、状态裁决与后续边界

- `PASS_ZIP_HASH_AND_FILE_INTEGRITY`、`PASS_REVIEWER_DIRECT_MP4_FULL_DECODE_1253_FRAMES`、`PASS_SCOPED_SECURITY_DIFF`、`PASS_EXECUTOR_TEST_LOGS_60_BASELINE_67_BRANCH`、`PASS_CWS_FIXTURE_ONLY_E2E`。
- `NOT_PASS_GENERIC_FAKEIP_MEDIA_DOWNLOAD`、`NOT_VERIFIED_UNTRUSTED_URL_PROXY_EGRESS_SSRF`、`RIGHTS_NOT_ASSESSED_FOR_PROGRAM`。
- **最终：`PASS_FIXTURE_PROXY_COMPAT`**，这个结论**不等于整条素材生产/发布流程PASS**。PR#155历史取材流程RETURN、PR#156搜索PARTIAL和PR#157回归测试局部受理都不追溯改写。
- [PR#158](https://github.com/entropy-student/project/pull/158) Head `ff613307e1ee67846786c00e42fa0a48719fcc52`，Review提交：[GitHub正式独立意见](https://github.com/entropy-student/project/pull/158#pullrequestreview-5571657456)。Review时`Open / NOT_MERGED / mergeable=true`；在最新main基础上1 commit ahead、1个文档commit behind。**按Gate不自行合并；等待后续合并决策或授权**。
- **重要身份**：独立yt-dlp本轮Generic解析到元数据但没有可用format，真正下载是**CWS固定夹具新子命令**，不得误认为通用yt-dlp/所有视频网站都能下载。
- 下一步不能反复测试本次已PASS的Blender路径，也不该再增加数百通用搜索URL。若Owner希望更进一步，另定边界解决「一般素材网址在Fake-IP+代理下安全访问/重定向/实际出口验证」，用已有适用下载适配器最小测试；不改变Clash/TUN和正式视频HOLD。
