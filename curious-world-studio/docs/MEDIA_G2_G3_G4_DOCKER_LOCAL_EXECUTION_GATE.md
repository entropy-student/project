# CWS｜G2–G4 Windows Docker按需素材整链：执行与验收合同

> **Reviewer结果补充（2026-10-15，覆盖此文下面的AWAITING/预案描述）**：`G2_G3_G4_TECHNICAL_ACCEPT`，ZIP SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`。G2备份/注销和Docker后端健在以执行端日志证明（备份TAR本地保留、Reviewer未作恢复）；G3四组API真实非空、Compose完成停止/复启/最后关闭；G4同PeerTube技术家族的两个不同托管站点视频、Unsplash JPEG均通过了Reviewer独立完整文件FFmpeg解码；Owner在Edge手动确认播放。**素材动作与权利没有通过，正式制作仍HOLD。** 技术播放应在今后由Codex自己的隔离浏览器测试自动化完成，不应把用户手动点播作为常规QA必选步骤。

> **历史执行合同（已执行并由Reviewer技术接受，2026-10-15）**。下方采用当时的命令式语气供审计溯源；**不是下一轮任务，不要重复备份/注销Ubuntu或重跑G2-G4**。当前状态以[CURRENT_STATE](CURRENT_STATE.md)为准。原合同： Owner最新决策：**安全卸载独立`Ubuntu-24.04`发行版（保留WSL底座/Docker后端）→ 在Windows Docker Desktop按需启动隔离的SearXNG+4get → 在同一轮完成CWS关键词搜索、筛选、人工指定ID下载、文件QA、浏览器实播、停止并回读**。本合同覆盖此前“不使用Docker/不卸载Ubuntu”的过时运行限制；此前G0、G1A的已验证事实不作追溯撤销。
>
> 本轮只在Owner**实体Windows 11**及其既有Docker Desktop工作，不部署VPS、不启动独立长期云服务。CWS仍不属于正式节目制作系统；`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`、Research Aqua/3+1、MEDIA-R6/R7全部不变。
>
> **阶段编号**（历史执行）：`G2_UBUNTU_SAFE_REMOVAL`、`G3_DOCKER_SEARCH_SERVICES`、`G4_MEDIA_END_TO_END`。本轮现已交Executor证据并获独立Reviewer技术接受；正式节目仍HOLD。

## 0. 总体限制与硬保护

- **一个Codex任务，三个顺序Gate；允许单轮推进至G4，但只有前Gate核验PASS后才能做依赖下一Gate的操作**。若某项阻塞不影响其它只读/孤立测试，可记录部分证据，但不得把整体归为PASS。绝不伪造成功。
- **先盘点真实环境**：Windows本机路径/登录用户不打印；当前PowerShell/Python、内存/磁盘、`wsl -l -v`、`docker version`、Docker Desktop后台状态、容器/卷、端口占用/进程树、CWS源码与独立工作树、本轮共享项目归属。
- **保护已有资产**：旧分支3项tracked未提交更改、2个缓存目录、前次中断61项记录/约1.747GB、Owner保留的所有媒体原片和测试ZIP、Docker Desktop WSL数据、OpenMontage、其他项目容器、全局代理/VPN/Clash。**禁止git reset/clean、`docker system prune`、`docker volume prune`、删全局镜像/卷、停止无关服务、删除或覆盖任何旧VHDX。**
- 仅使用独立CWS命名空间Compose项目、卷与端口；正式源码修改应在由最新main隔离创建的分支/工作树中，新的稳定改动走PR并交Review，**不自行合并**。
- Windows 16GB RAM设备需评估实际可用内存；拉镜像/启容器前证明磁盘与内存资源充足，若低于安全余量（原则上可用内存不足约2GiB，或空间不足镜像/备份所需）则`BLOCKED_RESOURCE_HEADROOM`，不通过强关其他项目来凑资源。
- 全部HTTP监听只能在`127.0.0.1`，不得绑定`0.0.0.0`、公网或LAN、设置反向代理或自动开机常驻。容器的`restart: no`；终止时只关闭本Compose拥有的资源。不要复制上游默认80/443公网发布范例。
- 如果搜索站点需要访问外网，可只为本CWS容器显式配置已经确认正确的代理，而不是修改系统代理/Clash/VPN；其配置不得落入Git或未脱敏证据。禁止绕过DRM/付费/认证或违反站点规则。未知URL不是完整SSRF沙箱，保留既定人工指定ID/有界下载。

## G2｜Ubuntu-24.04 安全卸载

1. **精准目标识别**：`wsl --list --verbose`找到完整发行版名称；`Ubuntu-24.04`和`docker-desktop`**绝对不能混为一谈**。确认`Ubuntu-24.04`已停止或仅为本次可控读取而启动；核实其`ext4.vhdx`是否属于该注册发行版还是历史孤儿/其他项目，并调查home、项目、ssh配置、数据目录有无需要保留的非复制资料。
2. **先备份再移除**：优先`wsl --export Ubuntu-24.04 <Owner可访问的备份文件.tar>`（最终命令按实际发行版名称）；先证实备份存储空间足够、导出退出码为0、文件非零且压缩包可列目录/具备有效导出结构，计算SHA-256并保留备份在**发行版删除路径之外**。若导出失败、数据归属不明、出口路径不可靠或确认有共享依赖，**不执行`wsl --unregister`**，记录`G2_BLOCKED_DATA_RISK`。
3. **确认满足以上安全前提时才执行仅此发行版的`wsl --unregister Ubuntu-24.04`**；这属于用户已授权的G2范围，但必须记录精确命令、执行结果、卸载前后列表、备份路径的脱敏别名及SHA/恢复方法。删除Ubuntu商店启动器只有确认为单独Ubuntu软件包且不会触碰WSL/Docker后端时才执行；否则只完成发行版注销并标明商店入口残留。
4. **严格禁止** `wsl --uninstall`、关闭WSL或Virtual Machine Platform、注销`docker-desktop`或清空Docker VHDX。**即使Ubuntu已卸载，WSL底座要保留给Docker Desktop**。若原系统未注册Ubuntu，则`G2_ALREADY_ABSENT`，记录而不是找孤立VHDX冒险删除。
5. 检查`docker version`/Docker Desktop自身功能：Docker Desktop通常可在不安装任何额外Ubuntu发行版时使用WSL2后端（Docker官方文档），但该事实不替代本机实测。禁止为节省空间随意删除此前1.735GB残留磁盘，除非确认是目标发行版的正规卸载路径且备份完整。

## G3｜Docker Desktop + 两个搜索服务

1. **复用**现有已安装的Docker Desktop/WSL2后端，先核对Docker服务状态、现有Compose项目/卷/镜像、空闲端口与资源；无必要不重装Docker。初始启动Docker Desktop需遵守现有其他项目的影响边界。
2. 在**本轮专属**CWS工作区创建`docker-compose.yml`与持久配置（可放CWS `.local`），建立**独立Compose项目名**，至少两个服务：官方SearXNG、4get。必要SearXNG辅助缓存组件可作为本Compose自己的辅助服务，拒绝引入共享Redis或使用已有项目卷。
3. 配置示例端口：若未被占用，SearXNG `127.0.0.1:18080`、4get `127.0.0.1:15050`，冲突必须换本轮独立可用端口而非占用原服务。CWS以真实端口做API调用；容器内部端口以实际镜像为准，勿假定。全部重启策略`no`，CWS只管理自己Compose项目。
4. SearXNG以官方容器/Compose安装指导为准并允许本地JSON响应格式；4get以其上游Docker说明/镜像为准，核实配置版本、项目来源、镜像digest、实际PHP搜索路由和CWS解析契约。**不得仅因HTTP200宣称搜索成功**。SearXNG和4get各使用至少两个真实测试查询（至少包含video和image类别），验证返回结构、结果非空、原始出处URL、搜索质量与排错日志；若4get仍零结果必须留失败证据，不能靠SearXNG代替宣称双服务PASS。
5. 按本机可用资源评估内存/CPU，记录峰值与Docker磁盘增长；独立检查是否需代理。只有两搜索服务及其自身依赖在G3完成时可启动，**不触碰其它容器**。
6. 证明`docker compose stop`或仅当前项目的`docker compose down`后本CWS端口解除监听，容器无自动重启，而项目持久卷/索引/配置仍在。**不得`down -v`**。为了G4可以再次启动同一CWS项目。

## G4｜从关键词到真实浏览器播放

1. 先从GitHub `main`中的`curious-world-studio/media-pipeline/`出发；不修改主线应用逻辑/过滤契约，不覆盖未提交更改。新稳定集成脚本如必要在隔离分支制作；本轮临时运行产物保留在`.local`。
2. 使用这一次真实启动的两搜索引擎分别执行视频/图片关键词查询；保存去重前后条数、来源类别、引擎分组及空结果/失败原因，**不能用历史搜索CSV或人工构造响应冒充新实时查询**。
3. 维持默认排除大陆视频平台与全球竖屏/方形、按旋转/SAR修正后`≥4:3`、未知优先有限探测、1080p优先、失败不能报shell 0成功。人工从候选列表明确选择两个**不同原始海外视频来源**的真实公开视频ID，另1张图片（若有必要可由Owner从实际候选决定，不得凭随机URL全量下载）；保持限速/大小/超时、不碰登录/DRM。
4. **真实网络下载新测试样本**→FFprobe识别真实display比例与码流→FFmpeg完整文件解码退出0并记录帧数/时长→原片SHA；图片实际解码与SHA。失败按搜索/解析/下载/内容/质量分开报告，保留失败样本和原因。
5. 由CWS生成本地HTML素材库；必要时在**原片保留不覆盖**的前提下创建兼容Edge的H.264/AAC小型MP4预览副本；仅127.0.0.1本地HTTP提供，Owner在Edge**手动**确认两段真实媒体对应预览可见画面和播放时间增长。不要绕过浏览器控制工具的安全停止；无法Owner确认则`BROWSER_NOT_VERIFIED`，不得假称完整PASS。G1A此前手动PASS可以引用但不能冒充本次新素材播放PASS。
6. 一键停止：关闭本轮HTTP服务和本Compose搜索容器，端口解除监听、无自动重启；重新启动可复用现有配置与索引，不需Docker镜像再次下载。检查docker-compose不泄露公网监听，也不残留CWS后台服务。**不得关闭整个Docker Desktop或其它项目**，也不得自动`docker compose down -v`。
7. G4通过仅表示**技术素材获取闭环**；实际动作匹配、真实科研来源、视觉近重复、商用/复用权、自动制片、发布仍另立Gate。原片权利状态默认`UNKNOWN_TEST_ONLY`，无许可证材料不得对外传播/入库Git或发布。

## 回滚、停止条件与交付

- **串行判断**：G2风险阻塞时，记录BLOCKED并停所有破坏性卸载；若现有Docker后端可独立验证，仍可在**不更改Ubuntu**的安全前提下独立推进G3/G4，并最终按`G2_BLOCKED / G3_PASS / G4_PASS`逐项呈现，**不得说G2-G4整体完成**。G3服务未能返回真实结果时不得伪造G4搜索成功，可保留仅部分测试。
- 所有新增服务、容器和配置仅归本项目；rollback即停止这些进程、保留本轮临时工作树、镜像/卷/数据/备份，**不得删除共享或原先资产**。任何原工作树修改先记录，禁止无依据回退覆盖。
- Codex输出**唯一**`CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_<运行日期>.zip`、外层SHA-256与Owner可用路径；至少含`README.md`、`G2_UBUNTU_BACKUP_AND_UNINSTALL.md`、`G3_DOCKER_COMPOSE_AND_SEARCH.md`、`G4_LIVE_MEDIA_END_TO_END.md`、`REVIEWER_HANDOFF.md`、`manifest.json`、`SHA256SUMS.txt`、`evidence/`的WSL前后/备份SHA、Compose实际配置脱敏副本、docker ps端口/日志、搜索API脱敏响应摘要、CWS过滤/候选/下载/QA、HTTP播放证据、进程清理验证。备份tar、原片大文件、凭据/绝对用户路径**不得装入ZIP或推Git**，但必须记录可定位的脱敏别名及Owner本机实际归档位置。
- Reviewer独立复查每个Gate；`G2_PASS`必须有可恢复备份+目标发行版消失；`G3_PASS`必须两服务真实返回非空搜索+容器可停止；`G4_PASS`必须新素材的2视频/1图片下载+全解码+Owner实播反馈+停止释放（不涉及节目素材权利）。
- 若产生了可长期复用的Compose、入口脚本、测试，则以**独立分支PR**提交，经独立Reviewer接受后再决定合并main；**不提交证据原片、不自行合并**。只维护长效`CURRENT_STATE`/`REVIEWER_HANDOFF_CURRENT`/本Gate，不在Git创建每轮大量短命报告。
- 官方依据：Docker WSL2 backend https://docs.docker.com/desktop/features/wsl/ ，Microsoft WSL export/unregister https://learn.microsoft.com/windows/wsl/basic-commands ，SearXNG容器 https://docs.searxng.org/admin/installation-docker.html ，4get docker https://git.lolcat.ca/lolcat/4get/src/branch/master/docs/docker.md 。

## 后续媒体浏览器技术QA：默认自动，不将人工点播当成常规验收依赖（2026-10-15新要求）

- **Automated-browser技术证明**：在拥有明确许可的独立/隔离浏览器实例与临时用户资料目录中访问本轮`http://127.0.0.1:<本轮端口>/...`，不是附着、操作或窥视Owner正在使用的Edge窗口。可采用本机已获许可的Playwright、Edge/Chrome DevTools Protocol或等效的可审计工具。不会因早先Computer Use不能确认**Owner已打开窗口**，就得出视频播放无法自动检测的结论。
- 每个受检视频须捕获URL一致性、HTTP响应、HTML`video.error`/网络状态、`readyState>=2`、`videoWidth>0`和`videoHeight>0`、`play()`履约、播放事件、两次带实时间隔的`currentTime`增长、截图或视频帧检查、异常回报和关闭后残留端口/进程检查。黑屏/静帧判定需结合有意义的抽帧核验，不可只看HTTP200或脚本将`currentTime`设成更大值。
- 本轮代码或OS缺少可许可的测试浏览器时，报告`BROWSER_AUTOMATION_BLOCKED`及准确阻碍，不得通过偷偷使用其它自动化控制方式绕过既有安全停止；可征得用户许可采用**隔离测试会话**，但不应默认让Owner重复播放。仅对**内容真实性、爆裂动作是否实际出现、画面叙事适配、审美、商用权利**等主观或人工审核项目寻求Owner确认。
- 将上述规则用于后续复验/新增MEDIA样片；**不追溯把本次Owner手动确认伪装为机器Playwright/Reviewer直接观看的证据**。脚本或测试若要纳入正式main，须经独立PR和Reviewer通过。
