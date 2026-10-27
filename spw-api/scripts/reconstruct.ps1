[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceTarget = Join-Path $projectRoot 'source'
$manifest = Get-Content -LiteralPath (Join-Path $projectRoot 'SOURCE_MANIFEST.json') -Raw | ConvertFrom-Json
if (Test-Path -LiteralPath $sourceTarget) { throw 'source already exists; preserve it and reconstruct in a fresh project folder.' }
git init $sourceTarget
if ($LASTEXITCODE -ne 0) { throw 'git init failed.' }
git -C $sourceTarget remote add origin $manifest.upstream_url
if ($LASTEXITCODE -ne 0) { throw 'remote configuration failed.' }
git -C $sourceTarget fetch --depth 1 origin $manifest.upstream_commit
if ($LASTEXITCODE -ne 0) { throw 'Exact upstream fetch failed; do not use a different release.' }
git -C $sourceTarget checkout --detach FETCH_HEAD
if ($LASTEXITCODE -ne 0) { throw 'checkout failed.' }
$sourceRevision = (git -C $sourceTarget rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or $sourceRevision -ne $manifest.upstream_commit) { throw 'Upstream revision mismatch.' }
foreach ($entry in $manifest.files) {
    $overlayPath = [IO.Path]::GetFullPath((Join-Path $projectRoot $entry.archive_path))
    $destinationPath = [IO.Path]::GetFullPath((Join-Path $sourceTarget $entry.source_path))
    if (!$overlayPath.StartsWith($projectRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Overlay escapes project root.' }
    if (!$destinationPath.StartsWith($sourceTarget + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Source path escapes source root.' }
    if ((Get-FileHash -LiteralPath $overlayPath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.sha256) { throw "Overlay hash mismatch: $($entry.source_path)" }
    New-Item -ItemType Directory -Path (Split-Path -Parent $destinationPath) -Force | Out-Null
    Copy-Item -LiteralPath $overlayPath -Destination $destinationPath
    if ((Get-FileHash -LiteralPath $destinationPath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.sha256) { throw "Restored file mismatch: $($entry.source_path)" }
}
Write-Output "Exact upstream and $($manifest.files.Count) SPW files reconstructed. No credentials or database have been restored."
