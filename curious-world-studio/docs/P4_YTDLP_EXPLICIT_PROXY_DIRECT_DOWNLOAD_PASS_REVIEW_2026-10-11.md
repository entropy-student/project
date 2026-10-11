# yt-dlp 第三轮｜代理协议不匹配及 Blender 直链真实下载 PASS（2026-10-11）

> Reviewer disposition: **`DIRECT_MEDIA_DOWNLOAD=PASS_ONE_SOURCE_WITH_EXPLICIT_PROXY`**, **`MEDIA_DECODE=PASS`**，**`YOUTUBE_PAGE_EXTRACTION=FAIL_SITE_SIGN_IN_CHALLENGE`**。已安装 yt-dlp 可继续使用；**不是所有视频平台下载 PASS，更不是对任意视频素材的授权许可证明**。  
> 旧支线 Wikimedia/Blender 首次请求 `RETURN` 属历史真实失败，不被事后改写；本轮属于新的局部修复成功。  
> Reviewer **在独立沙盒实际读取** Owner 上传的 MP4、五份报告/JSON 并核对哈希与真实媒体属性，但**没有在 Owner Windows 本机执行代理握手、yt-dlp 下载命令或新 wrapper**。

## 1. 上传材料与独立校验

Owner 在本轮上传的六个项目（文件名保留本轮实际名称）：

| Owner 上传文件 | 独立 SHA-256 |
|---|---|
| `sintel-trailer-480p.mp4` | `b670602fa00934ca27c4351bb0efe7ea7a07fae57284e44226025eeed7c51254` |
| `report(1).txt` | `9b03b8ad195e440f5be0478a626665d2c789f65eb4f8e2ade3c700badabed85d` |
| `proxy-preflight.json` | `33dc9d8300178a4917430b89537f52dfe9a23b97f83744b26980a4b72fa85c81` |
| `fixed-download-result.json` | `6c5b46bdf240c91f7944470f8ff687df11a29d640aa4d8e289dc2e7b2ec91a91` |
| `media-integrity.json` | `87f9fba1526fe763c5060f3c5295457283793a62db86be69049092bac1c566b9` |
| `ffmpeg-verification.json` | `45d589f9f058d549b720e11788dd73082ccb43988a88403d117361bef7d6ae02` |

Reviewer 在本轮运行环境使用现有 `ffprobe -v error -count_frames` **独立验证**：MP4 格式，4,372,373 B，时长 **52.208333s**，视频 H.264 **854×480、24fps、1253个解码帧**；另有 AAC **48kHz 双声道**（音频解码帧记录 2434）。`ffmpeg -hide_banner -v error -xerror -i uploaded.mp4 -f null -` 完整解码 exit **0**。真实 MP4 SHA256 与 Owner 报告及 `media-integrity.json` 精确一致。抽帧于 1/26/50 秒的三张 PNG 文件未被上传，**其成功状态仅由 Owner 提交的 ffmpeg-verification.json 报告支持**，不是 Reviewer 当前独立抽帧验证事实。

## 2. 故障原因与本轮有效修复

本地检测报告显示：
- 当前进程 `HTTP_PROXY` 以 **`http://127.0.0.1:10808`** 的 HTTP scheme 指向 `vcore.exe` 监听的端口，握手报告该端口支持 **SOCKS5** 而不响应 HTTP；HTTP **scheme/port protocol 不匹配**。`HTTPS_PROXY`/`ALL_PROXY` 未设置。
- Windows WinINET 用户代理为 `127.0.0.1:7897`；本机 `verge-mihomo.exe` 监听此端口，报告 HTTP CONNECT 与 SOCKS5 都可握手，是当前可用的 mixed local proxy。
- PowerShell 的受控 **Range GET** 对 Blender 同一个 480p 文件返回 **206 Partial Content**、只读取 **65536 B**，本机报告该 PowerShell .NET 请求实际绕过代理直连。**这与之前仅 HEAD200 的对照不同**，也不能将独立 PowerShell 路径等同于 yt-dlp 路径。
- 针对 `https://download.blender.org/durian/trailer/sintel_trailer-480p.mp4`，本地 Codex 报告使用**原有 yt-dlp 2026.08.19**，明确加 `--proxy http://127.0.0.1:7897`，结合 `--ignore-config --no-playlist --no-overwrites --max-filesize 30M --socket-timeout 15`、零重试，下载 exit **0**。新输出由 Reviewer 独立读入及解码验证成功。
- 因而**错误配置的 HTTP_PROXY scheme/endpoint 与此前未显式指定正确 HTTP 代理，是明确证实的配置差异**；使用当前正确 HTTP 代理的调用路径对该文件**确实修复成功**。但没有完整旧 yt-dlp 网络 socket trace，不能单凭对照实验证明每一条旧 RemoteDisconnected 都只由同一个内部故障造成，也**不要改动**当前 VPN/代理/系统配置来追溯此事。

