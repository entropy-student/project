# EXECUTION EVIDENCE（append-only）

## G0 · 2026-10-28 · Reviewer source discovery
- AUTHORIZED_GATE：`G0_READONLY_SOURCE_INTAKE_20261028`
- PREFLIGHT_FACTS：读取当前 GitHub Governance v0.2.7；读取项目库 README；未找到既有“Macmini 实操指南”独立目录；源包为 Owner 本轮上传。
- ACTUAL_CHANGES：没有改动原 HTML、图片、Markdown 或本地运行系统；在隔离 GitHub 分支创建治理文档和根目录导航条目（以最终 PR diff 为准）。
- OBJECTIVE_READBACK：Python `zipfile.testzip()` 无损坏；4 个成员大小/哈希见 `docs/SOURCE_MANIFEST.md`；Pillow 尺寸检查：封面 1536×1024、Apple 图 1000×770；BeautifulSoup 检查 6 个 H2 章节、1 个 image 标签、6 个外部参考链接。
- VALIDATION：HTML 的相对封面/配图文件名均存在于 ZIP；**未运行**浏览器、手机、外网事实核验、ImageGen、Human Writing 自动检查；项目 GitHub 文档是否持久化及 fresh read-back 以 PR 审核结果为准。
- ANOMALIES：当前封面 3:2 ≠ 目标 4:3；人物参考图和风格参考图不在 ZIP；Apple 图片的公开再发布权利未知。
- EVIDENCE_ARTIFACTS_AND_PURPOSE：`docs/SOURCE_MANIFEST.md`（字节级定位）；`docs/G0_INTAKE_GATE.md`（边界）；源 ZIP 由 Owner 保存，未导入此仓库。
- ROLLBACK_EFFECT：源包零改动；拟议 GitHub 记录均在独立分支，PR 可关闭。
- RESOURCE_OR_BUSINESS_DELTA：无服务器资源、费用、支付或对外发布行为。
- EXECUTOR_RESULT：`NOT_APPLICABLE`（本轮为 Reviewer 只读接管）。
- REVIEWER_DECISION：`G0 PASS` 仅限“已发现/记录当前证据”；非文章、版权、视觉或发布验收。

> 后续 Executor 请只追加本轮事实，不改写 G0 已读证据。

## 2026-10-28 · Reviewer 目标漂移调和与研究（no Executor execution）
- AUTHORIZED_BOUNDARY: Owner 明确要求先修正目标、由 Reviewer 调研并规划，然后再交 Codex 制作一版视频脚本。
- ACCEPTED_CHANGE: 项目由「Mac mini 静态图文/HTML 打磨」纠偏为「实操视频叙事+画面规划试验」；原 G0 的 ZIP 读回证据仍然有效，旧项目目标和旧 G1 已被 supersede。
- DIRECT_READBACK: 原 HTML 分 6 章、18 段 p、2 个 figure；原 ZIP 为用户的历史内容基础，不是口播/分镜验收产物。
- RESEARCH_EVIDENCE: YouTube 官方留存指标、B 站官方课程索引、密歇根/马萨诸塞/哥伦比亚大学叙事建议、Mayer 多媒体学习综述与 Vanderbilt 分镜流程；出处和适用限制写入 `docs/RESEARCH_SCRIPT_FORMAT.md`。
- ACTUAL_CHANGES: 更新 `REVIEWER_HANDOFF.md`、`README.md`、`DECISION_LOG.md`、项目库导航；新增 `docs/RESEARCH_SCRIPT_FORMAT.md` 与 `docs/G1_SCRIPT_PILOT_GATE.md`，旧 Source Import Gate 标明 `SUPERSEDED`。
- UNVERIFIED: 尚无 Codex 首轮文案、HTML、配图方案、实际 Human Writing/语料效果与视频观众数据。没有执行原文、图像、部署、公开发布或自媒体视频制作。
- NEXT_STOP: GitHub 本轮文档 read-back 后，向 Owner 提供新 G1 Codex relay，等待其真实执行；下一步只有一个 Gate。

