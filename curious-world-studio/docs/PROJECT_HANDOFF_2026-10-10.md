> **统一当前状态**：请先看 [CURRENT_STATE.md](CURRENT_STATE.md)。本文件是**历史接手快照**，其中旧“21 条”“在线运行尚未验收”“P0/P1 待办”记录已过时，不可直接当现行指令。P0/P1 已有线上成功记录，九源仍 PARTIAL，当前研究重点已进入 P3-R2。

> **2026-10-10 P1 增量接手提醒（优先于以下历史状态）**：在线采集和覆盖审计已推进，见 [P1 审计](../research/topic-bank/batches/2026-10-10_COLLECTOR_P1_COVERAGE_AND_TOPICS_REVIEW.md)。GitHub Actions #38022100048：24/24 测试、4 个 artifact、537 条窗口元数据。PLOS 303 篇保留，新增 143 条仅供人工审阅的专题提示清单；九源全量仍 PARTIAL，正式题库 36 条与 HF-FIND / Mac v1.2 不变。

> **本文件是 2026-10-10 的历史快照；最新增量请优先看**：[P2-A 抽样及历史来源核查](../research/topic-bank/batches/2026-10-10_P2_CALIBRATION_AND_ARCHIVE_FEASIBILITY.md) 与 [40 条 DOI 逐项评分](../research/topic-bank/batches/2026-10-10_P2_PLOS_40_ABSTRACT_REVIEW.md)。P1 合入 main `bf16fd9`，24/24 测试已在主分支真实验证；P2-A 40 条样本只做单模型标题/摘要初审；九源完整性仍 **PARTIAL**，正式题库仍 36 条。切勿将旧的 P0/P1 待办覆盖为当前状态。

> **本文件是历史交接快照。2026-10-10 最新增量**：[P2-B/C 原始研究及官方日期窗对账](../research/topic-bank/batches/2026-10-10_P2B_PRIMARY_REVIEW_AND_P2C_CROSSWALK.md) + [Owner 题目质量投票](../research/topic-bank/batches/2026-10-10_P2_OWNER_TOPIC_QUALITY_GATE.md)。已核 5 篇 PLOS 原文，确定初步推荐巨噬细胞、点击声；MIT 3/3、NASA 3/3、Nature 2/2、JEB 7/7 当前可见子集对账仅为局部证据。**独立二审、Owner 意愿、正式 STORY-FIT、媒体许可和九源完整性仍未通过**。TOPICS 保留 36 项。

> **增量接手｜2026-10-10 P2-D 最新 Owner 校准**：Owner 主动排序 **B 毫秒级听觉声音问题第一、D 认知负荷风险决策第二**，同时说四题整体都不错，未否定 A/C。提出个人偏好「日常离自己近，却未仔细观察/思考」，**只是假设，不等于 B 站观众数据**。已有记录：[P2-D Owner 选择和证据复核](../research/topic-bank/batches/2026-10-10_P2D_OWNER_BD_PREFERENCE_AND_EVIDENCE.md)；B 补充音频已定位但未试听/核授权，D 的认知负荷与 tDCS 不可混成单因果。原正式题库 36 条、主协议、视觉均未改；下一步小范围真实观众盲选与独立原文校验，暂不写剧本或晋级。

# Curious World Studio｜新聊天 / Reviewer 完整接手快照

> **【历史 P3 编辑建议，观看机制 P3-R1 后需要重评】2026-10-10 P3 决策待批**：[B/D STORY-FIT 资格＋证据压力测试](../research/topic-bank/batches/2026-10-10_P3_BD_STORYFIT_ENTRY_GATE_REVIEW.md) 已完成，B/D 均不在 36 条 TOPICS，不能自动正式晋级。旧 B 申请 SHORTLIST / D 暂 HOLD 是早期实验节点导向的判断，现在等待 P3-R2 叙事机制比较。OpenMontage 本地技术已据 Owner 交接 READY，但视频生产前仍须 Owner 明确批准。

**快照日期：2026-10-10｜接手优先级：P0｜只针对 `entropy-student/project/curious-world-studio/`**

> **【原始历史快照的过期状态，不得据此重跑已成功 P0/P1】当时确认频道方向与 36 条题库，但尚未取得远端 run artifact；如今 P0/P1 在线运行已证，九源全量仍 PARTIAL。当前阶段以 [CURRENT_STATE.md](CURRENT_STATE.md) 为准。**
>
> **本文件是 2026-10-10 对话交接摘要**；所有研究论据、数据与许可的细节分别以链接的原始报告、母数据和权威规范为准。历史文件若包含过时的“下一步”，以本文件最新阶段状态优先；不要静默删除历史证据。

