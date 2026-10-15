# CWS｜MEDIA Windows 即用即停：中断恢复与技术选择规范

> **2026-10-15 Owner已覆盖前一运行选择**：本文件的“无Docker/不卸载Ubuntu/仅G1B搜索API路线”现为**历史对照，不再作为下一轮指令**。当前允许Windows本机Docker Desktop按需运行，并授权有备份和保护前提的Ubuntu-24.04发行版安全卸载。请以[最新G2-G4执行合同](MEDIA_G2_G3_G4_DOCKER_LOCAL_EXECUTION_GATE.md)为准；CWS资料、其余WSL、Docker后端、系统网络配置均受保护。

> **OWNER DECISION / ACTIVE · 2026-10-15**。Owner明确希望CWS是**即用即停的本地工具**，不需要长期开机、常驻后台或新增VPS部署；上一轮Codex `MEDIA-DOCKERFREE-ACCEPTANCE` 执行被Owner强制中断，**其完成状态/可能残留进程未知**。本文件**覆盖旧无Docker执行协议中的部署授权和下一任务**，而不是追溯修改已合并代码或历史报告。
>
> **历史授权：`MEDIA-ONDEMAND-RECOVERY-G0`只读调查已经完成且获Reviewer接受；其后独立本地`G1A_LOCAL_LIFECYCLE`已执行并获部分接受。最新状态见下方裁决。** 无须Owner上传旧ZIP给Codex；本机必须先核对真实Git工作树、PID与任务痕迹。**禁止直接恢复被中断命令、继续安装或搬迁服务、部署VPS、停止Docker/共享服务或擅自清理遗留文件。**

## G1A浏览器补测验收更新（2026-10-15，覆盖以下旧未验证状态）

- `G1A_BROWSER_OWNER_PASS / G1A_LOCAL_LIFECYCLE_ACCEPTED`：Owner在Edge手动确认2段6秒MP4预览画面与持续时间推进，HTTP GET日志佐证两资源实际请求。G1A本地短时127.0.0.1 HTTP启停与素材QA的执行记录已经形成可接受的闭环证据，Owner完成浏览器缺口。
- 交付ZIP `CWS_MEDIA_G1A_BROWSER_VERIFY_20261015.zip` SHA256 `07b7f169d54b5440bc967d464e2764e34119f98717474a8b92dbfec3ec8337d3`，CRC无错，27项SHA、26项manifest均复核匹配。**没有独立录屏、截图、原片或MP4代理副本，Reviewer没有直接看播放器或全片重新解码**；播放PASS只基于Owner实测。
- 接下来不是重新搭搜索服务器，而是`G1B-SEARCH-SOURCE`候选方案验证：无VPS、无Docker、无后台常驻；严格比较现成检索接口能否找到视频/图片、费用和条款是否允许保存CWS索引。**尚未获得完整素材搜索一键即停PASS**；CWS启动器正式入库也尚无PR。任何收费/下载/安装/代码修改需要明确后续许可。

## G1A 前次独立Reviewer局部验收（历史）（2026-10-15）

- `G1A_LOCAL_LIFECYCLE_PARTIAL_ACCEPT`：本机旧素材复用、媒体QA日志、Python仅127.0.0.1临时HTTP服务与生命周期测试证据可接受；ZIP `CWS_MEDIA_ONDEMAND_G1A_LOCAL_LIFECYCLE_20261015.zip`，SHA256 `4f5d7d7874830feb18597b76e4164f0f2b224ebb60cda4667fbec74e14b0bacc`，独立检查32条SHA256SUMS/31条manifest均通过。
- **`BROWSER_NOT_VERIFIED`**：Computer Use无法确定Edge当前URL而安全停止；不能以HTTP200、HTML文件存在或FFmpeg解码成功冒充真实浏览器播放或currentTime推进。实际原片与MP4预览未收入ZIP，Reviewer只验证日志和静态源码，并未独立完整解码原片或观看视频。
- **`SEARCH_NOT_IN_SCOPE`**：这一轮没有运行SearXNG/4get/Exa、下载媒体、安装搜索服务或部署VPS。G1A本地服务启停脚本在执行端隔离目录，不在正式Git源码中；不要宣称一键使用全流程已产品化。
- 后续建议Owner另行许可`G1A-BROWSER-FOCUSED-VERIFY`，由**用户在正常浏览器手动**完成实际播放与时间推进确认，并提供隐私脱敏证据；不通过其他自动化绕过Computer Use的安全停止。本轮不自动授权G1B/API付费/持久索引变更。

## 之前G0 Reviewer裁决（2026-10-15，历史索引）

- `G0_RECOVERY_EVIDENCE_ACCEPT`：Owner上传的只读调查包SHA `05ff890e6b87c420754a315812c7199c3da6c7c09116db5f5ffb3281c69f8c42`，16条内部SHA与15项manifest复核通过；仅意味着中断现场和方案比较获得证据级接受。
- 没有可复用的**当前本机**SearXNG/4get服务；18080/15050无监听，WSL stopped；旧VHDX和原工作树的未提交内容都要保护，不清理。
- 2026-10-15独立Reviewer验证Brave普通Search API条款禁止将Search Results建立持久缓存/数据库（瞬时运行储存例外；扩展储存须特别授权）；**不批准直接把Brave数据写入现有CWS持久catalog**。Exa的存储与视频/图片覆盖尚未核实。优先评估本机现成`agent-reach`检索能力的合法数据用途，不把其命令行可用等同于MEDIA检索接口已通过。
- 后续建议采用**零部署、短生命周期**的方案；人工URL导入可作为降级选项，但**不等同于自动关键词批量视频搜索**。任何真实G1/安装/付费API/持久源码更改须有独立Owner授权。

