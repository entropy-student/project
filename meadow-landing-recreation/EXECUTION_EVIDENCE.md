# Meadow — EXECUTION EVIDENCE

## 2026-10-28：归档基线

- **AUTHORIZED_GATE**：Owner 要求按 VPS 项目管理规范将本项目相关内容归档到 GitHub `entropy-student/project`。
- **PREFLIGHT_FACTS**：GitHub 项目库为公开仓库，默认分支 `main`；归档前 `main` 为 `9f55632f36d28c139e3e4df67ea0201649748382`。目标新目录 `meadow-landing-recreation/`，原目录列表无同名项目。项目独立本地基线 `3484ca019095b9fb58a45bff3bd9d41b01c69b7e`，工作区当时无已跟踪修改。
- **ACTUAL_CHANGES**：准备项目目录、根导航项、运行代码、场景/字样资产、五张构建参考帧、原视频分片、素材来源说明、交接、校验清单与验证截图。排除 Sites 绑定身份、凭据、Git 元数据及临时产物。
- **OBJECTIVE_READBACK**：此前 Sites 部署返回 `succeeded`，浏览器可读到项目页面；桌面 1922×1080 与手机 390×844 的元素边界分别为全视口、边距 0、圆角 0，手机无横向溢出。桌面图像见 [qa/fullbleed-desktop.png](./qa/fullbleed-desktop.png)。
- **VALIDATION**：`node --check dist/app.js` 通过；此前浏览器测试覆盖日夜切换、导航弹窗和鼠标轨迹。检测到快速鼠标移动时的负时间差异常后已修复；修复后的交互未产生新的浏览器错误。录屏为 16.566 秒 H.264 视频及 AAC 音轨，检测均值和峰值均为 -91 dB，未发现可听声音。归档内容完整性以 [docs/ARCHIVE_MANIFEST.json](./docs/ARCHIVE_MANIFEST.json) 和验证脚本为准。
- **ANOMALIES / LIMITATIONS**：授权和原站技术栈未知；实际三维草地与物体动画未恢复。视频分片仅用于仓库存储，恢复后须验证完整哈希。
- **ROLLBACK_EFFECT**：无删除、无 VPS/共享基础设施变更。项目库归档提交可通过限定范围的后续 Git 变更撤回；未进行回滚演练。
- **EXECUTOR_RESULT**：归档内容已准备；远程持久化和读回的结果以本文件后续追加记录为准。

## 2026-10-28：GitHub 归档读回与 Reviewer 核验

- **DIRECT_READBACK**：项目库 `main` 更新至首个归档提交 `ca898fe53b7fae25416752049da6b7b0629533f7`；项目子树 `fbf770e4b32d90743f0802096c625faf5e952b99` 的递归读取未截断，共 33 个文件。
- **INTEGRITY**：33 个项目文件的远端 Git blob SHA 均与上传前本地计算一致，无缺失或额外文件；两份根目录导航的 blob SHA 与拟定内容一致。远端完整性清单内容与本地核验清单一致。
- **RECONSTRUCTION**：本地恢复八个原视频分片，所得文件长度为 36,782,130 bytes，SHA-256 为 `959073ef90a2b6fe425cfa60aa3d0c8b57c8658aaf7a1b66e0590a6a964cff35`，与原录屏一致；远端通过 Git 对象内容寻址与对应本地文件逐项关联，本轮未在另一台机器上重新下载和重组视频。
- **REVIEWER_DECISION**：`MEADOW_ARCHIVE_20261028 = PASS`，限于已核验的项目归档、导航及内容完整性；素材权利和未来私有预览可用性仍分别为 `UNKNOWN` / `UNVERIFIED`。
- **SCOPE / RECOVERY**：未删除原视频、本地项目、Sites 预览或共享资源；回滚为针对归档目录和导航项的有界 Git 变更，未演练。
