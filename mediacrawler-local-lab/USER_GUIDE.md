# MediaCrawler Windows 原版使用说明（预期界面；安装成功前不保证实际可用）
> 仅限经 G1 Codex 返回成功后使用。项目源代码固定 `156c602c8d689266e6c5e9130b36f0b70495f5f0`。

1. 首次 Codex 安装后，打开报告中的本机地址，首选 `http://127.0.0.1:8080`（冲突时 `http://127.0.0.1:18080`）。此 WebUI 原生支持小红书、抖音、快手、B站、微博、贴吧、知乎。
2. 在页面设置平台、关键词、采集类型（search/detail/creator）、是否采集评论/二级评论、媒体下载与存储类型（JSONL/JSON/CSV/Excel/SQLite 等）。目前**一个任务运行一个平台**；换平台再发起下一任务，不能将这描述为自动一次采集七平台。
3. 任务启动/停止/日志和数据预览/下载是原版 WebUI 能力；**在 Reviewer 批准真实平台测试前，先不要点击开始采集或扫描登录二维码**。
4. 作者最新原版默认连接现有 Chrome/Edge（CDP）。本安装只在自己的项目副本把 CDP 关闭，后续由本项目隔离 Chromium 浏览器与 `source/browser_data/` 维护专用登录状态。不需要修改 Chrome 远程调试设置。**不要向 WebUI 粘贴 Cookie**：原版后端启动日志可能暴露 Cookie。
5. 无需 PostgreSQL 才能导出 JSONL/JSON/CSV。数据在本项目 `source/data/`，Codex 可以处理本地文件并按 note_id/platform/source_keyword 分类、去重、研究痛点。勿把原始账号数据/登录资料上传公共 GitHub。
6. 启动：运行 Codex 生成的项目内 `START_HERE.cmd`（或 `runtime/Start-MediaCrawler.ps1`），只打开本机 Uvicorn WebUI 单服务。关闭：在专属控制台 Ctrl+C。不要通过结束所有 Python、Docker 或浏览器进程来停机。
7. 若启动后 WebUI 页面能打开，但二维码验证或抓取失败，这是**平台访问/登录问题**，与 WebUI 安装成功不同；需向 Reviewer 提供去敏错误类别及实际资源指标。目标平台条款、合理速率及非商业许可证仍适用。
