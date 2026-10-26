# Gate：手机端地图轮廓修复与静态发布

## GATE_ID

MAP-MOBILE-OUTLINE-20261026 — PASS_CANDIDATE

## OBJECTIVE

修复 spikersun.com 手机上地图只有经纬线、没有国家轮廓的问题，并把最小修复部署到现有 Cloudflare Pages。

## MAX_ENDPOINT_THIS_ROUND

只改静态导出器对 JS 模块资源引用的识别；只给当前已发布静态站补入一个地图 GeoJSON；部署到既有项目 spw-journal-static/main；核验地图及主要公开路由。没有修改地图算法、页面内容、文章、后台、Halo/Docker、其他项目、Tunnel、DNS 或 Cloudflare 账号配置。

## ROOT_CAUSE

journey.bundle.js 通过 new URL("./countries.json", import.meta.url) 读取国家边界数据。静态导出器原先只扫描 JS 的 import 声明，未发现这个运行时 URL，导致导出目录和 Cloudflare 正式部署都缺少 countries.json。浏览器取不到数据后，组件按设计显示“地图轮廓暂不可用”。

## ACTUAL_CHANGES

- scripts/Export-StaticSite.mjs：增加对 JS new URL(relativePath, import.meta.url) 依赖的收集，让后续正常导出能带上 countries.json。
- dist-static/themes/theme-spw-cinema/assets/journey/countries.json：从本地主题资源复制并发布。SHA-256 EC1EAF26E0B7A11462F63E01048042638A4F75E47BED997A05F8368CD80F5E42，155,939 字节，180 个 feature。
- 原静态包 664 个文件；本轮只新增 1 个文件。Cloudflare Wrangler 确认上传 1 个文件、复用 664 个文件。

## PRODUCTION_READBACK

- 新部署 ID：2563e60a-c642-4f61-8007-b248b733c2c3。
- 不可变预览：https://2563e60a.spw-journal-static.pages.dev。
- 正式站首页、文章 /archives/why-personal-website-in-2026、搜索索引和地图数据均 HTTP 200；/console/ 为 404。
- 地图 GeoJSON 在线解析为 180 个 feature，和本地源文件 SHA-256 相同。
- 浏览器打开线上首页并跳转到地图场景后，国家轮廓、海岸线与经纬线均可见，失败提示未出现。
- 浏览器画面为桌面 1280×720；没有可用的手机 viewport 仿真，未声称真实手机发布后截图验收。排障确认数据 fetch 不依赖 viewport，手机 CSS 断点也没有隐藏地图画布；先前移动端症状由相同 GeoJSON 404 引起。
- Docker engine 不可用，本轮未启动 Halo 或 Docker；部署沿用已验证的 dist-static 首页基线。前一成功 Pages 版本 c53f05b7-8132-4c8d-8e13-eac6db0bdd85 仍保留，可在回归时回滚。

## REQUIRED_EVIDENCE

- verification/mobile-map-20261026/preflight.json：旧版本、状态、数据源与原导出器 SHA。
- verification/mobile-map-20261026/asset-repair.json：唯一静态文件新增、哈希和 feature 数。
- 本地 Node 语法检查通过；实际 bundle 检出 ./countries.json，导出器新规则存在。
- Wrangler 成功结果、线上 HTTP 检查，以及本轮浏览器地图视觉核验。

## ACCEPTANCE_CRITERIA

1. 导出器可收集模块 new URL(..., import.meta.url) 依赖：PASS。
2. GeoJSON 线上 HTTP 200、JSON 可读且含 180 个 feature：PASS。
3. 地图组件在正式站浏览器中恢复陆地/国家轮廓；移动端问题根因为同一 fetch 404，资源现已可达，且移动断点没有隐藏地图画布：PASS。真实手机截图未单独采集。
4. 首页、文章、搜索和 /console/ 边界维持预期：PASS。
5. 本次部署范围只增加一个资源；项目记录完成远端回读后关闭：PASS_CANDIDATE。

## ROLLBACK_STATUS_OR_PLAN

Cloudflare 中保留原成功部署 c53f05b7-8132-4c8d-8e13-eac6db0bdd85，可回滚；本地导出器修改前版本位于 verification/mobile-map-20261026/Export-StaticSite.before.mjs，SHA-256 为 3D3276CDE859AB877B415927811B2A38C3441B824DDE3D8AE5F68B2DD40264BB。没有 Halo 数据、数据库或 Secret 变更。

## EXECUTOR_TO_REVIEWER_RELAY

结果：PASS_CANDIDATE。
改动：静态导出器追踪 import.meta URL 资源，Pages 静态树新增地图 GeoJSON 1 个文件。
验证：Node 语法检查通过；实际 bundle 依赖匹配；线上资源 200、180 features、SHA 一致；首页/文章/搜索 200、后台 404；线上浏览器可见国家轮廓。
限制：没有真实手机设备/viewport 截图；地图数据请求对所有屏幕宽度共用，移动 CSS 未禁用地图画布。
回滚：Pages previous deployment 保留；本地源快照保留。
请 Reviewer：核验本地与远端 Handoff / Gate / Evidence 回读，再将 Gate 关闭。

