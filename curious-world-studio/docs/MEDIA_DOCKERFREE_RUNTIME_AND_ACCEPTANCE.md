# CWS｜MEDIA 无 Docker 运行合同与整链验收（历史Gate，当前暂停）

> **2026-10-15 Owner最新决定：此文的“可部署Linux/VPS、安装原生SearXNG/4get、立即执行DF-G0~G6”执行授权已暂停。** Codex上轮执行被Owner强制中断；当前唯一允许动作是[ONDEMAND中断现场只读恢复与可行性评估](MEDIA_ONDEMAND_RECOVERY_AND_START_STOP_POLICY.md)，**不得按本旧Gate续跑、对VPS执行远程命令或部署、安装/停止Docker或共享服务**。旧DF验收表仅作未来若重新获批后的参考标准；`DOCKER_FREE_MEDIA_PIPELINE_PASS`依然未建立。

> **Owner授权启动 · 2026-10-15 · CURRENT GATE: `MEDIA-DOCKERFREE-ACCEPTANCE / NOT_YET_VERIFIED`**。前置代码PR #129已经在独立Reviewer集中修复验收后合并GitHub `main`（commit `10b369ee5558ed9a0ac2f738aea978623f62ba0f`）。本合同要求由Owner Windows本地Codex实测整个MEDIA链路**无需容器**，不是立即修改其他系统或宣称PASS的结果报告。与`MEDIA-R6/R7`和`PROD-R1~R4`分离。

## 1. 实施原则与现有边界

