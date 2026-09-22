# Mini Craft Night Kit — GitHub Reviewer / Executor Handoff Protocol

Last reviewed: 2026-09-22  
Status: **TRIAL APPROVED**

## 1. Goal

减少 Owner 在聊天中复制粘贴长日志与文档。

GitHub `entropy-student/project/mini-craft-night-kit/` 作为 Mini Craft 项目的长期可查阅记录面。

## 2. Reviewer-owned documents

Reviewer 维护：

- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
- `docs/*DECISION*.md`
- Gate / architecture / acceptance truth

Reviewer 聊天回复默认简化为：

> Reviewer 已完成，可查阅 `mini-craft-night-kit/REVIEWER_HANDOFF.md`。

如果有专项 Decision，则附对应文档名。

## 3. Executor-owned documents

Executor / Codex 维护：

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- 必要的 manifest / evidence index
- 当前 Gate 的实现代码与可安全提交的测试证据

Executor 聊天回复默认：

> 执行完成，可查阅 `mini-craft-night-kit/EXECUTION_EVIDENCE.md` 与 `EXECUTOR_HANDOFF.md`。

## 4. Secret Boundary

GitHub 永远不得写入：

- .env；
- password；
- token；
- private key；
- Provider Secret；
- cookies；
- credential dump；
- production customer sensitive data。

Evidence 只记录：
- Secret 是否存在；
- Secret 配置位置类别；
- read-back 成功/失败；
- 必要的非敏感标识。

## 5. PASS Boundary

Executor 只能写：

`PASS_CANDIDATE`

只有 Reviewer 能写正式：

`PASS`

## 6. Visual Evidence Boundary

凡涉及 UI / 页面 / 视觉验收的 Gate：

- Executor 必须把最终截图提交到 GitHub，作为长期 Evidence；
- 仅有 GitHub 路径、commit、hash 或“截图已归档”不等于 Reviewer 已完成视觉验收；
- Reviewer 必须实际看到截图像素后，才能给 `Visual PASS`；
- 所有需要 Reviewer 视觉确认的截图证据，Executor 除了提交 GitHub 归档外，还必须额外打包成一个 Owner 可直接转交的 ZIP；
- ZIP 只包含本次 Gate 的视觉证据与一个简短 manifest，不得混入日志、Secrets、cookies、credentials、数据库导出、无关截图或其它项目文件；
- ZIP 默认命名：`<gate>-visual-review.zip`；
- ZIP 内建议结构：
  - `desktop/`
  - `mobile/`
  - `manifest.txt`
- `manifest.txt` 至少记录：Gate、截图文件名、视口尺寸、页面、commit SHA；不得记录 Secret；
- Executor 返回时必须明确：
  - `VISUAL_REVIEW_PACKAGE=<absolute local zip path>`
  - `VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED`
- Owner 将该 ZIP 直接上传到当前对话，Reviewer 解包并实际查看截图像素后再做视觉判断；
- 在 Reviewer 未实际看到 ZIP 中的截图像素前，只能给 `Technical PASS`，不能给最终 `Visual PASS`；
- UI Gate 的标准视觉证据交付默认包含：
  1. GitHub 中的长期截图归档；
  2. 本次视觉证据 ZIP；
  3. Owner 将 ZIP 上传到当前对话后的 Reviewer 视觉审查。

除非 Reviewer 明确要求，不再让 Owner 逐张下载/上传截图。
禁止用 Base64 长文本替代正常截图交付。

## 7. Promotion to Global Governance

当前先在 Mini Craft 项目试运行。

满足以下条件后再写入全局 Governance：

- 至少连续 3 个 Gate 顺利；
- Reviewer 能直接从 GitHub 接管；
- Executor 不覆盖 Reviewer Truth；
- Owner 不需要搬运长日志；
- Secret / evidence boundary 无事故；
- 历史记录可追踪。

成功后建立 Governance Change Gate，将其推广到其他项目。
