[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-UidFixture {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Get-UidFunctionText {
    param([System.Management.Automation.Language.Ast]$Ast, [string]$Name)
    $node = $Ast.Find({ param($item) $item -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $item.Name -ceq $Name }, $true)
    Assert-UidFixture ($null -ne $node) ('FUNCTION_MISSING_' + $Name.ToUpperInvariant())
    return $node.Extent.Text
}

$helperPath = Join-Path $PSScriptRoot 'g4b-baidu-uid-discovery-checkpoint.ps1'
$acceptedCheckpointPath = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
$helperText = [IO.File]::ReadAllText($helperPath, [Text.Encoding]::UTF8)
$acceptedText = [IO.File]::ReadAllText($acceptedCheckpointPath, [Text.Encoding]::UTF8)
$validatorText = [IO.File]::ReadAllText($PSCommandPath, [Text.Encoding]::UTF8)
$helperTokens = $null
$helperParseErrors = $null
$helperAst = [System.Management.Automation.Language.Parser]::ParseFile($helperPath, [ref]$helperTokens, [ref]$helperParseErrors)
Assert-UidFixture ($helperParseErrors.Count -eq 0) 'UID_HELPER_AST_PARSE_FAILED'
$validatorTokens = $null
$validatorParseErrors = $null
$validatorAst = [System.Management.Automation.Language.Parser]::ParseFile($PSCommandPath, [ref]$validatorTokens, [ref]$validatorParseErrors)
Assert-UidFixture ($validatorParseErrors.Count -eq 0) 'UID_VALIDATOR_AST_PARSE_FAILED'

$helperParameters = @($helperAst.ParamBlock.Parameters)
Assert-UidFixture ($helperParameters.Count -eq 0 -and $helperText -notmatch '(?im)\$env:(?:BDUSS|STOKEN|COOKIE|PASSWORD|TOKEN|CREDENTIAL|SECRET)\b') 'UID_CREDENTIAL_INPUT_FOUND'
Write-Output 'UID_HELPER_NO_CREDENTIAL_PARAMETERS=PASS'

$acceptedTokens = $null
$acceptedParseErrors = $null
$acceptedAst = [System.Management.Automation.Language.Parser]::ParseFile($acceptedCheckpointPath, [ref]$acceptedTokens, [ref]$acceptedParseErrors)
Assert-UidFixture ($acceptedParseErrors.Count -eq 0) 'ACCEPTED_R6R1_CHECKPOINT_AST_FAILED'
$acceptedWhoStart = Get-UidFunctionText -Ast $acceptedAst -Name 'New-ReadOnlyWhoStartInfo'
$acceptedWhoInvoke = Get-UidFunctionText -Ast $acceptedAst -Name 'Invoke-ReadOnlyBaiduWho'
$acceptedArchive = Get-UidFunctionText -Ast $acceptedAst -Name 'Get-PinnedBaiduExecutableBytes'
$acceptedAcl = Get-UidFunctionText -Ast $acceptedAst -Name 'Assert-SafeBaiduConfigDirectory'
$acceptedAclPredicate = Get-UidFunctionText -Ast $acceptedAst -Name 'Assert-BaiduConfigAclMetadata'
$uidInvoke = Get-UidFunctionText -Ast $helperAst -Name 'Invoke-BaiduUidDiscoveryCheckpoint'
$expectedArchiveUrl = 'https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v4.0.2/BaiduPCS-Go-v4.0.2-windows-x64.zip'
$expectedArchiveHash = 'ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
$hashReadAt = $acceptedArchive.IndexOf('Get-FileHash -LiteralPath $Archive -Algorithm SHA256', [StringComparison]::Ordinal)
$hashCheckAt = $acceptedArchive.IndexOf('Assert-PinnedArchiveDigest -ActualSha256 $actualHash', [StringComparison]::Ordinal)
$zipOpenAt = $acceptedArchive.IndexOf('[IO.Compression.ZipFile]::OpenRead($Archive)', [StringComparison]::Ordinal)
Assert-UidFixture ($acceptedText.Contains("`$script:archiveUrl = '$expectedArchiveUrl'") -and $acceptedText.Contains("`$script:archiveSha256 = '$expectedArchiveHash'") -and $helperText.Contains('Get-PinnedBaiduExecutableBytes -Archive') -and $hashReadAt -ge 0 -and $hashCheckAt -gt $hashReadAt -and $zipOpenAt -gt $hashCheckAt) 'PINNED_ARCHIVE_TRUST_NOT_REUSED'
Write-Output 'UID_HELPER_PINNED_ARCHIVE_TRUST_REUSED=PASS'

Assert-UidFixture ($helperText.Contains('. $acceptedCheckpoint') -and $helperText.Contains('Assert-SafeBaiduConfigDirectory -ConfigDirectory') -and $uidInvoke.Contains('Resolve-SafeBaiduConfigPath') -and $acceptedAcl.Contains('ReparsePoint') -and $acceptedAcl.Contains('Assert-BaiduConfigAclMetadata') -and $acceptedAclPredicate.Contains('BAIDU_AUTH_CONFIG_OWNER_READ_RIGHTS_MISSING') -and $uidInvoke -notmatch '(?i)Get-Content|ReadAllText|ReadAllBytes|ReadAllLines|Copy-Item|Move-Item') 'R6R1_CONFIG_ACL_POLICY_NOT_REUSED'
Write-Output 'UID_HELPER_R6R1_CONFIG_ACL_POLICY_REUSED=PASS'

$whoArgumentAdds = [regex]::Matches($acceptedWhoStart, '\.ArgumentList\.Add\(''who''\)')
$helperWhoCalls = [regex]::Matches($helperText, '\bInvoke-ReadOnlyBaiduWho\s+-ExecutablePath')
Assert-UidFixture ($whoArgumentAdds.Count -eq 1 -and $acceptedWhoStart -notmatch '\.ArgumentList\.Add\((?!''who'')' -and $acceptedWhoStart.Contains('$psi.Environment.Clear()') -and $helperWhoCalls.Count -eq 1 -and $acceptedWhoInvoke.Contains('ReadToEndAsync') -and $acceptedWhoInvoke.Contains('StandardError')) 'UID_PROVIDER_ACTION_NOT_WHO_ONLY'
Assert-UidFixture ($helperText -notmatch '(?i)\.ArgumentList\.Add\(\s*''login''\s*\)|\b(?:Invoke-)?Baidu\w*\s+login\b') 'UID_LOGIN_COMMAND_PRESENT'
Write-Output 'UID_HELPER_NO_LOGIN_COMMAND=PASS'
Write-Output 'UID_HELPER_WHO_ONLY_PROVIDER_ACTION=PASS'

Assert-UidFixture ($acceptedText -match '(?m)^if \(\$MyInvocation\.InvocationName -ne ''\.''\) \{ Invoke-R6Checkpoint \}$' -and $helperText -match '(?m)^if \(\$MyInvocation\.InvocationName -ne ''\.''\) \{ Invoke-BaiduUidDiscoveryCheckpoint \}$') 'DOTSOURCE_ENTRYPOINT_GUARD_MISSING'
. $acceptedCheckpointPath
. $helperPath
function Get-AcceptedArchiveHashInFunctionScope {
    . $acceptedCheckpointPath
    return $script:archiveSha256
}
Assert-UidFixture ((Get-AcceptedArchiveHashInFunctionScope) -ceq $expectedArchiveHash) 'ACCEPTED_DOTSOURCE_SCOPE_FIXTURE_FAILED'
Write-Output 'UID_HELPER_ACCEPTED_SOURCE_SCOPE_FIXTURE=PASS'
$parseText = Get-UidFunctionText -Ast $helperAst -Name 'Resolve-BaiduUidDiscoveryOutcome'
Assert-UidFixture ($parseText.Contains("'(?m)^当前帐号 uid:\s*([0-9]+),'") -and $parseText.Contains('BAIDU_UID_OUTPUT_AMBIGUOUS') -and $parseText -notmatch 'Write-(?:Output|Host|Error)') 'UID_PARSER_CONTRACT_INVALID'
$rawMarker = 'UID_RAW_PROVIDER_FIXTURE_61A7_NONSECRET'
$usernameMarker = 'display-name-fixture-never-emit'
$uidFixture = '908172635'
$validOutcome = Resolve-BaiduUidDiscoveryOutcome -ExitCode 0 -StdOut ("provider fixture $rawMarker`n用户名: $usernameMarker`n当前帐号 uid: $uidFixture, fixture") -StdErr ''
$validOutcomeText = ConvertTo-Json -InputObject $validOutcome -Compress
Assert-UidFixture ($validOutcome.State -ceq 'READY' -and $validOutcome.Uid -ceq $uidFixture -and $validOutcome.Code -ceq 'NONE') 'UID_SINGLE_PARSE_FIXTURE_FAILED'
Assert-UidFixture (@($validOutcome.PSObject.Properties.Name | Sort-Object) -join ',' -ceq 'Code,State,Uid') 'UID_OUTCOME_EXPOSES_EXTRA_FIELDS'
Assert-UidFixture (-not $validOutcomeText.Contains($rawMarker) -and -not $validOutcomeText.Contains($usernameMarker)) 'UID_RAW_OUTPUT_OR_USERNAME_LEAKED'
Write-Output 'UID_HELPER_RAW_PROVIDER_OUTPUT_SUPPRESSED=PASS'
Assert-UidFixture ($helperText -notmatch '(?im)^\s*Write-Output\b.*(?:StdOut|StdErr|username|用户名)') 'UID_USERNAME_OUTPUT_EXPRESSION_FOUND'
Write-Output 'UID_HELPER_USERNAME_NOT_EMITTED=PASS'
Write-Output 'UID_HELPER_SINGLE_UID_PARSE=PASS'

$unauthOutcome = Resolve-BaiduUidDiscoveryOutcome -ExitCode 1 -StdOut 'not authenticated fixture' -StdErr ''
Assert-UidFixture ($unauthOutcome.State -ceq 'OWNER_ACTION_REQUIRED' -and $unauthOutcome.Code -ceq 'RETURN_OWNER_ACTION_REQUIRED' -and $null -eq $unauthOutcome.Uid) 'UID_UNAUTHENTICATED_FIXTURE_INVALID'
Write-Output 'UID_HELPER_UNAUTHENTICATED_OWNER_ACTION_REQUIRED=PASS'

$duplicateOutcome = Resolve-BaiduUidDiscoveryOutcome -ExitCode 0 -StdOut "当前帐号 uid: 908172635, first`n当前帐号 uid: 908172636, second" -StdErr ''
$secondaryMentionOutcome = Resolve-BaiduUidDiscoveryOutcome -ExitCode 0 -StdOut '当前帐号 uid: 908172635, first; second uid: 908172636' -StdErr ''
Assert-UidFixture ($duplicateOutcome.State -ceq 'FAIL_CLOSED' -and $duplicateOutcome.Code -ceq 'BAIDU_UID_OUTPUT_AMBIGUOUS' -and $secondaryMentionOutcome.State -ceq 'FAIL_CLOSED' -and $secondaryMentionOutcome.Code -ceq 'BAIDU_UID_OUTPUT_AMBIGUOUS') 'UID_AMBIGUOUS_FIXTURE_ACCEPTED'
Write-Output 'UID_HELPER_AMBIGUOUS_OUTPUT_FAIL_CLOSED=PASS'

$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$fixtureRoot = Join-Path $tempRoot ('vpn-g4b-uid-fixture-' + [Guid]::NewGuid().ToString('N'))
$fixtureProject = Join-Path $fixtureRoot 'repo'
$fixtureConfig = Join-Path $fixtureRoot 'config'
$fixtureConfigFile = Join-Path $fixtureConfig 'config.fixture'
$fixtureRuntime = Join-Path $fixtureRoot ('vpn-network-optimization-baidu-uid-' + [Guid]::NewGuid().ToString('N'))
$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
try {
    [void][IO.Directory]::CreateDirectory($fixtureRoot)
    [void][IO.Directory]::CreateDirectory($fixtureProject)
    [void][IO.Directory]::CreateDirectory($fixtureConfig)
    Set-OwnerOnlyAcl -Path $fixtureConfig -OwnerSid $ownerSid -Directory
    [IO.File]::WriteAllText($fixtureConfigFile, 'NON_SECRET_UID_HELPER_CONFIG_FIXTURE')
    Set-OwnerOnlyAcl -Path $fixtureConfigFile -OwnerSid $ownerSid
    Assert-SafeBaiduConfigDirectory -ConfigDirectory $fixtureConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid
    Write-Output 'UID_HELPER_R6R1_CONFIG_ACL_POLICY_FIXTURE=PASS'

    [void][IO.Directory]::CreateDirectory($fixtureRuntime)
    [IO.File]::WriteAllText((Join-Path $fixtureRuntime 'BaiduPCS-Go.exe'), 'NON_SECRET_RUNTIME_CLEANUP_FIXTURE')
    Remove-BaiduUidRuntime -RuntimeDirectory $fixtureRuntime -AllowedParent $fixtureRoot
    Assert-UidFixture (-not (Test-Path -LiteralPath $fixtureRuntime)) 'UID_RUNTIME_CLEANUP_FIXTURE_FAILED'
} finally {
    $fullFixtureRoot = [IO.Path]::GetFullPath($fixtureRoot)
    Assert-UidFixture (([IO.Path]::GetDirectoryName($fullFixtureRoot) -ceq $tempRoot.TrimEnd('\')) -and ([IO.Path]::GetFileName($fullFixtureRoot) -match '^vpn-g4b-uid-fixture-[0-9a-f]{32}$')) 'UID_FIXTURE_CLEANUP_SCOPE_INVALID'
    if (Test-Path -LiteralPath $fullFixtureRoot) { Remove-Item -LiteralPath $fullFixtureRoot -Recurse -Force -ErrorAction Stop }
    Assert-UidFixture (-not (Test-Path -LiteralPath $fullFixtureRoot)) 'UID_FIXTURE_CLEANUP_FAILED'
}

$outputLines = @($helperText -split "`r?`n" | Where-Object { $_ -match '^\s*Write-Output\b' })
Assert-UidFixture (@($outputLines | Where-Object { $_ -match 'BAIDU_OWNER_LOCAL_UID=' }).Count -eq 1 -and $helperText -notmatch '(?i)Write-(?:Output|Host|Error).*?(?:StdOut|StdErr|用户名|cookie|bduss|stoken)') 'UID_OUTPUT_BOUNDARY_INVALID'
Assert-UidFixture ($helperText -notmatch 'Remove-Item[^\r\n]*-Recurse' -and $helperText.Contains('BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=YES') -and $helperText.Contains('OWNER_REMINDER=')) 'UID_CLEANUP_OR_OWNER_REMINDER_INVALID'
$secretPattern = '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|(?i)(?:bduss|stoken|cookie|password|access[_-]?token)\s*[:=]\s*[A-Za-z0-9+/=_-]{24,}'
Assert-UidFixture (($helperText + $validatorText) -notmatch $secretPattern) 'UID_HELPER_SECRET_LITERAL_FOUND'
Write-Output 'UID_HELPER_TEMP_CLEANUP=PASS'
Write-Output 'POWERSHELL_AST_PARSE=PASS'
Write-Output 'SECRET_SCAN=PASS'
Write-Output 'REAL_BAIDU_ACTIONS=0'
Write-Output 'OWNER_CONFIG_READ=NO'
Write-Output 'NETWORK_REQUESTS=0'
Write-Output 'LIVE_G4B_ACTIONS=0'
