# Gate: 手机端地图轮廓修复与静态发布

## GATE_ID

MAP-MOBILE-OUTLINE-20261026 — IN_PROGRESS

## OBJECTIVE

修复 spikersun.com 手机上地图只有经纬线、没有国家轮廓的问题，并将最小修复部署到现有 Cloudflare Pages。

## MAX_ENDPOINT_THIS_ROUND

只修改 Halo/SPW 项目的静态导出器，使其收集 JS 的 new URL(path, import.meta.url) 依赖；只在现有静态发布目录补入地图所需的 countries.json；发布到既有 Pages 项目 spw-journal-static / main；验证手机视口地图数据及主页/文章/搜索/后台边界。不得更改地图算法、内容、其他页面、其他项目、Halo/Docker、Tunnel、DNS 或 Cloudflare 账号配置。

## TARGET_AND_SCOPE

- 本地：halo-fuwari/scripts/Export-StaticSite.mjs 与 dist-static/themes/theme-spw-cinema/assets/journey/countries.json。
- 线上：Cloudflare Pages 项目 spw-journal-static，生产分支 main，正式域名 https://spikersun.com/。
- GitHub 项目记录：entropy-student/project 的 main:halo-spw-journal/。

## PREFLIGHT

- 现有生产部署：c53f05b7-8132-4c8d-8e13-eac6db0bdd85，https://c53f05b7.spw-journal-static.pages.dev。
- 其不可变预览首页与本机 dist-static/index.html 字节一致；本机发布包有 664 个文件。
- 线上及本机静态目录均缺少 /themes/theme-spw-cinema/assets/journey/countries.json；线上 HEAD 为 404。
- 本机主题源码已有 155,939 字节地图 GeoJSON（180 个 feature）；与组件源数据 SHA-256 一致。
- journey.bundle.js 确实通过 new URL("./countries.json", import.meta.url) 加载数据；导出器仅扫描 JS 的 import 依赖，因此遗漏此资源。
- Docker Desktop engine 当前未运行；不启动本机 Halo/Docker。本轮只基于与当前正式 Pages 预览逐字节一致的已发布静态包增补缺失资源。

## APPLICABLE_CONSTRAINTS

仅修复地图轮廓资源的收集与交付。保持当前主题、页面文案、文章及功能不变。不得发布后台、草稿或其他内容。部署失败时 Cloudflare 保留原生产版本。

## ACCEPTANCE_CRITERIA

1. 导出器通过语法与针对实际 bundle 的依赖识别检查，能发现 ./countries.json。
2. 重部署后地图 GeoJSON 返回 200、JSON 有 180 个国家/地区 feature。
3. 手机视口页面运行时地图进入 data-map-ready=true，且视觉可见地图轮廓，不再显示失败提示。
4. 正式首页、现有文章、静态搜索继续可用；/console/ 继续为 404。
5. Cloudflare 最新生产部署与本地目录仅有获准的地图数据修复；文档记录和远端 read-back 完成。

## ROLLBACK_STATUS_OR_PLAN

本地修改前导出器快照保留于 verification/mobile-map-20261026/Export-StaticSite.before.mjs。如发布后出现回归，使用 Cloudflare Pages 保留的前一成功部署回滚；本机导出器可从该快照恢复。回滚不会改动 Halo 数据或账号配置。

## REVIEWER_TO_EXECUTOR_RELAY

完成以上唯一的导出器依赖识别补丁；验证前后静态包的首页基线一致，并核对缺失的 GeoJSON。按用户授权向既有 spw-journal-static 的 main 部署。完成手机视口运行时检查和公网边界检查后，更新 Gate / Evidence / Handoff；只读回远端项目记录。任一目标路径、生产项目或产物基线不符即停止。
