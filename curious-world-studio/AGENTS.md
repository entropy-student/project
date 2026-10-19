<!-- CWS_GENERIC_FAKEIP_PROXY_GATE_OWNER_AUTH_20261019 -->
# CWS 当前唯一执行入口｜2026-10-19

**CURRENT_GATE**：`CWS-MEDIA-GENERAL-FAKEIP-SAFE-PROXY-EGRESS-20261019`  
**STATUS**：`OWNER_AUTHORIZED / EXECUTOR_NOT_DISPATCHED / SINGLE_BOUNDED_GATE`

**唯一执行Gate**：[一般素材网址的Fake-IP安全代理出口与动态下载验证](docs/CWS_MEDIA_GENERAL_FAKEIP_SAFE_PROXY_EGRESS_GATE_2026-10-19.md)。Owner在PR#158仅固定Blender夹具技术PASS后明确“我同意，继续吧”，正式授权**通用候选网址安全校验/条件式最小代码修复/有界动态视频下载Canary**。Codex仅依本Gate `REVIEWER_TO_EXECUTOR_RELAY`列出的具体文件启动；先前TUN固定夹具Gate已执行Review封板，**不能重跑**。

**已证明的能力**：[PR #158](https://github.com/entropy-student/project/pull/158) 仅受限固定Blender官方测试片`PASS_FIXTURE_PROXY_COMPAT`，真实ZIP/下载MP4/FFprobe/FFmpeg已由Reviewer复核；但它**尚未合并main**。旧[PR #157](https://github.com/entropy-student/project/pull/157)也仍未合并。新隔离代码必须辨认实际main源码与PR#158候选Head `ff613307e1ee67846786c00e42fa0a48719fcc52`，必要时清晰移植接受的测试夹具实现，**不得因Reviewer审过就认为代码已在main**；也不得让Codex擅自合并旧PR。

**本轮唯一焦点**：Windows真机保留TUN/Fake-IP、Clash与系统DNS/代理配置不变，借真实已验证的本机回环HTTP CONNECT代理让**从catalog动态选出的非硬编码、非Blender新素材直链/可支持页面**经安全公网目的IP绑定、TLS原域名验证、防恶意跳转与嵌套URL检查后受限探测，安全允许才下载最多**1份≤30MB**，FFprobe/FFmpeg全解码/SHA、负例测试、独立PR+脱敏ZIP交Reviewer。选自**已有**274目录或受控免费原始源，最多2个不同来源做小对照，不重启Docker/SearXNG/4get、不增加几百条搜索结果。

**核心安全硬边界**：原一般`_validate_public_url`非公网/混合Fake-IP拒绝仍有效。**若代理不能将真实CONNECT目的地锁定到已验证公网IP并保留原Host/SNI/TLS证书，不能仅因HTTP CONNECT正常或DoH回答公网就跳过安全校验**，应`RETURN_PROXY_EGRESS_PINNING_UNAVAILABLE`；未知yt-dlp页面的跳转/manifest/CDN子URL若不可逐跳验证，只声明动态安全直链`PARTIAL_EXTRACTOR_UNVERIFIED`，不可宣称全站通用成功。绝不修改Clash/TUN/DNS/系统代理、添加特权常驻服务、关闭安全防护、付费、登录、修改别的Docker/VPS/项目、清理旧原片/重做Blender或59.93秒正式样片。

**历史接受状态**：固定Blender夹具PASS；旧PR#155素材流程`RETURN_PROCESS_COMPLIANCE`、PR#156`PARTIAL_SEARCH`、PR#157安全负例独立受理但未合并；V5.6.2冻结HTML、CW0005 59.93秒样片技术PASS保持。`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH / VOICE_BY_EAR_UNVERIFIED`继续。不能倒推正式制片/版权/发布权限。

**读写规则**：项目治理 v0.2.7由Reviewer解析；Executor无需反复全仓回读。所有正式代码只进隔离新PR，不能自行merge；当前Gate内连续完成安全前置合格的步骤，无须逐步请求Owner批准，风险边界不合则精准PARTIAL/RETURN。

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
