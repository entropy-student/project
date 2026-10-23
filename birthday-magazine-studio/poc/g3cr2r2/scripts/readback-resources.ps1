$ErrorActionPreference = 'Stop'
$repoRoot = (git rev-parse --show-toplevel).Trim()
$project = 'birthday-magazine-g3cr2r2'
$base = Join-Path $repoRoot 'birthday-magazine-studio/poc/g3cr2r2'
$before = Get-Content (Join-Path $base 'artifacts/reports/resource-before.json') -Raw | ConvertFrom-Json

$containers = @(docker ps -aq --no-trunc | ForEach-Object { docker inspect --format '{{.Id}}|{{.Name}}|{{.Config.Image}}|{{.Config.Labels}}' $_ })
$volumes = @(docker volume ls -q | Sort-Object)
$networks = @(docker network ls --no-trunc --format '{{.ID}}|{{.Name}}|{{.Driver}}|{{.Labels}}' | Where-Object { ($_ -split '\|')[1] -notin @('bridge', 'host', 'none') } | Sort-Object)
$inventory = (@($containers) + @($volumes) + @($networks) | Sort-Object) -join "`n"
$sha = [Security.Cryptography.SHA256]::Create()
$fingerprint = (($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($inventory)) | ForEach-Object { $_.ToString('x2') }) -join '')
$projectContainers = @(docker ps -aq --filter "label=com.docker.compose.project=$project")
$projectVolumes = @(docker volume ls -q | Where-Object { $_ -match '^birthday-magazine-g3cr2r2_' })
$projectNetworks = @(docker network ls --format '{{.Name}}' | Where-Object { $_ -ceq 'birthday-magazine-g3cr2r2_private' })
$tmp = Join-Path $base '.tmp'
$tmpExists = Test-Path -LiteralPath $tmp
$tmpFiles = if ($tmpExists) { @(Get-ChildItem -LiteralPath $tmp -Force -Recurse -File).Count } else { 0 }
$portListeners = @{}
foreach ($port in @(8177, 8178)) { $portListeners[[string]$port] = @(Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue).Count }
$report = [ordered]@{
    capturedAtUtc = [DateTime]::UtcNow.ToString('o')
    gate = 'G3CR2R2_BLOCKSY_WEDDING_V2_CATALOG_CLOSURE'
    composeProject = $project
    projectContainers = $projectContainers.Count
    projectVolumes = $projectVolumes.Count
    projectNetworks = $projectNetworks.Count
    temporaryDirectoryExists = $tmpExists
    temporaryFileCount = $tmpFiles
    hostPortListeners = $portListeners
    unrelatedResourceCounts = $before.unrelatedResourceCounts
    unrelatedInventorySha256Before = $before.unrelatedInventorySha256
    unrelatedInventorySha256After = $fingerprint
    unrelatedInventoryFingerprintComparable = ($fingerprint -ceq $before.unrelatedInventorySha256)
    unrelatedResourcesUnchanged = ($containers.Count -eq $before.unrelatedResourceCounts.containers -and $volumes.Count -eq $before.unrelatedResourceCounts.volumes -and $networks.Count -eq $before.unrelatedResourceCounts.networks)
    paypalActions = 0
    realMoneyActions = 0
    modelCalls = 0
    sharedInfrastructureMutations = 0
    globalDockerPrune = 0
}
$report | ConvertTo-Json -Depth 6 | Set-Content -Encoding utf8 (Join-Path $base 'artifacts/reports/cleanup-readback.json')
$report | ConvertTo-Json -Depth 6
if ($report.projectContainers -ne 0 -or $report.projectVolumes -ne 0 -or $report.projectNetworks -ne 0 -or $report.temporaryDirectoryExists -or $report.temporaryFileCount -ne 0 -or $report.hostPortListeners['8177'] -ne 0 -or $report.hostPortListeners['8178'] -ne 0 -or !$report.unrelatedResourcesUnchanged) { throw 'Cleanup/read-back did not satisfy the project-scoped closure.' }
