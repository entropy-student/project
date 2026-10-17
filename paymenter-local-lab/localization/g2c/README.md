# Paymenter G2C：原生语言选择与审计详情修复

对应 Gate：`PAYMENTER-G2C-LOCALE-SEMANTICS-AND-AUDIT-RUNTIME-20261017`。

目标版本：Paymenter v1.5.9，源码基线 `ee729f7d99ac18942625b79f3f93d8d8b21255e8`。本补丁是在已应用的 G2A 和 G2B-R1 源码之上追加，不改写旧补丁。

## 补丁内容

- 管理后台按允许语言读取当前 session：`zh` 仅映射为 `zh_CN` 以使用简体中文词库；`en`、`fi` 保持原值。空值和不允许的值回退到本机默认语言，默认值无效时回退到英语。
- Filament 导航分组改为请求渲染时再解析翻译，避免 Panel 初始化时提前固定在默认语言。
- 审计详情模板恢复 `$audit->event` 与 `$audit->auditable_type` 两个原始显示参数；不改审计写入、记录、权限或业务数据。

补丁只修改 3 个应用源码文件。SHA-256：`089f7a45674f2076eb3aa5c396a8a90b435c5c2af18f71b409fc6148e1bf60c2`。

## 重放到现有本机实例

前提：本机 Paymenter 已有 G2A 与 G2B-R1 层；不要重放 G1/G2A/R1，也不要用此补丁重建容器或数据库。将本文件旁的补丁复制到项目本机目录 `g2a-work\paymenter-g2c.patch`，该目录在运行容器中对应 `/app/var/g2a-work`。

```powershell
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check /app/var/g2a-work/paymenter-g2c.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply /app/var/g2a-work/paymenter-g2c.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && php artisan view:clear --no-interaction'
```

本机 Owner 实例已经应用该补丁。无需重启数据库、Redis 或重建容器；如确有 PHP opcode 缓存导致的旧代码迹象，最多只重启 Paymenter app 服务。

## 回滚

```powershell
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check --reverse /app/var/g2a-work/paymenter-g2c.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --reverse /app/var/g2a-work/paymenter-g2c.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && php artisan view:clear --no-interaction'
```

回滚只恢复 G2C 的 3 个文件到本轮开始时的 G2A+R1 状态。不要反向应用 G2A/R1，不要删除命名卷、账户、商品或其他业务数据。本机逐文件备份和 SHA 清单位于 Owner 私有目录 `Paymenter-Local-Lab\g2a-work\g2c-before`，不提交仓库。

## 已完成验证与边界

- PHP lint（中间件、Panel Provider）通过；Laravel `view:cache` 与 `view:clear` 通过。
- 用非持久化虚构审计 fixture 实际渲染 `admin.actions.audits` Blade 详情，事件和模型类型均完整显示，无参数错误。
- 通过 Laravel HTTP Kernel + 内存 session 请求验证前台 `zh/en/fi` 导航以及 admin locale、Panel 分组和商品资源分组；非法、空、未设置的 admin locale 都回退到 `zh_CN`。芬兰语没有这些 Filament 分组的本地词条，因此分组名按原生回退显示英语，同时 locale 保持 `fi`。
- 用户、分类、商品、套餐、订单、发票、服务、扩展的计数与修改前一致；12 条通知模板聚合哈希不变。没有写数据库、支付配置、订单或邮件。
- 只读 loopback HTTP：首页、登录、演示商品详情为 200；未认证 admin/dashboard 为预期 302。
- 本轮没有执行登录态浏览器/截图验收；admin HTTP 请求没有凭据，UI 视觉验收仍交 Reviewer。G2B 整体视觉状态仍为 PARTIAL。
- 额外负向探测发现：人为注入不在允许列表的前台 session locale 时，原版前台 `SetLocale` 请求未返回 200。内置 `LocaleSwitch` 会拒绝该值；按本 Gate 仅修后台非法/空 session 回退，未扩大修改到前台中间件，请 Reviewer 判断是否另列后续范围。

详见仓库根目录 `EXECUTION_EVIDENCE.md` 的 G2C 执行记录。