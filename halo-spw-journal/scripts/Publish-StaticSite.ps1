param([switch]$BuildOnly)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
Push-Location $projectRoot
try {
    $probe = "try { const response = await fetch('http://127.0.0.1:8090/'); if (!response.ok) process.exit(1) } catch { process.exit(1) }"
    node --input-type=module -e $probe
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Halo 未运行，正在启动本机 Halo 与数据库……'
        docker compose up -d --wait halo
        if ($LASTEXITCODE -ne 0) { throw 'Docker 启动失败。请先启动 Docker Desktop，再重试。' }
    }

    node scripts/Export-StaticSite.mjs
    if ($LASTEXITCODE -ne 0) { throw '静态站生成失败，未执行部署。' }
    if (-not (Test-Path 'dist-static/index.html')) { throw '缺少 dist-static/index.html，未执行部署。' }
    if ($BuildOnly) {
        Write-Host '本地生成完成：dist-static。需要部署时运行本脚本（不带 -BuildOnly）。'
        return
    }

    # 此电脑的本地代理会使 Wrangler 请求超时；仅在部署子进程中临时停用。
    $proxyNames = @('HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'HTPPS_PROXY')
    $savedProxies = @{}
    foreach ($name in $proxyNames) {
        $savedProxies[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
        [Environment]::SetEnvironmentVariable($name, $null, 'Process')
    }
    # 工作区尚无 Git HEAD，从临时目录调用可避免 Wrangler 错误读取其他项目的 Git 元数据。
    Push-Location ([IO.Path]::GetTempPath())
    try {
        npx --yes wrangler@4 pages deploy (Join-Path $projectRoot 'dist-static') --project-name spw-journal-static --branch main
        if ($LASTEXITCODE -ne 0) { throw 'Cloudflare Pages 部署失败。首次使用请先运行 npx --yes wrangler@4 login。' }
    } finally {
        Pop-Location
        foreach ($name in $proxyNames) {
            [Environment]::SetEnvironmentVariable($name, $savedProxies[$name], 'Process')
        }
    }
    Write-Host '更新成功：https://spikersun.com/ 。现在可以关闭 Halo 和 Docker。'
} finally {
    Pop-Location
}
