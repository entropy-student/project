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
