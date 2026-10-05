[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:stage='BOOT'
$script:ownerSid=[Security.Principal.WindowsIdentity]::GetCurrent().User
$runtimeRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$configDir=Join-Path $env:APPDATA 'BaiduPCS-Go'
$remoteDir='/vpn-network-optimization-g4b-recovery'
$archiveUrl='https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v4.0.2/BaiduPCS-Go-v4.0.2-windows-x64.zip'
$archiveSha='ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
$binarySha='e44769b49156fa3f094431da87231021e6874b6519ea82da4b8af0637662576d'
$diagRoot=Join-Path $runtimeRoot ('g4b-baidu-readonly-diag-'+[guid]::NewGuid().ToString('N'))
$archive=Join-Path $diagRoot 'BaiduPCS-Go-v4.0.2-windows-x64.zip'
$exe=Join-Path $diagRoot 'BaiduPCS-Go.exe'
$cleanupPass=$false
$classification='UNKNOWN'

function Write-Stage {
    param([string]$Name)
    $script:stage=$Name
    Write-Output ('DIAGNOSTIC_STAGE='+$Name)
}

function Assert-Diagnostic {
    param([bool]$Condition,[string]$Code)
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
    [void]$acl.AddAccessRule([Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inherit,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    ))
    return $acl
}

function Assert-OwnerAcl {
    param([string]$Path)
    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-Diagnostic (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'OWNER_ACL_REPARSE_POINT'
    $acl=Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-Diagnostic $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'
    Assert-Diagnostic ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $script:ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'
}

function Get-SafeProcessResult {
    param(
        [Parameter(Mandatory=$true)][string]$Action,
        [string[]]$Arguments=@()
    )

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
    foreach($arg in $Arguments){[void]$psi.ArgumentList.Add([string]$arg)}

    $keys=@($psi.Environment.Keys)
    foreach($key in $keys){
        if([string]$key -match '(?i)bduss|stoken|ptoken|cookie|password|credential|auth|secret|token'){
            [void]$psi.Environment.Remove([string]$key)
        }
    }
    $psi.Environment['BAIDUPCS_GO_CONFIG_DIR']=$configDir
    $psi.Environment['BAIDUPCS_GO_VERBOSE']='0'

    $p=[Diagnostics.Process]::new()
    $stdout=$null
    $stderr=$null
    try {
        $p.StartInfo=$psi
        Assert-Diagnostic ($p.Start()) 'BAIDU_DIAG_PROCESS_START_FAILED'
        $outTask=$p.StandardOutput.ReadToEndAsync()
        $errTask=$p.StandardError.ReadToEndAsync()
        if(-not $p.WaitForExit(120000)){
            try{$p.Kill($true)}catch{}
            throw 'BAIDU_DIAG_PROCESS_TIMEOUT'
        }
        $stdout=$outTask.GetAwaiter().GetResult()
        $stderr=$errTask.GetAwaiter().GetResult()
        return @{
            ExitCode=[int]$p.ExitCode
            StdOut=[string]$stdout
            StdErr=[string]$stderr
        }
    }
    finally {
        $p.Dispose()
    }
}

function Get-SafeErrorClass {
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

try {
    Write-Stage 'OWNER_RUNTIME'
    Assert-Diagnostic ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-Diagnostic (Test-Path -LiteralPath $runtimeRoot -PathType Container) 'RUNTIME_ROOT_MISSING'
    Write-Output 'OWNER_RUNTIME=PASS'

    Write-Stage 'BAIDU_CONFIG_ACL'
    Assert-Diagnostic (Test-Path -LiteralPath $configDir -PathType Container) 'BAIDU_AUTH_CONFIG_MISSING'
    $unsafe=@('S-1-1-0','S-1-5-11','S-1-5-32-545')
    $items=[Collections.Generic.List[IO.FileSystemInfo]]::new()
    $items.Add((Get-Item -LiteralPath $configDir -Force -ErrorAction Stop))
    foreach($child in @(Get-ChildItem -LiteralPath $configDir -Force -Recurse -ErrorAction Stop)){$items.Add($child)}
    foreach($item in $items){
        Assert-Diagnostic (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_AUTH_CONFIG_REPARSE_POINT'
        $acl=Get-Acl -LiteralPath $item.FullName -ErrorAction Stop
        Assert-Diagnostic ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $script:ownerSid.Value) 'BAIDU_AUTH_CONFIG_OWNER_MISMATCH'
        foreach($rule in @($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))){
            if($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow){
                Assert-Diagnostic ($rule.IdentityReference.Value -notin $unsafe) 'BAIDU_AUTH_CONFIG_BROAD_ACCESS'
            }
        }
    }
    Write-Output 'BAIDU_CONFIG_ACL=PASS'

    Write-Stage 'PINNED_CLI_PREPARE'
    Assert-Diagnostic (-not (Test-Path -LiteralPath $diagRoot)) 'DIAGNOSTIC_RUNTIME_COLLISION'
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
    Assert-Diagnostic (Test-Path -LiteralPath $archive -PathType Leaf) 'BAIDU_CLI_ARCHIVE_MISSING'
    Assert-Diagnostic ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $archiveSha) 'BAIDU_CLI_ARCHIVE_HASH_INVALID'

    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    $zip=$null;$entryStream=$null;$outStream=$null
    try {
        $zip=[IO.Compression.ZipFile]::OpenRead($archive)
        $entries=@($zip.Entries | Where-Object {[IO.Path]::GetFileName($_.FullName) -ceq 'BaiduPCS-Go.exe'})
        Assert-Diagnostic ($entries.Count -eq 1) 'BAIDU_CLI_ARCHIVE_ENTRY_INVALID'
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
    Assert-Diagnostic ((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $binarySha) 'BAIDU_CLI_BINARY_HASH_INVALID'
    Write-Output 'BAIDU_PINNED_CLI=PASS'

    Write-Stage 'EXPECTED_UID_INPUT'
    $uidSecure=Read-Host 'Enter expected Baidu UID for read-only diagnostic (input hidden)' -AsSecureString
    $ptr=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($uidSecure)
    try{$expectedUid=[Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)}
    finally{[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr);$uidSecure.Dispose()}
    Assert-Diagnostic ($expectedUid -match '^[1-9][0-9]{0,19}$') 'BAIDU_EXPECTED_ACCOUNT_ID_INVALID'
    Write-Output 'EXPECTED_UID_INPUT=READY'

    Write-Stage 'BAIDU_WHO_PROCESS'
    $who=Get-SafeProcessResult -Action 'who'
    Write-Stage 'BAIDU_WHO_RESULT'
    Assert-Diagnostic ($who -is [System.Collections.IDictionary]) 'BAIDU_WHO_RESULT_SHAPE_INVALID'
    Assert-Diagnostic ($who.Contains('ExitCode') -and $who.Contains('StdOut') -and $who.Contains('StdErr')) 'BAIDU_WHO_RESULT_KEYS_MISSING'
    if([int]$who['ExitCode'] -ne 0){
        Write-Output 'BAIDU_WHO_PROCESS=FAIL'
        Write-Output 'BAIDU_WHO_UID_PARSE=NOT_AVAILABLE'
        Write-Output 'BAIDU_WHO_UID_MATCH=NOT_AVAILABLE'
        $classification='WHO_'+(Get-SafeErrorClass -StdOut ([string]$who['StdOut']) -StdErr ([string]$who['StdErr']))
        throw 'BAIDU_WHO_READONLY_FAILED'
    }
    Write-Output 'BAIDU_WHO_PROCESS=PASS'
    Write-Stage 'BAIDU_WHO_UID_PARSE'
    $uidMatch=[regex]::Match([string]$who['StdOut'],'(?m)^当前帐号 uid:\s*([0-9]+),')
    if(-not $uidMatch.Success){
        Write-Output 'BAIDU_WHO_UID_PARSE=FAIL'
        Write-Output 'BAIDU_WHO_UID_MATCH=NOT_AVAILABLE'
        $classification='WHO_UID_PARSE_FAILED'
        throw 'BAIDU_WHO_UID_PARSE_FAILED'
    }
    Write-Output 'BAIDU_WHO_UID_PARSE=PASS'
    if($uidMatch.Groups[1].Value -cne $expectedUid){
        Write-Output 'BAIDU_WHO_UID_MATCH=FAIL'
        $classification='WHO_UID_MISMATCH'
        throw 'BAIDU_WHO_UID_MISMATCH'
    }
    Write-Output 'BAIDU_WHO_UID_MATCH=PASS'

    Write-Stage 'BAIDU_LS_PROCESS'
    $ls=Get-SafeProcessResult -Action 'ls' -Arguments @('-l',$remoteDir)
    Write-Stage 'BAIDU_LS_RESULT'
    Assert-Diagnostic ($ls -is [System.Collections.IDictionary]) 'BAIDU_LS_RESULT_SHAPE_INVALID'
    Assert-Diagnostic ($ls.Contains('ExitCode') -and $ls.Contains('StdOut') -and $ls.Contains('StdErr')) 'BAIDU_LS_RESULT_KEYS_MISSING'
    if([int]$ls['ExitCode'] -ne 0){
        Write-Output 'BAIDU_LS_PROCESS=FAIL'
        Write-Output 'BAIDU_LS_DIRECTORY_HEADER=NOT_AVAILABLE'
        $classification='LS_'+(Get-SafeErrorClass -StdOut ([string]$ls['StdOut']) -StdErr ([string]$ls['StdErr']))
        throw 'BAIDU_LS_READONLY_FAILED'
    }
    Write-Output 'BAIDU_LS_PROCESS=PASS'
    Write-Stage 'BAIDU_LS_HEADER_PARSE'
    $headerOk=[regex]::IsMatch([string]$ls['StdOut'],'(?m)^当前目录:\s*'+[regex]::Escape($remoteDir)+'\s*
    if($headerOk){
        Write-Output 'BAIDU_LS_DIRECTORY_HEADER=PASS'
        $classification='READONLY_BAIDU_PATH_PASS'
    } else {
        Write-Output 'BAIDU_LS_DIRECTORY_HEADER=FAIL'
        $classification='LS_DIRECTORY_HEADER_PARSE_FAILED'
        throw 'BAIDU_LS_HEADER_PARSE_FAILED'
    }

    Write-Output ('BAIDU_READONLY_DIAGNOSTIC_CLASSIFICATION='+$classification)
}
catch {
    if($classification -eq 'UNKNOWN'){
        $message=[string]$_.Exception.Message
        if($message -match '^[A-Z][A-Z0-9_]{1,95}$'){$classification=$message}else{$classification='LOCAL_DIAGNOSTIC_EXCEPTION'}
    }
    Write-Output ('DIAGNOSTIC_FAILED_STAGE='+$script:stage)
    Write-Output ('DIAGNOSTIC_EXCEPTION_TYPE='+$_.Exception.GetType().FullName)
    Write-Output ('DIAGNOSTIC_ERROR_LINE='+[string]$_.InvocationInfo.ScriptLineNumber)
    Write-Output ('BAIDU_READONLY_DIAGNOSTIC_CLASSIFICATION='+$classification)
}
finally {
    $expectedUid=$null
    $who=$null
    $ls=$null
    if(Test-Path -LiteralPath $diagRoot -PathType Container){
        try {
            Assert-OwnerAcl -Path $diagRoot
            Remove-Item -LiteralPath $diagRoot -Recurse -Force -ErrorAction Stop
            $cleanupPass=(-not (Test-Path -LiteralPath $diagRoot))
        } catch {
            $cleanupPass=$false
        }
    } else {
        $cleanupPass=$true
    }
    Write-Output ('TEMP_RUNTIME_CLEANUP='+$(if($cleanupPass){'PASS'}else{'FAIL'}))
    Write-Output 'BAIDU_MUTATION_ACTION=NO'
    Write-Output 'SSH_OR_VPS_ACTION=NO'
    Write-Output 'RECOVERY_WRITE=NO'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
)
    if($headerOk){
        Write-Output 'BAIDU_LS_DIRECTORY_HEADER=PASS'
        $classification='READONLY_BAIDU_PATH_PASS'
    } else {
        Write-Output 'BAIDU_LS_DIRECTORY_HEADER=FAIL'
        $classification='LS_DIRECTORY_HEADER_PARSE_FAILED'
        throw 'BAIDU_LS_HEADER_PARSE_FAILED'
    }

    Write-Output ('BAIDU_READONLY_DIAGNOSTIC_CLASSIFICATION='+$classification)
}
catch {
    if($classification -eq 'UNKNOWN'){
        $message=[string]$_.Exception.Message
        if($message -match '^[A-Z][A-Z0-9_]{1,95}$'){$classification=$message}else{$classification='LOCAL_DIAGNOSTIC_EXCEPTION'}
    }
    Write-Output ('DIAGNOSTIC_FAILED_STAGE='+$script:stage)
    Write-Output ('DIAGNOSTIC_EXCEPTION_TYPE='+$_.Exception.GetType().FullName)
    Write-Output ('BAIDU_READONLY_DIAGNOSTIC_CLASSIFICATION='+$classification)
}
finally {
    $expectedUid=$null
    $who=$null
    $ls=$null
    if(Test-Path -LiteralPath $diagRoot -PathType Container){
        try {
            Assert-OwnerAcl -Path $diagRoot
            Remove-Item -LiteralPath $diagRoot -Recurse -Force -ErrorAction Stop
            $cleanupPass=(-not (Test-Path -LiteralPath $diagRoot))
        } catch {
            $cleanupPass=$false
        }
    } else {
        $cleanupPass=$true
    }
    Write-Output ('TEMP_RUNTIME_CLEANUP='+$(if($cleanupPass){'PASS'}else{'FAIL'}))
    Write-Output 'BAIDU_MUTATION_ACTION=NO'
    Write-Output 'SSH_OR_VPS_ACTION=NO'
    Write-Output 'RECOVERY_WRITE=NO'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
