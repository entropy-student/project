# Karakeep Local · 项目统一入口

> 状态更新时间：2026-10-16
> 原本机安装实施 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`；Karakeep 保留运行。
> **最新状态**：G2B R2 已尝试、在 Computer Use 无法确认浏览器目标 URL 时安全停止；Canary 未执行、删除 0、Executor 未提交 G2B Evidence。Reviewer 判 `RETURN_BROWSER_TARGET_UNVERIFIED_AND_EVIDENCE_NOT_PERSISTED`，**等待下一次 Owner 指令，当前没有可执行的新 Gate**。
> 以后项目事实以 [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) 为唯一当前状态权威；本文件是索引，不替代 Handoff。
> **当前唯一待本机执行 Gate**：[G3A_LOCAL_ASSET_READONLY_GATE.md](./G3A_LOCAL_ASSET_READONLY_GATE.md)，Owner 已授权**只读本机资产盘点**，本机 Codex 尚未执行；无文件删除/移动/备份/迁移权限。历史 G2B 仍为 RETURN。

## 一、所有项目文档的统一目录

**GitHub 项目资料目录**：https://github.com/entropy-student/project/tree/main/karakeep-local

| 文件 | 用途 |
|---|---|
| [README.md](./README.md) | 文档入口、本机配置/数据位置、日常启动命令 |
| [LOCAL_ASSET_ARCHIVE_PLAN.md](./LOCAL_ASSET_ARCHIVE_PLAN.md) | Windows 本机资产归档方案；阶段 A 已授权、尚未执行，后续整理/清理未授权 |
| [G3A_LOCAL_ASSET_READONLY_GATE.md](./G3A_LOCAL_ASSET_READONLY_GATE.md) | **唯一当前执行说明**：Owner Windows 只读盘点配置/Docker/疑似 `sass` 工作区，在 GitHub 产出脱敏清单和 Evidence |
| [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) | 唯一当前状态、正在授权的 Gate、后续 Reviewer 交接 |
| [DECISION_LOG.md](./DECISION_LOG.md) | Owner 决定、Gate 调整及理由；历史决策保留 |
| [CLOSEOUT_REPORT.md](./CLOSEOUT_REPORT.md) | 原安装实施正式 Close 的结项报告及其后补充说明 |
| [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) | 各轮脱敏执行证据（append-only；当前最后一轮实际执行为 G1J） |

**GitHub 是管理文档的统一入口，不是收藏数据库，也没有密码、`.env`、Docker 数据卷或可用于数据恢复的备份。**

## 二、你的 Windows 电脑上，各部分到底放在哪里

本地有三个不同层次，**不是同一个普通 Windows 文件夹**：

| 内容 | 位置/标识 | 当前事实 |
|---|---|---|
| 本机配置目录 | `$env:USERPROFILE\KarakeepLocal` | 经历史本机执行验证存在；包含受保护 `docker-compose.yml` 和 `.env` |
| Karakeep 收藏/账号/抓取资产 | Docker named volume `karakeep-local_data` | 由 Docker Desktop Linux 引擎保存、映射到 Web 容器内 `/data` |
| 搜索索引 | Docker named volume `karakeep-local_meilisearch` | Docker 管理，映射到 Meilisearch 容器内 `/meili_data` |
| 程序镜像/容器/上述 Docker 卷的主机磁盘后端 | Docker Desktop 管理的 Linux 存储/虚拟磁盘 | G2B Executor 报告 WSL2 磁盘位置目录为 `%LOCALAPPDATA%\Docker\wsl`，**VHDX 文件名/完整路径仍 `UNVERIFIED`**；可能与其它项目共享 |
| 项目进度与验收文档 | GitHub `project/karakeep-local/` | 同一个项目文档目录，独立于 Docker 用户数据 |

你在 Karakeep 网页新增一个收藏时，应用会将相关记录/抓取资产写入 `karakeep-local_data`，搜索相关数据保存在 `karakeep-local_meilisearch`。本轮 Executor 报告 Docker Linux 内部 mountpoints 分别为 `/var/lib/docker/volumes/karakeep-local_data/_data` 和 `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`；它们不是 Windows 资源管理器普通文件夹。**具体数据库文件名及 Windows VHDX 文件绝对路径未验证**。以上本轮新增细节来自 Owner 转交 Executor 报告，未附正式 G2B Evidence，不能当作 Reviewer 独立本机读回。

**推荐且已决定的方式**：维持当前 Compose + 原 named volumes，**不**改为 Windows bind mount，不移动/复制/合并卷，不修改 Docker Desktop `Disk image location`，不直接打开/编辑底层 VHDX，也不为了“集中路径”修改镜像或数据。这样无需动已有账号/收藏，也不干扰其它 Docker 项目。

本轮 G2B 报告已使用 `docker volume inspect`、容器 `Mounts` 和 Docker Desktop UI 做只读核对；无需为搜寻 VHDX 文件名继续操作或重复执行已接受的安装检查。具体来源、证据状态与停止边界见 [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)。

## 三、日常使用与手动启动

正常直接打开 http://localhost:3000 （只在同一台 Windows 本机）。

如果 Karakeep 没在运行，**先启动 Docker Desktop 并等待 Linux Engine 就绪**，再打开 Windows PowerShell 执行：

```powershell
Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
docker compose -p karakeep-local up -d --pull never
if ($LASTEXITCODE -eq 0) {
    Start-Process 'http://localhost:3000'
}
```

这是基于已冻结 Compose 的日常**按需启动**命令；G2B 不会为了验证它而主动停止或重启容器/电脑。已有镜像和两个 named volumes 必须保留。失败时报告当前报错，不随便卸载、重装或运行 `docker compose down -v` / `docker system prune`。

## 四、G2B 中止结果与数据风险

- **本轮停止**：存储布局已报告完成只读核对，`KarakeepLocal` 顶层只有 `.env` 和 `docker-compose.yml`，**没有可删临时文件，实际删除 0**。Computer Use 无法充分确认 Windows 当前浏览器 URL 而停止，**未添加书签、未进行抓取/搜索/预览，也未执行新 HTTP 检查**。没有 G2B Executor Evidence 或 Commit SHA。Reviewer 已记录未完成、停止并等待 Owner 下一次指令。
- **不自动重试**：旧 G2B R2 授权已经在停止条件下终止，不能重新下发原提示词强行操作浏览器；如果未来 Owner 要继续单条 Canary，需要 Reviewer 新审批边界。
- Owner 已明确：**不做备份、恢复演练、迁移、Windows/Docker Desktop 重启测试、长期监控**。旧版包含备份的 G2B 已 `SUPERSEDED_UNEXECUTED`，不能执行。
- 现有账户/收藏/搜索数据只存电脑上，`BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`；电脑故障或 Docker 存储损坏可能永久丢失收藏。不能将这个风险写成已解决或将 GitHub 文档视为恢复材料。
- **已审计的最后一轮 Executor GitHub Evidence 仍是 G1J PASS**；G2B 的本机只读报告由 Owner 转交、未持久化到 Executor Evidence。Owner 先前成功登录并找到语言设置入口；是否已切换简体中文仍 `UNVERIFIED`。

## 五、本机文件整理：先做什么

整理 Karakeep 前，**不要先删除疑似根目录 `sass` / `saas` 或 Docker 目录**。其完整路径、是否存在未提交资料或被项目引用仍 `UNKNOWN`。推荐顺序：**Owner 已授权一次只读资产盘点（G3A），等待本机 Codex 执行**；查明运行配置、Docker 两卷和疑似旧工作区的归属与引用，输出 GitHub `LOCAL_ASSET_INVENTORY.md`（当前尚未创建）；由 Reviewer 审核分类哪些必须保留，哪些可以作为未来清理候选；最后**仅在 Owner 单独批准具体路径后**才可能精确清理。

[完整归档方案](./LOCAL_ASSET_ARCHIVE_PLAN.md) 不要求重新部署、迁移收藏、备份、重启或浏览器操作。历史 G2B 仍 RETURN，安装实施已 CLOSE、服务保留。