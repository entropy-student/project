[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-R6R2E {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-R6R2EThrows {
    param([scriptblock]$Action)
    try { $null = & $Action } catch { return $true }
    return $false
}

function New-R6R2ERule {
    param(
        [string]$Sid,
        [Security.AccessControl.AccessControlType]$Type = [Security.AccessControl.AccessControlType]::Allow,
        [Security.AccessControl.FileSystemRights]$Rights = [Security.AccessControl.FileSystemRights]::FullControl,
        [bool]$Inherited = $false
    )
    return [pscustomobject]@{
        AccessControlType = $Type
        IdentityReference = [Security.Principal.SecurityIdentifier]::new($Sid)
        IsInherited = $Inherited
        FileSystemRights = $Rights
        PropagationFlags = [Security.AccessControl.PropagationFlags]::None
    }
}

function Get-R6R2EFunctionText {
    param([System.Management.Automation.Language.Ast]$Ast, [string]$Name)
    $node = $Ast.Find({ param($item) $item -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $item.Name -ceq $Name }, $true)
    Assert-R6R2E ($null -ne $node) ('FUNCTION_MISSING_' + $Name.ToUpperInvariant())
    return $node.Extent.Text
}

$reconcilePath = Join-Path $PSScriptRoot 'g4b-baidu-partial-config-reconcile-checkpoint.ps1'
$authPath = Join-Path $PSScriptRoot 'g4b-baidu-owner-interactive-auth-checkpoint.ps1'
$r6Path = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
$r6ValidatorPath = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-validator.ps1'
$gatePath = Join-Path $PSScriptRoot '..\docs\G4B_BAIDU_PARTIAL_CONFIG_RECONCILIATION_REPAIR_R6R2E.md'
$reconcileText = [IO.File]::ReadAllText($reconcilePath, [Text.Encoding]::UTF8)
$authText = [IO.File]::ReadAllText($authPath, [Text.Encoding]::UTF8)
$validatorText = [IO.File]::ReadAllText($PSCommandPath, [Text.Encoding]::UTF8)
$gateText = [IO.File]::ReadAllText($gatePath, [Text.Encoding]::UTF8)

foreach ($path in @($reconcilePath, $authPath, $r6Path, $r6ValidatorPath, $PSCommandPath)) {
    $tokens = $null
    $parseErrors = $null
    [void][Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$parseErrors)
    Assert-R6R2E ($parseErrors.Count -eq 0) 'POWERSHELL_AST_PARSE_FAILED'
}

. $r6Path
. $reconcilePath

$reconcileAst = [Management.Automation.Language.Parser]::ParseFile($reconcilePath, [ref]$null, [ref]$null)
$authAst = [Management.Automation.Language.Parser]::ParseFile($authPath, [ref]$null, [ref]$null)
$aclText = Get-R6R2EFunctionText -Ast $reconcileAst -Name 'Assert-BaiduPartialConfigAclMetadata'
$metadataFunction = Get-R6R2EFunctionText -Ast $reconcileAst -Name 'Get-BaiduPartialConfigMetadata'
$deleteFunction = Get-R6R2EFunctionText -Ast $reconcileAst -Name 'Remove-BaiduPartialConfigExactResidue'
$mainFunction = Get-R6R2EFunctionText -Ast $reconcileAst -Name 'Invoke-BaiduPartialConfigReconciliationCheckpoint'
$ownerPostLogin = Get-R6R2EFunctionText -Ast $authAst -Name 'Complete-BaiduInteractivePostLoginConfig'
$ownerNormalizationPlan = Get-R6R2EFunctionText -Ast $authAst -Name 'Get-BaiduInteractivePostLoginNormalizationPlan'
$authMain = Get-R6R2EFunctionText -Ast $authAst -Name 'Invoke-BaiduOwnerInteractiveAuthCheckpoint'

$upstreamCommit = '225bdd3b6cb298601c4d5ef7104c3e08cd1d692d'
$upstreamBlobs = @('ac5ace05fc860bc3f47fdaf9ddec126d06890630', '8865962ac126053632beee750310b099e6b89e1d', '2ab8f56647d70a903786db351c57308ee8bee69d')
Assert-R6R2E ($gateText.Contains("UPSTREAM_TAG_COMMIT=$upstreamCommit") -and $gateText.Contains('UPSTREAM_CONFIG_FILENAME=pcs_config.json') -and @($upstreamBlobs | Where-Object { -not $gateText.Contains($_) }).Count -eq 0 -and $metadataFunction.Contains("$([string][char]36)child.Name") -and $gateText.Contains('only `pcs_config.json`')) 'UPSTREAM_SINGLE_CONFIG_EVIDENCE_MISSING'
Write-Output 'R6R2E_UPSTREAM_SINGLE_CONFIG_FILE_PROVEN=PASS'

Assert-R6R2E ($metadataFunction -notmatch '(?i)Get-Content|ReadAllText|ReadAllBytes|ReadAllLines|Copy-Item|Move-Item|Get-FileHash' -and $deleteFunction -notmatch '(?i)Get-Content|ReadAllText|ReadAllBytes|ReadAllLines|Copy-Item|Move-Item|Get-FileHash' -and $mainFunction.Contains('BAIDU_PARTIAL_CONFIG_CONTENT_READ=NO')) 'RECONCILIATION_CONTENT_ACCESS_FOUND'
Write-Output 'R6R2E_RECONCILE_METADATA_ONLY=PASS'

$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$fixtureBase = Join-Path ([IO.Path]::GetTempPath()) ('vpn-g4b-r6r2e-shape-' + [Guid]::NewGuid().ToString('N'))
$rootPath = Join-Path $fixtureBase 'BaiduPCS-Go'
$ownerRule = New-R6R2ERule -Sid $ownerSid.Value
$systemInherited = New-R6R2ERule -Sid 'S-1-5-18' -Inherited $true
$adminsRule = New-R6R2ERule -Sid 'S-1-5-32-544'
$safeRules = @($ownerRule, $systemInherited, $adminsRule)
$safeEntry = [pscustomobject]@{
    Name = 'pcs_config.json'
    IsDirectory = $false
    IsReparsePoint = $false
    Length = [long]64
    OwnerSid = $ownerSid.Value
    Rules = $safeRules
}
$safeSnapshot = [pscustomobject]@{
    Exists = $true
    Path = $rootPath
    IsDirectory = $true
    IsReparsePoint = $false
    OwnerSid = $ownerSid.Value
    Rules = $safeRules
    Entries = [object[]]@($safeEntry)
}
Assert-R6R2E (-not (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $safeSnapshot -ProjectRoot $projectRoot })) 'EXACT_SINGLE_FILE_SYNTHETIC_FIXTURE_FAILED'
$adminOwnedSnapshot = $safeSnapshot.PSObject.Copy()
$adminOwnedSnapshot.OwnerSid = 'S-1-5-32-544'
$adminOwnedSnapshot.Entries = [object[]]@($safeEntry.PSObject.Copy())
$adminOwnedSnapshot.Entries[0].OwnerSid = 'S-1-5-32-544'
Assert-R6R2E (-not (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $adminOwnedSnapshot -ProjectRoot $projectRoot })) 'BUILTIN_ADMIN_OWNER_FIXTURE_FAILED'
Write-Output 'R6R2E_RECONCILE_EXACT_PCS_CONFIG_ONLY=PASS'

