# Paymenter G2A 简体中文源码补丁

本补丁对应 Gate `PAYMENTER-G2A-ZH-HANS-SOURCE-WITHOUT-COMPUTER-USE-20261017`，目标为 Paymenter v1.5.9 / 源码 revision `ee729f7d99ac18942625b79f3f93d8d8b21255e8`。

## 文件

- [主源码补丁](paymenter-zh-hans-v1.5.9.patch)：117 个文件；涵盖用户区 `lang/zh` 文案、`zh_CN` 原生语言目录、JSON 翻译、Filament 管理导航/资源/字段/图表常用文案、Blade 常用页面和默认主题文案。
- [主题运行模板覆盖补丁](paymenter-runtime-theme-overlay-v1.5.9.patch)：只修改 `themes_default/default/theme.php` 中的默认欢迎语。Paymenter 容器启动脚本会把 `/app/themes_default` 复制到 `/app/themes`，所以本机重启持久性需要同时更新这个运行模板副本。
- 主补丁 SHA-256：`6061f07707ccb45e30a7dd5471692bb54c5682d370b32729b8f73ff52c24966a`
- 主题运行模板覆盖补丁 SHA-256：`07d05f724a79f3d3c8593b425abf2cb651051497a1d18c428093a1b118d7f4f6`

补丁作用于 Paymenter 应用容器内的 `/app` 源码树，不作用于本项目管理仓库根目录。补丁不包含数据库、`.env`、容器凭据、账号密码或 vendor 目录。

## 应用到现有本机实例

先将这两个补丁文件复制到本机项目目录：

`%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab\g2a-work\g2a.patch`

`%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab\g2a-work\runtime-theme-overlay.patch`

在 PowerShell 中先检查，再按顺序应用：

```powershell
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check /app/var/g2a-work/g2a.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check /app/var/g2a-work/runtime-theme-overlay.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply /app/var/g2a-work/g2a.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply /app/var/g2a-work/runtime-theme-overlay.patch'
```

仅当设置 `theme_default_home_page_text` 仍是 Paymenter 的精确默认值 `Welcome to Paymenter!` 时，才将这一项更新为 `欢迎使用 Paymenter 本机试用版！`。更新前保存该值，确认恰好修改一行；自定义值不覆盖。此实例的更新已完成并单独保存原值快照。

清除编译视图后，只重启 Paymenter 服务：

```powershell
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && php artisan view:clear --no-interaction'
docker compose -p paymenter_local_lab -f "$env:USERPROFILE\Documents\ChatGPT\Paymenter-Local-Lab\docker-compose.yml" restart paymenter
```

容器入口脚本启动时会自动执行 `php artisan migrate --seed --force`；应用前应确认迁移均已运行。此轮未执行数据库初始化或手工迁移命令，重启后读回为 71 Ran / 0 Pending。

## 回滚

先检查并反向应用两个补丁：

```powershell
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check --reverse /app/var/g2a-work/g2a.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --check --reverse /app/var/g2a-work/runtime-theme-overlay.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --reverse /app/var/g2a-work/g2a.patch'
docker exec paymenter_local_lab-paymenter-1 sh -lc 'cd /app && git -c safe.directory=/app apply --reverse /app/var/g2a-work/runtime-theme-overlay.patch'
```

将首页设置恢复为原值时，仅在当前值仍等于 `欢迎使用 Paymenter 本机试用版！` 的情况下恢复为 `Welcome to Paymenter!`；如果当前值已被用户自定义，停止并保留该值。最后只重启 `paymenter`。本机另有应用前的逐文件备份和哈希清单：`%USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab\g2a-work\backup-original`；数据库设置快照位于同目录下的 `private-backup`。这些备份不提交到 GitHub。

不要删除数据库/应用命名卷或运行全局 Docker 清理命令。更换 Paymenter 镜像或重建容器后，需针对新版本重新检查默认主题模板路径和补丁上下文。

## 验收边界

静态、PHP/Laravel CLI、只读 HTTP GET 和单服务重启验证见项目根目录的 `EXECUTION_EVIDENCE.md`。本 Gate 不执行浏览器登录或视觉验收；后台登录后的页面、交互、图表和弹窗仍属于 G2B。
