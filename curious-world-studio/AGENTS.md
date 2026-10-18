<!-- CWS_CURRENT_EXECUTION_ENTRY_SINGLE_AUTHORITY_20261018 -->
# CWS 当前唯一执行入口｜2026-10-18

**CURRENT_GATE**: `NONE / REVIEWER_STOP_AFTER_PR156_PARTIAL_SEARCH`  
**STATUS**: `PR156_EVIDENCE_MERGED / NEW_EXECUTOR_GATE_NOT_AUTHORIZED`

**当前结果**：Owner上传的[PR#156](https://github.com/entropy-student/project/pull/156)真实ZIP经独立Reviewer核全部34条内部SHA及GitHub九份blob、95条原始搜索记录→87个去重页面URL；只有一组语义发出查询，SearXNG上游部分失败，第二组因内存小于1664MiB停线；4候选没有有效格式验证/实际动作视频画面/合法复用许可；下载0条正确。**正式`PARTIAL_SEARCH`，不是媒体流程PASS；历史PR#155`RETURN_PROCESS_COMPLIANCE`仍然有效。** 原始[PR156 Reviewer报告](docs/reviews/CW0005_PR156_INDEPENDENT_MEDIA_PROCESS_REVIEW_PARTIAL_2026-10-18.md)及[本轮执行Gate（已执行，禁止重跑）](docs/CWS_CW0005_MEDIA_PROVENANCE_AND_BOUNDED_MULTISOURCE_VALIDATION_GATE_2026-10-18.md)。

**证据归档**：PR#156仅九份可验证的脱敏报告，已squash merge为`890d52b1c5b767bffa6677eeffafe8be96de5cbb`，合并只表示正式保存`PARTIAL_SEARCH`执行事实，**不等于授权素材再下载/出版或视觉Story-Fit PASS**；PR#155仍Open不合并。

**当前禁止**：无新Gate时不再执行旧搜索、重复启动Docker、降低1664MiB内存门槛、绕过`NON_PUBLIC_MEDIA_ADDRESS`、生图/渲染新MP4、修改冻结V5.6.2、改别的项目网络/Docker、付费、公开发布。旧两条59.93秒作品、三张AI图、五条已用历史实拍都保留且各自沿用原指纹、项目级视频源禁复用。

**NEXT_STEP（建议，尚未派发）**：由Reviewer先界定一轮小型**纯只读**Owner Windows诊断：原始四个`ValueError`的精确错误code与DNS地址类别/代理Fake-IP；正常CWS源码导入路径和临时harness来源；Docker Desktop/Compose各自占用及本次资源余量；现有可免Docker复用的OpenMontage候选。**不得白名单绕过私网保护或再次盲重试**。下一轮新Gate需Review后单独有效授权。

**固定限制**：`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH / VOICE_BY_EAR_UNVERIFIED`。本文件下方稳定功能说明中的历史任务提法均不生成新执行权；Executor未来只从更新后的`CURRENT_GATE`和`REVIEWER_TO_EXECUTOR_RELAY`启动。

**项目级图片准则**：[AI静态图优先复用/快速保存/最多2并发/QA指南](docs/AI_IMAGE_GENERATION_EFFICIENCY_REUSE_GUIDE_2026-10-16.md)；本次不启动生图。


# Curious World Studio｜Agent / Codex 唯一入口

> **历史技术基线**：`MEDIA-INTEGRATION PR#129/#131 MERGED`、本机G2–G4搜索/下载/解码工具技术已验收，R6L/R7L已完成。**历史能力不构成本轮素材流程PASS**；生产/发布继续HOLD。唯一**现行执行入口始终以本文件顶部CURRENT_GATE为准**。
>
> **Executor只读启动**：先本文件顶部的**唯一当前Gate**及其`REVIEWER_TO_EXECUTOR_RELAY`，再按其中精准列出的所需文档/代码范围读取；不要全面重读旧Gates、过时Handoff任务或历史视频验收。Reviewer按Governance另行读取完整当前状态和所需材料。

## 工作范围与Gate

- **频道与研究**：不露脸跨领域真实知识视频；B站主阵地。九大信息源→发现→初筛→[36条选题库](research/topic-bank/WORKFLOW_V1.md)→STORY-FIT→剧本/素材证据→制作。HF-FIND单独遵循[唯一研究主协议](research/HF_有趣发现_唯一主协议.md)。
- **视觉**：A简短Mac Tiger Aqua桌面→B满屏QuickTime 7银灰播放器，单行字幕；以[STYLE_LOCK](visual/retro-mac-v1.2/docs/STYLE_LOCK.md)为规范，HTML原型不等于成片。
- **素材**：以[3+1正式合同](docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)为最高来源/权利规则，MEDIA技术默认排除大陆平台、竖屏及方形、显示比例≥4:3，优先1080p，未知先有限探测；严格区分`LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED`。
- **MEDIA当前运行选择**：Windows已有Docker Desktop/WSL2；SearXNG+4get Compose本机按需启停，CWS Python/yt-dlp/FFmpeg本机执行；不部署VPS、不开公网、不需要后台24h常驻。不操作共享Docker项目、VPN/Clash、全局代理、OpenMontage。
- **制作边界**：MEDIA工具PASS/样片59.93秒技术PASS不能解除`G1_NOT_PASS/G2_NOT_AUTHORIZED/NO_PUBLISH`，旧PROD-R3授权已完成并不可重跑；当前只执行顶部限定的媒体来源流程验证，不触发视频制作。

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
