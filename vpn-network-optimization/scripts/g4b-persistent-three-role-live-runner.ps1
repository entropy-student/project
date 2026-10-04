[CmdletBinding()]
param(
    [ValidateSet('Run','Rollback','Closeout')][string]$Mode = 'Run',
    [switch]$Live,
    [string]$OwnerAuthorization,
    [string]$ExpectedRunnerBlob,
    [string]$RunId,
    [string]$ReviewerDecision,
    [string]$SshIdentityFile,
    [string]$KnownHostsFile = (Join-Path $env:USERPROFILE '.ssh\known_hosts'),
    [string]$SecondFailureDomainPath,
    [string]$SecondFailureDomainAcknowledgement
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:phase = 'BOOT'
$script:remoteMutationStarted = $false
$script:remoteRollbackVerified = $false
$script:completed = $false
$script:runId = if ($Mode -eq 'Run') { [Guid]::NewGuid().ToString('N') } else { $RunId }
$script:projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$script:publicIp = '24.199.118.137'
$script:controlTarget = 'root@10.66.21.1'
$script:hostKeyAlias = '24.199.118.137'
$script:runtimeUser = 'reality-vpn-network-optimization'
$script:realityService = 'mihomo-reality-vpn-network-optimization.service'
$script:secretRecoveryPath = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\reality-g4b.dpapi'
$script:localRuntimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$script:localRuntime = Join-Path $script:localRuntimeRoot ('g4b-' + $script:runId)
$script:rollbackJournal = Join-Path $script:localRuntimeRoot ('g4b-' + $script:runId + '.rollback.json')
$script:recoveryPendingLocal = $script:secretRecoveryPath + '.pending'
$script:recoveryFinalExternal = $null
$script:recoveryPendingExternal = $null
$script:profileConfig = Join-Path $script:localRuntime 'SELF-VPN-V1.yaml'
$script:profileStore = $null
$script:profileBefore = $null
$script:profileCreatedPaths = [Collections.Generic.List[string]]::new()
$script:ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$script:physicalEgress = $null
$script:baseline = $null
$script:remoteCredentials = $null
$script:hy2Auth = $null
$script:portablePassphrase = $null
$script:journalCreated = $false
$script:preserveRollbackJournal = $false
$script:profileSnapshotAfterImport = $null
$script:recoveryCreatedPaths = [Collections.Generic.List[string]]::new()

function Assert-G4B {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Write-Phase {
    param([ValidateSet('P0_CANONICAL_SOURCE','P1_OWNER_HOST_AND_NETWORK_PREFLIGHT','P2_STRICT_TARGET_IDENTITY','P3_WG_HY2_TCP443_BASELINE','P4_REALITY_RUNTIME_IDENTITY_AND_PATH_PREFLIGHT','P5_SECRET_AND_RECOVERY_PREPARE','P6_SERVER_CONFIG_PARSE','P7_SERVICE_ENABLE_AND_LISTENER_READBACK','P8_PUBLIC_REALITY_READINESS','P9_OWNER_THREE_ROLE_PROFILE_PREPARE','P10_OWNER_UI_IMPORT_AND_VISIBILITY','P11_RESTART_PERSISTENCE','P12_FINAL_BASELINE_READBACK')][string]$Name)
    $script:phase = $Name
    Write-Output "RUNNER_PHASE=$Name"
}

function Invoke-GitRead {
    param([string[]]$Arguments)
    $result = @(& git -C $script:projectRoot @Arguments 2>$null)
    if ($LASTEXITCODE -ne 0) { throw 'CANONICAL_GIT_QUERY_FAILED' }
    return (($result -join [Environment]::NewLine).Trim())
}

function Assert-CanonicalSource {
    $repoRoot = Invoke-GitRead -Arguments @('rev-parse','--show-toplevel')
    $origin = Invoke-GitRead -Arguments @('remote','get-url','origin')
    Assert-G4B ($origin -match '(?i)(?:github\.com[:/]entropy-student/project(?:\.git)?)$') 'CANONICAL_ORIGIN_INVALID'
    $projectPrefix = Invoke-GitRead -Arguments @('rev-parse','--show-prefix')
    $projectPrefix = $projectPrefix.TrimEnd('/')
    Assert-G4B ($projectPrefix -match '(^|/)vpn-network-optimization$') 'PROJECT_TRACKED_PATH_INVALID'
    $runnerRel = ($projectPrefix + '/scripts/g4b-persistent-three-role-live-runner.ps1').TrimStart('/')
    $handoffRel = ($projectPrefix + '/REVIEWER_HANDOFF.md').TrimStart('/')
    $trackedRunner = Invoke-GitRead -Arguments @('ls-files','--error-unmatch',$runnerRel)
    $trackedHandoff = Invoke-GitRead -Arguments @('ls-files','--error-unmatch',$handoffRel)
    Assert-G4B ($trackedRunner -ceq $runnerRel -and $trackedHandoff -ceq $handoffRel) 'CANONICAL_TARGET_NOT_TRACKED'
    $dirty = @(& git -C $script:projectRoot status --porcelain=v1 --untracked-files=all -- $projectPrefix 2>$null)
    if ($LASTEXITCODE -ne 0) { throw 'CANONICAL_PROJECT_STATUS_FAILED' }
    Assert-G4B ($dirty.Count -eq 0) 'CANONICAL_PROJECT_SCOPE_DIRTY'
    $actualRunnerBlob = Invoke-GitRead -Arguments @('rev-parse',"HEAD:$runnerRel")
    Assert-G4B ($ExpectedRunnerBlob -match '^[0-9a-f]{40}$' -and $actualRunnerBlob -ceq $ExpectedRunnerBlob) 'RUNNER_BLOB_MISMATCH'
    & git -C $script:projectRoot fetch origin main 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'CANONICAL_MAIN_FETCH_FAILED' }
    $head = Invoke-GitRead -Arguments @('rev-parse','HEAD')
    $main = Invoke-GitRead -Arguments @('rev-parse','origin/main')
    Assert-G4B ($head -ceq $main) 'CANONICAL_MAIN_NOT_CURRENT'
    $handoffPath = Join-Path $script:projectRoot 'REVIEWER_HANDOFF.md'
    $handoff = [IO.File]::ReadAllText($handoffPath,[Text.Encoding]::UTF8)
    if ($Mode -eq 'Run') {
        Assert-G4B ($handoff -match '(?m)^GATE_ID=G4B_PERSISTENT_THREE_ROLE_READINESS$') 'LIVE_G4B_GATE_NOT_CURRENT'
        Assert-G4B ($handoff -match '(?m)^LIVE_G4B_EXECUTION_AUTHORIZED=YES$') 'REVIEWER_LIVE_AUTHORIZATION_MISSING'
        Assert-G4B ($handoff -match '(?m)^SECOND_FAILURE_DOMAIN_DESTINATION=OWNER_APPROVED$') 'REVIEWER_RECOVERY_DESTINATION_NOT_APPROVED'
    }
    Assert-G4B ($repoRoot.Length -gt 0) 'CANONICAL_ROOT_UNAVAILABLE'
}

function Get-IntegrityRid {
    $groups = @(& whoami.exe /groups 2>$null)
    if ($LASTEXITCODE -ne 0) { throw 'INTEGRITY_QUERY_FAILED' }
    $matches = [regex]::Matches(($groups -join "`n"),'S-1-16-(\d+)')
    if ($matches.Count -ne 1) { throw 'INTEGRITY_RID_INVALID' }
    return [int]$matches[0].Groups[1].Value
}

function Resolve-PhysicalEgress {
    $candidates = [Collections.Generic.List[object]]::new()
    foreach ($adapter in @(Get-NetAdapter -Physical -ErrorAction Stop)) {
        if ($adapter.Status -ne 'Up' -or $adapter.Name -ceq 'SFO2-A' -or $adapter.InterfaceDescription -match '(?i)WireGuard|TUN|Virtual|Clash') { continue }
        $index = [int]$adapter.ifIndex
        if ($index -le 0) { continue }
        $cfg = Get-NetIPConfiguration -InterfaceIndex $index -ErrorAction Stop
        $gateways = @($cfg.IPv4DefaultGateway | Where-Object { $_ -and -not [string]::IsNullOrWhiteSpace([string]$_.NextHop) })
        $addresses = @($cfg.IPv4Address | Where-Object { $_ -and -not [string]::IsNullOrWhiteSpace([string]$_.IPAddress) })
        if ($gateways.Count -ne 1 -or $addresses.Count -ne 1) { continue }
        $routes = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix '0.0.0.0/0' -ErrorAction Stop | Where-Object { [int]$_.InterfaceIndex -eq $index -and [string]$_.NextHop -ceq [string]$gateways[0].NextHop })
        if ($routes.Count -eq 0) { continue }
        $ipif = @(Get-NetIPInterface -AddressFamily IPv4 -InterfaceIndex $index -ErrorAction Stop)
        if ($ipif.Count -ne 1) { continue }
        $route = @($routes | Sort-Object RouteMetric | Select-Object -First 1)[0]
        $candidates.Add([pscustomobject]@{ Name=[string]$adapter.Name; Index=$index; Gateway=[string]$gateways[0].NextHop; Source=[string]$addresses[0].IPAddress; Score=([int]$route.RouteMetric + [int]$ipif[0].InterfaceMetric) })
    }
    Assert-G4B ($candidates.Count -gt 0) 'PHYSICAL_EGRESS_NOT_FOUND'
    $ordered = @($candidates | Sort-Object Score,Index,Name)
    if ($ordered.Count -gt 1 -and $ordered[0].Score -eq $ordered[1].Score) { throw 'PHYSICAL_EGRESS_AMBIGUOUS' }
    return $ordered[0]
}

function Get-TunCount {
    return @(
        Get-NetAdapter -IncludeHidden -ErrorAction Stop | Where-Object {
            $_.Status -eq 'Up' -and $_.Name -cne 'SFO2-A' -and
            $_.InterfaceDescription -notmatch '(?i)WireGuard' -and
            ($_.Name -match '(?i)clash|mihomo|tun' -or $_.InterfaceDescription -match '(?i)clash|mihomo|tun')
        }
    ).Count
}

function Get-RouteSnapshot {
    return @(
        Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop |
            ForEach-Object { '{0}|{1}|{2}|{3}' -f $_.DestinationPrefix,$_.NextHop,$_.InterfaceIndex,$_.RouteMetric } |
            Sort-Object
    )
}

function Get-OptionalStringProperty {
    param([Parameter(Mandatory=$true)][object]$InputObject,[Parameter(Mandatory=$true)][string]$Name)
    $property=$InputObject.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return '' }
    return [string]$property.Value
}

function Get-LocalBaseline {
    $manager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $tunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $wg = @(Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop)
    $clash = Get-Service -Name 'clash_verge_service' -ErrorAction Stop
    $settings = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    Assert-G4B ($wg.Count -eq 1 -and $wg[0].Status -ceq 'Up' -and [int]$wg[0].ifIndex -gt 0) 'WIREGUARD_ADAPTER_INVALID'
    Assert-G4B ($manager.Status -ceq 'Running' -and $tunnel.Status -ceq 'Running') 'WIREGUARD_SERVICE_INVALID'
    Assert-G4B ($clash.Status -ceq 'Running') 'CLASH_SERVICE_INVALID'
    Assert-G4B ($null -ne $settings.PSObject.Properties['ProxyEnable'] -and [int]$settings.ProxyEnable -eq 0) 'SYSTEM_PROXY_NOT_OFF'
    Assert-G4B ((Get-TunCount) -eq 0) 'TUN_NOT_OFF'
    $winHttp = @(& netsh.exe winhttp show proxy 2>$null)
    if ($LASTEXITCODE -ne 0) { throw 'WINHTTP_READBACK_FAILED' }
    return [pscustomobject]@{
        Manager=[string]$manager.Status; Tunnel=[string]$tunnel.Status; WgIfIndex=[int]$wg[0].ifIndex
        WgStatus=[string]$wg[0].Status; Clash=[string]$clash.Status; ProxyEnable=[int]$settings.ProxyEnable
        ProxyServer=(Get-OptionalStringProperty -InputObject $settings -Name 'ProxyServer')
        ProxyOverride=(Get-OptionalStringProperty -InputObject $settings -Name 'ProxyOverride')
        AutoConfigURL=(Get-OptionalStringProperty -InputObject $settings -Name 'AutoConfigURL')
        TunCount=(Get-TunCount); Routes=(Get-RouteSnapshot)
        WinHttp=($winHttp -join "`n")
    }
}

