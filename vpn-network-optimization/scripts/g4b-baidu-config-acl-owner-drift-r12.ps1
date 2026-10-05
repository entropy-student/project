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

function Assert-R12 {
    param([bool]$Condition,[Parameter(Mandatory=$true)][string]$Code)
    if(-not $Condition){throw $Code}
}

try {
    Write-Stage 'OWNER_RUNTIME'

    Assert-R12 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'

    $ownerSid=[Security.Principal.WindowsIdentity]::GetCurrent().User
    Assert-R12 ($null -ne $ownerSid) 'CURRENT_OWNER_SID_UNAVAILABLE'

    $configDir=Join-Path $env:APPDATA 'BaiduPCS-Go'
    Assert-R12 (-not [string]::IsNullOrWhiteSpace($configDir)) 'BAIDU_CONFIG_PATH_INVALID'
    Assert-R12 (-not $configDir.StartsWith('\\',[StringComparison]::OrdinalIgnoreCase)) 'BAIDU_CONFIG_NETWORK_PATH_FORBIDDEN'
    Assert-R12 (Test-Path -LiteralPath $configDir -PathType Container) 'BAIDU_CONFIG_DIRECTORY_MISSING'

    Write-Output 'OWNER_RUNTIME=PASS'

    Write-Stage 'BAIDU_CONFIG_METADATA_INVENTORY'

    $items=[Collections.Generic.List[IO.FileSystemInfo]]::new()
    $rootItem=Get-Item -LiteralPath $configDir -Force -ErrorAction Stop
    $items.Add($rootItem)

    foreach($child in @(Get-ChildItem -LiteralPath $configDir -Force -Recurse -ErrorAction Stop)){
        $items.Add($child)
    }

    Assert-R12 ($items.Count -le 4096) 'BAIDU_CONFIG_ENTRY_LIMIT_EXCEEDED'

    $totalCount=$items.Count
    $fileCount=0
    $directoryCount=0

    $exactOwnerCount=0
    $adminOwnerCount=0
    $systemOwnerCount=0
    $otherOwnerCount=0

    $ownerMismatchFileCount=0
    $ownerMismatchDirectoryCount=0

    $reparseCount=0
    $denyAceItemCount=0
    $unauthorizedAllowItemCount=0
    $ownerReadRightsMissingItemCount=0

    $rootOwnerMatch=$false
    $rootIndex=0

    $adminMismatchDirectChildFileCount=0

    $adminSid='S-1-5-32-544'
    $systemSid='S-1-5-18'
    $allowedSids=@($ownerSid.Value,$systemSid,$adminSid)

    foreach($item in $items){
        $isDirectory=[bool]$item.PSIsContainer

        if($isDirectory){
            $directoryCount++
        }
        else {
            $fileCount++
        }

        $isReparse=(($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
        if($isReparse){
            $reparseCount++
        }

        $acl=Get-Acl -LiteralPath $item.FullName -ErrorAction Stop
        $actualOwnerSid=$acl.GetOwner([Security.Principal.SecurityIdentifier]).Value

        if($actualOwnerSid -ceq $ownerSid.Value){
            $exactOwnerCount++
        }
        elseif($actualOwnerSid -ceq $adminSid){
            $adminOwnerCount++

            if(-not $isDirectory){
                $parent=[IO.Path]::GetDirectoryName($item.FullName)
                if($parent -ceq $configDir){
                    $adminMismatchDirectChildFileCount++
                }
            }
        }
        elseif($actualOwnerSid -ceq $systemSid){
            $systemOwnerCount++
        }
        else {
            $otherOwnerCount++
        }

        if($rootIndex -eq 0){
            $rootOwnerMatch=($actualOwnerSid -ceq $ownerSid.Value)
        }

        if($actualOwnerSid -cne $ownerSid.Value){
            if($isDirectory){
                $ownerMismatchDirectoryCount++
            }
            else {
                $ownerMismatchFileCount++
            }
        }

        $rules=@($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))

        $itemHasDeny=$false
        $itemHasUnauthorizedAllow=$false
        $ownerDirectRights=[long]0
        $ownerInheritedRights=[long]0

        foreach($rule in $rules){
            Assert-R12 ($null -ne $rule) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'

            $identity=$rule.IdentityReference
            Assert-R12 ($identity -is [Security.Principal.SecurityIdentifier]) 'BAIDU_AUTH_CONFIG_ACE_IDENTITY_INVALID'

            $ruleSid=[string]$identity.Value
            $accessType=$rule.AccessControlType
            $rights=$rule.FileSystemRights
            $isInherited=[bool]$rule.IsInherited
            $propagation=$rule.PropagationFlags

            if($accessType -eq [Security.AccessControl.AccessControlType]::Deny){
                $itemHasDeny=$true
                continue
            }

            Assert-R12 ($accessType -eq [Security.AccessControl.AccessControlType]::Allow) 'BAIDU_AUTH_CONFIG_ACE_TYPE_INVALID'

            if($ruleSid -notin $allowedSids){
                $itemHasUnauthorizedAllow=$true
            }

            if(
                $ruleSid -ceq $ownerSid.Value -and
                (([long]$propagation -band [long][Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0)
            ){
                if($isInherited){
                    $ownerInheritedRights=$ownerInheritedRights -bor [long]$rights
                }
                else {
                    $ownerDirectRights=$ownerDirectRights -bor [long]$rights
                }
            }
        }

        if($itemHasDeny){
            $denyAceItemCount++
        }

        if($itemHasUnauthorizedAllow){
            $unauthorizedAllowItemCount++
        }

        if($isDirectory){
            $requiredReadRights=[long](
                [Security.AccessControl.FileSystemRights]::ListDirectory -bor
                [Security.AccessControl.FileSystemRights]::ExecuteFile -bor
                [Security.AccessControl.FileSystemRights]::ReadAttributes -bor
                [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor
                [Security.AccessControl.FileSystemRights]::ReadPermissions
            )
        }
        else {
            $requiredReadRights=[long](
                [Security.AccessControl.FileSystemRights]::ReadData -bor
                [Security.AccessControl.FileSystemRights]::ReadAttributes -bor
                [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor
                [Security.AccessControl.FileSystemRights]::ReadPermissions
            )
        }

        $effectiveOwnerRights=$ownerDirectRights -bor $ownerInheritedRights

        if(($effectiveOwnerRights -band $requiredReadRights) -ne $requiredReadRights){
            $ownerReadRightsMissingItemCount++
        }

        $rootIndex++
    }

    Write-Output ('ITEM_COUNT='+$totalCount)
    Write-Output ('FILE_COUNT='+$fileCount)
    Write-Output ('DIRECTORY_COUNT='+$directoryCount)
    Write-Output ('ROOT_OWNER_MATCH='+$(if($rootOwnerMatch){'YES'}else{'NO'}))

    Write-Output ('EXACT_OWNER_ITEM_COUNT='+$exactOwnerCount)
    Write-Output ('ADMIN_OWNER_ITEM_COUNT='+$adminOwnerCount)
    Write-Output ('SYSTEM_OWNER_ITEM_COUNT='+$systemOwnerCount)
    Write-Output ('OTHER_OWNER_ITEM_COUNT='+$otherOwnerCount)

    Write-Output ('OWNER_MISMATCH_FILE_COUNT='+$ownerMismatchFileCount)
    Write-Output ('OWNER_MISMATCH_DIRECTORY_COUNT='+$ownerMismatchDirectoryCount)

    Write-Output ('REPARSE_POINT_COUNT='+$reparseCount)
    Write-Output ('DENY_ACE_ITEM_COUNT='+$denyAceItemCount)
    Write-Output ('UNAUTHORIZED_ALLOW_ITEM_COUNT='+$unauthorizedAllowItemCount)
    Write-Output ('OWNER_READ_RIGHTS_MISSING_ITEM_COUNT='+$ownerReadRightsMissingItemCount)

    $policyDrift=(
        $denyAceItemCount -gt 0 -or
        $unauthorizedAllowItemCount -gt 0 -or
        $ownerReadRightsMissingItemCount -gt 0
    )

    $narrowAdminShape=(
        $rootOwnerMatch -and
        $totalCount -eq 2 -and
        $directoryCount -eq 1 -and
        $fileCount -eq 1 -and
        $exactOwnerCount -eq 1 -and
        $adminOwnerCount -eq 1 -and
        $systemOwnerCount -eq 0 -and
        $otherOwnerCount -eq 0 -and
        $ownerMismatchFileCount -eq 1 -and
        $ownerMismatchDirectoryCount -eq 0 -and
        $adminMismatchDirectChildFileCount -eq 1 -and
        $reparseCount -eq 0 -and
        -not $policyDrift
    )

    if($reparseCount -gt 0){
        $classification='REPARSE_OR_UNSAFE_SHAPE'
    }
    elseif($otherOwnerCount -gt 0){
        $classification='OTHER_OWNER_DRIFT'
    }
    elseif($systemOwnerCount -gt 0){
        $classification='SYSTEM_OWNER_DRIFT'
    }
    elseif($policyDrift){
        $classification='ACL_POLICY_DRIFT'
    }
    elseif($narrowAdminShape){
        $classification='ADMIN_OWNER_SINGLE_EXPECTED_FILE_SHAPE'
    }
    elseif($adminOwnerCount -gt 0){
        $classification='ADMIN_OWNER_MULTI_ITEM_DRIFT'
    }
    elseif($exactOwnerCount -eq $totalCount){
        $classification='ACL_CLEAN'
    }
    else {
        $classification='LOCAL_DIAGNOSTIC_EXCEPTION'
    }

    Write-Output ('R12_ACL_STATE='+$classification)
}
catch {
    if($classification -eq 'UNKNOWN'){
        $classification='LOCAL_DIAGNOSTIC_EXCEPTION'
    }

    Write-Output ('DIAGNOSTIC_FAILED_STAGE='+$script:stage)
    Write-Output ('DIAGNOSTIC_EXCEPTION_TYPE='+$_.Exception.GetType().FullName)
    Write-Output ('DIAGNOSTIC_ERROR_LINE='+[string]$_.InvocationInfo.ScriptLineNumber)
    Write-Output ('R12_ACL_STATE='+$classification)
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