## 1. 已经成立与尚未成立的事实

- GitHub `main` 已有PR#129合并的CWS `media-pipeline/`；受限范围内可索引SearXNG/4get查询、去重、按ID下载、FFprobe/FFmpeg QA、HTML素材库；代码Windows36/36测试与Reviewer修复验收通过。
- **不能由PR#129推导出**：两个搜索引擎能无Docker Windows原生一键启动、素材库浏览器互动播放PASS、无需服务端的完整搜索质量、输入任意主题即可无人值守选片，或最终节目制作已放行。
- `yt-dlp`、`ffmpeg`、`ffprobe`、CWS CLI可作为**调用时运行、完成后退出的本机命令**；SearXNG/4get历史以HTTP服务方式调用，能否按需原生启停、或改用无需自建服务的其他来源，**必须实测/比较，不作预设**。
- 旧`MEDIA-DOCKERFREE-ACCEPTANCE`部署/整链Gate现在是`PAUSED_BY_OWNER`，不允许按其建议继续在Linux/VPS安装原生搜索栈。旧文档保留供将来复核。

## 2. 本轮唯一允许的Codex工作（G0，READ_ONLY）

1. **定位实际项目**：核对Owner Windows本机与当前仓库worktree、PR#129合并后的`main`版本、是否存在未提交更改/未追踪文件/半成品。不能因为远端main更新就直接pull、reset、clean或覆盖工作树。
2. **中断现场调查**：读取上轮Codex的历史日志、终端上下文、最近CWS临时工作目录（只能核实拥有者和归属，不能在全磁盘盲扫）；列出与上一轮任务**确切相关**的PID、父进程、命令行、监听端口、子进程、进程创建时间、是否仍存活或由其他工作使用。
3. **不擅自停止进程**：仅列出`SAFE_TO_STOP_CANDIDATE`、`SHARED_OR_UNKNOWN_DO_NOT_TOUCH`、`ALREADY_EXITED`三种证据分类。未知归属一律不动；包括任何Docker Desktop、VPS、VPN、Clash、OpenMontage、M2、其他项目进程/服务。
4. **查当前搜索服务来源**：现有SearXNG/4get的地址是否为本机/远端、是否Docker/WSL/Windows本地服务/其它进程、是否能确认被其它项目复用；只进行必要的安全、只读配置/HTTP状态查阅，不读取Cookie/令牌内容、不展示代理/SSH密钥；不得把`HTTP 200`当有效搜索结果。
5. **无安装路线对比**：按首选顺序提出A)已安装的本机非容器SearXNG/4get可按需启停（需真实证明）；B)无需自己运行搜索服务的合规直接搜索API或其它可用来源，标明是否付费、限流、视频/图片覆盖及CWS接口需要改动；C)如必须自托管，说明本机临时进程方式的真实依赖、启动开销、失败情况，但**本轮不实施/安装**。**VPS部署不作为默认方案。**
6. **输出可执行的下一轮最小Gate建议**：给出所选路线的开机不常驻/一键启动/搜索/手动指定ID下载/本地解码与浏览器播放/一键关闭的流程、可控PID与端口、超时、资源、回滚、验收、与PR#129的兼容性；如果根本无法不用服务端，坦陈限制，不能仅用“设计能实现”当PASS。
7. **本轮停在Reviewer**：仅允许在实际已存在的CWS `.local/`（若可安全定位）下创建独立最小`handoff`目录/ZIP用于证据，**不得写入Git跟踪文件**；不下载媒体、不启动新搜索服务、不改PATH/防火墙/网络配置、不安装Python/PHP/WSL/Docker，不执行新的在线负载。没有明确归属与写权限则只在允许的本机用户临时工作目录创建交接ZIP并记录原因。

## 3. Gate、交付、下轮授权

- 交付一个`CWS_MEDIA_ONDEMAND_G0_<实际运行日期>.zip`，至少含`README.md`、`manifest.json`、`SHA256SUMS.txt`、`handoff.md`、`evidence/processes_redacted.csv`、`evidence/git_state.txt`、`evidence/search_backend_origin.md`、`DECISION_MATRIX.md`、`NEXT_G1_PROPOSAL.md`。记录`NOT_RUN`，不要提供虚构证据；脱敏绝对用户路径、访问凭据、Cookie及敏感环境变量。
- G0 Reviewer分类：`G0_RECOVERY_EVIDENCE_ACCEPT`（只表示事实盘点与可行方案完整）、`RETURN`（证据不足）或`BLOCKED`（不可安全审计）。G0**不是**`ONDEMAND_END_TO_END_PASS`或`DOCKER_FREE_MEDIA_PIPELINE_PASS`。
- 仅在Owner看到G0方案并**另行允许G1**后，才可以写有界一键启动/停止脚本、安装真正不可缺依赖、修改CWS代码（应走新PR）、或实际下载/运行本地小规模闭环。
- 工作方式固定：Owner发**纯文字任务**→Codex本机执行→一个ZIP和外部SHA→Owner交独立Reviewer→审核结果，持久生效的重大决策写GitHub `main`，临时日志不入Git。
- CWS正式节目仍`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`，不得因工具验收自动启动`MEDIA-R6/R7`或节目生产。
