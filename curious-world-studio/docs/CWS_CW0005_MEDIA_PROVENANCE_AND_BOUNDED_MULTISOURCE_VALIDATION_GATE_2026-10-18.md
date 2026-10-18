# CWS｜CW0005 素材流程RETURN：历史追溯＋最小多来源真实验证联合Gate（2026-10-18）

> **状态：OWNER_AUTHORIZED_2026-10-18 / READY_FOR_EXECUTOR / SINGLE_COMBINED_GATE / PREVIOUS_PROCESS_RETURN_REMAINS**。Owner在[PR #155独立Review](reviews/CW0005_PR155_MEDIA_PROCESS_AND_VISUAL_INDEPENDENT_REVIEW_RETURN_2026-10-18.md)确认“素材搜索下载流程RETURN，技术视频PASS”后明确“请继续下一步”。本Gate是新的**受限媒体流程动作授权**：只在当前CW0005同一个素材问题上连续完成已存历史证据追溯、一个微型多来源检索验证、必要时最多一条**未被使用过的候选视频**定向下载、技术/内容/权利分类和一份脱敏执行PR；**不授权再次渲染旧视频、替换旧片、正式制片、发布、付费或跨项目更改**。
>
> **治理**：权威`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md v0.2.7`，以Owner决定、§0–10、§11触发表和适用的11B/11C边界执行；源图本轮**禁止生图/编辑**，不触发新的11G图片模型调用。Reviewer已核对[现行交接](REVIEWER_HANDOFF_CURRENT.md)、[3+1来源合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)、[Owner素材匹配决议](VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md)、[MEDIA工具说明](../media-pipeline/README.md)、[PR#155实际ZIP审核](reviews/CW0005_PR155_MEDIA_PROCESS_AND_VISUAL_INDEPENDENT_REVIEW_RETURN_2026-10-18.md)。本Gate是所需最小闭环，**不拆成“先调查/再审批搜索/再审批下载”三轮**；内部条件和预算边界满足时允许连续执行。

## 1. 工作合同

- **GATE_ID**：`CWS-CW0005-MEDIA-PROVENANCE-BOUNDED-MULTISOURCE-VALIDATION-20261018`
- **OBJECTIVE**：消除未来制作的“只留Pexels最终链接，缺多平台候选/真实预览/选用依据/下载QA过程”这一体系性流程缺陷。对PR#155旧事实仅做不改写的证据分类，**不能后补假日志把历史RETURN改成PASS**；通过一个**只围绕S01真实“爆裂/起跳”动作**的极小检索选片练习，建立下一期均能复制的实际证据标准。这里S01旧库存素材是桌面上爆米花下落（Pexels#7677397），**不要求为新候选立刻重剪已经有效的旧片**。
- **MAX_ENDPOINT_THIS_ROUND**：
  1. 本机旧run及本项目现有媒体索引的**只读**历史核对；
  2. 最多**2种S01检索语义**（真实玉米爆裂/锅内弹跳），优先调用现成`cws_media.py discover`在本机唯一隔离MEDIA Compose中对SearXNG和4get实际检索；通过结果所归属**原始媒体网站/平台家族**对比，不能把两个搜索聚合器直接算两个媒体源；如果现有OpenMontage Pexels/Pixabay适配器无需升级/花钱即可调用，可在同样关键词下有界补一个提供方检索；
  3. 先真实预览已有候选并去重，只有发现一个**相关性与来源权利均更好、1080p优先、在历史项目台账中确实未用**的候选，才通过显式候选ID/已有合法源站下载流程下载**最多1个视频**，大小`≤80MB`、总增量`≤80MB`、不超既有80MB/2GB MEDIA硬限制、只在项目`.local`；不强制为了示范而下载；
  4. 新增一个小型项目内**结构化搜索/来源审查记录**（首选普通CSV/JSON/Markdown，沿用既有`catalog/index.json`模式，不新建长期服务/复杂搜索调度器）、一个新隔离分支PR和必要的可Review文件；
  5. 禁止新MP4完整渲染、视频片段加入正式节目、修改冻结HTML、生成或编辑AI图、TTS、开放端口、浏览器私人配置/Clash/VPN/代理全局设置、Docker镜像拉取/安装或清理其他项目资源。
- **MANDATORY_REVIEW_STOP**：Executor在本轮只交`PASS_CANDIDATE_MEDIA_PROCESS_CANARY`、`PARTIAL_SEARCH`或精确`RETURN_*`，不能宣布旧`RETURN_PROCESS_COMPLIANCE`自行取消；交新PR后停止Reviewer，不能自行合并旧PR#155或新PR。
- **TARGET_AND_SCOPE**：Owner真实Windows 11本机的`entropy-student/project:curious-world-studio/`，隔离工作树与本Gate唯一`.local/media-process-validation-20261018/`证据目录；沿用项目当前已验收但按实际host preflight确认的`media-pipeline/cws_media.py` / MEDIA工具；仅CWS项目内写入。不得为了跑SearXNG/4get再装/重建Docker平台或另造下载器。
- **OWNER_ONLY_ACTIONS**：本轮Owner的“继续下一步”授权的是**一组合法免费素材流程最小验证动作**；不授权新媒体进入已有成片、正式对外使用、任何付费许可/模型、账号权限/登录、修改Shared Infra、清理、重置和跨到下一轮视频生产。真实商业复用权仍是另一个Gate的条件。

## 2. 事先固定的五个验收原则

1. **3+1不等于三个网站必须下载**。渠道①论文/科研原作者（本轮只依已有网页/许可证证据归类，不重新破解下载论文电影），②OpenMontage已有Pexels/Pixabay，③yt-dlp为已知合法站点技术提取工具，不是第三个素材网站；具体采用哪一路凭实际动作和权利决定。**多平台候选发现**是当前生效的Owner决议，但若某平台失败须留下真实`NOT_AVAILABLE/PARTIAL_SEARCH`证据，不为凑来源伪造成功。
2. **逐层真实数字不能跳**：`SEARCH_URL_FOUND`（各检索引擎/目标域）→`URL_DEDUPED`（同一个URL等同）→`ORIGINAL_IDENTITY_DEDUPED`（同源转载/旧素材）→`PROBE_ELIGIBLE`（横屏显示比例≥4:3/分辨率，排大陆视频平台、方形/竖屏）→`CONTENT_PREVIEW_VERIFIED`（实看跳跃/爆裂动作）→`DOWNLOADED+FULL_DECODE_PASS`（只有真实下载才可算）→`REUSE_RIGHTS_VERIFIED`（权限可证明才算通过）。数字未知写`UNKNOWN`，不把预览缩略图当已下载实拍，亦不把`LINK_FOUND`冒充`RIGHTS_VERIFIED`。
3. **候选应服务叙事**：S01需画面中的实际爆裂/受热起跳或相关科学可信动作，库存“爆米花从空中落桌面”不能冒充论文中淀粉脚推起；不为获得看似多源而接受无关素材。其他S02–S10已存在T6/T5/T2科学可视化，不因此重做。
4. **项目级唯一视频使用**：历史Pexels #854959、Pixabay #2793、Pexels #1796141/#35876717、最新Pexels #7677397均登记`USED_IN_HISTORICAL_INTERNAL_SAMPLE`，**不得因视频未发布或文件改名就把它们作为下一条正式可用新源**；新视频的跨站转载、作者/页面、原始作品ID、SHA和可用的视觉近似都需判别。新下载但从未入片的候选标`UNUSED_REVIEW_CANDIDATE`，不错误计入“作品已用”。
5. **本Gate先复用已存在的能力**：只有机器/运行时允许且资源阈值满足才启现成唯一MEDIA Compose，结束时只停本轮自己启动的容器并核回环端口释放，其他项目容器不得碰。工具崩溃要有具体错误分类；不得“为了流程PASS”重写媒体基础设施。下载来源未知/权利未知时可以仅记录候选并跳过下载，不阻塞对搜索流程本身做有证据评价。

## 3. 连续执行序列（一个Gate，不额外等Owner批准）

**PRE-1／安全宿主与历史回读**：证明Windows Owner实际主机、Git工作树/隔离分支、非目标未跟踪/ignored文件并确保不覆盖。定位PR#155对应本机run已存在的`reports/MEDIA_SEARCH_DOWNLOAD_LINEAGE.md`、`evidence`、媒体/媒体库索引；只读查过去搜索记录或存在的`catalog/index.json`查询事件，记录`PR155_HISTORY=RECOVERED | PARTIAL | NOT_RECONSTRUCTIBLE`及每项依据。**没有就结束历史追溯，不擅扫Owner私人浏览器全历史**。本步骤不可通过事后新搜索伪装成历史查询证据。

**PRE-2／真实能力与本轮预算**：`cws_media.py doctor`需先查其实际副作用和针对已存在目录的读取位置，记录Python/ffmpeg/yt-dlp/Compose/docker资源可用性，默认内存≥1664MiB、剩余硬盘≥2GiB由现有工具验证；当Docker或任一服务未达到健康门槛时，按其现状分类而非重装/清理。若已有OpenMontage可轻量用，审查真实安装/插件/密钥是否已就绪，不为一次搜源创建新帐号或跑收费API。

**STEP-A／最多2检索语义的小样本发现**：冻结S01需求关键词（如`popcorn kernel popping in pan close-up` / `popping corn kernels jump stove slow motion`）与明确不匹配条件；有界调用`cws_media.py discover --kind video`，基于现成SearXNG+4get每次返回的实际结构化JSON按搜索引擎×**原始媒体站点**统计，并另记录OpenMontage/Pixabay的调用情况或未调用原因，查询同一个工作目录以利用旧索引去重。严格记录`OK / PARTIAL_SEARCH / SEARCH_FAILED / NOT_USED`与上游失败，不要自动改成`--allow-partial`伪装全PASS；可针对已知、支持、无需付费的源站做有界补搜，不重复全网遍历。**本Gate追求可审计的对照，不规定一定获取两个不同域名的成功视频**。

**STEP-B／候选实看与最多1条实际下载**：使用已有索引只列前几条真实相关视频（不把列表从未核验的“SEO标题”当画面验证），经过源站预览或合法小段逐帧/播放，明确为何选/弃与候选横屏、≥1080p优先、作者、rights、原作品身份。**只有确认比当前S01下落画面更接近爆裂/起跳且免费合法获取、未用原素材时**，选明确catalog ID做格式`probe`和`fetch`至项目独立`.local`，数量至多1，源文件≤80MB；FFprobe/FFmpeg完整解码/SHA/关键帧5张、真实分辨率/帧率，单一媒资Rights不确定则维持`PARTIAL`并不放入正式片。不能为了凑满下载1条而主动降低内容相关性。

**STEP-C／结构化记录和交付**：交付一份小型`SEARCH_LINEAGE.json`或等价csv（每个query×engine×site的结果/错误/时长）、`CANDIDATE_SELECTION.json`（包含规范化作品ID、是否跨站重复、视频实际动作、被排除原因）、`ACQUISITION_QA.json`（选ID+权限+实际源SHA/解码及下载预算；没下载时标`NOT_NEEDED`）、`HISTORICAL_RECONCILIATION.md`（不伪造PR#155查询历史）、`NEXT_MEDIA_CONTRACT.md`（以后每个镜头可直接复用的最小取材检查序列）。可放在隔离分支`curious-world-studio/docs/reviews/`的新报告及脚本无须进入正式源码；原始媒体、搜索响应中的私人字段、原图/视频不可上传Git，仅Owner本机忽略目录保留。**无需修改任何production应用、冻结模板、已认可WAV/SRT/MP4**。完成后新PR/Commit及已保存证据路径/哈希，交独立Reviewer。

## 4. Gate PASS / RETURN 边界和回滚

- **新流程PASS仅表示前瞻性的操作链已被独立检验**，并不能让PR#155既有下载历史变成“原来就执行了多站搜索”。独立Reviewer按`ACTUAL_INSPECTED`核全程事实，可能判`PASS_MEDIA_DISCOVERY_PROCESS_CANARY / PARTIAL_MEDIA_SOURCE_RIGHTS / RETURN_PROCESS_EVIDENCE`等精确结果。
- 现阶段`CW0005_59S_MP4_TECH_PASS / RETURN_PROCESS_COMPLIANCE_PR155 / IMAGEGEN_PARTIAL_PASS / VISUAL_IMPROVED_OWNER_NOT_ACCEPTED / VOICE_BY_EAR_UNVERIFIED / NO_PUBLISH / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL`均继续有效，不因新搜索自动改变。
- 回滚仅涉及本次隔离PR和新候选媒体目录；旧PR#155、两条59.93秒视频、3张AI图、历史`.local`索引、冻结V5.6.2全部保留。任何Git漂移/媒体目录归属不明/已有容器异常/权限失败先停线，不能盲删重跑。
- **不得使用“再多找素材”当作新视频制作授权。** 如果Owner当前样片的审美未接受，下一轮才决定是否真正替换S01；当前不渲染、不追加新视效。

## 5. REVIEWER_TO_EXECUTOR_RELAY

> 请执行 **`CWS-CW0005-MEDIA-PROVENANCE-BOUNDED-MULTISOURCE-VALIDATION-20261018`**。Owner已经授权此有界单轮流程修复，**一次做完旧证据核实→最多两组S01搜索→聚合候选去重/真实预览→必要时最多1条未用视频下载+QA→脱敏PR报告**，不需每步审批。先读**本Gate**，再定向读 `docs/reviews/CW0005_PR155_MEDIA_PROCESS_AND_VISUAL_INDEPENDENT_REVIEW_RETURN_2026-10-18.md`、`docs/VISUAL_ASSET_MATCHING_DECISION_REGISTER_2026-10-16.md` 已确认②项和原视频唯一使用、`docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md` 3+1合同/权利、`media-pipeline/README.md` 和`media-pipeline/cws_media.py` CLI入口、PR#155本机`reports/MEDIA_SEARCH_DOWNLOAD_LINEAGE.md`（可查其源ZIP）。Reviewer已完成Governance和历史文档解释；**不要重读全部CWS历史或重新扫描155条文档**。如果实际机器、服务、授权、网络无法满足准则，保留已获得的证据并精准RETURN，不通过暗中换架构/支付/跳过失败来制造PASS。
>
> **EXECUTOR_TO_REVIEWER_RELAY**：依Governance七行简报（结果/改动/验证/问题/回滚/请Reviewer检查/Owner转交），附新PR、HEAD SHA、实际检索/下载记录脱敏文件路径和必要的Reviewer可接触文件。严禁新全片、额外AI图、任意付费或PR合并。Owner正式审美/发布决定以后独立处理。
