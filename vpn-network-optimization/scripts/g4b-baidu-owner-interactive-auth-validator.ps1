[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-R6R2CFixture {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Get-R6R2CFunctionText {
    param([System.Management.Automation.Language.Ast]$Ast, [string]$Name)
    $node = $Ast.Find({ param($item) $item -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $item.Name -ceq $Name }, $true)
    Assert-R6R2CFixture ($null -ne $node) ('FUNCTION_MISSING_' + $Name.ToUpperInvariant())
    return $node.Extent.Text
}

function Test-R6R2CThrowsCode {
    param([scriptblock]$Action, [string]$ExpectedCode)
    try { $null = & $Action } catch { return [bool]([string]$_.Exception.Message -ceq $ExpectedCode) }
    return $false
}

$helperPath = Join-Path $PSScriptRoot 'g4b-baidu-owner-interactive-auth-checkpoint.ps1'
$runnerPath = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
$uidHelperPath = Join-Path $PSScriptRoot 'g4b-baidu-uid-discovery-checkpoint.ps1'
$helperText = [IO.File]::ReadAllText($helperPath, [Text.Encoding]::UTF8)
$runnerText = [IO.File]::ReadAllText($runnerPath, [Text.Encoding]::UTF8)
$uidHelperText = [IO.File]::ReadAllText($uidHelperPath, [Text.Encoding]::UTF8)
$validatorText = [IO.File]::ReadAllText($PSCommandPath, [Text.Encoding]::UTF8)

$helperTokens = $null
$helperErrors = $null
$helperAst = [System.Management.Automation.Language.Parser]::ParseFile($helperPath, [ref]$helperTokens, [ref]$helperErrors)
Assert-R6R2CFixture ($helperErrors.Count -eq 0) 'INTERACTIVE_HELPER_AST_FAILED'
$validatorTokens = $null
$validatorErrors = $null
$validatorAst = [System.Management.Automation.Language.Parser]::ParseFile($PSCommandPath, [ref]$validatorTokens, [ref]$validatorErrors)
Assert-R6R2CFixture ($validatorErrors.Count -eq 0) 'INTERACTIVE_VALIDATOR_AST_FAILED'
$runnerTokens = $null
$runnerErrors = $null
$runnerAst = [System.Management.Automation.Language.Parser]::ParseFile($runnerPath, [ref]$runnerTokens, [ref]$runnerErrors)
Assert-R6R2CFixture ($runnerErrors.Count -eq 0) 'ACCEPTED_R6R1_AST_FAILED'
$uidTokens = $null
$uidErrors = $null
$uidAst = [System.Management.Automation.Language.Parser]::ParseFile($uidHelperPath, [ref]$uidTokens, [ref]$uidErrors)
Assert-R6R2CFixture ($uidErrors.Count -eq 0) 'ACCEPTED_R6R2A_AST_FAILED'

Assert-R6R2CFixture ($runnerText.Contains('if ($MyInvocation.InvocationName -ne ''.'') { Invoke-R6Checkpoint }') -and $uidHelperText.Contains('if ($MyInvocation.InvocationName -ne ''.'') { Invoke-BaiduUidDiscoveryCheckpoint }') -and $helperText.Contains('if ($MyInvocation.InvocationName -ne ''.'') { Invoke-BaiduOwnerInteractiveAuthCheckpoint }')) 'SOURCE_ONLY_ENTRY_GUARD_MISSING'
. $runnerPath
. $uidHelperPath
. $helperPath

$helperParameters = @($helperAst.ParamBlock.Parameters)
Assert-R6R2CFixture ($helperParameters.Count -eq 0) 'HELPER_ARGUMENTS_NOT_EMPTY'
$helperMain = Get-R6R2CFunctionText -Ast $helperAst -Name 'Invoke-BaiduOwnerInteractiveAuthCheckpoint'
$loginStart = Get-R6R2CFunctionText -Ast $helperAst -Name 'New-BaiduInteractiveLoginStartInfo'
$loginInvoke = Get-R6R2CFunctionText -Ast $helperAst -Name 'Invoke-BaiduInteractiveLogin'
$configInit = Get-R6R2CFunctionText -Ast $helperAst -Name 'Initialize-BaiduInteractiveConfigDirectory'
$runtimeCleanup = Get-R6R2CFunctionText -Ast $helperAst -Name 'Remove-BaiduInteractiveRuntime'
$configRollback = Get-R6R2CFunctionText -Ast $helperAst -Name 'Remove-NewEmptyBaiduConfigDirectory'
$readyPredicate = Get-R6R2CFunctionText -Ast $helperAst -Name 'Test-BaiduInteractiveAuthReady'
$whoStart = Get-R6R2CFunctionText -Ast $runnerAst -Name 'New-ReadOnlyWhoStartInfo'
$whoInvoke = Get-R6R2CFunctionText -Ast $runnerAst -Name 'Invoke-ReadOnlyBaiduWho'
$archiveExtract = Get-R6R2CFunctionText -Ast $runnerAst -Name 'Get-PinnedBaiduExecutableBytes'
$uidParser = Get-R6R2CFunctionText -Ast $uidAst -Name 'Resolve-BaiduUidDiscoveryOutcome'

$expectedUrl = 'https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v4.0.2/BaiduPCS-Go-v4.0.2-windows-x64.zip'
$expectedHash = 'ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
$urlAssignment = [string][char]36 + 'script:archiveUrl = ''' + $expectedUrl + ''''
$hashAssignment = [string][char]36 + 'script:archiveSha256 = ''' + $expectedHash + ''''
Assert-R6R2CFixture ($runnerText.Contains($urlAssignment) -and $runnerText.Contains($hashAssignment) -and $helperMain.Contains('Invoke-WebRequest -Uri $script:archiveUrl') -and $helperMain.Contains('Get-PinnedBaiduExecutableBytes -Archive $script:interactiveAuthArchive') -and $archiveExtract.IndexOf('Assert-PinnedArchiveDigest') -gt $archiveExtract.IndexOf('Get-FileHash') -and $archiveExtract.IndexOf('[IO.Compression.ZipFile]::OpenRead') -gt $archiveExtract.IndexOf('Assert-PinnedArchiveDigest')) 'PINNED_ARCHIVE_TRUST_NOT_REUSED'
Write-Output 'R6R2C_PINNED_ARCHIVE_TRUST_REUSED=PASS'

Assert-R6R2CFixture ($helperParameters.Count -eq 0 -and $helperText -notmatch '(?i)\$env:(?:BDUSS|STOKEN|COOKIE|PASSWORD|TOKEN|CREDENTIAL|SECRET)\b') 'CREDENTIAL_INPUT_SURFACE_FOUND'
Assert-R6R2CFixture ([regex]::Matches($loginStart, "\.ArgumentList\.Add\('login'\)").Count -eq 1 -and [regex]::Matches($loginStart, '\.ArgumentList\.Add\(').Count -eq 1 -and $loginStart -notmatch '(?i)username|password|cookie|bduss|stoken|ptoken') 'LOGIN_ARGUMENT_SET_INVALID'
Write-Output 'R6R2C_LOGIN_NO_CREDENTIAL_FLAGS=PASS'

$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$whoUidFixture = '913740286'
$whoReadyFixture = Resolve-BaiduUidDiscoveryOutcome -ExitCode 0 -StdOut ('synthetic provider text' + [Environment]::NewLine + '当前帐号 uid: ' + $whoUidFixture + ', fixture') -StdErr ''
$whoUnauthFixture = Resolve-BaiduUidDiscoveryOutcome -ExitCode 1 -StdOut 'synthetic unauthenticated fixture' -StdErr ''
$whoAmbiguousFixture = Resolve-BaiduUidDiscoveryOutcome -ExitCode 0 -StdOut ('当前帐号 uid: ' + $whoUidFixture + ', first' + [Environment]::NewLine + '当前帐号 uid: 913740287, second') -StdErr ''
Assert-R6R2CFixture ($whoReadyFixture.State -ceq 'READY' -and $whoReadyFixture.Uid -ceq $whoUidFixture -and $whoUnauthFixture.State -ceq 'OWNER_ACTION_REQUIRED' -and $whoAmbiguousFixture.State -ceq 'FAIL_CLOSED') 'ACCEPTED_WHO_OUTCOME_FIXTURES_FAILED'
$whoReadyFixture.Uid = $null
$whoReadyFixture = $null
$whoUnauthFixture = $null
$whoAmbiguousFixture = $null
Write-Output 'R6R2C_WHO_SYNTHETIC_OUTCOME_FIXTURES=PASS'
$loginInfo = New-BaiduInteractiveLoginStartInfo -ExecutablePath (Join-Path ([IO.Path]::GetTempPath()) 'fixture.exe') -ConfigDirectory (Join-Path ([IO.Path]::GetTempPath()) 'BaiduPCS-Go')
$envNames = @($loginInfo.Environment.Keys | ForEach-Object { [string]$_ })
$allowedEnvNames = @('SystemRoot', 'WINDIR', 'PATH', 'BAIDUPCS_GO_CONFIG_DIR', 'BAIDUPCS_GO_VERBOSE')
Assert-R6R2CFixture (@($envNames | Where-Object { $_ -notin $allowedEnvNames }).Count -eq 0 -and @($envNames | Where-Object { $_ -match '(?i)user|pass|cookie|bduss|stoken|ptoken|token|credential|secret' }).Count -eq 0) 'LOGIN_ENVIRONMENT_NOT_ALLOWLISTED'
Assert-R6R2CFixture ($loginStart.Contains('$psi.Environment.Clear()') -and $loginInfo.Environment['BAIDUPCS_GO_VERBOSE'] -ceq '0') 'LOGIN_ENVIRONMENT_CLEAR_OR_VERBOSE_INVALID'
Write-Output 'R6R2C_LOGIN_NO_CREDENTIAL_ENV=PASS'

Assert-R6R2CFixture (-not $loginInfo.UseShellExecute -and -not $loginInfo.CreateNoWindow -and -not $loginInfo.RedirectStandardInput -and -not $loginInfo.RedirectStandardOutput -and -not $loginInfo.RedirectStandardError -and $loginInfo.ArgumentList.Count -eq 1 -and $loginInfo.ArgumentList[0] -ceq 'login') 'INTERACTIVE_CONSOLE_INHERITANCE_INVALID'
Write-Output 'R6R2C_LOGIN_INTERACTIVE_CONSOLE_INHERITED=PASS'

Assert-R6R2CFixture ($loginInvoke.Contains('$process.Start()') -and $loginInvoke.Contains('$process.WaitForExit(600000)') -and $loginInvoke -notmatch 'StandardInput|StandardOutput|StandardError|RedirectStandard|Start-Transcript|Tee-Object|Out-File|Set-Content|Write-(?:Output|Host|Error|Information|Warning|Verbose)') 'LOGIN_OUTPUT_CAPTURE_OR_LOGGING_FOUND'
Assert-R6R2CFixture ($helperText -notmatch '(?i)Start-Transcript|Tee-Object|RedirectStandard(?:Input|Output|Error)\s*=\s*\$true|BAIDU_AUTH_DEBUG\s*=\s*[''"](?:1|true|yes)' -and $helperText.Contains(([string][char]36 + "psi.Environment['BAIDUPCS_GO_VERBOSE'] = '0'"))) 'LOGIN_CAPTURE_OR_VERBOSE_DEBUG_ENABLED'
Write-Output 'R6R2C_LOGIN_OUTPUT_NOT_CAPTURED_OR_LOGGED=PASS'
Write-Output 'R6R2C_VERBOSE_DEBUG_DISABLED=PASS'

Assert-R6R2CFixture ($configInit.Contains('Resolve-SafeBaiduConfigPath') -and $configInit.Contains('Set-OwnerOnlyAcl -Path $configFull') -and $configInit.Contains('Assert-OwnerOnlyAcl -Path $configFull') -and $configInit.Contains('Assert-SafeBaiduConfigDirectory') -and $configInit.Contains('Test-DirectoryHasEntry') -and $configInit.IndexOf('Resolve-InteractiveConfigState') -lt $configInit.IndexOf('Set-OwnerOnlyAcl')) 'R6R1_CONFIG_ACL_POLICY_NOT_REUSED_OR_APPLIED_TOO_EARLY'
Assert-R6R2CFixture ($helperMain.Contains('. $acceptedCheckpoint') -and $helperMain.Contains('. $acceptedUidHelper') -and $configInit.Contains('Resolve-SafeBaiduConfigPath') -and $configInit.Contains('Assert-SafeBaiduConfigDirectory')) 'R6R1_SOURCE_OR_PREDICATE_NOT_REUSED'
Write-Output 'R6R2C_R6R1_ACL_POLICY_REUSED=PASS'

$unknown = Resolve-InteractiveConfigState -Exists $true -IsDirectory $true -IsReparsePoint $false -EntryCount 1
$absent = Resolve-InteractiveConfigState -Exists $false -IsDirectory $false -IsReparsePoint $false -EntryCount 0
$empty = Resolve-InteractiveConfigState -Exists $true -IsDirectory $true -IsReparsePoint $false -EntryCount 0
Assert-R6R2CFixture ($unknown.State -ceq 'UNKNOWN_NONEMPTY' -and $unknown.Code -ceq 'BAIDU_AUTH_CONFIG_UNKNOWN_NONEMPTY') 'UNKNOWN_NONEMPTY_CONFIG_NOT_REJECTED'
Assert-R6R2CFixture ($absent.State -ceq 'ABSENT_INITIALIZABLE' -and $empty.State -ceq 'EMPTY_INITIALIZABLE') 'EMPTY_CONFIG_STATES_NOT_INITIALIZABLE'
Assert-R6R2CFixture ((Resolve-InteractiveConfigState -Exists $true -IsDirectory $true -IsReparsePoint $true -EntryCount 0).State -ceq 'FAIL_CLOSED' -and (Resolve-InteractiveConfigState -Exists $true -IsDirectory $false -IsReparsePoint $false -EntryCount 0).State -ceq 'FAIL_CLOSED') 'CONFIG_SHAPE_NOT_FAIL_CLOSED'
Write-Output 'R6R2C_EXISTING_UNKNOWN_CONFIG_FAIL_CLOSED=PASS'

$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('vpn-g4b-r6r2c-fixture-' + [Guid]::NewGuid().ToString('N'))
$fixtureProject = Join-Path $fixtureRoot 'project'
$fixtureAppData = Join-Path $fixtureRoot 'appdata'
$newConfig = Join-Path $fixtureAppData 'BaiduPCS-Go'
$emptyConfig = Join-Path $fixtureRoot 'existing-empty\BaiduPCS-Go'
$unknownConfig = Join-Path $fixtureRoot 'existing-unknown\BaiduPCS-Go'
$partialConfig = Join-Path $fixtureRoot 'new-partial\BaiduPCS-Go'
$fixtureMarkerPath = Join-Path $unknownConfig 'non-secret.fixture'
$partialMarkerPath = Join-Path $partialConfig 'non-secret-partial.fixture'
$parentSddlBefore = $null
try {
    [void][IO.Directory]::CreateDirectory($fixtureRoot)
    [void][IO.Directory]::CreateDirectory($fixtureProject)
    [void][IO.Directory]::CreateDirectory($fixtureAppData)
    [void][IO.Directory]::CreateDirectory((Split-Path -Parent $emptyConfig))
    [void][IO.Directory]::CreateDirectory($emptyConfig)
    [void][IO.Directory]::CreateDirectory((Split-Path -Parent $unknownConfig))
    [void][IO.Directory]::CreateDirectory($unknownConfig)
    [IO.File]::WriteAllText($fixtureMarkerPath, 'NON_SECRET_UNKNOWN_CONFIG_FIXTURE')

    $parentSddlBefore = (Get-Acl -LiteralPath $fixtureAppData).Sddl
    $script:interactiveAuthConfigCreated = $false
    $newResult = Initialize-BaiduInteractiveConfigDirectory -ConfigDirectory $newConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid
    Assert-R6R2CFixture ($newResult.State -ceq 'NEW_INITIALIZED' -and $newResult.CreatedThisRun -and (Test-Path -LiteralPath $newConfig -PathType Container)) 'ABSENT_CONFIG_INITIALIZATION_FIXTURE_FAILED'
    Assert-OwnerOnlyAcl -Path $newConfig -OwnerSid $ownerSid
    Assert-SafeBaiduConfigDirectory -ConfigDirectory $newConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid
    $newCleanup = Remove-NewEmptyBaiduConfigDirectory -ConfigDirectory $newConfig -OwnerSid $ownerSid
    $script:interactiveAuthConfigCreated = $false
    Assert-R6R2CFixture ($newCleanup -ceq 'REMOVED_EMPTY_NEW' -and -not (Test-Path -LiteralPath $newConfig)) 'NEW_EMPTY_CONFIG_ROLLBACK_FIXTURE_FAILED'

    $emptyResult = Initialize-BaiduInteractiveConfigDirectory -ConfigDirectory $emptyConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid
    Assert-R6R2CFixture ($emptyResult.State -ceq 'EXISTING_EMPTY_INITIALIZED' -and -not $emptyResult.CreatedThisRun) 'EXISTING_EMPTY_CONFIG_FIXTURE_FAILED'
    Assert-OwnerOnlyAcl -Path $emptyConfig -OwnerSid $ownerSid
    Assert-SafeBaiduConfigDirectory -ConfigDirectory $emptyConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid
    Assert-R6R2CFixture ((Test-Path -LiteralPath $emptyConfig -PathType Container) -and (@(Get-ChildItem -LiteralPath $emptyConfig -Force).Count -eq 0)) 'PREEXISTING_CONFIG_WAS_REMOVED_OR_CHANGED'
    Assert-R6R2CFixture ((Get-Acl -LiteralPath $fixtureAppData).Sddl -ceq $parentSddlBefore) 'UNRELATED_APPDATA_PARENT_ACL_CHANGED'
    [void][IO.Directory]::CreateDirectory((Split-Path -Parent $partialConfig))
    $partialResult = Initialize-BaiduInteractiveConfigDirectory -ConfigDirectory $partialConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid
    Assert-R6R2CFixture ($partialResult.CreatedThisRun) 'PARTIAL_CONFIG_FIXTURE_NOT_NEW'
    [IO.File]::WriteAllText($partialMarkerPath, 'NON_SECRET_PARTIAL_CONFIG_FIXTURE')
    $partialDisposition = Remove-NewEmptyBaiduConfigDirectory -ConfigDirectory $partialConfig -OwnerSid $ownerSid
    Assert-R6R2CFixture ($partialDisposition -ceq 'PRESERVED_NONEMPTY' -and (Test-Path -LiteralPath $partialMarkerPath -PathType Leaf)) 'PARTIAL_CONFIG_DATA_WAS_DELETED'
    $script:interactiveAuthConfigCreated = $false
    Write-Output 'R6R2C_EMPTY_CONFIG_INITIALIZATION_BOUNDED=PASS'

    $unknownAclBefore = (Get-Acl -LiteralPath $unknownConfig).Sddl
    $unknownRejected = Test-R6R2CThrowsCode { Initialize-BaiduInteractiveConfigDirectory -ConfigDirectory $unknownConfig -ProjectRoot $fixtureProject -OwnerSid $ownerSid } 'BAIDU_AUTH_CONFIG_UNKNOWN_NONEMPTY'
    Assert-R6R2CFixture ($unknownRejected -and (Test-Path -LiteralPath $fixtureMarkerPath -PathType Leaf) -and (Get-Acl -LiteralPath $unknownConfig).Sddl -ceq $unknownAclBefore) 'UNKNOWN_NONEMPTY_CONFIG_MUTATED_OR_ACCEPTED'
} finally {
    $fixtureFull = [IO.Path]::GetFullPath($fixtureRoot)
    $tempFull = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\')
    Assert-R6R2CFixture (([IO.Path]::GetDirectoryName($fixtureFull) -ieq $tempFull) -and ([IO.Path]::GetFileName($fixtureFull) -match '^vpn-g4b-r6r2c-fixture-[0-9a-f]{32}$')) 'FIXTURE_CLEANUP_SCOPE_INVALID'
    if (Test-Path -LiteralPath $fixtureFull) { Remove-Item -LiteralPath $fixtureFull -Recurse -Force -ErrorAction Stop }
    Assert-R6R2CFixture (-not (Test-Path -LiteralPath $fixtureFull)) 'CONFIG_FIXTURE_CLEANUP_FAILED'
}
Write-Output 'R6R2C_CONFIG_STATE_FIXTURES=PASS'

$runtimeParent = Join-Path ([IO.Path]::GetTempPath()) ('vpn-g4b-r6r2c-runtime-' + [Guid]::NewGuid().ToString('N'))
$runtimeFixture = Join-Path $runtimeParent ('vpn-network-optimization-baidu-interactive-auth-' + [Guid]::NewGuid().ToString('N'))
$runtimeUnknown = Join-Path $runtimeParent ('vpn-network-optimization-baidu-interactive-auth-' + [Guid]::NewGuid().ToString('N'))
try {
    [void][IO.Directory]::CreateDirectory($runtimeParent)
    [void][IO.Directory]::CreateDirectory($runtimeFixture)
    Set-OwnerOnlyAcl -Path $runtimeFixture -OwnerSid $ownerSid -Directory
    foreach ($name in @('BaiduPCS-Go-v4.0.2-windows-x64.zip', 'BaiduPCS-Go.exe')) {
        $path = Join-Path $runtimeFixture $name
        [IO.File]::WriteAllText($path, 'NON_SECRET_RUNTIME_FIXTURE')
        Set-OwnerOnlyAcl -Path $path -OwnerSid $ownerSid
    }
    Remove-BaiduInteractiveRuntime -RuntimeDirectory $runtimeFixture -AllowedParent $runtimeParent -OwnerSid $ownerSid
    Assert-R6R2CFixture (-not (Test-Path -LiteralPath $runtimeFixture)) 'RUNTIME_CLEANUP_FIXTURE_FAILED'
    [void][IO.Directory]::CreateDirectory($runtimeUnknown)
    Set-OwnerOnlyAcl -Path $runtimeUnknown -OwnerSid $ownerSid -Directory
    $unknownRuntimeFile = Join-Path $runtimeUnknown 'unexpected.fixture'
    [IO.File]::WriteAllText($unknownRuntimeFile, 'NON_SECRET_UNKNOWN_RUNTIME_FIXTURE')
    Set-OwnerOnlyAcl -Path $unknownRuntimeFile -OwnerSid $ownerSid
    $unknownRuntimeRejected = Test-R6R2CThrowsCode { Remove-BaiduInteractiveRuntime -RuntimeDirectory $runtimeUnknown -AllowedParent $runtimeParent -OwnerSid $ownerSid } 'BAIDU_AUTH_RUNTIME_CLEANUP_CONTENT_INVALID'
    Assert-R6R2CFixture ($unknownRuntimeRejected -and (Test-Path -LiteralPath $unknownRuntimeFile -PathType Leaf)) 'UNKNOWN_RUNTIME_CONTENT_WAS_DELETED'
} finally {
    if (Test-Path -LiteralPath $runtimeParent) { Remove-Item -LiteralPath $runtimeParent -Recurse -Force -ErrorAction Stop }
}
Write-Output 'R6R2C_TEMP_CLEANUP=PASS'

$loginOrder = $helperMain.IndexOf('Invoke-BaiduInteractiveLogin -ExecutablePath', [StringComparison]::Ordinal)
$exitCheck = $helperMain.IndexOf('$script:interactiveAuthLoginExitCode -eq 0', [StringComparison]::Ordinal)
$postLoginAcl = $helperMain.IndexOf('Assert-SafeBaiduConfigDirectory -ConfigDirectory $configInfo.Path', [StringComparison]::Ordinal)
$loginFailureGate = $helperMain.IndexOf('if (-not $loginSucceeded)', [StringComparison]::Ordinal)
$whoCall = $helperMain.IndexOf('Invoke-ReadOnlyBaiduWho -ExecutablePath', [StringComparison]::Ordinal)
Assert-R6R2CFixture ($loginOrder -ge 0 -and $exitCheck -gt $loginOrder -and $postLoginAcl -gt $exitCheck -and $loginFailureGate -gt $postLoginAcl -and $whoCall -gt $loginFailureGate -and [regex]::Matches($helperMain, 'Invoke-ReadOnlyBaiduWho\s+-ExecutablePath').Count -eq 1 -and [regex]::Matches($whoStart, "\.ArgumentList\.Add\('who'\)").Count -eq 1) 'POST_LOGIN_WHO_ORDER_OR_COUNT_INVALID'
Assert-R6R2CFixture ($loginInvoke.Contains('$process.ExitCode') -and $loginInvoke.Contains('WaitForExit(600000)')) 'NATIVE_LOGIN_EXIT_NOT_CHECKED'
Write-Output 'R6R2C_NATIVE_LOGIN_EXIT_CHECKED=PASS'
Write-Output 'R6R2C_POST_LOGIN_WHO_ONLY=PASS'

Assert-R6R2CFixture ($helperMain.Contains('$env:APPDATA') -and $helperMain.Contains("'BaiduPCS-Go'") -and $configInit.Contains('Resolve-SafeBaiduConfigPath')) 'CONFIG_LOCATION_CONTRACT_INVALID'
Assert-R6R2CFixture ($helperText -notmatch '(?i)Get-Content|ReadAllText|ReadAllBytes|ReadAllLines' -and $configInit -notmatch '(?i)Get-Content|ReadAllText|ReadAllBytes|ReadAllLines|Copy-Item|Move-Item') 'CONFIG_CONTENT_ACCESS_FOUND'
Assert-R6R2CFixture ($helperText -match "Write-Output 'BAIDU_UID_EMITTED=NO'" -and $helperText -notmatch '(?im)^\s*Write-Output\b[^\r\n]*(?:interactiveAuthUid|whoOutcome\.Uid|\.Uid\b)') 'UID_OUTPUT_PATH_FOUND'
Assert-R6R2CFixture ($uidParser.Contains("'(?m)^当前帐号 uid:\s*([0-9]+),'") -and $readyPredicate.Contains('$Uid -match ''^[1-9][0-9]{0,19}$''')) 'UNIQUE_NUMERIC_UID_VALIDATION_MISSING'
Write-Output 'R6R2C_UID_NOT_EMITTED=PASS'

