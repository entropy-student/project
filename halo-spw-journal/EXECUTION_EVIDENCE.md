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
