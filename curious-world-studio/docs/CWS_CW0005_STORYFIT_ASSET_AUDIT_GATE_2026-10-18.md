# CWS｜CW0005真实视觉Story-Fit：已有素材只读盘点Gate（2026-10-18）

> **状态：OWNER_AUTHORIZED_BOUNDED_AUDIT / EXECUTOR_NOT_STARTED / REVIEW_REQUIRED。**
> 此Gate由Reviewer依据Owner在当前对话批准“开始下一轮”并澄清“Codex可独立读写GitHub仓库，旧提示词及ZIP未下发”后设定。授权仅限现有素材的只读盘点、候选视觉映射与隔离PR中非敏感文字证据提交；**不授权新媒体获取、图片处理、视频制作、正式R4、改变项目HOLD或直接合并**。旧ZIP不是Codex输入，也不需要Owner传包。
> **规范基线：** `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7（Reviewer已按 §0–13核读、触发扫描；Executor不需重读全规范）。
> **已接受基线：** V5.6.2冻结HTML Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`；旧V5.2保持；PR#144仍Draft未合并。CW0005 R2十句旁白和S01–S10仅编辑PASS；旧R3 55.367秒真实MP4被Owner以视觉Story-Fit否决，**旧R3 Gate已经用完，严禁重新执行**。
> **本Gate不是⑤/⑭的PASS，也不是七轮计划中R1的自动实施许可。**

## Gate合同

**GATE_ID**：`CWS-CW0005-EXISTING-VISUAL-ASSET-AUDIT-20261018`

**OBJECTIVE**：基于现有R2旁白和科研论文，盘点Owner Windows本机CWS既存的研究图像、横屏实拍视频、预览和素材台账；核对真实性、作品级去重与权利状态，提出S01–S10逐镜候选及明确缺口，让Reviewer判断是否值得单独签发30–60秒视觉预览Gate。

**MAX_ENDPOINT_THIS_ROUND**：仅一轮本机已有文件/现存catalog/manifest/图像预览的只读审核，附逐镜头映射、Figure 1/3a/6核对表、最小缺口清单；将**脱敏文本证据**写在从最新main派生的CWS隔离分支PR内后停止。任何媒体下载、联网搜片、画面抽帧落盘、新图生成、字幕配音/视频渲染、源码修补及main写入均超界。

**MANDATORY_REVIEW_STOP**：Codex的结论最多`PASS_CANDIDATE`或精准`RETURN_*`；不得写正式PASS、修改`CURRENT_STATE`/`REVIEWER_HANDOFF_CURRENT`/冻结HTML/Owner决策、合并PR或自行进入视频预览、R4与正式制片。

**TARGET_AND_SCOPE**：`entropy-student/project` → `curious-world-studio/`；Owner原生Windows 11本地既有文件只读；GitHub只可在本项目路径的**独立分支PR**写脱敏文字报告/必要的`EXECUTION_EVIDENCE`追加候选。允许新建一个项目内`.local/`忽略目录保存本轮工作报告，不得覆盖或删除历史文件；不动其他项目、共享服务或Git拓扑。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- Research Aqua唯一原Mac/QuickTime外壳、T1–T6、单Master Clock、冻结原字节全保留；⑪时码语义暂缓。
- 先锁定R2全部十句旁白，搜索/匹配期间不可改稿；原论文科学事实、确定/假说区分不变。
- 素材A=既存视频（含录屏）、B=既存静态图，C=AI静态示意仅方向允许、**本轮禁止实际生图**；不创造第七模板、新Mac、MW第十四项。
- Pexels **#854959** 与 Pixabay **#2793** 已用于旧R3，即便文件还在也须列 `BLOCKED_ALREADY_USED`，不得复用于未来新片；所有原始视频项目级同源只用一次，重命名、镜像、裁切、转载不产生新身份。此禁令不自动适用静态论文图片。
- `LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED` 独立记录；论文开放可阅读≠确定获得再次传播或商业使用权。未知则`UNKNOWN/PARTIAL`；真实实验/论文证据与辅助库存画面不可混标。
- 素材匹配相关且不误导即可，不把找到论文精确高速视频作为硬门槛；拒绝同源画面重复充数和纯文字讲核心机制。不设素材占比硬指标，也不因内容缺口自动扩大操作授权。

**PREFLIGHT**：
1. 在目标Windows本机核实主机/用户/工作目录与仓库根、当前分支与HEAD；只读检查CWS及整个共享仓库的已修改、未追踪、旧缓存现状。不可`reset --hard`、`clean`、覆盖`.local`、全局Docker清理。
2. 核对目标GitHub main现行CWS状态与指定输入文档；若CWS权威源/Owner权限或文件基线发生实质漂移，则先停止返回`RETURN_PREFLIGHT_DRIFT`，不得猜测重建旧基线。
3. 若要将证据写GitHub，使用**新的隔离分支或独立工作树**，只改许可范围内文件；验证Git读写目标确系此仓库，且不会混入旧未提交改动。不能安全隔离则保留本轮只读结果并精确RETURN。
4. 元数据尽量使用既有索引/FFprobe只读访问；不得启动Docker服务、改变网络/代理/VPN/Clash/安装组件，也不得通过“验证”名义抓取远程图片。

