# CWS｜yt-dlp 官方安装与 Wikimedia 下载失败｜Reviewer 证据复核 2026-10-11

> **证据类型**：Owner 提交的 ZIP `cws-ytdlp-download-test-20261011-144057-626034e7fb90.zip`，36 个条目；当前 Reviewer 直接读取 ZIP 中报告、JSON、stderr、许可页 HTML 与 API Release metadata；**无用户 Windows EXE 实体或本地机权限**。  
> **最终结论**：`INSTALL_VERIFIED_BY_OWNER_LOCAL_REPORT_AND_OFFICIAL_DIGEST`；`YTDLP_REAL_DOWNLOAD=RETURN_YTDLP_MEDIA_REQUEST_FAILED`；`MEDIA_DECODE=NOT_RUN`。不能升级为 yt-dlp 下载能力 PASS 或全网站可用。  
> **源**：2026-10-11 Owner 提交证据包；ZIP SHA256 `647faa22645f7958a852d54d26973031594640b32bf2293d1437063095385600`。实际用户 Windows 文件是否仍存在，须由本机重新读回，不凭 ZIP 猜测。

## 1. 安装阶段（有充分本机报告证据）

- GitHub 官方 REST Release `2026.08.19` 元信息 HTTP200：`yt-dlp.exe` asset ID `521488854`，文件 `17,840,399` bytes，官方 digest `sha256:66674953fe251b89f4d08c5f0e35e0728679bd67ab3d7d05c0562af101dd3e7a`。Reviewer 同时从**当前 GitHub 官方 Release API**直接核对了 tag/size/digest。
- Owner Codex 报告透过官方 REST release asset endpoint `Accept: application/octet-stream` 下载到：`C:\Users\34707\AppData\Local\curious-world-studio\tools\yt-dlp\2026.08.19\yt-dlp.exe`。
- `final-install-check.json`：本机读取可执行文件 SHA256 与上述官方值一致，大小一致，`--version` 输出 `2026.08.19`、exit 0。证据显示本机可用的**绝对路径**，而 `ytDlpOnPath=false`；不需要也未更改全局 PATH。
- **注意证据等级**：Reviewer 查阅了本机 Codex 的校验报告及官方 Release 元数据，**没有在 Reviewer 沙盒直接读取或对 Windows 已安装 EXE 重新计算哈希**；不能写成 Reviewer 直接操纵了用户电脑。

## 2. 解析与下载失败（有原始命令和 stderr）

- 官方 `https://commons.wikimedia.org/wiki/File:Daaruum.webm` 页面曾由本机 PowerShell 返回 HTTP200，缓存 HTML 有 `CC0 1.0 Universal Public Domain Dedication`；这是**该具体测试素材的许可证据**，不覆盖其他镜头。
- yt-dlp 针对 Commons 页面进行 `--dump-single-json --skip-download` 时，metadata 请求 `RemoteDisconnected`，exit 1，未成功得到格式/视频 URL；改 IPv4 仍失败。
- 针对同一素材官方 `Special:Redirect/file/Daaruum.webm` 以及其网页所列 `upload.wikimedia.org/wikipedia/commons/8/82/Daaruum.webm` 的 yt-dlp 获取：均为 `RemoteDisconnected`、exit 1，且均无真实媒体文件输出；切换同一地址的 UA/referer/IPv4 没改变结果。
- 一次独立 PowerShell `System.Net.Http` GET 诊断同一 Wikimedia 静态媒体地址得到 **HTTP 429**、`content-type=text/html`、长度 `2,074` 字节；**下载了0字节的可用媒体且没写任何 MP4/WebM**。429 说明该请求被限流，**不能推论根因必然为 Wikimedia 永久限流或所有网站下载不可用**；下载器错误与这个 HTTP429 是两类观测。
- 因没有视频文件：`videoFiles=[]`、无视频 SHA256、FFprobe/FFmpeg 视频解码/抽帧 `NOT_RUN`。若声明成功则属于错误升级。

## 3. 操作边界与质量

- 安装之后的测试没有改变系统代理、VPN/WG/HY2、PATH、FFmpeg、OpenMontage、M2 源码、GitHub；`activeRenderMatches=[]` 仅证明本地报告在所检查的时刻**没有命中匹配进程**，不能证明其他所有程序未运行。
- 本轮仅同一个被许可的测试素材，没有下载研究视频或另一个网站。重定向、UA、IPv4、静态地址尝试**较最初的单 URL 最小试验有多轮同源变体**；在连续近似失败后原则上应停止并记录症状，**不能无限重试**。
- 第一轮直连 GitHub Release 超时，后来通过官方 GitHub REST API 得到有效二进制。**工具安装完成，不应再次安装或重跑已经获证的官方哈希验证 Gate。**
- 目前没有证据能将远端断连归因于 yt-dlp 自身 bug、用户本地网络设置或某个代理配置问题，任何这类确诊都为越界推断。
- 本机保留：上述独立工具目录与 `C:\Users\34707\AppData\Local\Temp\cws-ytdlp-download-test-20261011-144057-626034e7fb90` 的调试证据；**未授权删除**。在正式视频前的清理盘点中，安装程序和有审查/回滚用途的原始证据须保留。

## 4. 下一步边界

- `YTDLP_INSTALL=COMPLETE_REPORTED_AND_CORROBORATED`，`YTDLP_METADATA=FAIL_ONE_WIKIMEDIA_SOURCE`，`YTDLP_DOWNLOAD=RETURN_YTDLP_MEDIA_REQUEST_FAILED`，`YTDLP_DECODE=NOT_RUN`。
- 不使用现有 M2-F1 日志只读诊断 Gate 来重试 yt-dlp；两者隔离。**未获新授权前，不再对该限流 URL 提交请求、不更改 VPN、不安装镜像工具**。
- 如后续确需取得一个视频，优先选择另一**来源许可明确、源站允许、体积受控**的测试素材，另列来源/权限/下载/哈希/FFmpeg 条件和 STOP。一个测试源成功只代表该来源路径通过，不说明所有网站可用。
- 新增的默认横屏和正式生产前受控清理 Owner 决策分别见 `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md` 与 `docs/PREPRODUCTION_CLEANUP_POLICY_2026-10-11.md`，均不允许提早清理或影响 M2-F1。
