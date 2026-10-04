[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

$probeCount = 0

function Invoke-Socks5Greeting {
    param([int]$Port)

    $client = [Net.Sockets.TcpClient]::new()
    try {
        $connectTask = $client.ConnectAsync('127.0.0.1', $Port)
        if (-not $connectTask.Wait(1000)) {
            return 'CONNECT_TIMEOUT'
        }

        $stream = $client.GetStream()
        $stream.ReadTimeout = 1000
        $stream.WriteTimeout = 1000

        $greeting = [byte[]](0x05,0x01,0x00)
        $stream.Write($greeting,0,$greeting.Length)
        $stream.Flush()

        $response = [byte[]]::new(2)
        $read = 0
        try {
            while ($read -lt 2) {
                $n = $stream.Read($response,$read,2-$read)
                if ($n -le 0) { break }
                $read += $n
            }
        }
        catch [IO.IOException] {
            return 'NO_RESPONSE'
        }

        if ($read -ne 2) { return 'NO_RESPONSE' }

        if ($response[0] -eq 0x05 -and $response[1] -eq 0x00) {
            return 'SOCKS5_NOAUTH'
        }

        if ($response[0] -eq 0x05) {
            return ('SOCKS5_METHOD_' + $response[1].ToString('X2'))
        }

        return ('NON_SOCKS_' + $response[0].ToString('X2') + $response[1].ToString('X2'))
    }
    catch {
        return ('ERROR_' + $_.Exception.GetType().Name)
    }
    finally {
        $client.Dispose()
    }
}

try {
    $service = Get-Service -Name 'clash_verge_service' -ErrorAction Stop
    Write-Output ('CLASH_VERGE_SERVICE_STATUS=' + [string]$service.Status)

    $processes = @(
        Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessName -match '(?i)(?:mihomo|clash)' } |
        Sort-Object Id
    )

    $listeners = [Collections.Generic.List[object]]::new()
    foreach ($process in $processes) {
        foreach ($listener in @(Get-NetTCPConnection -State Listen -OwningProcess $process.Id -ErrorAction SilentlyContinue)) {
            if ([string]$listener.LocalAddress -in @('127.0.0.1','0.0.0.0','::1','::')) {
                $listeners.Add([pscustomobject]@{
                    ProcessName = [string]$process.ProcessName
                    LocalAddress = [string]$listener.LocalAddress
                    LocalPort = [int]$listener.LocalPort
                })
            }
        }
    }

    $listeners = @($listeners | Sort-Object ProcessName,LocalPort,LocalAddress -Unique)
    Write-Output ('CANDIDATE_LISTENER_COUNT=' + @($listeners).Count)

    $probeResults = [Collections.Generic.List[object]]::new()
    foreach ($listener in $listeners) {
        $probeCount++
        $result = Invoke-Socks5Greeting -Port $listener.LocalPort
        $probeResults.Add([pscustomobject]@{
            ProcessName = $listener.ProcessName
            LocalAddress = $listener.LocalAddress
            LocalPort = $listener.LocalPort
            Result = $result
        })
        Write-Output ('SOCKS5_PROBE=' + $listener.ProcessName + '|' + $listener.LocalAddress + '|' + $listener.LocalPort + '|' + $result)
    }

    $socksListeners = @($probeResults | Where-Object { $_.Result -eq 'SOCKS5_NOAUTH' })

    Write-Output ('SOCKS5_PROXY_LISTENER_COUNT=' + @($socksListeners).Count)
    foreach ($listener in $socksListeners) {
        Write-Output ('SOCKS5_PROXY_LISTENER=' + $listener.ProcessName + '|' + $listener.LocalAddress + '|' + $listener.LocalPort)
    }

    Write-Output 'C2C_LOCAL_PROXY_PROTOCOL_DIAGNOSTIC=PASS'
}
catch {
    Write-Output 'C2C_LOCAL_PROXY_PROTOCOL_DIAGNOSTIC=RETURN'
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
    Write-Output ('LOCAL_SOCKET_PROBES=' + $probeCount)
    Write-Output 'EXTERNAL_NETWORK_REQUESTS=0'
    Write-Output 'DPAPI_UNPROTECT=NO'
    Write-Output 'REAL_SECRET_READ=NO'
    Write-Output 'CLASH_PROFILE_MUTATION=NO'
    Write-Output 'NETWORK_CHANGED=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
