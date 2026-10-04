[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

try {
    $internet = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    $proxyEnable = if ($null -ne $internet.PSObject.Properties['ProxyEnable']) { [int]$internet.ProxyEnable } else { -1 }
    $proxyServer = if ($null -ne $internet.PSObject.Properties['ProxyServer']) { [string]$internet.ProxyServer } else { '' }

    Write-Output ('SYSTEM_PROXY_ENABLE=' + $proxyEnable)

    $registryPorts = @(
        [regex]::Matches($proxyServer, '(?i)(?:127\.0\.0\.1|localhost):(?<p>\d{2,5})') |
        ForEach-Object { [int]$_.Groups['p'].Value } |
        Sort-Object -Unique
    )
    Write-Output ('REGISTRY_PROXY_PORT_COUNT=' + @($registryPorts).Count)
    if (@($registryPorts).Count -gt 0) {
        Write-Output ('REGISTRY_PROXY_PORTS=' + (($registryPorts | ForEach-Object { [string]$_ }) -join ','))
    }

    $service = Get-Service -Name 'clash_verge_service' -ErrorAction Stop
    Write-Output ('CLASH_VERGE_SERVICE_STATUS=' + [string]$service.Status)

    $candidateProcesses = @(
        Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessName -match '(?i)(?:mihomo|clash)' } |
        Sort-Object Id
    )

    Write-Output ('CLASH_MIHOMO_PROCESS_COUNT=' + @($candidateProcesses).Count)

    $ownedListeners = [Collections.Generic.List[object]]::new()
    foreach ($process in $candidateProcesses) {
        $listeners = @(
            Get-NetTCPConnection -State Listen -OwningProcess $process.Id -ErrorAction SilentlyContinue
        )
        foreach ($listener in $listeners) {
            $address = [string]$listener.LocalAddress
            if ($address -in @('127.0.0.1','0.0.0.0','::1','::')) {
                $ownedListeners.Add([pscustomobject]@{
                    ProcessName = [string]$process.ProcessName
                    LocalAddress = $address
                    LocalPort = [int]$listener.LocalPort
                })
            }
        }
    }

    $ownedListeners = @(
        $ownedListeners |
        Sort-Object ProcessName, LocalPort, LocalAddress -Unique
    )

    Write-Output ('CLASH_MIHOMO_LISTENER_COUNT=' + @($ownedListeners).Count)
    foreach ($listener in $ownedListeners) {
        Write-Output ('CLASH_MIHOMO_LISTENER=' + $listener.ProcessName + '|' + $listener.LocalAddress + '|' + $listener.LocalPort)
    }

    foreach ($port in $registryPorts) {
        $atPort = @(
            Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue
        )
        Write-Output ('REGISTRY_PORT_' + $port + '_LISTENER_COUNT=' + @($atPort).Count)

        foreach ($listener in $atPort) {
            $name = 'UNRESOLVED'
            try {
                $name = (Get-Process -Id $listener.OwningProcess -ErrorAction Stop).ProcessName
            }
            catch { }

            Write-Output ('REGISTRY_PORT_' + $port + '_LISTENER=' + $name + '|' + [string]$listener.LocalAddress)
        }
    }

    $ownedPorts = @($ownedListeners | ForEach-Object { $_.LocalPort } | Sort-Object -Unique)
    $intersection = @($registryPorts | Where-Object { $ownedPorts -contains $_ } | Sort-Object -Unique)

    Write-Output ('REGISTRY_TO_CLASH_LISTENER_MATCH_COUNT=' + @($intersection).Count)
    if (@($intersection).Count -gt 0) {
        Write-Output ('REGISTRY_TO_CLASH_LISTENER_MATCH_PORTS=' + (($intersection | ForEach-Object { [string]$_ }) -join ','))
    }

    Write-Output 'C2C_LOCAL_PROXY_LISTENER_DIAGNOSTIC=PASS'
}
catch {
    Write-Output 'C2C_LOCAL_PROXY_LISTENER_DIAGNOSTIC=RETURN'
    $code=[string]$_.Exception.Message
    if ($code -cmatch '^[A-Z][A-Z0-9_]{1,95}$') {
        Write-Output ('FAILURE_CODE=' + $code)
    }
    else {
        Write-Output ('FAILURE_CLASS=' + $_.Exception.GetType().Name)
        Write-Output 'FAILURE_CODE=UNCLASSIFIED'
    }
    exit 1
}
finally {
    $finished=[DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished-$started).ToString('c'))
    Write-Output 'DPAPI_UNPROTECT=NO'
    Write-Output 'REAL_SECRET_READ=NO'
    Write-Output 'CLASH_PROFILE_MUTATION=NO'
    Write-Output 'NETWORK_REQUESTS=0'
    Write-Output 'NETWORK_CHANGED=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
