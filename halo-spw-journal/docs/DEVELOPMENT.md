# 主题开发、验证与恢复

## 源码位置

- source/theme-spw-cinema/：Halo SPW 主题源码。
- DESIGN.md：唯一的全站设计规范源，主题构建会把它复制到主题源码目录。
- components/hello-intro/：独立 Hello Web Component。
- components/spike-journey/：五词字符场与交互地球。
- components/starflow-background/：SPIKE 星流背景及局部设置面板。
- scripts/：主题准备、构建、安装、验证、回滚和草稿上传工具。

## 本机构建

需要 Python、Node.js 和 PowerShell 7。首次构建前分别安装两个组件的依赖并生成 bundle：

    cd components/spike-journey
    npm ci
    npm run build
    cd ../starflow-background
    npm ci
    npm run build
    cd ../..
    pwsh -NoProfile -File scripts/Build-Cinema.ps1
    python scripts/Verify-Cinema.py

输出主题包位于 dist/。它只包含主题前端，不含 Halo 文章、附件、账号或数据库。

## 更新与验收

升级前先检查当前主题配置并保留一致性备份。当前主题前端安装脚本为 scripts/Install-Transparent.ps1；执行安装前应确认目标 URL 指向本机 Halo，并在页面上验证首页、文章、关于页、分类、标签、搜索、评论、明暗模式和移动布局。

不要把测试文章、生产数据库或访问凭据写入公开验证材料。浏览器截图与完整运行日志只保存在本机 verification/。

## 回滚

最近一次透明阅读与子页面更新可用：

    pwsh -NoProfile -File scripts/Rollback-Transparent.ps1

只验证对应快照而不安装时：

    pwsh -NoProfile -File scripts/Rollback-Transparent.ps1 -VerifyOnly

较早的 Rollback-Starflow.ps1、Rollback-SpikeStarflow.ps1 和 Rollback-Glass.ps1 分别对应更早版本，不能互相混用。所有恢复脚本应先确认目标 Halo 实例与备份版本。

## 上游来源与许可证

主题派生自 Halo Fuwari 2.2.0。Halo、主题、Starflow、D3 地理数据和字体的许可证及来源记录随源码保留。分发主题包时保留对应 LICENSE 文件和第三方声明。
