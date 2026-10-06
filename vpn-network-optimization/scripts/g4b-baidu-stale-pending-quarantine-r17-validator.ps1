[CmdletBinding()]
param(
    [string]$HelperPath=(Join-Path $PSScriptRoot 'g4b-baidu-stale-pending-quarantine-r17.ps1')
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Assert-R17Validator {
    param([bool]$Condition,[Parameter(Mandatory=$true)][string]$Code)
    if(-not $Condition){throw $Code}
}

$resolved=[IO.Path]::GetFullPath($HelperPath)
Assert-R17Validator (Test-Path -LiteralPath $resolved -PathType Leaf) 'R17_VALIDATOR_HELPER_MISSING'

$tokens=$null
$errors=$null
[void][System.Management.Automation.Language.Parser]::ParseFile($resolved,[ref]$tokens,[ref]$errors)
Assert-R17Validator ($errors.Count -eq 0) 'R17_VALIDATOR_AST_PARSE_FAILED'
Write-Output 'R17_VALIDATOR_AST_PARSE=PASS'

$source=[IO.File]::ReadAllText($resolved,[Text.UTF8Encoding]::new($false))
Assert-R17Validator ($source.Contains("[string]`$Mode='Validate'")) 'R17_VALIDATOR_DEFAULT_MODE_INVALID'
Assert-R17Validator ($source -match "ValidateSet\('who','ls','mv'\)") 'R17_VALIDATOR_COMMAND_ALLOWLIST_INVALID'
Assert-R17Validator ($source -match 'R17_OWNER_AUTHORIZATION_REQUIRED') 'R17_VALIDATOR_OWNER_GUARD_MISSING'
Assert-R17Validator ($source -match 'R17_REMOTE_MUTATION=MV_TO_QUARANTINE') 'R17_VALIDATOR_FORWARD_MARKER_MISSING'
Assert-R17Validator ($source -match 'R17_ROLLBACK_PRECHECK=PASS') 'R17_VALIDATOR_ROLLBACK_GUARD_MISSING'
Assert-R17Validator ($source -match 'BAIDU_UID_OUTPUT_AMBIGUOUS') 'R17_VALIDATOR_UID_UNIQUENESS_GUARD_MISSING'
Assert-R17Validator ($source -match 'R17_MV_ARGUMENT_SHAPE_INVALID') 'R17_VALIDATOR_MV_SHAPE_GUARD_MISSING'
Assert-R17Validator ($source -match 'QuarantineObjectCount') 'R17_VALIDATOR_QUARANTINE_OBJECT_GUARD_MISSING'
Assert-R17Validator ($source -match 'BAIDU_PERMANENT_DELETE=NO') 'R17_VALIDATOR_DELETE_GUARD_MISSING'
Assert-R17Validator ($source -match 'BAIDU_AUTH_CONFIG_DENY_ACE') 'R17_VALIDATOR_STRICT_ACL_DENY_MISSING'
Assert-R17Validator ($source -match 'BAIDU_AUTH_CONFIG_UNAUTHORIZED_ALLOW') 'R17_VALIDATOR_STRICT_ACL_ALLOWLIST_MISSING'
Assert-R17Validator ($source -match 'BAIDU_AUTH_CONFIG_OWNER_READ_RIGHTS_MISSING') 'R17_VALIDATOR_STRICT_ACL_RIGHTS_MISSING'
Assert-R17Validator (-not ($source -match "-Action\s+'(?:rm|upload|download|mkdir|login|logout|config)'")) 'R17_VALIDATOR_FORBIDDEN_PROVIDER_ACTION_PRESENT'
Write-Output 'R17_VALIDATOR_STATIC_BOUNDARY=PASS'

. $resolved -DefinitionOnly

$remote='/vpn-network-optimization-g4b-recovery'
$run='0123456789abcdef0123456789abcdef'
$pending='vpn-network-optimization-g4b-'+$run+'.vpr1.pending'
$quarantine='r17-quarantine-'+$run+'.vpr1.pending'

$onePending="当前目录: $remote`n1 2 3 $pending`n"
Assert-R17DirectoryHeader -Listing $onePending
$pre=Get-R17ListingState -Listing $onePending -SourceName $pending -QuarantineName $quarantine
Assert-R17Validator ([int]$pre['FinalCount'] -eq 0) 'R17_FIXTURE_PENDING_FINAL_COUNT'
Assert-R17Validator ([int]$pre['PendingCount'] -eq 1) 'R17_FIXTURE_PENDING_COUNT'
Assert-R17Validator ([int]$pre['UnknownCount'] -eq 0) 'R17_FIXTURE_PENDING_UNKNOWN_COUNT'
Assert-R17Validator ([int]$pre['SourceCount'] -eq 1) 'R17_FIXTURE_PENDING_SOURCE_COUNT'
Assert-R17Validator ([int]$pre['QuarantineCount'] -eq 0) 'R17_FIXTURE_PENDING_QUARANTINE_COUNT'
Assert-R17Validator ([int]$pre['QuarantineObjectCount'] -eq 0) 'R17_FIXTURE_PENDING_QUARANTINE_OBJECT_COUNT'
Assert-R17Validator ([int]$pre['QuarantineDirectoryCount'] -eq 0) 'R17_FIXTURE_PENDING_QUARANTINE_DIRECTORY_COUNT'
Assert-R17Validator ([string]$pre['SingleRunId'] -ceq $run) 'R17_FIXTURE_RUN_ID'
Write-Output 'R17_FIXTURE_ONE_PENDING=PASS'

$afterForward="当前目录: $remote`n1 2 3 $quarantine`n"
Assert-R17DirectoryHeader -Listing $afterForward
$post=Get-R17ListingState -Listing $afterForward -SourceName $pending -QuarantineName $quarantine
Assert-R17Validator ([int]$post['FinalCount'] -eq 0) 'R17_FIXTURE_FORWARD_FINAL_COUNT'
Assert-R17Validator ([int]$post['PendingCount'] -eq 0) 'R17_FIXTURE_FORWARD_PENDING_COUNT'
Assert-R17Validator ([int]$post['UnknownCount'] -eq 0) 'R17_FIXTURE_FORWARD_UNKNOWN_COUNT'
Assert-R17Validator ([int]$post['SourceCount'] -eq 0) 'R17_FIXTURE_FORWARD_SOURCE_COUNT'
Assert-R17Validator ([int]$post['QuarantineCount'] -eq 1) 'R17_FIXTURE_FORWARD_QUARANTINE_COUNT'
Assert-R17Validator ([int]$post['QuarantineObjectCount'] -eq 1) 'R17_FIXTURE_FORWARD_QUARANTINE_OBJECT_COUNT'
Assert-R17Validator ([int]$post['QuarantineDirectoryCount'] -eq 0) 'R17_FIXTURE_FORWARD_QUARANTINE_DIRECTORY_COUNT'
Write-Output 'R17_FIXTURE_QUARANTINE_STATE=PASS'

$quarantineDirectory="当前目录: $remote`n1 2 3 $quarantine/`n"
$quarantineDirectoryState=Get-R17ListingState -Listing $quarantineDirectory -SourceName $pending -QuarantineName $quarantine
Assert-R17Validator ([int]$quarantineDirectoryState['QuarantineCount'] -eq 0) 'R17_FIXTURE_QUARANTINE_DIRECTORY_FILE_COUNT'
Assert-R17Validator ([int]$quarantineDirectoryState['QuarantineObjectCount'] -eq 1) 'R17_FIXTURE_QUARANTINE_DIRECTORY_OBJECT_COUNT'
Assert-R17Validator ([int]$quarantineDirectoryState['QuarantineDirectoryCount'] -eq 1) 'R17_FIXTURE_QUARANTINE_DIRECTORY_NOT_DETECTED'
Write-Output 'R17_FIXTURE_QUARANTINE_DIRECTORY_COLLISION=PASS'

$pendingDirectory="当前目录: $remote`n1 2 3 $pending/`n"
$pendingDirectoryState=Get-R17ListingState -Listing $pendingDirectory
Assert-R17Validator ([int]$pendingDirectoryState['PendingCount'] -eq 0) 'R17_FIXTURE_PENDING_DIRECTORY_PENDING_COUNT'
Assert-R17Validator ([int]$pendingDirectoryState['UnknownCount'] -eq 1) 'R17_FIXTURE_PENDING_DIRECTORY_UNKNOWN_COUNT'
Write-Output 'R17_FIXTURE_PROJECT_DIRECTORY_UNKNOWN=PASS'

$unknown="当前目录: $remote`n1 2 3 vpn-network-optimization-g4b-unexpected.vpr1`n"
$unknownState=Get-R17ListingState -Listing $unknown
Assert-R17Validator ([int]$unknownState['UnknownCount'] -eq 1) 'R17_FIXTURE_UNKNOWN_NOT_REJECTED'
Write-Output 'R17_FIXTURE_UNKNOWN_DETECTION=PASS'
# Multiple canonical pending objects must fail the production precondition.
$run2=[string]::new('b',32)
$pending2='vpn-network-optimization-g4b-'+$run2+'.vpr1.pending'

$multiplePending=(
    "当前目录: $remote`n"+
    "1 2 3 $pending`n"+
    "1 2 3 $pending2`n"
)

$multipleState=Get-R17ListingState -Listing $multiplePending

Assert-R17Validator (
    [int]$multipleState['FinalCount'] -eq 0
) 'R17_FIXTURE_MULTIPLE_PENDING_FINAL_COUNT'

Assert-R17Validator (
    [int]$multipleState['PendingCount'] -eq 2
) 'R17_FIXTURE_MULTIPLE_PENDING_COUNT'

Assert-R17Validator (
    [int]$multipleState['UnknownCount'] -eq 0
) 'R17_FIXTURE_MULTIPLE_PENDING_UNKNOWN_COUNT'

Assert-R17Validator (
    [string]::IsNullOrEmpty(
        [string]$multipleState['SinglePendingName']
    )
) 'R17_FIXTURE_MULTIPLE_PENDING_SINGLE_NAME_NOT_EMPTY'

$multipleAccepted=(
    [int]$multipleState['FinalCount'] -eq 0 -and
    [int]$multipleState['PendingCount'] -eq 1 -and
    [int]$multipleState['UnknownCount'] -eq 0
)

Assert-R17Validator (
    -not $multipleAccepted
) 'R17_FIXTURE_MULTIPLE_PENDING_NOT_REJECTED'

Write-Output 'R17_FIXTURE_MULTIPLE_PENDING_REJECT=PASS'

# A production final object must fail the production precondition.
$finalName='vpn-network-optimization-g4b.vpr1'

$finalPresent=(
    "当前目录: $remote`n"+
    "1 2 3 $finalName`n"+
    "1 2 3 $pending`n"
)

$finalState=Get-R17ListingState -Listing $finalPresent

Assert-R17Validator (
    [int]$finalState['FinalCount'] -eq 1
) 'R17_FIXTURE_FINAL_PRESENT_FINAL_COUNT'

Assert-R17Validator (
    [int]$finalState['PendingCount'] -eq 1
) 'R17_FIXTURE_FINAL_PRESENT_PENDING_COUNT'

Assert-R17Validator (
    [int]$finalState['UnknownCount'] -eq 0
) 'R17_FIXTURE_FINAL_PRESENT_UNKNOWN_COUNT'

$finalAccepted=(
    [int]$finalState['FinalCount'] -eq 0 -and
    [int]$finalState['PendingCount'] -eq 1 -and
    [int]$finalState['UnknownCount'] -eq 0
)

Assert-R17Validator (
    -not $finalAccepted
) 'R17_FIXTURE_FINAL_PRESENT_NOT_REJECTED'

Write-Output 'R17_FIXTURE_FINAL_PRESENT_REJECT=PASS'

# Explicit parent-Gate shape guards.
Assert-R17Validator (
    $source -match 'R17_SOURCE_CARDINALITY_INVALID'
) 'R17_VALIDATOR_SOURCE_CARDINALITY_GUARD_MISSING'

Assert-R17Validator (
    $source -match 'R17_QUARANTINE_TARGET_COLLISION'
) 'R17_VALIDATOR_QUARANTINE_COLLISION_GUARD_MISSING'

Assert-R17Validator (
    $source -match 'R17_MV_ARGUMENT_SHAPE_INVALID'
) 'R17_VALIDATOR_MV_SHAPE_GUARD_MISSING_FINAL'

Write-Output 'R17_SOURCE_TARGET_SHAPE_GUARDS=PASS'

$defaultOutput=@(& $resolved)
Assert-R17Validator ($defaultOutput -contains 'R17_VALIDATION=PASS') 'R17_VALIDATOR_DEFAULT_VALIDATION_MISSING'
Assert-R17Validator ($defaultOutput -contains 'R17_DEFAULT_MODE=NON_MUTATING') 'R17_VALIDATOR_DEFAULT_NONMUTATING_MISSING'
Assert-R17Validator ($defaultOutput -contains 'BAIDU_PROVIDER_ACTION=NO') 'R17_VALIDATOR_DEFAULT_PROVIDER_BOUNDARY_MISSING'
Assert-R17Validator (-not ($defaultOutput -match '^R17_STAGE=')) 'R17_VALIDATOR_DEFAULT_REACHED_RUNTIME_STAGE'
Write-Output 'R17_DEFAULT_NONMUTATING_EXECUTION=PASS'

Write-Output 'R17_OFFLINE_VALIDATOR=PASS'
Write-Output 'BAIDU_PROVIDER_ACTION=NO'
Write-Output 'OWNER_CONFIG_READ=NO'
Write-Output 'SECRET_OR_DPAPI_ACCESS=NO'
Write-Output 'SSH_OR_VPS_ACTION=NO'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'STOP_AT_REVIEWER=YES'
