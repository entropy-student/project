# CWS｜MEDIA Windows 即用即停：中断恢复与技术选择规范

> **OWNER DECISION / ACTIVE · 2026-10-15**。Owner明确希望CWS是**即用即停的本地工具**，不需要长期开机、常驻后台或新增VPS部署；上一轮Codex `MEDIA-DOCKERFREE-ACCEPTANCE` 执行被Owner强制中断，**其完成状态/可能残留进程未知**。本文件**覆盖旧无Docker执行协议中的部署授权和下一任务**，而不是追溯修改已合并代码或历史报告。
>
> **当前仅批准 `MEDIA-ONDEMAND-RECOVERY-G0`：Windows本机只读环境复核与按需技术路线判断。** 无须Owner上传旧ZIP给Codex；本机必须先核对真实Git工作树、PID与任务痕迹。**禁止直接恢复被中断命令、继续安装或搬迁服务、部署VPS、停止Docker/共享服务或擅自清理遗留文件。**

## 当前Reviewer裁决附注（2026-10-15，长期索引）

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
