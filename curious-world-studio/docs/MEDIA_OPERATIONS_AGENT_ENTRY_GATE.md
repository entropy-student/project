# CWS｜MEDIA-OPERATIONS-INTEGRATION：Codex统一素材工具

> **历史执行合同｜2026-10-15已完成并正式合并main，勿重复实施。** 技术Review `MEDIA_OPERATIONS_INTEGRATION_TECHNICAL_PASS_WITH_UPSTREAM_DEGRADATION`；[PR #131](https://github.com/entropy-student/project/pull/131) squash commit [`201c39a2`](https://github.com/entropy-student/project/commit/201c39a2b61eae7189cc624d5cb2c18dd671de38)。下述实施步骤保留供历史追溯，未来新需求要另立Gate。 本轮把已有的CWS搜索、筛选、按ID下载、FFmpeg技术QA和HTML素材库封装成**一个供Codex调用的轻量CLI**。不做给Owner操作的桌面GUI，不部署VPS或常驻服务，不重复G2 Ubuntu卸载，不做R6精准镜头匹配或PROD制片。

## 目标使用方式

现已合并的实际统一CLI示例（运行仍取决于本机工具和Docker就绪、搜索上游可能部分降级），从仓库根目录调用：

```powershell
python curious-world-studio/media-pipeline/cws_media.py doctor --json
python curious-world-studio/media-pipeline/cws_media.py discover --query "popcorn popping" --kind video --json
python curious-world-studio/media-pipeline/cws_media.py catalog --json
python curious-world-studio/media-pipeline/cws_media.py fetch --ids video-EXPLICIT_ID --json
python curious-world-studio/media-pipeline/cws_media.py gallery --json
```

- `discover`按需启动**本项目独有**的SearXNG+4get Docker Compose，分别真实搜索并去重、写入既有候选索引，在`finally`/Ctrl+C/异常清理中只停止自己启动且归属已确认的容器；**搜索不自动下载**。
- `fetch`只接受Codex明确选中的既有候选ID，复用现有`media_pipeline.py`的probe/download/download-image、格式方向过滤、次数/大小/时间限制、yt-dlp和FFprobe/FFmpeg校验；不需要重新启动搜索容器。Codex选ID前可按提示的题材要求自行阅读候选，但记录选择理由，不自动下载几十上百条。
- `catalog`和`gallery`不必启动Docker；`doctor`只做只读本机预检。所有状态返回有版本号的机器可读JSON、明确错误码/非零退出码、来源/候选ID/本地相对路径、内容/权利UNKNOWN；支持失败重试且不重复下载已经有校验的素材。
- 这是**供未来所有Codex制作流程调用的本地工具入口**，本轮不开发HTTP Agent服务、Electron、网页管理台或插件安装器，不要求Owner自己点击“搜索”。

## 实施与硬边界

1. 先读最新main`AGENTS.md`、`docs/CURRENT_STATE.md`、本合同和`media-pipeline/README.md`；保护原本未提交的3项tracked改动、2项缓存、旧媒体、Ubuntu备份tar；**在最新main的隔离分支/工作树开发**，PR交独立Reviewer，不得自行合并。
2. **复用现有已合并PR#129 Python模块**，不可另写第二套搜索索引、下载器、媒体格式过滤器或数据库。先定位上轮G3/G4 **真实运行过**的本机Compose文件、镜像版本、配置和缓存卷；最小迁入代码库的**非敏感模板**。找不到就报告`RETURN_PREVIOUS_COMPOSE_NOT_LOCATED`，不要猜容器接口或顺手重装。
3. Windows Docker Desktop/WSL2运行但无需后台常驻CWS：`127.0.0.1`绑定，独立Compose项目名，非restart-always，缓存卷持久化；仅停止自己拥有的容器，**不退出共享Docker Desktop后端，不停止其他项目**。端口冲突/归属不明就安全RETURN。禁止`docker system prune`、`down -v`、改Clash/VPN/系统代理、删除WSL或其它卷。
4. 单次`discover`应真实调用SearXNG/4get各自video/image或按请求类别的搜索接口；HTTP200不等于有效检索，保留上游引擎错误和每组结果数量。默认排除大陆视频平台、方形/竖屏（SAR/旋转后显示比例≥4:3）、未知待probe，优先1080p。
5. 如需浏览器播放技术回归，Codex使用**获许可的隔离测试浏览器**自动测视频加载、画面、`play()`和`currentTime`增量、关闭清理；不得操纵Owner私人Edge会话或绕过Computer Use明确安全停止；阻塞就`BROWSER_AUTO_NOT_VERIFIED`，不默认要求Owner反复手播。
6. 安全：只处理本地可信Codex决定的显式ID，不把工具开放为接受不可信URL的公网下载接口；PR#129并不构成完整SSRF隔离。媒体默认`UNKNOWN_TEST_ONLY`，不擅自用作正式频道镜头、上传原片到GitHub或申请版权PASS。

## 验收与交付

- 本机真实验证`doctor`、`discover`的Docker自动启动/两引擎非空检索/自动关闭，`catalog`与`gallery`无服务运行，`fetch --ids`只下载明确选中的有界公开视频并经FFmpeg完整解码+SHA；再次启动复用缓存。旧结果可用于回归但**不得冒充本轮真实搜索/下载**。
- 覆盖重复调用、已有容器与端口归属、Docker不在线、低内存/磁盘、部分搜索引擎失败、缺失ID、下载失败、用户Ctrl+C、异常退出/无残留、退出码和JSON schema。
- 在隔离分支提交**一个最小PR**（统一入口、必要Compose模板、单元/真实集成测试、一页README），不自行合并；本轮交**一个脱敏证据ZIP+外层SHA、内部SHA/manifest、运行日志/关键结果和Reviewer handoff**。不上传Ubuntu tar、原片、Cookie/代理凭据。
- **本轮已完成`MEDIA_OPERATIONS_INTEGRATION_TECHNICAL_PASS_WITH_UPSTREAM_DEGRADATION`并合并PR #131**；包括真实SearXNG/4get与Ctrl+C运行证据。请以本合同和Reviewer证据判断原授权范围，**不得将部分上游故障、素材内容或版权问题称为全量PASS**。MEDIA-R6/R7、PROD-R1~R4、`CW0005_VISUAL_STORYFIT_HOLD`均不改变。

历史基础：G2–G4 `G2_G3_G4_TECHNICAL_ACCEPT`，证据ZIP `CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip` SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`；这不意味着统一入口已经实现。
