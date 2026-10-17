# G3S4R — 本机目标核验与浏览器目标停止证据

- 执行日期：2026-10-17（Asia/Singapore）
- Gate：[G3S4R](../../G3S4R_SAFE_LOCAL_TARGET_AND_STRIPE_TEST_CONTINUATION_2026-10-17.md)
- Owner 授权：[G3S4R TEST-only 授权](../../OWNER_AUTHORIZATION_G3S4R_SAFE_TARGET_TEST_ONLY_2026-10-17.md)
- 历史预检/恢复：[G3S4E 留存证据](G3S4E_RETAINED_PREFLIGHT_AND_BACKUP_RECOVERY_2026-10-16.md)
- PR #64 目标分支：`codex/birthday-magazine-g3c-blocksy-wedding-productization`
- 执行结果：`RETURN_BROWSER_TARGET_UNVERIFIED`
- Reviewer stop：YES

> 完成本轮授权范围内的本机只读核验。Computer Use 无法按策略确认浏览器 URL，因此没有进入 Stripe 或 WooCommerce 支付写操作。下列主机结果是本轮只读读回；本证据没有复制密钥、凭据、客户资料、订单标识或备份内容。

## 本机运行目标、源码与工作区

`EXECUTOR_DIRECT_HOST_READBACK`：

- 本机 G3C WordPress 容器、WP-CLI 容器和 MariaDB 容器均运行；MariaDB 容器报告 healthy。WordPress 端口仅映射到 `127.0.0.1:8189`；MariaDB 未发布主机端口。
- 首次 PowerShell HTTP 请求返回网络异常。随后对同一 loopback URL 发出不跟随重定向的只读 GET，读回 HTTP 200，远端地址为 `127.0.0.1`。
- 运行时读回：WordPress 7.1.1；WooCommerce 11.1.2（active）；官方 WooCommerce Stripe 11.1.0（inactive）；站点货币 USD；商品 #1113 为 publish、virtual=yes、price=39.99。未读取订单/客户资料。
- 将 Compose 文件和三个现有只读 bind 源目录中的文件（含 `.htaccess`）逐项按仓库 clean filter 计算 Git blob SHA，并与 PR #64 当前树 `7397dd3bb7ab5fe62bb8575185d51405391f2c63` 比对：44/44 匹配。此结果比较的是 Git 规范化 blob 内容；没有更改或覆盖源码。
- 本机工作区 HEAD 为 `f50cc974ead65c9811f952cdf0a327c548f14efc`。只读状态计数为 200 项：17 deleted、3 modified、180 untracked。G3S4E 留存为 199 项（17/3/179）；额外 1 个 untracked 项无法与上轮路径清单逐项比较。所有本地修改均保留，本轮没有执行写入工作树的命令。

## 已有 G3S4 备份现时元数据

`EXECUTOR_DIRECT_HOST_READBACK`：读取目标文件的存在性、大小、时间和 SHA-256；未读取、展开或恢复备份内容。脱敏位置为 `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4\20261016T153123Z-90703d65`。目录 ACL 继承仍受保护，读回主体类别为当前用户与 SYSTEM。

| 文件 | 存在 | 字节数 | 当前修改时间（UTC） | SHA-256 |
| --- | --- | ---: | --- | --- |
| `wordpress-db-final-r1.sql` | yes | 9,804,037 | 2026-10-16T15:34:28.3015968Z | `EA2114F00DF992556979991C205B22ACD97514954E74305EF215609345C9361B` |
| `wordpress-root-consistent-r1.tar.gz` | yes | 127,422,362 | 2026-10-16T15:34:45.5643270Z | `C01CDB81FE59052B6C31BC8979B3D9E2F307E8490B3A6EC9A73E6712A1B547D3` |
| `g3c-bind-source-r1.tar.gz` | yes | 23,741,093 | 2026-10-16T15:34:47.0354967Z | `45B00A576FA3147452826A042C6C33BE35F3BF8A336EF761429A493168D5B35D` |

三份文件当前 SHA-256 与 G3S4E 留存值一致。没有新建备份、数据库导出或恢复。历史隔离恢复结论及其 UNKNOWN 退出码沿用 [G3S4E 证据](G3S4E_RETAINED_PREFLIGHT_AND_BACKUP_RECOVERY_2026-10-16.md)，本轮未重做。

## 根因与停止边界

- `OWNER_REPORTED / AMBIENT_UI_CONTEXT`：Owner 表示已在内置浏览器打开 `http://127.0.0.1:8189/`；本轮对话提供的浏览器上下文也显示该根路径。它是站点首页，不是 WordPress 管理设置页。
- `EXECUTOR_DIRECT_HOST_READBACK`：Stripe 插件已安装但 inactive。因此 WooCommerce 的 Payments 页面当前不会显示一个已启用的 Stripe 网关；这是找不到可配置 Stripe 支付方式的直接本机状态原因。一般入口为 WordPress 管理区的 WooCommerce → Settings → Payments；本轮没有启用插件或更改设置。
- `EXECUTOR_DIRECT_COMPUTER_USE_READBACK`：Computer Use 枚举到的是 Windows Edge 原生窗口；第一次返回的窗口句柄随后已失效。刷新窗口后，`get_window_state` 返回：`Computer Use has been stopped for this turn because it could not determine the current browser URL on Windows with enough confidence to enforce policy`。当前证据表明内置浏览器上下文与该 Windows Edge 窗口枚举不是同一个可验证表面；这是工具无法确认 URL 的可能原因，不推断为已修复。
- 按 Gate 和 Owner 授权中的安全边界，没有改用其他浏览器、API、CLI 或控制通道来绕过 Computer Use URL 安全停止；也没有在 WordPress 后台继续导航或操作。

## 未执行事项与结果

没有 Stripe 登录/OAuth、Test 网关启用/连接、WooCommerce 付款、Webhook 签名/负向/重放验证或测试退款；没有写入支付配置、公开管理端、触碰 PayPal、执行生产部署或合并 PR。由于浏览器 URL 未能按要求独立验证，本轮在 provider/Woo 写操作前返回，G3S4R 支付闭环未完成。

本 Evidence 是 PR #64 上唯一新增文件，供 Reviewer 审查 RETURN 原因、当前插件状态、备份哈希复核和工作区脏状态差异。后续若要继续，需由 Reviewer 决定一种符合 Gate 安全要求、能够可靠验证内置浏览器目标的流程；不在本轮自行切换控制面。执行停止；无 Owner 转交。