function Assert-SameLocalBaseline {
    param([object]$Before,[object]$After)
    foreach ($name in @('Manager','Tunnel','WgIfIndex','WgStatus','Clash','ProxyEnable','ProxyServer','ProxyOverride','AutoConfigURL','TunCount','WinHttp')) {
        Assert-G4B ($Before.$name -ceq $After.$name) ('LOCAL_BASELINE_CHANGED_' + $name.ToUpperInvariant())
    }
    Assert-G4B (($Before.Routes -join "`n") -ceq ($After.Routes -join "`n")) 'ACTIVE_ROUTES_CHANGED'
}

function New-OwnerAcl {
    param([switch]$Directory)
    if ($Directory) { $acl=[Security.AccessControl.DirectorySecurity]::new(); $inherit=[Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit }
    else { $acl=[Security.AccessControl.FileSecurity]::new(); $inherit=[Security.AccessControl.InheritanceFlags]::None }
    $acl.SetAccessRuleProtection($true,$false)
    $acl.SetOwner($script:ownerSid)
    [void]$acl.AddAccessRule([Security.AccessControl.FileSystemAccessRule]::new($script:ownerSid,[Security.AccessControl.FileSystemRights]::FullControl,$inherit,[Security.AccessControl.PropagationFlags]::None,[Security.AccessControl.AccessControlType]::Allow))
    return $acl
}

function Assert-OwnerAcl {
    param([string]$Path)
    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-G4B (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'OWNER_ACL_REPARSE_POINT'
    $acl=Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-G4B $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'
    Assert-G4B ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $script:ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'
    $rules=@($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
    $direct=[long]0
    foreach($rule in $rules){
        Assert-G4B (-not $rule.IsInherited -and $rule.IdentityReference.Value -ceq $script:ownerSid.Value) 'OWNER_ACL_UNAUTHORIZED_RULE'
        Assert-G4B ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'OWNER_ACL_DENY_RULE'
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) { $direct=$direct -bor [long]$rule.FileSystemRights }
    }
    $full=[long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-G4B (($direct -band $full) -eq $full) 'OWNER_ACL_FULLCONTROL_MISSING'
    if ($item.PSIsContainer) { Assert-G4B (($rules.Count -gt 0) -and (@($rules | Where-Object { ($_.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0 }).Count -gt 0)) 'OWNER_ACL_CHILD_INHERITANCE_MISSING' }
}

function Resolve-ProfileStoreRoot {
    $roaming=[Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    Assert-G4B (-not [string]::IsNullOrWhiteSpace($roaming)) 'CLASH_PROFILE_STORE_ROOT_UNAVAILABLE'
    $roots=@(Get-ChildItem -LiteralPath $roaming -Directory -Force -ErrorAction Stop | Where-Object { $_.Name -match '(?i)(?:clash.*verge|verge.*clash)' })
    $stores=@($roots | ForEach-Object { Join-Path $_.FullName 'profiles' } | Where-Object { Test-Path -LiteralPath $_ -PathType Container })
    Assert-G4B ($stores.Count -eq 1) 'CLASH_PROFILE_STORE_AMBIGUOUS'
    $store=(Resolve-Path -LiteralPath $stores[0] -ErrorAction Stop).Path
    Assert-G4B (((Get-Item -LiteralPath $store -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'CLASH_PROFILE_STORE_REPARSE_POINT'
    return $store
}

function Get-ProfileSnapshot {
    param([string]$Root)
    $map=[Collections.Generic.SortedDictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    $stack=[Collections.Generic.Stack[string]]::new(); $stack.Push($Root)
    while($stack.Count -gt 0){
        $dir=$stack.Pop()
        foreach($item in @(Get-ChildItem -LiteralPath $dir -Force -ErrorAction Stop)){
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'CLASH_PROFILE_STORE_REPARSE_POINT' }
            $rel=[IO.Path]::GetRelativePath($Root,$item.FullName).Replace('\','/')
            if ($item.PSIsContainer) { $map.Add($rel,'DIR'); $stack.Push($item.FullName) }
            else { $map.Add($rel,('{0}|{1}' -f $item.Length,$item.LastWriteTimeUtc.Ticks)) }
        }
    }
    return ,$map
}

function Assert-ExistingProfileStoreUnchanged {
    param([object]$Before,[object]$After)
    foreach($key in $Before.Keys){ Assert-G4B ($After.ContainsKey($key) -and $Before[$key] -ceq $After[$key]) 'UNRELATED_PROFILE_STORE_MUTATION' }
}

function Read-Hy2Auth {
    $path=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\hy2-g2a.dpapi'
    Assert-G4B (Test-Path -LiteralPath $path -PathType Leaf) 'HY2_RECOVERY_MISSING'
    $cipher=[IO.File]::ReadAllBytes($path)
    $plain=$null
    $reader=$null; $stream=$null; $files=@{}
    try {
        $plain=[Security.Cryptography.ProtectedData]::Unprotect($cipher,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
        if ($plain.Length -gt 131072) { throw 'HY2_RECOVERY_TOO_LARGE' }
        $stream=[IO.MemoryStream]::new($plain,$false); $reader=[IO.BinaryReader]::new($stream,[Text.Encoding]::UTF8,$true)
        $magic=[Text.Encoding]::ASCII.GetString($reader.ReadBytes(8))
        Assert-G4B ($magic -ceq 'VPNHY2R1') 'HY2_RECOVERY_MAGIC_INVALID'
        while($stream.Position -lt $stream.Length){
            $nameLength=[int]$reader.ReadByte(); Assert-G4B ($nameLength -ge 1 -and $nameLength -le 32) 'HY2_RECOVERY_NAME_LENGTH_INVALID'
            $lengthBytes=$reader.ReadBytes(4); Assert-G4B ($lengthBytes.Length -eq 4) 'HY2_RECOVERY_FRAME_TRUNCATED'
            [uint32]$length=([uint32]$lengthBytes[0] -shl 24) -bor ([uint32]$lengthBytes[1] -shl 16) -bor ([uint32]$lengthBytes[2] -shl 8) -bor [uint32]$lengthBytes[3]
            Assert-G4B ($length -gt 0 -and $length -le 65536) 'HY2_RECOVERY_DATA_LENGTH_INVALID'
            $name=[Text.Encoding]::UTF8.GetString($reader.ReadBytes($nameLength)); Assert-G4B ($name -in @('hy2-auth','server.key','server.crt') -and -not $files.ContainsKey($name)) 'HY2_RECOVERY_ALLOWLIST_INVALID'
            $data=$reader.ReadBytes([int]$length); Assert-G4B ($data.Length -eq $length) 'HY2_RECOVERY_FRAME_TRUNCATED'; $files[$name]=$data
        }
        Assert-G4B ($files.Count -eq 3) 'HY2_RECOVERY_CARDINALITY_INVALID'
        $authBytes=[byte[]]$files['hy2-auth']
        Assert-G4B ($authBytes.Length -eq 64 -and [regex]::IsMatch([Text.Encoding]::ASCII.GetString($authBytes),'^[0-9a-f]{64}$')) 'HY2_AUTH_FORMAT_INVALID'
        $pinTemplate=[IO.File]::ReadAllText((Join-Path $script:projectRoot 'templates\clash\c2c-real-hy2-canary.yaml.template'),[Text.Encoding]::UTF8)
        $match=[regex]::Match($pinTemplate,'(?m)^\s*fingerprint:\s*(?<v>[0-9A-F]{2}(?::[0-9A-F]{2}){31})\s*$')
        Assert-G4B $match.Success 'HY2_PIN_TEMPLATE_INVALID'
        $cert=[Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$files['server.crt'])
        try { $fingerprint=[string]::Join(':',[regex]::Matches([Convert]::ToHexString($cert.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256)),'..').Value) }
        finally { $cert.Dispose() }
        Assert-G4B ($fingerprint -ceq $match.Groups['v'].Value) 'HY2_CERTIFICATE_FINGERPRINT_MISMATCH'
        $script:hy2Auth=[Text.Encoding]::ASCII.GetString($authBytes)
    }
    finally {
        if ($reader) { $reader.Dispose() }; if ($stream) { $stream.Dispose() }
        foreach($value in $files.Values){ [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value) }
        if ($null -ne $plain) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($plain) }
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($cipher)
    }
}

function ConvertFrom-SecurePassphrase {
    param([Parameter(Mandatory=$true)][Security.SecureString]$Value)
    Assert-G4B ($Value.Length -ge 16) 'PORTABLE_RECOVERY_PASSPHRASE_TOO_SHORT'
    $pointer=[IntPtr]::Zero; $chars=[char[]]::new($Value.Length); $bytes=$null
    try {
        $pointer=[Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($Value)
        for($i=0;$i -lt $chars.Length;$i++){ $chars[$i]=[char]([uint16][Runtime.InteropServices.Marshal]::ReadInt16($pointer,$i*2)) }
        $bytes=[byte[]]::new([Text.Encoding]::UTF8.GetByteCount($chars))
        [void][Text.Encoding]::UTF8.GetBytes($chars,0,$chars.Length,$bytes,0)
        return ,$bytes
    }
    catch {
        if($null -ne $bytes){[Security.Cryptography.CryptographicOperations]::ZeroMemory($bytes)}
        throw 'PORTABLE_RECOVERY_PASSPHRASE_CONVERSION_FAILED'
    }
    finally {
        [Array]::Clear($chars,0,$chars.Length)
        if($pointer -ne [IntPtr]::Zero){[Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($pointer)}
    }
}

function Test-G4BRecoveryPayload {
    param([Parameter(Mandatory=$true)][byte[]]$PayloadBytes)
    $document=$null
    try {
        $json=[Text.UTF8Encoding]::new($false,$true).GetString($PayloadBytes)
        $document=[System.Text.Json.JsonDocument]::Parse($json)
        if($document.RootElement.ValueKind -ne [System.Text.Json.JsonValueKind]::Object){return $false}
        $allowed=@('format','hy2_auth','reality_uuid','reality_private_key','reality_public_key','reality_short_id')
        $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach($property in $document.RootElement.EnumerateObject()){
            $added=$seen.Add($property.Name)
            if(-not $added -or $property.Name -cnotin $allowed){return $false}
            if($property.Value.ValueKind -ne [System.Text.Json.JsonValueKind]::String){return $false}
        }
        if($seen.Count -ne $allowed.Count){return $false}
        $root=$document.RootElement
        return ($root.GetProperty('format').GetString() -ceq 'VPNG4BR1' -and
            $root.GetProperty('hy2_auth').GetString() -cmatch '^[0-9a-f]{64}$' -and
            $root.GetProperty('reality_uuid').GetString() -cmatch '^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$' -and
            $root.GetProperty('reality_private_key').GetString() -cmatch '^[A-Za-z0-9_-]{40,64}$' -and
            $root.GetProperty('reality_public_key').GetString() -cmatch '^[A-Za-z0-9_-]{40,64}$' -and
            $root.GetProperty('reality_short_id').GetString() -cmatch '^[0-9a-f]{16}$')
    }
    catch { return $false }
    finally { if($null -ne $document){$document.Dispose()} }
}

function ConvertTo-PortableRecoveryBytes {
    param([Parameter(Mandatory=$true)][byte[]]$PayloadBytes,[Parameter(Mandatory=$true)][Security.SecureString]$Passphrase)
    $passwordBytes=$null; $key=$null; $salt=[Security.Cryptography.RandomNumberGenerator]::GetBytes(16); $nonce=[Security.Cryptography.RandomNumberGenerator]::GetBytes(12)
    $tag=[byte[]]::new(16); $cipher=[byte[]]::new($PayloadBytes.Length); $aes=$null
    $header=[byte[]]::new(44); [Array]::Copy([Text.Encoding]::ASCII.GetBytes('VPNG4BP1'),$header,8)
    $iterationBytes=[BitConverter]::GetBytes([int]600000); if([BitConverter]::IsLittleEndian){[Array]::Reverse($iterationBytes)}
    [Array]::Copy($iterationBytes,0,$header,8,4); [Array]::Copy($salt,0,$header,12,16); [Array]::Copy($nonce,0,$header,28,12)
    $lengthBytes=[BitConverter]::GetBytes([int]$PayloadBytes.Length); if([BitConverter]::IsLittleEndian){[Array]::Reverse($lengthBytes)}
    [Array]::Copy($lengthBytes,0,$header,40,4)
    try {
        $passwordBytes=ConvertFrom-SecurePassphrase -Value $Passphrase
        $key=[Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2($passwordBytes,$salt,600000,[Security.Cryptography.HashAlgorithmName]::SHA256,32)
        $aes=[Security.Cryptography.AesGcm]::new($key,16); $aes.Encrypt($nonce,$PayloadBytes,$cipher,$tag,$header)
        $blob=[byte[]]::new($header.Length+$tag.Length+$cipher.Length)
        [Array]::Copy($header,0,$blob,0,$header.Length); [Array]::Copy($tag,0,$blob,$header.Length,$tag.Length); [Array]::Copy($cipher,0,$blob,$header.Length+$tag.Length,$cipher.Length)
        return ,$blob
    }
    finally {
        if($aes){$aes.Dispose()}; if($null -ne $passwordBytes){[Security.Cryptography.CryptographicOperations]::ZeroMemory($passwordBytes)}
        if($null -ne $key){[Security.Cryptography.CryptographicOperations]::ZeroMemory($key)}
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($salt); [Security.Cryptography.CryptographicOperations]::ZeroMemory($nonce)
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($tag); [Security.Cryptography.CryptographicOperations]::ZeroMemory($cipher)
    }
}

function ConvertFrom-PortableRecoveryBytes {
    param([Parameter(Mandatory=$true)][byte[]]$Blob,[Parameter(Mandatory=$true)][Security.SecureString]$Passphrase)
    Assert-G4B ($Blob.Length -ge 61 -and [Text.Encoding]::ASCII.GetString($Blob,0,8) -ceq 'VPNG4BP1') 'PORTABLE_RECOVERY_HEADER_INVALID'
    $header=[byte[]]::new(44); [Array]::Copy($Blob,0,$header,0,44)
    $iterationBytes=[byte[]]::new(4); [Array]::Copy($Blob,8,$iterationBytes,0,4); if([BitConverter]::IsLittleEndian){[Array]::Reverse($iterationBytes)}
    $iterations=[BitConverter]::ToInt32($iterationBytes,0)
    $lengthBytes=[byte[]]::new(4); [Array]::Copy($Blob,40,$lengthBytes,0,4); if([BitConverter]::IsLittleEndian){[Array]::Reverse($lengthBytes)}
    $length=[BitConverter]::ToInt32($lengthBytes,0)
    Assert-G4B ($iterations -ge 600000 -and $iterations -eq 600000 -and $length -gt 0 -and $length -le 131072 -and $Blob.Length -eq 60+$length) 'PORTABLE_RECOVERY_LENGTH_OR_KDF_INVALID'
    $salt=[byte[]]::new(16); $nonce=[byte[]]::new(12); $tag=[byte[]]::new(16); $cipher=[byte[]]::new($length); $plain=[byte[]]::new($length)
    [Array]::Copy($Blob,12,$salt,0,16); [Array]::Copy($Blob,28,$nonce,0,12); [Array]::Copy($Blob,44,$tag,0,16); [Array]::Copy($Blob,60,$cipher,0,$length)
    $passwordBytes=$null; $key=$null; $aes=$null
    try {
        $passwordBytes=ConvertFrom-SecurePassphrase -Value $Passphrase
        $key=[Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2($passwordBytes,$salt,$iterations,[Security.Cryptography.HashAlgorithmName]::SHA256,32)
        $aes=[Security.Cryptography.AesGcm]::new($key,16); $aes.Decrypt($nonce,$cipher,$tag,$plain,$header)
        Assert-G4B (Test-G4BRecoveryPayload -PayloadBytes $plain) 'PORTABLE_RECOVERY_PAYLOAD_INVALID'
        return ,$plain
    }
    catch {
        if($null -ne $plain){[Security.Cryptography.CryptographicOperations]::ZeroMemory($plain)}
        throw 'PORTABLE_RECOVERY_AUTHENTICATION_OR_PARSE_FAILED'
    }
    finally {
        if($aes){$aes.Dispose()}; if($null -ne $passwordBytes){[Security.Cryptography.CryptographicOperations]::ZeroMemory($passwordBytes)}
        if($null -ne $key){[Security.Cryptography.CryptographicOperations]::ZeroMemory($key)}
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($salt); [Security.Cryptography.CryptographicOperations]::ZeroMemory($nonce)
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($tag); [Security.Cryptography.CryptographicOperations]::ZeroMemory($cipher)
    }
}

function Write-EncryptedRecovery {
    param([Parameter(Mandatory=$true)][byte[]]$PayloadBytes,[Parameter(Mandatory=$true)][Security.SecureString]$Passphrase)
    $root=Split-Path -Parent $script:secretRecoveryPath
    Assert-G4B (Test-Path -LiteralPath $root -PathType Container) 'OWNER_RECOVERY_ROOT_MISSING'
    Assert-OwnerAcl -Path $root
    $external=[IO.Path]::GetFullPath($SecondFailureDomainPath)
    Assert-G4B (Test-Path -LiteralPath $external -PathType Container) 'SECOND_FAILURE_DOMAIN_UNAVAILABLE'
    Assert-G4B ($SecondFailureDomainAcknowledgement -ceq 'SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED') 'SECOND_FAILURE_DOMAIN_ACK_INVALID'
    Assert-G4B (-not $external.StartsWith($script:projectRoot,[StringComparison]::OrdinalIgnoreCase)) 'SECOND_FAILURE_DOMAIN_INSIDE_REPOSITORY'
    Assert-G4B (-not $external.StartsWith((Split-Path -Parent $script:secretRecoveryPath),[StringComparison]::OrdinalIgnoreCase)) 'SECOND_FAILURE_DOMAIN_NOT_DISTINCT'
    $script:recoveryFinalExternal=Join-Path $external 'vpn-network-optimization-g4b.vpr1'
    $script:recoveryPendingExternal=$script:recoveryFinalExternal+'.pending'
    foreach($path in @($script:secretRecoveryPath,$script:recoveryPendingLocal,$script:recoveryFinalExternal,$script:recoveryPendingExternal)){
        Assert-G4B (-not (Test-Path -LiteralPath $path)) 'RECOVERY_TARGET_OR_PENDING_EXISTS'
    }
    Assert-G4B (Test-G4BRecoveryPayload -PayloadBytes $PayloadBytes) 'RECOVERY_PAYLOAD_INVALID'
    $dpapi=$null; $portable=$null; $round=$null; $portableRound=$null
    try {
        $dpapi=[Security.Cryptography.ProtectedData]::Protect($PayloadBytes,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
        $round=[Security.Cryptography.ProtectedData]::Unprotect($dpapi,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
        Assert-G4B ([Linq.Enumerable]::SequenceEqual[byte]($PayloadBytes,$round) -and (Test-G4BRecoveryPayload -PayloadBytes $round)) 'DPAPI_RECOVERY_ROUNDTRIP_FAILED'
        $portable=ConvertTo-PortableRecoveryBytes -PayloadBytes $PayloadBytes -Passphrase $Passphrase
        $portableRound=ConvertFrom-PortableRecoveryBytes -Blob $portable -Passphrase $Passphrase
        Assert-G4B ([Linq.Enumerable]::SequenceEqual[byte]($PayloadBytes,$portableRound)) 'PORTABLE_RECOVERY_ROUNDTRIP_FAILED'
        Write-OwnerOnlyFile -Path $script:recoveryPendingLocal -Bytes $dpapi -RecoveryArtifact
        Write-OwnerOnlyFile -Path $script:recoveryPendingExternal -Bytes $portable -RecoveryArtifact
        Assert-OwnerAcl -Path $script:recoveryPendingLocal; Assert-OwnerAcl -Path $script:recoveryPendingExternal
        $localReadback=[IO.File]::ReadAllBytes($script:recoveryPendingLocal); $externalReadback=[IO.File]::ReadAllBytes($script:recoveryPendingExternal)
        $localPayload=[Security.Cryptography.ProtectedData]::Unprotect($localReadback,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
        $externalPayload=ConvertFrom-PortableRecoveryBytes -Blob $externalReadback -Passphrase $Passphrase
        Assert-G4B ([Linq.Enumerable]::SequenceEqual[byte]($PayloadBytes,$localPayload) -and [Linq.Enumerable]::SequenceEqual[byte]($PayloadBytes,$externalPayload)) 'RECOVERY_PENDING_READBACK_FAILED'
    }
    finally {
        foreach($value in @($round,$portableRound,$dpapi,$portable,$localReadback,$externalReadback,$localPayload,$externalPayload)){ if($null -ne $value){[Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value)} }
    }
}

function Promote-RecoveryArtifacts {
    param([Parameter(Mandatory=$true)][byte[]]$PayloadBytes)
    Assert-G4B ((Test-Path -LiteralPath $script:recoveryPendingLocal -PathType Leaf) -and (Test-Path -LiteralPath $script:recoveryPendingExternal -PathType Leaf)) 'RECOVERY_PENDING_MISSING'
    Assert-G4B ((-not (Test-Path -LiteralPath $script:secretRecoveryPath)) -and (-not (Test-Path -LiteralPath $script:recoveryFinalExternal))) 'RECOVERY_FINAL_COLLISION'
    [IO.File]::Move($script:recoveryPendingLocal,$script:secretRecoveryPath); $script:recoveryCreatedPaths.Add($script:secretRecoveryPath)
    [IO.File]::Move($script:recoveryPendingExternal,$script:recoveryFinalExternal); $script:recoveryCreatedPaths.Add($script:recoveryFinalExternal)
    Assert-OwnerAcl -Path $script:secretRecoveryPath; Assert-OwnerAcl -Path $script:recoveryFinalExternal
    $cipher=[IO.File]::ReadAllBytes($script:secretRecoveryPath); $round=$null
    try {
        $round=[Security.Cryptography.ProtectedData]::Unprotect($cipher,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
        Assert-G4B ([Linq.Enumerable]::SequenceEqual[byte]($round,$PayloadBytes) -and (Test-G4BRecoveryPayload -PayloadBytes $round)) 'DPAPI_FINAL_PARSE_FAILED'
    }
    finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($cipher); if($null -ne $round){[Security.Cryptography.CryptographicOperations]::ZeroMemory($round)} }
    $portable=[IO.File]::ReadAllBytes($script:recoveryFinalExternal); $portableRound=$null
    try { $portableRound=ConvertFrom-PortableRecoveryBytes -Blob $portable -Passphrase $script:portablePassphrase; Assert-G4B ([Linq.Enumerable]::SequenceEqual[byte]($portableRound,$PayloadBytes) -and (Test-G4BRecoveryPayload -PayloadBytes $portableRound)) 'PORTABLE_FINAL_PARSE_FAILED' }
    finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($portable); if($null -ne $portableRound){[Security.Cryptography.CryptographicOperations]::ZeroMemory($portableRound)} }
}

function Invoke-MihomoParse {
    param([string]$ConfigPath)
    $binary='C:\Program Files\Clash Verge\verge-mihomo.exe'
    Assert-G4B (Test-Path -LiteralPath $binary -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    $p=[Diagnostics.Process]::new()
    try {
        $p.StartInfo.FileName=$binary; $p.StartInfo.UseShellExecute=$false; $p.StartInfo.RedirectStandardOutput=$true; $p.StartInfo.RedirectStandardError=$true
        foreach($arg in @('-t','-d',$script:localRuntime,'-f',$ConfigPath)){ [void]$p.StartInfo.ArgumentList.Add($arg) }
        if(-not $p.Start()) { throw 'MIHOMO_PARSE_START_FAILED' }
        $stdout=$p.StandardOutput.ReadToEndAsync(); $stderr=$p.StandardError.ReadToEndAsync()
        if(-not $p.WaitForExit(30000)){ try{$p.Kill($true)}catch{}; throw 'MIHOMO_PARSE_TIMEOUT' }
        [void]$stdout.GetAwaiter().GetResult(); [void]$stderr.GetAwaiter().GetResult()
        Assert-G4B ($p.ExitCode -eq 0) 'MIHOMO_CONFIG_PARSE_FAILED'
    }
    finally { $p.Dispose() }
}

function New-RealityCredentials {
    $binary='C:\Program Files\Clash Verge\verge-mihomo.exe'
    Assert-G4B (Test-Path -LiteralPath $binary -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    $versionProcess=[Diagnostics.Process]::new()
    try {
        $versionProcess.StartInfo.FileName=$binary; $versionProcess.StartInfo.UseShellExecute=$false
        $versionProcess.StartInfo.RedirectStandardOutput=$true; $versionProcess.StartInfo.RedirectStandardError=$true
        [void]$versionProcess.StartInfo.ArgumentList.Add('-v')
        if(-not $versionProcess.Start()){throw 'MIHOMO_VERSION_START_FAILED'}
        $versionOut=$versionProcess.StandardOutput.ReadToEndAsync(); $versionErr=$versionProcess.StandardError.ReadToEndAsync()
        if(-not $versionProcess.WaitForExit(15000)){try{$versionProcess.Kill($true)}catch{};throw 'MIHOMO_VERSION_TIMEOUT'}
        $versionText=$versionOut.GetAwaiter().GetResult(); [void]$versionErr.GetAwaiter().GetResult()
        Assert-G4B ($versionProcess.ExitCode -eq 0 -and $versionText -match '(?i)1\.19\.32') 'MIHOMO_VERSION_MISMATCH'
    }
    finally { $versionProcess.Dispose() }
    $keyProcess=[Diagnostics.Process]::new()
    try {
        $keyProcess.StartInfo.FileName=$binary; $keyProcess.StartInfo.UseShellExecute=$false
        $keyProcess.StartInfo.RedirectStandardOutput=$true; $keyProcess.StartInfo.RedirectStandardError=$true
        [void]$keyProcess.StartInfo.ArgumentList.Add('generate'); [void]$keyProcess.StartInfo.ArgumentList.Add('reality-keypair')
        if(-not $keyProcess.Start()){throw 'REALITY_KEYPAIR_START_FAILED'}
        $keyOut=$keyProcess.StandardOutput.ReadToEndAsync(); $keyErr=$keyProcess.StandardError.ReadToEndAsync()
        if(-not $keyProcess.WaitForExit(15000)){try{$keyProcess.Kill($true)}catch{};throw 'REALITY_KEYPAIR_TIMEOUT'}
        $keyText=$keyOut.GetAwaiter().GetResult(); [void]$keyErr.GetAwaiter().GetResult()
        Assert-G4B ($keyProcess.ExitCode -eq 0) 'REALITY_KEYPAIR_GENERATION_FAILED'
        $private=[regex]::Match($keyText,'(?im)^PrivateKey:\s*(?<v>[A-Za-z0-9_-]{40,64})\s*$')
        $public=[regex]::Match($keyText,'(?im)^PublicKey:\s*(?<v>[A-Za-z0-9_-]{40,64})\s*$')
        Assert-G4B ($private.Success -and $public.Success) 'REALITY_KEYPAIR_FORMAT_INVALID'
        $random=[Security.Cryptography.RandomNumberGenerator]::GetBytes(8)
        try {
            return @{
                uuid=[Guid]::NewGuid().ToString().ToLowerInvariant(); private_key=$private.Groups['v'].Value
                public_key=$public.Groups['v'].Value; short_id=[Convert]::ToHexString($random).ToLowerInvariant()
            }
        }
        finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($random); $keyText=$null }
    }
    finally { $keyProcess.Dispose() }
}

function Get-ProfileSemanticState {
    param([Parameter(Mandatory=$true)][string]$Path)
    Assert-G4B (Test-Path -LiteralPath $Path -PathType Leaf) 'RESTART_PROFILE_MISSING'
    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-G4B (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0 -and $item.Length -le 1048576) 'RESTART_PROFILE_FILE_INVALID'
    $text=[IO.File]::ReadAllText($Path,[Text.Encoding]::UTF8)
    Assert-G4B ($text.StartsWith('# G4B_RUN_ID='+$script:runId+[Environment]::NewLine,[StringComparison]::Ordinal)) 'PROFILE_RUN_OWNERSHIP_MARKER_MISSING'
    $json=$text.Substring($text.IndexOf([Environment]::NewLine,[StringComparison]::Ordinal)+[Environment]::NewLine.Length)
    $cfg=ConvertFrom-Json -InputObject $json -AsHashtable -ErrorAction Stop
    $proxies=@($cfg['proxies']); $groups=@($cfg['proxy-groups'])
    Assert-G4B ($proxies.Count -eq 3 -and $groups.Count -eq 1) 'RESTART_PROFILE_SHAPE_INVALID'
    Assert-G4B ($proxies[0]['name'] -ceq 'HY2-SFO3' -and $proxies[1]['name'] -ceq 'WG-BASELINE' -and $proxies[1]['type'] -ceq 'direct' -and $proxies[2]['name'] -ceq 'REALITY-SFO3') 'RESTART_PROFILE_ROLE_ORDER_INVALID'
    Assert-G4B ($groups[0]['name'] -ceq 'SELF-VPN-V1' -and $groups[0]['type'] -ceq 'select' -and ($groups[0]['proxies'] -join '|') -ceq 'HY2-SFO3|WG-BASELINE|REALITY-SFO3') 'RESTART_PROFILE_SELECTOR_INVALID'
    Assert-G4B (@($groups | Where-Object { $_.type -in @('url-test','fallback','load-balance') }).Count -eq 0) 'RESTART_PROFILE_AUTO_SELECTOR_PRESENT'
    return [pscustomobject]@{Present=$true; RoleOrder='HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2'; ManualSelect=$true}
}

function Write-RollbackJournal {
    param([Parameter(Mandatory=$true)][string]$Status)
    $record=@{
        format='G4B_OWNER_ROLLBACK_R1'; run_id=$script:runId; status=$Status
        profile_store=$script:profileStore
        profile_created_paths=@($script:profileCreatedPaths)
        profile_before=@(if($null -ne $script:profileBefore){foreach($key in $script:profileBefore.Keys){[pscustomobject]@{path=$key;metadata=$script:profileBefore[$key]}}})
        recovery_pending_local=$script:recoveryPendingLocal
        recovery_pending_external=$script:recoveryPendingExternal
        recovery_final_local=$script:secretRecoveryPath
        recovery_final_external=$script:recoveryFinalExternal
    }
    $bytes=[Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject $record -Depth 8 -Compress))
    try {
        if(-not $script:journalCreated){
            Write-OwnerOnlyFile -Path $script:rollbackJournal -Bytes $bytes -RollbackJournal
            $script:journalCreated=$true
        } else {
            $temporary=$script:rollbackJournal+'.update'
            Assert-G4B (-not (Test-Path -LiteralPath $temporary)) 'ROLLBACK_JOURNAL_TEMP_COLLISION'
            $temporaryCreated=$false
            try {
                Write-OwnerOnlyFile -Path $temporary -Bytes $bytes; $temporaryCreated=$true
                [IO.File]::Replace($temporary,$script:rollbackJournal,$null,$true)
                Assert-OwnerAcl -Path $script:rollbackJournal
            }
            finally { if($temporaryCreated -and (Test-Path -LiteralPath $temporary -PathType Leaf)){Remove-Item -LiteralPath $temporary -Force -ErrorAction Stop} }
        }
    }
    finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($bytes) }
}

function Read-RollbackJournal {
    Assert-G4B ($script:runId -match '^[0-9a-f]{32}$') 'ROLLBACK_RUN_ID_REQUIRED'
    Assert-G4B (Test-Path -LiteralPath $script:rollbackJournal -PathType Leaf) 'ROLLBACK_JOURNAL_MISSING'
    Assert-OwnerAcl -Path $script:rollbackJournal
    $record=ConvertFrom-Json -InputObject ([IO.File]::ReadAllText($script:rollbackJournal,[Text.Encoding]::UTF8)) -AsHashtable -ErrorAction Stop
    Assert-G4B ($record['format'] -ceq 'G4B_OWNER_ROLLBACK_R1' -and $record['run_id'] -ceq $script:runId -and $record['status'] -in @('IN_PROGRESS','PASS_CANDIDATE')) 'ROLLBACK_JOURNAL_IDENTITY_INVALID'
    Assert-G4B ($record['profile_store'] -is [string] -and $record['profile_created_paths'] -is [array]) 'ROLLBACK_JOURNAL_SHAPE_INVALID'
    $currentProfileStore=Resolve-ProfileStoreRoot
    Assert-G4B ([IO.Path]::GetFullPath([string]$record['profile_store']) -ceq [IO.Path]::GetFullPath($currentProfileStore)) 'ROLLBACK_JOURNAL_PROFILE_ROOT_INVALID'
    Assert-G4B ($SecondFailureDomainPath -and (Test-Path -LiteralPath $SecondFailureDomainPath -PathType Container)) 'ROLLBACK_RECOVERY_DOMAIN_REQUIRED'
    $externalRoot=[IO.Path]::GetFullPath($SecondFailureDomainPath)
    $expectedExternal=Join-Path $externalRoot 'vpn-network-optimization-g4b.vpr1'
    Assert-G4B (([IO.Path]::GetFullPath([string]$record['recovery_pending_local']) -ceq $script:recoveryPendingLocal) -and
        ([IO.Path]::GetFullPath([string]$record['recovery_pending_external']) -ceq ($expectedExternal+'.pending')) -and
        ([IO.Path]::GetFullPath([string]$record['recovery_final_local']) -ceq $script:secretRecoveryPath) -and
        ([IO.Path]::GetFullPath([string]$record['recovery_final_external']) -ceq $expectedExternal)) 'ROLLBACK_JOURNAL_RECOVERY_PATH_INVALID'
    return $record
}

function Get-JournalProfileSnapshot {
    param([Parameter(Mandatory=$true)][object]$Journal)
    $map=[Collections.Generic.SortedDictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach($entry in @($Journal['profile_before'])){
        Assert-G4B ($entry['path'] -is [string] -and $entry['metadata'] -is [string]) 'ROLLBACK_JOURNAL_PROFILE_BASELINE_INVALID'
        $map.Add([string]$entry['path'],[string]$entry['metadata'])
    }
    return ,$map
}

function Assert-ProfileStoreMatchesJournal {
    param([Parameter(Mandatory=$true)][object]$Journal)
    $before=Get-JournalProfileSnapshot -Journal $Journal
    $after=Get-ProfileSnapshot -Root ([string]$Journal['profile_store'])
    Assert-G4B ($before.Count -eq $after.Count) 'PROFILE_STORE_ROLLBACK_SHAPE_CHANGED'
    Assert-ExistingProfileStoreUnchanged -Before $before -After $after
}

function Remove-OwnedProfileFiles {
    param([Parameter(Mandatory=$true)][object]$Journal)
    $root=[IO.Path]::GetFullPath([string]$Journal['profile_store']).TrimEnd('\')+'\'
    foreach($path in @($Journal['profile_created_paths'])){
        $full=[IO.Path]::GetFullPath([string]$path)
        Assert-G4B ($full.StartsWith($root,[StringComparison]::OrdinalIgnoreCase) -and -not (Test-Path -LiteralPath $full -PathType Container)) 'PROFILE_ROLLBACK_PATH_INVALID'
        if(Test-Path -LiteralPath $full -PathType Leaf){
            $item=Get-Item -LiteralPath $full -Force -ErrorAction Stop
            Assert-G4B (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0 -and $item.Length -le 1048576) 'PROFILE_ROLLBACK_FILE_INVALID'
            $content=[IO.File]::ReadAllText($full,[Text.Encoding]::UTF8)
            Assert-G4B ($content.StartsWith('# G4B_RUN_ID='+$script:runId+[Environment]::NewLine,[StringComparison]::Ordinal)) 'PROFILE_ROLLBACK_OWNERSHIP_UNPROVEN'
            Remove-Item -LiteralPath $full -Force -ErrorAction Stop
            Assert-G4B (-not (Test-Path -LiteralPath $full)) 'PROFILE_ROLLBACK_REMOVE_UNVERIFIED'
        }
    }
}

function Resolve-SshExecutable {
    $cmd=Get-Command ssh.exe -ErrorAction Stop
    return $cmd.Source
}

function Invoke-Remote {
    param([string]$Action,[hashtable]$Payload=@{})
    $request=@{ action=$Action; run_id=$script:runId; payload=$Payload }
    $requestJson=ConvertTo-Json -InputObject $request -Depth 20 -Compress
    $requestB64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($requestJson))
    $program=Get-RemoteSupervisor
    $program=$program.Replace('__REQUEST_B64__',$requestB64)
    $psi=[Diagnostics.ProcessStartInfo]::new()
    $psi.FileName=Resolve-SshExecutable; $psi.UseShellExecute=$false; $psi.RedirectStandardInput=$true; $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true
    foreach($arg in @('-T','-i',$SshIdentityFile,'-o','BatchMode=yes','-o','IdentitiesOnly=yes','-o','StrictHostKeyChecking=yes','-o',('HostKeyAlias='+$script:hostKeyAlias),'-o',('UserKnownHostsFile='+$KnownHostsFile),'-o','ConnectTimeout=10',$script:controlTarget,'python3 -')) { [void]$psi.ArgumentList.Add($arg) }
    $process=[Diagnostics.Process]::new()
    try {
        $process.StartInfo=$psi
        if(-not $process.Start()){ throw 'SSH_PROCESS_START_FAILED' }
        $outTask=$process.StandardOutput.ReadToEndAsync(); $errTask=$process.StandardError.ReadToEndAsync()
        $process.StandardInput.Write($program); $process.StandardInput.Close()
        if(-not $process.WaitForExit(180000)){ try{$process.Kill($true)}catch{}; throw 'SSH_OPERATION_TIMEOUT' }
        $out=$outTask.GetAwaiter().GetResult(); [void]$errTask.GetAwaiter().GetResult()
        if($process.ExitCode -ne 0){ throw 'SSH_REMOTE_ACTION_FAILED' }
        $response=ConvertFrom-Json -InputObject $out -AsHashtable -ErrorAction Stop
        Assert-G4B ($response['ok'] -eq $true) 'REMOTE_ACTION_REJECTED'
        return $response
    }
    catch { throw (if ($_.Exception.Message -match '^[A-Z][A-Z0-9_]{1,95}$') { $_.Exception.Message } else { 'SSH_ACTION_FAILED' }) }
    finally { $process.Dispose(); [Security.Cryptography.CryptographicOperations]::ZeroMemory([Text.Encoding]::UTF8.GetBytes($requestJson)); [Security.Cryptography.CryptographicOperations]::ZeroMemory([Text.Encoding]::UTF8.GetBytes($program)) }
}

function Get-RemoteSupervisor {
@'
import base64, gzip, hashlib, json, os, pathlib, pwd, grp, re, secrets, shutil, socket, stat, subprocess, sys, urllib.request
REQ=json.loads(base64.b64decode('__REQUEST_B64__'))
RUN_ID=REQ['run_id']
ACTION=REQ['action']
P=REQ.get('payload',{})
ASSET_URL='https://github.com/MetaCubeX/mihomo/releases/download/v1.19.31/mihomo-linux-amd64-compatible-v1.19.31.gz'
ASSET_SHA='04cf9f09671704f839ddbee2e93069dc831a4123a75281e725d1d96ab9ac1afc'
BIN=pathlib.Path('/usr/local/lib/vpn-network-optimization/mihomo-reality')
RUNTIME=pathlib.Path('/srv/apps/vpn-network-optimization/reality')
SECRETS=pathlib.Path('/srv/apps/vpn-network-optimization/secrets/reality-server.yaml')
UNIT=pathlib.Path('/etc/systemd/system/mihomo-reality-vpn-network-optimization.service')
SERVICE='mihomo-reality-vpn-network-optimization.service'
USER='reality-vpn-network-optimization'
GROUP=USER
TXN=pathlib.Path('/var/lib')/('vpn-network-optimization-g4b-'+RUN_ID)
TMP=pathlib.Path('/tmp')/('vpn-network-optimization-g4b-'+RUN_ID)
class GateError(Exception):
    def __init__(self, code): self.code=code
def run(args, timeout=30, input_bytes=None):
    r=subprocess.run(args, input=input_bytes, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=timeout, check=False)
    if r.returncode != 0: raise GateError('REMOTE_NATIVE_COMMAND_FAILED')
    return r.stdout
def absent(path):
    try: path.lstat(); return False
    except FileNotFoundError: return True
def write_new(path, data, mode, uid=0, gid=0):
    flags=os.O_WRONLY|os.O_CREAT|os.O_EXCL|getattr(os,'O_NOFOLLOW',0)
    fd=os.open(path,flags,mode)
    try:
        with os.fdopen(fd,'wb',closefd=False) as f: f.write(data); f.flush(); os.fsync(f.fileno())
        os.fchmod(fd,mode); os.fchown(fd,uid,gid)
    finally: os.close(fd)
def ensure_directory(path, mode, uid, gid, state):
    path=pathlib.Path(path)
    if path.exists() or path.is_symlink():
        info=path.lstat()
        if not stat.S_ISDIR(info.st_mode) or stat.S_ISLNK(info.st_mode) or info.st_uid!=uid or info.st_gid!=gid or stat.S_IMODE(info.st_mode)!=mode:
            raise GateError('PROJECT_DIRECTORY_CONTRACT_INVALID')
        return False
    if not path.parent.is_dir() or path.parent.is_symlink(): raise GateError('PROJECT_DIRECTORY_PARENT_INVALID')
    path.mkdir(mode=mode)
    state.setdefault('created_parents',[]).append(str(path)); save_state(state)
    os.chown(path,uid,gid); os.chmod(path,mode)
    return True
def access_as(user, path, mode):
    account=pwd.getpwnam(user)
    pid=os.fork()
    if pid==0:
        try:
            os.setgroups([account.pw_gid] if user!= 'nobody' else [])
            os.setgid(account.pw_gid); os.setuid(account.pw_uid)
            os._exit(0 if os.access(path,mode,effective_ids=True) else 1)
        except BaseException: os._exit(125)
    _,status=os.waitpid(pid,0)
    if not os.WIFEXITED(status) or os.WEXITSTATUS(status)==125: raise GateError('ACCESS_IDENTITY_PROBE_FAILED')
    return os.WEXITSTATUS(status)==0
def load_state():
    state_path=TXN/'state.json'
    if not state_path.is_file() or state_path.is_symlink(): raise GateError('REMOTE_TRANSACTION_STATE_MISSING')
    return json.loads(state_path.read_text(encoding='utf-8'))
def save_state(s):
    tmp=TXN/'state.tmp'
    with open(tmp,'x',encoding='utf-8') as f: json.dump(s,f,separators=(',',':')); f.flush(); os.fsync(f.fileno())
    os.replace(tmp,TXN/'state.json')
def probe():
    if os.geteuid()!=0: raise GateError('REMOTE_ROOT_REQUIRED')
    host=socket.gethostname()
    osinfo=pathlib.Path('/etc/os-release').read_text(encoding='utf-8')
    mem=int(re.search(r'^MemAvailable:\s+(\d+)',pathlib.Path('/proc/meminfo').read_text(),re.M).group(1))
    free=shutil.disk_usage('/').free
    ss=subprocess.run(['ss','-H','-ltnup'],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,check=False,timeout=10)
    if ss.returncode: raise GateError('REMOTE_SOCKET_QUERY_FAILED')
    lines=ss.stdout.splitlines()
    count=lambda port,proto: sum(1 for x in lines if re.search(r'\b'+str(port)+r'\b',x) and (('udp' in x.lower()) if proto=='udp' else ('tcp' in x.lower())))
    wg=run(['systemctl','is-active','wg-quick@wg0']).decode().strip()
    hy=run(['systemctl','is-active','hysteria2-vpn-network-optimization.service']).decode().strip()
    unit=run(['systemctl','is-active',SERVICE],timeout=10).decode().strip() if not absent(UNIT) else 'absent'
    firewall={'ufw':subprocess.run(['ufw','status'],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,check=False,timeout=10).returncode if shutil.which('ufw') else -1,
              'nft':subprocess.run(['nft','list','ruleset'],stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False,timeout=10).returncode if shutil.which('nft') else -1}
    return {'hostname':host,'os_id':'ubuntu' if 'ID=ubuntu' in osinfo else 'unknown','os_version':'24.04' if 'VERSION_ID="24.04"' in osinfo else 'unknown','wg_service':wg,'hy2_service':hy,'udp51820':count(51820,'udp'),'udp8443':count(8443,'udp'),'tcp443':count(443,'tcp'),'reality_service':unit,'mihomo_processes':sum(1 for p in pathlib.Path('/proc').iterdir() if p.name.isdigit() and (pathlib.Path('/proc')/p.name/'comm').exists() and 'mihomo' in (pathlib.Path('/proc')/p.name/'comm').read_text(errors='ignore')),'memory_available_kib':mem,'root_free_bytes':free,'firewall_query_rc':firewall,'target_paths_absent':all(absent(x) for x in (BIN,RUNTIME,SECRETS,UNIT)),'transaction_path_absent':absent(TXN),'temp_path_absent':absent(TMP)}
def stage():
    if os.geteuid()!=0: raise GateError('REMOTE_ROOT_REQUIRED')
    if not all(absent(x) for x in (BIN,RUNTIME,SECRETS,UNIT,TXN,TMP)): raise GateError('PERSISTENT_TARGET_COLLISION')
    if shutil.which('getent') and subprocess.run(['getent','passwd',USER],stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False).returncode==0: raise GateError('RUNTIME_USER_COLLISION')
    if subprocess.run(['getent','group',GROUP],stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False).returncode==0: raise GateError('RUNTIME_GROUP_COLLISION')
    TXN.mkdir(mode=0o700); os.chmod(TXN,0o700)
    TMP.mkdir(mode=0o700); os.chmod(TMP,0o700)
    state={'run_id':RUN_ID,'created_binary':False,'created_user':False,'created_group':False,'created_runtime':False,'created_secrets_dir':False,'created_secret_config':False,'created_unit':False,'service_started':False,'created_parents':[],'pass_candidate':False}
    save_state(state)
    write_new(TMP/'.g4b-owner',(RUN_ID+'\n').encode(),0o600)
    try:
        ensure_directory(BIN.parent,0o755,0,0,state)
        run(['groupadd','--system',GROUP]); state['created_group']=True; save_state(state)
        run(['useradd','--system','--gid',GROUP,'--home-dir','/nonexistent','--shell','/usr/sbin/nologin',USER]); state['created_user']=True; save_state(state)
        archive=TMP/'mihomo.gz'
        digest=hashlib.sha256(); total=0
        with urllib.request.urlopen(ASSET_URL,timeout=60) as response, open(archive,'xb') as output:
            while True:
                chunk=response.read(1024*1024)
                if not chunk: break
                total+=len(chunk)
                if total>100*1024*1024: raise GateError('MIHOMO_ASSET_SIZE_LIMIT')
                digest.update(chunk); output.write(chunk)
            output.flush(); os.fsync(output.fileno())
        if digest.hexdigest()!=ASSET_SHA: raise GateError('MIHOMO_ASSET_HASH_MISMATCH')
        binary_tmp=TMP/'mihomo'
        with gzip.open(archive,'rb') as src, open(binary_tmp,'xb') as dst: shutil.copyfileobj(src,dst,1024*1024); dst.flush(); os.fsync(dst.fileno())
        state['created_binary']=True
        state['binary_sha256']=hashlib.sha256(binary_tmp.read_bytes()).hexdigest(); save_state(state)
        write_new(BIN,binary_tmp.read_bytes(),0o755)
        save_state(state)
        version=run([str(BIN),'-v'],timeout=15).decode(errors='replace')
        if 'v1.19.31' not in version: raise GateError('MIHOMO_VERSION_MISMATCH')
        return {'ok':True,'version':'v1.19.31','asset_hash':'PASS'}
    except Exception:
        rollback()
        raise
    finally:
        if not absent(TMP):
            marker=TMP/'.g4b-owner'
            if not marker.is_file() or marker.is_symlink() or marker.read_text(encoding='utf-8').strip()!=RUN_ID: raise GateError('STAGE_TEMP_OWNERSHIP_UNPROVEN')
            shutil.rmtree(TMP)
            if not absent(TMP): raise GateError('STAGE_TEMP_REMOVE_UNVERIFIED')
def configure():
    s=load_state()
    if not s.get('created_binary') or not BIN.is_file(): raise GateError('STAGED_BINARY_MISSING')
    config=base64.b64decode(P['server_config_b64'],validate=True)
    unit=base64.b64decode(P['unit_b64'],validate=True)
    if not config.startswith(b'# G4B_RUN_ID='+RUN_ID.encode()+b'\n') or not unit.startswith(b'# G4B_RUN_ID='+RUN_ID.encode()+b'\n'): raise GateError('RUN_OWNERSHIP_MARKER_INVALID')
    if not all(absent(x) for x in (RUNTIME,SECRETS,UNIT)): raise GateError('PERSISTENT_TARGET_COLLISION')
    uid=pwd.getpwnam(USER).pw_uid; gid=grp.getgrnam(GROUP).gr_gid
    ensure_directory(RUNTIME.parent,0o755,0,0,s)
    s['created_runtime']=ensure_directory(RUNTIME,0o750,uid,gid,s); save_state(s)
    ensure_directory(SECRETS.parent.parent,0o755,0,0,s)
    s['created_secrets_dir']=ensure_directory(SECRETS.parent,0o710,0,gid,s); save_state(s)
    marker=RUNTIME/'.g4b-owner'; write_new(marker,(RUN_ID+'\n').encode(),0o640,0,grp.getgrnam(GROUP).gr_gid)
    write_new(SECRETS,config,0o640,0,gid); s['created_secret_config']=True; save_state(s)
    config_info=SECRETS.stat(); secret_dir_info=SECRETS.parent.stat(); runtime_info=RUNTIME.stat()
    if config_info.st_uid!=0 or config_info.st_gid!=gid or stat.S_IMODE(config_info.st_mode)!=0o640 or secret_dir_info.st_uid!=0 or secret_dir_info.st_gid!=gid or stat.S_IMODE(secret_dir_info.st_mode)!=0o710 or runtime_info.st_uid!=uid or runtime_info.st_gid!=gid or stat.S_IMODE(runtime_info.st_mode)!=0o750: raise GateError('REALITY_FILESYSTEM_METADATA_INVALID')
    if not access_as(USER,RUNTIME,os.W_OK|os.X_OK) or not access_as(USER,SECRETS.parent,os.X_OK) or not access_as(USER,SECRETS,os.R_OK): raise GateError('REALITY_RUNTIME_ACCESS_INVALID')
    nobody=pwd.getpwnam('nobody')
    if nobody.pw_uid in (0,uid) or access_as('nobody',SECRETS,os.R_OK): raise GateError('REALITY_SECRET_UNRELATED_READ_ACCESS')
    if not shutil.which('runuser'): raise GateError('RUNTIME_CONFIG_CHECK_IDENTITY_UNAVAILABLE')
    check=run(['runuser','-u',USER,'--',str(BIN),'-t','-d',str(RUNTIME),'-f',str(SECRETS)],timeout=30)
    staged=TXN/SERVICE; write_new(staged,unit,0o600)
    run(['systemd-analyze','verify',str(staged)],timeout=20)
    write_new(UNIT,unit,0o644); s['created_unit']=True; save_state(s)
    return {'ok':True,'config_parse':'PASS','systemd_unit_parse':'PASS','runtime_access':'PASS','unrelated_secret_read':'DENIED'}
def enable():
    s=load_state()
    if not s.get('created_unit') or not s.get('created_secret_config'): raise GateError('CONFIG_NOT_STAGED')
    run(['systemctl','daemon-reload']); run(['systemctl','enable','--now',SERVICE],timeout=45); s['service_started']=True; save_state(s)
    return status()
def restart():
    run(['systemctl','restart',SERVICE],timeout=45)
    return status()
def status():
    active=run(['systemctl','is-active',SERVICE],timeout=10).decode().strip()
    ss=subprocess.run(['ss','-H','-ltnp','sport','=',':443'],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,check=False,timeout=10)
    if ss.returncode: raise GateError('TCP443_LISTENER_QUERY_FAILED')
    lines=ss.stdout.splitlines()
    owned=bool(lines) and all('mihomo' in x.lower() for x in lines)
    if active!='active' or not lines or not owned: raise GateError('REALITY_LISTENER_READBACK_INVALID')
    return {'ok':True,'service':'active','tcp443_listener':'mihomo'}
def rollback():
    if absent(TXN):
        if not absent(TMP): raise GateError('ROLLBACK_TEMP_OWNERSHIP_UNPROVEN')
        check=probe()
        if not check['target_paths_absent'] or check['reality_service']!='absent' or check['wg_service']!='active' or check['hy2_service']!='active' or check['udp51820']==0 or check['udp8443']==0 or check['tcp443']!=0: raise GateError('ROLLBACK_NO_TRANSACTION_READBACK_FAILED')
        return {'ok':True,'rollback':'PASS','target_paths':'absent','wg_hy2':'preserved'}
    s=load_state()
    if s.get('run_id')!=RUN_ID: raise GateError('ROLLBACK_OWNERSHIP_MISMATCH')
    if s.get('created_unit') and not absent(UNIT):
        text=UNIT.read_text(encoding='utf-8')
        if not text.startswith('# G4B_RUN_ID='+RUN_ID): raise GateError('ROLLBACK_UNIT_OWNERSHIP_UNPROVEN')
        run(['systemctl','disable','--now',SERVICE],timeout=30)
        active=subprocess.run(['systemctl','is-active',SERVICE],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,check=False,timeout=10)
        if active.returncode==0 or active.stdout.strip()=='active': raise GateError('ROLLBACK_SERVICE_STOP_UNVERIFIED')
        UNIT.unlink(); run(['systemctl','daemon-reload'])
        if not absent(UNIT): raise GateError('ROLLBACK_UNIT_REMOVE_UNVERIFIED')
    if s.get('created_secret_config') and not absent(SECRETS):
        if not SECRETS.read_bytes().startswith(b'# G4B_RUN_ID='+RUN_ID.encode()+b'\n'): raise GateError('ROLLBACK_CONFIG_OWNERSHIP_UNPROVEN')
        SECRETS.unlink()
        if not absent(SECRETS): raise GateError('ROLLBACK_CONFIG_REMOVE_UNVERIFIED')
    if s.get('created_secrets_dir') and not absent(SECRETS.parent):
        info=SECRETS.parent.lstat()
        if not stat.S_ISDIR(info.st_mode) or stat.S_ISLNK(info.st_mode) or info.st_uid!=0 or info.st_gid!=grp.getgrnam(GROUP).gr_gid or stat.S_IMODE(info.st_mode)!=0o710: raise GateError('ROLLBACK_SECRETS_DIRECTORY_OWNERSHIP_UNPROVEN')
        SECRETS.parent.rmdir()
        if not absent(SECRETS.parent): raise GateError('ROLLBACK_SECRETS_DIRECTORY_REMOVE_UNVERIFIED')
    if s.get('created_runtime') and not absent(RUNTIME):
        marker=RUNTIME/'.g4b-owner'
        if not marker.is_file() or marker.is_symlink() or marker.read_text(encoding='utf-8').strip()!=RUN_ID: raise GateError('ROLLBACK_RUNTIME_OWNERSHIP_UNPROVEN')
        shutil.rmtree(RUNTIME)
        if not absent(RUNTIME): raise GateError('ROLLBACK_RUNTIME_REMOVE_UNVERIFIED')
    if s.get('created_binary') and not absent(BIN):
        if not s.get('binary_sha256') or hashlib.sha256(BIN.read_bytes()).hexdigest()!=s['binary_sha256']: raise GateError('ROLLBACK_BINARY_OWNERSHIP_UNPROVEN')
        BIN.unlink()
        if not absent(BIN): raise GateError('ROLLBACK_BINARY_REMOVE_UNVERIFIED')
    if s.get('created_user'):
        run(['userdel',USER],timeout=15)
        if subprocess.run(['getent','passwd',USER],stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False,timeout=10).returncode!=2: raise GateError('ROLLBACK_USER_REMOVE_UNVERIFIED')
    if s.get('created_group'):
        run(['groupdel',GROUP],timeout=15)
        if subprocess.run(['getent','group',GROUP],stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False,timeout=10).returncode!=2: raise GateError('ROLLBACK_GROUP_REMOVE_UNVERIFIED')
    for parent in reversed(s.get('created_parents',[])):
        path=pathlib.Path(parent)
        if path not in (BIN.parent,RUNTIME.parent,RUNTIME,SECRETS.parent): raise GateError('ROLLBACK_PARENT_SCOPE_INVALID')
        if not absent(path):
            info=path.lstat()
            if not stat.S_ISDIR(info.st_mode) or stat.S_ISLNK(info.st_mode) or info.st_uid!=0 or info.st_gid!=0 or stat.S_IMODE(info.st_mode)!=0o755: raise GateError('ROLLBACK_PARENT_OWNERSHIP_UNPROVEN')
            path.rmdir()
            if not absent(path): raise GateError('ROLLBACK_PARENT_REMOVE_UNVERIFIED')
    if not absent(TMP):
        marker=TMP/'.g4b-owner'
        if not marker.is_file() or marker.is_symlink() or marker.read_text(encoding='utf-8').strip()!=RUN_ID: raise GateError('ROLLBACK_TEMP_OWNERSHIP_UNPROVEN')
        shutil.rmtree(TMP)
    shutil.rmtree(TXN)
    check=probe()
    if not check['target_paths_absent'] or check['reality_service']!='absent' or check['wg_service']!='active' or check['hy2_service']!='active' or check['udp51820']==0 or check['udp8443']==0 or check['tcp443']!=0: raise GateError('ROLLBACK_POSTREMOVE_READBACK_FAILED')
    return {'ok':True,'rollback':'PASS','target_paths':'absent','wg_hy2':'preserved'}
def closeout():
    if absent(TXN): raise GateError('CLOSEOUT_TRANSACTION_MISSING')
    s=load_state()
    if s.get('run_id')!=RUN_ID: raise GateError('CLOSEOUT_OWNERSHIP_MISMATCH')
    if s.get('pass_candidate') is not True: raise GateError('CLOSEOUT_PASS_CANDIDATE_NOT_RECORDED')
    if P.get('reviewer_decision')!='FORMAL_PASS_G4B_PERSISTENT_THREE_ROLE_READINESS': raise GateError('CLOSEOUT_REVIEWER_PASS_REQUIRED')
    current=status()
    if current.get('service')!='active' or current.get('tcp443_listener')!='mihomo': raise GateError('CLOSEOUT_SERVICE_READBACK_FAILED')
    if not absent(TMP):
        marker=TMP/'.g4b-owner'
        if not marker.is_file() or marker.is_symlink() or marker.read_text(encoding='utf-8').strip()!=RUN_ID: raise GateError('CLOSEOUT_TEMP_OWNERSHIP_UNPROVEN')
        shutil.rmtree(TMP)
    shutil.rmtree(TXN)
    return {'ok':True,'closeout':'PASS','ownership_state_removed':'YES'}
def candidate():
    if absent(TXN): raise GateError('CANDIDATE_TRANSACTION_MISSING')
    s=load_state()
    if s.get('run_id')!=RUN_ID: raise GateError('CANDIDATE_OWNERSHIP_MISMATCH')
    current=status()
    if current.get('service')!='active' or current.get('tcp443_listener')!='mihomo': raise GateError('CANDIDATE_SERVICE_READBACK_FAILED')
    s['pass_candidate']=True; save_state(s)
    return {'ok':True,'rollback_journal_retained':'YES'}
def main():
    if ACTION=='probe': return {'ok':True,**probe()}
    if ACTION=='stage': return stage()
    if ACTION=='configure': return configure()
    if ACTION=='enable': return enable()
    if ACTION=='restart': return restart()
    if ACTION=='status': return status()
    if ACTION=='rollback': return rollback()
    if ACTION=='closeout': return closeout()
    if ACTION=='candidate': return candidate()
    raise GateError('REMOTE_ACTION_INVALID')
try:
    result=main()
    sys.stdout.write(json.dumps(result,separators=(',',':'))+'\n')
except GateError as exc:
    sys.stdout.write(json.dumps({'ok':False,'error_code':exc.code},separators=(',',':'))+'\n')
    sys.exit(2)
except Exception:
    sys.stdout.write(json.dumps({'ok':False,'error_code':'REMOTE_UNCLASSIFIED'},separators=(',',':'))+'\n')
    sys.exit(3)
'@
}

function Get-ProfileRenderedText {
    param([string]$Template,[string]$Uuid,[string]$PublicKey,[string]$ShortId,[string]$InterfaceName)
    $cfg=ConvertFrom-Json -InputObject $Template -AsHashtable -ErrorAction Stop
    Assert-G4B ($cfg['proxies'].Count -eq 3 -and $cfg['proxy-groups'].Count -eq 1) 'THREE_ROLE_TEMPLATE_SHAPE_INVALID'
    Assert-G4B ($cfg['proxies'][0]['name'] -ceq 'HY2-SFO3' -and $cfg['proxies'][1]['name'] -ceq 'WG-BASELINE' -and $cfg['proxies'][1]['type'] -ceq 'direct' -and $cfg['proxies'][2]['name'] -ceq 'REALITY-SFO3') 'THREE_ROLE_TEMPLATE_ORDER_INVALID'
    Assert-G4B ($cfg['proxy-groups'][0]['type'] -ceq 'select' -and ($cfg['proxy-groups'][0]['proxies'] -join '|') -ceq 'HY2-SFO3|WG-BASELINE|REALITY-SFO3') 'THREE_ROLE_SELECTOR_INVALID'
    $cfg['proxies'][0]['server']=$script:publicIp; $cfg['proxies'][0]['password']=$script:hy2Auth; $cfg['proxies'][0]['sni']='hy2.sfo3-a.invalid'; $cfg['proxies'][0]['interface-name']=$InterfaceName
    $cfg['proxies'][2]['server']=$script:publicIp; $cfg['proxies'][2]['uuid']=$Uuid; $cfg['proxies'][2]['reality-opts']['public-key']=$PublicKey; $cfg['proxies'][2]['reality-opts']['short-id']=$ShortId; $cfg['proxies'][2]['interface-name']=$InterfaceName
    return ('# G4B_RUN_ID='+$script:runId+[Environment]::NewLine+(ConvertTo-Json -InputObject $cfg -Depth 20 -Compress))
}

function Write-OwnerOnlyFile {
    param([string]$Path,[byte[]]$Bytes,[switch]$RecoveryArtifact,[switch]$RollbackJournal)
    $stream=[IO.File]::Open($Path,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
    if($RecoveryArtifact){$script:recoveryCreatedPaths.Add($Path)}
    if($RollbackJournal){$script:journalCreated=$true}
    try { $stream.Write($Bytes,0,$Bytes.Length); $stream.Flush($true) } finally { $stream.Dispose() }
    Set-Acl -LiteralPath $Path -AclObject (New-OwnerAcl) -ErrorAction Stop
    Assert-OwnerAcl -Path $Path
}

try {
    if (-not $Live) { Write-Output 'G4B_RUNNER_LIVE_MODE=NOT_REQUESTED'; return }
    Write-Phase 'P0_CANONICAL_SOURCE'
    if($Mode -ne 'Run'){Assert-G4B ($RunId -match '^[0-9a-f]{32}$') 'ROLLBACK_RUN_ID_REQUIRED'}
    Assert-G4B ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    $principal=[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-G4B ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
    Assert-G4B ((Get-IntegrityRid) -ge 12288) 'HIGH_INTEGRITY_REQUIRED'
    Assert-G4B ($OwnerAuthorization -ceq 'OWNER_G4B_LIVE_AUTHORIZATION=APPROVED') 'OWNER_G4B_AUTHORIZATION_REQUIRED'
    Assert-G4B ($SecondFailureDomainAcknowledgement -ceq 'SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED') 'SECOND_FAILURE_DOMAIN_AUTHORIZATION_REQUIRED'
    Assert-G4B (-not [string]::IsNullOrWhiteSpace($SshIdentityFile) -and (Test-Path -LiteralPath $SshIdentityFile -PathType Leaf)) 'SSH_IDENTITY_FILE_INVALID'
    Assert-G4B (Test-Path -LiteralPath $KnownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_MISSING'
    Assert-CanonicalSource

    if($Mode -eq 'Rollback'){
        $script:baseline=Get-LocalBaseline
        $journal=Read-RollbackJournal
        $script:profileStore=[string]$journal['profile_store']
        $rollback=Invoke-Remote -Action 'rollback'
        Assert-G4B ($rollback['rollback'] -ceq 'PASS') 'BOUNDED_REMOTE_ROLLBACK_UNVERIFIED'
        Remove-OwnedProfileFiles -Journal $journal
        Assert-ProfileStoreMatchesJournal -Journal $journal
        foreach($path in @($journal['recovery_pending_local'],$journal['recovery_pending_external'])){
            if(Test-Path -LiteralPath $path -PathType Leaf){Assert-OwnerAcl -Path $path; Remove-Item -LiteralPath $path -Force -ErrorAction Stop; Assert-G4B (-not (Test-Path -LiteralPath $path)) 'ROLLBACK_RECOVERY_PENDING_REMOVE_UNVERIFIED'}
        }
        Remove-Item -LiteralPath $script:rollbackJournal -Force -ErrorAction Stop
        Assert-G4B (-not (Test-Path -LiteralPath $script:rollbackJournal)) 'ROLLBACK_JOURNAL_REMOVE_UNVERIFIED'
        $after=Get-LocalBaseline; Assert-SameLocalBaseline -Before $script:baseline -After $after
        $script:completed=$true
        Write-Output 'G4B_BOUNDED_ROLLBACK=PASS'; Write-Output 'RECOVERY_FINAL_ARTIFACTS_PRESERVED=YES'; Write-Output 'STOP_AT_REVIEWER=YES'
        return
    }
    if($Mode -eq 'Closeout'){
        Assert-G4B ($ReviewerDecision -ceq 'FORMAL_PASS_G4B_PERSISTENT_THREE_ROLE_READINESS') 'CLOSEOUT_REVIEWER_PASS_REQUIRED'
        $script:baseline=Get-LocalBaseline
        $journal=Read-RollbackJournal
        Assert-G4B ($journal['status'] -ceq 'PASS_CANDIDATE') 'CLOSEOUT_PASS_CANDIDATE_REQUIRED'
        $script:profileStore=[string]$journal['profile_store']
        $profileBefore=Get-JournalProfileSnapshot -Journal $journal
        $profileCurrent=Get-ProfileSnapshot -Root $script:profileStore
        Assert-ExistingProfileStoreUnchanged -Before $profileBefore -After $profileCurrent
        $expectedCreated=@($journal['profile_created_paths'] | ForEach-Object { [IO.Path]::GetRelativePath($script:profileStore,[string]$_).Replace('\','/') } | Sort-Object)
        $actualCreated=@($profileCurrent.Keys | Where-Object { -not $profileBefore.ContainsKey($_) } | Sort-Object)
        Assert-G4B (($expectedCreated -join '|') -ceq ($actualCreated -join '|')) 'CLOSEOUT_PROFILE_STORE_DRIFT'
        foreach($path in @($journal['profile_created_paths'])){[void](Get-ProfileSemanticState -Path ([string]$path))}
        $closed=Invoke-Remote -Action 'closeout' -Payload @{reviewer_decision=$ReviewerDecision}
        Assert-G4B ($closed['closeout'] -ceq 'PASS') 'REMOTE_CLOSEOUT_UNVERIFIED'
        Remove-Item -LiteralPath $script:rollbackJournal -Force -ErrorAction Stop
        Assert-G4B (-not (Test-Path -LiteralPath $script:rollbackJournal)) 'CLOSEOUT_JOURNAL_REMOVE_UNVERIFIED'
        $script:completed=$true
        Write-Output 'G4B_REVIEWER_PASS_CLOSEOUT=PASS'; Write-Output 'RECOVERY_FINAL_ARTIFACTS_PRESERVED=YES'; Write-Output 'STOP_AT_REVIEWER=YES'
        return
    }

    Write-Phase 'P1_OWNER_HOST_AND_NETWORK_PREFLIGHT'
    $script:baseline=Get-LocalBaseline
    $script:physicalEgress=Resolve-PhysicalEgress
    Assert-G4B (Test-Path -LiteralPath $script:localRuntimeRoot -PathType Container) 'LOCAL_RUNTIME_ROOT_MISSING'
    Assert-OwnerAcl -Path $script:localRuntimeRoot
    Assert-G4B (-not (Test-Path -LiteralPath $script:localRuntime)) 'LOCAL_RUNTIME_COLLISION'
    $script:profileStore=Resolve-ProfileStoreRoot
    $script:profileBefore=Get-ProfileSnapshot -Root $script:profileStore
    Assert-G4B (@($script:profileBefore.Keys | Where-Object { $_ -match '(?i)(^|/)SELF-VPN-V1(?:\.[^/]*)?$' }).Count -eq 0) 'THREE_ROLE_PROFILE_COLLISION'
    Assert-G4B (-not (Test-Path -LiteralPath $script:secretRecoveryPath)) 'REALITY_RECOVERY_COLLISION'

    Write-Phase 'P2_STRICT_TARGET_IDENTITY'
    $remote=Invoke-Remote -Action 'probe'
    Assert-G4B ($remote['hostname'] -ceq 'ubuntu-s-1vcpu-512mb-10gb-sfo3' -and $remote['os_id'] -ceq 'ubuntu' -and $remote['os_version'] -ceq '24.04') 'VPS_IDENTITY_INVALID'
    Assert-G4B ($remote['transaction_path_absent'] -eq $true -and $remote['temp_path_absent'] -eq $true) 'REMOTE_RUN_PATH_COLLISION'

    Write-Phase 'P3_WG_HY2_TCP443_BASELINE'
    Assert-G4B ($remote['wg_service'] -ceq 'active' -and [int]$remote['udp51820'] -gt 0) 'VPS_WIREGUARD_BASELINE_INVALID'
    Assert-G4B ($remote['hy2_service'] -ceq 'active' -and [int]$remote['udp8443'] -gt 0) 'VPS_HY2_BASELINE_INVALID'
    Assert-G4B ([int]$remote['tcp443'] -eq 0 -and [int]$remote['mihomo_processes'] -eq 0) 'VPS_TCP443_OR_PROCESS_COLLISION'
    Assert-G4B ([long]$remote['memory_available_kib'] -ge 131072 -and [long]$remote['root_free_bytes'] -ge 268435456) 'VPS_RESOURCE_HEADROOM_INSUFFICIENT'

    Write-Phase 'P4_REALITY_RUNTIME_IDENTITY_AND_PATH_PREFLIGHT'
    Assert-G4B ($remote['target_paths_absent'] -eq $true -and $remote['reality_service'] -eq 'absent') 'REALITY_TARGET_PATH_COLLISION'

    Write-Phase 'P5_SECRET_AND_RECOVERY_PREPARE'
    Assert-G4B ($SecondFailureDomainPath -and (Test-Path -LiteralPath $SecondFailureDomainPath -PathType Container)) 'SECOND_FAILURE_DOMAIN_DESTINATION_REQUIRED'
    Read-Hy2Auth
    $credentials=New-RealityCredentials
    Assert-G4B ($credentials['uuid'] -match '^[0-9a-f-]{36}$' -and $credentials['private_key'] -match '^[A-Za-z0-9_-]{40,64}$' -and $credentials['public_key'] -match '^[A-Za-z0-9_-]{40,64}$' -and $credentials['short_id'] -match '^[0-9a-f]{16}$') 'REALITY_CREDENTIAL_FORMAT_INVALID'
    $script:portablePassphrase=Read-Host 'Enter portable recovery passphrase (input hidden; minimum 16 characters)' -AsSecureString
    $recoveryJson=ConvertTo-Json -InputObject @{format='VPNG4BR1';hy2_auth=$script:hy2Auth;reality_uuid=$credentials['uuid'];reality_private_key=$credentials['private_key'];reality_public_key=$credentials['public_key'];reality_short_id=$credentials['short_id']} -Compress
    $recoveryBytes=[Text.Encoding]::UTF8.GetBytes($recoveryJson)
    try { Write-EncryptedRecovery -PayloadBytes $recoveryBytes -Passphrase $script:portablePassphrase }
    finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($recoveryBytes); $recoveryJson=$null }
    Write-Output 'G4B_RECOVERY_PENDING_VERIFIED=YES'

    [void][IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory),$script:localRuntime)
    Assert-OwnerAcl -Path $script:localRuntime
    $profileTemplate=[IO.File]::ReadAllText((Join-Path $script:projectRoot 'templates\clash\self-vpn-v1-three-role.yaml.template'),[Text.Encoding]::UTF8)
    $rendered=Get-ProfileRenderedText -Template $profileTemplate -Uuid $credentials['uuid'] -PublicKey $credentials['public_key'] -ShortId $credentials['short_id'] -InterfaceName $script:physicalEgress.Name
    $profileBytes=[Text.Encoding]::UTF8.GetBytes($rendered)
    try { Write-OwnerOnlyFile -Path $script:profileConfig -Bytes $profileBytes } finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($profileBytes) }
    Invoke-MihomoParse -ConfigPath $script:profileConfig
    [void](Get-ProfileSemanticState -Path $script:profileConfig)
    Write-RollbackJournal -Status 'IN_PROGRESS'

    $script:remoteMutationStarted=$true
    $script:remoteCredentials=Invoke-Remote -Action 'stage'
    Assert-G4B ($script:remoteCredentials['version'] -ceq 'v1.19.31' -and $script:remoteCredentials['asset_hash'] -ceq 'PASS') 'PINNED_MIHOMO_ASSET_INVALID'

    Write-Phase 'P6_SERVER_CONFIG_PARSE'
    $serverTemplate=[IO.File]::ReadAllText((Join-Path $script:projectRoot 'templates\reality\mihomo-reality-server.yaml.template'),[Text.Encoding]::UTF8)
    $required=@('__VPS_PUBLIC_IP__','__REALITY_UUID_INJECT_PROTECTED_RUNTIME_ONLY__','__REALITY_PRIVATE_KEY_INJECT_PROTECTED_RUNTIME_ONLY__','__REALITY_SHORT_ID_INJECT_PROTECTED_RUNTIME_ONLY__')
    foreach($marker in $required){ Assert-G4B ($serverTemplate.Contains($marker)) 'REALITY_SERVER_TEMPLATE_PLACEHOLDER_MISSING' }
    $serverRendered=$serverTemplate.Replace('__VPS_PUBLIC_IP__',$script:publicIp).Replace('__REALITY_UUID_INJECT_PROTECTED_RUNTIME_ONLY__',[string]$credentials['uuid']).Replace('__REALITY_PRIVATE_KEY_INJECT_PROTECTED_RUNTIME_ONLY__',[string]$credentials['private_key']).Replace('__REALITY_SHORT_ID_INJECT_PROTECTED_RUNTIME_ONLY__',[string]$credentials['short_id'])
    $serverRendered="# G4B_RUN_ID=$($script:runId)`n"+$serverRendered
    $serviceTemplate=[IO.File]::ReadAllText((Join-Path $script:projectRoot 'templates\systemd\mihomo-reality-vpn-network-optimization.service.template'),[Text.Encoding]::UTF8).Replace('__REALITY_RUNTIME_USER__',$script:runtimeUser)
    $unitRendered="# G4B_RUN_ID=$($script:runId)`n"+$serviceTemplate
    $configured=Invoke-Remote -Action 'configure' -Payload @{server_config_b64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($serverRendered));unit_b64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($unitRendered))}
    Assert-G4B ($configured['config_parse'] -ceq 'PASS' -and $configured['systemd_unit_parse'] -ceq 'PASS') 'SERVER_CONFIG_OR_UNIT_PARSE_FAILED'
    Assert-G4B ($configured['runtime_access'] -ceq 'PASS' -and $configured['unrelated_secret_read'] -ceq 'DENIED') 'REALITY_FILESYSTEM_ACCESS_PROOF_FAILED'
    Write-Output 'G4B_REALITY_RUNTIME_ACCESS=PASS'

    Write-Phase 'P7_SERVICE_ENABLE_AND_LISTENER_READBACK'
    $ready=Invoke-Remote -Action 'enable'
    Assert-G4B ($ready['service'] -ceq 'active' -and $ready['tcp443_listener'] -ceq 'mihomo') 'REALITY_SERVICE_LISTENER_INVALID'

    Write-Phase 'P8_PUBLIC_REALITY_READINESS'
    $tcp=Test-NetConnection -ComputerName $script:publicIp -Port 443 -ConstrainSourceAddress $script:physicalEgress.Source -WarningAction SilentlyContinue
    Assert-G4B ($tcp.TcpTestSucceeded) 'PUBLIC_TCP443_UNREACHABLE'

    Write-Phase 'P9_OWNER_THREE_ROLE_PROFILE_PREPARE'
    Assert-G4B ($script:profileConfig -and (Test-Path -LiteralPath $script:profileConfig -PathType Leaf)) 'THREE_ROLE_PROFILE_NOT_PREPARED'
    Write-Output ('OWNER_UI_IMPORT_PATH='+$script:profileConfig)

    Write-Phase 'P10_OWNER_UI_IMPORT_AND_VISIBILITY'
    $ack='G4B_PROFILE_ACK|IMPORTED=YES|VISIBLE=YES|ACTIVE_PROFILE=UNCHANGED|ORDER=HY2-SFO3,WG-BASELINE,REALITY-SFO3|DEFAULT=HY2-SFO3|AUTO=OFF|SYSTEM_PROXY=OFF|TUN=OFF'
    Assert-G4B ((Read-Host ('Import only the named three-role profile; verify it is visible without activating it. Type: '+$ack)) -ceq $ack) 'OWNER_PROFILE_IMPORT_ACK_INVALID'
    $afterImport=Get-ProfileSnapshot -Root $script:profileStore
    Assert-ExistingProfileStoreUnchanged -Before $script:profileBefore -After $afterImport
    $added=@($afterImport.Keys | Where-Object { -not $script:profileBefore.ContainsKey($_) })
    Assert-G4B ($added.Count -eq 1 -and $added[0] -match '(?i)(^|[\/])SELF-VPN-V1(?:\.[^/]*)?$' -and $afterImport[$added[0]] -cne 'DIR') 'THREE_ROLE_PROFILE_IMPORT_NOT_READ_BACK'
    $importedProfilePath=Join-Path $script:profileStore $added[0]
    $script:profileCreatedPaths.Add($importedProfilePath)
    [void](Get-ProfileSemanticState -Path $importedProfilePath)
    Write-RollbackJournal -Status 'IN_PROGRESS'
    Assert-OwnerAcl -Path $script:localRuntime
    Remove-Item -LiteralPath $script:localRuntime -Recurse -Force -ErrorAction Stop
    Assert-G4B (-not (Test-Path -LiteralPath $script:localRuntime)) 'LOCAL_SECRET_RUNTIME_NOT_REMOVED_AFTER_IMPORT'

    Write-Phase 'P11_RESTART_PERSISTENCE'
    $restarted=Invoke-Remote -Action 'restart'
    Assert-G4B ($restarted['service'] -ceq 'active' -and $restarted['tcp443_listener'] -ceq 'mihomo') 'REALITY_RESTART_PERSISTENCE_FAILED'
    Restart-Service -Name 'clash_verge_service' -ErrorAction Stop
    $script:baselineAfterRestart=Get-LocalBaseline
    Assert-SameLocalBaseline -Before $script:baseline -After $script:baselineAfterRestart
    $profileAfterRestart=Get-ProfileSnapshot -Root $script:profileStore
    Assert-ExistingProfileStoreUnchanged -Before $script:profileBefore -After $profileAfterRestart
    Assert-G4B ($profileAfterRestart.ContainsKey($added[0]) -and $profileAfterRestart[$added[0]] -cne 'DIR') 'RESTART_PROFILE_NOT_PERSISTED'
    [void](Get-ProfileSemanticState -Path $importedProfilePath)
    $script:profileSnapshotAfterImport=$profileAfterRestart
    Write-Output 'G4B_THREE_ROLE_PROFILE_RESTART_PERSISTENCE=PASS'

    Write-Phase 'P12_FINAL_BASELINE_READBACK'
    $final=Get-LocalBaseline
    Assert-SameLocalBaseline -Before $script:baseline -After $final
    $remoteFinal=Invoke-Remote -Action 'status'
    Assert-G4B ($remoteFinal['service'] -ceq 'active' -and $remoteFinal['tcp443_listener'] -ceq 'mihomo') 'FINAL_REALITY_READBACK_FAILED'
    $remoteBaseline=Invoke-Remote -Action 'probe'
    Assert-G4B ($remoteBaseline['wg_service'] -ceq 'active' -and [int]$remoteBaseline['udp51820'] -gt 0 -and $remoteBaseline['hy2_service'] -ceq 'active' -and [int]$remoteBaseline['udp8443'] -gt 0) 'FINAL_WG_HY2_READBACK_FAILED'
    $remoteCandidate=Invoke-Remote -Action 'candidate'
    Assert-G4B ($remoteCandidate['rollback_journal_retained'] -ceq 'YES') 'REMOTE_ROLLBACK_JOURNAL_NOT_RETAINED'
    $finalRecoveryJson=ConvertTo-Json -InputObject @{format='VPNG4BR1';hy2_auth=$script:hy2Auth;reality_uuid=$credentials['uuid'];reality_private_key=$credentials['private_key'];reality_public_key=$credentials['public_key'];reality_short_id=$credentials['short_id']} -Compress
    $finalRecoveryBytes=[Text.Encoding]::UTF8.GetBytes($finalRecoveryJson)
    try { Promote-RecoveryArtifacts -PayloadBytes $finalRecoveryBytes }
    finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($finalRecoveryBytes); $finalRecoveryJson=$null }
    Write-RollbackJournal -Status 'PASS_CANDIDATE'
    $script:preserveRollbackJournal=$true
    $script:completed=$true
    Write-Output ('G4B_ROLLBACK_RUN_ID='+$script:runId)
    Write-Output ('G4B_ROLLBACK_JOURNAL='+$script:rollbackJournal)
    Write-Output 'G4B_RECOVERY_FINAL_PROMOTED=YES'
    Write-Output 'G4B_RECOVERY_PORTABLE_FORMAT=VPNG4BP1'
    Write-Output 'G4B_REALITY_SERVICE_READY=YES'
    Write-Output 'G4B_PUBLIC_TCP443_READY=YES'
    Write-Output 'G4B_THREE_ROLE_PROFILE_IMPORTED=YES'
    Write-Output 'G4B_ROLE_ORDER=HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2'
    Write-Output 'G4B_AUTO_SWITCHING=OFF'
    Write-Output 'G4B_WIREGUARD_PRESERVED=YES'
    Write-Output 'G4B_HY2_PRESERVED=YES'
    Write-Output 'G4B_SYSTEM_PROXY_FINAL=OFF'
    Write-Output 'G4B_TUN_FINAL=OFF'
    Write-Output 'G4B_ROLLBACK_JOURNAL_RETAINED=YES'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output 'G4B_PERSISTENT_THREE_ROLE_RUNNER=PASS_CANDIDATE'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
catch {
    $code=[string]$_.Exception.Message
    if ($code -notmatch '^[A-Z][A-Z0-9_]{1,95}$') { $code='UNCLASSIFIED' }
    Write-Output ('RUNNER_FAILED_PHASE='+$script:phase)
    Write-Output ('FAILURE_CODE='+$code)
    Write-Output ('CONSEQUENTIAL_MUTATION_STARTED='+$(if($script:remoteMutationStarted){'YES'}else{'NO'}))
    exit 1
}
finally {
    if (-not $script:completed) {
        if ($script:remoteMutationStarted -or $script:recoveryCreatedPaths.Count -gt 0) {
            try {
                $rollback=Invoke-Remote -Action 'rollback'
                if($rollback['rollback'] -ceq 'PASS') { $script:remoteRollbackVerified=$true; Write-Output 'REMOTE_ROLLBACK=PASS' }
                else { Write-Output 'REMOTE_ROLLBACK=FAIL' }
            }
            catch { Write-Output 'REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION' }
        }
        $localCleanupVerified=$true
        if($script:remoteRollbackVerified -and $script:profileCreatedPaths.Count -gt 0){
            try { Remove-OwnedProfileFiles -Journal @{profile_store=$script:profileStore;profile_created_paths=@($script:profileCreatedPaths)}; Write-Output 'PROFILE_ROLLBACK=PASS' }
            catch { $localCleanupVerified=$false; Write-Output 'PROFILE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION' }
        }
        if ($script:remoteRollbackVerified -and $localCleanupVerified) {
            foreach($path in $script:recoveryCreatedPaths){
                try {
                    if([IO.Path]::GetExtension($path) -ceq '.pending' -and (Test-Path -LiteralPath $path -PathType Leaf)){
                        Assert-OwnerAcl -Path $path; Remove-Item -LiteralPath $path -Force -ErrorAction Stop
                        Assert-G4B (-not (Test-Path -LiteralPath $path)) 'RECOVERY_PENDING_REMOVE_UNVERIFIED'
                    }
                } catch { $localCleanupVerified=$false; Write-Output 'RECOVERY_ARTIFACT_CLEANUP=FAIL' }
            }
        } elseif ($script:recoveryCreatedPaths.Count -gt 0) {
            Write-Output 'RECOVERY_ARTIFACT_CLEANUP=RETAINED_ROLLBACK_UNVERIFIED'
        }
        if (Test-Path -LiteralPath $script:localRuntime -PathType Container) {
            try { Assert-OwnerAcl -Path $script:localRuntime; Remove-Item -LiteralPath $script:localRuntime -Recurse -Force -ErrorAction Stop; Assert-G4B (-not (Test-Path -LiteralPath $script:localRuntime)) 'LOCAL_RUNTIME_REMOVE_UNVERIFIED' }
            catch { $localCleanupVerified=$false; Write-Output 'LOCAL_RUNTIME_CLEANUP=FAIL' }
        }
        if($script:journalCreated -and $script:remoteRollbackVerified -and $localCleanupVerified -and (Test-Path -LiteralPath $script:rollbackJournal -PathType Leaf)){
            try { Assert-OwnerAcl -Path $script:rollbackJournal; Remove-Item -LiteralPath $script:rollbackJournal -Force -ErrorAction Stop; Assert-G4B (-not (Test-Path -LiteralPath $script:rollbackJournal)) 'ROLLBACK_JOURNAL_CLEANUP_UNVERIFIED' }
            catch { Write-Output 'ROLLBACK_JOURNAL=RETAINED_REQUIRES_RECONCILIATION' }
        } elseif($script:journalCreated -and -not $script:preserveRollbackJournal -and (Test-Path -LiteralPath $script:rollbackJournal -PathType Leaf)) {
            Write-Output 'ROLLBACK_JOURNAL=RETAINED_REQUIRES_RECONCILIATION'
        }
    }
    if ($null -ne $script:hy2Auth) { $script:hy2Auth=$null }
    if ($null -ne $script:remoteCredentials) { $script:remoteCredentials=$null }
    if($null -ne $script:portablePassphrase){$script:portablePassphrase.Dispose();$script:portablePassphrase=$null}
    $credentials=$null; $recoveryJson=$null; $recoveryBytes=$null; $rendered=$null; $serverRendered=$null; $unitRendered=$null
}