$readyFixture = Test-BaiduInteractiveAuthReady -LoginExitCode 0 -ConfigSafe $true -WhoState 'READY' -Uid '913740286' -RuntimeCleanup 'PASS'
$negativeReadiness = @(
    (Test-BaiduInteractiveAuthReady -LoginExitCode 1 -ConfigSafe $true -WhoState 'READY' -Uid '913740286' -RuntimeCleanup 'PASS'),
    (Test-BaiduInteractiveAuthReady -LoginExitCode 0 -ConfigSafe $false -WhoState 'READY' -Uid '913740286' -RuntimeCleanup 'PASS'),
    (Test-BaiduInteractiveAuthReady -LoginExitCode 0 -ConfigSafe $true -WhoState 'FAIL_CLOSED' -Uid '913740286' -RuntimeCleanup 'PASS'),
    (Test-BaiduInteractiveAuthReady -LoginExitCode 0 -ConfigSafe $true -WhoState 'READY' -Uid 'ambiguous' -RuntimeCleanup 'PASS'),
    (Test-BaiduInteractiveAuthReady -LoginExitCode 0 -ConfigSafe $true -WhoState 'READY' -Uid '913740286' -RuntimeCleanup 'FAIL')
)
Assert-R6R2CFixture ($readyFixture -and @($negativeReadiness | Where-Object { $_ }).Count -eq 0) 'PARTIAL_FAILURE_FALSE_PASS'
Assert-R6R2CFixture ($helperMain.Contains('if ($script:interactiveAuthConfigCreated -and -not $candidateReady)') -and $configRollback.Contains('Test-DirectoryHasEntry') -and $configRollback.Contains('PRESERVED_NONEMPTY') -and $configRollback.Contains('[IO.Directory]::Delete($ConfigDirectory, $false)') -and $helperText -notmatch 'Remove-Item[^\r\n]*-Recurse') 'PARTIAL_CONFIG_ROLLBACK_BOUNDARY_INVALID'
Assert-R6R2CFixture ($helperMain.Contains('-RuntimeCleanup $script:interactiveAuthRuntimeCleanup') -and $helperMain.Contains('Test-BaiduInteractiveAuthReady')) 'SUCCESS_NOT_GATED_ON_CLEANUP'
Write-Output 'R6R2C_PARTIAL_FAILURE_NO_FALSE_PASS=PASS'

