[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$PSNativeCommandUseErrorActionPreference = $false

Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
Add-Type -AssemblyName System.IO.FileSystem.AccessControl

$script:phase = 'INITIALIZE'
$script:startedAt = [DateTimeOffset]::UtcNow
$script:projectRoot = Split-Path -Parent $PSScriptRoot
$script:gatePath = Join-Path $script:projectRoot 'docs\G4B0_WINDOWS_INTERFACE_BYPASS_CANARY_GATE.md'
$script:handoffPath = Join-Path $script:projectRoot 'REVIEWER_HANDOFF.md'
$script:templatePath = Join-Path $script:projectRoot 'templates\clash\g4b0-hy2-interface-bypass.yaml.template'
$script:recoveryPath = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\hy2-g2a.dpapi'
$script:runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$script:mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
$script:targetIp = '24.199.118.137'
$script:routePrefix = '24.199.118.137/32'
$script:hy2Sni = 'hy2.sfo3-a.invalid'
$script:expectedFingerprint = '8A:8D:50:5F:DF:80:DB:76:C6:76:39:5A:86:E4:9D:81:8E:A1:5B:76:64:ED:70:30:8C:29:60:9C:23:74:1F:18'
$script:ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User

$script:protectedBytes = $null
$script:bundleBytes = $null
$script:bundleFiles = $null
$script:authBytes = $null
$script:configBytes = $null
$script:runtimeDirectory = $null
$script:configPath = $null
$script:runtimeMarkerPath = $null
$script:mihomoProcess = $null
$script:mihomoStdoutTask = $null
$script:mihomoStderrTask = $null
$script:baseline = $null
$script:physicalEgress = $null
$script:proxyPort = 0
$script:requestCount = 0
$script:consequentialStarted = $false
$script:success = $false
$script:failureCode = $null
$script:cleanupFailures = [Collections.Generic.List[string]]::new()

function Assert-G4B0 {
    param([bool]$Condition,[string]$Code)
    if (-not $Condition) { throw $Code }
}

function Get-SafeFailureCode {
    param([object]$ErrorRecord)
    $code = [string]$ErrorRecord.Exception.Message
    if ($code -cmatch '^[A-Z][A-Z0-9_]{1,95}$') { return $code }
    return 'UNCLASSIFIED'
}

function Test-HighIntegrity {
    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    Assert-G4B0 ($LASTEXITCODE -eq 0) 'INTEGRITY_QUERY_FAILED'
    $match = [regex]::Match($groups,'S-1-16-(\d+)')
    return ($match.Success -and [int]$match.Groups[1].Value -ge 12288)
}

function New-OwnerAcl {
    param([switch]$Directory)
    if ($Directory) {
        $acl = [Security.AccessControl.DirectorySecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    }
    else {
        $acl = [Security.AccessControl.FileSecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::None
    }
    $acl.SetAccessRuleProtection($true,$false)
    $acl.SetOwner($script:ownerSid)
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-OwnerAcl {
    param([string]$Path)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-G4B0 $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'
    $owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    Assert-G4B0 ($owner -ceq $script:ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'
    $rules = @($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
    Assert-G4B0 ($rules.Count -gt 0) 'OWNER_ACL_RULES_MISSING'
    $direct = [long]0
    $container = [long]0
    $object = [long]0
    foreach($rule in $rules){
        Assert-G4B0 (-not $rule.IsInherited) 'OWNER_ACL_INHERITED_RULE_PRESENT'
        Assert-G4B0 ($rule.IdentityReference.Value -ceq $script:ownerSid.Value) 'OWNER_ACL_UNAUTHORIZED_PRINCIPAL'
        Assert-G4B0 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'OWNER_ACL_DENY_RULE_PRESENT'
        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) { $direct = $direct -bor $rights }
        if ($item.PSIsContainer) {
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) { $container = $container -bor $rights }
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) { $object = $object -bor $rights }
        }
    }
    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-G4B0 (($direct -band $full) -eq $full) 'OWNER_ACL_FULLCONTROL_MISSING'
    if ($item.PSIsContainer) {
        Assert-G4B0 ((($container -band $full) -eq $full) -and (($object -band $full) -eq $full)) 'OWNER_ACL_CHILD_INHERITANCE_MISSING'
    }
}

function Get-TunCount {
    return @(
        Get-NetAdapter -IncludeHidden -ErrorAction Stop |
        Where-Object {
            $_.Status -eq 'Up' -and
            $_.Name -cne 'SFO2-A' -and
            $_.InterfaceDescription -notmatch '(?i)WireGuard' -and
            ($_.Name -match '(?i)(?:mihomo|clash|tun)' -or $_.InterfaceDescription -match '(?i)(?:mihomo|clash|tun)')
        }
    ).Count
}

function Get-ExactRouteRows {
    param([ValidateSet('ActiveStore','PersistentStore')][string]$PolicyStore)
    try {
        return @(Get-NetRoute -AddressFamily IPv4 -PolicyStore $PolicyStore -DestinationPrefix $script:routePrefix -ErrorAction Stop)
    }
    catch {
        if ([string]$_.FullyQualifiedErrorId -like 'CmdletizationQuery_NotFound*') { return @() }
        throw
    }
}

function Assert-NoVps32Route {
    $active = @(Get-ExactRouteRows -PolicyStore ActiveStore)
    $persistent = @(Get-ExactRouteRows -PolicyStore PersistentStore)
    Assert-G4B0 ($active.Count -eq 0) 'ACTIVE_VPS_32_ROUTE_PRESENT'
    Assert-G4B0 ($persistent.Count -eq 0) 'PERSISTENT_VPS_32_ROUTE_PRESENT'
}

function Get-RouteSnapshot {
    return @(
        Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop |
        ForEach-Object { '{0}|{1}|{2}|{3}' -f $_.DestinationPrefix,$_.NextHop,$_.InterfaceIndex,$_.RouteMetric } |
        Sort-Object
    )
}

function Get-Baseline {
    $manager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $tunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $wg = @(Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop)
    Assert-G4B0 ($wg.Count -eq 1) 'WIREGUARD_ADAPTER_CARDINALITY_INVALID'
    $clash = Get-Service -Name 'clash_verge_service' -ErrorAction Stop
    $internet = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    Assert-G4B0 ($null -ne $internet.PSObject.Properties['ProxyEnable']) 'SYSTEM_PROXY_STATE_MISSING'
    return [pscustomobject]@{
        Manager = [string]$manager.Status
        Tunnel = [string]$tunnel.Status
        WgStatus = [string]$wg[0].Status
        WgIfIndex = [int]$wg[0].InterfaceIndex
        Clash = [string]$clash.Status
        ProxyEnable = [int]$internet.ProxyEnable
        TunCount = Get-TunCount
        Routes = Get-RouteSnapshot
    }
}

function Assert-SafeBaseline {
    param([object]$State)
    Assert-G4B0 ($State.Manager -ceq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-G4B0 ($State.Tunnel -ceq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
    Assert-G4B0 ($State.WgStatus -ceq 'Up') 'WIREGUARD_ADAPTER_NOT_UP'
    Assert-G4B0 ($State.Clash -ceq 'Running') 'CLASH_VERGE_SERVICE_NOT_RUNNING'
    Assert-G4B0 ($State.ProxyEnable -eq 0) 'SYSTEM_PROXY_NOT_OFF'
    Assert-G4B0 ($State.TunCount -eq 0) 'CLASH_TUN_NOT_OFF'
}

function Assert-SameBaseline {
    param([object]$Before,[object]$After)
    Assert-G4B0 ($Before.Manager -ceq $After.Manager) 'WIREGUARD_MANAGER_CHANGED'
    Assert-G4B0 ($Before.Tunnel -ceq $After.Tunnel) 'WIREGUARD_TUNNEL_CHANGED'
    Assert-G4B0 ($Before.WgStatus -ceq $After.WgStatus) 'WIREGUARD_ADAPTER_CHANGED'
    Assert-G4B0 ($Before.WgIfIndex -eq $After.WgIfIndex) 'WIREGUARD_IFINDEX_CHANGED'
    Assert-G4B0 ($Before.Clash -ceq $After.Clash) 'CLASH_SERVICE_CHANGED'
    Assert-G4B0 ($Before.ProxyEnable -eq $After.ProxyEnable) 'SYSTEM_PROXY_CHANGED'
    Assert-G4B0 ($Before.TunCount -eq $After.TunCount) 'TUN_STATE_CHANGED'
    Assert-G4B0 (($Before.Routes -join [Environment]::NewLine) -ceq ($After.Routes -join [Environment]::NewLine)) 'ACTIVE_ROUTE_SNAPSHOT_CHANGED'
}

function Resolve-PhysicalEgress {
    $candidates = [Collections.Generic.List[object]]::new()
    foreach($adapter in @(Get-NetAdapter -Physical -ErrorAction Stop)){
        if ([string]$adapter.Status -ne 'Up') { continue }
        $ifIndex = [int]$adapter.ifIndex
        $cfg = Get-NetIPConfiguration -InterfaceIndex $ifIndex -ErrorAction Stop
        $gateways = @($cfg.IPv4DefaultGateway | Where-Object { $null -ne $_ -and -not [string]::IsNullOrWhiteSpace([string]$_.NextHop) })
        $addresses = @($cfg.IPv4Address | Where-Object { $null -ne $_ -and -not [string]::IsNullOrWhiteSpace([string]$_.IPAddress) })
        if ($gateways.Count -ne 1 -or $addresses.Count -ne 1) { continue }
        $nextHop = [string]$gateways[0].NextHop
        $source = [string]$addresses[0].IPAddress
        $defaults = @(
            Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix '0.0.0.0/0' -ErrorAction Stop |
            Where-Object { [int]$_.InterfaceIndex -eq $ifIndex -and [string]$_.NextHop -eq $nextHop }
        )
        if ($defaults.Count -lt 1) { continue }
        $interfaces = @(Get-NetIPInterface -AddressFamily IPv4 -InterfaceIndex $ifIndex -ErrorAction Stop)
        if ($interfaces.Count -lt 1) { continue }
        $bestRoute = @($defaults | Sort-Object RouteMetric | Select-Object -First 1)[0]
        $score = [int]$bestRoute.RouteMetric + [int]$interfaces[0].InterfaceMetric
        $candidates.Add([pscustomobject]@{
            Alias = [string]$adapter.Name
            InterfaceIndex = $ifIndex
            Gateway = $nextHop
            SourceIPv4 = $source
            Score = $score
        })
    }
    Assert-G4B0 ($candidates.Count -gt 0) 'PHYSICAL_EGRESS_NOT_FOUND'
    $ordered = @($candidates | Sort-Object Score,InterfaceIndex,Alias)
    if ($ordered.Count -gt 1 -and $ordered[0].Score -eq $ordered[1].Score) { throw 'PHYSICAL_EGRESS_AMBIGUOUS' }
    return $ordered[0]
}

function Get-FreeProxyPort {
    for($port=27990;$port -le 28030;$port++){
        $tcp = @(Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue)
        $udp = @(Get-NetUDPEndpoint -LocalPort $port -ErrorAction SilentlyContinue)
        if ($tcp.Count -eq 0 -and $udp.Count -eq 0) { return $port }
    }
    throw 'LOCAL_PROXY_PORT_UNAVAILABLE'
}

function Read-ExactBytes {
    param([IO.BinaryReader]$Reader,[int]$Count)
    $bytes = $Reader.ReadBytes($Count)
    if ($bytes.Length -ne $Count) { throw 'RECOVERY_FRAME_TRUNCATED' }
    return ,$bytes
}

function Read-RecoveryBundle {
    param([byte[]]$Bytes)
    if ($Bytes.Length -gt 131072) { throw 'RECOVERY_FRAME_TOO_LARGE' }
    $stream = [IO.MemoryStream]::new($Bytes,$false)
    $reader = [IO.BinaryReader]::new($stream,[Text.Encoding]::UTF8,$true)
    $files = @{}
    try {
        $magic = [Text.Encoding]::ASCII.GetString((Read-ExactBytes -Reader $reader -Count 8))
        if ($magic -ne 'VPNHY2R1') { throw 'RECOVERY_FRAME_MAGIC_INVALID' }
        while($stream.Position -lt $stream.Length){
            $nameLength = [int]$reader.ReadByte()
            if ($nameLength -lt 1 -or $nameLength -gt 32) { throw 'RECOVERY_FRAME_NAME_LENGTH_INVALID' }
            $lengthBytes = Read-ExactBytes -Reader $reader -Count 4
            $dataLength = ([uint32]$lengthBytes[0] -shl 24) -bor
                          ([uint32]$lengthBytes[1] -shl 16) -bor
                          ([uint32]$lengthBytes[2] -shl 8) -bor
                          [uint32]$lengthBytes[3]
            if ($dataLength -lt 1 -or $dataLength -gt 65536) { throw 'RECOVERY_FRAME_DATA_LENGTH_INVALID' }
            $name = [Text.Encoding]::UTF8.GetString((Read-ExactBytes -Reader $reader -Count $nameLength))
            if ($name -notin @('hy2-auth','server.key','server.crt') -or $files.ContainsKey($name)) { throw 'RECOVERY_FRAME_ALLOWLIST_INVALID' }
            $files[$name] = Read-ExactBytes -Reader $reader -Count ([int]$dataLength)
        }
        if ($files.Count -ne 3) { throw 'RECOVERY_FRAME_CARDINALITY_INVALID' }
        $auth = [byte[]]$files['hy2-auth']
        if ($auth.Length -ne 64 -or @($auth | Where-Object { $_ -notin 48..57 -and $_ -notin 97..102 }).Count -gt 0) { throw 'RECOVERY_AUTH_FORMAT_INVALID' }

        $certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$files['server.crt'])
        try {
            $sanExtension = $certificate.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.17' } | Select-Object -First 1
            if ($null -eq $sanExtension) { throw 'RECOVERY_CERTIFICATE_SAN_MISSING' }
            $san = [Security.Cryptography.X509Certificates.X509SubjectAlternativeNameExtension]::new($sanExtension.RawData)
            $names = @($san.EnumerateDnsNames())
            if ($names.Count -ne 1 -or $names[0] -ne $script:hy2Sni) { throw 'RECOVERY_CERTIFICATE_SAN_INVALID' }
            $hex = [Convert]::ToHexString($certificate.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256))
            $fingerprint = [string]::Join(':',[regex]::Matches($hex,'..').Value)
        }
        finally { $certificate.Dispose() }
        return [pscustomobject]@{ Files=$files; Fingerprint=$fingerprint }
    }
    catch {
        foreach($value in $files.Values){ [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value) }
        throw
    }
    finally {
        $reader.Dispose()
        $stream.Dispose()
    }
}

function New-ConfigBytes {
    param([string]$TemplateText,[byte[]]$AuthBytes,[object]$Physical,[int]$ProxyPort,[string]$Fingerprint)

    foreach($ch in $TemplateText.ToCharArray()){
        if ([int][char]$ch -gt 127) { throw 'G4B0_TEMPLATE_NON_ASCII' }
    }

    $rendered = $TemplateText
    $rendered = $rendered.Replace('__LOCAL_PROXY_PORT__',[string]$ProxyPort)
    $rendered = $rendered.Replace('"__VPS_HOST__"',(ConvertTo-Json -Compress $script:targetIp))
    $rendered = $rendered.Replace('"__HY2_SNI__"',(ConvertTo-Json -Compress $script:hy2Sni))
    $rendered = $rendered.Replace('"__HY2_CERT_SHA256__"',(ConvertTo-Json -Compress $Fingerprint))
    $rendered = $rendered.Replace('"__PHYSICAL_INTERFACE_NAME_RUNTIME_DISCOVERY__"',(ConvertTo-Json -Compress ([string]$Physical.Alias)))

    foreach($placeholder in @('__LOCAL_PROXY_PORT__','__VPS_HOST__','__HY2_SNI__','__HY2_CERT_SHA256__','__PHYSICAL_INTERFACE_NAME_RUNTIME_DISCOVERY__')){
        Assert-G4B0 (-not $rendered.Contains($placeholder)) 'G4B0_NONSECRET_PLACEHOLDER_REMAINS'
    }

    $secretPlaceholder = '__HY2_AUTH_INJECT_PROTECTED_RUNTIME_ONLY__'
    $index = $rendered.IndexOf($secretPlaceholder,[StringComparison]::Ordinal)
    Assert-G4B0 ($index -ge 0 -and $rendered.LastIndexOf($secretPlaceholder,[StringComparison]::Ordinal) -eq $index) 'G4B0_SECRET_PLACEHOLDER_INVALID'

    $prefix = [Text.Encoding]::ASCII.GetBytes($rendered.Substring(0,$index))
    $suffix = [Text.Encoding]::ASCII.GetBytes($rendered.Substring($index + $secretPlaceholder.Length))
    $bytes = [byte[]]::new($prefix.Length + $AuthBytes.Length + $suffix.Length)
    try {
        [Buffer]::BlockCopy($prefix,0,$bytes,0,$prefix.Length)
        [Buffer]::BlockCopy($AuthBytes,0,$bytes,$prefix.Length,$AuthBytes.Length)
        [Buffer]::BlockCopy($suffix,0,$bytes,$prefix.Length+$AuthBytes.Length,$suffix.Length)
        return ,$bytes
    }
    finally {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($prefix)
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($suffix)
    }
}

function Invoke-MihomoParse {
    $process = [Diagnostics.Process]::new()
    try {
        $process.StartInfo.FileName = $script:mihomoPath
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.RedirectStandardError = $true
        foreach($arg in @('-t','-d',$script:runtimeDirectory,'-f',$script:configPath)){ [void]$process.StartInfo.ArgumentList.Add($arg) }
        if (-not $process.Start()) { throw 'MIHOMO_PARSE_START_FAILED' }
        $outTask = $process.StandardOutput.ReadToEndAsync()
        $errTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(30000)) {
            try { $process.Kill($true) } catch {}
            throw 'MIHOMO_PARSE_TIMEOUT'
        }
        [void]$outTask.GetAwaiter().GetResult()
        [void]$errTask.GetAwaiter().GetResult()
        Assert-G4B0 ($process.ExitCode -eq 0) 'MIHOMO_CONFIG_PARSE_FAILED'
    }
    finally { $process.Dispose() }
}

function Start-Mihomo {
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $script:mihomoPath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    foreach($arg in @('-d',$script:runtimeDirectory,'-f',$script:configPath)){ [void]$psi.ArgumentList.Add($arg) }

    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $psi
    if (-not $process.Start()) { throw 'MIHOMO_START_FAILED' }
    $script:mihomoStdoutTask = $process.StandardOutput.ReadToEndAsync()
    $script:mihomoStderrTask = $process.StandardError.ReadToEndAsync()
    $script:mihomoProcess = $process

    $deadline = [DateTime]::UtcNow.AddSeconds(12)
    while([DateTime]::UtcNow -lt $deadline){
        if ($process.HasExited) { throw 'MIHOMO_EXITED_BEFORE_PROXY_READY' }
        $listeners = @(Get-NetTCPConnection -State Listen -ErrorAction Stop | Where-Object { [int]$_.OwningProcess -eq $process.Id })
        $udp = @(Get-NetUDPEndpoint -ErrorAction Stop | Where-Object { [int]$_.OwningProcess -eq $process.Id })
        if ($listeners.Count -gt 0) {
            Assert-G4B0 ($listeners.Count -eq 1) 'MIHOMO_UNEXPECTED_TCP_LISTENER_COUNT'
            Assert-G4B0 ([int]$listeners[0].LocalPort -eq $script:proxyPort) 'MIHOMO_PROXY_PORT_MISMATCH'
            Assert-G4B0 ([string]$listeners[0].LocalAddress -in @('127.0.0.1','::ffff:127.0.0.1')) 'MIHOMO_PROXY_BINDING_NOT_LOCALHOST'
            Assert-G4B0 ($udp.Count -eq 0) 'MIHOMO_UNEXPECTED_UDP_LISTENER'
            return
        }
        Start-Sleep -Milliseconds 200
    }
    throw 'MIHOMO_PROXY_NOT_READY'
}

function Stop-Mihomo {
    if ($null -eq $script:mihomoProcess) { return }
    try {
        if (-not $script:mihomoProcess.HasExited) {
            $script:mihomoProcess.Kill($true)
            if (-not $script:mihomoProcess.WaitForExit(5000)) { throw 'MIHOMO_STOP_TIMEOUT' }
        }
    }
    finally {
        try { if ($null -ne $script:mihomoStdoutTask) { [void]$script:mihomoStdoutTask.GetAwaiter().GetResult() } } catch {}
        try { if ($null -ne $script:mihomoStderrTask) { [void]$script:mihomoStderrTask.GetAwaiter().GetResult() } } catch {}
        $script:mihomoProcess.Dispose()
        $script:mihomoProcess = $null
    }
}

function Invoke-TwoRequestProbe {
    $curl = (Get-Command curl.exe -ErrorAction Stop).Source
    $proxy = "socks5h://127.0.0.1:$($script:proxyPort)"

    Assert-NoVps32Route
    $script:requestCount++
    $writeOut = '%{http_code}|%{time_total}|%{time_connect}|%{time_appconnect}|%{proxy_used}'
    $output = & $curl -sS -o NUL --connect-timeout 10 --max-time 20 --noproxy '' --proxy $proxy -w $writeOut 'https://api.openai.com/v1/models' 2>$null
    $curlExit = $LASTEXITCODE
    $parts = ([string]$output).Trim().Split('|')
    Assert-G4B0 ($parts.Count -eq 5) 'OPENAI_RESULT_SHAPE_INVALID'
    Assert-G4B0 ($curlExit -eq 0) 'OPENAI_CURL_FAILED'
    Assert-G4B0 ($parts[0] -ceq '401') 'OPENAI_HTTP_STATUS_INVALID'
    Assert-G4B0 ($parts[4] -ceq '1') 'OPENAI_PROXY_NOT_USED'

    Write-Output 'G4B0_OPENAI_CURL_EXIT=0'
    Write-Output 'G4B0_OPENAI_HTTP_STATUS=401'
    Write-Output 'G4B0_OPENAI_PROXY_USED=1'
    Write-Output ('G4B0_OPENAI_TIME_TOTAL=' + $parts[1])
    Write-Output ('G4B0_OPENAI_TIME_CONNECT=' + $parts[2])
    Write-Output ('G4B0_OPENAI_TIME_APPCONNECT=' + $parts[3])

    Assert-NoVps32Route
    $script:requestCount++
    $exitValue = & $curl -fsS --connect-timeout 10 --max-time 20 --noproxy '' --proxy $proxy 'https://api.ipify.org' 2>$null
    $exitCode = $LASTEXITCODE
    Assert-G4B0 ($exitCode -eq 0) 'EXIT_QUERY_FAILED'
    Assert-G4B0 (([string]$exitValue).Trim() -ceq $script:targetIp) 'EXIT_IP_MISMATCH'

    Write-Output 'G4B0_PUBLIC_EXIT=EXPECTED_SFO3'
    Write-Output ('G4B0_REQUEST_COUNT=' + $script:requestCount)
    Assert-G4B0 ($script:requestCount -eq 2) 'REQUEST_BUDGET_INVALID'
}

function Assert-CanonicalLocalState {
    Push-Location -LiteralPath $script:projectRoot
    try {
        $inside = @(& git rev-parse --is-inside-work-tree 2>$null)
        Assert-G4B0 ($LASTEXITCODE -eq 0 -and $inside.Count -eq 1 -and ([string]$inside[0]).Trim() -ceq 'true') 'CANONICAL_GIT_ROOT_UNAVAILABLE'
        $origin = @(& git remote get-url origin 2>$null)
        Assert-G4B0 ($LASTEXITCODE -eq 0 -and $origin.Count -eq 1) 'ORIGIN_URL_UNAVAILABLE'
        Assert-G4B0 (([string]$origin[0]).Trim() -match '(?i)github\.com[:/]entropy-student/project(?:\.git)?$') 'CANONICAL_ORIGIN_MISMATCH'
        $head = @(& git rev-parse HEAD 2>$null)
        Assert-G4B0 ($LASTEXITCODE -eq 0 -and $head.Count -eq 1) 'HEAD_READ_FAILED'
        $main = @(& git rev-parse origin/main 2>$null)
        Assert-G4B0 ($LASTEXITCODE -eq 0 -and $main.Count -eq 1) 'ORIGIN_MAIN_READ_FAILED'
        Assert-G4B0 (([string]$head[0]).Trim() -ceq ([string]$main[0]).Trim()) 'LOCAL_HEAD_NOT_ORIGIN_MAIN'
        $dirty = @(& git status --porcelain -- . 2>$null)
        Assert-G4B0 ($LASTEXITCODE -eq 0 -and $dirty.Count -eq 0) 'PROJECT_PATH_NOT_CLEAN'
    }
    finally { Pop-Location }

    $handoff = [IO.File]::ReadAllText($script:handoffPath,[Text.Encoding]::UTF8)
    Assert-G4B0 ($handoff.Contains('GATE_ID=G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1')) 'CURRENT_GATE_MISMATCH'
    Assert-G4B0 ($handoff.Contains('STATE=AUTHORIZED_NOT_EXECUTED')) 'CURRENT_GATE_NOT_AUTHORIZED'
}

try {
    Write-Output ('ROUND_STARTED_AT=' + $script:startedAt.ToString('o'))
    $script:phase = 'P0_CANONICAL_SOURCE'
    Assert-G4B0 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-G4B0 (Test-HighIntegrity) 'HIGH_INTEGRITY_REQUIRED'
    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-G4B0 ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
    Assert-G4B0 ($null -ne $script:ownerSid) 'OWNER_SID_UNAVAILABLE'
    foreach($path in @($script:gatePath,$script:handoffPath,$script:templatePath,$script:recoveryPath,$script:mihomoPath)){
        Assert-G4B0 (Test-Path -LiteralPath $path -PathType Leaf) 'REQUIRED_FILE_MISSING'
    }
    Assert-CanonicalLocalState
    Write-Output 'G4B0_CANONICAL_SOURCE=PASS'

    $script:phase = 'P1_OWNER_HOST_AND_NETWORK_PREFLIGHT'
    $script:baseline = Get-Baseline
    Assert-SafeBaseline -State $script:baseline
    Assert-NoVps32Route
    Write-Output 'G4B0_OWNER_BASELINE=PASS'
    Write-Output 'G4B0_ACTIVE_VPS_32_ROUTE_BEFORE=0'
    Write-Output 'G4B0_PERSISTENT_VPS_32_ROUTE_BEFORE=0'

    $script:phase = 'P2_PHYSICAL_EGRESS'
    $script:physicalEgress = Resolve-PhysicalEgress
    Assert-G4B0 (-not [string]::IsNullOrWhiteSpace([string]$script:physicalEgress.Alias)) 'PHYSICAL_EGRESS_ALIAS_INVALID'
    Write-Output 'G4B0_PHYSICAL_EGRESS_DISCOVERY=PASS'
    Write-Output ('G4B0_PHYSICAL_INTERFACE_ALIAS=' + [string]$script:physicalEgress.Alias)
    Write-Output ('G4B0_PHYSICAL_INTERFACE_INDEX=' + [string]$script:physicalEgress.InterfaceIndex)

    $script:phase = 'P3_SECRET_AND_RUNTIME_PREPARE'
    Assert-OwnerAcl -Path (Split-Path -Parent $script:recoveryPath)
    Assert-OwnerAcl -Path $script:recoveryPath
    if (Test-Path -LiteralPath $script:runtimeRoot -PathType Container) {
        Assert-OwnerAcl -Path $script:runtimeRoot
    }
    else {
        [void][System.IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory),$script:runtimeRoot)
        Assert-OwnerAcl -Path $script:runtimeRoot
    }
    $leftovers = @(Get-ChildItem -LiteralPath $script:runtimeRoot -Directory -Force -ErrorAction Stop | Where-Object { $_.Name -like 'g4b0-*' })
    Assert-G4B0 ($leftovers.Count -eq 0) 'G4B0_RUNTIME_LEFTOVER_PRESENT'

    $script:protectedBytes = [IO.File]::ReadAllBytes($script:recoveryPath)
    $script:bundleBytes = [Security.Cryptography.ProtectedData]::Unprotect($script:protectedBytes,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:protectedBytes)
    $script:protectedBytes = $null
    $script:bundleFiles = Read-RecoveryBundle -Bytes $script:bundleBytes
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:bundleBytes)
    $script:bundleBytes = $null
    Assert-G4B0 ($script:bundleFiles.Fingerprint -ceq $script:expectedFingerprint) 'CERTIFICATE_FINGERPRINT_MISMATCH'
    $script:authBytes = [byte[]]$script:bundleFiles.Files['hy2-auth'].Clone()
    foreach($name in @('hy2-auth','server.key','server.crt')) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$script:bundleFiles.Files[$name])
    }
    $script:bundleFiles = $null

    $script:proxyPort = Get-FreeProxyPort
    $script:runtimeDirectory = Join-Path $script:runtimeRoot ('g4b0-' + [Guid]::NewGuid().ToString('N'))
    [void][System.IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory),$script:runtimeDirectory)
    Assert-OwnerAcl -Path $script:runtimeDirectory
    $script:runtimeMarkerPath = Join-Path $script:runtimeDirectory '.g4b0-owner'
    [IO.File]::WriteAllText($script:runtimeMarkerPath,'G4B0',[Text.UTF8Encoding]::new($false))
    Set-Acl -LiteralPath $script:runtimeMarkerPath -AclObject (New-OwnerAcl) -ErrorAction Stop
    Assert-OwnerAcl -Path $script:runtimeMarkerPath
    $script:configPath = Join-Path $script:runtimeDirectory 'g4b0-interface-bypass.json'
    $templateText = [IO.File]::ReadAllText($script:templatePath,[Text.Encoding]::UTF8)
    $script:configBytes = New-ConfigBytes -TemplateText $templateText -AuthBytes $script:authBytes -Physical $script:physicalEgress -ProxyPort $script:proxyPort -Fingerprint $script:expectedFingerprint

    $stream = [IO.File]::Open($script:configPath,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
    try {
        $stream.Write($script:configBytes,0,$script:configBytes.Length)
        $stream.Flush($true)
    }
    finally { $stream.Dispose() }
    Set-Acl -LiteralPath $script:configPath -AclObject (New-OwnerAcl) -ErrorAction Stop
    Assert-OwnerAcl -Path $script:configPath
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:configBytes)
    $script:configBytes = $null
    $script:consequentialStarted = $true
    Write-Output 'G4B0_CONSEQUENTIAL_PHASE_STARTED=YES'
    Write-Output 'G4B0_DPAPI_UNPROTECT=PASS'
    Write-Output 'G4B0_HY2_AUTH_FORMAT=PASS'
    Write-Output 'G4B0_CERTIFICATE_FINGERPRINT_MATCH=PASS'
    Write-Output 'G4B0_OWNER_ONLY_RUNTIME=PASS'
    Write-Output 'G4B0_INTERFACE_NAME_APPLIED=YES'

    $script:phase = 'P4_MIHOMO_PARSE_AND_START'
    Invoke-MihomoParse
    Write-Output 'G4B0_MIHOMO_CONFIG_PARSE=PASS'
    Assert-NoVps32Route
    Start-Mihomo
    Write-Output 'G4B0_MIHOMO_LOCAL_PROXY_READY=YES'
    Assert-NoVps32Route
    Write-Output 'G4B0_TEMP_OR_PERSISTENT_VPS_32_ROUTE_CREATED=NO'

    $script:phase = 'P5_TWO_REQUEST_CANARY'
    Invoke-TwoRequestProbe
    Assert-NoVps32Route
    Write-Output 'G4B0_BOUNDED_PROXY_PROBE=PASS'
    Write-Output 'G4B0_INTERFACE_NAME_BYPASS=PASS'

    $script:success = $true
}
catch {
    $script:failureCode = Get-SafeFailureCode -ErrorRecord $_
}
finally {
    $script:phase = 'P6_CLEANUP_AND_READBACK'
    try { Stop-Mihomo } catch { $script:cleanupFailures.Add('MIHOMO_STOP_FAILED') }

    try {
        if ($null -ne $script:configPath -and (Test-Path -LiteralPath $script:configPath -PathType Leaf)) {
            Assert-OwnerAcl -Path $script:configPath
            Remove-Item -LiteralPath $script:configPath -Force -ErrorAction Stop
        }
    }
    catch { $script:cleanupFailures.Add('CONFIG_DELETE_FAILED') }

    try {
        if ($null -ne $script:runtimeDirectory -and (Test-Path -LiteralPath $script:runtimeDirectory -PathType Container)) {
            $runtimeFull = [IO.Path]::GetFullPath($script:runtimeDirectory)
            $runtimeRootFull = [IO.Path]::GetFullPath($script:runtimeRoot).TrimEnd('\') + '\'
            $runtimeLeaf = Split-Path -Leaf $runtimeFull
            Assert-G4B0 ($runtimeFull.StartsWith($runtimeRootFull,[StringComparison]::OrdinalIgnoreCase)) 'RUNTIME_PATH_OUTSIDE_PROJECT_ROOT'
            Assert-G4B0 ($runtimeLeaf -cmatch '^g4b0-[0-9a-f]{32}$') 'RUNTIME_DIRECTORY_NAME_INVALID'
            Assert-OwnerAcl -Path $script:runtimeDirectory
            Assert-G4B0 ($null -ne $script:runtimeMarkerPath -and (Test-Path -LiteralPath $script:runtimeMarkerPath -PathType Leaf)) 'RUNTIME_MARKER_MISSING'
            Assert-OwnerAcl -Path $script:runtimeMarkerPath
            foreach($item in @(Get-ChildItem -LiteralPath $script:runtimeDirectory -Recurse -Force -ErrorAction Stop)) {
                Assert-G4B0 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'RUNTIME_REPARSE_POINT_PRESENT'
            }
            Remove-Item -LiteralPath $script:runtimeDirectory -Recurse -Force -ErrorAction Stop
            Assert-G4B0 (-not (Test-Path -LiteralPath $script:runtimeDirectory)) 'RUNTIME_DIRECTORY_REMAINS'
        }
    }
    catch { $script:cleanupFailures.Add('RUNTIME_DIRECTORY_DELETE_FAILED') }

    try {
        $leftoversAfter = @(Get-ChildItem -LiteralPath $script:runtimeRoot -Directory -Force -ErrorAction Stop | Where-Object { $_.Name -like 'g4b0-*' })
        if ($leftoversAfter.Count -ne 0) { $script:cleanupFailures.Add('G4B0_RUNTIME_RESIDUE_PRESENT') }
    }
    catch { $script:cleanupFailures.Add('RUNTIME_RESIDUE_READBACK_FAILED') }

    try {
        Assert-NoVps32Route
        Write-Output 'G4B0_ACTIVE_VPS_32_ROUTE_AFTER=0'
        Write-Output 'G4B0_PERSISTENT_VPS_32_ROUTE_AFTER=0'
    }
    catch { $script:cleanupFailures.Add('FINAL_VPS_32_ROUTE_STATE_INVALID') }

    try {
        if ($null -ne $script:baseline) {
            $finalState = Get-Baseline
            Assert-SafeBaseline -State $finalState
            Assert-SameBaseline -Before $script:baseline -After $finalState
            Write-Output 'G4B0_WIREGUARD_PRESERVED=YES'
            Write-Output 'G4B0_SYSTEM_PROXY_FINAL=OFF'
            Write-Output 'G4B0_TUN_FINAL=OFF'
            Write-Output 'G4B0_NETWORK_BASELINE_RESTORED=PASS'
        }
    }
    catch { $script:cleanupFailures.Add('FINAL_NETWORK_BASELINE_INVALID') }

    if ($null -ne $script:configBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:configBytes) }
    if ($null -ne $script:authBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:authBytes) }
    if ($null -ne $script:bundleFiles) {
        foreach($value in $script:bundleFiles.Files.Values){ [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value) }
    }
    if ($null -ne $script:bundleBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:bundleBytes) }
    if ($null -ne $script:protectedBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:protectedBytes) }

    if ($script:cleanupFailures.Count -eq 0) {
        Write-Output 'G4B0_SECRET_RUNTIME_CLEANUP=PASS'
    }
    else {
        $script:success = $false
        if ($null -eq $script:failureCode) { $script:failureCode = 'G4B0_CLEANUP_FAILED' }
        Write-Output ('G4B0_CLEANUP_FAILURE_COUNT=' + $script:cleanupFailures.Count)
    }

    Write-Output 'SECRET_VALUES_EMITTED=0'
    $finishedAt = [DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finishedAt.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finishedAt - $script:startedAt).ToString())
}

if ($script:success -and $script:cleanupFailures.Count -eq 0) {
    Write-Output 'G4B0_OWNER_CHECKPOINT=COMPLETE'
    Write-Output 'G4B0_RUNNER_RESULT=PASS_CANDIDATE_INTERFACE_NAME_BYPASS'
    exit 0
}

Write-Output 'G4B0_RUNNER_RESULT=RETURN_TO_REVIEWER'
Write-Output ('G4B0_FAILURE_PHASE=' + $script:phase)
Write-Output ('G4B0_FAILURE_CODE=' + $(if ($null -ne $script:failureCode) { $script:failureCode } else { 'UNKNOWN' }))
Write-Output ('G4B0_CONSEQUENTIAL_ACTION_STARTED=' + $(if ($script:consequentialStarted) { 'YES' } else { 'NO' }))
Write-Output ('G4B0_REQUEST_COUNT=' + $script:requestCount)
Write-Output 'DO_NOT_RERUN=YES'
exit 1
