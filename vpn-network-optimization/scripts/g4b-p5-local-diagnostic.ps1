[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:stage = 'BOOT'
$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$recoveryRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery'
$hy2Recovery = Join-Path $recoveryRoot 'hy2-g2a.dpapi'
$mihomo = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
$pinTemplatePath = Join-Path $projectRoot 'templates\clash\c2c-real-hy2-canary.yaml.template'

function Write-Stage {
    param([string]$Name)
    $script:stage = $Name
    Write-Output ('DIAGNOSTIC_STAGE=' + $Name)
}

function Assert-Diagnostic {
    param([bool]$Condition,[string]$Code)
    if(-not $Condition){ throw $Code }
}

try {
    Write-Stage 'POST_FAILURE_CLEANUP'
    Assert-Diagnostic (Test-Path -LiteralPath $runtimeRoot -PathType Container) 'RUNTIME_ROOT_MISSING'
    $baiduRuntimes = @(Get-ChildItem -LiteralPath $runtimeRoot -Directory -Force -ErrorAction Stop | Where-Object { $_.Name -like 'g4b-baidu-*' })
    $liveRuntimes = @(Get-ChildItem -LiteralPath $runtimeRoot -Directory -Force -ErrorAction Stop | Where-Object { $_.Name -like 'g4b-*' -and $_.Name -notlike 'g4b-baidu-*' })
    Write-Output ('POST_FAILURE_BAIDU_RUNTIME_COUNT=' + $baiduRuntimes.Count)
    Write-Output ('POST_FAILURE_LIVE_RUNTIME_COUNT=' + $liveRuntimes.Count)
    Assert-Diagnostic ($baiduRuntimes.Count -eq 0) 'BAIDU_RUNTIME_CLEANUP_INCOMPLETE'
    Assert-Diagnostic ($liveRuntimes.Count -eq 0) 'LOCAL_RUNTIME_CLEANUP_INCOMPLETE'
    Write-Output 'POST_FAILURE_LOCAL_CLEANUP=PASS'

    Write-Stage 'HY2_DPAPI_UNPROTECT'
    Assert-Diagnostic (Test-Path -LiteralPath $hy2Recovery -PathType Leaf) 'HY2_RECOVERY_MISSING'
    $cipher = [IO.File]::ReadAllBytes($hy2Recovery)
    $plain = $null
    $reader = $null
    $stream = $null
    $files = @{}
    try {
        $plain = [Security.Cryptography.ProtectedData]::Unprotect(
            $cipher,
            $null,
            [Security.Cryptography.DataProtectionScope]::CurrentUser
        )
        Assert-Diagnostic ($null -ne $plain -and $plain.Length -gt 0 -and $plain.Length -le 131072) 'HY2_DPAPI_UNPROTECT_INVALID'
        Write-Output 'HY2_DPAPI_UNPROTECT=PASS'

        Write-Stage 'HY2_FRAME_PARSE'
        $stream = [IO.MemoryStream]::new($plain,$false)
        $reader = [IO.BinaryReader]::new($stream,[Text.Encoding]::UTF8,$true)
        $magic = [Text.Encoding]::ASCII.GetString($reader.ReadBytes(8))
        Assert-Diagnostic ($magic -ceq 'VPNHY2R1') 'HY2_RECOVERY_MAGIC_INVALID'

        while($stream.Position -lt $stream.Length){
            $nameLength = [int]$reader.ReadByte()
            Assert-Diagnostic ($nameLength -ge 1 -and $nameLength -le 32) 'HY2_RECOVERY_NAME_LENGTH_INVALID'

            $lengthBytes = $reader.ReadBytes(4)
            Assert-Diagnostic ($lengthBytes.Length -eq 4) 'HY2_RECOVERY_FRAME_TRUNCATED'

            [uint32]$length = ([uint32]$lengthBytes[0] -shl 24) -bor
                               ([uint32]$lengthBytes[1] -shl 16) -bor
                               ([uint32]$lengthBytes[2] -shl 8) -bor
                               [uint32]$lengthBytes[3]

            Assert-Diagnostic ($length -gt 0 -and $length -le 65536) 'HY2_RECOVERY_DATA_LENGTH_INVALID'

            $name = [Text.Encoding]::UTF8.GetString($reader.ReadBytes($nameLength))
            Assert-Diagnostic ($name -in @('hy2-auth','server.key','server.crt')) 'HY2_RECOVERY_ALLOWLIST_INVALID'
            Assert-Diagnostic (-not $files.ContainsKey($name)) 'HY2_RECOVERY_DUPLICATE_FIELD'

            $data = $reader.ReadBytes([int]$length)
            Assert-Diagnostic ($data.Length -eq $length) 'HY2_RECOVERY_FRAME_TRUNCATED'
            $files[$name] = $data
        }

        Assert-Diagnostic ($files.Count -eq 3) 'HY2_RECOVERY_CARDINALITY_INVALID'
        Assert-Diagnostic ($files.ContainsKey('hy2-auth') -and $files.ContainsKey('server.key') -and $files.ContainsKey('server.crt')) 'HY2_RECOVERY_REQUIRED_FIELD_MISSING'

        $authBytes = [byte[]]$files['hy2-auth']
        Assert-Diagnostic ($authBytes.Length -eq 64) 'HY2_AUTH_LENGTH_INVALID'
        Assert-Diagnostic ([regex]::IsMatch([Text.Encoding]::ASCII.GetString($authBytes),'^[0-9a-f]{64}$')) 'HY2_AUTH_FORMAT_INVALID'
        Write-Output 'HY2_FRAME_PARSE=PASS'

        Write-Stage 'HY2_CERTIFICATE_CONTRACT'
        Assert-Diagnostic (Test-Path -LiteralPath $pinTemplatePath -PathType Leaf) 'HY2_PIN_TEMPLATE_MISSING'
        $pinTemplate = [IO.File]::ReadAllText($pinTemplatePath,[Text.Encoding]::UTF8)
        $match = [regex]::Match($pinTemplate,'(?m)^\s*fingerprint:\s*(?<v>[0-9A-F]{2}(?::[0-9A-F]{2}){31})\s*$')
        Assert-Diagnostic $match.Success 'HY2_PIN_TEMPLATE_INVALID'

        $cert = [Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$files['server.crt'])
        try {
            $fingerprint = [string]::Join(
                ':',
                [regex]::Matches(
                    [Convert]::ToHexString(
                        $cert.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256)
                    ),
                    '..'
                ).Value
            )
            Assert-Diagnostic ($fingerprint -ceq $match.Groups['v'].Value) 'HY2_CERTIFICATE_FINGERPRINT_MISMATCH'
            Write-Output 'HY2_CERTIFICATE_CONTRACT=PASS'
        }
        finally {
            $fingerprint = $null
            $cert.Dispose()
        }
    }
    finally {
        if($reader){$reader.Dispose()}
        if($stream){$stream.Dispose()}
        foreach($value in $files.Values){
            if($null -ne $value){[Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value)}
        }
        if($null -ne $plain){[Security.Cryptography.CryptographicOperations]::ZeroMemory($plain)}
        if($null -ne $cipher){[Security.Cryptography.CryptographicOperations]::ZeroMemory($cipher)}
    }

    Write-Stage 'MIHOMO_VERSION'
    Assert-Diagnostic (Test-Path -LiteralPath $mihomo -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    $versionProcess = [Diagnostics.Process]::new()
    try {
        $versionProcess.StartInfo.FileName = $mihomo
        $versionProcess.StartInfo.UseShellExecute = $false
        $versionProcess.StartInfo.RedirectStandardOutput = $true
        $versionProcess.StartInfo.RedirectStandardError = $true
        [void]$versionProcess.StartInfo.ArgumentList.Add('-v')
        Assert-Diagnostic ($versionProcess.Start()) 'MIHOMO_VERSION_START_FAILED'
        $versionOutTask = $versionProcess.StandardOutput.ReadToEndAsync()
        $versionErrTask = $versionProcess.StandardError.ReadToEndAsync()
        if(-not $versionProcess.WaitForExit(15000)){
            try{$versionProcess.Kill($true)}catch{}
            throw 'MIHOMO_VERSION_TIMEOUT'
        }
        $versionText = $versionOutTask.GetAwaiter().GetResult()
        [void]$versionErrTask.GetAwaiter().GetResult()
        Assert-Diagnostic ($versionProcess.ExitCode -eq 0) 'MIHOMO_VERSION_FAILED'
        Assert-Diagnostic ($versionText -match '(?i)1\.19\.32') 'MIHOMO_VERSION_MISMATCH'
        Write-Output 'MIHOMO_VERSION=PASS'
    }
    finally {
        $versionText = $null
        $versionProcess.Dispose()
    }

    Write-Stage 'MIHOMO_REALITY_KEYPAIR'
    $keyProcess = [Diagnostics.Process]::new()
    try {
        $keyProcess.StartInfo.FileName = $mihomo
        $keyProcess.StartInfo.UseShellExecute = $false
        $keyProcess.StartInfo.RedirectStandardOutput = $true
        $keyProcess.StartInfo.RedirectStandardError = $true
        [void]$keyProcess.StartInfo.ArgumentList.Add('generate')
        [void]$keyProcess.StartInfo.ArgumentList.Add('reality-keypair')
        Assert-Diagnostic ($keyProcess.Start()) 'REALITY_KEYPAIR_START_FAILED'
        $keyOutTask = $keyProcess.StandardOutput.ReadToEndAsync()
        $keyErrTask = $keyProcess.StandardError.ReadToEndAsync()
        if(-not $keyProcess.WaitForExit(15000)){
            try{$keyProcess.Kill($true)}catch{}
            throw 'REALITY_KEYPAIR_TIMEOUT'
        }
        $keyText = $keyOutTask.GetAwaiter().GetResult()
        [void]$keyErrTask.GetAwaiter().GetResult()
        Assert-Diagnostic ($keyProcess.ExitCode -eq 0) 'REALITY_KEYPAIR_GENERATION_FAILED'
        $private = [regex]::Match($keyText,'(?im)^PrivateKey:\s*(?<v>[A-Za-z0-9_-]{40,64})\s*$')
        $public = [regex]::Match($keyText,'(?im)^PublicKey:\s*(?<v>[A-Za-z0-9_-]{40,64})\s*$')
        Assert-Diagnostic ($private.Success -and $public.Success) 'REALITY_KEYPAIR_FORMAT_INVALID'
        Write-Output 'MIHOMO_REALITY_KEYPAIR=PASS'
    }
    finally {
        $private = $null
        $public = $null
        $keyText = $null
        $keyProcess.Dispose()
    }

    Write-Output 'BAIDU_NETWORK_ACTION=NO'
    Write-Output 'SSH_OR_VPS_ACTION=NO'
    Write-Output 'RECOVERY_WRITE=NO'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output 'G4B_P5_LOCAL_DIAGNOSTIC=PASS'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
catch {
    $code = [string]$_.Exception.Message
    if($code -notmatch '^[A-Z][A-Z0-9_]{1,95}$'){
        $code = 'UNCLASSIFIED_LOCAL_EXCEPTION'
    }
    Write-Output ('DIAGNOSTIC_FAILED_STAGE=' + $script:stage)
    Write-Output ('DIAGNOSTIC_EXCEPTION_TYPE=' + $_.Exception.GetType().FullName)
    Write-Output ('DIAGNOSTIC_FAILURE_CODE=' + $code)
    Write-Output 'BAIDU_NETWORK_ACTION=NO'
    Write-Output 'SSH_OR_VPS_ACTION=NO'
    Write-Output 'RECOVERY_WRITE=NO'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output 'STOP_AT_REVIEWER=YES'
    exit 1
}
