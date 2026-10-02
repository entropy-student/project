[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$tunnelName = 'SFO2-A'
$serviceName = 'WireGuardTunnel$SFO2-A'
$publicVpsIp = '24.199.118.137'
$configPath = Join-Path $env:ProgramFiles 'WireGuard\Data\Configurations\SFO2-A.conf.dpapi'
$wireGuardExe = Join-Path $env:ProgramFiles 'WireGuard\wireguard.exe'
$wgExe = Join-Path $env:ProgramFiles 'WireGuard\wg.exe'
$pwshExe = (Get-Command pwsh.exe -ErrorAction Stop).Source

$root = Join-Path $env:ProgramData 'vpn-network-optimization'
$runId = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8)
$work = Join-Path $root ('wg-killswitch-repair-' + $runId)
$workerPath = Join-Path $work 'system-worker.ps1'
$statusPath = Join-Path $work 'worker-status.txt'
$backupDir = Join-Path $root 'wireguard-encrypted-rollback'
$backupPath = Join-Path $backupDir ('SFO2-A.conf.dpapi.' + $runId + '.bak')
$wfpPath = Join-Path $work 'wfp-after.xml'
$taskName = 'vpn-network-optimization-wg-repair-' + $runId

$repairApplied = $false
$repairVerified = $false
$rollbackAttempted = $false
$rollbackVerified = $false
$taskRegistered = $false
$cleanupFailures = [Collections.Generic.List[string]]::new()