- 本轮验证的是**搜集素材、索引筛选、人工指定ID下载、FFprobe/FFmpeg完整解码、HTML真实播放**；不是输入选题自动完成分镜、TTS、渲染和发布。正式节目保持`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。
- 优先**复用已运行且确认无Docker依赖的SearXNG/4get**。仅发现二者运行于Docker时，不得把“Windows客户端使用原生Python”当作系统无Docker成功。
- 若搜索服务是容器：先盘点已有宿主与项目归属、PID/服务、监听地址、端口、凭据/登录（不输出敏感值）、CPU/内存和已有服务影响。**不得擅自停止任何已运行的共享Docker容器、停止Docker Desktop、迁移数据库、重置VPS网络或占用已有Web服务端口。**
- 如需要新部署：优先由Owner明确授权的**独立Linux非Docker环境**承载搜索服务（现有可用Linux主机/新隔离账号均可，但不能猜IP、凭据或服务器归属）；SearXNG可按官方Python venv/uWSGI指引原生部署，4get可按官方Apache/PHP-FPM指引原生部署。因安装可能涉及系统级依赖/端口/服务，**先只读预检；确认隔离、权限、依赖、资源、备份与回滚后才执行被明确授权范围内的安装**。无法证明隔离或缺管理员权限则`BLOCKED_NATIVE_SERVICE_SETUP`，不暗改共享系统。
- 不要求把SearXNG/4get装到Owner Windows；Windows运行CWS Python、yt-dlp、FFprobe/FFmpeg与仅127.0.0.1可访问的素材页即可。Linux搜索服务可经**用户授权并测试的SSH端口转发**映射成Windows本机127.0.0.1端口；不要新开公网访问端口，也不要猜已用端口。
- 外部媒体URL验证（私网DNS与HTTP重定向）是**有限保护，不是SSRF沙箱**。仍必须人工选择预览过的可信来源ID，遵循大小/数量/超时边界；不得构建公网搜索/下载代理服务或无限批量爬取。

参考官方、非容器部署文档（使用时以页面当前版本为准）：
- SearXNG: https://docs.searxng.org/admin/installation.html 及 https://docs.searxng.org/admin/installation-searxng.html
- 4get Apache/PHP-FPM: https://git.lolcat.ca/lolcat/4get/src/branch/master/docs/apache2.md
- CWS Windows命令入口：[MEDIA_PIPELINE_WINDOWS_USAGE.md](MEDIA_PIPELINE_WINDOWS_USAGE.md)，[源码和测试](../media-pipeline/README.md)。

## 2. 唯一被认可的全流程与证据

| Gate | 必须真实操作与证明 | 通过标准 |
|---|---|---|
| **DF-G0：环境只读盘点** | Windows运行环境、git main SHA/clean状态、Python版本/内存/磁盘；现有yt-dlp/FFprobe/FFmpeg版本；SearXNG/4get地址、进程/运行方式；是否容器、目前Docker依赖；资源/服务冲突 | 可判定无Docker路径及影响范围；不凭“没发现docker命令”推定成功 |
| **DF-G1：搜索引擎原生来源** | 对SearXNG、4get分别给出实际非容器PID/服务管理器、命令行、二进制/文件路径和绑定端口；需要远端服务时出具服务端原生进程/容器cgroup或等价证据及Windows端SSH本地转发映射；提供两者真正的API响应样本 | 两者均证实不由Docker/容器提供，API各返回至少一条真实非空、可解析结果；单纯HTTP200/HTML错误页不够 |
| **DF-G2：搜索与过滤** | 在Windows CWS `search`分别调用两种引擎（视频/图片），保存原始响应的脱敏样本、候选总数/去重、来源/驳回原因；离线验证大陆平台、外国竖屏、方形、SAR/旋转、未知画质等规则 | 外国横屏进入候选；大陆平台及非横屏拒绝；未知画质进入有限探测，未自动下载 |
| **DF-G3：真实下载与QA** | 至少2个不同的**实际海外视频托管源**，各人工选定一个公开视频ID，`probe`→`download`→FFprobe→FFmpeg完整解码→SHA/代表帧；另下载并解码1张真实图片。不得使用版权/认证限制源 | ≥2个不同来源技术下载成功、都符合≥4:3；视频完整解码0错误，SHA/大小一致；图片真实解码成功；必要时源可改但需保留失败记录 |
| **DF-G4：真实浏览器播放** | 由本机仅绑定127.0.0.1的临时HTTP静态服务打开生成的素材库（不要依赖被限制的`file:`浏览）；Edge/Chrome实际访问，逐个确认本地播放器可加载、播放、时间推进；保留非敏感屏幕/网络/播放证据 | ≥2个本地视频可在浏览器实际播放；不能用HTML存在/路径存在替代播放PASS；端口退出后仍可重新复现 |
| **DF-G5：独立性与资源审计** | 从G1启动到G4完成，服务与主CLI保持非Docker链；记录绑定端口、PID/cgroup/映射、资源峰值及回滚；如果已有其他项目容器在跑，须证明**本CWS链无依赖**，不得为凑“全机器零Docker”停止其他项目 | 无容器服务或Docker网络/卷依赖；证明无其他项目被影响 |
| **DF-G6：交付与独立Review** | 仅交一个证据ZIP（README、manifest、SHA、脱敏日志、源索引、实际帧、可浏览短样本、交接）。如修改生产代码另开分支PR且不得自行合并 | Reviewer对实际证据逐项复算，并按`PASS / PARTIAL / RETURN / BLOCKED`裁决 |

## 3. 验收失败时如何处理

- 若**任一搜索服务实际仍由Docker供给**，状态必须为`PARTIAL_DOCKER_DEPENDENCY`，不可冠以`DOCKER_FREE_MEDIA_PIPELINE_PASS`。
- 若服务器无法按授权部署原生服务，标`BLOCKED_NATIVE_SERVICE_SETUP`并列明隔离与权限阻碍。可先验证本机CWS子流程，不要伪造完整PASS。
- 若浏览器拦截`file:`，应在Windows仅127.0.0.1上临时服务静态目录再试；仍失败标`BROWSER_NOT_VERIFIED`，不谎报。
- 任何缺少视频实际内容、原片全解码、真实下载/权限证据的项按未验证记录。录像能观看/下载**不等于复用许可PASS**。
- 4get仅一页结果API已实现，分页不在本轮；NASA/Archive/ZDF历史失败不需要无限重试，必须保留原始失败而非虚报成功。
- 不改Docker引擎/系统代理、Clash、WireGuard、VPS其他服务、OpenMontage、Research Aqua、Remotion、题库、公开发布与PROD Gate。

## 4. 输出、保存与后续流转

- 执行标识建议`CWS-MEDIA-DOCKERFREE-ACCEPTANCE-20261015`；**目前还没有结果ZIP**。
- 输出一个`CWS_MEDIA_DOCKERFREE_ACCEPTANCE_<实际运行日>.zip`，包含：`README.md`（实际环境和命令、结果）、`evidence/runtime_proof/`（服务PID、系统单元/cgroup、Docker依赖判断）、`evidence/live_search/`、`evidence/download_decode/`、`evidence/browser_playback/`、`tables/`（候选与QA）、`handoff.md`、`manifest.json`、SHA清单。脱敏密钥、用户绝对路径、Cookie、代理和SSH凭据。
- **不得为了生成ZIP复制全部原始数据到Git**。仅高价值短样本入包，完整原片可本机留档并记录SHA和验证范围；Reviewer须明确区分真实独立全片解码与仅审阅执行日志。
- 正式协议（本文件）留在`main`，每轮执行报告/截图/临时HTML与原片留`.local`和Owner ZIP备份；Review后仅更新`CURRENT_STATE.md`、`REVIEWER_HANDOFF_CURRENT.md`等活状态，不为每轮新增大量报告页。
- **下一阶段MEDIA-R6精准动作匹配**，仅在本轮Review且Owner另行许可后开始；`PROD-R1~4`不因工具验收自动晋级。
