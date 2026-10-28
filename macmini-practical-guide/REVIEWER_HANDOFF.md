# Mac mini 实操指南 · REVIEWER HANDOFF
记录日期：2026-10-28
治理基线：`entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 / ACTIVE_PROVISIONAL（本轮读取 blob `3917c88a7f36df7a53758b3879a92703d659ef9d`）

## PROJECT_GOAL
把 Mac mini 新手实操图文教程做成事实准确、自然中文表达、视觉一致、手机可读、离线完整、出版资源可追溯的可复用作品。

## PROJECT_STAGE
`G0_INTAKE_REVIEWED`；G1 源包归档/权限核对待 Executor。当前不是发布、部署或文章改稿轮次。

## SYSTEM_MAP
| 维度 | 已证实状态 |
|---|---|
| 交付形态 | 单页 HTML + 内联 CSS + 两张相对路径 PNG；可离线展示的静态页面 |
| 内容 | 6 节：外设、接线与开机、Windows 迁移、显示/声音、软件快捷键、Time Machine |
| 前/后端 | 纯静态 HTML；后端、数据库、worker、scheduler、Docker 均无证据 |
| 数据/持久化 | 原始内容存在 Owner 上传的 ZIP；GitHub 项目目前是治理文档，非完整素材仓库 |
| 账户/Secret | 上传包未申明运行账户或 Secret；未做全面隐私/安全审计 |
| 网络/外部 | 页面含 Apple 支持与萌娘百科外部出处链接；网页正文不依赖动态接口 |
| 部署/域名 | 无；公开发表未经授权 |
| 共享基础设施 | 不涉及 Shared VPS；禁止跨项目修改 |
| 测试/恢复 | ZIP CRC 与文件哈希已核对；可用上传 ZIP 逐字节还原；浏览器视觉与手机测试未做 |

## CURRENT_ACCEPTED_STATE
- `DIRECT_READBACK`：原始 ZIP 4 项；通过 ZIP 完整性检验；HTML 内有 1 个 img 标签引用 `apple-setup.png`，CSS 引用 `封面.png`，相对路径均对应包内文件。
- `DIRECT_READBACK`：当前封面 1536×1024（3:2），与打磨记录要求的 4:3 不一致；Apple 接线图 1000×770。
- `DIRECT_READBACK`：打磨记录明确要求使用用户的解说男主角色参考图，但该参考图不在本 ZIP 内。
- `SOURCE_RECORD`：上轮记录要求当轮只记录问题、不改成品；本次接管继续保留源码与素材原样。
- `UNVERIFIED`：Apple 图片再发布使用权、文章事实与外链有效性、Human Writing 自动检测、手机与桌面浏览器实测。

## CURRENT_GATE
`G1_SOURCE_IMPORT_AND_RIGHTS_RECONCILIATION_20261028`，见 `docs/G1_SOURCE_IMPORT_GATE.md`。只准做源码导入/来源核对/校验，不准改成品或公开发布；到 `STOP_AT_REVIEWER` 为止。

## CRITICAL_CONSTRAINTS
1. 保持源 HTML/图片/原打磨记录的内容与字节不变；只做独立治理文件与有界导入。
2. 封面未来改为 4:3；须使用 Owner 提供的男主参考图，维持角色识别特征；尚未授权生图。
3. 中文文风参考 Human Writing Skill 与具体语境的幽默表达，不能声称未运行的检查已通过。
4. Apple 图片权利范围未知，不得把「公开可看」视为允许公开再发布。
5. 不触碰网站部署、VPS、支付、个人账户、其他项目或生产环境。

## DEFAULT_EXECUTION_CHANNEL
项目原包由 Owner 通过聊天附件交付；下一轮 Codex 在它实际可访问的本地工作区执行；GitHub 使用项目目录隔离、分支/PR；具体本地路径未验证，为 `UNKNOWN`。

## CURRENT_ROLLBACK_STATUS
原上传 ZIP 是只读源包与校验锚点；本轮 GitHub 文档操作可通过对应分支/PR 撤回。不存在已验证的异机发布回滚点。

## UNRESOLVED
- HTML、PNG 原件尚未进入 GitHub；本仓库当前并非可直接运行的完整站点。
- 男主形象参考图缺失；当前封面为 3:2，和目标 4:3 不一致。
- Apple 图片的许可/再发布权限未核实。
- 事实核对、内容风格与自动检查、移动端渲染、外链有效性均未验收。
- 用户尚未确认最终发布渠道与发布日期，默认不发布。

## NEXT_STEP
Executor 执行 `docs/G1_SOURCE_IMPORT_GATE.md`，交付导入文件校验、权利分类和有限 Evidence；Reviewer fresh read-back 后决定 PASS/RETURN。G1 结束前不进入正文改写或封面再设计。

## OWNER_ACTION_REQUIRED
只有在启动本地 Codex G1 时，将本次 `Macmini实操指南.zip` 放到 Codex 可读位置；后续封面 Gate 再交付男主参考图。当前不需要进行线上授权或支付。

## EVIDENCE_POINTERS
- `docs/SOURCE_MANIFEST.md`：源包清单、SHA256、图像尺寸、遗留问题。
- `EXECUTION_EVIDENCE.md`：G0 只读核验结果。
- `docs/G0_INTAKE_GATE.md`、`docs/G1_SOURCE_IMPORT_GATE.md`：Gate 记录。
- `DECISION_LOG.md`：不修改原成品、项目边界和分阶段推进。
