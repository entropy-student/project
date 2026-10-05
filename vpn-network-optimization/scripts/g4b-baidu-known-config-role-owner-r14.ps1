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

function Assert-R14 {
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

    Assert-R14 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'

    $ownerSid=[Security.Principal.WindowsIdentity]::GetCurrent().User
    Assert-R14 ($null -ne $ownerSid) 'CURRENT_OWNER_SID_UNAVAILABLE'

    $configDir=Join-Path $env:APPDATA 'BaiduPCS-Go'
    Assert-R14 (-not [string]::IsNullOrWhiteSpace($configDir)) 'BAIDU_CONFIG_PATH_INVALID'
    Assert-R14 (-not $configDir.StartsWith('\\',[StringComparison]::OrdinalIgnoreCase)) 'BAIDU_CONFIG_NETWORK_PATH_FORBIDDEN'
    Assert-R14 (Test-Path -LiteralPath $configDir -PathType Container) 'BAIDU_CONFIG_DIRECTORY_MISSING'

    Write-Output 'OWNER_RUNTIME=PASS'

    Write-Stage 'BAIDU_KNOWN_CONFIG_ROLE_METADATA'

    $root=Get-Item -LiteralPath $configDir -Force -ErrorAction Stop
    $children=@(Get-ChildItem -LiteralPath $configDir -Force -ErrorAction Stop)

    Assert-R14 ($children.Count -le 64) 'BAIDU_CONFIG_DIRECT_CHILD_LIMIT_EXCEEDED'

    $rootAcl=Get-Acl -LiteralPath $root.FullName -ErrorAction Stop
    $rootOwnerSid=$rootAcl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    $rootOwnerRole=Get-OwnerRole -ActualOwnerSid $rootOwnerSid -ExpectedOwnerSid $ownerSid

    $configPresent=$false
    $configOwnerRole='NOT_PRESENT'
    $historyPresent=$false
    $historyOwnerRole='NOT_PRESENT'
    $uploadDbPresent=$false
    $uploadDbOwnerRole='NOT_PRESENT'
    $captchaPresent=$false
    $captchaOwnerRole='NOT_PRESENT'

    $configCount=0
    $historyCount=0
    $uploadDbCount=0
    $captchaCount=0
    $unknownFileCount=0
    $unknownDirectoryCount=0
    $reparsePointCount=0

    if(($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){
        $reparsePointCount++
    }

    foreach($child in $children){
        $isReparse=(($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
        if($isReparse){
            $reparsePointCount++
        }

        if($child.PSIsContainer){
            $unknownDirectoryCount++
            continue
        }

        $name=[IO.Path]::GetFileName($child.FullName)
        $acl=Get-Acl -LiteralPath $child.FullName -ErrorAction Stop
        $actualOwnerSid=$acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
        $role=Get-OwnerRole -ActualOwnerSid $actualOwnerSid -ExpectedOwnerSid $ownerSid

        if($name -ceq 'pcs_config.json'){
            $configCount++
            $configPresent=$true
            $configOwnerRole=$role
            continue
        }

        if($name -ceq 'pcs_command_history.txt'){
            $historyCount++
            $historyPresent=$true
            $historyOwnerRole=$role
            continue
        }

        if($name -ceq 'pcs_uploading.json'){
            $uploadDbCount++
            $uploadDbPresent=$true
            $uploadDbOwnerRole=$role
            continue
        }

        if($name -ceq 'captcha.png'){
            $captchaCount++
            $captchaPresent=$true
            $captchaOwnerRole=$role
            continue
        }

        $unknownFileCount++
    }

    Assert-R14 ($configCount -le 1) 'DUPLICATE_CONFIG_ROLE'
    Assert-R14 ($historyCount -le 1) 'DUPLICATE_HISTORY_ROLE'
    Assert-R14 ($uploadDbCount -le 1) 'DUPLICATE_UPLOAD_DB_ROLE'
    Assert-R14 ($captchaCount -le 1) 'DUPLICATE_CAPTCHA_ROLE'

    Write-Output ('TOTAL_ITEM_COUNT='+(1+$children.Count))
    Write-Output ('ROOT_OWNER_ROLE='+$rootOwnerRole)
    Write-Output ('CONFIG_PRESENT='+$(if($configPresent){'YES'}else{'NO'}))
    Write-Output ('CONFIG_OWNER_ROLE='+$configOwnerRole)
    Write-Output ('HISTORY_PRESENT='+$(if($historyPresent){'YES'}else{'NO'}))
    Write-Output ('HISTORY_OWNER_ROLE='+$historyOwnerRole)
    Write-Output ('UPLOAD_DB_PRESENT='+$(if($uploadDbPresent){'YES'}else{'NO'}))
    Write-Output ('UPLOAD_DB_OWNER_ROLE='+$uploadDbOwnerRole)
    Write-Output ('CAPTCHA_PRESENT='+$(if($captchaPresent){'YES'}else{'NO'}))
    Write-Output ('CAPTCHA_OWNER_ROLE='+$captchaOwnerRole)
    Write-Output ('UNKNOWN_FILE_COUNT='+$unknownFileCount)
    Write-Output ('UNKNOWN_DIRECTORY_COUNT='+$unknownDirectoryCount)
    Write-Output ('REPARSE_POINT_COUNT='+$reparsePointCount)

    if($reparsePointCount -gt 0){
        $classification='REPARSE_OR_UNSAFE_SHAPE'
    }
    elseif($unknownFileCount -gt 0 -or $unknownDirectoryCount -gt 0){
        $classification='UNKNOWN_ENTRY_PRESENT'
    }
    elseif(-not $configPresent){
        $classification='EXPECTED_CORE_CONFIG_MISSING'
    }
    elseif(
        $rootOwnerRole -ceq 'OWNER' -and
        $configOwnerRole -ceq 'OWNER' -and
        -not $historyPresent -and
        $uploadDbPresent -and
        $uploadDbOwnerRole -ceq 'ADMIN' -and
        -not $captchaPresent
    ){
        $classification='EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN'
    }
    elseif(
        $rootOwnerRole -ceq 'OWNER' -and
        $configOwnerRole -ceq 'OWNER' -and
        $historyPresent -and
        $historyOwnerRole -ceq 'OWNER' -and
        -not $uploadDbPresent -and
        -not $captchaPresent
    ){
        $classification='EXPECTED_CONFIG_OWNER_HISTORY_OWNER'
    }
    else {
        $classification='EXPECTED_KNOWN_ROLE_COMBINATION_OTHER'
    }

    Write-Output ('R14_KNOWN_ROLE_STATE='+$classification)
}
catch {
    if($classification -eq 'UNKNOWN'){
        $classification='LOCAL_DIAGNOSTIC_EXCEPTION'
    }

    Write-Output ('DIAGNOSTIC_FAILED_STAGE='+$script:stage)
    Write-Output ('DIAGNOSTIC_EXCEPTION_TYPE='+$_.Exception.GetType().FullName)
    Write-Output ('DIAGNOSTIC_ERROR_LINE='+[string]$_.InvocationInfo.ScriptLineNumber)
    Write-Output ('R14_KNOWN_ROLE_STATE='+$classification)
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
