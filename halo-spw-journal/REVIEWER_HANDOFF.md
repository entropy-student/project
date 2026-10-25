# SPW Journal · 当前交接记录

状态日期：2026-10-25

## 当前状态

- 本机 Halo 2.27.1 与 PostgreSQL 16 通过 Docker Compose 运行，网页入口为 http://localhost:8090/。
- 当前启用 SPW 放映室主题 2.2.0-spw.6。原版 Halo Fuwari 主题仍留在实例中供回退使用。
- 首页包含 Hello、五词/SPIKE 字符场、上海/深圳地球和博客内容；Starflow 延续到公开子页面。
- Halo 官方 CLI 已安装并配置本地 profile。个人访问令牌保存在操作系统凭据存储，不在项目文档或脚本中。
- CLI 图文草稿上传流程已端到端验证，文章保持草稿且图片可访问。

## 下一步

用户可开始在 Halo 后台编写文章和页面。日常操作见 docs/OPERATIONS.md；需要修改主题时从根目录 DESIGN.md 与 docs/DEVELOPMENT.md 开始。

发布文章前需有明确的发布指示；项目里的 Markdown 上传脚本仅创建或更新草稿。

## 范围与边界

本文档归档的是 Halo/SPW 项目说明，不包含运行数据。数据库、附件、管理员资料、环境变量、备份和浏览器截图继续保留在本机，不上传到公开项目库。
