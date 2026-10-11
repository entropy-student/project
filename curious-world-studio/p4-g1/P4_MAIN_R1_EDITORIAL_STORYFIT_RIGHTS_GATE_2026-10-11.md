# CWS P4 主线 R1｜CW0002 vs CW0005 首期 Story-Fit／真实画面与权利比选（只读）

> **GATE_ID:** `CWS_MAIN_R1_STORYFIT_SOURCE_RIGHTS_READONLY`  
> **权限**：Owner已授权“你做编辑取舍，我复核”的主线协作规划；这份任务仅包含**仓库与公开原始资料只读审查**，**不修改题库、不下载授权未知的研究影像、不做付费或账号访问、不联系作者、不渲染**。执行状态 `READY_FOR_LOCAL_CODEX_RELAY / NOT_EXECUTED`。只在用户将本指令转交给主线 Windows Codex 后运行本地部分。
> **约束来源**：[主线协作泳道](../docs/P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)、[正式选题流程](../research/topic-bank/WORKFLOW_V1.md)、[3+1正式素材合同](../docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)、[Aqua 2/4/6视觉语法](../docs/P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md)、[CW0002此前预检](../docs/P4_CW0002_STORYFIT_READONLY_PREFLIGHT_2026-10-11.md)。

## 目标与选择机制

从正式题库中最短路径选择**一条有机会拍成第一期的视频**，不要只看标题或程序能否运行。严格只读比较：

1. **CW-0002**：大象想让同伴离开时，会注意它有没有在看吗？ Owner先前明确偏好。已有Animal Cognition原论文首轮事实预检；实拍的具体可用视频/原来源/复用许可缺口大，优先核实。
2. **CW-0005**：爆米花为什么既会跳又会响？已为SHORTLIST、可查真实高速摄影研究，**是否具备原片、商用权利和三次故事推进尚未知**；作为内容明确、动作可能易观察的备选，不因直觉就认定更容易/已授权。

禁止只因另一题容易拿素材就忽略既定观众承诺；**科学事实、观众吸引、故事推进、真实画面可获得、复用权**五个维度必须并列独立评价，必要时提供取舍理由。两个题都不可拍则 `RETURN_BOTH_SOURCE_GAPS` 而非强行开拍。

## 最少必须交出的4份只读产物

### 1. 一手论文核验对照

- 对CW0002读取原研究和对应图表统计，明确作者、发表日期、方法、样本条件、研究局限、视频补充材料地址（如公开）。把“找视觉注意”“等待回应”“手势与目标”分清楚；研究录像存在 ≠ 录像已发布或授权。
- 对CW0005读取原论文与高速摄像、声音记录的Methods和结果。区分爆米花“跳”发生机制与“响”机制；避免把不同实验镜头拼成同一次实录。
- 输出每个事实 `claim_id / exact_original_source / finding / limitations / supporting_figure_or_table`；对于未完整读到的原文标 `UNVERIFIED`。

### 2. 原始“观众看得见的动作”镜头候选清单

- 优先作者、期刊补充、实验室、研究机构原网页，检索每个可定位的视频/图。每条分别记录 `URL, uploader/organization, original_media_identity, source_in/out, frame/visible_action, evidence_label`；没有实际看过就标 `NOT_FRAME_REVIEWED`，不能以新闻概括代替画面。
- **权限分三状态**：`LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED`，单项显示PASS/UNKNOWN/FAIL；论文CC BY并非当然给予外站或作者原录像商用权。研究片不能拿到时可查OpenMontage来源或yt-dlp已知合法URL，但**辅助素材必须标签清楚，不能拿泛大象影像冒充本研究观察样本**。
- 本轮仅只读在线看源站允许公开展示的内容和许可信息，不下载视频/音频、不绕过注册、DRM、反爬、YouTube登录挑战、不擅自请求作者许可。对明确可用的媒体记录候选，仍不下载。短引可能涉及法定引用但不能自动判商业复用已经有权；交独立Owner/法律合规确认。

### 3. 两题各3个独立叙事推进节点

- 以观众问题为中心，每节点必须说明新问题→新增证据→观众答案如何变化→需看具体什么真实动作/静态论文图→媒体证据/权利。不能一条答案变成三句重复。
- 按用户偏好的“近且未深思的问题”和“把一个解释讲准/追到一个答案”约束，不预先指定4–6分钟必须凑够长度；有价值时自然短。
- 列出 B站同类主题对标的真实查找情况；无法全面验证标 `PARTIAL`，不虚报内容市场验证。

### 4. 编辑决策表与Reviewer可复核结论

| 栏目 | CW0002 | CW0005 |
|---|---|---|
| 事实可信度与明确边界 | 证据 | 证据 |
| 三次独立推进是否成立 | GO/COND/HOLD + 理由 | GO/COND/HOLD + 理由 |
| 能看见真实行为的画面候选 | 链接+时码+是否实际播放 | 同左 |
| 研究素材可否合规复用 | PASS/UNKNOWN/FAIL+依据 | 同左 |
| 观众吸引与B站竞品覆盖 | 真实证据+覆盖声明 | 同左 |
| **编辑建议** | GO/CONDITIONAL/HOLD | GO/CONDITIONAL/HOLD |

执行Codex只提交事实与候选建议；**Reviewer（我）依据证据选主选题，必要时改选备选**，并提交给Owner在R2一次复核，不让Owner先陷入低价值的每个搜索选项。素材权利或关键真实性未证不得选为`PRODUCTION_READY`。

## 实际执行/停止/交接

- **边界**：不改`TOPICS_V1.json`、`BOARD_V1.md`、`WORKFLOW_V1.md`、STYLE_LOCK、Remotion、M2源码、Mac HTML/ZIP或本机代理；不运行FFmpeg渲染、TTS、yt-dlp下载或新安装。无需访问Windows共享目录。
- **输出**：新隔离目录的 `R1_CW0002_CW0005_SOURCE_EVIDENCE_MATRIX.md`、`R1_FOOTAGE_RIGHTS_LEDGER.md`、`R1_STORY_BEATS_COMPARE.md`、`R1_REVIEWER_RELAY.md`，且附原链接/采集日期、信息不确定和失败列表。执行器勿自称题库状态晋级或G1 PASS。
- **STOP**：至少一个核心实验事实有冲突/画面证明不够、许可无法验证，则降为`CONDITIONAL_SOURCE_GAP`或HOLD、保存具体补证据动作；不伪造论文录像、不借助AI图或重复素材。
- **回报给Reviewer**：两题都给同结构证据；当前事实vs推断分开；明确主推候选和仍缺的每个镜头/权利、下一轮R2需要Owner复核的少量关键内容；不直接执行R2/R3。
