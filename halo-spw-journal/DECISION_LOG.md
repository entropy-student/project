# SPW Journal · 决策记录

这里记录原因与范围，不替代当前 REVIEWER_HANDOFF 或 GitHub Governance。

## D-001 · 公开静态前台，本地保留编辑源

日期：2026-10-26。来源：Owner 明确确认，上一轮已实施并验收。

目标是电脑和 Docker 关闭后仍能访问网站。采用本地 Halo/PostgreSQL + Cloudflare Pages，用户在 Halo 发布后手动运行一键导出部署。暂不迁移 VPS；后台写入与实时服务端能力不冒充静态功能。

## D-002 · 文档规范接管，不退役项目

日期：2026-10-26。来源：本轮 Owner 请求 + Reviewer reconciliation。

使用 GitHub 当前 vps-project-governance 作为规范入口。只更新项目子目录的持久记录，保持 Governance 仓库和项目库根地图不动。发现本地容器已停止，作为现场状态记录并保留，不自动重启。

## D-003 · 精确清理旧设计文本

日期：2026-10-26。来源：Reviewer 已逐份核对的 GitHub 历史材料。

清理 6 份已停止作为设计规范使用的说明/提示词，约 24 KB；GitHub 固定版本保留并逐字节重建。保留当前 DESIGN、组件 README、spike-reference 来源记录、LICENSE/OFL、图片、源码、文章和所有恢复/Secret 数据。未知用途的 .hallmark 快照不作为无效文件删除。记录见 docs/ARCHIVE.md。

## D-004 · 明示恢复能力边界

日期：2026-10-26。来源：现存目录、包和脚本的直接读取。

本轮可证明文档恢复；本机 .8 主题包存在；旧 Rollback-Transparent 指向 .5，不能当作当前 .8 的完整恢复。数据库、附件、keys 与凭据仍需独立保护；缺少本轮异机恢复证明，状态为 PARTIAL/UNKNOWN，而不是把文档归档宣称为全站备份。
