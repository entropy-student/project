# Karakeep Local｜文件在哪里、怎么用、如何交给本机 Codex

> **本文件是 Owner 的唯一日常使用入口。** 技术项目状态的权威记录仍见 [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)。  
> 最后整理：2026-10-16；GitHub：`entropy-student/project` 的 `main/karakeep-local/`。  
> **原安装已结项、应用及数据原位保留。** G3B 的“只读盘点 PASS”不代表删除授权；没有正在执行的新 Gate。  
> 这里整合的是**说明和文档入口**，不是将运行数据搬到 GitHub 或把整个本机项目迁移到单一文件夹。

## 1. 我所有相关文件现在在哪里？

请先区分**项目管理文档**、**Windows 本机运行配置**、**Docker 用户数据**三件事：

| 类别 | 已核实的位置（可直接复制） | 保存什么 | 能否删除或搬动 |
|---|---|---|---|
| **项目文档（主要入口）** | [GitHub `main/karakeep-local/`](https://github.com/entropy-student/project/tree/main/karakeep-local) | 本 README、项目交接、决定、验收与资产清单等 **Markdown 文档** | 在 GitHub 统一查看；不要把历史日志当垃圾删除 |
| **本机配置目录** | Windows 资源管理器输入 `%USERPROFILE%\KarakeepLocal` | 已核实顶层有 `docker-compose.yml`（运行配置）和 `.env`（含密钥）。**这里不是 Markdown 文档归档文件夹** | **不能删/改名/搬动** |
| **真实收藏和账户** | Docker 命名卷 `karakeep-local_data`，容器内 `/data` | 网页收藏、账号/数据库、抓取资产等 | **不能删/迁移** |
| **搜索索引** | Docker 命名卷 `karakeep-local_meilisearch`，容器内 `/meili_data` | Meilisearch 持久数据 | **不能删/迁移** |
| **Docker Desktop 后端** | Windows 路径**目录** `%LOCALAPPDATA%\Docker\wsl`（此前本机报告） | WSL2 / Docker 的底层共享存储；确切 VHDX 文件完整路径未核实 | **不能手动清理** |

**重要的事实边界：**
- 目前**已证实的 Markdown 项目文档存放位置是 GitHub**；现有本机检查并未确认一个额外的本地 Markdown 文档归档目录。不要把 `%USERPROFILE%\KarakeepLocal` 当成文档库，那里只有已报告的两个运行配置文件。
- GitHub **没有真实收藏数据库、密钥、Docker 数据卷或可以恢复用户资料的备份**。它只是文档存放处。
- 两个 named volumes 的 Linux 内部位置分别为 `/var/lib/docker/volumes/karakeep-local_data/_data` 和 `/var/lib/docker/volumes/karakeep-local_meilisearch/_data`（此前本机报告）。**这些不是 Windows 资源管理器中的普通目录**。
- **没有已确认可安全删除的本机文件，删除许可清单为空。** Owner 未要求备份/迁移或重装，数据丢失后的恢复能力仍 `UNVERIFIED`。
- 以上只覆盖当前 Karakeep 已知资产，**不是 Windows 全盘文件盘点**；本次使用说明不检查任何其它工作区或项目根目录。

## 2. 文档只分两个部分：平时只看第一部分

### 第一部分：日常使用说明（1 个文件）

**就是你现在看的这个 [README.md](./README.md)**。已经整合了：
- 文档在 GitHub 哪里、本地配置与收藏实际在哪里；
- 哪些东西必须原位保留；
- 日常打开或按需启动 Karakeep 的方法；
- 将来在**本机 Codex** 中怎么描述这个项目。

**以后绝大多数时候，只需收藏本 README 链接。** 不用每次从几十轮 Gate 和 Evidence 里找操作步骤。

### 第二部分：项目技术档案（为下一位 Reviewer/Codex 保留，不是给日常用户逐页看的）

都在**同一个 GitHub `karakeep-local/` 目录**，没有为分类而移动或删除历史记录：

| 文件 | 保存的内容 | 什么时候才需要 |
|---|---|---|
| [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) | 当前技术状态、保护边界、已接受的结果、遗留问题 | 让新的 Reviewer/Codex 接手复杂工作 |
| [LOCAL_ASSET_INVENTORY.md](./LOCAL_ASSET_INVENTORY.md) | 已知 Windows 配置、Docker 卷及限定范围的只读资产地图 | 要判断某个文件/目录是不是运行依赖时 |
| [DECISION_LOG.md](./DECISION_LOG.md) | Owner 决策、为什么保留/暂停某项操作 | 需要追溯决策原因时 |
| [CLOSEOUT_REPORT.md](./CLOSEOUT_REPORT.md) | 原 Karakeep 安装实施正式 Close 的验收 | 需要证明安装曾完成时 |
| [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) | 各轮执行证据（append-only，已有 G3B） | Reviewer 核验技术事实时 |
| [LOCAL_ASSET_ARCHIVE_PLAN.md](./LOCAL_ASSET_ARCHIVE_PLAN.md) | 此前资产整理计划和边界 | 查历史整理方案时 |
| `G3A_LOCAL_ASSET_READONLY_GATE.md`、`G3B_SASS_WORKTREE_READONLY_GATE.md` 等 | 历史执行指令 | 仅历史审计；**不要重新下发执行** |

这是**逻辑上两部分、物理上一个 GitHub 目录**的整理方式。保留原证据与历史，避免重复复制、遗失记录。以后增补日常入口内容优先修订本 README，不再为每次小问题新增一个用户阅读文件。

## 3. 我以后在 Windows 本机怎样打开 Karakeep？

**情况 A｜Docker Desktop 和 Karakeep 已经运行**

直接用本机浏览器打开：**http://localhost:3000**。

**情况 B｜Karakeep 没有运行，但要重新打开**

先手动打开 **Docker Desktop**，等 Linux Engine 显示就绪。再打开 Windows PowerShell，执行：

```powershell
Set-Location (Join-Path $env:USERPROFILE 'KarakeepLocal')
docker compose -p karakeep-local up -d --pull never
if ($LASTEXITCODE -eq 0) {
    Start-Process 'http://localhost:3000'
}
```

这是**按需启动已经安装的服务**，不是重新安装。假如命令报错，把错误原因交给本机 Codex；**不要自行卸载/清理 Docker 卷、修改 .env 或重装**。

## 4. 以后怎样向本机 Codex 表达？（直接复制）

> 请接手我 Windows 本机已经安装的 **Karakeep Local**，不是重新部署。  
> 项目统一文档位于 GitHub `entropy-student/project` 的最新 `main/karakeep-local/README.md`；需要了解当前技术状态时再读同目录 `REVIEWER_HANDOFF.md`。  
> 本机运行配置在 `$env:USERPROFILE\KarakeepLocal`，Karakeep 收藏数据位于 Docker named volume `karakeep-local_data`，搜索数据位于 `karakeep-local_meilisearch`。  
> **我本次要做的是：【在这里填写任务】。** 只做该任务所需的最小检查；先说明执行方案、可能影响，再依据我的明确授权进行写操作。  
> 不要重新安装或迁移，不要删除、清理、重置本机文件、Docker 数据卷、WSL2 存储或密钥，不要重试历史 G2B/G3A/G3B Gate；如只是查看状态，严格只读。**不要检查任何与当前任务无关的工作区或项目根目录。**

例如将占位处换为：`检查为什么 http://localhost:3000 打不开，只读定位问题`；或 `告诉我现在 Karakeep 是否运行，如何打开`。

**如果只是收藏网页，不需要 Codex。** 直接打开 Karakeep 网页使用即可。

## 5. 现在的结论，以及能不能整理/删除文件

- **已完成**：官方 Karakeep 的本机安装结项；GitHub 管理文档集中归档；已知本机运行配置及 Docker 卷的位置登记；限定范围只读盘点 G3B PASS。
- **历史未完成**：G2B 浏览器单条收藏功能测试和 G3A 中止任务；不影响之前已确认的安装状态，也不需要因整理文档而补跑。
- **不做/不得自行做**：数据迁移、备份/恢复、系统重启测试、全局 Docker 清理、删除任何未证明无引用的项目资产。
- **目前可删除项：0 个（没有批准的删除目标）**。整理**文档**和清理**正在运行的资料**是两回事。

**记住三个入口：** 文档看 **GitHub README**；要打开 Karakeep 用 **http://localhost:3000**；本机维护任务交给 **Codex 并指向此 README + Handoff**。