## 0. 仓库范围与接手入口

- GitHub **已有公共项目库**：`https://github.com/entropy-student/project`，分支 `main`。
- **唯一项目目录**：`curious-world-studio/`。这不是独立新仓库。所有新文件/代码限制在本目录；例外是已经存在的仓库级只读工作流 `.github/workflows/cws-source-audit.yml`。**不得动其他一级项目**。
- 第一批必读：[`../README.md`](../README.md) → [`../AGENTS.md`](../AGENTS.md) → [`STATUS_AND_DECISIONS.md`](STATUS_AND_DECISIONS.md) → [`../REVIEWER_HANDOFF.md`](../REVIEWER_HANDOFF.md) → **本文件**。
- 分项权威：
  - 频道定位：[`CHANNEL.md`](CHANNEL.md)
  - HF-FIND **唯一**研究主协议：[`../research/HF_有趣发现_唯一主协议.md`](../research/HF_有趣发现_唯一主协议.md)
  - 严筛九源：[`../research/SOURCE_SYSTEM_FINAL_V1.md`](../research/SOURCE_SYSTEM_FINAL_V1.md)
  - 跨领域选题库流程：[`../research/topic-bank/WORKFLOW_V1.md`](../research/topic-bank/WORKFLOW_V1.md)
  - 母表：[`../research/topic-bank/TOPICS_V1.json`](../research/topic-bank/TOPICS_V1.json)；看板：[`../research/topic-bank/BOARD_V1.md`](../research/topic-bank/BOARD_V1.md)
  - 视觉唯一锁定：[`../visual/retro-mac-v1.2/docs/STYLE_LOCK.md`](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)；具体变量 `../visual/retro-mac-v1.2/config/design-tokens.json`；HTML `../visual/retro-mac-v1.2/preview/index.html`。

## 1. Owner 对内容的明确方向（已讨论确认）

- **平台与长度**：B 站为主，小红书/抖音为辅；目标一条**约 4–6 分钟**（约五分钟），不要求每篇凑满五分钟。目标是闲暇时愿意沉浸观看、轻松见识新事物的普通观众；不能将其简化为只爱 AI 的小圈子。
- **作品类型**：暂称「探索型知识叙事」：**像一个好奇朋友带观众跟着一个问题，一步步观察真实现象、理解它为何发生、看研究者怎样验证、产生新的疑问与发现**；不是论文摘要机、新闻稿搬运、单个结果科普或纯教程。Owner 举过 B 站毕导、赛博食录的逐步推导观感作参考，不要求复刻其固定结构。
- **核心文案/编辑承诺**：「**知识小众，问题大众；现场具体，过程有趣；证据真实，承诺兑现**」。`curious-world-studio` 仅项目代号，中文「世界有点意思」仅候选，**频道正式名称、Logo、声音/音乐、固定口播都未定**。
- **选题不局限 AI**：Hugging Face Daily Papers 是好用的长期科技发现源，但现已确认向衣食住行、动物行为、食品、人体感知、心理、自然、出行、科技等全面扩展。**领域不是卖点，探索过程与编辑判断才有机会成为差异化。**
- **选题与故事的关系**：点击冲动 ≠ 标题兑现 ≠ 五分钟节目承载力。不能因标题好听或有视频就直接写剧本，也不能对没有额外内容的论文硬凑时长。
- **两条作品策划路线均保留**：A「从一项有趣但短的研究出发，结合严谨的其他研究与原创观察互动，形成完整探索」；B「优先找到原始研究本来就自带多阶段实验、反转、失败重试或影响，减少额外拼接」。**编辑上暂优先 B，A 不淘汰**。报告：[`STORY-FIT 双路线试验`](../research/reports/2026-10-10_STORY_FIT_双路线试验.md)。
- **真实反馈**：
  - EyeRobot《为什么插吸管前先看杯子》标题吸引，但 Owner 听完认为答案仍是「机器人也要学会看哪里」，**当前切口 REJECTED**，不是声称论文有问题；
  - Strike a Chord《会动的字母》标题与基础承诺兑现，但单论文自然支撑偏短；可拓展到几何运动/意图归因，但**没有证据就不拼心理学解释**；
  - Owner 最初点击愿望：会动字母 ＞ 沙子变面团 ＞ 机器人；同一道机器人问题换成「为什么先看杯子？」兴趣明显提高，证明措辞非常影响点击；
  - 九源样本中 Owner 主动选中「大象是否知道别人有没有注意」「会说话的果冻还舍不舍得吃」「学习网站卡两秒」三题，**没有表示这三题内部排名**。反映「可代入处境＋直觉判断→证据反差」的潜力，不代表真实平台数据。校准证据：[点击校准报告](../research/STORY_FIT_CLICK_CALIBRATION_2026-10-10.md)。

