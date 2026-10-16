# Karakeep Local · Reviewer Decision Log

> 2026-10-16 · 项目决策及理由，非技术执行证据；原执行事实在 `EXECUTION_EVIDENCE.md`，唯一当前状态在 `REVIEWER_HANDOFF.md`。

## D-20261016-CLOSE — 关闭本机安装实施，保留已运行服务

- **Decision**：Owner 明确要求正式 Close；Reviewer 将 `karakeep-local` 的**本机安装、首次登录及语言设置入口确认**实施工作结束，状态 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED`。不执行服务卸载、数据清理或失去运行能力的“完全退役”。
- **Accepted evidence**：G1J 技术部署 PASS（`EXECUTION_EVIDENCE.md` blob `71c26e6e9665e10bb87ab14e0d1514be7e7f24a4`）；Owner 在真实 Windows 浏览器显示认证后的 Karakeep 页面，并明确反馈已找到 Interface Language 设置（`OWNER_REPORTED`）；未要求/记录用户密码。
- **Why close**：原安装目标达成，继续开展重复 Docker/Chrome/代理 Gate 不增加必要的安装验证价值。
- **Excluded from PASS**：书签抓取端到端、界面语言实际切换结果、数据与 Secret 离机备份/恢复、Docker Desktop 重启后的持久性、精确 Web 源码 revision，均为 `DEFERRED_NOT_PASS` 或 `UNVERIFIED`。
- **Resources retained**：正在使用的本机 Karakeep 三容器、现有受保护 Compose/.env、原三个官方镜像、两个 project named volumes（可能已包含 Owner 账户），以及仅 loopback 的 `http://localhost:3000` 入口。没有授权 `down`/卷删除/卸载/共享配置修改。
- **Closeout disposition**：归档 GitHub 项目 Handoff / Evidence / `CLOSEOUT_REPORT.md`；本机应用继续运行；真实书签成为不可丢失资料前优先单独授权备份/恢复 Gate。完整风险、保留与重建限制见 `CLOSEOUT_REPORT.md`。

## D-20261016-G2B — 已结项项目的一次性维护收尾

- **Owner decision**：安装实施的 Close 状态不撤销；Owner 要求将本地项目安全清理、数据/Secret 备份与隔离恢复、一个可丢弃网页收藏功能验证尽量合并为一次执行；明确不安排 Windows/Docker Desktop 重启测试与长期观察。
- **Reviewer decision**：另立一次 `KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016`，只授权项目内的安全复制/隔离验证/单条非敏感 Canary/经证明可弃的项目级临时文件精确清理，执行后停 Reviewer；不反复重跑已完成的安装 Gate。
- **Why combined**：同一 Owner Windows/本地 Karakeep、同一证据与安全边界，可串行完成；独立备份目的地或一致性未验证时只能判 PARTIAL，不允许运行中 SQLite/Meili 不一致复制冒充可靠恢复。
- **Explicit exceptions**：如无真正不同故障域且受控的备份位置，`OFF_DEVICE_RECOVERY` 保留 `UNVERIFIED`，不自行上传到 GitHub/外部服务；不删除原卷、Secret、镜像、共享 Docker 对象，不作故意设备重启或长期监控。
- **Normal re-entry**：已冻结的 Compose 位于 Owner 的 `USERPROFILE\KarakeepLocal`，可在 Docker Desktop Engine 就绪后从该目录 `docker compose -p karakeep-local up -d --pull never`，再访问 `http://localhost:3000`。不需要日常调用 Codex，除非出现真实故障。

## D-20261016-G2B-R1 — Owner 取消备份，所有项目文档集中在一个目录

- **Owner latest decision**：目前没有独立备份位置，明确要求**完全取消此次数据和 Secret 备份、快照、恢复验证、迁移及备份介质寻找**。收藏和账户数据直接留在本机 Docker 命名卷；不做设备/Docker Desktop 重启测试或长期观察。
- **Risk accepted, not solved**：`BACKUP_NOT_REQUESTED / OFF_DEVICE_RECOVERY_UNVERIFIED`。单电脑/磁盘故障时账户、网页收藏与搜索数据可能无法找回；不能把 GitHub 文档、原两个 Docker 卷或本机存储当作已验证备份。
- **Reviewer scope adjustment**：此前 `KARAKEEP-WIN-G2B-ONE-SHOT-BACKUP-CANARY-CLEANUP-20261016` 草案在尚无 G2B 执行证据前被 **SUPERSEDED_UNEXECUTED**；当前仅 `KARAKEEP-WIN-G2B-FUNCTION-SAFE-CLEANUP-20261016`，包含一条公开测试收藏与确证可弃的本机临时/诊断文件清理，绝不进入持久卷/.env 或批量资料清理。
- **Document home**：`https://github.com/entropy-student/project/tree/main/karakeep-local`；新增该目录的 `README.md` 汇总 Handoff、Closeout、Decision、Evidence 的入口与本机路径说明。GitHub 只存脱敏项目文档，不上传原数据库/密钥或原日志。
- **Closeout remains**：最初安装实施状态 `CLOSED_IMPLEMENTATION_RUNTIME_RETAINED` 保持不变，剩余一次性 G2B 是 Owner 单独下达的项目级维护，不撤销历史 Close。
