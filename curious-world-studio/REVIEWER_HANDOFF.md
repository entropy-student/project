# Curious World Studio — Reviewer Handoff

**状态**：研究协议与视觉基线已确定；项目处于规范/原型阶段，尚无自动成片系统。

## 唯一权威入口
- 项目概览：`README.md`
- 频道承诺与命名状态：`docs/CHANNEL.md`
- 选题：`research/HF_有趣发现_唯一主协议.md`（HF-FIND）
- 视觉：`visual/retro-mac-v1.2/docs/STYLE_LOCK.md` + `config/design-tokens.json`
- 原型：`visual/retro-mac-v1.2/preview/index.html`
- 决策：`docs/STATUS_AND_DECISIONS.md`

## 已实施
项目归档于 `entropy-student/project/curious-world-studio/`。读取与维护时必须限制在本项目路径；根 README 只做导航。

## 尚待确认
频道正式名称和 Logo；视觉细节的尾部修正；素材许可；文案→素材时间轴→音频/SRT→成片的生产和 QA 链路。

## 防止误报
不把“论文页面链接存在”当作“视频核实、商业使用许可已经证实”；不把可交互 HTML 原型当作成片工具；不重新引入多份竞争的 HF 提示词；不自行启动新视频项目或修改其他一级项目。


## 2026-10-10 STORY-FIT 双路线初试
- 研究报告：[`research/reports/2026-10-10_STORY_FIT_双路线试验.md`](research/reports/2026-10-10_STORY_FIT_双路线试验.md)
- **路线 A**：Strike a Chord 字母运动 + Heider/Simmel 抽象运动知觉相关研究；节目承载力 CONDITIONAL GO，需对跨研究关联与“无字词提示”互动谨慎求证。
- **路线 B**：4DCodeBench、AgentGarten 原研究具备连续案例；可进入 4–6 分钟内容原型，但原素材逐片 QA 和商业授权尚未完成。
- **决策**：暂优先 B，保留 A；不修改 HF-FIND 唯一主协议；未开展完整视频制作。


## 2026-10-10 跨领域选题雷达 v1
- Owner 决策：**扩大选题范围**；生活/衣食住行/身体与感知的原始研究，与 Hugging Face 科技研究并行，不要求内容一定提 AI。
- 初选结果：[跨领域选题雷达 v1](research/reports/2026-10-10_跨领域选题雷达_v1.md)：10 个候选（9 个有实证线索、1 个 HOLD），优先五分钟预审意大利面、蚊子偏好、爆米花。注意尚未做系统 B站竞品查重或媒体商用授权确认。
- 保留 `research/HF_有趣发现_唯一主协议.md` 未变；下一步按同一 STORY-FIT 判据对生活题与科技题公平比较，不宣称原创赛道/供给空白。


## 2026-10-10 跨领域信源分层体系（严格筛选版）
- 最终框架：[`research/SOURCE_SYSTEM_FINAL_V1.md`](research/SOURCE_SYSTEM_FINAL_V1.md)。层次：每日 HF / MIT Research RSS / EurekAlert 浏览；每周 JEB / NASA EO / PLOS 定制 RSS / Nature 专题；原文核实 OpenAlex / PubMed / DOI / 作者原论文。
- EurekAlert 尚未确证公共 RSS/API，不作为已部署自动采集接口；OpenAlex / PubMed 是检索与核实底座，不应每日扫全量。
- USDA ARS 降级低频（2026 新闻档案稀疏），arXiv RSS 与 HF 内容重叠，独立 Nature Food 全刊不每日扫。
- **只完成网站、官方文档和部分 2026-10-07 至 09 样本抽查；没有真实运行三日 API/RSS 批量抓取**。不宣称每日候选数量/通过率/授权已验证。旧 `SOURCE_REGISTRY_V1.md` 为历史候选版，不是最终执行版。
- Owner 本轮要求只展示信息源体系框架，不启动新扫描或渲染。


