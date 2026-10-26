# SPW 静态前台与文章更新

状态日期：2026-10-26。正式站点为 https://spikersun.com/，Cloudflare Pages 项目为 `spw-journal-static`，生产分支为 `main`。不要把独角兽商城部署到这个域名。

## 运行方式

- Halo 和 PostgreSQL 保留在这台电脑的 Docker Compose 项目中，Halo 后台入口为 `http://localhost:8090/console/`。
- 公开前台由 Cloudflare Pages 提供，项目名为 `spw-journal-static`，正式域名为 `https://spikersun.com/`。
- 本机 Halo 是文章与页面的编辑源；Cloudflare Pages 保存最近一次生成的静态发布版本。两者分开运行，所以电脑和 Docker 关闭后，最近一次部署的公开页面仍可访问。
- 本机私有 `.env` 中 `HALO_EXTERNAL_URL` 使用 `http://localhost:8090/`，保证后台预览与新上传图片使用本机地址。导出时会转换为 `https://spikersun.com/`，不要再把本机 Halo 的外部地址改回公网静态域名。
- Cloudflare Pages 通过全球边缘网络提供静态资源。无需另加一层 CDN 缓存规则；不要给 HTML 设置长时间强缓存，否则新文章可能迟迟不更新。

## 发布文章后的最简单流程

1. 打开 Docker Desktop。进入 Halo 后台编辑文章、上传图片，并在 Halo 中正式发布文章。未发布的草稿不会进入公开静态站。
2. 双击项目根目录的 `Publish-Website.cmd`，等待出现“更新成功”。也可在 Windows PowerShell 进入本项目目录，执行：

       pwsh -NoProfile -File .\scripts\Publish-StaticSite.ps1

3. 刷新 https://spikersun.com/ 检查更新。随后可以关闭 Halo、Docker Desktop 或电脑，公开站点仍由 Cloudflare 托管。

脚本会检查本机 Halo；若 Docker Desktop 已运行但 Halo 已停止，会自动启动 Halo 和数据库，再导出页面、图片、RSS、站点地图及文章搜索索引，并通过 Wrangler 发布。Docker Desktop 完全关闭时，先启动 Docker Desktop 再运行脚本。仅想本地生成并检查、不上传时执行：

    pwsh -NoProfile -File .\scripts\Publish-StaticSite.ps1 -BuildOnly

## 首次配置

Pages 项目名必须为 `spw-journal-static`。首次部署前需要使用 Cloudflare 账号完成一次 Wrangler 登录：

    npx --yes wrangler@4 login

登录凭据由 Wrangler 保存在本机用户配置目录，不要复制到项目、Markdown、`.env` 或 GitHub。后续部署复用该登录状态；凭据失效时再重新登录。自动部署脚本不读取或打印 `.env`。

这台电脑的 `HTTP_PROXY` 指向本地代理，曾导致 Wrangler 授权令牌交换超时。发布脚本只在 Wrangler 调用期间临时清除代理环境变量，随后恢复，不更改 Windows 或其他应用的代理设置。若手动登录也遇到同样超时，在当前 PowerShell 窗口临时执行 `$env:HTTP_PROXY = ''`、`$env:HTTPS_PROXY = ''`，再重新登录。工作区尚无 Git HEAD，脚本从系统临时目录调用 Wrangler，避免读取其他项目的 Git 信息。

## 页面能力与边界

静态站包含 Halo 已公开的首页、文章、分类、标签、页面、文章图片和主题资源；保留 SPIKE/Starflow 动效、主题交互、页面导航、RSS 与站点地图。搜索使用本次导出的公开文章索引，不依赖本机 Halo API。Halo 访问统计跟踪脚本不会复制到静态站。

静态前台可独立阅读。Halo 后台编辑/发布、评论写入、Halo 访问统计及其他实时 Halo API 在本机 Halo 关闭时不可用；重新打开本地 Halo 后，后台照常使用。部署只导出公开页面，不会发布后台、登录页或未发布草稿。

在本地 Halo 点击“发布”只会更新本机编辑源，必须再运行一次静态发布脚本才能更新公网。修改主题、导航、头像、独立页面、图片或删除文章后，同样运行一次脚本。它会重新生成全站，不需要手工修改云端文件；部署失败时 Cloudflare 保留上一份成功版本。

本次 HTTP 验证中，HTML 与搜索索引的响应头为 `Cache-Control: public, max-age=0, must-revalidate`。Cloudflare 提供边缘托管与加速，浏览器会重新验证内容，避免长期缓存旧文章；这不承诺中国大陆所有网络都能获得同样速度。

## 已完成的实际验收

- Wrangler 完成账号授权，正式部署成功。验收版本包含 664 个文件，对应部署为 `e41dfe9b.spw-journal-static.pages.dev`；后续运行发布脚本会创建新的部署版本。
- 单独停止本项目 Halo 与 PostgreSQL，确认 `127.0.0.1:8090` 无法连接；未关闭整个 Docker Desktop，以免影响其他项目。
- 在上述停止状态下，正式域名的首页、归档、文章、分类、标签、RSS、站点地图和搜索索引均返回 HTTP 200。
- 最终版本逐项检查 663 个公开文件，失败数为 0；`/console/`、`/login` 和服务端搜索 API 返回 404，公开域名不再暴露本机后台。
- 浏览器实际搜索“个人网站”并点击进入文章；文章封面与正文共 5 张已加载图片（包含头像）均有有效自然宽度。
- 文章页 Starflow 画布和参数面板可用，检查时浏览器没有脚本错误。验收截图保留在本机 `verification/static-site/`。
- 验收后通过一键脚本重新启动本地 Halo 与数据库，便于继续写作。公网 Pages 不依赖这些容器。

当前本机 `/about`、`/user-agreement`、`/privacy-policy` 返回 404，属于尚未准备好的源站页面；未创建替代内容，导出时从站点地图排除。头像仍保留原来的 `/about` 链接，如需启用，请在 Halo 后台发布对应页面后再次部署。

## 验收与排查

- 本地生成后检查 `dist-static/index.html`、`dist-static/search-index.json` 和 `dist-static/archives/`。
- 部署完成后检查首页、文章链接、文章图片和搜索；Cloudflare Pages 项目中也可查看当前部署记录并回滚到之前的部署。
- 如脚本提示 Halo 无法连接，先确认 Docker Desktop 已启动，再在项目目录执行 `docker compose up -d --wait`，之后重试发布命令。
- 如提示 Wrangler 未授权，执行一次 `npx --yes wrangler@4 login`，完成 Cloudflare 登录，再重试。
- 如首页正常但文章未更新，确认文章已经在 Halo 中发布，并等待 Cloudflare 部署命令成功后刷新页面。
- 公网域名应指向 Pages；保留其他子域名的 Tunnel 路由时，只调整 `spikersun.com` 对应的根域名路由。

## 相关文件

- scripts/Export-StaticSite.mjs：从本机 Halo 导出公开页面和依赖资源，并生成静态搜索索引；追踪 JS import 与 new URL(..., import.meta.url) 资源。
- `scripts/Publish-StaticSite.ps1`：一键检查/启动 Halo、生成静态站并部署到 Cloudflare Pages。
- `Publish-Website.cmd`：Windows 双击入口，结束后保留结果窗口。
- `docs/OPERATIONS.md`：Halo 启停、写作、图片、页面管理及迁移说明。

