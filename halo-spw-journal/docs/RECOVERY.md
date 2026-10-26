# 存储与恢复状态

状态日期：2026-10-26；本轮仅核对与记录，没有恢复、迁移或密钥操作。

## 存储单元

| 项 | 当前状态 |
|---|---|
| COMPOSE_PROJECT | halo-fuwari-local；manifest 为本地 compose.yaml |
| APP_RELEASE_PATH | source/theme-spw-cinema、components；可用主题包 dist/theme-spw-cinema-2.2.0-spw.8.zip |
| DURABLE_DATA_PATHS | db、halo2（含 attachments、plugins、themes、keys、backups）以及本地 content 原稿 |
| DATABASE_ENGINE_AND_LOCATION | PostgreSQL 16；db 绑定 /var/lib/postgresql/data |
| UPLOADS_OR_OBJECT_DATA | halo2/attachments；整个 halo2 绑定 /root/.halo2 |
| PERSISTENT_MOUNTS_OR_NAMED_VOLUMES | 上述项目专属 bind mounts，无已声明业务匿名卷 |
| SECRET_LOCATIONS_METADATA_ONLY | 本地 .env、LOCAL-ACCESS.txt、halo2/keys；CLI OS 凭据存储；Wrangler 用户配置。不得复制具体值到档案 |
| SECRET_RUNTIME_READER_AND_PERMISSIONS | Halo/PG/cloudflared 按 compose 引用；Owner 本机 CLI/Wrangler。精细 ACL 和跨用户隔离未在本轮重验：UNKNOWN |
| SECRET_RECOVERY_DESTINATION_AND_LIMITATION | 旧本机快照含 .env；未证明独立故障域的加密恢复副本，异机恢复 UNKNOWN |
| BACKUP_METHOD_AND_PATH | backups 中保留多个既有快照；pre-spw-cinema-20261025 中存在 halo.dump、配置和 .env；另有 halo2/backups，具体覆盖未重验 |
| BACKUP_SCOPE_TIMESTAMP_INTEGRITY_AND_SECRET_INCLUSION | 既有快照日期由目录/文件记录；存在性 DIRECT_READBACK；完整性、最新内容覆盖、异机恢复未在本轮测试；部分含 Secret，不进入 GitHub |
| RESTORE_METHOD_AND_LAST_VALIDATION | 运维说明提供 Halo 备份/恢复或一致性 PG dump 路线；本轮未恢复数据库。上次完整恢复验证 UNKNOWN |
| RETENTION | 本轮全部保留；旧恢复点只有在替代覆盖、Secret 配对与恢复验证齐备的独立 Gate 中再决定删除 |
| MIGRATION_UNIT | compose、对应应用/主题包、PG 一致性备份、整个 Halo 持久数据、原稿/附件、独立安全 Secret 转移；未来迁移需另立 Gate |
| DECOMMISSION_RULE | 本项目仍在使用，本轮不退役 runtime、worktree 或数据 |
| EXPECTED_FOOTPRINT_OR_GROWTH | 上传附件与 DB 随内容增长；尚未建立容量预测，UNKNOWN；本轮只回收六份文档的逻辑字节 |

## 当前可证明的恢复

- 文档：本轮修改前的 8 份现行文档已在 backups/docs-governance-20261026 逐一校验。六份旧文本按 docs/ARCHIVE.md 的固定 GitHub blob 重建校验；文档恢复可验证。
- 主题：本机 .8 ZIP 存在，SHA256 为 `F3D0317FF7906668EB7F1D022CAE21C597957758885CE2A0F91A30114EC2531E`。此 hash 只标识非敏感主题包，不是数据库/Secret 恢复证明。
- 旧主题回滚：本轮静态读取 Rollback-Transparent.ps1，确认其期望恢复 .5，不是当前 .8；不要自动执行来“恢复当前版本”。
- Cloudflare Pages：上轮部署记录存在，平台可选择先前部署；本轮仅访问公开站，没有操作控制面回滚。

## 尚未证明的恢复

完整主题源码未上传到项目文档库；数据库、附件、账户与 keys 也不在 GitHub。不能只凭文档仓库在一台新电脑完整还原当前 Halo。完整灾难恢复为 PARTIAL；异机 Secret 恢复、DB/附件一致性还原均为 UNKNOWN。现有运行目录与私有恢复点因此必须保留。

如果需要验证，应另开只针对恢复的 Gate，以新目录/新实例做副本演练，先确认数据和 Secret 配对，不覆盖现有实例。
