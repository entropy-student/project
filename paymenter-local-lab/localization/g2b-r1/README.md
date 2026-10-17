# Paymenter G2B R1 简体中文最小修复

本补丁对应 Gate `PAYMENTER-G2B-LOCAL-ZH-HANS-VISUAL-ACCEPTANCE-20261017` 的 R1 授权修复，基线为 Paymenter v1.5.9 / 源码 revision `ee729f7d99ac18942625b79f3f93d8d8b21255e8`，并要求先应用已合并的 G2A 主补丁与主题 overlay。

## 内容与边界

- `paymenter-g2b-r1-v1.5.9.patch` 是增量补丁，仅涉及 6 个文件：仪表盘 Support 标题/空状态、商品分类分组和 Slug 标签、通知列表 8 个精确默认英文标题的显示映射、页脚 3 个信息链接标签、两份 JSON 字典新增 16 个词条、套餐选项显示名称。
- 通知映射仅在管理员列表列格式化精确匹配的默认 `subject`。未知/自定义标题原样显示；含 Blade 变量的模板标题也不会命中映射。数据库字段 `key`、`subject`、正文及动态变量、站内通知字段和发送行为不变。
- 分类、Slug 和套餐选项的保存值/键保持不变。页脚 URL、品牌来源和图标保持不变。
- 优惠券日期输入没有修改：运行时 `DatePicker` 使用原生 HTML 日期控件（`native=yes`），所见 `yyyy/mm/日` 属于浏览器/系统本地化显示；未改动日期状态格式、解析或数据库值。
- 不包含数据库、环境变量、账号口令、Cookie、日志、vendor、Docker Compose、支付配置或其他 Docker 项目。

补丁 SHA-256：`cb064cdfc63601f2f9e7f06287a96e4814f09fd182fe2bff7a24e5e397c43fa4`。

## 重放到已应用 G2A 的本机 Paymenter 源码

先将补丁文件放到本机项目目录：

`%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab\g2a-work\paymenter-g2b-r1.patch`

只有在当前源码尚未应用 R1 时，才运行：

```powershell
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check /app/var/g2a-work/paymenter-g2b-r1.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply /app/var/g2a-work/paymenter-g2b-r1.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && php artisan view:clear --no-interaction'
```

此补丁不要求重建容器或重启数据库/Redis；如实际 PHP 进程未加载更新，可在 Reviewer 认可后仅重启 Paymenter 服务。当前 Owner 实例已应用此补丁。

## 回滚

在 Paymenter 容器内执行反向检查与反向应用：

```powershell
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check --reverse /app/var/g2a-work/paymenter-g2b-r1.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --reverse /app/var/g2a-work/paymenter-g2b-r1.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && php artisan view:clear --no-interaction'
```

这只恢复 R1 的 6 个文件到 G2A 已验收状态；不要反向应用 G2A 补丁，不要删除或重置 Docker 卷、数据库、账户或业务记录。