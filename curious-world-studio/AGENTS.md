<!-- CWS_PR159_SAFE_DYNAMIC_DIRECT_INDEPENDENT_PASS_20261020 -->
# CWS 当前唯一执行入口｜2026-10-20

**CURRENT_GATE**：`NONE / PR159_SAFE_DYNAMIC_DIRECT_MEDIA_CANARY_REVIEWED_PASS`  
**STATUS**：`REVIEWER_COMPLETE / NEXT_EXECUTOR_NOT_AUTHORIZED / PR159_OPEN_UNMERGED`

**最新正式Reviewer结论**：[PR#159真实NASA小文件+安全代理下载独立审核报告](docs/reviews/CW0005_PR159_SAFE_DIRECT_REAL_MEDIA_INDEPENDENT_PASS_20261020.md)：`PASS_SAFE_DYNAMIC_DIRECT_MEDIA_CANARY`仅限CWS对**catalog动态ID的HTTPS单文件MP4/WebM直链**，绝非`PASS_GENERIC_YTDLP_EXTRACTOR`。Owner本轮上传ZIP SHA`dd2875f7adf2ce3f41cf948267b54c27ab5bd11824691058d68d22b78b1f0ae5`（38文件/37条SHA全部匹配）；Reviewer独立复检真实NASA 5582 MP4 2,669,379B、H.264、1920×1080、60fps、23.366667秒、1402帧、FFmpeg全片解码exit0、SHA`5dfc7ff258428e5c09c15f809792af9f1fc285d459bdfc2c407a24351d1de1d6`。新PR Head `bfddbbf86c9d5fa9a8c93513c1ea5c2d7b62dea8`，五个ZIP源码/单测快照逐一Git blob与GitHub HEAD一致，Windows 84项PASS为Executor日志，Reviewer另独立运行13项代理单测PASS。源码修正此前F159-01旧缓存误报及F159-02全下载deadline，且公网IP固定CONNECT、原TLS域名验证与禁止私网/跳转/嵌套URL守卫继续有效。

**一个非阻塞小问题**：独立Python 3.13的2条deadline超时模拟测试清理`HTTPResponse`时出现`Exception ignored: _DeadlineSocketReader 缺flush()`（F159-03），不影响本次视频真实下载、解码或SSRF安全判定。**合并前建议在PR#159同一分支小修HTTPResponse文件接口及显式close测试**，不需要另下载NASA/Blender或重开完整网络Gate；此处只表示本轮技术Gate PASS，不表示PR现可不复核直接合并。**PR #159仍Open/未合并，Reviewer没有发新Executor授权**。

**过期Gate**：上一`CWS-PR159-CACHE-DEADLINE-SMALL-REAL-MEDIA-20261019`已经执行、交付、独立Review并正式关闭；不得据旧文件中的Owner授权再次启动。历史PR#157安全负例、PR#158固定Blender夹具PASS、PR#156素材索引PARTIAL、PR#155早期流程RETURN都维持独立档案。

**正式业务约束**：NASA轨道动画仅`UNKNOWN_TEST_ONLY`技术素材，不能入CW0005爆米花节目；历史59.933秒样片技术PASS/V5.6.2 HTML冻结原样；`CW0005_VISUAL_STORYFIT_HOLD/G1_NOT_PASS/G2_NOT_AUTHORIZED/R4_NOT_AUTHORIZED/RIGHTS_PARTIAL/NO_PUBLISH/VOICE_BY_EAR_UNVERIFIED`持续生效。任意yt-dlp网页及分段/重定向路径**未验收**，不关Clash/TUN/Fake-IP/DNS/系统代理保护。

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
