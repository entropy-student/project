# SPW Journal · Halo

这是 Halo 个人博客与 SPW 放映室主题的文档归档，状态记录日期为 2026-10-26。归档遵循 Project Library 的单项目目录约定。

本目录只收录清理后的项目说明、当前设计规范、操作与开发指南、组件说明、设计过程文本、交接记录和脱敏验收结果，以及本次静态导出与部署的辅助脚本。Halo 源码、文章数据库、附件、账号凭据、环境文件、主题 ZIP、备份与浏览器截图均未上传。

## 文档导航

- [当前交接记录](./REVIEWER_HANDOFF.md)
- [执行证据](./EXECUTION_EVIDENCE.md)
- [现行设计规范](./DESIGN.md)
- [日常操作与部署](./docs/OPERATIONS.md)
- [静态网站架构与一键更新](./docs/STATIC-SITE.md)
- [开发、验证与回滚](./docs/DEVELOPMENT.md)
- [设计迭代归档](./docs/ARCHIVE.md)
- [组件接入说明](./docs/components/)
- [设计参考与图像提示词](./docs/archive/design/)

## 当前公开网站与更新流程

公开前台 [spikersun.com](https://spikersun.com/) 由 Cloudflare Pages 项目 `spw-journal-static`（生产分支 `main`）托管；Halo 与 PostgreSQL 继续保留在 Windows 本机 Docker 中，暂不迁移 VPS。已停止本地 Halo/数据库并验证公网静态文件、文章图片、搜索和 Starflow 可用。

日常更新：打开 Docker Desktop → 在本地 Halo 发布文章或页面 → 双击本地项目根目录 `Publish-Website.cmd` → 等待“更新成功” → 检查网站，然后即可关闭电脑。静态站不提供 Halo 后台、评论提交或实时统计服务。完整验收、缓存策略、认证与故障排查见 [STATIC-SITE.md](./docs/STATIC-SITE.md)。

此归档增加了 `scripts/Export-StaticSite.mjs`、`scripts/Publish-StaticSite.ps1` 和双击入口供恢复工作流。它们不含账号令牌；完整本地 Halo 实例及内容仍需独立备份，文档库不代替数据库与附件备份。其他项目和商城未部署到此域名。
