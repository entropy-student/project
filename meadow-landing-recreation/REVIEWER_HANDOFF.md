# Meadow — REVIEWER HANDOFF

> Governance: `vps-project-governance` v0.2.7 / `VNEXT.md`; 本次 Reviewer 对归档边界的核验见 [EXECUTION_EVIDENCE](./EXECUTION_EVIDENCE.md)。
> 最后核验日期：2026-10-28（America/Los_Angeles）。

## PROJECT_GOAL / PROJECT_STAGE

按用户录屏还原可运行、可继续编辑的前端页面。当前为交互式视觉复刻与归档阶段；不声明原创站点或生产产品已获授权。

## SYSTEM_MAP

- 静态页面：`dist/index.html` + CSS + JavaScript，场景和品牌字样由 SVG 资产呈现；本地 `npm start` 使用 Node HTTP 服务。
- 数据：无项目数据库、用户上传、后台、队列或定时任务。导航弹窗是演示；没有真实业务页面或后端。
- 托管：此前已发布为所有者私有的 Sites 预览；该预览的账号与部署身份属于受控元数据，不存入本公开项目目录。当前在线服务状态以未来控制台读取为准。
- 素材：用户提交的录屏及其截帧；大字经像素轮廓矢量化；部分视觉动效为前端近似。录屏原站及第三方素材权利、授权范围为 **UNKNOWN**。
- Shared VPS、Docker、账户密钥和其他项目基础设施：本项目未接入；未来使用前需重新核验。

## CURRENT_ACCEPTED_STATE

本地源站代码基线为 `3484ca019095b9fb58a45bff3bd9d41b01c69b7e`；该基线的私有预览发布此前返回成功。2026-10-28 已按用户要求去掉黑色外边框和圆角，在桌面 1922×1080、窄屏 390×844 检查铺满和横向溢出；[桌面截图](./qa/fullbleed-desktop.png)。快速鼠标轨迹、昼夜按钮及弹窗已在浏览器验证。此处不宣称未经核实的原站技术栈或素材授权。

## CURRENT_GATE

`MEADOW_ARCHIVE_20261028`：建立项目独立目录，保存源码、可运行资产、重建参考帧、原录屏分片、证据和完整性清单；更新根导航并做 GitHub 读回。范围仅为项目目录和根 README 导航。归档不授权删除本地或远端资产、不授权修改预览访问、部署、生产路由、VPS 或共享资源。

## CRITICAL_CONSTRAINTS

- 用户希望保持视频效果；未经新请求不要大范围重设计。
- 不提交 Secret、`.openai/hosting.json`、账户凭据或浏览器会话；本公开仓库不保存私有预览身份及链接。
- 原录屏可能包含第三方素材；进一步公开传播或商用前由 Owner 确认使用许可。
- 页面视觉基于二维录屏帧，不是恢复出的原始三维场景；不可将近似动效表述为原始实现。

## DEFAULT_EXECUTION_CHANNEL / CURRENT_ROLLBACK_STATUS

- 代码与归档：本仓库项目目录；托管操作需先确认正确的所有者及权限。
- 回滚：Git 变更按提交恢复或撤回；归档操作前项目库 `main` 的基线为 `9f55632f36d28c139e3e4df67ea0201649748382`。恢复或删除应限定本项目及其导航项，避免回退其他项目；尚未执行远程回滚演练。
- 素材恢复：`python scripts/restore-reference-video.py` 从分片恢复并验证原录屏；`docs/ARCHIVE_MANIFEST.json` 记录归档资产 SHA-256，`python scripts/verify-archive.py` 做完整性检查。

## UNRESOLVED / NEXT_STEP / OWNER_ACTION_REQUIRED

- 原录屏所展示页面和素材的权利、许可及商用边界：**UNKNOWN**。若需要商用或进一步传播，先核实授权。
- 私有预览能否长期访问、后续保留政策和恢复细节：**UNVERIFIED**；继续托管前应查对应 Sites 控制面。
- 下一步：正常维护按本目录源码与交接记录开始；如要改为真实站点、部署到 VPS、清理本地文件或公开新素材，应另行定义范围。
- Owner 现在无需转交凭据；无需执行清理。

## EVIDENCE_POINTERS

[执行证据](./EXECUTION_EVIDENCE.md) · [素材来源](./docs/ASSET_PROVENANCE.md) · [文件完整性清单](./docs/ARCHIVE_MANIFEST.json) · [桌面验证截图](./qa/fullbleed-desktop.png)