$extra = $safeSnapshot.PSObject.Copy()
$extra.Entries = [object[]]@($safeEntry, [pscustomobject]@{ Name = 'unexpected.fixture'; IsDirectory = $false; IsReparsePoint = $false; Length = [long]1; OwnerSid = $ownerSid.Value; Rules = $safeRules })
Assert-R6R2E (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $extra -ProjectRoot $projectRoot }) 'EXTRA_ENTRY_ACCEPTED'
$extraDirectory = $safeSnapshot.PSObject.Copy()
$extraDirectory.Entries = [object[]]@($safeEntry, [pscustomobject]@{ Name = 'unexpected-subdir'; IsDirectory = $true; IsReparsePoint = $false; Length = [long]-1; OwnerSid = $ownerSid.Value; Rules = $safeRules })
Assert-R6R2E (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $extraDirectory -ProjectRoot $projectRoot }) 'EXTRA_SUBDIRECTORY_ACCEPTED'
Write-Output 'R6R2E_RECONCILE_EXTRA_ENTRY_REJECTED=PASS'

$reparse = $safeSnapshot.PSObject.Copy()
$reparse.Entries = [object[]]@($safeEntry.PSObject.Copy())
$reparse.Entries[0].IsReparsePoint = $true
Assert-R6R2E (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $reparse -ProjectRoot $projectRoot }) 'REPARSE_ENTRY_ACCEPTED'
Write-Output 'R6R2E_RECONCILE_REPARSE_REJECTED=PASS'