## 2. 已锁定的七阶段顺序（不可抢跑）

```
九大信息源（SOURCE SYSTEM）
  → 按日期/来源批量发现（DISCOVERY BATCH，先记全且报告覆盖）
  → 统一初筛、证据/标题审查及四轴判断（EDITORIAL GATE）
  → 正式选题库（TOPIC BANK，含完整状态、ID、去重和淘汰原因）
  → STORY-FIT 五分钟叙事深审（4–6 分钟是否自然成立）
  → 剧本与逐片素材/版权/时间轴核实
  → 视频生产、QA、发布及观众反馈回填
```

- 当前工作处于**第 2～4 阶段的「可重复采集与覆盖审计」**，下一步优先拿到真正运行的、可复查分母的采集结果，而不是又挑两题直接撰写脚本。
- 初筛四轴：**HOOK 点击、SURPRISE 答案增量、PROGRESSION 至少三步独立真实推进、VISUAL 实际画面/合法自制可能**；HIGH/MED/LOW/UNKNOWN 是编辑假设，**不能机械打总分，也不是 B 站真实点击数据**。
- 重要状态：`SHORTLIST` 只是准许进入 STORY-FIT 深审；`VERIFY` 是补证据；`HOLD` 是当前过程/画面不足；`REJECTED` 是当前切口失败。**任何 SHORTLIST 不等于 STORYFIT_GO / PRODUCTION_READY。**
- 影视素材状态 `LINK_FOUND`、`CONTENT_VERIFIED`、`REUSE_RIGHTS_VERIFIED` **必须独立**，研究摘要、新闻稿、项目演示链接、视频商用权四者不相互替代。

## 3. 九源体系（2026-10-10 V1.0 已确定）

| 层次 | 来源 | 角色 | 采集边界 |
|---|---|---|---|
| 每日 1 | **HF Daily Papers** | AI/机器人/交互视觉科技 | HF 日榜本身并非所有论文发表目录；HF-FIND 唯一协议不许修改 |
| 每日 2 | **MIT News Research** | 装置、材料、科学实测 | 研究机构新闻≠原始论文；RSS 滚动不保证历史全量 |
| 每日 3 | **EurekAlert!** | 横跨衣食住行、动物、心理与自然的科学新闻稿发现 | 网站直达曾 403，**没有确认合法公开 RSS/API**；暂人工/网页发现，勿绕过访问限制 |
| 每周 1 | **JEB / Inside JEB** | 动物行为、生物运动 | Inside JEB 是解说；需追 JEB Original Research；Crossref DOI 索引不等于 Accepted Manuscripts |
| 每周 2 | **NASA Earth Observatory** | 自然卫星影像/地理变化 | Image of the Day 不代表 NASA 所有栏目 |
| 每周 3 | **PLOS 专题** | 心理、行为、生活实验、开放论文 | 按主题/Article Type 过滤，勿用全站文章数当节目的原始实验数 |
| 每周 4 | **Nature 主题** | 食物、心理、人类行为与环境 | 订阅/登录壁垒，News & Views 与原创论文类型须分清 |
| 核实底座 1 | **OpenAlex** | 全学科检索、反查 DOI、去重 | 不是同行评审系统，也不按“全站每日扫描”任务使用 |
| 核实底座 2 | **PubMed** | 生物、健康、人体/食品与感知研究的文献核实 | 索引不等于所有记录均为已同行评审的原始实验 |

- 低频备用：USDA ARS、arXiv RSS、Nature Food 定向文章；Phys.org/ScienceDaily 等只能做线索，不能作为科学结论的唯一证据。
- **“9大”按 3+4+2 的职责划分；不是 9 个同样能稳定每天爬取的 RSS**。权威合同：[SOURCE_SYSTEM_FINAL_V1](../research/SOURCE_SYSTEM_FINAL_V1.md)。旧 `SOURCE_REGISTRY_V1.md` 是历史候选版，勿误当最新执行规范。

