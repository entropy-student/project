# G3S4E — 已留存预检与备份恢复证据

- Evidence 整理日期：2026-10-17
- 原执行日期：2026-10-16
- 状态：`PASS_CANDIDATE_G3S4E_EVIDENCE_ONLY`
- 适用 Gate：[G3S4E](../../G3S4E_PERSIST_RETAINED_PREFLIGHT_EVIDENCE_ONLY_2026-10-16.md)
- 原 G3S4 Gate：[G3S4 Stripe TEST-only Gate](../../G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_2026-10-16.md)（上轮已停止）
- Owner 授权记录：[G3S4 Stripe TEST-only 授权](../../OWNER_AUTHORIZATION_G3S4_STRIPE_TEST_ONLY_2026-10-16.md)
- PR 基线：`codex/birthday-magazine-g3c-blocksy-wedding-productization` @ `1b2e3c4e0b7c3c2f4961c991a2626f341dec5b7c`

> 本文只整理上一轮 G3S4 已留存的执行结果。本轮没有访问本机、Docker、备份文件、浏览器或支付环境；没有重跑本机检查、备份、恢复、Stripe 连接或支付。这里记录的“通过”仅指上轮对应检查的留存结果，不代表本轮复验，也不代表 G3S4 支付循环通过。

## 来源与可信度标记

- `EXECUTOR_DIRECT_HOST_READBACK`：上一轮执行器直接观察并留存在会话记录中的主机读回结果；本轮未重新检查。
- `OWNER_RELAY_ONLY`：来自 Owner 授权范围或转述，未由本轮独立读取。
- `UNVERIFIED / UNKNOWN`：现有留存信息不足；本轮不补造、不回查本机。

原执行环境记录为 Windows 11 Owner 主机；具体设备名、Windows 用户名和逐条原生进程退出码未保留。下文的直接读回事实均来自上一轮执行器会话记录，而非本轮主机检查。

## 源码与运行目标

以下为 `EXECUTOR_DIRECT_HOST_READBACK`：

- 上轮将本机 G3C Compose、Preview、Commerce、Mailpit 插件及 `.htaccess` 的 44 个有效挂载文件与 PR #64 基线 `1b2e3c4e...` 的 GitHub blob 内容核对，记录为 44/44 匹配、无差异。逐文件路径/hash 清单未留在本证据来源中：`UNKNOWN`。
- 上轮记录的项目范围既有工作区状态为 199 项：17 项历史截图删除、3 项修改、179 项未跟踪。它们在 G3S4 执行期间被保留；没有覆盖这些源码改动。该状态本轮未重查。
- 原本机站点仅绑定 `127.0.0.1:8189`，上轮 HTTP 读回为 200。WordPress 版本 7.1.1、WooCommerce 11.1.2；官方 WooCommerce Stripe 插件 11.1.0 已安装但未启用。上轮活动插件清单没有 PayPal Payments 插件；本轮没有修改或移除支付插件。
- 上轮记录站点货币 USD、已有 1 个 WooCommerce 订单（HPOS）及已发布虚拟商品 #1113（USD 39.99）。未保留任何订单/客户标识，故不在此披露。
- 上轮 WP-CLI 数据库检查因 MariaDB 自签名 TLS 失败；未修改配置。随后通过本机 MariaDB socket 的只读检查及 `mariadb-check` 记录为 58 张表通过。原生进程退出码：`UNKNOWN`。

## 新建受保护备份

以下为 `EXECUTOR_DIRECT_HOST_READBACK`，均是 2026-10-16 上轮记录；本轮没有读取或物化备份数据：

- 备份标识：`20261016T153123Z-90703d65`。脱敏位置：`%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4\20261016T153123Z-90703d65`。上轮记录目录继承已保护，访问主体为当前 Windows 账户与 SYSTEM；未保留或输出账户名。
- 备份标识所含创建时间：`2026-10-16T15:31:23Z`。各文件独立修改时间未留存：`UNKNOWN`。
- 上轮所选备份集及留存的大小、SHA-256：

