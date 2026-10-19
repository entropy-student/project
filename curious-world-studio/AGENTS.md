<!-- CWS_PR159_SMALL_MEDIA_FIX_GATE_ACTIVE_20261019 -->
# CWS 当前唯一执行入口｜2026-10-19

**CURRENT_GATE**：`CWS-PR159-CACHE-DEADLINE-SMALL-REAL-MEDIA-20261019`  
**STATUS**：`OWNER_AUTHORIZED / EXECUTOR_NOT_DISPATCHED / SINGLE_FIX_AND_CANARY_GATE`

**唯一执行文件**：[PR159两项最小修补＋NASA小文件真实Canary Gate](docs/CWS_PR159_CACHE_DEADLINE_REAL_SMALL_MEDIA_CANARY_GATE_2026-10-19.md)。Owner针对已独立Review的[PR#159](https://github.com/entropy-student/project/pull/159) 明确“好的继续下一步吧”，因此此Gate**当前生效**。先完整读本Gate末尾`REVIEWER_TO_EXECUTOR_RELAY`及列出的代码片段；旧通用Fake-IP Gate/前次“CURRENT_GATE=NONE”全部历史，不得重跑。

**确定问题与允许动作**：上轮真实ZIP和GitHub六文件独立核证公网IP固定CONNECT、原域名TLS证书连接通过，但NASA大视频`87,626,655B`超过30MB、JPL 301而拒绝，**0实际媒体下载**，正式`PARTIAL_SAFE_PROXY_EGRESS_VERIFIED_NO_MEDIA_CANARY`。Reviewer另发现F159-01：旧普通yt-dlp/图片文件缓存可在`fetch --safe-direct`前置命中、误报CACHED成功；F159-02：下载有socket操作超时却无真正**整个正文慢滴流总体期限**。**本轮只修这两点和最少单测**，并用NASA SVS ID 5582官方**1920×1080、标称2.5MB**直链作为**非Blender技术验证候选**（备用同页6.8MB），只有现场安全HEAD满足200、无跳转、MP4、≤30MB才可按catalog ID做一条CWS下载＋FFprobe/FFmpeg全片解码/SHA。

**代码归属与PR策略**：[PR#159](https://github.com/entropy-student/project/pull/159) 旧Head `59f427d37591d2c6c8aa67033ddc4cfe401a933a`当前尚未合并；**优先在其原隔离分支追加最小修补commit并更新同一PR**，保留原安全网络技术成果与Code Review，不要凭空开很多新PR。若新Head/branch有冲突先只读说明，不覆盖同事或本机其他工作。PR#158固定Blender技术PASS及PR#157回归历史、均未合并，禁止擅自处置。

**硬约束**：必须保留`NON_PUBLIC_MEDIA_ADDRESS`、公网DNS/CNAME与实际数字IP CONNECT的约束、TLS验证、302禁止、manifest/嵌套媒体禁止、30,000,000B上限；**不改Owner的TUN、Clash、Fake-IP、DNS、系统代理/共享Docker/VPS，不登录、付费、不删除旧文件、不重下载Blender、不重复大规模素材搜索、不自动合并/发布/重渲59.93秒样片**。所有真实下载都要求新工作目录、来源/尺寸/合法内部测试标注及真实视频可供Reviewer接收的受控附件；无媒体必须诚实`PARTIAL`，不可模拟FFmpeg/SHA成功。

**冻结状态持续**：V5.6.2 HTML冻结、现59.933秒视频技术PASS；旧PR#155素材流程RETURN、PR#156搜索PARTIAL、PR#158仅官方固定夹具PASS；CW0005`VISUAL_STORYFIT_HOLD/G1_NOT_PASS/G2_NOT_AUTHORIZED/R4_NOT_AUTHORIZED/RIGHTS_PARTIAL/NO_PUBLISH/VOICE_BY_EAR_UNVERIFIED`全部保持。**Executor完成仅交PR和脱敏ZIP独立Reviewer，不自行合并。**

---

# Curious World Studio｜Agent / Codex 唯一入口

> **历史技术基线**：`MEDIA-INTEGRATION PR#129/#131 MERGED`、本机G2–G4搜索/下载/解码工具技术已验收，R6L/R7L已完成。**历史能力不构成本轮素材流程PASS**；生产/发布继续HOLD。唯一**现行执行入口始终以本文件顶部CURRENT_GATE为准**。
>
> **Executor只读启动**：先本文件顶部的**唯一当前Gate**及其`REVIEWER_TO_EXECUTOR_RELAY`，再按其中精准列出的所需文档/代码范围读取；不要全面重读旧Gates、过时Handoff任务或历史视频验收。Reviewer按Governance另行读取完整当前状态和所需材料。

## 工作范围与Gate

- **频道与研究**：不露脸跨领域真实知识视频；B站主阵地。九大信息源→发现→初筛→[36条选题库](research/topic-bank/WORKFLOW_V1.md)→STORY-FIT→剧本/素材证据→制作。HF-FIND单独遵循[唯一研究主协议](research/HF_有趣发现_唯一主协议.md)。
- **视觉**：A简短Mac Tiger Aqua桌面→B满屏QuickTime 7银灰播放器，单行字幕；以[STYLE_LOCK](visual/retro-mac-v1.2/docs/STYLE_LOCK.md)为规范，HTML原型不等于成片。
- **素材**：以[3+1正式合同](docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)为最高来源/权利规则，MEDIA技术默认排除大陆平台、竖屏及方形、显示比例≥4:3，优先1080p，未知先有限探测；严格区分`LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED`。
- **MEDIA当前运行选择**：Windows已有Docker Desktop/WSL2；SearXNG+4get Compose本机按需启停，CWS Python/yt-dlp/FFmpeg本机执行；不部署VPS、不开公网、不需要后台24h常驻。不操作共享Docker项目、VPN/Clash、全局代理、OpenMontage。
- **制作边界**：MEDIA工具PASS/样片59.93秒技术PASS不能解除`G1_NOT_PASS/G2_NOT_AUTHORIZED/NO_PUBLISH`，旧PROD-R3授权已完成并不可重跑；本轮执行Gate以顶部为准；现行授权仅取顶部唯一Gate；无正式视频制作授权。

## 完整内容制作｜长期文案工作流

- **先脚本后配音**：R2和以后每期在完整脚本录音前，按[双轮文案润色流程](docs/VIDEO_SCRIPT_POLISH_WORKFLOW.md)依次使用 `KKKKhazix/human-writing`（首轮结构、信息组织与自然中文）和固定 `blader/humanizer v3.1.0`（次轮去模板句、机械衔接与AI腔），完成事实/来源/节奏回归才冻结口播稿。
- **R4完整内部草片**：完整全片新增或重写旁白必须包含该编辑步骤，不能直接把R3短样片文案扩长后未经润色就配音；该工作包含未来获授权的**同一R4 Gate**，不自动增加额外轮次。已无变动的验收段落可复用。不对正在执行的R3返修追加写作任务；当前正式Gate和素材权利不变。
- **环境和真实性**：两个Skill的仓库/版本已经核对，但本次未安装、未在Codex调用；后续执行需先验证环境实际可用与版本。不让Skill修改科研数据、引用、假说边界，不以AI检测工具分数作为验收标准。

## Reviewer与执行者职责

- **Owner**：明确授权下一Gate、付费、删除、远程部署、素材复用、生产和发布，审核内容动作、审美。
- **Windows本机Codex**：仅执行Owner授权范围，保留旧工作树3个tracked改动/2个未跟踪缓存与Ubuntu备份；若需新增稳定源码，基于最新main建隔离分支PR，**不得自行合并**；交**一个脱敏ZIP+SHA**供Reviewer验收。
- **独立Reviewer**：分别标明实际独立验证和执行端/Owner提供的证据；判断PASS/PARTIAL/RETURN/HOLD；认可合并应独立审查而非仅凭日志口述。
- **浏览器自动技术QA**：今后应由Codex在获准的**独立测试浏览器**测试`readyState/videoWidth/play()/currentTime`和实际画面，结束时回收本轮进程；不得控制Owner现有私人Edge窗口或绕过Computer Use明确的安全停止。若运行权限受限，标`BROWSER_AUTO_NOT_VERIFIED`，不默认让Owner反复点击同一技术样片。
- **保全**：不对旧工作树做`reset --hard`/`git clean`，不`docker system prune`/`down -v`，不删已备份Ubuntu tar/旧媒体、不把Cookie、凭据、全量原片/日志上传Git。

## 按指令类型分流

- `PROJECT-STATUS`：仅依据[CURRENT_STATE](docs/CURRENT_STATE.md)与交接，不能把旧“已授权执行”当现行任务。
- `HF-FIND`：按唯一主协议执行HF日榜发现；不自行制作视频。
- `TOPIC-BANK`：按[工作流](research/topic-bank/WORKFLOW_V1.md)和[九源注册表](research/SOURCE_SYSTEM_FINAL_V1.md)，修改母表/看板时先运行`python curious-world-studio/research/topic-bank/validate_topic_bank.py`及`python -m unittest discover -s curious-world-studio/research/topic-bank -p test_validate_topic_bank.py`。
- `STYLE-REVIEW`：仅依据视觉锁与真实证据评论样式，不自动开发渲染器。
- `MEDIA-OPERATIONS-INTEGRATION`技术已合并/验收，R2文案PASS、PR#155 59.93秒视频技术PASS，**素材流程`RETURN_PROCESS_COMPLIANCE`**。旧PROD-R3和MEDIA试跑Gate仅用于历史取证，本轮应执行顶部的新Gate；完整R4、第二题、公开发布仍未授权。

历史G0/M2/阶段报告只用于追溯。**GitHub main记录稳定代码和长期规范，执行ZIP/媒体保留Owner本机，不为每轮普通QA新增重复Git报告。**