## 4. 真实选题库与审计结果（已远端确认）

- 机读数据：`research/topic-bank/TOPICS_V1.json`；人读数据：`BOARD_V1.md`，均已提交仓库 `main`。
- **36 条独立候选角度**，ID `CW-0001` ～ `CW-0036` 唯一；状态：**SHORTLIST 11 / VERIFY 15 / HOLD 9 / REJECTED 1**。
- 构成：历史研究和定向核对回填 **21 条**，再从 2026-10-07～09 **部分来源扫描**新增 **15 条**，其中 **2 SHORTLIST / 8 VERIFY / 5 HOLD**。历史候选不得冒充此三日新发现。
- 三日审计：[2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md](../research/topic-bank/batches/2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md)。
- **非全量**：HF 打开三日日期页但没有完成全标题/摘要穷举；MIT 主要浏览研究列表一页；EurekAlert 搜索结果/团队新闻但其原站 403；JEB 当时看到 7 篇 Accepted Manuscripts 并深入部分；NASA 的 Image of the Day 3/3；Nature/PLOS 仅主题取样；OpenAlex API 未实际跑通，PubMed 按需查。
- **整个母表所有媒体使用权 UNKNOWN；没有任何条目正式通过 4–6 分钟 STORY-FIT；B 站竞争分析未系统完成，不能宣称市场空白、稳定选题率或可直接开拍。**

### 最重要的候选状态及事实边界
| ID | 题目 | 状态 | 注意 |
|---|---|---|---|
| `CW-0001` | 会说话的果冻是否舍得吃 | SHORTLIST，Owner 点选 | 2024 实验真吃，2026 仅看视频评价；心智感不同但内疚差异不显著；不能合并研究 |
| `CW-0002` | 大象是否确认同伴注意 | SHORTLIST，Owner 点选 | 实际研究是视觉注意、等待回应和继续手势，不能写“读心”“听懂”；原野外视频权利未核 |
| `CW-0003` | 学习网站加载延迟 1–2 秒 | SHORTLIST，Owner 点选 | 纵向准实验，不能写随机 A/B；有作者交互演示但不是论文现场 |
| `CW-0015` | AgentGarten 捉迷藏搬斜坡 | SHORTLIST | 多任务/多轮不能剪成一次连续实录 |
| `CW-0016` | AI 复刻沙水变面团 | SHORTLIST | 不能泛化所有 AI、不混淆各种模拟策略 |
| `CW-0017` | 字母会动（Strike a Chord） | HOLD | 单论文短；A 线可搭配其他独立研究审查 |
| `CW-0018` | EyeRobot 插吸管前看杯子 | REJECTED 当前故事角度 | Owner 听完“就这”，绝不能把原标题吸引力当五分钟能力 |
| `CW-0021` | 主人与狗同睡谁先活动 | SHORTLIST | 关联性、时间先后不等于因果醒来 |
| `CW-0022` | 夜鹰慢速捕虫 vs 迁徙飞行 | SHORTLIST（本批新） | 9/30 原论文，10/9 机构新闻，不能把风洞单项推成所有能耗 |
| `CW-0023` | 城市海岸鱼数量不错却有生理压力 | SHORTLIST（本批新） | 基因表达压力标志≠鱼的主观情绪；论文全文部分受限 |
- 其他全部 26 条仍需按 BOARD/JSON 对应 ID 阅读。**不要覆盖、改号或丢弃淘汰记录**。

## 5. 当前 P0：数据采集器已提交但未在线验收

### 已在 main 的源码/说明
- `research/topic-bank/collector/collect.py`：Python 标准库只读抓取器，按日期请求并输出 `audit.json`、`AUDIT.md`；有 HTTP 请求/页数/日期窗口/解析失败/DOI 类跨源去重。
- `research/topic-bank/collector/test_collect.py`：8 个 mock 离线单测（日期、缺失日期、HF/PLOS 分页、故障、去重、禁止虚假 PASS）。
- `research/topic-bank/collector/README.md`：接口边界、PowerShell 和 GitHub Actions 操作。
- 仓库根 `.github/workflows/cws-source-audit.yml`：**只读工作流**，`contents: read`，`workflow_dispatch` + 工作流文件变更触发 `push`；离线单测→采集→上传 `cws-source-audit-results` artifact，保留 14 天。默认日期 2026-10-07～09；不定时部署、不修改选题库。
- 实施审计：[`2026-10-10_COLLECTOR_IMPLEMENTATION_AUDIT.md`](../research/topic-bank/batches/2026-10-10_COLLECTOR_IMPLEMENTATION_AUDIT.md)。

