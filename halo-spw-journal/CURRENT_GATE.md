# 当前 Gate：文档治理与精确清理

## Discovery 已接受

`GOV-DOC-DISCOVERY-20261026: PASS`。只读确认公网可访问、本地三个容器已停止、数据与源码保留、远端文档基线和 7 份历史文本内容。没有猜测不存在的历史 Gate。

## GATE_ID

`GOV-DOC-CLOSEOUT-20261026` — PASS（Reviewer 已核对实际执行与归档证据）。这是已完成 Gate，不是可重复运行的清理授权。

## OBJECTIVE

按当前 Governance 整理可长期交接的项目记录，归档到 GitHub，并只清理已可重建的过时本地文档。

## MAX_ENDPOINT_THIS_ROUND

规范化当前 Handoff、Gate、Evidence、Decision Log 和恢复/归档导航；GitHub read-back；删除 docs/ARCHIVE.md 白名单中的 6 份旧设计文本；只读核对网站、容器与受保护路径。

## MANDATORY_REVIEW_STOP

归档与重建证明齐备后，在删除前由 Reviewer 核对每个候选；删除后再核对清单和运行边界，证据持久化并回读后才可 PASS。

## TARGET_AND_SCOPE

仅本地 `C:/Users/34707/Documents/ChatGPT/SaSS/halo-fuwari/` 内项目文档和白名单文件；仅 GitHub `entropy-student/project` 的 `main:halo-spw-journal/`。治理仓库、仓库根地图及其他项目不写入。

## APPLICABLE_CRITICAL_CONSTRAINTS

保持本地 Docker 编辑源与公网 Pages；不修改文章/数据库/附件/源码功能/凭据/部署配置；不停止、启动或删除 Docker 资源；不改 Tunnel、DNS 或 shared Git；保留 provenance、许可证与恢复点。

本轮扫描：11A、11B、11C、11D（对现有认证/脚本的边界记录）、11F 适用；11E 无 Provider/支付业务或账户写入，不适用；11G 不生图，不适用。已读取命中的专项，不保存 Governance 本地副本。

## PREFLIGHT

- 本机 Windows Owner 工作区、PowerShell 7.6.5；共享 Git root 为 SaSS，分支 master，无 HEAD（exit 128），无可推送的项目提交；不得为整洁创建/改动共享 Git 历史。
- 既有项目档案基线 commit：`b010874a225eeb1db95219987bb5082b470341a2`。
- 8 份本地现行文档已备份并校验；非敏感白名单文本与 GitHub blob、全文均一致。
- 公网首页/文章/搜索索引 200，后台 /console/ 404；本地 8090 offline；三个容器 exited。
- 受保护路径存在；不以“文档库可还原”声称运行数据或 Secret 可异机恢复。

## REQUIRED_EVIDENCE

6 文件逐一分类、引用排查、GitHub 精确 blob 和本地字节比对、实际重建结果；修改前文档快照；本机删除前后数量/字节；受保护路径/容器/同级 Git 状态；公网正负检查；最终 canonical read-back。

## ACCEPTANCE_CRITERIA

当前状态字段齐全且 UNKNOWN 明示；没有新增竞争治理规则；Evidence 历史只追加；六文件归档可逐字节恢复且删除后不存在；来源与法律声明保留；运行和其他项目状态未改变；远端可读取新 Handoff、Gate、Evidence、归档/恢复记录。

## ROLLBACK_STATUS_OR_PLAN

文档修改恢复到本地 `backups/docs-governance-20261026/`；被删除旧文本从固定 GitHub commit 重建并比对 blob。全站恢复能力另见 docs/RECOVERY.md，不属于本 Gate 的 PASS 范围。

## OWNER_ONLY_ACTIONS

NONE：用户已授权本项目文档归档和无效文档清理。本 Gate 不触发凭据更换、公开部署、共享设施或运行数据删除。

## REVIEWER_TO_EXECUTOR_RELAY

只读本 Gate、docs/ARCHIVE.md 的白名单表，以及本机 `verification/governance-20261026/` 的重建/前检结果。已接受：候选均为旧设计说明/提示词，GitHub 字节一致；spike-reference 来源记录及许可文件保留。先持久化文档并回读，重建候选和复核引用；只对六个精确路径做文件删除，任一 hash/路径/引用不符即停止。不要扫描其他项目、不要调用发布/回滚/授权脚本。执行后报告精确计数、保护路径与只读公网/容器结果给 Reviewer。

## EXECUTOR_TO_REVIEWER_RELAY

结果：PASS_CANDIDATE；随后 Reviewer 接受为 PASS。
改动：归档九份现行项目记录，删除六份已固定归档的旧设计文本，共 24,671 字节。
验证：远端九文件全文回读、六文件实际重建与哈希一致、删除后零残留、十四个保护路径存在、容器/同级 Git 状态未变、公网正负检查及文档链接检查均通过；详见 EXECUTION_EVIDENCE。
问题：NONE。
回滚：修改前八份文档快照保留；六份文本的固定远端版本和已验证重建保留。
请 Reviewer 检查：已实际检查 archive barrier、cleanup-result.json、postcheck.json 与 canonical 记录；本轮文档范围满足验收，全站灾难恢复仍为 PARTIAL。
Owner 转交：NONE。