$helperOutputs = @($helperText -split '\r?\n' | Where-Object { $_ -match '^\s*Write-Output\b' })
Assert-R6R2CFixture ($helperOutputs.Count -eq 9 -and $helperText -notmatch '(?i)Start-Transcript|Tee-Object|Write-(?:Output|Host|Error|Information|Warning|Verbose)\s+.*(?:StdOut|StdErr|interactiveAuthUid|whoOutcome\.Uid|username|用户名)') 'BOUNDED_OUTPUT_CONTRACT_INVALID'
$secretPattern = '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|(?i)(?:bduss|stoken|cookie|password|access[_-]?token)\s*[:=]\s*[A-Za-z0-9+/=_-]{20,}'
Assert-R6R2CFixture (($helperText + $validatorText) -notmatch $secretPattern) 'SECRET_LITERAL_FOUND'
Assert-R6R2CFixture (@($helperOutputs | Where-Object { $_ -match '(?i)(?:StdOut|StdErr|\$(?:script:)?\w*(?:Uid|Who))' }).Count -eq 0 -and $helperText.Contains('BAIDU_WHO_RAW_OUTPUT_EMITTED=NO')) 'RAW_OUTPUT_OR_UID_EMISSION_FOUND'
Write-Output 'POWERSHELL_AST_PARSE=PASS'
Write-Output 'SECRET_SCAN=PASS'
Write-Output 'REAL_LOGIN_ACTIONS=0'
Write-Output 'REAL_BAIDU_ACTIONS=0'
Write-Output 'OWNER_CONFIG_READ=NO'
Write-Output 'NETWORK_REQUESTS=0'
Write-Output 'VPS_OR_SSH_ACTIONS=0'
Write-Output 'LIVE_G4B_ACTIONS=0'
