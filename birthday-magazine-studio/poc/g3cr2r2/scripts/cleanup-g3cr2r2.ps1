$ErrorActionPreference = 'Stop'
$project = 'birthday-magazine-g3cr2r2'
$repoRoot = (git rev-parse --show-toplevel).Trim()
$composeFile = Join-Path $repoRoot 'birthday-magazine-studio/poc/g3cr2r2/compose.yaml'
$target = [System.IO.Path]::GetFullPath((Join-Path $repoRoot 'birthday-magazine-studio/poc/g3cr2r2/.tmp'))
$expected = [System.IO.Path]::GetFullPath((Join-Path $repoRoot 'birthday-magazine-studio/poc/g3cr2r2/.tmp'))
$prefix = [System.IO.Path]::GetFullPath($repoRoot).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar

if ($target -cne $expected -or !$target.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) { throw 'Temporary target did not resolve to the exact project-local path.' }
if ((Split-Path -Leaf $target) -cne '.tmp' -or (Split-Path -Leaf (Split-Path -Parent $target)) -cne 'g3cr2r2') { throw 'Temporary target parent guard failed.' }
if (!(Test-Path -LiteralPath $composeFile -PathType Leaf)) { throw 'Expected project Compose file is missing.' }
$ignored = git check-ignore --quiet -- 'birthday-magazine-studio/poc/g3cr2r2/.tmp'
if ($LASTEXITCODE -ne 0) { throw 'Temporary target is not ignored by Git.' }
foreach ($candidate in @($target, (Split-Path -Parent $target), (Split-Path -Parent (Split-Path -Parent $target)))) {
    if (Test-Path -LiteralPath $candidate) {
        $item = Get-Item -LiteralPath $candidate -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) { throw "Reparse point found in target path: $candidate" }
    }
}

docker compose -p $project -f $composeFile down --volumes --remove-orphans
if ($LASTEXITCODE -ne 0) { throw 'Project-scoped Docker Compose cleanup failed.' }
if (Test-Path -LiteralPath $target) { Remove-Item -LiteralPath $target -Recurse -Force }
if (Test-Path -LiteralPath $target) { throw 'Temporary package directory remains after cleanup.' }

Write-Output 'Scoped Compose resources and exact ignored .tmp directory removed.'