$wrongOwner = $safeSnapshot.PSObject.Copy()
$wrongOwner.Entries = [object[]]@($safeEntry.PSObject.Copy())
$wrongOwner.Entries[0].OwnerSid = 'S-1-5-20'
Assert-R6R2E (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $wrongOwner -ProjectRoot $projectRoot }) 'UNEXPECTED_OWNER_ACCEPTED'
Write-Output 'R6R2E_RECONCILE_UNEXPECTED_OWNER_REJECTED=PASS'

$forbidden = $safeSnapshot.PSObject.Copy()
$badRule = New-R6R2ERule -Sid 'S-1-5-11' -Inherited $true
$forbidden.Rules = [object[]]@($ownerRule, $badRule)
Assert-R6R2E (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $forbidden -ProjectRoot $projectRoot }) 'FORBIDDEN_ACE_ACCEPTED'
$deny = $safeSnapshot.PSObject.Copy()
$deny.Rules = [object[]]@($ownerRule, (New-R6R2ERule -Sid $ownerSid.Value -Type Deny))
Assert-R6R2E (Test-R6R2EThrows { Assert-BaiduPartialConfigMetadata -Snapshot $deny -ProjectRoot $projectRoot }) 'DENY_ACE_ACCEPTED'
Write-Output 'R6R2E_RECONCILE_FORBIDDEN_ACE_REJECTED=PASS'

$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('vpn-g4b-r6r2e-delete-' + [Guid]::NewGuid().ToString('N'))
$fixtureConfig = Join-Path $fixtureRoot 'BaiduPCS-Go'
$outsideSentinel = Join-Path $fixtureRoot 'must-remain.fixture'
try {
    [void][IO.Directory]::CreateDirectory($fixtureRoot)
    [void][IO.Directory]::CreateDirectory($fixtureConfig)
    Set-OwnerOnlyAcl -Path $fixtureConfig -OwnerSid $ownerSid -Directory
    $fixtureConfigFile = Join-Path $fixtureConfig 'pcs_config.json'
    [IO.File]::WriteAllText($fixtureConfigFile, 'NON_SECRET_R6R2E_METADATA_FIXTURE')
    Set-OwnerOnlyAcl -Path $fixtureConfigFile -OwnerSid $ownerSid
    [IO.File]::WriteAllText($outsideSentinel, 'NON_SECRET_OUTSIDE_SENTINEL')
    $deleted = Remove-BaiduPartialConfigExactResidue -ConfigDirectory $fixtureConfig -ProjectRoot $projectRoot
    Assert-R6R2E ($deleted -ceq 'REMOVED_EXACT_RESIDUE' -and -not (Test-Path -LiteralPath $fixtureConfig) -and (Test-Path -LiteralPath $outsideSentinel -PathType Leaf)) 'EXACT_DELETE_SCOPE_FIXTURE_FAILED'
} finally {
    $fixtureFull = [IO.Path]::GetFullPath($fixtureRoot)
    $tempFull = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\')
    Assert-R6R2E (([IO.Path]::GetDirectoryName($fixtureFull) -ieq $tempFull) -and ([IO.Path]::GetFileName($fixtureFull) -match '^vpn-g4b-r6r2e-delete-[0-9a-f]{32}$')) 'FIXTURE_CLEANUP_SCOPE_INVALID'
    if (Test-Path -LiteralPath $fixtureFull) { Remove-Item -LiteralPath $fixtureFull -Recurse -Force -ErrorAction Stop }
    Assert-R6R2E (-not (Test-Path -LiteralPath $fixtureFull)) 'FIXTURE_CLEANUP_FAILED'
}
Write-Output 'R6R2E_RECONCILE_DELETE_EXACT_ONLY=PASS'

