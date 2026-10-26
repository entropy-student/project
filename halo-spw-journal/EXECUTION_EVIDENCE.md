# SPW Journal · 执行证据

记录日期：2026-10-25

本记录只列出已实际检查的结果，不包含令牌、密码、数据库导出或私有访问资料。

| 检查项 | 结果 |
|---|---|
| Docker Compose | Halo 与 PostgreSQL 容器均处于运行状态；Halo 仅绑定本机 127.0.0.1:8090 |
| Halo 前台 | 本机首页可访问；管理后台需使用 Halo 登录会话 |
| Halo 版本 | 2.27.1 |
| PostgreSQL 版本 | 16 |
| 当前主题 | SPW 放映室 2.2.0-spw.6 |
| Halo CLI | 1.3.0，profile 指向本机 Halo |
| 图文草稿流程 | 成功上传本地图片并创建 Halo 草稿；草稿状态为 DRAFT，publish 为 false |
| 图片可用性 | 上传后的图片响应为 HTTP 200，内容类型为 JPEG，且能解码为 1024×1024 图片 |
| 重复上传 | 再次运行脚本更新同一篇受跟踪草稿，没有新增重复文章 |

详细浏览器截图、临时环境与恢复校验留在本机 verification/ 和 backups/，这些目录不属于 GitHub 文档归档。

## 2026-10-26 · 静态前台独立运行验收

- 正式域名：https://spikersun.com/；Cloudflare Pages 项目：`spw-journal-static`；生产分支：`main`；停机验收部署：`e41dfe9b.spw-journal-static.pages.dev`。
- 发布脚本成功部署 664 个文件。验证时停止本项目 Halo 与 PostgreSQL，确认本机 8090 连接失败，没有停止其他项目或整个 Docker Desktop。
- 停止源站时逐项检查 663 个公开文件，全部成功；自定义 404 页面另行保留，不计入成功文件数。
- 首页、归档、文章、分类、标签、RSS、站点地图与搜索索引可访问；浏览器搜索“个人网站”后进入文章成功，5 张页面图片（含头像）均正常加载，Starflow 画布与设置面板可用，浏览器未发现脚本错误。
- `/console/`、`/login`、Halo 服务端搜索 API 在公网均返回 404；搜索由静态索引在浏览器完成。
- HTML 与搜索索引使用 `public, max-age=0, must-revalidate`，避免浏览器长期使用旧内容。
- 一键脚本也实际完成了自动启动停止的 Halo/数据库、导出、再次部署的流程；验收后恢复本地服务供编辑使用。
- 本机详细报告：`verification/static-site/live-report.json`；截图：`verification/static-site/article-halo-stopped-final.png`。这些含实际文章内容的文件不上传到 GitHub。

这证明公开阅读、图片、静态搜索和主题交互不依赖本地容器。Halo 后台、评论提交和实时统计属于服务端能力，未声称它们在纯静态站中运行。更新方式见 `docs/STATIC-SITE.md`。

收尾将本机 Halo 外部地址恢复为 `http://localhost:8090/`，再次完成全站导出与部署（`c53f05b7.spw-journal-static.pages.dev`）。本机预览地址与公网静态域名分开，导出 HTML 未保留本机 8090 地址。
