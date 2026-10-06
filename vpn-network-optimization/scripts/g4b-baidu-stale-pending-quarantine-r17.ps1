[CmdletBinding()]
param(
    [ValidateSet('Validate','Run')]
    [string]$Mode='Validate',
    [switch]$OwnerAuthorized,
    [switch]$DefinitionOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

$script:stage='BOOT'
$script:ownerSid=[Security.Principal.WindowsIdentity]::GetCurrent().User
$script:mutationStarted=$false
$script:forwardSourceRemote=''
$script:forwardTargetRemote=''

$runtimeRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$configDir=Join-Path $env:APPDATA 'BaiduPCS-Go'
$remoteDir='/vpn-network-optimization-g4b-recovery'

$archiveUrl='https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v4.0.2/BaiduPCS-Go-v4.0.2-windows-x64.zip'
$archiveSha='ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
$binarySha='e44769b49156fa3f094431da87231021e6874b6519ea82da4b8af0637662576d'

$diagRoot=Join-Path $runtimeRoot ('g4b-r17-baidu-quarantine-'+[guid]::NewGuid().ToString('N'))
$archive=Join-Path $diagRoot 'BaiduPCS-Go-v4.0.2-windows-x64.zip'
$exe=Join-Path $diagRoot 'BaiduPCS-Go.exe'

function Write-Stage {
    param([Parameter(Mandatory=$true)][string]$Name)
    $script:stage=$Name
    Write-Output ('R17_STAGE='+$Name)
}

function Assert-R17 {
    param([bool]$Condition,[Parameter(Mandatory=$true)][string]$Code)
    if(-not $Condition){throw $Code}
}

function New-OwnerAcl {
    param([switch]$Directory)

    if($Directory){
        $acl=[Security.AccessControl.DirectorySecurity]::new()
        $inherit=[Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    } else {
        $acl=[Security.AccessControl.FileSecurity]::new()
        $inherit=[Security.AccessControl.InheritanceFlags]::None
    }

    $acl.SetAccessRuleProtection($true,$false)
    $acl.SetOwner($script:ownerSid)

    [void]$acl.AddAccessRule(
        [Security.AccessControl.FileSystemAccessRule]::new(
            $script:ownerSid,
            [Security.AccessControl.FileSystemRights]::FullControl,
            $inherit,
            [Security.AccessControl.PropagationFlags]::None,
            [Security.AccessControl.AccessControlType]::Allow
        )
    )

    return $acl
}

function Assert-OwnerAcl {
    param([Parameter(Mandatory=$true)][string]$Path)

    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R17 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'OWNER_ACL_REPARSE_POINT'

    $acl=Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-R17 $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'
    Assert-R17 ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $script:ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'
}

function Assert-BaiduConfigAclMetadata {
    param(
        [Parameter(Mandatory=$true)][string]$ActualOwnerSid,
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$ExpectedOwnerSid,
        [Parameter(Mandatory=$true)][object[]]$Rules,
        [Parameter(Mandatory=$true)][bool]$IsDirectory
    )

    Assert-R17 ($ActualOwnerSid -ceq $ExpectedOwnerSid.Value) 'BAIDU_AUTH_CONFIG_OWNER_MISMATCH'
    $allowedSids=@($ExpectedOwnerSid.Value,'S-1-5-18','S-1-5-32-544')
    $ownerDirectRights=[long]0
    $ownerInheritedRights=[long]0

    foreach($rule in $Rules){
        Assert-R17 ($null -ne $rule) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'
        $identityProperty=$rule.PSObject.Properties['IdentityReference']
        $typeProperty=$rule.PSObject.Properties['AccessControlType']
        $inheritedProperty=$rule.PSObject.Properties['IsInherited']
        $rightsProperty=$rule.PSObject.Properties['FileSystemRights']
        $propagationProperty=$rule.PSObject.Properties['PropagationFlags']

        Assert-R17 (
            $null -ne $identityProperty -and
            $null -ne $identityProperty.Value -and
            $null -ne $typeProperty -and
            $null -ne $inheritedProperty -and
            $null -ne $rightsProperty -and
            $null -ne $propagationProperty
        ) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'

        $sidProperty=$identityProperty.Value.PSObject.Properties['Value']
        Assert-R17 (
            $identityProperty.Value -is [Security.Principal.SecurityIdentifier] -and
            $null -ne $sidProperty -and
            -not [string]::IsNullOrWhiteSpace([string]$sidProperty.Value) -and
            $inheritedProperty.Value -is [bool] -and
            $typeProperty.Value -is [Security.AccessControl.AccessControlType] -and
            $rightsProperty.Value -is [Security.AccessControl.FileSystemRights] -and
            $propagationProperty.Value -is [Security.AccessControl.PropagationFlags]
        ) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'

        $ruleSid=[string]$sidProperty.Value
        $isInherited=[bool]$inheritedProperty.Value

        if($typeProperty.Value -eq [Security.AccessControl.AccessControlType]::Deny){
            throw 'BAIDU_AUTH_CONFIG_DENY_ACE'
        }

        Assert-R17 ($typeProperty.Value -eq [Security.AccessControl.AccessControlType]::Allow) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'
        Assert-R17 ($ruleSid -in $allowedSids) 'BAIDU_AUTH_CONFIG_UNAUTHORIZED_ALLOW'

        if(
            $ruleSid -ceq $ExpectedOwnerSid.Value -and
            (([long]$propagationProperty.Value -band [long][Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0)
        ){
            if($isInherited){
                $ownerInheritedRights=$ownerInheritedRights -bor [long]$rightsProperty.Value
            }
            else {
                $ownerDirectRights=$ownerDirectRights -bor [long]$rightsProperty.Value
            }
        }
    }

    if($IsDirectory){
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
    Assert-R17 (($effectiveOwnerRights -band $requiredReadRights) -eq $requiredReadRights) 'BAIDU_AUTH_CONFIG_OWNER_READ_RIGHTS_MISSING'
}

function Assert-SafeBaiduConfigDirectory {
    param(
        [Parameter(Mandatory=$true)][string]$ConfigDirectory,
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$OwnerSid
    )

    Assert-R17 (Test-Path -LiteralPath $ConfigDirectory -PathType Container) 'BAIDU_AUTH_CONFIG_NOT_DIRECTORY'

    $items=[Collections.Generic.List[IO.FileSystemInfo]]::new()
    $items.Add((Get-Item -LiteralPath $ConfigDirectory -Force -ErrorAction Stop))
    foreach($child in @(Get-ChildItem -LiteralPath $ConfigDirectory -Force -Recurse -ErrorAction Stop)){
        $items.Add($child)
    }

    Assert-R17 ($items.Count -le 4096) 'BAIDU_CONFIG_ENTRY_LIMIT_EXCEEDED'

    foreach($item in $items){
        Assert-R17 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_AUTH_CONFIG_REPARSE_POINT'
        $acl=Get-Acl -LiteralPath $item.FullName -ErrorAction Stop
        $actualOwnerSid=$acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
        $rules=@($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
        Assert-BaiduConfigAclMetadata -ActualOwnerSid $actualOwnerSid -ExpectedOwnerSid $OwnerSid -Rules $rules -IsDirectory ([bool]$item.PSIsContainer)
    }
}

function Get-SafeProcessResult {
    param(
        [Parameter(Mandatory=$true)][ValidateSet('who','ls','mv')][string]$Action,
        [string[]]$Arguments=@()
    )

    switch($Action){
        'who' { Assert-R17 ($Arguments.Count -eq 0) 'R17_WHO_ARGUMENT_SHAPE_INVALID' }
        'ls' {
            Assert-R17 (
                $Arguments.Count -eq 2 -and
                $Arguments[0] -ceq '-l' -and
                $Arguments[1] -ceq $remoteDir
            ) 'R17_LS_ARGUMENT_SHAPE_INVALID'
        }
        'mv' {
            Assert-R17 (
                -not [string]::IsNullOrEmpty($script:forwardSourceRemote) -and
                -not [string]::IsNullOrEmpty($script:forwardTargetRemote)
            ) 'R17_MV_BOUNDARY_NOT_INITIALIZED'
            $forwardShape=(
                $Arguments.Count -eq 2 -and
                $Arguments[0] -ceq $script:forwardSourceRemote -and
                $Arguments[1] -ceq $script:forwardTargetRemote
            )
            $rollbackShape=(
                $Arguments.Count -eq 2 -and
                $Arguments[0] -ceq $script:forwardTargetRemote -and
                $Arguments[1] -ceq $script:forwardSourceRemote
            )
            Assert-R17 ($forwardShape -or $rollbackShape) 'R17_MV_ARGUMENT_SHAPE_INVALID'
        }
    }

    $psi=[Diagnostics.ProcessStartInfo]::new()
    $psi.FileName=$exe
    $psi.UseShellExecute=$false
    $psi.RedirectStandardOutput=$true
    $psi.RedirectStandardError=$true
    $psi.CreateNoWindow=$true

    $utf8=[Text.UTF8Encoding]::new($false)
    $psi.StandardOutputEncoding=$utf8
    $psi.StandardErrorEncoding=$utf8

    [void]$psi.ArgumentList.Add($Action)
    foreach($arg in $Arguments){
        [void]$psi.ArgumentList.Add([string]$arg)
    }

    foreach($key in @($psi.Environment.Keys)){
        if([string]$key -match '(?i)bduss|stoken|ptoken|cookie|password|credential|auth|secret|token'){
            [void]$psi.Environment.Remove([string]$key)
        }
    }

    $psi.Environment['BAIDUPCS_GO_CONFIG_DIR']=$configDir
    $psi.Environment['BAIDUPCS_GO_VERBOSE']='0'

    $p=[Diagnostics.Process]::new()
    try {
        $p.StartInfo=$psi
        Assert-R17 ($p.Start()) 'BAIDU_PROCESS_START_FAILED'

        $outTask=$p.StandardOutput.ReadToEndAsync()
        $errTask=$p.StandardError.ReadToEndAsync()

        if(-not $p.WaitForExit(120000)){
            try{$p.Kill($true)}catch{}
            throw 'BAIDU_PROCESS_TIMEOUT'
        }

        return @{
            ExitCode=[int]$p.ExitCode
            StdOut=[string]$outTask.GetAwaiter().GetResult()
            StdErr=[string]$errTask.GetAwaiter().GetResult()
        }
    }
    finally {
        $p.Dispose()
    }
}

function Get-SafeRemoteClass {
    param([string]$StdOut,[string]$StdErr)

    $combined=([string]$StdOut)+[Environment]::NewLine+([string]$StdErr)
    if($combined -match '(?i)not.?login|未登录|登录.*失效|login.*expired'){return 'AUTH_NOT_READY'}
    if($combined -match '(?i)not.?found|不存在|找不到|no such'){return 'REMOTE_PATH_NOT_FOUND'}
    if($combined -match '(?i)timeout|超时'){return 'TIMEOUT_REPORTED'}
    if($combined -match '(?i)network|connection|网络|连接'){return 'NETWORK_REPORTED'}
    if($combined -match '(?i)permission|denied|权限'){return 'PERMISSION_REPORTED'}
    if($combined -match '(?i)rate|limit|频繁|限流'){return 'RATE_LIMIT_REPORTED'}
    return 'UNCLASSIFIED_REMOTE_OUTPUT'
}

function Assert-R17DirectoryHeader {
    param([Parameter(Mandatory=$true)][string]$Listing)
    $headerPattern='(?m)^当前目录:\s*'+[regex]::Escape($remoteDir)+'\s*(?=\r?\n|\z)'
    Assert-R17 ([regex]::IsMatch($Listing,$headerPattern)) 'BAIDU_DIRECTORY_HEADER_INVALID'
}

function Get-R17ListingState {
    param(
        [Parameter(Mandatory=$true)][string]$Listing,
        [string]$SourceName='',
        [string]$QuarantineName=''
    )

    $finalPattern='(?m)^(?:[^\r\n]*[ \t])?vpn-network-optimization-g4b\.vpr1[ \t]*(?=\r?\n|\z)'
    $pendingPattern='(?m)^(?:[^\r\n]*[ \t])?(?<name>vpn-network-optimization-g4b-(?<run>[0-9a-f]{32})\.vpr1\.pending)[ \t]*(?=\r?\n|\z)'
    $projectPattern='(?m)^(?:[^\r\n]*[ \t])?(?<name>vpn-network-optimization-g4b[^\s/]*)(?<projectDirectory>/)?[ \t]*(?=\r?\n|\z)'

    $finalCount=[regex]::Matches($Listing,$finalPattern).Count
    $pendingMatches=[regex]::Matches($Listing,$pendingPattern)
    $pendingCount=$pendingMatches.Count
    $projectMatches=[regex]::Matches($Listing,$projectPattern)
    $unknownCount=[Math]::Max(0,$projectMatches.Count-$finalCount-$pendingCount)

    $singlePendingName=''
    $singleRunId=''
    if($pendingCount -eq 1){
        $singlePendingName=$pendingMatches[0].Groups['name'].Value
        $singleRunId=$pendingMatches[0].Groups['run'].Value
    }

    $sourceObjectCount=0
    $sourceFileCount=0
    $sourceDirectoryCount=0
    if(-not [string]::IsNullOrEmpty($SourceName)){
        $sourcePattern='(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($SourceName)+'(?<directory>/)?[ \t]*(?=\r?\n|\z)'
        $sourceMatches=[regex]::Matches($Listing,$sourcePattern)
        $sourceObjectCount=$sourceMatches.Count
        foreach($match in $sourceMatches){
            if($match.Groups['directory'].Success){$sourceDirectoryCount++}else{$sourceFileCount++}
        }
    }

    $quarantineObjectCount=0
    $quarantineFileCount=0
    $quarantineDirectoryCount=0
    if(-not [string]::IsNullOrEmpty($QuarantineName)){
        $quarantinePattern='(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($QuarantineName)+'(?<directory>/)?[ \t]*(?=\r?\n|\z)'
        $quarantineMatches=[regex]::Matches($Listing,$quarantinePattern)
        $quarantineObjectCount=$quarantineMatches.Count
        foreach($match in $quarantineMatches){
            if($match.Groups['directory'].Success){$quarantineDirectoryCount++}else{$quarantineFileCount++}
        }
    }

    return @{
        FinalCount=$finalCount
        PendingCount=$pendingCount
        UnknownCount=$unknownCount
        SinglePendingName=$singlePendingName
        SingleRunId=$singleRunId
        SourceCount=$sourceFileCount
        SourceObjectCount=$sourceObjectCount
        SourceDirectoryCount=$sourceDirectoryCount
        QuarantineCount=$quarantineFileCount
        QuarantineObjectCount=$quarantineObjectCount
        QuarantineDirectoryCount=$quarantineDirectoryCount
    }
}

function Get-R17Listing {
    $result=Get-SafeProcessResult -Action 'ls' -Arguments @('-l',$remoteDir)
    if([int]$result['ExitCode'] -ne 0){
        Write-Output ('R17_REMOTE_ERROR_CLASS='+(Get-SafeRemoteClass -StdOut ([string]$result['StdOut']) -StdErr ([string]$result['StdErr'])))
        throw 'BAIDU_LS_READ_FAILED'
    }
    $listing=[string]$result['StdOut']
    Assert-R17DirectoryHeader -Listing $listing
    return $listing
}

function Invoke-R17Rollback {
    param(
        [Parameter(Mandatory=$true)][string]$SourceRemote,
        [Parameter(Mandatory=$true)][string]$TargetRemote,
        [Parameter(Mandatory=$true)][string]$SourceName,
        [Parameter(Mandatory=$true)][string]$QuarantineName
    )

    Write-Output 'R17_ROLLBACK_ATTEMPT=YES'

    $beforeListing=$null
    try {
        $beforeListing=Get-R17Listing
    }
    catch {
        Write-Output 'R17_ROLLBACK_PRECHECK=UNAVAILABLE'
        return $false
    }

    $before=Get-R17ListingState -Listing $beforeListing -SourceName $SourceName -QuarantineName $QuarantineName

    $baselineAlreadyPresent=(
        [int]$before['FinalCount'] -eq 0 -and
        [int]$before['PendingCount'] -eq 1 -and
        [int]$before['UnknownCount'] -eq 0 -and
        [int]$before['SourceCount'] -eq 1 -and
        [int]$before['SourceObjectCount'] -eq 1 -and
        [int]$before['SourceDirectoryCount'] -eq 0 -and
        [int]$before['QuarantineObjectCount'] -eq 0
    )

    if($baselineAlreadyPresent){
        Write-Output 'R17_ROLLBACK_PRECHECK=BASELINE_ALREADY_PRESENT'
        Write-Output 'R17_ROLLBACK_READBACK=PASS'
        return $true
    }

    $rollbackShape=(
        [int]$before['FinalCount'] -eq 0 -and
        [int]$before['PendingCount'] -eq 0 -and
        [int]$before['UnknownCount'] -eq 0 -and
        [int]$before['SourceObjectCount'] -eq 0 -and
        [int]$before['QuarantineCount'] -eq 1 -and
        [int]$before['QuarantineObjectCount'] -eq 1 -and
        [int]$before['QuarantineDirectoryCount'] -eq 0
    )

    if(-not $rollbackShape){
        Write-Output 'R17_ROLLBACK_PRECHECK=AMBIGUOUS'
        return $false
    }

    Write-Output 'R17_ROLLBACK_PRECHECK=PASS'
    $rb=Get-SafeProcessResult -Action 'mv' -Arguments @($TargetRemote,$SourceRemote)

    $afterListing=$null
    try {
        $afterListing=Get-R17Listing
    }
    catch {
        Write-Output 'R17_ROLLBACK_READBACK=FAIL'
        return $false
    }

    $after=Get-R17ListingState -Listing $afterListing -SourceName $SourceName -QuarantineName $QuarantineName
    $restored=(
        [int]$rb['ExitCode'] -eq 0 -and
        [int]$after['FinalCount'] -eq 0 -and
        [int]$after['PendingCount'] -eq 1 -and
        [int]$after['UnknownCount'] -eq 0 -and
        [int]$after['SourceCount'] -eq 1 -and
        [int]$after['SourceObjectCount'] -eq 1 -and
        [int]$after['SourceDirectoryCount'] -eq 0 -and
        [int]$after['QuarantineObjectCount'] -eq 0
    )

    if($restored){
        Write-Output 'R17_ROLLBACK_READBACK=PASS'
        return $true
    }

    if([int]$rb['ExitCode'] -ne 0){
        Write-Output ('R17_ROLLBACK_REMOTE_ERROR_CLASS='+(Get-SafeRemoteClass -StdOut ([string]$rb['StdOut']) -StdErr ([string]$rb['StdErr'])))
    }

    Write-Output 'R17_ROLLBACK_READBACK=FAIL'
    return $false
}

function Invoke-R17Validate {
    Write-Output 'R17_VALIDATION=PASS'
    Write-Output 'R17_DEFAULT_MODE=NON_MUTATING'
    Write-Output 'R17_PROVIDER_COMMAND_ALLOWLIST=WHO_LS_MV_ONLY'
    Write-Output 'R17_FORWARD_LIMIT=ONE_MV'
    Write-Output 'R17_ROLLBACK_LIMIT=ONE_MV_IF_REQUIRED'
    Write-Output 'BAIDU_PERMANENT_DELETE=NO'
    Write-Output 'BAIDU_PROVIDER_ACTION=NO'
    Write-Output 'SSH_OR_VPS_ACTION=NO'
    Write-Output 'RECOVERY_READ_OR_WRITE=NO'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output 'STOP_AT_REVIEWER=YES'
}

function Invoke-R17Run {
    Assert-R17 $OwnerAuthorized.IsPresent 'R17_OWNER_AUTHORIZATION_REQUIRED'

    $cleanupPass=$false
    $expectedUid=$null
    $who=$null
    $sourceName=''
    $runId=''
    $quarantineName=''
    $sourceRemote=''
    $targetRemote=''
    $resultCode='RETURN_R17_UNCLASSIFIED'
    $forwardBaselineKnown=$false

    try {
        Write-Stage 'OWNER_RUNTIME'
        Assert-R17 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
        Assert-R17 (Test-Path -LiteralPath $runtimeRoot -PathType Container) 'RUNTIME_ROOT_MISSING'
        Write-Output 'OWNER_RUNTIME=PASS'

        Write-Stage 'BAIDU_CONFIG_ACL'
        Assert-SafeBaiduConfigDirectory -ConfigDirectory $configDir -OwnerSid $script:ownerSid
        Write-Output 'BAIDU_CONFIG_ACL=PASS'

        Write-Stage 'PINNED_CLI_PREPARE'
        Assert-R17 (-not (Test-Path -LiteralPath $diagRoot)) 'DIAGNOSTIC_RUNTIME_COLLISION'
        [void][IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory),$diagRoot)
        Assert-OwnerAcl -Path $diagRoot

        $oldProgress=$ProgressPreference
        try {
            $ProgressPreference='SilentlyContinue'
            [void](Invoke-WebRequest -Uri $archiveUrl -OutFile $archive -TimeoutSec 120 -ErrorAction Stop)
        }
        finally {
            $ProgressPreference=$oldProgress
        }

        Assert-R17 (Test-Path -LiteralPath $archive -PathType Leaf) 'BAIDU_CLI_ARCHIVE_MISSING'
        Assert-R17 ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $archiveSha) 'BAIDU_CLI_ARCHIVE_HASH_INVALID'

        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
        $zip=$null
        $entryStream=$null
        $outStream=$null
        try {
            $zip=[IO.Compression.ZipFile]::OpenRead($archive)
            $entries=@($zip.Entries | Where-Object {[IO.Path]::GetFileName($_.FullName) -ceq 'BaiduPCS-Go.exe'})
            Assert-R17 ($entries.Count -eq 1) 'BAIDU_CLI_ARCHIVE_ENTRY_INVALID'
            Assert-R17 ($entries[0].Length -gt 0 -and $entries[0].Length -le 64MB) 'BAIDU_CLI_ARCHIVE_ENTRY_SIZE_INVALID'
            $entryStream=$entries[0].Open()
            $outStream=[IO.File]::Open($exe,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
            $entryStream.CopyTo($outStream)
        }
        finally {
            if($outStream){$outStream.Dispose()}
            if($entryStream){$entryStream.Dispose()}
            if($zip){$zip.Dispose()}
        }

        Set-Acl -LiteralPath $exe -AclObject (New-OwnerAcl) -ErrorAction Stop
        Assert-R17 ((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $binarySha) 'BAIDU_CLI_BINARY_HASH_INVALID'
        Write-Output 'BAIDU_PINNED_CLI=PASS'

        Write-Stage 'EXPECTED_UID_INPUT'
        $uidSecure=Read-Host 'Enter expected Baidu UID for R17 quarantine reconciliation (input hidden)' -AsSecureString
        $ptr=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($uidSecure)
        try {
            $expectedUid=[Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
        }
        finally {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
            $uidSecure.Dispose()
        }
        Assert-R17 ($expectedUid -match '^[1-9][0-9]{0,19}$') 'BAIDU_EXPECTED_ACCOUNT_ID_INVALID'
        Write-Output 'EXPECTED_UID_INPUT=READY'

        Write-Stage 'BAIDU_WHO'
        $who=Get-SafeProcessResult -Action 'who'
        if([int]$who['ExitCode'] -ne 0){
            Write-Output ('R17_REMOTE_ERROR_CLASS='+(Get-SafeRemoteClass -StdOut ([string]$who['StdOut']) -StdErr ([string]$who['StdErr'])))
            throw 'BAIDU_WHO_READ_FAILED'
        }
        Write-Output 'BAIDU_WHO_PROCESS=PASS'

        $uidMatches=[regex]::Matches([string]$who['StdOut'],'(?m)^当前帐号 uid:\s*([0-9]+),')
        Assert-R17 ($uidMatches.Count -eq 1) 'BAIDU_UID_OUTPUT_AMBIGUOUS'
        Write-Output 'BAIDU_UID_PARSE=PASS'
        Assert-R17 ($uidMatches[0].Groups[1].Value -ceq $expectedUid) 'BAIDU_UID_MISMATCH'
        Write-Output 'BAIDU_UID_MATCH=PASS'

        Write-Stage 'R17_PRECHECK'
        $listing=Get-R17Listing
        $pre=Get-R17ListingState -Listing $listing

        Assert-R17 (
            [int]$pre['FinalCount'] -eq 0 -and
            [int]$pre['PendingCount'] -eq 1 -and
            [int]$pre['UnknownCount'] -eq 0
        ) 'R17_PRECHECK_PRODUCTION_STATE_DRIFT'

        $sourceName=[string]$pre['SinglePendingName']
        $runId=[string]$pre['SingleRunId']
        Assert-R17 ($sourceName -match '^vpn-network-optimization-g4b-[0-9a-f]{32}\.vpr1\.pending$') 'R17_SOURCE_NAME_INVALID'
        Assert-R17 ($runId -match '^[0-9a-f]{32}$') 'R17_RUN_ID_INVALID'

        $quarantineName='r17-quarantine-'+$runId+'.vpr1.pending'
        Assert-R17 ($quarantineName -match '^r17-quarantine-[0-9a-f]{32}\.vpr1\.pending$') 'R17_QUARANTINE_NAME_INVALID'
        Assert-R17 (-not $quarantineName.StartsWith('vpn-network-optimization-g4b')) 'R17_QUARANTINE_NAMESPACE_INVALID'

        $preExact=Get-R17ListingState -Listing $listing -SourceName $sourceName -QuarantineName $quarantineName
        Assert-R17 (
            [int]$preExact['SourceCount'] -eq 1 -and
            [int]$preExact['SourceObjectCount'] -eq 1 -and
            [int]$preExact['SourceDirectoryCount'] -eq 0
        ) 'R17_SOURCE_CARDINALITY_INVALID'
        Assert-R17 ([int]$preExact['QuarantineObjectCount'] -eq 0) 'R17_QUARANTINE_TARGET_COLLISION'

        $sourceRemote=$remoteDir+'/'+$sourceName
        $targetRemote=$remoteDir+'/'+$quarantineName
        $script:forwardSourceRemote=$sourceRemote
        $script:forwardTargetRemote=$targetRemote
        $forwardBaselineKnown=$true

        Write-Output 'R17_PRECHECK=PASS'
        Write-Output 'R17_SOURCE_STATE=ONE_PENDING'
        Write-Output 'R17_QUARANTINE_TARGET_PRECHECK=ABSENT'

        Write-Stage 'R17_FORWARD_MOVE'
        $script:mutationStarted=$true
        Write-Output 'R17_REMOTE_MUTATION=MV_TO_QUARANTINE'
        $forward=Get-SafeProcessResult -Action 'mv' -Arguments @($sourceRemote,$targetRemote)

        $postReadOk=$true
        $postListing=$null
        try {
            $postListing=Get-R17Listing
        }
        catch {
            $postReadOk=$false
        }

        if($postReadOk){
            $post=Get-R17ListingState -Listing $postListing -SourceName $sourceName -QuarantineName $quarantineName
            $success=(
                [int]$forward['ExitCode'] -eq 0 -and
                [int]$post['FinalCount'] -eq 0 -and
                [int]$post['PendingCount'] -eq 0 -and
                [int]$post['UnknownCount'] -eq 0 -and
                [int]$post['SourceObjectCount'] -eq 0 -and
                [int]$post['QuarantineCount'] -eq 1 -and
                [int]$post['QuarantineObjectCount'] -eq 1 -and
                [int]$post['QuarantineDirectoryCount'] -eq 0
            )

            if($success){
                Write-Output 'R17_SOURCE_AFTER=ABSENT'
                Write-Output 'R17_QUARANTINE_AFTER=PRESENT'
                Write-Output 'PROJECT_FINAL_COUNT_AFTER=0'
                Write-Output 'PROJECT_PENDING_COUNT_AFTER=0'
                Write-Output 'PROJECT_UNKNOWN_COUNT_AFTER=0'
                Write-Output 'R17_ROLLBACK_REQUIRED=NO'
                $resultCode='PASS_CANDIDATE'
            }
            else {
                $baselineStillPresent=(
                    [int]$post['FinalCount'] -eq 0 -and
                    [int]$post['PendingCount'] -eq 1 -and
                    [int]$post['UnknownCount'] -eq 0 -and
                    [int]$post['SourceCount'] -eq 1 -and
                    [int]$post['SourceObjectCount'] -eq 1 -and
                    [int]$post['SourceDirectoryCount'] -eq 0 -and
                    [int]$post['QuarantineObjectCount'] -eq 0
                )

                if($baselineStillPresent){
                    $resultCode='RETURN_FORWARD_NOT_COMMITTED'
                }
                else {
                    $rollbackSequence=@(Invoke-R17Rollback -SourceRemote $sourceRemote -TargetRemote $targetRemote -SourceName $sourceName -QuarantineName $quarantineName)
                    Assert-R17 ($rollbackSequence.Count -ge 1) 'R17_ROLLBACK_RESULT_MISSING'
                    $rollbackTail=$rollbackSequence[$rollbackSequence.Count-1]
                    Assert-R17 ($rollbackTail -is [bool]) 'R17_ROLLBACK_RESULT_TYPE_INVALID'
                    if($rollbackSequence.Count -gt 1){
                        for($rollbackIndex=0; $rollbackIndex -lt ($rollbackSequence.Count-1); $rollbackIndex++){
                            Write-Output ([string]$rollbackSequence[$rollbackIndex])
                        }
                    }
                    $rollbackOk=[bool]$rollbackTail
                    if($rollbackOk){
                        $resultCode='RETURN_FORWARD_FAILED_ROLLED_BACK'
                    }
                    else {
                        $resultCode='ROLLBACK_FAILED'
                    }
                }
            }
        }
        else {
            $rollbackSequence=@(Invoke-R17Rollback -SourceRemote $sourceRemote -TargetRemote $targetRemote -SourceName $sourceName -QuarantineName $quarantineName)
            Assert-R17 ($rollbackSequence.Count -ge 1) 'R17_ROLLBACK_RESULT_MISSING'
            $rollbackTail=$rollbackSequence[$rollbackSequence.Count-1]
            Assert-R17 ($rollbackTail -is [bool]) 'R17_ROLLBACK_RESULT_TYPE_INVALID'
            if($rollbackSequence.Count -gt 1){
                for($rollbackIndex=0; $rollbackIndex -lt ($rollbackSequence.Count-1); $rollbackIndex++){
                    Write-Output ([string]$rollbackSequence[$rollbackIndex])
                }
            }
            $rollbackOk=[bool]$rollbackTail
            if($rollbackOk){
                $resultCode='RETURN_POSTREAD_FAILED_ROLLED_BACK'
            }
            else {
                $resultCode='ROLLBACK_FAILED'
            }
        }

        Write-Output ('R17_RESULT='+$resultCode)
    }
    catch {
        if($script:mutationStarted -and $forwardBaselineKnown -and $resultCode -eq 'RETURN_R17_UNCLASSIFIED'){
            try {
                $rollbackSequence=@(Invoke-R17Rollback -SourceRemote $sourceRemote -TargetRemote $targetRemote -SourceName $sourceName -QuarantineName $quarantineName)
                Assert-R17 ($rollbackSequence.Count -ge 1) 'R17_ROLLBACK_RESULT_MISSING'
                $rollbackTail=$rollbackSequence[$rollbackSequence.Count-1]
                Assert-R17 ($rollbackTail -is [bool]) 'R17_ROLLBACK_RESULT_TYPE_INVALID'
                if($rollbackSequence.Count -gt 1){
                    for($rollbackIndex=0; $rollbackIndex -lt ($rollbackSequence.Count-1); $rollbackIndex++){
                        Write-Output ([string]$rollbackSequence[$rollbackIndex])
                    }
                }
                $rollbackOk=[bool]$rollbackTail
                if($rollbackOk){
                    $resultCode='RETURN_EXCEPTION_ROLLED_BACK'
                }
                else {
                    $resultCode='ROLLBACK_FAILED'
                }
            }
            catch {
                $resultCode='ROLLBACK_FAILED'
            }
        }
        elseif($resultCode -eq 'RETURN_R17_UNCLASSIFIED'){
            $message=[string]$_.Exception.Message
            if($message -match '^[A-Z][A-Z0-9_]{1,95}$'){
                $resultCode=$message
            }
            else {
                $resultCode='LOCAL_R17_EXCEPTION'
            }
        }

        Write-Output ('R17_FAILED_STAGE='+$script:stage)
        Write-Output ('R17_EXCEPTION_TYPE='+$_.Exception.GetType().FullName)
        Write-Output ('R17_ERROR_LINE='+[string]$_.InvocationInfo.ScriptLineNumber)
        Write-Output ('R17_RESULT='+$resultCode)
    }
    finally {
        $expectedUid=$null
        $who=$null
        $uidMatches=$null
        $script:forwardSourceRemote=''
        $script:forwardTargetRemote=''
        $sourceName=''
        $runId=''
        $quarantineName=''
        $sourceRemote=''
        $targetRemote=''

        if(Test-Path -LiteralPath $diagRoot -PathType Container){
            try {
                Assert-OwnerAcl -Path $diagRoot
                Remove-Item -LiteralPath $diagRoot -Recurse -Force -ErrorAction Stop
                $cleanupPass=(-not (Test-Path -LiteralPath $diagRoot))
            }
            catch {
                $cleanupPass=$false
            }
        }
        else {
            $cleanupPass=$true
        }

        Write-Output ('TEMP_RUNTIME_CLEANUP='+$(if($cleanupPass){'PASS'}else{'FAIL'}))
        Write-Output ('R17_CONSEQUENTIAL_MUTATION_STARTED='+$(if($script:mutationStarted){'YES'}else{'NO'}))
        Write-Output 'BAIDU_PERMANENT_DELETE=NO'
        Write-Output 'R15_ROLLBACK_JOURNAL_ACTION=NONE'
        Write-Output 'SSH_OR_VPS_ACTION=NO'
        Write-Output 'RECOVERY_READ_OR_WRITE=NO'
        Write-Output 'NETWORK_MUTATION=NO'
        Write-Output 'SECRET_VALUES_EMITTED=0'
        Write-Output 'STOP_AT_REVIEWER=YES'
    }
}

if($DefinitionOnly){
    return
}

if($Mode -ceq 'Validate'){
    Invoke-R17Validate
}
else {
    Invoke-R17Run
}