## 2026-10-10 OWNER 三题点击校准
- Owner 主动选中：野生大象是否确认对方注意、会说话的食用果冻、1–2 秒页面卡顿如何影响学习。**没给三题内部排名；不要推断为正式平台市场偏好。**
- 校准报告：[STORY_FIT_CLICK_CALIBRATION_2026-10-10.md](research/STORY_FIT_CLICK_CALIBRATION_2026-10-10.md)。主结论：生活中可代入的主体/处境 + 直觉预测 → 实证反差/后续动作，比学科标签更能解释这次选题兴趣。
- 编辑优先：果冻（2024 真吃与 2026 只看视频评价，且内疚感无显著差异）→ 大象（有明确多步行为与等待，但作者野外实验视频商用权未确认）→ 页面延迟（准实验数据扎实、作者有自助 2 秒交互体验，但视频故事画面少）。前两题进入下一轮 STORY-FIT 深审，第三题留作互动型备选。
- **未修改** HF-FIND 主协议；不要把动物心智推断、2026 果冻真的被试吃、微延迟研究是随机对照试验这类错误带入剧本。未完成原创录像商业授权或中文平台竞品查重。


## 2026-10-10 Owner 确认的正式选题库顺序（已执行第一批）

**九大信息源 → 批量发现 → 统一筛选与评分 → 正式选题库 → STORY-FIT 深审 → 剧本/素材核验 → 视频制作/QA/发布。**

- 工作流唯一入口：[`research/topic-bank/WORKFLOW_V1.md`](research/topic-bank/WORKFLOW_V1.md)
- 选题库展示：[`research/topic-bank/BOARD_V1.md`](research/topic-bank/BOARD_V1.md)；机读母表：[`research/topic-bank/TOPICS_V1.json`](research/topic-bank/TOPICS_V1.json)
- 第一批审计：[`research/topic-bank/batches/2026-10-10_SEED_IMPORT_AND_SPOTCHECK.md`](research/topic-bank/batches/2026-10-10_SEED_IMPORT_AND_SPOTCHECK.md)
- 21 条（SHORTLIST 9 / VERIFY 7 / HOLD 4 / REJECTED 1）。来自历史研究回填 + 少量定向抽查，**并非九源三日完整扫描或自动化生产系统**；尚无 STORY-FIT 正式通关、竞争分析或素材复用许可。
- HF-FIND 唯一主协议及 QuickTime v1.2 视觉规范保持不变；本选题库框架在跨领域层面调度，不是第二份 HF-FIND 主协议。


## 2026-10-10 首轮跨领域三日来源扫描（重要：部分覆盖）
- 已执行 2026-10-07 至 09（各源发表日期）定向扫描与论文核查，**不是全量九源爬取，也不是三日稳定自动化测试**。
- 批次审计：[research/topic-bank/batches/2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md](research/topic-bank/batches/2026-10-07_to_09_PARTIAL_9_SOURCE_SCAN.md)。新加 CW-0022～0036 共 **15** 角度：SHORTLIST **2** / VERIFY **8** / HOLD **5**。与历史 21 条合并，总 **36**：SHORTLIST **11** / VERIFY **15** / HOLD **9** / REJECTED **1**。
- 新增 SHORTLIST：**夜鹰在慢速捕虫与长途迁徙中的飞行权衡**（Lund 10/9 研究新闻、论文 9/30）和**冲绳城市海岸蓝魔雀鲷的基因表达压力与外表丰度反差**（OIST 10/9、Nature Communications DOI）。均未过 STORY-FIT/视频素材审核。
- 源覆盖：HF 三个日榜打开，但未逐一深读全部摘要；MIT 研究页仅首屏列表；JEB Accepted Manuscripts 日间列表 7 条可见稿、2 篇摘要；NASA 3 个对应 Image of Day 原文；PLOS/Nature/EurekAlert 通过定向搜索而非完整抓取。EurekAlert 本站直达 403，OpenAlex API 未跑；PubMed 部分核原论文学术信息。**不允许计算统一来源入选率或声称九大来源自动化已部署**。
- 更新母表 `research/topic-bank/TOPICS_V1.json` 与看板 `research/topic-bank/BOARD_V1.md`，本批无任何素材商用许可确认、无中文平台竞品系统检查，不进入剧本。