| 文件 | 字节数 | SHA-256 |
| --- | ---: | --- |
| `wordpress-db-final-r1.sql` | 9,804,037 | `EA2114F00DF992556979991C205B22ACD97514954E74305EF215609345C9361B` |
| `wordpress-root-consistent-r1.tar.gz` | 127,422,362 | `C01CDB81FE59052B6C31BC8979B3D9E2F307E8490B3A6EC9A73E6712A1B547D3` |
| `g3c-bind-source-r1.tar.gz` | 23,741,093 | `45B00A576FA3147452826A042C6C33BE35F3BF8A336EF761429A493168D5B35D` |

- 上轮备份链路记录：数据库只读表检查通过后导出数据库；站点根目录归档及 44 文件源码归档进入最终所选集合。根目录归档记录 18,109 个文件。旧 G3S1S 备份的 4 项元数据保持不变。
- 上轮还记录了未选入最终集合的首次尝试产物：额外数据库导出 `wordpress-db.sql`；以及因当时 WordPress 容器处于暂停状态、无法 exec 而产生的 0 字节 `wordpress-root.tar.gz`。它们没有替代最终所选文件。本轮没有删除或检查这些文件。

## 隔离恢复读回

以下为 `EXECUTOR_DIRECT_HOST_READBACK`，只描述上一轮完成的最终隔离恢复；本轮未重做：

- 数据库转储恢复到无网络、无端口发布、无持久卷的临时 MariaDB 环境，并在临时文件系统中运行只读表检查：58 张表通过。汇总读回为 `tables=58; orders=1; product=1; price=39.99; virtual=yes`。订单及客户标识未读取到此证据中。
- WordPress 根目录归档恢复到无网络临时环境；`wp-config.php`、核心版本文件和 uploads 目录存在；记录共 18,109 个文件、387 个 uploads 文件。
- 上轮先遇到暂停容器导致的 exec 失败及就绪探测超时，随后延迟探测后完成上述最终恢复读回。最终临时容器已清理，原项目容器仍运行。
- 这些记录证明上轮隔离恢复过程的结果；本轮未读取备份字节，因而不声称当前备份对象已被重新验证为可恢复。逐条恢复命令的原生退出码：`UNKNOWN`。

## Computer Use 停止边界与支付状态

以下为 `EXECUTOR_DIRECT_HOST_READBACK`：

- 上轮 Computer Use 工具因无法以足够置信度识别 Windows 当前浏览器 URL 来执行策略检查而停止。工具返回的停止原因是：`could not determine the current browser URL on Windows with enough confidence to enforce policy`。
- 因此上轮没有继续浏览器操作或账户设置核验，也没有 Stripe 登录/OAuth、TEST 网关配置/启用、模拟付款、Webhook 测试或测试退款。未读取、请求或输出密钥。G3S4 停止在提供方操作之前。
- 本轮没有重试 Computer Use 或访问 Stripe/WooCommerce 支付流程。Owner 已给出的 Stripe TEST-only 授权仅标记授权范围（`OWNER_RELAY_ONLY`），不改变上轮停止事实。

## 未留存项

以下为 `UNVERIFIED / UNKNOWN`，遵照 G3S4E 不重做或补造：

- 各命令的原生退出码、各备份文件独立时间戳、逐文件挂载/hash 明细、Windows 设备名，以及足以重新识别当前浏览器的 URL。
- 未保留在会话记录中的原始未脱敏终端输出和任何独立第三方校验材料。

## 本次提交范围与 Reviewer 停止点

本次仅向 PR #64 新增本 Evidence Markdown。没有纳入本机已有源码/截图改动，没有修改应用源码或正式支付配置，也没有执行生产部署、合并或资金交易。

结果只表示 G3S4E 已整理并持久化所留存的预检/备份/隔离恢复事实；Stripe TEST 支付流程尚未开始。请 Reviewer 验收本证据及其 UNKNOWN 项，并另行决定后续 Gate。执行到此停止；无 Owner 转交。
