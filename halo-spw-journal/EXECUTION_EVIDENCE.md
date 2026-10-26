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

## 2026-10-26 · GOV-DOC-DISCOVERY / CLOSEOUT 前检

AUTHORIZED_GATE：Owner 请求按 GitHub vps-project-governance 整理本项目、归档后清理无效文档。规范本轮读取为 v0.2.7，commit 16e33384dc569629a1527d1c9ec0060823af09ce；VNEXT blob 3917c88a7f36df7a53758b3879a92703d659ef9d，已固定版本回读一致。没有更改治理仓库。

PREFLIGHT_FACTS：DIRECT_READBACK 确认 Windows 项目路径、PowerShell 7.6.5、共享 Git master 无 HEAD（128），本项目未跟踪但无项目提交可推送。既有 GitHub 项目档案基线为 b010874a225eeb1db95219987bb5082b470341a2。8 份现行文档已复制到 backups/docs-governance-20261026 并哈希一致。7 份历史设计文本逐一与远端 blob 和全文一致；其中来源说明仍被引用，保留，只允许清理余下 6 份。

OBJECTIVE_READBACK：DIRECT_READBACK 三容器 exited，数据、附件、源码、组件、文章、备份与凭据文件位置存在。BEHAVIORALLY_VERIFIED 本机 8090 offline；公网首页、文章、搜索索引 200，/console/ 404。本轮不启动容器、不部署网站。

ANOMALIES：上一轮“已恢复本地服务”为历史事实，现场已全部停止，记录更新而不猜测原因。现有本地 .8 主题包存在；旧 Rollback-Transparent 期望 .5，完整异机数据/Secret 恢复未验证。UNKNOWN 不计为恢复 PASS。

EVIDENCE_ARTIFACTS_AND_PURPOSE：verification/governance-20261026/preflight.json（本机前检与文档快照）；docs/ARCHIVE.md（精确候选与远端 blob）；docs/RECOVERY.md（恢复边界）；GitHub fetch_file 的逐份 read-back（归档基线）。

EXECUTOR_RESULT：前检与 Discovery 已接受；文档更新与删除尚未完成，IN_PROGRESS；最终事实另行追加，不改写上述历史。

## 2026-10-26 · GOV-DOC-CLOSEOUT 执行与 Review

AUTHORIZED_GATE：GOV-DOC-CLOSEOUT-20261026；只允许项目文档治理、GitHub 项目子目录归档及六文件删除，未扩展至运行、业务数据、Secret 或共享设施。

ACTUAL_CHANGES：创建 AGENTS、CURRENT_GATE、DECISION_LOG、RECOVERY 入口/记录，规范化 README、REVIEWER_HANDOFF、ARCHIVE、DEVELOPMENT；EXECUTION_EVIDENCE 保留 canonical 历史并只追加。九份记录上传到 entropy-student/project 的 main:halo-spw-journal，逐份 fetch_file 全文回读一致后才进入删除。

OBJECTIVE_READBACK：六份历史说明/提示词从已读取 GitHub 内容实际重建到 verification/governance-20261026/reconstructed-design，与原文件 SHA256 及 Git blob 全部一致；来源说明和法律声明不在删除白名单。删除前再次检查精确路径、普通文件/非重解析点、源 hash、重建 hash 和根目录边界。Remove-Item 仅作用于六个叶文件，无递归删除。

VALIDATION：DIRECT_READBACK 清理结果 DeletedCount=6、DeletedBytes=24671、RemainingTargets=0；14 个保护路径存在；OtherProjectGitStateUnchanged=true；RuntimeUnchanged=true，三个容器 ID 与 exited 状态一致。BEHAVIORALLY_VERIFIED 复测公网首页/文章/搜索索引为 200，/console/ 为 404。九份现行文档的本地相对链接检查无缺失。

ANOMALIES：NONE（本 Gate 内）；不把源站已停止当作故障或擅自启动。完整站点异机恢复、Secret 独立故障域恢复、旧缺失页面和第三方授权范围仍按 Handoff 标为 PARTIAL/UNKNOWN，未在本轮宣称已解决。

EVIDENCE_ARTIFACTS_AND_PURPOSE：verification/governance-20261026/reconstruction.json（6 文件重建验证）、cleanup-allowlist.json（精确白名单）、cleanup-result.json（实际删除计数与非目标 read-back）、postcheck.json（公网与文档链接检查）；docs/ARCHIVE.md 记录每个远端 blob 与固定归档 commit。原始报告和恢复资料留本机，不上传到 GitHub。

ROLLBACK_EFFECT：删除目标均可从固定 canonical archive 重建；修改前 8 文档快照保留；保留现行源码、组件、图片、文章、数据库、附件、keys、认证资料、所有旧快照和未知用途 .hallmark。未声称本轮验证了全站数据恢复。

RESOURCE_OR_BUSINESS_DELTA：六份旧工作文档逻辑大小减少 24,671 字节；没有 Docker/Pages/DNS/Tunnel/账户权限/文章状态/支付或业务数据变更。新治理文档和验收恢复证据单独保留；该数字不是净磁盘空间回收声明。

EXECUTOR_RESULT：PASS_CANDIDATE。

REVIEWER_REVIEW：已实际检查 canonical 全文回读、重建哈希、精确清理报告、保护路径、容器/同级状态和公网正负证据；所需项均 AVAILABLE、REVIEWABLE、INSPECTED 并满足本 Gate 验收。决议 PASS；最终 Handoff/Gate/Evidence 持久化回读成功后关闭本轮；下一 Gate 为 NONE。
