[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Fixture {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Get-FunctionText {
    param([System.Management.Automation.Language.Ast]$Ast, [string]$Name)
    $node = $Ast.Find({ param($item) $item -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $item.Name -ceq $Name }, $true)
    Assert-Fixture ($null -ne $node) ('FUNCTION_MISSING_' + $Name.ToUpperInvariant())
    return $node.Extent.Text
}

function Test-ThrowsCode {
    param([scriptblock]$Action, [string]$ExpectedCode)
    $actualCode = $null
    try { $null = & $Action } catch { $actualCode = [string]$_.Exception.Message }
    return [bool]($actualCode -ceq $ExpectedCode)
}

$runnerPath = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
$runnerText = [IO.File]::ReadAllText($runnerPath, [Text.Encoding]::UTF8)
$validatorText = [IO.File]::ReadAllText($PSCommandPath, [Text.Encoding]::UTF8)
$tokens = $null
$parseErrors = $null
$runnerAst = [System.Management.Automation.Language.Parser]::ParseFile($runnerPath, [ref]$tokens, [ref]$parseErrors)
Assert-Fixture ($parseErrors.Count -eq 0) 'RUNNER_AST_PARSE_FAILED'
. $runnerPath

$params = @($runnerAst.ParamBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
$credentialParams = @($params | Where-Object { $_ -match '(?i)(bduss|stoken|cookie|password|token|credential|secret|auth)' })
Assert-Fixture ($credentialParams.Count -eq 0) 'CREDENTIAL_PARAMETER_FOUND'
Write-Output 'R6_NO_CREDENTIAL_PARAMETERS=PASS'

$whoStartText = Get-FunctionText -Ast $runnerAst -Name 'New-ReadOnlyWhoStartInfo'
$whoInvokeText = Get-FunctionText -Ast $runnerAst -Name 'Invoke-ReadOnlyBaiduWho'
$whoAdds = [regex]::Matches($whoStartText, '\.ArgumentList\.Add\(''who''\)')
Assert-Fixture ($whoAdds.Count -eq 1 -and $whoStartText -notmatch '\.ArgumentList\.Add\((?!''who'')') 'WHO_ARGUMENT_NOT_EXACT'
Assert-Fixture ($whoStartText.Contains('$psi.Environment.Clear()') -and $whoStartText.Contains('$psi.RedirectStandardOutput = $true') -and $whoStartText.Contains('$psi.RedirectStandardError = $true')) 'WHO_PROCESS_BOUNDARY_INVALID'
Assert-Fixture ($whoInvokeText.Contains('$process.Kill($true)') -and $whoInvokeText.Contains('$process.WaitForExit(5000)')) 'WHO_TIMEOUT_CLEANUP_MISSING'
Assert-Fixture ($runnerText -notmatch '(?im)\.ArgumentList\.Add\(\s*''login''\s*\)|\bInvoke-BaiduCli\s+-Action\s+''login''') 'LOGIN_COMMAND_PRESENT'
Write-Output 'R6_NO_LOGIN_COMMAND=PASS'
Write-Output 'R6_WHO_ONLY_RUNTIME_ACTION=PASS'

$pinnedHash = 'ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
Assert-Fixture ($runnerText.Contains("`$script:archiveSha256 = '$pinnedHash'")) 'PINNED_ARCHIVE_HASH_CHANGED'
$archiveText = Get-FunctionText -Ast $runnerAst -Name 'Get-PinnedBaiduExecutableBytes'
$hashAt = $archiveText.IndexOf('Get-FileHash -LiteralPath $Archive -Algorithm SHA256', [StringComparison]::Ordinal)
$verifyAt = $archiveText.IndexOf('Assert-PinnedArchiveDigest -ActualSha256 $actualHash', [StringComparison]::Ordinal)
$openAt = $archiveText.IndexOf('[IO.Compression.ZipFile]::OpenRead($Archive)', [StringComparison]::Ordinal)
Assert-Fixture ($hashAt -ge 0 -and $verifyAt -gt $hashAt -and $openAt -gt $verifyAt) 'ARCHIVE_VERIFICATION_ORDER_INVALID'
$script:archiveSha256 = $pinnedHash
Assert-Fixture (-not (Test-ThrowsCode { Assert-PinnedArchiveDigest -ActualSha256 $pinnedHash } 'BAIDU_CLI_ARCHIVE_HASH_INVALID')) 'PINNED_ARCHIVE_FIXTURE_REJECTED'
Assert-Fixture (Test-ThrowsCode { Assert-PinnedArchiveDigest -ActualSha256 ('0' * 64) } 'BAIDU_CLI_ARCHIVE_HASH_INVALID') 'ARCHIVE_MISMATCH_FIXTURE_ACCEPTED'
Write-Output 'R6_PINNED_ARCHIVE_TRUST_REUSED=PASS'

$configText = Get-FunctionText -Ast $runnerAst -Name 'Assert-SafeBaiduConfigDirectory'
Assert-Fixture ($configText.Contains('Get-Item') -and $configText.Contains('Get-ChildItem') -and $configText.Contains('Get-Acl') -and $configText.Contains('ReparsePoint')) 'CONFIG_METADATA_CHECK_INCOMPLETE'
Assert-Fixture ($configText -notmatch '(?i)Get-Content|ReadAllText|ReadAllBytes|ReadAllLines|Copy-Item|Move-Item') 'CONFIG_CONTENT_ACCESS_PRESENT'
Assert-Fixture ($configText.Contains('Assert-BaiduConfigAclMetadata')) 'CONFIG_ACL_VALIDATOR_NOT_USED'
$configAclText = Get-FunctionText -Ast $runnerAst -Name 'Assert-BaiduConfigAclMetadata'
Assert-Fixture ($configAclText.Contains('BAIDU_AUTH_CONFIG_OWNER_MISMATCH') -and $configAclText.Contains('BAIDU_AUTH_CONFIG_BROAD_ACCESS')) 'CONFIG_ACL_POLICY_INCOMPLETE'
$configPresence = Resolve-BaiduConfigPresence -PathExists $false -IsDirectory $false
Assert-Fixture ($configPresence.State -ceq 'OWNER_ACTION_REQUIRED' -and $configPresence.Code -ceq 'RETURN_OWNER_ACTION_REQUIRED') 'CONFIG_ABSENT_FIXTURE_CODE_INVALID'
$configFileShape = Resolve-BaiduConfigPresence -PathExists $true -IsDirectory $false
Assert-Fixture ($configFileShape.State -ceq 'FAIL_CLOSED' -and $configFileShape.Code -ceq 'BAIDU_AUTH_CONFIG_NOT_DIRECTORY') 'CONFIG_FILE_SHAPE_FIXTURE_NOT_FAIL_CLOSED'
Assert-Fixture ((Resolve-BaiduConfigPresence -PathExists $true -IsDirectory $true).State -ceq 'INSPECT') 'CONFIG_DIRECTORY_FIXTURE_INVALID'
Write-Output 'R6_CONFIG_METADATA_ONLY=PASS'
Write-Output 'R6_CONFIG_ABSENT_OWNER_ACTION_REQUIRED=PASS'

$whoOutcomeText = Get-FunctionText -Ast $runnerAst -Name 'Resolve-BaiduWhoOutcome'
Assert-Fixture ($whoOutcomeText.Contains("'(?m)^当前帐号 uid:\s*([0-9]+),'") -and $whoOutcomeText.Contains('BAIDU_ACCOUNT_MISMATCH') -and $whoOutcomeText.Contains('BAIDU_WHO_OUTPUT_AMBIGUOUS')) 'WHO_ACCOUNT_CONTRACT_INVALID'
$rawMarker = 'RAW_PROVIDER_FIXTURE_7F41A_NONSECRET'
$syntheticUid = '947102638'
$success = Resolve-BaiduWhoOutcome -ExitCode 0 -StdOut ("provider synthetic text $rawMarker`n当前帐号 uid: $syntheticUid, fixture") -StdErr 'stderr synthetic fixture' -ExpectedUid $syntheticUid
$successText = ConvertTo-Json -InputObject $success -Compress
Assert-Fixture ($success.State -ceq 'READY' -and $success.Code -ceq 'NONE') 'WHO_MATCH_FIXTURE_FAILED'
Assert-Fixture (-not $successText.Contains($rawMarker) -and -not $successText.Contains($syntheticUid)) 'RAW_OUTPUT_OR_UID_LEAKED'
Assert-Fixture (@($success.PSObject.Properties.Name | Where-Object { $_ -match '(?i)uid|stdout|stderr|raw|account' }).Count -eq 0) 'WHO_RESULT_EXPOSES_IDENTITY'
Write-Output 'R6_RAW_PROVIDER_OUTPUT_SUPPRESSED=PASS'
Write-Output 'R6_UID_NOT_EMITTED=PASS'

$mismatch = Resolve-BaiduWhoOutcome -ExitCode 0 -StdOut '当前帐号 uid: 947102639, fixture' -StdErr '' -ExpectedUid $syntheticUid
Assert-Fixture ($mismatch.State -ceq 'FAIL_CLOSED' -and $mismatch.Code -ceq 'BAIDU_ACCOUNT_MISMATCH') 'ACCOUNT_MISMATCH_NOT_FAIL_CLOSED'
Write-Output 'R6_EXPECTED_ACCOUNT_MATCH_FAIL_CLOSED=PASS'

$unauth = Resolve-BaiduWhoOutcome -ExitCode 1 -StdOut 'synthetic unauthenticated fixture' -StdErr 'synthetic error' -ExpectedUid $syntheticUid
Assert-Fixture ($unauth.State -ceq 'OWNER_ACTION_REQUIRED' -and $unauth.Code -ceq 'RETURN_OWNER_ACTION_REQUIRED') 'UNAUTHENTICATED_FIXTURE_CODE_INVALID'
$missingUid = Resolve-BaiduWhoOutcome -ExitCode 0 -StdOut 'synthetic account unavailable' -StdErr '' -ExpectedUid $syntheticUid
Assert-Fixture ($missingUid.State -ceq 'OWNER_ACTION_REQUIRED' -and $missingUid.Code -ceq 'RETURN_OWNER_ACTION_REQUIRED') 'MISSING_ACCOUNT_FIXTURE_CODE_INVALID'
Write-Output 'R6_UNAUTHENTICATED_RETURNS_OWNER_ACTION_REQUIRED=PASS'

$ambiguous = Resolve-BaiduWhoOutcome -ExitCode 0 -StdOut "当前帐号 uid: $syntheticUid, fixture`n当前帐号 uid: 947102639, fixture" -StdErr '' -ExpectedUid $syntheticUid
Assert-Fixture ($ambiguous.State -ceq 'FAIL_CLOSED' -and $ambiguous.Code -ceq 'BAIDU_WHO_OUTPUT_AMBIGUOUS') 'AMBIGUOUS_WHO_FIXTURE_NOT_FAIL_CLOSED'
$invalidUid = Resolve-BaiduWhoOutcome -ExitCode 0 -StdOut 'synthetic uid output drift' -StdErr '' -ExpectedUid $syntheticUid
Assert-Fixture ($invalidUid.State -ceq 'FAIL_CLOSED' -and $invalidUid.Code -ceq 'BAIDU_WHO_OUTPUT_AMBIGUOUS') 'WHO_OUTPUT_DRIFT_NOT_FAIL_CLOSED'

$argumentAdds = [regex]::Matches($runnerText, '\.ArgumentList\.Add\(')
Assert-Fixture ($argumentAdds.Count -eq 1 -and $whoAdds.Count -eq 1) 'PROVIDER_ACTION_SET_NOT_WHO_ONLY'
Write-Output 'R6_NO_PROVIDER_MUTATION_COMMANDS=PASS'

$checkpointText = Get-FunctionText -Ast $runnerAst -Name 'Invoke-R6Checkpoint'
$downloadFlagAt = $checkpointText.IndexOf('$script:downloadedArchive = $true', [StringComparison]::Ordinal)
$downloadAt = $checkpointText.IndexOf('Invoke-WebRequest -Uri $script:archiveUrl', [StringComparison]::Ordinal)
$cleanupAt = $checkpointText.LastIndexOf('finally {', [StringComparison]::Ordinal)
$cleanupText = if ($cleanupAt -ge 0) { $checkpointText.Substring($cleanupAt) } else { '' }
Assert-Fixture ($downloadFlagAt -ge 0 -and $downloadAt -gt $downloadFlagAt -and $cleanupText.Contains('Remove-Item -LiteralPath $path') -and $cleanupText.Contains('Remove-Item -LiteralPath $script:runtimeDirectory')) 'RUNTIME_CLEANUP_BOUNDARY_INVALID'
Assert-Fixture ($cleanupText -notmatch 'Remove-Item[^\r\n]*-Recurse') 'RUNTIME_CLEANUP_TOO_BROAD'
Write-Output 'R6_ATOMIC_RUNTIME_CLEANUP=PASS'

$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$fixtureRoot = Join-Path $tempRoot ('vpn-g4b-r6-fixture-' + [Guid]::NewGuid().ToString('N'))
$fixtureProject = Join-Path $fixtureRoot 'repo'
$fixtureConfig = Join-Path $fixtureRoot 'config'
$fixtureFile = Join-Path $fixtureConfig 'config.fixture'
$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
try {
    [void][IO.Directory]::CreateDirectory($fixtureRoot)
    Set-OwnerOnlyAcl -Path $fixtureRoot -OwnerSid $ownerSid -Directory
    [void][IO.Directory]::CreateDirectory($fixtureProject)
    [void][IO.Directory]::CreateDirectory($fixtureConfig)
    Set-OwnerOnlyAcl -Path $fixtureProject -OwnerSid $ownerSid -Directory
    Set-OwnerOnlyAcl -Path $fixtureConfig -OwnerSid $ownerSid -Directory
    [IO.File]::WriteAllText($fixtureFile, 'R6_NON_SECRET_CONFIG_FIXTURE')
    Set-OwnerOnlyAcl -Path $fixtureFile -OwnerSid $ownerSid
    Assert-SafeBaiduConfigDirectory -ConfigDirectory $fixtureConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid
    Write-Output 'R6_CONFIG_ACL_FIXTURE=PASS'

    $fileAcl = Get-Acl -LiteralPath $fixtureFile
    $fixtureRules = @($fileAcl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    $broadRule = [pscustomobject]@{ AccessControlType = [Security.AccessControl.AccessControlType]::Allow; IdentityReference = [pscustomobject]@{ Value = 'S-1-1-0' } }
    $fixtureRules += $broadRule
    $actualOwnerSid = $fileAcl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    Assert-Fixture (Test-ThrowsCode { Assert-BaiduConfigAclMetadata -ActualOwnerSid $actualOwnerSid -ExpectedOwnerSid $ownerSid -Rules $fixtureRules } 'BAIDU_AUTH_CONFIG_BROAD_ACCESS') 'BROAD_CONFIG_ACL_FIXTURE_ACCEPTED'
    Write-Output 'R6_CONFIG_ACL_FAIL_CLOSED=PASS'

    Assert-Fixture (Test-ThrowsCode { Assert-SafeBaiduConfigDirectory -ConfigDirectory $fixtureConfig -ProjectRoot $fixtureRoot -OwnerSid $ownerSid } 'BAIDU_CONFIG_INSIDE_REPOSITORY') 'CONFIG_INSIDE_REPOSITORY_FIXTURE_ACCEPTED'
    Write-Output 'R6_CONFIG_LOCATION_FAIL_CLOSED=PASS'
} finally {
    $fullFixture = [IO.Path]::GetFullPath($fixtureRoot)
    Assert-Fixture (([IO.Path]::GetDirectoryName($fullFixture) -ceq $tempRoot.TrimEnd('\')) -and ([IO.Path]::GetFileName($fullFixture) -match '^vpn-g4b-r6-fixture-[0-9a-f]{32}$')) 'FIXTURE_CLEANUP_SCOPE_INVALID'
    if (Test-Path -LiteralPath $fullFixture) { Remove-Item -LiteralPath $fullFixture -Recurse -Force -ErrorAction Stop }
    Assert-Fixture (-not (Test-Path -LiteralPath $fullFixture)) 'FIXTURE_CLEANUP_FAILED'
}
Write-Output 'R6_SYNTHETIC_FIXTURE_CLEANUP=PASS'

$safeMarkers = @('BAIDU_AUTH_READINESS=', 'BAIDU_FAILURE_CODE=', 'BAIDU_LOGIN_READY=', 'BAIDU_ACCOUNT_MATCH=', 'BAIDU_PROVIDER_MUTATION=NO', 'BAIDU_RAW_PROVIDER_OUTPUT_EMITTED=NO', 'BAIDU_UID_EMITTED=NO', 'BAIDU_TEMP_RUNTIME_CLEANUP=')
$outputLines = @($runnerText -split "`r?`n" | Where-Object { $_ -match '^\s*Write-Output\b' })
Assert-Fixture ($outputLines.Count -eq $safeMarkers.Count) 'OUTPUT_MARKER_COUNT_INVALID'
foreach ($marker in $safeMarkers) { Assert-Fixture (@($outputLines | Where-Object { $_.Contains($marker) }).Count -eq 1) ('OUTPUT_MARKER_MISSING_' + $marker.TrimEnd('=')) }
Assert-Fixture ($runnerText -notmatch '(?im)^\s*Write-(?:Output|Host|Error|Information|Warning|Verbose)\b.*(?:StdOut|StdErr|ExpectedBaiduUid|Groups\[1\])') 'UNSAFE_OUTPUT_EXPRESSION_FOUND'
Assert-Fixture (($runnerText + $validatorText) -notmatch '(?im)-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|(?:bduss|stoken|cookie|password|access[_-]?token)\s*[:=]\s*[A-Za-z0-9+/=_-]{20,}') 'SECRET_LITERAL_FOUND'
Write-Output 'POWERSHELL_AST_PARSE=PASS'
Write-Output 'SECRET_SCAN=PASS'
Write-Output 'LIVE_ACTIONS=0'
