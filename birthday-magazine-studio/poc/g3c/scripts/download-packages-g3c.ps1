$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\..\..'))
$tmpRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\.tmp'))
$repoPrefix = $repoRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
if (-not $tmpRoot.StartsWith($repoPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
	throw 'G3C package temp directory is outside the repository.'
}

$packages = @(
	@{ Name = 'woocommerce.11.1.2.zip'; Url = 'https://downloads.wordpress.org/plugin/woocommerce.11.1.2.zip' },
	@{ Name = 'astra.4.13.11.zip'; Url = 'https://downloads.wordpress.org/theme/astra.4.13.11.zip' },
	@{ Name = 'astra-sites.4.7.7.zip'; Url = 'https://downloads.wordpress.org/plugin/astra-sites.4.7.7.zip' }
)

New-Item -ItemType Directory -Force -Path $tmpRoot | Out-Null
foreach ($package in $packages) {
	$output = [System.IO.Path]::GetFullPath((Join-Path $tmpRoot $package.Name))
	if (-not $output.StartsWith($repoPrefix, [System.StringComparison]::OrdinalIgnoreCase) -or (Split-Path -Parent $output) -ne $tmpRoot) {
		throw 'Package output failed the project-scoped path guard.'
	}
	Invoke-WebRequest -Uri $package.Url -OutFile $output -UseBasicParsing -TimeoutSec 120
	$item = Get-Item -LiteralPath $output
	$hash = (Get-FileHash -LiteralPath $output -Algorithm SHA256).Hash.ToLowerInvariant()
	[pscustomobject]@{ name = $package.Name; bytes = $item.Length; sha256 = $hash }
}
