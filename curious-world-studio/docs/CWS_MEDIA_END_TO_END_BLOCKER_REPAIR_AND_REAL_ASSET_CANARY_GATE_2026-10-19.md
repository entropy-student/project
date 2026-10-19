# Curious World Studio｜MEDIA搜索与合法素材下载闭环：最小阻塞修复联合Gate（2026-10-19）

> **Owner latest authorization：`OWNER_AUTHORIZED / EXECUTOR_NOT_STARTED`。** 2026-10-19，Owner确认已为Windows电脑预留可用内存，要求**“继续推进下一步，最好本轮一次性解决掉”**。本Gate把安全诊断、必要的最小适配修复、多来源候选发现、真实播放预览、合法素材至多1份验收下载、全解码/权限/证据PR合并在**一个条件式联合Gate**；严格依照[上位项目管理规范v0.2.7](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)的Gate/权限/安全/资源、既有CWS媒体素材规范执行。**本文件是唯一给本机Codex执行的Gate，之前PR#156搜索Gate已停止，不可直接重复旧操作。**
>
> **不能保证本次一定PASS**：Owner预留内存只解决运行前置条件；安全DNS路径、源网站实际播放/许可未知。如未获合格素材，必须真实分类停线，禁止伪造下载/内容证明。已接受的CWS V5.6.2六模板（Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`）、PR#155 59.933秒MP4技术PASS、PR#156的95搜索记录/87 URL索引与历史流程`RETURN_PROCESS_COMPLIANCE`均保持不变。

## A. Gate合同与允许到达的最大端点

- **GATE_ID**：`CWS-MEDIA-END-TO-END-BLOCKER-REPAIR-REAL-ASSET-CANARY-20261019`
- **OBJECTIVE**：消除PR#156具体的三类阻塞——`LOW_MEMORY`、`NON_PUBLIC_MEDIA_ADDRESS`的可归因安全拦截、Windows本机`media_pipeline.py`与GitHub main不一致/临时harness污染——并证明未来制作可重复使用**按脚本需求→多来源搜源→作品级去重→真实动作预览→权利/横屏核对→按ID选用→实际下载→FFprobe/FFmpeg/SHA→清理本轮服务**的流程。
- **MAX_ENDPOINT_THIS_ROUND**：一次复用既有CWS媒体能力的有界真实Canary。先完成安全只读诊断；安全且有必要时，在**CWS独立干净worktree/分支**最小修复/适配**媒体子模块及相关测试**，不可改冻结模板/业务应用/共享配置；随后最多**2个已冻结S01搜索语义×每语义既有聚合搜索+已可用的合法素材提供方**，最多**2名候选进行真实下载尝试、但最多1个成功留存的新视频**，单文件**≤80 MB**、本轮失败碎片+成品新增总计**≤160 MB**（且守住工具内部更严上限）。只有合法、适合内容且来源可溯的一个实物可以下载，不能为凑数字强制下载。对单个故障域最多一次**有新证据的定向修正与一次回归**；同类失败达到2次时停线，不重复猜测。
- **MANDATORY_REVIEW_STOP**：完成本Gate并提交**独立PR、Commit SHA及一次脱敏ZIP**之后，停在独立Reviewer。Executor只能输出`PASS_CANDIDATE_MEDIA_END_TO_END`或准确`PARTIAL_*/RETURN_*`，不得自评正式PASS、合并PR、生产长片、重剪旧样片、发布或开启第二题。
- **TARGET_AND_SCOPE**：Owner实际Windows 11主机；仓库`entropy-student/project`的`curious-world-studio/`项目路径；仅允许该项目隔离工作树/分支和`.local/media-e2e-canary-20261019/`的下载/临时证据；媒体图片、视频、账号/代理密钥、原始搜索日志不上Git。现有孤立`.pyc`不能删除或以改变系统配置清理，使用`python -B`等无字节码执行模式避免新增。
- **OWNER_ONLY_ACTIONS**：Owner已授权本轮限定的**普通无付费实搜、可审的媒体模块最小修复与免费许可素材小体量下载**；未授权更改Clash/VPN/TUN模式或系统DNS/全局代理，禁用或减弱安全守卫、修改Docker Desktop全局配置/重装镜像、安装额外大型依赖、登录绕过/付费/下载未经许可素材、执行`git clean/reset`或删其他项目文件、对外发布、直接合并PR、正式视频重渲/生图/TTS。若合法完成需要这些Owner-only动作，准确RETURN，不自行扩大授权。

## B. 本轮要一次处理的具体阻塞与正常路径

### B1. 资源：已预留内存，仍需真实读回

PR#156只在第一次`doctor`看到约1705MiB可用，首组搜索后第二组在685/794MiB下触发冻结`MIN_FREE_MEMORY_MB=1664`。Owner本轮已主动预留内存，**不必重复请求清理**，但Executor在真实Windows要先量`ullAvailPhys`并记录，同时记录Docker Desktop已启动/未启动、CWS Compose所属、非项目容器概览和磁盘空余。**最低门槛维持1664MiB/约1.63GiB，推荐启动前≥3GiB可用（有Edge并行则≥4GB更稳妥），这一推荐不变成新的Gate硬阈值**；有警报或观测内存持续下降时停止新容器/查询，不能降阈值骗过CLI。

优先先复用项目已运行Docker engine/现有健康CWS Compose；只启动**属于本Gate的CWS Compose服务**，不重启、关停或修改其他项目容器；Docker Desktop为全局应用，只能在当前用户上下文原有合法启动路径且不会改动他人服务时启动已装客户端，**无管理员权限/额外安装的必要时优先走免Docker提供方**。结束回读CWS Compose+端口（18080/15050）并只停止本轮自己开启的CWS服务，**Docker Desktop可以保留运行，不冒称其已关闭**。

### B2. DNS/代理安全：诊断精确原因，绝对不关保护

1. **只读先分类**：针对PR#156的4个**确切已知候选域名**（YouTube、Dailymotion、PeerTube，取真实日志中的准确域名），及一个可获得明确商业免费使用许可的提供方域名，执行最小DNS检查。记录`getaddrinfo`解析为`GLOBAL / PRIVATE / LOOPBACK / RESERVED_FAKE_IP / MIXED / UNRESOLVED`、系统代理/TUN是否存在的**开关/协议类别**、真正CLI抛出的`exception_type + sanitized_error_code + source_line`；不要公开用户IP、代理地址和凭据。PR#156原始探测JSONL只留`ValueError`，**之前“NON_PUBLIC_MEDIA_ADDRESS”尚未被Reviewer独立实证根因**。若无法在一致的进程内复现，只写`UNREPRODUCED`。
2. **禁止**：把私网地址或198.18.0.0/15假IP段“判为公网”、给YouTube/PeerTube泛域名白名单、直接禁用`_validate_public_url`、用新的无校验Downloader/FFprobe播放任意未可信URL、手动更改Clash/TUN/系统DNS以绕过安全边界、重试登录/DRM/限流、在远端服务器替代Owner本机以假装本机已修复。
3. **合法技术路径依证据选择**：优先现有OpenMontage的Pexels/Pixabay原站路径，或官方原论文/研究机构/已声明明确许可的Wikimedia原站视频和已许可的稳定CDN；域名、源作品ID、实际跳转/提供方权利都必须单项核实。使用现有可信原厂API和支持路径时可绕过**泛用yt-dlp分支**，但**不可绕过实际私有地址访问保护**。仅当可以对有效出口/实际最终IP、跳转和媒体嵌套清单分别实行同等或更强的`reject-non-public`约束（包括重复解析与连接目的地一致性），才允许在**隔离分支**实现最小`proxy-aware`适配并写负例测试；不能仅用外部DoH查询一次公共IP就把未验证的代理隧道认成安全。
4. 如果是代理Fake-IP路径又无可以证明安全的出口验证能力，**停止这一路**并尝试现成合法素材提供方的**原有受支持工具**，不造新的“通用域名放行器”。同一根因安全错误连续2次未收敛则停止这个故障域，按`PARTIAL_SAFE_ADDRESS_GUARD`明确报告。

### B3. 来源与可复现：不再混合本地旧模块+临时harness

PR#156显示`cws_media.py`与Compose为main，但Owner电脑实际导入的`media_pipeline.py`与main blob `0204d11569ca64de7ca31c55975859f95c9eaa32`不一致，并用一次性harness注入main helper / `media_filter.py`。本轮必须先**只读**证明实际导入的`__file__`（规范化相对路径）及Git Blob、工作树干净/脏状态、Python/CLI运行入口/依赖版本，**绝不覆盖Owner原工作树文件**。从已验证`main`重新创建项目范围的干净隔离worktree（不重置原工作树），使用**原样main源码直接调用**；若现成main不能运行，先在该干净分支最小修兼容与自动测试，提供diff、测试环境、命令/退出码/负例。**不得再通过运行时inject/harness替换正式包来宣称正常代码可复现PASS**。若需要改系统包/执行器安全策略/其它项目，停线RETURN。

### B4. 真实内容与版权：不再把搜索URL算成可用视频

1. **沿用PR#156中87个去重页面做缓存基础**，避免又搜100条无许可证YouTube/短视频；先对少数可信素材提供方（现成OpenMontage/Pexels/Pixabay、原研究机构、Wikimedia许可视频）按`S01真正受热爆裂/起跳`具体需求筛选。最多2个语义：`popcorn kernels popping in pan close up`与`popcorn jumping popping slow motion pan`（实际词可因镜头小改，但必须记录）。可用SearXNG+4get做发现补充，但不能把两个引擎等同于两个独立媒体原提供方；如SearXNG局部上游失败，**记录PARTIAL，不为凑全绿提高请求频率**。只调用**已验证可用的provider插件/工具**，不安装、重建项目或扩散到80站点。
2. 候选只对确有希望且来源允许复用的作品实看画面。记录至少`source original URL/provider/creator/platform family/license page/normalized original media identity/historical used inventory ID`，核对项目已用的5条历史视频作品（Pexels#854959 / Pixabay#2793 / Pexels#1796141/#35876717/#7677397）并识别可疑跨站转载。拒绝用户不想要的中国大陆视频平台与方形/竖屏（按旋转/SAR后的显示比≥4:3）、默认优先16:9/1080p；720p只有事实/动作更合适且有真实权利时标备用，不为指标强行拉升。
3. **真正视频预览**：以已经受信任且获许可的网页播放器、已有合法预览片段/只读的提供方原媒体预览，确认至少一个**真实动作**而非仅看标题/封面/HTML Player样式；记录关键帧/时间点、画面内容及是否为素材辅助而非论文高速实录。**访问能看≠可下载≠可商用**，逐层状态判定。
4. **有界下载**：仅候选`CONTENT_PREVIEW_VERIFIED + ORIGINAL_IDENTITY_NOT_USED + RIGHTS_VERIFIED_FOR_INTENDED_INTERNAL_CANARY + FORMAT_ELIGIBLE`同时满足，并经过端点安全校验时，才允许一个实际媒体定向下载（最多2不同候选的失败尝试，总成功留存≤1，单文件≤80MB，本轮含碎片总≤160MB）。原始媒体只放`.local`，记实际来源/文件SHA、ffprobe实际codec/分辨率/帧率/SAR/rotation、全片FFmpeg解码、至少3张代表帧与本机可安全分享的**无第三方媒体内容证据**；源站许可未明确则`RIGHTS_PARTIAL`、不下载。失败同因2次停止该路径，不能重复冲击限流/版权。
5. **七层台账**：`SEARCH_URL_FOUND / URL_DEDUPED / ORIGINAL_IDENTITY_DEDUPED / FORMAT_PROBED / CONTENT_PREVIEW_VERIFIED / DOWNLOADED_PLUS_FULL_DECODE_PASS / REUSE_RIGHTS_VERIFIED`，来源域名/平台家族、每查询词成功与失败分别统计；旧PR#155过程缺失继续`HISTORICAL_UNKNOWN`，本Gate新成功不得追溯修正历史RETURN。

## C. 连续执行与QA验收

- **P0｜一次只读根因矩阵**：先做B1内存、B2精确DNS/代理/错误code、B3实际导入路径/差异及旧搜索87链接/权利候选可用性。对每个阻塞给`PROVEN_CAUSE / PLAUSIBLE_UNCONFIRMED / NOT_REPRODUCED`和最小修法。已有明确数据可直接用于修正，不将所有问题重新研究一次。
- **P1｜必要的最小安全修复**：只有P0证明具体实现缺陷，才在隔离分支修改CWS媒体子模块、增加**确切命中故障的单元/负例**，并恢复从main干净源直接运行，不允许全架构替换。若OpenMontage原路径安全地可用，则**优先不动媒体网络核心代码**。校验私网、回环、混合DNS、重定向、下载尺寸上限、项目路径限制的回归；既有禁入条款必须全部仍生效。
- **P2｜有限实际检索与预览**：使用已存索引+现成合法来源做最多2个语义的搜索候选对比，事实记录查询成功/部分失败而不是全打PASS；核来源、独立作品身份、适合S01的实际爆裂/起跳画面/权限。预览至少一条真实动作是新Canary达标前置；若只有不匹配素材，标`PARTIAL_ACTION_FIT`，不拿虚假动作替代。
- **P3｜真实许可下载／QA（符合条件则连续执行）**：若有具体合法、格式合格、未用源，将其按实际ID和预算下载最多一份完整源视频，完成全片技术解码/SHA、可审关键帧和源权限记录；不需每次停下请求Owner。**如果完全没有合规源，也不授权从未知许可证站点“挑一个用来测试”**，可交`PARTIAL_RIGHTS_OR_CONTENT_GAP`并停线。
- **P4｜收尾与Reviewer证据**：运行后确认项目内CWS Compose停止或保持预先存在的原状态、18080/15050仅本轮持有的监听释放、Docker Desktop/非项目项目容器状态无非授权变化；严格保留旧缓存、`.pyc`不可擅删/改ACL。提交**一个独立PR+一个脱敏ZIP**，包含`ROOT_CAUSE_MATRIX.md`、`SOURCE_IMPORT_AND_PATCH_DIFF.md`、`SEARCH_LINEAGE.json`、`CANDIDATE_DECISIONS.csv`、`PROBE_PREVIEW_RIGHTS.json`、`DOWNLOAD_QA.json`、`E2E_TEST_RESULTS.md`、`ROLLBACK.md`及必要的最小新测试/源码，实际不适用项写`NOT_RUN/UNKNOWN`；绝不把视频、私有IP、Cookie/Token、许可不明原图塞Git。PR只要求Reviewer审核，不得合并。

**EXACT_ACCEPTANCE**：
1. 实际本机可用内存与Docker三层生命周期可审、1664MiB保护未更动；
2. 每一个失败`NON_PUBLIC_MEDIA_ADDRESS/ValueError`至少能够判断**准确异常code/解析类别/源导入版本**，不擅自当安全Bug或全面宣称DNS已修复；
3. 从**标准CWS隔离checkout原样main或经PR最小补丁**完成实际检索/预览/符合许可的素材下载/完整解码链，既有私网/跳转/预算回归不退化；不能用harness偷换；
4. 数据结构每阶段可独立复核：查到的链接不是可用内容，实际看不是商用许可，下载格式与内容/许可三条不互相冒充；
5. **至少一段可真实看见爆米花相关动作、来源许可可说明且得到一条不曾用过的合法视频完整下载+FFmpeg全解码**，才可报`PASS_CANDIDATE_MEDIA_END_TO_END`。不满足则精准`PARTIAL_*`，不强造结果；
6. 保留旧V5.6.2及CW0005前期技术成果，`NO_PUBLISH / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL`不自动升级。

**ROLLBACK**：Git生产main只写Owner授权的项目现行Gate/交接；执行者CWS修复代码只进隔离新分支PR；本机仅新增本轮专属`.local`文件且所有原缓存/旧样片/使用权台账保留，发生漂移可放弃该工作分支，任何非本Gate已有真实文件、共享容器、代理、模型或公网配置不得被覆盖。非目标异常立即止步并保存证明。若无法Review内容（Owner本机独有原视频），提供最小安全交接或Owner上传**获许可的单一验收视频**供Reviewer看，若不能传输则Reviewer只能判视频内容`UNVERIFIED`，不能要求把未经许可源上传公共仓库。

## D. REVIEWER_TO_EXECUTOR_RELAY（唯一直接入口）

请从GitHub最新main开始本Gate，仅顺序阅读**本Gate全文**、`docs/reviews/CW0005_PR156_INDEPENDENT_MEDIA_PROCESS_REVIEW_PARTIAL_2026-10-18.md`中阻塞原因、`docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`来源/权限及不重用、`docs/VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md`Owner已确认搜源选择策略，和必要的`media-pipeline/cws_media.py`、`media-pipeline/media_pipeline.py`、`media-pipeline/media_filter.py`、`media-pipeline/README.md`及相关测试。**不再漫游历史Gates、不重读Governance、不重新验收V5.6.2或55/59秒视频技术**；历史PR#156真实索引可在`main:docs/reviews/CW0005_MEDIA_PROVENANCE_CANDIDATE_INVENTORY_2026-10-18.csv`及Owner本机旧`.local`查。

**Owner授权本轮在Gate内连续做到真实素材一条的安全许可下载与完整解码**；在P0-P3条件满足时无需分步骤索要批准。先确诊DNS/源码与内存，再有限新搜，最好走已可用的免Docker合法提供方；若必须修改则仅隔离分支最小安全补丁+负例，严禁关闭`NON_PUBLIC_MEDIA_ADDRESS`私网保护或调低内存线。满足1个新真实合法横屏素材完整验收时交`PASS_CANDIDATE_MEDIA_END_TO_END`，否则精准`PARTIAL_*`，停止Reviewer。

**EXECUTOR_TO_REVIEWER_RELAY**：依规范七行（结果、改动、验证、问题、回滚、请Reviewer检查、Owner转交），列新PR/HEAD/SHA、脱敏ZIP/完整hash、真实下载源URL及许可判断/技术QA/预览时点、Host状态与未知项。**不自行合并、不发布、不生成新视频、不启动第二题。**