function Assert-Check {
    param(
        [Parameter(Mandatory=$true)][bool]$Condition,
        [Parameter(Mandatory=$true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Add-CleanupFailure {
    param([Parameter(Mandatory=$true)][string]$Code)
    $script:cleanupFailures.Add($Code)
    Write-Output "CLEANUP_FAILED=$Code"
}

function Get-WgV4RouteState {
    $adapter = Get-NetAdapter -Name $script:tunnelName -ErrorAction Stop
    $routes = @(Get-NetRoute -AddressFamily IPv4 -InterfaceIndex $adapter.InterfaceIndex -PolicyStore ActiveStore -ErrorAction Stop)
    $prefixes = @($routes | ForEach-Object { [string]$_.DestinationPrefix })
    [pscustomobject]@{
        IfIndex = [int]$adapter.InterfaceIndex
        HasDefault = ($prefixes -contains '0.0.0.0/0')
        HasSplitA = ($prefixes -contains '0.0.0.0/1')
        HasSplitB = ($prefixes -contains '128.0.0.0/1')
    }
}

function Get-WgV6RouteState {
    $adapter = Get-NetAdapter -Name $script:tunnelName -ErrorAction Stop
    try {
        $routes = @(Get-NetRoute -AddressFamily IPv6 -InterfaceIndex $adapter.InterfaceIndex -PolicyStore ActiveStore -ErrorAction Stop)
    }
    catch {
        $routes = @()
    }
    $prefixes = @($routes | ForEach-Object { [string]$_.DestinationPrefix })
    [pscustomobject]@{
        HasDefault = ($prefixes -contains '::/0')
        HasSplitA = ($prefixes -contains '::/1')
        HasSplitB = ($prefixes -contains '8000::/1')
    }
}

function Get-WfpKillSwitchPresent {
    param([Parameter(Mandatory=$true)][string]$OutputPath)
    if (Test-Path -LiteralPath $OutputPath) { Remove-Item -LiteralPath $OutputPath -Force }
    $netsh = (Get-Command netsh.exe -ErrorAction Stop).Source
    & $netsh wfp show filters file="$OutputPath" protocol=17 remoteaddr=$script:publicVpsIp remoteport=8443 dir=out verbose=on | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'WFP_QUERY_FAILED'
    Assert-Check (Test-Path -LiteralPath $OutputPath -PathType Leaf) 'WFP_QUERY_OUTPUT_MISSING'
    $text = Get-Content -LiteralPath $OutputPath -Raw -ErrorAction Stop
    return [bool]($text -match 'Block all outbound \(IPv4\)')
}

function Wait-ServiceState {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$State,
        [int]$TimeoutSeconds = 30
    )
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        $svc = Get-Service -Name $Name -ErrorAction SilentlyContinue
        if ($null -ne $svc -and [string]$svc.Status -eq $State) { return $true }
        Start-Sleep -Milliseconds 250
    } while ((Get-Date) -lt $deadline)
    return $false
}

function Register-And-RunSystemTask {
    param(
        [Parameter(Mandatory=$true)][string]$WorkerMode
    )

    if (Test-Path -LiteralPath $statusPath) {
        Remove-Item -LiteralPath $statusPath -Force
    }

    $args = '-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "' + $workerPath + '" -Mode ' + $WorkerMode +
        ' -ConfigPath "' + $configPath + '" -BackupPath "' + $backupPath + '" -StatusPath "' + $statusPath + '"'

    $service = New-Object -ComObject 'Schedule.Service'
    $service.Connect()
    $rootFolder = $service.GetFolder('\')
    $task = $service.NewTask(0)
    $task.RegistrationInfo.Description = 'Temporary WireGuard config repair task for vpn-network-optimization'
    $task.Settings.Enabled = $true
    $task.Settings.Hidden = $true
    $task.Settings.AllowDemandStart = $true
    $task.Settings.ExecutionTimeLimit = 'PT1M'
    $task.Principal.UserId = 'SYSTEM'
    $task.Principal.LogonType = 5
    $task.Principal.RunLevel = 1
    $action = $task.Actions.Create(0)
    $action.Path = $pwshExe
    $action.Arguments = $args
    $registered = $rootFolder.RegisterTaskDefinition($taskName, $task, 6, 'SYSTEM', $null, 5)
    $script:taskRegistered = $true
    [void]$registered.Run($null)

    $deadline = (Get-Date).AddSeconds(45)
    while ((Get-Date) -lt $deadline) {
        if (Test-Path -LiteralPath $statusPath -PathType Leaf) {
            $status = (Get-Content -LiteralPath $statusPath -Raw -ErrorAction Stop).Trim()
            if ($status -match '^RESULT=(PASS|FAIL)') {
                return $status
            }
        }
        Start-Sleep -Milliseconds 250
    }
    throw 'SYSTEM_WORKER_TIMEOUT'
}

function Remove-SystemTask {
    try {
        $service = New-Object -ComObject 'Schedule.Service'
        $service.Connect()
        $rootFolder = $service.GetFolder('\')
        try {
            $rootFolder.DeleteTask($taskName, 0)
        }
        catch {
            if ($_.Exception.Message -notmatch '(?i)cannot find|not found|找不到') { throw }
        }
        $script:taskRegistered = $false
    }
    catch {
        Add-CleanupFailure 'SYSTEM_TASK_REMOVE_FAILED'
    }
}

$worker = @'
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidateSet('Apply','Rollback')][string]$Mode,
    [Parameter(Mandatory=$true)][string]$ConfigPath,
    [Parameter(Mandatory=$true)][string]$BackupPath,
    [Parameter(Mandatory=$true)][string]$StatusPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Status {
    param([string[]]$Lines)
    $tmp = $StatusPath + '.tmp'
    [IO.File]::WriteAllLines($tmp, $Lines, [Text.UTF8Encoding]::new($false))
    Move-Item -LiteralPath $tmp -Destination $StatusPath -Force
}

try {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    if ($id.Name -ne 'NT AUTHORITY\SYSTEM') { throw 'NOT_SYSTEM' }

    if ($Mode -eq 'Rollback') {
        if (-not (Test-Path -LiteralPath $BackupPath -PathType Leaf)) { throw 'BACKUP_MISSING' }
        Copy-Item -LiteralPath $BackupPath -Destination $ConfigPath -Force
        Write-Status @('RESULT=PASS','MODE=ROLLBACK','RESTORED_ENCRYPTED_CONFIG=YES')
        exit 0
    }

    Add-Type -TypeDefinition @"
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

public static class WireGuardDpapi {
    [StructLayout(LayoutKind.Sequential)]
    private struct DATA_BLOB {
        public int cbData;
        public IntPtr pbData;
    }

    [DllImport("crypt32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern bool CryptUnprotectData(
        ref DATA_BLOB pDataIn,
        out IntPtr ppszDataDescr,
        IntPtr pOptionalEntropy,
        IntPtr pvReserved,
        IntPtr pPromptStruct,
        uint dwFlags,
        ref DATA_BLOB pDataOut);

    [DllImport("crypt32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern bool CryptProtectData(
        ref DATA_BLOB pDataIn,
        string szDataDescr,
        IntPtr pOptionalEntropy,
        IntPtr pvReserved,
        IntPtr pPromptStruct,
        uint dwFlags,
        ref DATA_BLOB pDataOut);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern IntPtr LocalFree(IntPtr hMem);

    private static DATA_BLOB ToBlob(byte[] data, out IntPtr mem) {
        mem = Marshal.AllocHGlobal(data.Length);
        Marshal.Copy(data, 0, mem, data.Length);
        return new DATA_BLOB { cbData = data.Length, pbData = mem };
    }

    public static byte[] Unprotect(byte[] encrypted, out string description) {
        IntPtr inMem = IntPtr.Zero;
        IntPtr descrPtr = IntPtr.Zero;
        DATA_BLOB input = ToBlob(encrypted, out inMem);
        DATA_BLOB output = new DATA_BLOB();
        try {
            if (!CryptUnprotectData(ref input, out descrPtr, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, 1, ref output))
                throw new Win32Exception(Marshal.GetLastWin32Error());
            description = descrPtr == IntPtr.Zero ? null : Marshal.PtrToStringUni(descrPtr);
            byte[] result = new byte[output.cbData];
            Marshal.Copy(output.pbData, result, 0, result.Length);
            return result;
        }
        finally {
            if (inMem != IntPtr.Zero) Marshal.FreeHGlobal(inMem);
            if (output.pbData != IntPtr.Zero) LocalFree(output.pbData);
            if (descrPtr != IntPtr.Zero) LocalFree(descrPtr);
        }
    }

    public static byte[] Protect(byte[] plain, string description) {
        IntPtr inMem = IntPtr.Zero;
        DATA_BLOB input = ToBlob(plain, out inMem);
        DATA_BLOB output = new DATA_BLOB();
        try {
            if (!CryptProtectData(ref input, description, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, 1, ref output))
                throw new Win32Exception(Marshal.GetLastWin32Error());
            byte[] result = new byte[output.cbData];
            Marshal.Copy(output.pbData, result, 0, result.Length);
            return result;
        }
        finally {
            if (inMem != IntPtr.Zero) Marshal.FreeHGlobal(inMem);
            if (output.pbData != IntPtr.Zero) LocalFree(output.pbData);
        }
    }
}
"@

    if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) { throw 'CONFIG_MISSING' }

    $cipher = [IO.File]::ReadAllBytes($ConfigPath)
    $description = $null
    $plain = [WireGuardDpapi]::Unprotect($cipher, [ref]$description)
    if ($description -ne 'SFO2-A') { throw 'DPAPI_DESCRIPTION_MISMATCH' }

    $text = [Text.UTF8Encoding]::new($false).GetString($plain)
    if ($text -notmatch '(?im)^\s*\[Peer\]\s*$') { throw 'PEER_SECTION_MISSING' }

    $ipv4Count = 0
    $ipv6Count = 0
    $newText = [regex]::Replace(
        $text,
        '(?im)^(?<prefix>\s*AllowedIPs\s*=\s*)(?<value>[^\r\n]+)$',
        [Text.RegularExpressions.MatchEvaluator]{
            param($m)
            $out = [Collections.Generic.List[string]]::new()
            foreach ($tokenRaw in ($m.Groups['value'].Value -split ',')) {
                $token = $tokenRaw.Trim()
                if ($token -eq '0.0.0.0/0') {
                    $out.Add('0.0.0.0/1')
                    $out.Add('128.0.0.0/1')
                    $script:ipv4Count++
                }
                elseif ($token -eq '::/0') {
                    $out.Add('::/1')
                    $out.Add('8000::/1')
                    $script:ipv6Count++
                }
                elseif (-not [string]::IsNullOrWhiteSpace($token)) {
                    $out.Add($token)
                }
            }
            return $m.Groups['prefix'].Value + (($out | Select-Object -Unique) -join ', ')
        }
    )

    if ($ipv4Count -lt 1 -and $ipv6Count -lt 1) { throw 'NO_DEFAULT_ALLOWEDIP_FOUND' }
    if ($newText -match '(?im)^\s*AllowedIPs\s*=.*(?:^|,\s*)(?:0\.0\.0\.0/0|::/0)(?:\s*,|\s*$)') {
        throw 'DEFAULT_ALLOWEDIP_REMAINS'
    }

    New-Item -ItemType Directory -Path (Split-Path -Parent $BackupPath) -Force | Out-Null
    Copy-Item -LiteralPath $ConfigPath -Destination $BackupPath -Force

    $newBytes = [Text.UTF8Encoding]::new($false).GetBytes($newText)
    $newCipher = [WireGuardDpapi]::Protect($newBytes, 'SFO2-A')
    $tempConfig = $ConfigPath + '.repair-' + [guid]::NewGuid().ToString('N')
    [IO.File]::WriteAllBytes($tempConfig, $newCipher)

    $acl = Get-Acl -LiteralPath $ConfigPath
    Set-Acl -LiteralPath $tempConfig -AclObject $acl
    Move-Item -LiteralPath $tempConfig -Destination $ConfigPath -Force

    Write-Status @(
        'RESULT=PASS',
        'MODE=APPLY',
        'DPAPI_DESCRIPTION_MATCH=YES',
        ('REPLACED_IPV4_DEFAULT_COUNT=' + $ipv4Count),
        ('REPLACED_IPV6_DEFAULT_COUNT=' + $ipv6Count),
        'PLAINTEXT_CONFIG_WRITTEN_TO_DISK=NO',
        'ENCRYPTED_BACKUP_CREATED=YES'
    )
}
catch {
    $code = [string]$_.Exception.Message
    if ($code -notmatch '^[A-Z][A-Z0-9_]*$') { $code = 'SYSTEM_WORKER_ERROR' }
    try { Write-Status @('RESULT=FAIL',('CODE=' + $code)) } catch { }
    exit 1
}
'@

try {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    Assert-Check ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_ELEVATION_REQUIRED'
    Assert-Check ($PSVersionTable.PSVersion.ToString() -eq '7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-Check (Test-Path -LiteralPath $configPath -PathType Leaf) 'WIREGUARD_DPAPI_CONFIG_NOT_FOUND'
    Assert-Check (Test-Path -LiteralPath $wireGuardExe -PathType Leaf) 'WIREGUARD_EXE_NOT_FOUND'
    Assert-Check (Test-Path -LiteralPath $wgExe -PathType Leaf) 'WG_EXE_NOT_FOUND'

    $manager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $tunnel = Get-Service -Name $serviceName -ErrorAction Stop
    $adapter = Get-NetAdapter -Name $tunnelName -ErrorAction Stop
    Assert-Check ($manager.Status -eq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-Check ($tunnel.Status -eq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
    Assert-Check ($adapter.Status -eq 'Up') 'WIREGUARD_ADAPTER_NOT_UP'

    $beforeV4 = Get-WgV4RouteState
    $beforeV6 = Get-WgV6RouteState
    Assert-Check $beforeV4.HasDefault 'WG_IPV4_DEFAULT_ROUTE_NOT_PRESENT'
    $beforeKill = Get-WfpKillSwitchPresent -OutputPath (Join-Path $env:TEMP ('wg-killswitch-pre-' + $runId + '.xml'))
    Assert-Check $beforeKill 'WG_KILLSWITCH_NOT_PRESENT_AT_PREFLIGHT'

    $peerLines = @(& $wgExe show $tunnelName peers 2>$null)
    Assert-Check ($LASTEXITCODE -eq 0) 'WG_PEER_QUERY_FAILED'
    Assert-Check ($peerLines.Count -eq 1) 'WG_PEER_CARDINALITY_NOT_ONE'

    Write-Output 'REPAIR_PREFLIGHT=PASS'
    Write-Output 'ROOT_CAUSE_WG_KILLSWITCH_CONFIRMED=YES'
    Write-Output 'REPAIR_PLAN=REPLACE_DEFAULT_ALLOWEDIPS_WITH_SPLIT_DEFAULTS'
    Write-Output 'PLAINTEXT_CONFIG_WILL_NOT_BE_WRITTEN_TO_DISK=YES'

    New-Item -ItemType Directory -Path $work -Force | Out-Null
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    & icacls.exe $root /inheritance:r /grant:r 'SYSTEM:(OI)(CI)(F)' 'Administrators:(OI)(CI)(F)' | Out-Null
    & icacls.exe $work /inheritance:r /grant:r 'SYSTEM:(OI)(CI)(F)' 'Administrators:(OI)(CI)(F)' | Out-Null
    & icacls.exe $backupDir /inheritance:r /grant:r 'SYSTEM:(OI)(CI)(F)' 'Administrators:(OI)(CI)(F)' | Out-Null

    [IO.File]::WriteAllText($workerPath, $worker, [Text.UTF8Encoding]::new($false))
    & icacls.exe $workerPath /inheritance:r /grant:r 'SYSTEM:(F)' 'Administrators:(F)' | Out-Null

    Write-Output 'WIREGUARD_TUNNEL_RELOAD=START'
    Stop-Service -Name $serviceName -Force -ErrorAction Stop
    Assert-Check (Wait-ServiceState -Name $serviceName -State 'Stopped' -TimeoutSeconds 30) 'WIREGUARD_TUNNEL_STOP_TIMEOUT'
    Write-Output 'WIREGUARD_TUNNEL_STOPPED=YES'

    $status = Register-And-RunSystemTask -WorkerMode 'Apply'
    Remove-SystemTask
    Assert-Check ($status -match '(?m)^RESULT=PASS$') 'SYSTEM_REPAIR_WORKER_FAILED'
    Assert-Check ($status -match '(?m)^DPAPI_DESCRIPTION_MATCH=YES$') 'DPAPI_DESCRIPTION_NOT_CONFIRMED'
    Assert-Check ($status -match '(?m)^ENCRYPTED_BACKUP_CREATED=YES$') 'ENCRYPTED_BACKUP_NOT_CONFIRMED'
    Write-Output 'WIREGUARD_ENCRYPTED_CONFIG_PATCHED=YES'
    Write-Output 'WIREGUARD_ENCRYPTED_ROLLBACK_BACKUP_CREATED=YES'
    $repairApplied = $true

    Start-Service -Name $serviceName -ErrorAction Stop
    Assert-Check (Wait-ServiceState -Name $serviceName -State 'Running' -TimeoutSeconds 30) 'WIREGUARD_TUNNEL_START_TIMEOUT'

    $deadline = (Get-Date).AddSeconds(30)
    do {
        $adapterAfter = Get-NetAdapter -Name $tunnelName -ErrorAction SilentlyContinue
        if ($null -ne $adapterAfter -and $adapterAfter.Status -eq 'Up') { break }
        Start-Sleep -Milliseconds 250
    } while ((Get-Date) -lt $deadline)
    Assert-Check ($null -ne $adapterAfter -and $adapterAfter.Status -eq 'Up') 'WIREGUARD_ADAPTER_RESTORE_TIMEOUT'

    $afterV4 = Get-WgV4RouteState
    $afterV6 = Get-WgV6RouteState
    Assert-Check (-not $afterV4.HasDefault) 'WG_IPV4_DEFAULT_ROUTE_STILL_PRESENT'
    Assert-Check ($afterV4.HasSplitA -and $afterV4.HasSplitB) 'WG_IPV4_SPLIT_DEFAULTS_MISSING'
    if ($beforeV6.HasDefault) {
        Assert-Check (-not $afterV6.HasDefault) 'WG_IPV6_DEFAULT_ROUTE_STILL_PRESENT'
        Assert-Check ($afterV6.HasSplitA -and $afterV6.HasSplitB) 'WG_IPV6_SPLIT_DEFAULTS_MISSING'
    }

    $killAfter = Get-WfpKillSwitchPresent -OutputPath $wfpPath
    Assert-Check (-not $killAfter) 'WG_KILLSWITCH_FILTER_STILL_PRESENT'

    $handshakes = @(& $wgExe show $tunnelName latest-handshakes 2>$null)
    Assert-Check ($LASTEXITCODE -eq 0) 'WG_HANDSHAKE_QUERY_FAILED'
    Assert-Check ($handshakes.Count -eq 1) 'WG_HANDSHAKE_RESULT_CARDINALITY_INVALID'
    $fields = $handshakes[0] -split '\s+'
    Assert-Check ($fields.Count -ge 2) 'WG_HANDSHAKE_RESULT_SHAPE_INVALID'
    $latestHandshake = [int64]$fields[-1]
    Assert-Check ($latestHandshake -gt 0) 'WG_LATEST_HANDSHAKE_MISSING'

    Write-Output 'WG_ROUTE_DEFAULT_V4_AFTER=NO'
    Write-Output 'WG_ROUTE_SPLIT_DEFAULTS_V4_AFTER=YES'
    Write-Output "WG_ROUTE_SPLIT_DEFAULTS_V6_AFTER=$(if($beforeV6.HasDefault){'YES'}else{'NOT_REQUIRED'})"
    Write-Output 'WFP_BLOCK_ALL_OUTBOUND_IPV4_AFTER=NO'
    Write-Output 'WIREGUARD_TUNNEL_RUNNING_AFTER=YES'
    Write-Output 'WIREGUARD_ADAPTER_UP_AFTER=YES'
    Write-Output 'WIREGUARD_LATEST_HANDSHAKE_PRESENT=YES'
    Write-Output 'KILLSWITCH_REPAIR_VERIFIED=YES'
    $repairVerified = $true
}
catch {
    $code = [string]$_.Exception.Message
    if ($code -notmatch '^[A-Z][A-Z0-9_]*$') { $code = 'REPAIR_RUNTIME_ERROR' }
    Write-Output "KILLSWITCH_REPAIR_RETURN_CODE=$code"

    if ($repairApplied -and -not $repairVerified) {
        $rollbackAttempted = $true
        Write-Output 'ROLLBACK=START'
        try {
            Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
            [void](Wait-ServiceState -Name $serviceName -State 'Stopped' -TimeoutSeconds 30)

            $rollbackStatus = Register-And-RunSystemTask -WorkerMode 'Rollback'
            Remove-SystemTask
            Assert-Check ($rollbackStatus -match '(?m)^RESULT=PASS$') 'ROLLBACK_SYSTEM_WORKER_FAILED'

            Start-Service -Name $serviceName -ErrorAction Stop
            Assert-Check (Wait-ServiceState -Name $serviceName -State 'Running' -TimeoutSeconds 30) 'ROLLBACK_TUNNEL_START_TIMEOUT'

            $deadline = (Get-Date).AddSeconds(30)
            do {
                $adapterRb = Get-NetAdapter -Name $tunnelName -ErrorAction SilentlyContinue
                if ($null -ne $adapterRb -and $adapterRb.Status -eq 'Up') { break }
                Start-Sleep -Milliseconds 250
            } while ((Get-Date) -lt $deadline)
            Assert-Check ($null -ne $adapterRb -and $adapterRb.Status -eq 'Up') 'ROLLBACK_ADAPTER_RESTORE_TIMEOUT'

            $rbV4 = Get-WgV4RouteState
            Assert-Check $rbV4.HasDefault 'ROLLBACK_IPV4_DEFAULT_ROUTE_MISSING'
            $rbKill = Get-WfpKillSwitchPresent -OutputPath (Join-Path $work 'wfp-rollback.xml')
            Assert-Check $rbKill 'ROLLBACK_KILLSWITCH_NOT_RESTORED'

            $rollbackVerified = $true
            Write-Output 'ROLLBACK_VERIFIED=YES'
        }
        catch {
            Write-Output 'ROLLBACK_VERIFIED=NO'
            Add-CleanupFailure 'ROLLBACK_FAILED'
        }
    }
}
finally {
    if ($taskRegistered) { Remove-SystemTask }

    try {
        if (Test-Path -LiteralPath $workerPath) { Remove-Item -LiteralPath $workerPath -Force -ErrorAction Stop }
        if (Test-Path -LiteralPath $statusPath) { Remove-Item -LiteralPath $statusPath -Force -ErrorAction Stop }
        if (Test-Path -LiteralPath ($statusPath + '.tmp')) { Remove-Item -LiteralPath ($statusPath + '.tmp') -Force -ErrorAction Stop }
        if (Test-Path -LiteralPath $wfpPath) { Remove-Item -LiteralPath $wfpPath -Force -ErrorAction Stop }
        $preWfp = Join-Path $env:TEMP ('wg-killswitch-pre-' + $runId + '.xml')
        if (Test-Path -LiteralPath $preWfp) { Remove-Item -LiteralPath $preWfp -Force -ErrorAction Stop }
        Write-Output 'TEMP_REPAIR_ARTIFACTS_CLEAN=YES'
    }
    catch {
        Add-CleanupFailure 'TEMP_REPAIR_ARTIFACT_CLEANUP_FAILED'
    }

    try {
        $managerFinal = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
        Assert-Check ($managerFinal.Status -eq 'Running') 'FINAL_WIREGUARD_MANAGER_NOT_RUNNING'
        Write-Output 'FINAL_WIREGUARD_MANAGER=RUNNING'
    }
    catch {
        Add-CleanupFailure 'FINAL_WIREGUARD_MANAGER_READBACK_FAILED'
    }
}

Write-Output "REPAIR_APPLIED=$repairApplied"
Write-Output "REPAIR_VERIFIED=$repairVerified"
Write-Output "ROLLBACK_ATTEMPTED=$rollbackAttempted"
Write-Output "ROLLBACK_VERIFIED=$rollbackVerified"
Write-Output "CLEANUP_FAILURE_COUNT=$($cleanupFailures.Count)"
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'PLAINTEXT_WIREGUARD_CONFIG_PERSISTED=NO'

if ($repairVerified -and $cleanupFailures.Count -eq 0) {
    Write-Output "ENCRYPTED_ROLLBACK_BACKUP_PATH=$backupPath"
    Write-Output 'OWNER_WIREGUARD_KILLSWITCH_REPAIR_RESULT=PASS_CANDIDATE'
    exit 0
}
Write-Output 'OWNER_WIREGUARD_KILLSWITCH_REPAIR_RESULT=RETURN_TO_REVIEWER'
exit 1
