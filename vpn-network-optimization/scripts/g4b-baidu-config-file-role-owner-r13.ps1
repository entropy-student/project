[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:stage='BOOT'
$classification='UNKNOWN'

function Write-Stage {
    param([Parameter(Mandatory=$true)][string]$Name)
    $script:stage=$Name
    Write-Output ('DIAGNOSTIC_STAGE='+$Name)
}

function Assert-R13 {
    param([bool]$Condition,[Parameter(Mandatory=$true)][string]$Code)
    if(-not $Condition){throw $Code}
}

function Get-OwnerRole {
    param(
        [Parameter(Mandatory=$true)][string]$ActualOwnerSid,
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$ExpectedOwnerSid
    )

    if($ActualOwnerSid -ceq $ExpectedOwnerSid.Value){return 'OWNER'}
    if($ActualOwnerSid -ceq 'S-1-5-32-544'){return 'ADMIN'}
    if($ActualOwnerSid -ceq 'S-1-5-18'){return 'SYSTEM'}
    return 'OTHER'
}

try {
    Write-Stage 'OWNER_RUNTIME'

    Assert-R13 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'

    $ownerSid=[Security.Principal.WindowsIdentity]::GetCurrent().User
    Assert-R13 ($null -ne $ownerSid) 'CURRENT_OWNER_SID_UNAVAILABLE'

    $configDir=Join-Path $env:APPDATA 'BaiduPCS-Go'
    Assert-R13 (-not [string]::IsNullOrWhiteSpace($configDir)) 'BAIDU_CONFIG_PATH_INVALID'
    Assert-R13 (-not $configDir.StartsWith('\\',[StringComparison]::OrdinalIgnoreCase)) 'BAIDU_CONFIG_NETWORK_PATH_FORBIDDEN'
    Assert-R13 (Test-Path -LiteralPath $configDir -PathType Container) 'BAIDU_CONFIG_DIRECTORY_MISSING'

    Write-Output 'OWNER_RUNTIME=PASS'

    Write-Stage 'BAIDU_CONFIG_FILE_ROLE_METADATA'

    $root=Get-Item -LiteralPath $configDir -Force -ErrorAction Stop
    $children=@(Get-ChildItem -LiteralPath $configDir -Force -ErrorAction Stop)

    Assert-R13 ($children.Count -le 64) 'BAIDU_CONFIG_DIRECT_CHILD_LIMIT_EXCEEDED'

    $rootAcl=Get-Acl -LiteralPath $root.FullName -ErrorAction Stop
    $rootOwnerSid=$rootAcl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    $rootOwnerRole=Get-OwnerRole -ActualOwnerSid $rootOwnerSid -ExpectedOwnerSid $ownerSid

    $configPresent=$false
    $configOwnerRole='NOT_PRESENT'
    $historyPresent=$false
    $historyOwnerRole='NOT_PRESENT'

    $unexpectedFileCount=0
    $unexpectedDirectoryCount=0
    $reparsePointCount=0
    $configCount=0
    $historyCount=0

    if(($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){
        $reparsePointCount++
    }

    foreach($child in $children){
        $isReparse=(($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
        if($isReparse){
            $reparsePointCount++
        }

        if($child.PSIsContainer){
            $unexpectedDirectoryCount++
            continue
        }

        $name=[IO.Path]::GetFileName($child.FullName)

        if($name -ceq 'pcs_config.json'){
            $configCount++
            $configPresent=$true

            $acl=Get-Acl -LiteralPath $child.FullName -ErrorAction Stop
            $actualOwnerSid=$acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
            $configOwnerRole=Get-OwnerRole -ActualOwnerSid $actualOwnerSid -ExpectedOwnerSid $ownerSid
            continue
        }

        if($name -ceq 'pcs_command_history.txt'){
            $historyCount++
            $historyPresent=$true

            $acl=Get-Acl -LiteralPath $child.FullName -ErrorAction Stop
            $actualOwnerSid=$acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
            $historyOwnerRole=Get-OwnerRole -ActualOwnerSid $actualOwnerSid -ExpectedOwnerSid $ownerSid
            continue
        }

        $unexpectedFileCount++
    }

    Assert-R13 ($configCount -le 1) 'DUPLICATE_CONFIG_FILE_ROLE'
    Assert-R13 ($historyCount -le 1) 'DUPLICATE_HISTORY_FILE_ROLE'

    $totalItemCount=1+$children.Count

    Write-Output ('TOTAL_ITEM_COUNT='+$totalItemCount)
    Write-Output ('ROOT_OWNER_ROLE='+$rootOwnerRole)
    Write-Output ('CONFIG_FILE_PRESENT='+$(if($configPresent){'YES'}else{'NO'}))
    Write-Output ('CONFIG_FILE_OWNER_ROLE='+$configOwnerRole)
    Write-Output ('HISTORY_FILE_PRESENT='+$(if($historyPresent){'YES'}else{'NO'}))
    Write-Output ('HISTORY_FILE_OWNER_ROLE='+$historyOwnerRole)
    Write-Output ('UNEXPECTED_FILE_COUNT='+$unexpectedFileCount)
    Write-Output ('UNEXPECTED_DIRECTORY_COUNT='+$unexpectedDirectoryCount)
    Write-Output ('REPARSE_POINT_COUNT='+$reparsePointCount)

    if($reparsePointCount -gt 0){
        $classification='REPARSE_OR_UNSAFE_SHAPE'
    }
    elseif($unexpectedFileCount -gt 0 -or $unexpectedDirectoryCount -gt 0){
        $classification='UNEXPECTED_ENTRY_PRESENT'
    }
    elseif(-not $configPresent -or -not $historyPresent){
        $classification='EXPECTED_FILE_MISSING'
    }
    elseif(
        $rootOwnerRole -ceq 'OWNER' -and
        $configOwnerRole -ceq 'ADMIN' -and
        $historyOwnerRole -ceq 'OWNER'
    ){
        $classification='EXPECTED_V4_0_2_SHAPE_CONFIG_ADMIN_HISTORY_OWNER'
    }
    elseif(
        $rootOwnerRole -ceq 'OWNER' -and
        $configOwnerRole -ceq 'OWNER' -and
        $historyOwnerRole -ceq 'OWNER'
    ){
        $classification='EXPECTED_V4_0_2_SHAPE_ALL_OWNER'
    }
    else {
        $classification='EXPECTED_V4_0_2_SHAPE_OTHER_OWNER_COMBINATION'
    }

    Write-Output ('R13_FILE_ROLE_STATE='+$classification)
}
catch {
    if($classification -eq 'UNKNOWN'){
        $classification='LOCAL_DIAGNOSTIC_EXCEPTION'
    }

    Write-Output ('DIAGNOSTIC_FAILED_STAGE='+$script:stage)
    Write-Output ('DIAGNOSTIC_EXCEPTION_TYPE='+$_.Exception.GetType().FullName)
    Write-Output ('DIAGNOSTIC_ERROR_LINE='+[string]$_.InvocationInfo.ScriptLineNumber)
    Write-Output ('R13_FILE_ROLE_STATE='+$classification)
}
finally {
    Write-Output 'CONFIG_CONTENT_READ=NO'
    Write-Output 'ACL_MUTATION=NO'
    Write-Output 'BAIDU_PROVIDER_ACTION=NO'
    Write-Output 'UID_INPUT=NO'
    Write-Output 'SECRET_OR_DPAPI_ACCESS=NO'
    Write-Output 'SSH_OR_VPS_ACTION=NO'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