## 2026-10-28 · Reviewer 规划轮｜三类文案 v0.1
- AUTHORIZED_GATE：Owner 要求根据先前调研开始制定写作规范与统一提示词，并新增唯一文案类型范围「实操、测评、观点」。
- PREFLIGHT：核对 GitHub Governance v0.2.7 当前 VNEXT、现有 Handoff、旧 G1 与项目 README；本轮不触发 Shared VPS、SSH、Deployment、Automation/Payment、Closeout 或 Image Generation 专项。
- SOURCE_RESEARCH：直接核查公开 SKILL.md，Human Writing (KKKKhazix)、educational-content-and-how-to、evidence-based-reviews、contrarian-and-opinion、content-research-and-sourcing、Humanizer-zh；对营销化强制 Hook/CTA、硬性句式禁令和无核验传播统计做排除说明。
- ACTUAL_CHANGES：新增规范/提示词/Skill 选型 3 文档，更新当前 Handoff、项目 README、根 README 导航，追加 Decision Log；废止原 G1 视频 + 配图试稿执行入口。
- OBJECTIVE_READBACK：GitHub 文件与 Draft PR 的最新可读状态以本轮随后的回读校验为准。
- VALIDATION：本轮仅方法设计；**未执行 Codex、未生成文案、未生成 HTML、未测试三类作品、未安装 Skill、未修改源 ZIP 或发布内容**。
- ROLLBACK_EFFECT：Draft PR 文档可回退；无生产系统影响。
- REVIEWER_RESULT：`WRITING_STANDARD_V0.1_CANDIDATE`，在 Owner 评审前不定义为正式通过。

## 2026-10-28 · G2 Mac mini 完整视频稿首轮试验（本会话执行）
- AUTHORIZED_GATE：Owner 「暂时我没有问题，开始吧」承接上一轮已确认的 Codex 首稿阶段；由于本轮会话**没有 Codex 执行工具**，直接生成稿件并在记录中明确执行渠道差异。
- PREFLIGHT：读取 Owner 2026-10-28 原 ZIP 中 HTML 与历史反馈；读取 v0.1 项目规范/统一提示词与 GitHub human-writing 的 SKILL.md/reality/formats/forum-prose/revision；从 Apple 官方页面独立核对 2024 M4/M4 Pro 接口、首次设置、迁移、快捷键、声音与时间机器；未假冒自有实机经历。
- ACTUAL_CHANGES：新增独立 HTML 审稿文件 `Macmini_实操文案_首轮审稿.html` 于本轮会话工作区，**没有**修改 ZIP 原件、没有把草稿公开推送到 GitHub、没有网站/移动端/视频/配图工作。
- OBJECTIVE_READBACK：首稿标题「Mac mini 到手第一天，先别急着买扩展坞」；17 段、正文 2145 个字符；HTML 9142 字节；SHA256 `7dcdd02c7d44d15fd765daa08158cf653ae2051e72ed2318e4e4a7769a397210`；7 条 Apple 官方链接；无 JavaScript、图片或远程运行依赖；BeautifulSoup 结构/引用检查通过。
- FACT_SOURCE_POINTERS：
  1. https://support.apple.com/zh-cn/121555 （2024 款前后端口、雷雳 M4/M4 Pro）
  2. https://support.apple.com/zh-cn/109523 （连接显示器使用后方接口）
  3. https://support.apple.com/zh-cn/guide/mac-mini/apd5bdcf1655/mac （初次连线、设置）
  4. https://support.apple.com/zh-cn/102565 （Windows 迁移助理）
  5. https://support.apple.com/zh-cn/102650 （键盘快捷键）
  6. https://support.apple.com/zh-cn/guide/mac-help/mchlp2256/27/mac/27 （输出设备）
  7. https://support.apple.com/zh-cn/104984 （Time Machine）。
- REVIEWER_FIRST_READ：围绕减少第一次开机时的无效配件购买，从正面 USB-C 与背面显示输出的区别引到亮屏排错，再进入 Windows 迁移、常用设置和备份，逻辑比原六章罗列集中；稿件有可朗读正文、具体结论与适用机型范围。
- REVIEWER_UNRESOLVED：尚无实体设备端到端验证；浏览器实际视觉截图因 headless Chromium 进程超时未取得（HTML 静态核验已通过）；风格是否像 Owner 的个人声音、是否符合「好的自媒体文案」仍必须由 Owner 阅读反馈；单篇实操试稿不能证明测评/观点型通用效果。
- ROLLBACK_EFFECT：仅新增独立文件和 GitHub 项目内治理文档，无在线系统影响。
- RESULT：`ARTIFACT_READY / OWNER_REVIEW_PENDING`；文案质量 `UNVERIFIED_BY_OWNER`，不称 `PASS`。
