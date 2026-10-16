# G3B SaSS 本机资产只读盘点

> Gate: `KARAKEEP-WIN-G3B-SASS-WORKTREE-READONLY-20261016`  
> 盘点时间：2026-10-16（Asia/Singapore）  
> 本清单只记录脱敏元数据，不构成归档、移动或删除授权。

## 范围与结论

- 目标：`%USERPROFILE%\Documents\ChatGPT\SaSS`。通过原生 Windows PowerShell 7.6.5 构造并核对该精确路径；路径存在，父路径链无 reparse point。
- 盘点边界：目标根目录和直接子项的元数据；没有读取项目文件正文，没有进入其它项目、AppData、浏览器配置、Docker/WSL 数据或整个 C 盘。
- 根目录有 1 个条目，且该条目为 `.git` 目录；普通文件 0、非 Git 子目录 0；Git 索引中跟踪路径 0。未发现可据以识别项目的普通工作树文件。
- Git 将目标路径识别为仓库根，当前为具名分支（名称省略）。状态计数：staged 0、modified 0、untracked 0、deleted 0、renamed 0。无 origin remote、无 upstream；不能证明本地提交已推送，故未推送状态为 **UNVERIFIED**。
- Docker 只读检查限于三个 `karakeep-local` 容器：没有容器将 SaSS 路径作为 bind mount。容器的 Compose 工作目录标签指向独立的 `%USERPROFILE%\KarakeepLocal`。这不能证明其它项目或进程未引用 SaSS；此类引用保持 **UNKNOWN**。
- **初步分类：** SaSS 为归属未确认的 Git 仓库，归为 `UNKNOWN_OR_SHARED`（保留）。没有足够证据将它列为可归档候选。本清单没有任何可删除结论。

## 资产明细

| PATH_REDACTED | ASSET_TYPE | OWNERSHIP | KARAKEEP_RUNTIME_REFERENCE | OTHER_REFERENCE | GIT_DIRTY_OR_UNTRACKED | PUSH_STATUS | DATA_UNIQUENESS | CLASSIFICATION | EVIDENCE_LEVEL | NEXT_SAFE_ACTION |
|---|---|---|---|---|---|---|---|---|---|---|
| `%USERPROFILE%\Documents\ChatGPT\SaSS` | 本机 Git 工作区；根目录仅有 Git 元数据目录，无普通工作树文件 | Git 根与目标路径相同；无 remote，具体仓库/项目归属 UNKNOWN | 三个目标容器均无指向 SaSS 的 bind mount（直接只读核验） | 其它项目/进程是否引用 UNKNOWN，未扫描 | tracked 0；staged/modified/untracked/deleted/renamed 均 0 | UNVERIFIED：无 origin/upstream；未联网 fetch | Git 对象/历史是否含独有提交未检查，保守视为可能独有 | UNKNOWN_OR_SHARED | 本轮 DIRECT_READBACK | 保留；先由 Owner 确认仓库身份、历史是否有远端副本及引用关系，再另行评估 |
| `%USERPROFILE%\KarakeepLocal` | Karakeep Compose 与环境配置目录 | Karakeep 专用配置目录 | 当前目标容器 Compose 工作目录标签指向此路径；具体 Compose/.env 内容及 ACL 属既有报告，未重读 | 其它项目引用未评估 | N/A；本轮未检查配置文件或 Secret | N/A | 配置含密钥，内容未读；按受保护资料处理 | PROTECTED_ACTIVE | 目录存在为本轮 DIRECT_READBACK；配置结构/保护信息为 OWNER_REPORTED | 保持原样；不读取或改动密钥 |
| Docker named volume `karakeep-local_data` | Karakeep 持久化数据；容器内挂载 `/data` | Karakeep 项目卷 | 当前 Web 容器只读 inspect 显示挂载；Docker 内部挂载点记录为 `/var/lib/docker/volumes/karakeep-local_data/_data` | 其它项目引用未评估 | N/A；卷内容未读 | N/A | 可能包含独有收藏/业务数据；未读卷内容 | PROTECTED_ACTIVE | 当前容器挂载 DIRECT_READBACK；内部路径为 OWNER_REPORTED | 保留；不迁移、备份、删除或检查内容 |
| Docker named volume `karakeep-local_meilisearch` | Meilisearch 持久化索引；容器内挂载 `/meili_data` | Karakeep 项目卷 | 当前 Meilisearch 容器只读 inspect 显示挂载；Docker 内部挂载点记录为 `/var/lib/docker/volumes/karakeep-local_meilisearch/_data` | 其它项目引用未评估 | N/A；卷内容未读 | N/A | 索引可重建但业务关联/唯一性未核实；按受保护数据处理 | PROTECTED_ACTIVE | 当前容器挂载 DIRECT_READBACK；内部路径为 OWNER_REPORTED | 保留；不迁移、备份、删除或检查内容 |
| `%LOCALAPPDATA%\Docker\wsl`（确切 VHDX 文件路径 UNKNOWN） | Docker Desktop WSL2 后端存储位置 | Docker Desktop 共享后端；不专属于 Karakeep | Karakeep 使用 Docker named volumes；WSL2 目录与精确 VHDX 路径来自此前报告，本轮未检查 | 可能承载其它 Docker 项目数据；UNKNOWN | N/A | N/A | 跨项目共享，内容及文件级归属未读取 | UNKNOWN_OR_SHARED | OWNER_REPORTED；非本轮读回 | 保留；任何后端存储操作需独立评估 |
| `entropy-student/project:main/karakeep-local/` | GitHub 项目管理文档 | 远端项目文档 | 记录 Karakeep 管理信息，不是本机容器挂载 | 其它项目关系不在本轮范围 | N/A | N/A | 脱敏项目文档；不等同本机数据备份 | DOCUMENTED_REMOTE | GitHub connector 读回 | 按项目管理规范维护 |
| 其它项目或本机进程的 SaSS 引用 | 未盘点引用方 | UNKNOWN | 除三个 Karakeep 容器的 bind mount 外未作判断 | UNKNOWN；没有扫描其它项目/进程 | N/A | N/A | UNKNOWN | UNKNOWN_OR_SHARED | 本轮范围限制 | 在取得独立、精确授权及安全证据前保留 SaSS |

## 分类说明

- `PROTECTED_ACTIVE`：必须保留的活动配置或数据。
- `DOCUMENTED_REMOTE`：已记录在远端项目文档中的资料，不代表本机资产已有备份。
- `ARCHIVE_CANDIDATE_NOT_AUTHORIZED`：潜在归档候选但尚未授权。本轮**没有资产满足足够证据而被列入此类**。
- `UNKNOWN_OR_SHARED`：归属、引用、唯一性或跨项目影响未确认；按必须保留处理。
- 本轮未认定任何 `UNIQUE_UNPUSHED`；SaSS 没有 upstream，所以推送状态是 UNVERIFIED，而非已推送或确定未推送。

## 限制与安全边界

- 未检查 SaSS Git 对象/提交内容、配置文件正文、密钥、收藏、数据库、VHDX 内容。
- 未扫描其它开发项目或进程命令行；未确认除 Karakeep 三容器以外的引用关系。
- 未执行本机写入、删除、移动、复制、备份、迁移、归档或 Docker 状态变更。
- 没有使用 Computer Use、浏览器或 GUI。当前清单不授权任何后续清理。
