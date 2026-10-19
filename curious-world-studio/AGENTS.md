<!-- CWS_PR157_REVIEWER_COMPLETE_20261019 -->
# CWS 当前唯一执行入口｜2026-10-19

**CURRENT_GATE**：`NONE / PR157_REVIEWED_PARTIAL_SAFE_ADDRESS_GUARD`  
**STATUS**：`REVIEWER_COMPLETE / NEXT_EXECUTOR_NOT_DISPATCHED`

**本轮独立裁决**：[PR#157真实ZIP和代码审核](docs/reviews/CW0005_PR157_INDEPENDENT_MEDIA_E2E_REVIEW_PARTIAL_20261019.md)，正式`PARTIAL_SAFE_ADDRESS_GUARD / RIGHTS_UNKNOWN / END_TO_END_MEDIA_CANARY_NOT_PASS`。旧`CWS-MEDIA-END-TO-END-BLOCKER-REPAIR-REAL-ASSET-CANARY-20261019`任务**已经执行并在Reviewer结束，不可再根据旧Gate授权重跑**。

**可保留成果**：ZIP 29成员/28条SHA校验PASS；本轮414原始记录，274个独立页面（146视频/128图片，54条与历史URL身份重合、220条新页面），内存有余、既有源码与main一致；PR#157只新增8行`198.18.0.1 + 公网IP`混合DNS必须被`NON_PUBLIC_MEDIA_ADDRESS`拒绝的安全负例，基线60/分支61测试的日志记录PASS。上述不等于274段真实合法视频。

**仍受阻**：1条YouTube素材只有Executor文字描述的部分视觉观察（时码不可核）、其他273页未实看，274条资产复用许可全部`UNKNOWN`；无合法视频下载、无新源FFprobe/FFmpeg/SHA；Fake-IP环境下安全访问通道**未修复**，生产校验器正确拒绝非公有地址。PR#157保持`Open / NOT_MERGED`，**新负例测试可局部接受但不得把PR或媒体流程宣称完整PASS**。

**下一步建议（尚未授权，不可自动执行）**：停止继续凑数式通用多站URL搜集，先在已有OpenMontage/Pexels/Pixabay等许可明确的原始提供方找到真实合适、作品身份未用的S01片段，核画面、权利和可追溯资源；仅在受支持的端点校验能同等安全覆盖最终目的地及跳转时做有界下载+完整解码，绝不关闭`NON_PUBLIC_MEDIA_ADDRESS`或改Clash/TUN/DNS/系统代理。下一个Gate须Owner明确启动。

**项目冻结状态**：原59.93秒样片技术PASS、V5.6.2模板冻结不变；历史PR#155`RETURN_PROCESS_COMPLIANCE`、PR#156`PARTIAL_SEARCH`，`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH / VOICE_BY_EAR_UNVERIFIED`继续有效。旧Gate全文与前期结果仍保留在`docs/DECISION_LOG.md`、Reviewer报告及Git历史，不构成新执行权限。

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
- **制作边界**：MEDIA工具PASS/样片59.93秒技术PASS不能解除`G1_NOT_PASS/G2_NOT_AUTHORIZED/NO_PUBLISH`，旧PROD-R3授权已完成并不可重跑；当前只执行顶部限定的MEDIA安全诊断/最小兼容修复/来源素材小型真实流程，不触发正式视频制作。

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
