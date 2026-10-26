# 日常使用与部署

## 启停 Halo

在项目目录中启动服务：

    docker compose up -d --wait
    docker compose ps

查看 Halo 日志：

    docker compose logs --tail=100 halo

可在 Docker Desktop 中启动或停止整个 Compose 项目。命令行停止容器但保留数据：

    docker compose stop

启动时使用整个 Compose 项目，保证 PostgreSQL 同时运行。不要直接删除 db/ 或 halo2/；它们包含实例数据。

## 写文章与图片

文章可在 Halo 后台的“文章 → 新建”中编辑。需要手动上传图片时，进入“附件 → 上传”，再把附件插入文章。

也可以使用 Halo CLI 批量导入 Markdown。当前项目的上传脚本会：

1. 要求文章 YAML 中明确设置 halo.publish: false。
2. 上传 Markdown 正文引用的本地图片和 `cover` 字段指定的本地封面，并替换成 Halo 附件链接。
3. 将文章导入为草稿；已有脚本跟踪标记时更新原草稿。

示例 Markdown：

    ---
    title: 我的文章
    cover: assets/cover.png
    halo:
      publish: false
    ---

    正文内容。

    ![配图](assets/example.jpg)

图片路径相对于 Markdown 文件所在目录。执行：

    pwsh -NoProfile -File scripts/Upload-HaloDraft.ps1 .\content\我的文章.md

脚本要求 Halo CLI 已安装并存在名为 local 的认证 profile。访问令牌保存在 Windows 凭据库；不要把令牌写进 Markdown、脚本、环境文件或 GitHub。令牌失效时，在 Halo 后台重新创建个人访问令牌，然后通过 Halo CLI 更新本机认证。

导入脚本只保存草稿。可在后台预览和校对；只有明确需要公开时，才在 Halo 后台发布或要求助手执行发布。

## 站点页面与主题设置

- “页面 → 新建”可添加关于页等独立页面。发布页面后如需导航入口，再到“菜单”中添加页面链接。
- “主题 → SPW 放映室”管理头像、简介、颜色、Hello、序章和 Starflow 设置。
- 侧栏头像与 Halo 管理员头像分别维护。
- 主题自定义和游客调色设置不会改变文章内容；游客偏好保存在浏览器中。

## 迁移到其他服务器

优先在 Halo 后台使用“备份与恢复”导出，再在相同或兼容版本的 Halo 中恢复。

完整迁移本地 Compose 实例时，先停止服务，再安全复制项目数据卷、配置文件和数据库。不要在数据库运行时直接复制数据库文件。保留数据库密码、Halo 版本和 PostgreSQL 主版本，并在目标服务器设置正确的站点外部地址、反向代理与 HTTPS。

.env、db/、halo2/、附件和备份含有私密运行数据，不能上传到公开 GitHub。新建空实例应从 .env.example 生成自己的配置并设置随机数据库密码，不要复制本机访问凭据。

## 更新公开静态网站

最简单的入口：Halo 中发布文章后，双击项目根目录 `Publish-Website.cmd`，看到“更新成功”后刷新公网检查，即可关闭 Docker 或电脑。

Halo 只在本机运行；公开前台由 Cloudflare Pages 托管。文章在 Halo 中发布后，在项目目录运行：

    pwsh -NoProfile -File .\scripts\Publish-StaticSite.ps1

脚本会在需要时启动 Halo 和数据库，生成公开页面及图片，并部署到 `spw-journal-static`。部署成功后电脑可以关机。首次使用 Wrangler 需先完成一次 `npx --yes wrangler@4 login`。静态站保留公开阅读、页面导航、主题交互及本地搜索；Halo 后台、评论写入、访问统计等 Halo 服务端功能在本机 Halo 关闭时不可用。详见 [STATIC-SITE.md](STATIC-SITE.md)。
