param(
	[Parameter(Mandatory = $true)]
	[string]$OutputPath
)

$ErrorActionPreference = 'Stop'
$project = 'birthday-magazine-g3cr2'

function Invoke-DockerJson([string[]]$Arguments) {
	$raw = & docker @Arguments
	if ($LASTEXITCODE -ne 0) { throw "Docker read-back failed: docker $($Arguments -join ' ')" }
	return ($raw -join "`n") | ConvertFrom-Json
}

function Get-Sha256([string[]]$Values) {
	$canonical = ($Values | Sort-Object -Unique) -join "`n"
	$bytes = [Text.Encoding]::UTF8.GetBytes($canonical)
	$shaProvider = [Security.Cryptography.SHA256]::Create()
	try { $sha = $shaProvider.ComputeHash($bytes) } finally { $shaProvider.Dispose() }
	return ([BitConverter]::ToString($sha)).Replace('-', '').ToLowerInvariant()
}

$containerRecords = @()
$containerIds = & docker ps -aq --no-trunc
if ($LASTEXITCODE -ne 0) { throw 'Docker container inventory failed.' }
foreach ($id in $containerIds) {
	$inspection = Invoke-DockerJson @('inspect', $id)
	$item = @($inspection)[0]
	$labels = $item.Config.Labels
	if ($labels.'com.docker.compose.project' -ne $project) {
		$containerRecords += "container:$($item.Id)"
	}
}

$volumeRecords = @()
$volumeNames = & docker volume ls -q
if ($LASTEXITCODE -ne 0) { throw 'Docker volume inventory failed.' }
foreach ($name in $volumeNames) {
	$item = @(Invoke-DockerJson @('volume', 'inspect', $name))[0]
	if ($item.Labels.'com.docker.compose.project' -ne $project) {
		$volumeRecords += "volume:$($item.Name)"
	}
}

$networkRecords = @()
$networkIds = & docker network ls -q
if ($LASTEXITCODE -ne 0) { throw 'Docker network inventory failed.' }
foreach ($id in $networkIds) {
	$item = @(Invoke-DockerJson @('network', 'inspect', $id))[0]
	if ($item.Labels.'com.docker.compose.project' -ne $project) {
		$networkRecords += "network:$($item.Id)"
	}
}

$projectContainers = & docker ps -aq --filter "label=com.docker.compose.project=$project"
$projectVolumes = & docker volume ls -q --filter "label=com.docker.compose.project=$project"
$projectNetworks = & docker network ls -q --filter "label=com.docker.compose.project=$project"
if ($LASTEXITCODE -ne 0) { throw 'Project-scoped resource inventory failed.' }

$report = [ordered]@{
	capturedAtUtc = [DateTime]::UtcNow.ToString('o')
	project = $project
	projectResourceCounts = [ordered]@{
		containers = @($projectContainers).Count
		volumes = @($projectVolumes).Count
		networks = @($projectNetworks).Count
	}
	unrelatedResourceCounts = [ordered]@{
		containers = $containerRecords.Count
		volumes = $volumeRecords.Count
		networks = $networkRecords.Count
	}
	unrelatedResourceFingerprintSha256 = Get-Sha256 ($containerRecords + $volumeRecords + $networkRecords)
}

$parent = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $parent | Out-Null
$report | ConvertTo-Json -Depth 6 | Set-Content -Encoding utf8 $OutputPath
$report | ConvertTo-Json -Compress -Depth 6