### 技术和覆盖边界
- HF 采用日榜日期分页；PLOS 采用 Solr `numFound` + 日期/分页；MIT/NASA/Nature 为滚动 RSS 快照，**即使请求成功也不能推断旧日期完整**；JEB 为 Crossref 的 DOI 日期代理，不是 JEB 官方三日全文；OpenAlex/PubMed 当前只是固定 DOI 的接口健康探测，不是全量去重；EurekAlert 暂不自动抓。
- **当前交接状态：还没有可在本对话中验证的 GitHub Actions run ID、job 日志或真实 artifact 内容**。先前容器对外 DNS/HTTP 不通，因此**不可声称采集器已经拿到真实三日数据 / 九源通过 / 自动化稳定运行**。
- 实施报告记载**隔离/fixture 模拟模型中有 8 个同原则离线用例通过**；但正式仓库的测试是否被 GitHub Actions 全部执行并通过，仍需根据 Actions job 日志确认。这两件事不能等同。

### 下一位 Reviewer 的可执行顺序（P0→P3）
**P0｜先读远端仓库、保持现状**。以上路径获取 `main` 当前版本，检查是否另有并行提交，确认工作流与 Python/README/测试一致；不得无视别人后续修改覆盖文件。

**P1｜只读在线验收采集器，先完成尚未完成的任务。**
1. 优先检查 [GitHub Actions 工作流](https://github.com/entropy-student/project/actions/workflows/cws-source-audit.yml) 是否存在最近运行；如果缺少，可由 Owner 在 GitHub 网页手动 `Run workflow`，选 `start_date=2026-10-07`、`end_date=2026-10-09`。**不要谎称你已触发过远端运行**。
2. 必须核 `Offline tests` 步骤通过、`Date-scoped source audit` 状态、`Publish raw counts` artifact；下载并阅读 `audit.json` 和 `AUDIT.md`（不是只看 workflow success）。
3. 逐源检查请求数量、实际条目、准确日期与失败、HF 是否读尽三日分页、PLOS 是否到 `numFound`，RSS 仅限当期实际返回的窗口；如果接口 schema/分页变动，做小幅可回滚修复，补离线测试，再运行一次。
4. **只有观察到真实 API 响应和数量，才在报告里写具体统计**；如果插件不支持动作执行/读 run，清楚交代限制，给 Owner 最小手工操作指引，不宣称 PASS。
5. 输出新带日期的覆盖审计，标注每源 `FETCHED/PARTIAL/BLOCKED` 和严格可证的分母。九源不能全部覆盖时仍 `PARTIAL`；不绕过 403/版权/访问限制。

**P2｜取数验证后再处理研究候选**。读取新 `audit.json`，对真正的新 DOI/arXiv/story angle 去重、回查原研究，才允许编辑 `TOPICS_V1.json` 同步 `BOARD_V1.md`；保留 ID、历史状态、审计日志。不能让自动脚本直接升 `SHORTLIST` 或 `PRODUCTION_READY`。

**P3｜待采集稳定后才做 STORY-FIT**。优先 Owner 选中的果冻、大象、卡顿以及高潜力原生故事（如夜鹰/AgentGarten/沙子）；核四至六分钟必要性、真实过程、平台已有内容、素材使用权；再向 Owner 要求制作确认。不要跨过这一关开视频开发。

### 本地命令（可在联网端或 Actions 中）
```powershell
cd C:\path\to\project\curious-world-studio\research\topic-bank\collector
py -m unittest discover -v -p "test_*.py"
py collect.py --start 2026-10-07 --end 2026-10-09 --output .\outputs
```
输出到 `outputs\audit.json` 与 `outputs\AUDIT.md`。**当前交接文档没有声称以上命令已在用户本机跑成功**。

## 6. 视觉锁定、制作边界

- v1.2 **A→B 两态**：A 是 **Mac OS X Tiger Aqua 桌面**，短暂打开研究文件（约 1.5–3 秒）；B 是 **QuickTime 7 银灰播放器风格**，边到边占满 **1920×1080、16:9、30fps**，视频、论文证据、图表、结尾都在 B 内部；**没有第三种 C 主体模式**。
- 中文字幕**严格单行**，推荐 **56px**（52–58 可微调），白色黑半透明底、与真实配音音频对齐；默认干净硬切，只有必要时 120–200ms 淡入淡出；不得做 PPT/Lottie 式图解、无意义故障闪烁或机械剪辑。
- 真正原创的 Aqua 部分参考 NovusGFX MIT 开源 CSS，在 `vendor/` 保留 LICENSE 与来源。并不是 Apple 官方播放器，也不是拿到了 Apple 资源复用权。
- `preview/index.html` 是**可交互视觉原型**，目前**没有**完整素材下载、商业权利审查、自动音频/字幕同步、成片渲染或发布流水线。旧项目中的 60–90 秒口述原型也不是现阶段要继续扩写的正式片子。

## 7. 研究历史与可靠性文档（不重复开并行协议）

- [HF-FIND 唯一主协议](../research/HF_有趣发现_唯一主协议.md)：HF 默认最近三完整日，高召回、寻原始实验/失败案例、两套榜单、三个媒体状态；旧 v1/v2/v3 为历史参考，不能同时发命令。
- [HF 定向回归试跑](../research/reports/2026-10-10_定向回归试跑.md)：部分历史回归，不是 HF 88 篇全量，揭示错过 AgentGarten/RoboQuest 等具体现场的风险。
- [STORY-FIT 双路线与 5min 结构对照](../research/reports/2026-10-10_STORY_FIT_双路线试验.md)。
- [A/B 两篇短口述实验](../research/story-fit/prototypes/2026-10-10_A_字母_口述原型.md)、[沙子原型](../research/story-fit/prototypes/2026-10-10_B_沙子_口述原型.md)：**仅历史原型，不自动继续剧本**。
- [生活/科技领域并行验证计划](../research/story-fit/2026-10-10_选题领域并行验证计划.md)。
- [跨领域雷达历史回填](../research/reports/2026-10-10_跨领域选题雷达_v1.md)。
- [用户三个题目偏好证据与事实禁区](../research/STORY_FIT_CLICK_CALIBRATION_2026-10-10.md)。
- [首批 21 条回填审计](../research/topic-bank/batches/2026-10-10_SEED_IMPORT_AND_SPOTCHECK.md)；[三日 15 条部分扫描审计](../research/topic-bank/batches/2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md)；[采集器提交审计](../research/topic-bank/batches/2026-10-10_COLLECTOR_IMPLEMENTATION_AUDIT.md)。
- [视觉 Codex 交接](../visual/retro-mac-v1.2/docs/CODEX_HANDOFF.md)，[QA 检查表](../visual/retro-mac-v1.2/docs/QA_CHECKLIST.md)。

## 8. 不能忘记的硬约束 / 未确认项

1. **别把“扫描过日期页”说成“全量论文阅读/自动抓取通过”**；RSS 保存期、被拒访问、API 限流必须写。
2. **别把研究新闻稿说成原论文**，不同研究/日期/人群/动物/实验任务不能混到一条故事里；相关性不等于因果。
3. **别把网页能访问的 GIF/论文图/野外录像直接拿来商用**；分别明确源链接、播放内容、权利证明，不可凭开放论文许可推断录像授权。
4. **别把 Owner 点选转换成 B站观众数据**；对选题真实偏好仍要做上线实验才能验证。
5. **别把只有两分钟内容的发现凑成五分钟**；A 扩展须有另外的真实独立证据，B 优先找原生有过程的研究。
6. **别为了“继续项目”修改 HF 唯一主协议或 Mac v1.2 锁定风格**。重要改变必须经 Owner 确认。
7. **别把选题库 SHORTLIST 解释成 STORYFIT_GO，别把在线脚本提交当作抓取成功**。
8. 频道正式名称、头像、声音与发布方案仍未确定，不自行对外公开内容。

## 9. 给新聊天 Reviewer 的一句话目标

> 当前只做 **P1：验证 GitHub Actions 的真实来源采集与三日覆盖分母**。优先读 `curious-world-studio/docs/PROJECT_HANDOFF_2026-10-10.md` 和 `REVIEWER_HANDOFF.md`，再核 `collector/` 与 Actions；如无真实 run/artifact，保持 **PARTIAL / NOT YET VERIFIED** 并提出最小下一步。**不要开始果冻/大象剧本、不要重做频道定位或视觉、不修改其他项目。**