**REQUIRED_EVIDENCE**：
- S01–S10逐镜表：`shot_id, narration_id, visual_purpose, proposed_T, candidate_source_identity, original_local_path_status, existing_SHA_or_manifest, existing_metadata, observed_content_evidence, prior_use, provenance, rights_state, fit_or_gap`。已知与未知分别明确；公网上可访问的网页链接不等于本机存在文件。
- 原论文 Figure 1 / Figure 3a / Figure 6 分表：证据用途、已有本机原图存在性、图像可读性、图源身份、Figure编号、原图与外部图解区别、许可凭证或UNKNOWN、T4/T5视口适配风险。论文：Virot & Ponomarenko (2015), `Popcorn: critical temperature, jump and sound`, DOI `10.1098/rsif.2014.1247`，https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/ 。不要无证断言图像已下载或允许商用。
- 整体**作品级去重**报告：两条旧视频为BLOCKED，并区分每个新候选是否与其他已用视频同源；旧22视频/31图片只属历史数字，不等于本机现存。
- 精确缺口与下一步最低成本建议：现有材料能覆盖哪些画面、哪些只有候选链接、哪些需要未来定向搜片或Owner权利判断；不启动下一轮。
- 脱敏Git提交和PR地址、涉及文件清单、Commit SHA；对不宜上传的绝对用户路径、私有工作目录、媒体原件、Cookie/Token、全量日志等只保留Owner本机，不进Git。Reviewer未见到的实际影像不得声称其已独立验收。

**ACCEPTANCE_CRITERIA**：Reviewer能够从PR和可访问的源证据核查逐镜映射、作品级去重、图号/研究事实、权利状态与缺口的正确分类；有界操作与保全可读回。**本轮至多能通过“素材盘点/候选视觉方案”**，不能凭执行者文字自述判⑤真实画面上屏或⑭连续观感正式PASS；不可用新TTS/MP4或媒体下载补证。资料缺失时以真实`PARTIAL/UNKNOWN`完成有价值的盘点，不虚构素材。

**ROLLBACK_STATUS_OR_PLAN**：旧CWS数据、旧Git工作区及两版冻结HTML从未写入；只放弃/回退本轮隔离分支的新证据提交即可撤销Git改动，不清除Owner本机历史数据。写入前后核对分支diff和目录范围；发生非授权文件变动、源身份不明或权限漂移立即停止并报告。

**OWNER_ONLY_ACTIONS**：新付费、下载/另找外部素材、AI生图、素材许可例外、正式预览制作、R4、合并/改变现行HOLD、公开发布与不可逆删除必须另外取得Owner授权；**本Gate不包含这些动作**。Owner转交默认`NONE`，可直接将本文GitHub地址交Codex。

## REVIEWER_TO_EXECUTOR_RELAY（Codex唯一直接入口）

**可直接依赖的事实**：V5.6.2技术PASS及原14项11项技术关账；R2十句编辑PASS，R3成片视觉RETURN；素材PR#129/#131已合并，无需重跑工具验收；历史Pexels/Pixabay两原视频本项目视为已用；现有素材是否在盘仍`UNKNOWN`。

**只读下列输入；不必通读Governance或旧历史**：
1. 本Gate（当前完整工作合同）。
2. `curious-world-studio/docs/CW0005_R2_ACCEPTED_NARRATION_AND_SHOTS_2026-10-16.md`（十句与S01–S10）。
3. `curious-world-studio/docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`（素材真实性/权利/去重）。
4. `curious-world-studio/visual/retro-mac-v1.2/docs/STYLE_LOCK.md`（画面可读/视觉价值）。
5. 仅在必须确认接口时针对性读取`curious-world-studio/visual/frozen/storyboard-v5-6-2-20261018.html`的T1–T6函数、非变更性的源码。
6. 本机已有库存的manifest/catalog及项目内忽略目录，限必要的本项目素材相关目录；无需全仓历史文档遍历或网络搜索。

**建议首轮候选映射（只作检查线索，不是已验收素材）**：
| S | 视觉任务 | 推荐已有模板 | 需要核实的材料 |
|---|---|---|---|
| S01 | 看到真实爆裂/跳起，建立悬念 | T1 | **未用**真实动作视频，找不到就标缺口 |
| S02 | 温度升高与爆开比例 | T4 | 论文Figure 1真实统计图 |
| S03 | 区分样本统计与单粒行为 | T2 | Figure 1中已有颗粒/爆后形态；必要时其他独立静态实图 |
| S04 | 引出真正跳跃研究 | T4 | Figure 3a原研究连续高速图 |
| S05 | 淀粉脚形成、受压、回弹 | T5 | Figure 3a不同**真实静态帧**（不是三条独立视频） |
| S06 | 纠正“喷汽火箭”直觉 | T3或T1 | 同一论文跳跃证据与准确简短说明，不能用普通库存片证明“未观察到” |
| S07 | 切换到第二组声学实验 | T4 | Figure 6摄影与声学同步证据 |
| S08 | 二次破裂后6ms声音 | T2或T3 | Figure 6真实波形和相应时点；禁止伪声纹 |
| S09 | 区分作者声源假说 | T1或T3 | 已核验的另一独立实拍或审阅过的论文图，标“假说” |
| S10 | 收束跳跃机制与声音假说 | T2 | Figure 3a与Figure 6两证据对照，不用全屏结论文字卡 |

**EXECUTOR_TO_REVIEWER_RELAY**：提交一个新的CWS审阅PR，仅包含本轮脱敏报告和附加的候选`EXECUTION_EVIDENCE`记录（可在隔离分支中追加，不得直接改main）；在对话以7行固定形式说明**结果、改动、验证、问题、回滚、请Reviewer检查、Owner转交**，贴PR URL和Commit SHA；**停止，不进入下一Gate**。

## 当前与下轮边界

当前正式状态仍`CW0005_R3_RETURN_OWNER_VISUAL_STORYFIT / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH / RIGHTS_PARTIAL`。若此Gate经Reviewer判定材料盘点可接受，下一步也只能**提出**单独30–60秒视觉连续预览Gate；不自动渲染。
