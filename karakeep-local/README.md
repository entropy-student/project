# Karakeep Local · 项目统一入口

> 维护日期：2026-10-16
> **安装实施：已正式 CLOSE，Karakeep 继续本机运行。**
> **一次性收尾：G2B 待本机 Codex 执行，范围仅为功能测试和安全清理；不备份、不迁移、不测试重启、不做长期监控。**
> 本文件仅提供索引，**当前状态唯一权威是 `REVIEWER_HANDOFF.md`**；历史证据在 `EXECUTION_EVIDENCE.md`，治理规范另见 `entropy-student/spike.skill`。

## 所有项目文档：同一个 GitHub 目录

**统一地址**：https://github.com/entropy-student/project/tree/main/karakeep-local

| 文件 | 用途 |
|---|---|
| [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) | 唯一当前状态、正在执行的 Gate、下一步、风险与本机运行信息 |
| [CLOSEOUT_REPORT.md](./CLOSEOUT_REPORT.md) | 已完成的安装实施结项、验收边界及资源保留说明 |
| [DECISION_LOG.md](./DECISION_LOG.md) | 决策记录及变更理由（包括 Owner 不做备份的最新决定） |
| [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) | 历史每轮部署和验证的脱敏执行证据，只追加 |
| [README.md](./README.md) | 本索引及日常使用入口 |

**注意**：这里是项目文档仓库，**没有存放实际书签数据库、镜像卷、登录密码或 `.env` 密钥值**。不能从 GitHub 文档恢复本机用户数据。

## 本机实际存放位置（和 GitHub 文档区分）

- **网页入口**：在安装 Docker Desktop 的同一台 Windows 电脑上访问 http://localhost:3000 。
- **本机受保护配置**：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml` 和同目录 `.env`（含 Secret；不得公开或删除）。
- **实际持久数据**：Docker 项目 `karakeep-local` 使用的两个命名卷：`karakeep-local_data`（应用/用户数据）、`karakeep-local_meilisearch`（搜索索引）。它们由 Docker Desktop 管理，**不等于 Windows 资源管理器中的同名普通文件夹**；不要手动删改。
- **程序运行**：Docker Compose 项目 `karakeep-local`，服务 `web` / `chrome` / `meilisearch`；Web 主机端口只绑定 `127.0.0.1:3000`。启动前应先有运行中的 Docker Desktop Linux Engine。
- **没有独立备份**：Owner 已明确选择把数据仅留在本机，当前没有经过验证的备份和恢复副本，属于接受的数据丢失风险，状态 `BACKUP_NOT_REQUESTED / RESTORE_UNVERIFIED`。磁盘/电脑损坏可能造成收藏和账户数据不可恢复。

## 日常直接启动（无需 Codex）

通常直接打开 http://localhost:3000 。如果 Docker Desktop 已启动但 Karakeep 没有运行，在 Windows PowerShell 中执行：

```powershell
Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
docker compose -p karakeep-local up -d --pull never
if ($LASTEXITCODE -eq 0) {
    Start-Process 'http://localhost:3000'
}
```

该命令使用原本 Compose、已下载的镜像、原有密钥和两数据卷，不新建账户，也不清空收藏。若输出报错，暂停并根据具体错误排查；**不要执行 `down -v`、`docker system prune` 或删除 `.env`**。

## 一次性 G2B 收尾边界

- 仅测试一条**可丢弃、无个人信息的公开 URL** 的保存、抓取、搜索、预览；只清理可明确证明属于项目、无引用且可重新生成的本机临时/诊断文件。
- **明确不做**：任何备份/快照/恢复演练、寻找备份介质、云端上传或迁移、Windows/Docker Desktop 重启测试、长期观察、自动化监控；也不修改其他 Docker 项目或系统代理。
- 若安全清理的唯一性/无引用无法证明，保留该文件并标 `SKIPPED_UNVERIFIED`；不要为了“清完”而删除真实持久资产。
- Executor 只追加脱敏 Evidence、停在 Reviewer。Reviewer 审核后恢复安装实施已 Close 的静止状态，不自动开启其他 Gate。
