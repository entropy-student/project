# SPW Journal · Reviewer 当前状态

状态日期：2026-10-26。现场核对时间：2026-10-26T10:55Z。

## PROJECT_GOAL

以 SPW/spike 个人网站展示文章与作品；Windows 本地 Halo 编辑，Cloudflare Pages 提供关机后仍可访问的公开静态前台。

## PROJECT_STAGE

`ACTIVE_MAINTENANCE`；本轮为文档治理和有限清理，不是运行环境退役。

## SYSTEM_MAP

| 层 | 当前事实 |
|---|---|
| 本地编辑源 | Windows `halo-fuwari/`，Halo 2.27.1、PostgreSQL 16，Compose 项目 `halo-fuwari-local` |
| 本地入口 | `http://localhost:8090/`、`/console/`；宿主绑定 127.0.0.1:8090；本机外部地址使用 localhost |
| 主题 | 当前源码和保留包为 SPW 放映室 2.2.0-spw.8；Hello、五词、上海/深圳地球、SPIKE 星流；当前容器关闭，未重新验证后台启用主题 |
| 公开站 | https://spikersun.com/；Cloudflare Pages 项目 spw-journal-static，生产分支 main；最新部署 2563e60a-c642-4f61-8007-b248b733c2c3；静态阅读、图片、浏览器搜索和主题交互 |
| 更新路径 | 本地 Halo 发布内容 → `Publish-Website.cmd` → 导出公开内容 → Wrangler 部署；草稿不导出 |
| 数据 | `db/` → PostgreSQL 数据；`halo2/` → Halo 状态；`halo2/attachments/` → 附件；源码/组件/文章本地文件分别在 source/components/content |
| 认证 | Halo 登录与 CLI profile、Wrangler OAuth；仅记录存储位置，详见 RECOVERY；不把凭据放进文档 |
| 共享边界 | 同级其他项目不属于本项目；cloudflared 为旧接入组件，历史上还承载 magazine 子域名，当前路由未从控制台重读，本轮不改/删 |
| 运行角色 | 前台浏览器动效，无新增后台 worker 或 scheduler；未配置本轮自动发布任务 |

## CURRENT_ACCEPTED_STATE

- BEHAVIORALLY_VERIFIED：本轮访问公网首页、已发布文章、搜索索引和地图数据均为 200；GeoJSON 含 180 个 feature；公网 /console/ 为 404。线上浏览器可见地图国家轮廓。
- DIRECT_READBACK：上轮记录 Halo、PostgreSQL、cloudflared 均 exited；本轮 Docker engine 不可用，未启动或更改容器。
- `DIRECT_READBACK`：数据库、附件目录、源码、组件、文章和本地恢复资料存在。
- `ACCEPTED_HISTORICAL_EVIDENCE`：上一轮停源站逐项检查 663 个公开文件、图片、搜索和星流通过；不冒充本轮全量重测。
- GitHub 文档与辅助发布脚本在 `entropy-student/project/main/halo-spw-journal/`；原始文章数据、完整主题源码与私有恢复材料仍在本地。

## CURRENT_GATE

MAP-MOBILE-OUTLINE-20261026：PASS_CANDIDATE，详见 CURRENT_GATE.md；修复静态导出器漏收 new URL(..., import.meta.url) 资源的问题，并部署地图 GeoJSON。上一 Gate GOV-DOC-CLOSEOUT-20261026 的归档/清理仍为历史 PASS，不重放。

## CRITICAL_CONSTRAINTS

保持本地 Halo + 公网静态站；暂不迁移 VPS；商城不部署到此域名；不修改后台/业务数据；不改共享 Git 拓扑、Docker 或 Tunnel；内容发布需用户明确指示；现行设计以 DESIGN.md 为准。

## DEFAULT_EXECUTION_CHANNEL

本地项目操作使用 Windows PowerShell 7 + 项目限定路径；GitHub 使用会话插件；Cloudflare 发布使用 Wrangler。地图修复基于与现有不可变 Pages 预览首页逐字节一致的 dist-static，只增补 GeoJSON；没有启动 Halo/Docker、登录或改动凭据。

## CURRENT_ROLLBACK_STATUS

- 文档恢复：PASS，8 份修改前文档已复制并逐一校验到 `backups/docs-governance-20261026/`；旧设计文本从已固定的 GitHub 版本重建校验后方可删除。
- 完整站点灾难恢复：PARTIAL；主题 .8 包和本地快照存在，但本轮没有做数据库恢复、异机还原或异机 Secret 恢复验证。详见 docs/RECOVERY.md，不能把文档归档当作完整备份。
- 本次地图发布的即时回滚：PASS；上一成功 Pages 部署为 c53f05b7-8132-4c8d-8e13-eac6db0bdd85，原部署保留。

## UNRESOLVED

1. /about、/user-agreement、/privacy-policy 在上一轮导出时为源站 404；本轮不新增内容。静态站地图已排除。
2. 完整源码与运行数据不在文档库；异机数据/Secret 恢复能力 UNKNOWN，后续需独立恢复 Gate。
3. cloudflared 其他子域名的当前控制面配置未重读；保留不动。
4. Ansyn 来源记录保留了当时未见根 LICENSE 的事实；授权范围未在本轮确认，不能从公开可读推断额外授权。
5. 本轮未在真实手机上做发布后截图；数据资源线上已为 200，桌面浏览器可见地图轮廓，移动断点未隐藏地图画布。

## NEXT_STEP

手机可刷新并查看 https://spikersun.com/#spw-world。以后文章仍按 docs/STATIC-SITE.md 发布。后续 Agent 重新加载当前 GitHub Governance，再从本页和新 Gate 开始；不要自动重播历史部署、授权或清理动作。

## OWNER_ACTION_REQUIRED

NONE。

## EVIDENCE_POINTERS

- EXECUTION_EVIDENCE.md：历史验收、文档治理与地图轮廓修复的实际核验。
- CURRENT_GATE.md：当前边界、relay 和验收要求。
- DECISION_LOG.md：架构与本轮清理选择的依据。
- docs/ARCHIVE.md：删除白名单、固定归档版本与恢复方法。
- docs/RECOVERY.md：存储、认证和恢复能力边界。

治理引用：GitHub main 的 vps-project-governance v0.2.7，本轮读取 commit `16e33384dc569629a1527d1c9ec0060823af09ce`、VNEXT blob `3917c88a7f36df7a53758b3879a92703d659ef9d`。这是本轮读取证据，不是下一轮版本锁定。