## 3. 许可、剩余限制与交付脚本

- 官方 Sintel 素材据 Owner 本机报告指向 Blender [download](https://durian.blender.org/download/) / [sharing](https://durian.blender.org/sharing/) 并说明为 **CC BY 3.0**。**这些站点在 Reviewer 本轮在线抓取不可用，未单独网页核验**；因此正式引用必须针对所使用的视频文件、分发/片尾/署名约束作最终确认，不能因为测试时合法便假定全部内容可随意复用。
- 官方 Blender YouTube 预告片采用同一明确代理后的**metadata-only** 请求，得到了 `Sign in to confirm you're not a bot` 挑战；`YOUTUBE_PAGE_EXTRACTION=FAIL_SITE_SIGN_IN_CHALLENGE`，**无 Cookie、未登录、未绕过、未下载**。此站点问题应与直接 MP4 URL 测试**分开**；不为打通它而绕过站点限制。
- Owner 本机 Codex 报告新建 `C:\Users\34707\AppData\Local\curious-world-studio\tools\yt-dlp\cws-ytdlp.ps1`，本机 SHA `033CD4300DE3A3289C220DC4B843D7B551E52145653AE9E13504244567B42649`，语法检查通过，固定调用既有 EXE 和本次成功的 `127.0.0.1:7897` HTTP 代理；但 Reviewer **没有收到脚本字节、没有独立 code review，也未以它实际下载一份视频**，所以只记 `WRAPPER_CREATED_AND_SYNTAX_CHECKED_OWNER_REPORTED`，**不能升级成 `WRAPPER_END_TO_END_QA_PASS`**。
- 混合端口 7897 是**当前时刻本机实际检测**，不是跨机器或节点永久常量。后续运行脚本前核对 Clash Verge 的监听端口及 HTTP 协议，勿自动改全局 `HTTP_PROXY`、Clash 设置、VPN/WG 或要求系统环境永久变化。
- **本轮对本机安全的断言来自本机报告**：无安装/升级、未改系统 PATH/VPN/DNS/Clash 等、未更改主线源码；Reviewer 不称直接观察所有 Owner 主机操作。

## 4. Reviewer 结论及项目分工

| 能力 | 新状态 |
|---|---|
| yt-dlp 已安装版本与官方哈希 | `PASS_EXISTING`（本机报告+先前官方 Release 哈希交叉核验） |
| Blender 官方直链实际下载 | **`PASS_ONE_SOURCE_WITH_EXPLICIT_PROXY`** |
| MP4 完整哈希和完整解码 | **`PASS_INDEPENDENT_REVIEWER_MEDIA_QA`** |
| 三张 PNG 抽帧 | `PASS_OWNER_REPORTED`，文件未上传 |
| CWS wrapper 可复用 | `CREATED_OWNER_REPORTED`，未独立源码/真实调用验收 |
| YouTube 受挑战页面元数据 | `FAIL_SITE_SIGN_IN_CHALLENGE`，不绕过 |
| 正式内容全自动素材搜集 | `NOT_PROVEN`，还需每个真实选题素材来源/版权/适配 |

**支线本轮可结束测试**。以后有具体研究素材 URL 需要视频获取时，先判断许可是否允许，再用已验证的绝对路径及本机有效的显式 HTTP 代理方案；没有必要继续重复通用下载测试，更不能把 YouTube 挑战当作阻止所有正式素材生产的前置 Gate。

**主线是独立状态**：截至本轮 GitHub main 的现行记录，F2 有真实9秒 MP4 成功并完成独立 QA，M2 五文件补丁仍**待正式代码 PR 审查/合并**；正式 G1/G2 尚未通过。主线下一步不因支线下载成功而改变。正式首期源视频默认横屏，正式生产前受控清理仍须另行授权、保留日志与证据。
