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
