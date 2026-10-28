# G1 — 原始项目导入、可恢复性与素材权利核对

## Gate contract
- GATE_ID：`G1_SOURCE_IMPORT_AND_RIGHTS_RECONCILIATION_20261028`
- OBJECTIVE：把用户提供的可用源包无损放进隔离本地项目目录，确保离线页面及图片可逐字节恢复，并归类公开发表权利风险。
- MAX_ENDPOINT_THIS_ROUND：**本地工作区导入 + 文件校验 + 静态本地预览 + 有界权利分类 + 脱敏 Evidence**；GitHub 可提交文本/自有且已确认权利素材，不上传权利未知的 Apple 图。不得推进到修改文章/封面或公开发布。
- MANDATORY_REVIEW_STOP：交付文件清单、差异/预览核验和 Evidence 后 `STOP_AT_REVIEWER`。
- TARGET_AND_SCOPE：`macmini-practical-guide/` 专属隔离工作区；原文件按 `site/Macmini实操指南.html`、`site/封面.png`、`site/apple-setup.png` 原样同目录保存；历史打磨记录置于 `docs/source/文案与封面打磨记录.md`（原文保留）。
- APPLICABLE_CRITICAL_CONSTRAINTS：完全不修改源文件字节；不从仓库 root/其它项目读取私人文件；不动 VPS、生产站、域名、支付或运行凭据；第三方图片版权未确认时保持本地，不在公开仓库/网站复制发布。
- PREFLIGHT：确认当前项目目录、分支、Git 状态和隔离；读取 `REVIEWER_HANDOFF.md`、本 Gate、`SOURCE_MANIFEST.md`；确认 **Codex 真实可读**的原 ZIP 路径；校验 SHA256；不匹配直接 RETURN，禁止自行找“相似文件”替代。
- REQUIRED_EVIDENCE：4 项的实得 byte/哈希对照；HTML 相对资源与页面加载检查；图片尺寸；离线本地预览截图及手机视口截图（若无法提供，明确 UNVERIFIED）；版权来源/许可核对结果；Git 状态与变更路径清单；是否只对允许文件提交；回退至原 ZIP 的恢复说明。
- ACCEPTANCE_CRITERIA：源包 byte-for-byte 保真；本地 HTML + 两图加载可用或准确解释未验证原因；未侵入其他项目；所有权利未知被显式隔离；完整证据持久化；由 Reviewer 决定 PASS。
- ROLLBACK_STATUS_OR_PLAN：保留不可变原 ZIP；删除/恢复仅针对新建的项目本地拷贝，禁止广泛清理或覆盖 Owner 原件；Git 分支可丢弃。
- OWNER_ONLY_ACTIONS：确认图片出版许可/取得授权、公开发布、购买付费服务、改动 Governance、不可逆删除、进入下一 Gate。

## REVIEWER_TO_EXECUTOR_RELAY（直接复制给 Codex）
```text
你是 Executor（Codex），当前只执行 G1_SOURCE_IMPORT_AND_RIGHTS_RECONCILIATION_20261028。
GitHub 仓库 entropy-student/project，项目目录 macmini-practical-guide，当前方案分支 intake/macmini-practical-guide-20261028。
只读启动材料：
- macmini-practical-guide/REVIEWER_HANDOFF.md 的 CURRENT_ACCEPTED_STATE / CRITICAL_CONSTRAINTS
- macmini-practical-guide/docs/G1_SOURCE_IMPORT_GATE.md（本 Gate）
- macmini-practical-guide/docs/SOURCE_MANIFEST.md（4 个 SHA256）
不重读历史 Governance、不扫描其他项目、不重放任何历史 Gate。
先要求并验证用户提供 ZIP 在当前 Codex 工作区的真实路径；不要推断聊天附件自动出现在你的文件系统。
本轮只准：在项目专属本地工作区解出 4 个原文件，校验 SHA256、HTML 相对资源、本地桌面/手机视口预览，标注素材权限已知/未知，补充 EXECUTION_EVIDENCE；可提交权利确认的文本源，但不得公开提交 Apple 图片或任何权属不明素材。
不准：修改 HTML/文案/图片内容、生图、网站部署、VPS/Docker/支付改动、公开发布、合并 PR、向下一 Gate 前进、广泛清理。
若 SHA 不符、ZIP 缺失、许可证不明影响推进、基线漂移或无法证明源文件所有权，明确 RETURN_*，不得盲试或自行替代。
完成后返回：结果/改动/验证/问题/回滚/请 Reviewer 检查/Owner 转交。Executor 只能声明 PASS_CANDIDATE；STOP_AT_REVIEWER。
```

## EXECUTOR_TO_REVIEWER_RELAY
```text
结果：PASS_CANDIDATE / RETURN_*
改动：本轮有界导入/记录内容一句话。
验证：文件哈希/预览/边界核验一句话，细节见 EXECUTION_EVIDENCE。
问题：NONE 或明确阻塞点。
回滚：原 ZIP 保留及项目隔离恢复路径。
请 Reviewer 检查：具体证据文件与未完成项。
Owner 转交：NONE 或最小必要动作（如把 ZIP 放到 Codex 可读路径）。
```

## 后续非授权路线
- G2：Apple 资料版本与链接、事实和许可核对。
- G3：文案表达与 Human Writing 实际检查。
- G4：封面 4:3 人物一致性，所需参考图和构图明确后再授权生图。
- G5：多视口排版、图文可用性与离线包回归。
- G6：出版/发布（Owner 单独授权后）。
