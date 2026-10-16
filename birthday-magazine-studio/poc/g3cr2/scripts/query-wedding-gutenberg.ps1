param(
	[Parameter(Mandatory = $true)]
	[string]$OutputPath
)

$ErrorActionPreference = 'Stop'
$composeFile = Join-Path $PSScriptRoot '..\compose.yaml'
$project = 'birthday-magazine-g3cr2'

$php = '$r = \Blocksy\Plugin::instance()->demo->fetch_single_demo(["demo" => "Wedding", "builder" => "gutenberg", "field" => "all"]); echo wp_json_encode(["invocation_completed" => true, "is_wp_error" => is_wp_error($r), "error_code" => is_wp_error($r) ? $r->get_error_code() : null, "returned_type" => gettype($r), "returned" => is_wp_error($r) ? null : (is_array($r) ? $r : (is_object($r) ? get_object_vars($r) : $r))]);'
$stdout = & docker compose -p $project -f $composeFile exec -T wpcli wp eval $php
if ($LASTEXITCODE -ne 0) { throw 'Blocksy fetch_single_demo query failed at the WP-CLI boundary.' }
$jsonLine = @($stdout | Where-Object { $_.Trim() } | Select-Object -Last 1)
if ($jsonLine.Count -ne 1) { throw 'Blocksy query did not return one JSON record.' }
$response = $jsonLine[0] | ConvertFrom-Json

function Get-Field([object]$Object, [string]$Name) {
	$property = $Object.PSObject.Properties[$Name]
	if ($null -eq $property) { return [ordered]@{ present = $false; value = $null } }
	return [ordered]@{ present = $true; value = $property.Value }
}

$returned = $response.returned
$identity = Get-Field $returned 'demo'
if (-not $identity.present) { $identity = Get-Field $returned 'name' }
$builder = Get-Field $returned 'builder'
$plugins = Get-Field $returned 'plugins'
$isPro = Get-Field $returned 'is_pro'
if (-not $isPro.present) { $isPro = Get-Field $returned 'isPro' }
if (-not $isPro.present) { $isPro = Get-Field $returned 'pro' }

$fieldNames = @()
if ($returned -is [System.Collections.IDictionary]) { $fieldNames = @($returned.Keys | Sort-Object) }
elseif ($null -ne $returned -and $returned -isnot [bool]) { $fieldNames = @($returned.PSObject.Properties.Name | Sort-Object) }
$querySuccess = [bool]$response.invocation_completed -and -not [bool]$response.is_wp_error -and $null -ne $returned -and $returned -ne $false

$report = [ordered]@{
	capturedAtUtc = [DateTime]::UtcNow.ToString('o')
	requested_demo = 'Wedding'
	requested_builder = 'gutenberg'
	returned_demo = $identity
	returned_builder = $builder
	returned_plugins = $plugins
	returned_is_pro = $isPro
	returned_value_type = $response.returned_type
	returned_value = if ($null -eq $returned -or $returned -is [bool]) { $returned } else { $null }
	returned_field_names = $fieldNames
	query_invocation_completed = [bool]$response.invocation_completed
	query_success = $querySuccess
	decision = if ($querySuccess) { 'METADATA_RETURNED' } else { 'RETURN_G3CR2R1_VARIANT_METADATA_UNAVAILABLE' }
	error_code = $response.error_code
	error_message = $null
}

$parent = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $parent | Out-Null
$report | ConvertTo-Json -Depth 20 | Set-Content -Encoding utf8 $OutputPath
$report | ConvertTo-Json -Compress -Depth 20
