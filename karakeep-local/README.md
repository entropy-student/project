# Karakeep Local · 项目统一入口

> 状态更新时间：2026-10-16
> 原本机安装实施 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`；Karakeep 保留运行。
> **唯一待下发任务**：`KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`（R2 定稿），仅本机存储位置只读核对、单条公开收藏测试、确证可弃文件的安全清理。**Executor 尚未执行 G2B。**
> 以后项目事实以 [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) 为唯一当前状态权威；本文件是索引，不替代 Handoff。

## 一、所有项目文档的统一目录

**GitHub 项目资料目录**：https://github.com/entropy-student/project/tree/main/karakeep-local

| 文件 | 用途 |
|---|---|
| [README.md](./README.md) | 文档入口、本机配置/数据位置、日常启动命令 |
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
| 程序镜像/容器/上述 Docker 卷的主机磁盘后端 | Docker Desktop 管理的 Linux 存储/虚拟磁盘 | **Windows 上实际磁盘文件绝对路径 `UNVERIFIED`**；可能和其它 Docker 项目共用底层磁盘 |
| 项目进度与验收文档 | GitHub `project/karakeep-local/` | 同一个项目文档目录，独立于 Docker 用户数据 |

你在 Karakeep 网页新增一个收藏时，应用会将相关记录/抓取资产写入 `karakeep-local_data`，搜索相关数据保存在 `karakeep-local_meilisearch`。具体数据库文件名、抓取产生哪些文件，以及 Windows 虚拟磁盘的确切路径**尚未经本轮本机只读核验**，不应凭模板猜测。

**推荐且已决定的方式**：维持当前 Compose + 原 named volumes，**不**改为 Windows bind mount，不移动/复制/合并卷，不修改 Docker Desktop `Disk image location`，不直接打开/编辑底层 VHDX，也不为了“集中路径”修改镜像或数据。这样无需动已有账号/收藏，也不干扰其它 Docker 项目。

如只想查看本机归属：下一轮 G2B 可通过 `docker volume inspect`、容器 `Mounts`、Docker Desktop **Settings → Resources → Advanced → Disk image location**（界面如果提供）进行**只读核对**，只记录路径类型和卷名等非秘密元数据；Linux `Mountpoint` 不等于资源管理器中的 Windows 普通文件夹。绝不可把默认模板路径冒充这台电脑的已验证实际位置。

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

## 四、剩余一次性任务与数据风险

- G2B 只做：本机存储布局**只读核对**、一条无敏感信息的公开网页收藏保存/抓取/搜索/预览测试、严格仅本项目**确证无引用且可再生的临时/诊断文件**安全清理。没有可靠的删除候选则不删。
- Owner 已明确：**不做备份、恢复演练、迁移、Windows/Docker Desktop 重启测试、长期监控**。旧版包含备份的 G2B 已 `SUPERSEDED_UNEXECUTED`，不能执行。
- 现有账户/收藏/搜索数据只存电脑上，`BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`；电脑故障或 Docker 存储损坏可能永久丢失收藏。不能将这个风险写成已解决或将 GitHub 文档视为恢复材料。
- 最后实际的本机技术执行是 **G1J PASS**；Owner 后续登录并找到语言设置入口，简体中文是否已经实际切换仍 `UNVERIFIED`。G2B 没有收到执行结果或清理证明。