Assert-R6R2E ($reconcileText -match '(?i)\[IO\.File\]::Delete\(\$configFile\)' -and $deleteFunction.Contains('[IO.Directory]::Delete($configFull, $false)') -and $reconcileText -notmatch '(?im)^\s*Remove-Item\b.*-Recurse') 'RECONCILIATION_DELETE_SCOPE_INVALID'
Assert-R6R2E ($reconcileText -notmatch '(?im)^\s*Write-(?:Output|Host|Error|Information|Warning|Verbose)\b.*(?:OwnerSid|Rules|Length|LastWriteTime|CreationTime|\.FullName|\.Path)') 'RECONCILIATION_METADATA_OUTPUT_FOUND'
Assert-R6R2E ($authMain.Contains('. $acceptedReconcileHelper') -and $authMain.Contains('if ($script:interactiveAuthLoginStarted -and $script:interactiveAuthConfigFileAbsentBeforeLogin -and -not $candidateReady)')) 'AUTH_RECONCILIATION_WIRING_MISSING'
Assert-R6R2E ($ownerPostLogin.IndexOf('Get-BaiduPartialConfigMetadata') -lt $ownerPostLogin.IndexOf('Get-BaiduInteractivePostLoginNormalizationPlan') -and $ownerPostLogin.IndexOf('Get-BaiduInteractivePostLoginNormalizationPlan') -lt $ownerPostLogin.IndexOf('Set-OwnerOnlyAcl -Path $target.Path') -and $ownerPostLogin.IndexOf('Assert-SafeBaiduConfigDirectory') -gt $ownerPostLogin.IndexOf('Set-OwnerOnlyAcl -Path $target.Path') -and $ownerNormalizationPlan.IndexOf('Assert-BaiduPartialConfigStructure') -lt $ownerNormalizationPlan.IndexOf('$configFile')) 'POST_LOGIN_NORMALIZATION_ORDER_INVALID'
Assert-R6R2E ($authMain.IndexOf('Complete-BaiduInteractivePostLoginConfig') -lt $authMain.IndexOf("if (-not `$loginSucceeded)") -and $authMain.IndexOf("if (-not `$loginSucceeded)") -lt $authMain.IndexOf('Invoke-ReadOnlyBaiduWho')) 'NONZERO_LOGIN_WHO_ORDER_INVALID'
Assert-R6R2E ($authText -notmatch '(?i)\$env:(?:BDUSS|STOKEN|COOKIE|PASSWORD|TOKEN|CREDENTIAL|SECRET)\b' -and $authText -match "\.ArgumentList\.Add\('login'\)" -and $authText -notmatch '(?i)username|password|cookie|bduss|stoken|ptoken') 'AUTH_CREDENTIAL_BOUNDARY_CHANGED'
Assert-R6R2E ($authMain -notmatch '(?i)Write-(?:Output|Host|Error|Information|Warning|Verbose)\b.*(?:interactiveAuthUid|\.Uid|StdOut|StdErr)' -and $authText.Contains("Write-Output 'BAIDU_UID_EMITTED=NO'")) 'AUTH_UID_OR_RAW_OUTPUT_EXPOSED'
Assert-R6R2E ($authText -notmatch '(?i)ReadAllText|ReadAllBytes|ReadAllLines|Get-Content|Get-FileHash.*pcs_config|Copy-Item.*pcs_config') 'AUTH_CONFIG_CONTENT_ACCESS_ADDED'
Write-Output 'R6R2E_AUTH_STATIC_BOUNDARIES=PASS'
Write-Output 'R6R2E_RECONCILE_FIXTURES=PASS'
Write-Output 'POWERSHELL_AST_PARSE=PASS'
Write-Output 'REAL_CONFIG_ACTIONS=0'
Write-Output 'REAL_LOGIN_ACTIONS=0'
Write-Output 'REAL_BAIDU_ACTIONS=0'
Write-Output 'NETWORK_REQUESTS=0'
