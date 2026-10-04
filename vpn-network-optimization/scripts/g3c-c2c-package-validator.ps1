[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$projectRoot = Split-Path -Parent $PSScriptRoot
$orchestratorPath = Join-Path $PSScriptRoot 'c2c-owner-clash-real-canary.ps1'
$secretHelperPath = Join-Path $PSScriptRoot 'c2c-secret-profile-helper.ps1'
$probePath = Join-Path $PSScriptRoot 'c2c-bounded-proxy-probe.ps1'
$templatePath = Join-Path $projectRoot 'templates\clash\c2c-real-hy2-canary.yaml.template'
$packagePath = Join-Path $projectRoot 'docs\G3C_C2C_REAL_HY2_CANARY_PACKAGE.md'
$mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'

foreach ($path in @($orchestratorPath,$secretHelperPath,$probePath,$templatePath,$packagePath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw 'C2C_PACKAGE_FILE_MISSING' }
}

$orchestrator = [IO.File]::ReadAllText($orchestratorPath)
$secretHelper = [IO.File]::ReadAllText($secretHelperPath)
$probe = [IO.File]::ReadAllText($probePath)
$template = [IO.File]::ReadAllText($templatePath)
$package = [IO.File]::ReadAllText($packagePath)

function Test-C2CPackage {
    param([string]$O,[string]$S,[string]$P,[string]$T,[string]$D)

    if ($O -match '(?im)\bProtectedData\b|::Unprotect\s*\(|hy2-auth|hy2-g2a\.dpapi') { throw 'ORCHESTRATOR_SECRET_ACCESS_FORBIDDEN' }
    if ($O -notmatch '(?im)c2c-secret-profile-helper\.ps1' -or $O -notmatch '(?im)c2c-bounded-proxy-probe\.ps1') { throw 'ORCHESTRATOR_HELPER_BOUNDARY_MISSING' }

    foreach ($ack in @(
        'C2C_IMPORT_ACK|IMPORT=YES|PROFILE_ACTIVE=YES|WG_VISIBLE=YES|HY2_REAL_VISIBLE=YES|SELECTOR_VISIBLE=YES|CURRENT=WG-BASELINE|SYSTEM_PROXY=OFF|TUN=OFF',
        'C2C_HY2_ACK|CURRENT=HY2-SFO3-REAL|SYSTEM_PROXY=OFF|TUN=OFF',
        'C2C_CLEANUP_ACK|CURRENT_BEFORE_REMOVE=WG-BASELINE|PROFILE_REMOVED=YES|SYSTEM_PROXY=OFF|TUN=OFF'
    )) {
        if ($O -notmatch [regex]::Escape($ack)) { throw 'STRUCTURED_UI_ACK_CONTRACT_MISSING' }
    }

    if ($O -notmatch '(?im)New-NetRoute[^\r\n]*-PolicyStore\s+ActiveStore' -or $O -notmatch '(?im)Remove-NetRoute' -or $O -notmatch '(?im)Get-NetRoute[^\r\n]*-PolicyStore\s+PersistentStore') { throw 'TEMP_ROUTE_LIFECYCLE_GUARD_MISSING' }
    if ($O -match '(?im)New-NetRoute[^\r\n]*-PolicyStore\s+PersistentStore' -or $O -match '(?im)\$_\.PolicyStore') { throw 'PERSISTENT_OR_NONPORTABLE_ROUTE_USE_FORBIDDEN' }
    if ($O -notmatch '(?im)FINAL_PRODUCTION_WIREGUARD=RESTORED' -or $O -notmatch '(?im)FINAL_SYSTEM_PROXY=OFF' -or $O -notmatch '(?im)FINAL_TUN=OFF' -or $O -notmatch '(?im)FINAL_ROUTE_SNAPSHOT=RESTORED') { throw 'FINAL_NETWORK_READBACK_MISSING' }
    if ($O -match '(?im)\b(?:Stop-Service|Restart-Service)\b[^\r\n]*WireGuard|Set-ItemProperty[^\r\n]*ProxyEnable|(?:enable-tun|tun)\s*:\s*true') { throw 'PRODUCTION_NETWORK_MUTATION_FORBIDDEN' }
    if ($O -match '(?im)sampleCount|\bbenchmark\b') { throw 'C2C_BENCHMARK_FORBIDDEN' }
    if ($O -match '(?im)ProxyServer') { throw 'STALE_PROXY_METADATA_DEPENDENCY_FORBIDDEN' }
    if ($O -notmatch '(?im)function\s+Invoke-LocalSocks5Greeting' -or
        $O -notmatch '(?im)SOCKS5_NOAUTH' -or
        $O -notmatch '(?im)CLASH_LOCAL_PROXY_DISCOVERY=LIVE_PROCESS_SOCKS5') {
        throw 'LIVE_SOCKS5_DISCOVERY_GUARD_MISSING'
    }
    $resolver = [regex]::Match($O, '(?is)function\s+Resolve-LocalProxyPort\s*\{(?<body>.*?)\r?\n\}\s*(?=function\s+Assert-LocalProxyListener)')
    if (-not $resolver.Success -or $resolver.Groups['body'].Value -notmatch '(?im)^\s*return\s+\[int\]\$socksPorts\[0\]\s*$') {
        throw 'PROXY_RESOLVER_SCALAR_RETURN_INVALID'
    }
    if ($resolver.Groups['body'].Value -match '(?im)\bWrite-Output\b') {
        throw 'PROXY_RESOLVER_SUCCESS_STREAM_DIAGNOSTIC_FORBIDDEN'
    }

    $helperInvoker = [regex]::Match($O, '(?is)function\s+Invoke-SecretHelper\s*\{(?<body>.*?)\r?\n\}\s*(?=function\s+Write-ApprovedSecretHelperEvidence)')
    $evidenceForwarder = [regex]::Match($O, '(?is)function\s+Write-ApprovedSecretHelperEvidence\s*\{(?<body>.*?)\r?\n\}\s*(?=function\s+Require-Markers)')
    if (-not $helperInvoker.Success -or -not $evidenceForwarder.Success -or
        $helperInvoker.Groups['body'].Value -match '(?im)\bWrite-Output\b' -or
        $helperInvoker.Groups['body'].Value -notmatch '(?im)return\s+,\$output') {
        throw 'SECRET_HELPER_EVIDENCE_FORWARDING_CONTRACT_INVALID'
    }
    $forwarderBody = $evidenceForwarder.Groups['body'].Value
    if ($forwarderBody -notmatch '(?im)\$allowedLines\s+-ccontains\s+\$text' -or
        $forwarderBody -notmatch '(?im)TEMP_REAL_PROFILE_PATH=\.\+' -or
        $forwarderBody -notmatch '(?im)Write-Output\s+\$text') {
        throw 'SECRET_HELPER_EVIDENCE_ALLOWLIST_INVALID'
    }
    foreach ($call in @(
        '\$prepareOutput\s*=\s*Invoke-SecretHelper\s+-Mode\s+Prepare\s*\r?\n\s*Write-ApprovedSecretHelperEvidence\s+-Output\s+\$prepareOutput\s+-Mode\s+Prepare',
        '\$cleanupOutput\s*=\s*Invoke-SecretHelper\s+-Mode\s+VerifyCleanup\s*\r?\n\s*Write-ApprovedSecretHelperEvidence\s+-Output\s+\$cleanupOutput\s+-Mode\s+VerifyCleanup',
        '\$fallbackOutput\s*=\s*Invoke-SecretHelper\s+-Mode\s+VerifyCleanup\s*\r?\n\s*Write-ApprovedSecretHelperEvidence\s+-Output\s+\$fallbackOutput\s+-Mode\s+VerifyCleanup'
    )) {
        if ($O -notmatch "(?im)$call") { throw 'SECRET_HELPER_CALLER_EVIDENCE_FORWARDING_MISSING' }
    }

    if ($S -notmatch '(?im)ProtectedData\]::Unprotect' -or $S -notmatch '(?im)DataProtectionScope\]::CurrentUser' -or $S -notmatch '(?im)hy2-g2a\.dpapi' -or $S -notmatch '(?im)VPNHY2R1') { throw 'SECRET_HELPER_DPAPI_CONTRACT_MISSING' }
    if ($S -notmatch '(?im)FileSystemAclExtensions\]::CreateDirectory' -or $S -notmatch '(?im)SetOwner\(\$ownerSid\)' -or $S -notmatch '(?im)SetAccessRuleProtection\(\$true,\s*\$false\)') { throw 'SECRET_HELPER_OWNER_ACL_GUARD_MISSING' }
    if ($S -notmatch '(?im)Get-PatternFileCount' -or $S -notmatch '(?im)CLASH_REAL_AUTH_RESIDUE=' -or $S -notmatch '(?im)PROJECT_RUNTIME_REAL_AUTH_RESIDUE=') { throw 'SECRET_RESIDUE_SCAN_MISSING' }
    $scanner = [regex]::Match($S, '(?is)function\s+Get-PatternFileCount\s*\{(?<body>.*?)\r?\n\}\s*(?=function\s+Read-ExactBytes)')
    if (-not $scanner.Success) { throw 'SECRET_SCAN_ROOT_LOCK_EXCEPTION_CONTRACT_INVALID' }
    $scannerBody = $scanner.Groups['body'].Value
    foreach ($requiredScannerGuard in @(
        '\[switch\]\$AllowUnreadableZeroLengthRootLock',
        '\$rootFull\s*=\s*\[IO\.Path\]::GetFullPath\(\$Root\)\.TrimEnd',
        'Get-Item\s+-LiteralPath\s+\$item\.FullName\s+-Force\s+-ErrorAction\s+Stop',
        '\$freshParent\s*=\s*\[IO\.Path\]::GetFullPath',
        '\$isRootLevel\s*=\s*\$freshParent\.Equals\(\$rootFull,\s*\[StringComparison\]::OrdinalIgnoreCase\)',
        '\$isLock\s*=\s*\$freshItem\.Extension\s+-ieq\s+''\.lock''',
        '\$isZeroLength\s*=\s*\[long\]\$freshItem\.Length\s+-eq\s+0',
        '\$isFile\s*=\s*-not\s+\$freshItem\.PSIsContainer',
        '\$isReparse\s*=\s*\(\(\$freshItem\.Attributes\s+-band\s+\[IO\.FileAttributes\]::ReparsePoint\)\s+-ne\s+0\)',
        '\$isRootLevel\s+-and\s+\$isLock\s+-and\s+\$isZeroLength\s+-and\s+\$isFile\s+-and\s+-not\s+\$isReparse\)\s*\{\s*continue'
    )) {
        if ($scannerBody -notmatch "(?is)$requiredScannerGuard") {
            throw 'SECRET_SCAN_ROOT_LOCK_EXCEPTION_CONTRACT_INVALID'
        }
    }

    $clashOptIn = 'Get-PatternFileCount\s+-Root\s+\$clashAppRoot\s+-Pattern\s+\$authBytes\s+-AllowUnreadableZeroLengthRootLock'
    if (([regex]::Matches($S, $clashOptIn, [Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count -ne 2) {
        throw 'SECRET_SCAN_CLASH_ONLY_OPT_IN_INVALID'
    }
    if ($S -match '(?im)Get-PatternFileCount\s+-Root\s+\$runtimeRoot[^\r\n]*AllowUnreadableZeroLengthRootLock') {
        throw 'SECRET_SCAN_RUNTIME_EXCEPTION_FORBIDDEN'
    }
    if ($S -match '(?im)\bcurl(?:\.exe)?\b|Invoke-WebRequest|Invoke-RestMethod|HttpClient|WebClient|api\.openai\.com|api\.ipify\.org') { throw 'SECRET_HELPER_NETWORK_CAPABILITY_FORBIDDEN' }
    if ($S -match '(?im)Write-(?:Output|Host)[^\r\n]*(?:authBytes|hy2-auth|bundleBytes|protectedBytes)') { throw 'SECRET_HELPER_SECRET_OUTPUT_FORBIDDEN' }
    if ($S -notmatch '(?im)CryptographicOperations\]::ZeroMemory') { throw 'SECRET_ZEROIZATION_MISSING' }

    if ($P -match '(?im)\bProtectedData\b|::Unprotect\s*\(|hy2-auth|hy2-g2a\.dpapi|C2C_REAL_HY2_AUTH_INJECTION_ONLY') { throw 'PROBE_SECRET_ACCESS_FORBIDDEN' }
    if (([regex]::Matches($P, 'https://api\.openai\.com/v1/models')).Count -ne 1 -or ([regex]::Matches($P, 'https://api\.ipify\.org')).Count -ne 1) { throw 'PROBE_ENDPOINT_CARDINALITY_INVALID' }
    if (([regex]::Matches($P, 'socks5h://127\.0\.0\.1:\$ProxyPort')).Count -ne 2 -or
        $P -match 'http://127\.0\.0\.1:\$ProxyPort') {
        throw 'PROBE_PROXY_SCHEME_INVALID'
    }
    if ($P -notmatch '(?im)REAL_CANARY_REQUEST_COUNT=2' -or $P -notmatch '(?im)C2C_OPENAI_HTTP_STATUS=401' -or $P -notmatch '(?im)C2C_OPENAI_PROXY_USED=1' -or $P -notmatch '(?im)C2C_PUBLIC_EXIT=EXPECTED_SFO3') { throw 'PROBE_ACCEPTANCE_MARKERS_MISSING' }

    if (([regex]::Matches($T, '__C2C_REAL_HY2_AUTH_INJECTION_ONLY__')).Count -ne 1) { throw 'TEMPLATE_SECRET_PLACEHOLDER_INVALID' }
    if ($T -notmatch '(?ms)proxies:\s*.*?- name:\s*WG-BASELINE\s*\r?\n\s*type:\s*direct' -or $T -notmatch '(?ms)- name:\s*HY2-SFO3-REAL\s*\r?\n\s*type:\s*hysteria2' -or $T -notmatch '(?m)^\s+server:\s*24\.199\.118\.137\s*$' -or $T -notmatch '(?m)^\s+port:\s*8443\s*$' -or $T -notmatch '(?m)^\s+sni:\s*hy2\.sfo3-a\.invalid\s*$' -or $T -notmatch '(?m)^\s+skip-cert-verify:\s*true\s*$') { throw 'TEMPLATE_REAL_HY2_TARGET_INVALID' }
    if ($T -notmatch '(?m)^\s+fingerprint:\s*8A:8D:50:5F:DF:80:DB:76:C6:76:39:5A:86:E4:9D:81:8E:A1:5B:76:64:ED:70:30:8C:29:60:9C:23:74:1F:18\s*$') { throw 'TEMPLATE_FINGERPRINT_INVALID' }
    if ($T -notmatch '(?ms)- name:\s*SELF-VPN-C2C\s*\r?\n\s*type:\s*select\s*\r?\n\s*proxies:\s*\r?\n\s*- WG-BASELINE\s*\r?\n\s*- HY2-SFO3-REAL') { throw 'TEMPLATE_MANUAL_SELECTOR_INVALID' }

    if ($D -notmatch '(?i)not a performance benchmark' -or $D -notmatch '(?i)system proxy.*OFF' -or $D -notmatch '(?i)TUN.*OFF' -or $D -notmatch '(?i)two.*real.*request' -or $D -notmatch '(?i)SOCKS5') { throw 'PACKAGE_BOUNDARY_UNDOCUMENTED' }
    foreach ($requiredDocContract in @(
        '(?i)zero-byte',
        '(?i)root-level',
        '(?i)\.lock',
        '(?i)actual read (?:failure|exception)',
        '(?i)project runtime.*strict',
        '(?i)reparse'
    )) {
        if ($D -notmatch $requiredDocContract) {
            throw 'PACKAGE_SECRET_SCAN_EXCEPTION_UNDOCUMENTED'
        }
    }
    return $true
}

function Assert-ExpectedFailure {
    param([string]$Expected,[string]$O,[string]$S,[string]$P,[string]$T,[string]$D)
    try {
        [void](Test-C2CPackage -O $O -S $S -P $P -T $T -D $D)
        throw 'EXPECTED_FAILURE_DID_NOT_OCCUR'
    }
    catch {
        if ([string]$_.Exception.Message -ne $Expected) { throw }
    }
}

[void](Test-C2CPackage -O $orchestrator -S $secretHelper -P $probe -T $template -D $package)
Write-Output 'G3C_C2C_FIXTURE_A_BASELINE_PACKAGE=PASS'

Assert-ExpectedFailure -Expected 'ORCHESTRATOR_SECRET_ACCESS_FORBIDDEN' -O ($orchestrator + [Environment]::NewLine + '$x=[Security.Cryptography.ProtectedData]::Unprotect($a,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)') -S $secretHelper -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_B_SECRET_NETWORK_SEPARATION=PASS'

Assert-ExpectedFailure -Expected 'SECRET_HELPER_NETWORK_CAPABILITY_FORBIDDEN' -O $orchestrator -S ($secretHelper + [Environment]::NewLine + 'curl.exe https://api.openai.com/v1/models') -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_C_SECRET_HELPER_NO_NETWORK=PASS'

Assert-ExpectedFailure -Expected 'PROBE_SECRET_ACCESS_FORBIDDEN' -O $orchestrator -S $secretHelper -P ($probe + [Environment]::NewLine + '$x="hy2-g2a.dpapi"') -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_D_PROBE_NO_SECRET=PASS'

Assert-ExpectedFailure -Expected 'PRODUCTION_NETWORK_MUTATION_FORBIDDEN' -O ($orchestrator + [Environment]::NewLine + 'Set-ItemProperty ProxyEnable 1') -S $secretHelper -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_E_NO_SYSTEM_PROXY_TUN_WG_MUTATION=PASS'

$withoutCleanupAck = $orchestrator.Replace('C2C_CLEANUP_ACK|CURRENT_BEFORE_REMOVE=WG-BASELINE|PROFILE_REMOVED=YES|SYSTEM_PROXY=OFF|TUN=OFF','C2C_CLEANUP_ACK_REMOVED')
Assert-ExpectedFailure -Expected 'STRUCTURED_UI_ACK_CONTRACT_MISSING' -O $withoutCleanupAck -S $secretHelper -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_F_STRUCTURED_CLEANUP_REQUIRED=PASS'

$badTemplate = $template.Replace('__C2C_REAL_HY2_AUTH_INJECTION_ONLY__', ('a' * 64))
Assert-ExpectedFailure -Expected 'TEMPLATE_SECRET_PLACEHOLDER_INVALID' -O $orchestrator -S $secretHelper -P $probe -T $badTemplate -D $package
Write-Output 'G3C_C2C_FIXTURE_G_TEMPLATE_NO_REAL_SECRET=PASS'

Assert-ExpectedFailure -Expected 'STALE_PROXY_METADATA_DEPENDENCY_FORBIDDEN' -O ($orchestrator + [Environment]::NewLine + '$x=$internet.ProxyServer') -S $secretHelper -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_H_STALE_PROXY_METADATA_REJECTED=PASS'

$httpProbe = $probe.Replace('socks5h://127.0.0.1:$ProxyPort','http://127.0.0.1:$ProxyPort')
Assert-ExpectedFailure -Expected 'PROBE_PROXY_SCHEME_INVALID' -O $orchestrator -S $secretHelper -P $httpProbe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_I_SOCKS5_SCHEME_REQUIRED=PASS'

$resolverWithDiagnostic = $orchestrator.Replace(
    '    return [int]$socksPorts[0]',
    "    Write-Output 'RESOLVER_DIAGNOSTIC'`r`n    return [int]`$socksPorts[0]"
)
Assert-ExpectedFailure -Expected 'PROXY_RESOLVER_SUCCESS_STREAM_DIAGNOSTIC_FORBIDDEN' -O $resolverWithDiagnostic -S $secretHelper -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_J_RESOLVER_SUCCESS_STREAM_SCALAR_RETURN=PASS'

$callerInvisibleForwarding = [regex]::Replace(
    $orchestrator,
    '(?im)^[ \t]*Write-ApprovedSecretHelperEvidence\s+-Output\s+\$(?:prepareOutput|cleanupOutput|fallbackOutput)\s+-Mode\s+(?:Prepare|VerifyCleanup)[ \t]*\r?\n',
    ''
)
$callerInvisibleForwarding = $callerInvisibleForwarding.Replace(
    '    Assert-C2C ($exitCode -eq 0)',
    '    foreach ($line in $output) { Write-Output $line }' + [Environment]::NewLine + '    Assert-C2C ($exitCode -eq 0)'
)
Assert-ExpectedFailure -Expected 'SECRET_HELPER_EVIDENCE_FORWARDING_CONTRACT_INVALID' -O $callerInvisibleForwarding -S $secretHelper -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_K_CALLER_VISIBLE_HELPER_EVIDENCE_REQUIRED=PASS'

$broadZeroLengthSkip = $secretHelper.Replace(
    '$isZeroLength = [long]$freshItem.Length -eq 0',
    '$isZeroLength = $true'
)
Assert-ExpectedFailure -Expected 'SECRET_SCAN_ROOT_LOCK_EXCEPTION_CONTRACT_INVALID' -O $orchestrator -S $broadZeroLengthSkip -P $probe -T $template -D $package

$descendantSkip = $secretHelper.Replace(
    '$isRootLevel = $freshParent.Equals($rootFull, [StringComparison]::OrdinalIgnoreCase)',
    '$isRootLevel = $true'
)
Assert-ExpectedFailure -Expected 'SECRET_SCAN_ROOT_LOCK_EXCEPTION_CONTRACT_INVALID' -O $orchestrator -S $descendantSkip -P $probe -T $template -D $package

$anyExtensionSkip = $secretHelper.Replace(
    '$isLock = $freshItem.Extension -ieq ''.lock''',
    '$isLock = $true'
)
Assert-ExpectedFailure -Expected 'SECRET_SCAN_ROOT_LOCK_EXCEPTION_CONTRACT_INVALID' -O $orchestrator -S $anyExtensionSkip -P $probe -T $template -D $package

$reparseSkip = $secretHelper.Replace(
    '$isReparse = (($freshItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)',
    '$isReparse = $false'
)
Assert-ExpectedFailure -Expected 'SECRET_SCAN_ROOT_LOCK_EXCEPTION_CONTRACT_INVALID' -O $orchestrator -S $reparseSkip -P $probe -T $template -D $package

$runtimeOptIn = $secretHelper.Replace(
    'Get-PatternFileCount -Root $runtimeRoot -Pattern $authBytes',
    'Get-PatternFileCount -Root $runtimeRoot -Pattern $authBytes -AllowUnreadableZeroLengthRootLock'
)
Assert-ExpectedFailure -Expected 'SECRET_SCAN_RUNTIME_EXCEPTION_FORBIDDEN' -O $orchestrator -S $runtimeOptIn -P $probe -T $template -D $package
Write-Output 'G3C_C2C_FIXTURE_L_ZERO_LENGTH_ROOT_LOCK_EXCEPTION_BOUNDED=PASS'

foreach ($path in @($orchestratorPath,$secretHelperPath,$probePath)) {
    $tokens = $null
    $errors = $null
    $null = [Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
    if ($errors.Count -ne 0) { throw 'POWERSHELL_AST_PARSE_FAILED' }
}
Write-Output 'POWERSHELL_AST_PARSE=PASS'

if (-not (Test-Path -LiteralPath $mihomoPath -PathType Leaf)) { throw 'MIHOMO_BINARY_MISSING' }
$version = @(& $mihomoPath -v 2>&1)
if ($LASTEXITCODE -ne 0 -or ($version -join ' ') -notmatch '\bv1\.19\.32\b') { throw 'MIHOMO_VERSION_MISMATCH' }

$tempRoot = Join-Path $env:TEMP ('c2c-validator-' + [Guid]::NewGuid().ToString('N'))
$tempConfig = Join-Path $tempRoot 'fixture.yaml'
try {
    [void][IO.Directory]::CreateDirectory($tempRoot)
    $fixture = $template.Replace('__C2C_REAL_HY2_AUTH_INJECTION_ONLY__', ('a' * 64))
    [IO.File]::WriteAllText($tempConfig, $fixture, [Text.UTF8Encoding]::new($false))
    $null = @(& $mihomoPath -t -f $tempConfig 2>&1)
    if ($LASTEXITCODE -ne 0) { throw 'MIHOMO_FIXTURE_PARSE_FAILED' }
    Write-Output 'MIHOMO_FIXTURE_PARSE=PASS'
}
finally {
    if (Test-Path -LiteralPath $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue }
}

Write-Output 'G3C_C2C_OFFLINE_FIXTURES=PASS'
Write-Output 'DPAPI_UNPROTECT=NO'
Write-Output 'NETWORK_REQUESTS=0'
Write-Output 'NETWORK_CHANGED=NO'
Write-Output 'SECRET_VALUES_EMITTED=0'
