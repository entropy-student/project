[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = $PSScriptRoot
$source = Get-Content -LiteralPath (Join-Path $scriptRoot 'g4b-baidu-cookie-auth-adapter\main.go') -Raw
$testSource = Get-Content -LiteralPath (Join-Path $scriptRoot 'g4b-baidu-cookie-auth-adapter\main_test.go') -Raw
$build = Get-Content -LiteralPath (Join-Path $scriptRoot 'build-g4b-baidu-cookie-auth-adapter.ps1') -Raw
$owner = Get-Content -LiteralPath (Join-Path $scriptRoot 'g4b-baidu-cookie-auth-owner-checkpoint.ps1') -Raw
$aclPath = Join-Path $scriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
$upstreamCommit = '225bdd3b6cb298601c4d5ef7104c3e08cd1d692d'
$aclHelperSha256 = 'AA28611D5C540F208A0DB40C0ED7D19E18B12180DE8437CCB54EA5A755D7F08F'
$allFiles = @(
    (Join-Path $scriptRoot 'g4b-baidu-cookie-auth-adapter\main.go'),
    (Join-Path $scriptRoot 'g4b-baidu-cookie-auth-adapter\main_test.go'),
    (Join-Path $scriptRoot 'build-g4b-baidu-cookie-auth-adapter.ps1'),
    (Join-Path $scriptRoot 'g4b-baidu-cookie-auth-owner-checkpoint.ps1'),
    (Join-Path $scriptRoot 'validate-g4b-baidu-cookie-auth-adapter.ps1')
)

function Assert-Validation {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
    Write-Output ($Code + '=PASS')
}

try {
    $powershellFiles = @(
        (Join-Path $scriptRoot 'build-g4b-baidu-cookie-auth-adapter.ps1'),
        (Join-Path $scriptRoot 'g4b-baidu-cookie-auth-owner-checkpoint.ps1'),
        (Join-Path $scriptRoot 'validate-g4b-baidu-cookie-auth-adapter.ps1')
    )
    $astPass = $true
    foreach ($path in $powershellFiles) {
        $tokens = $null
        $parseErrors = $null
        [void][Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$parseErrors)
        if ($parseErrors.Count -ne 0) { $astPass = $false }
    }
    Assert-Validation $astPass 'POWERSHELL_AST_PARSE'

    Assert-Validation ($source.Contains('terminal.ReadPassword(int(os.Stdin.Fd()))') -and $source.Contains('terminal.IsTerminal(int(os.Stdin.Fd()))') -and -not $source.Contains('liner.')) 'R6R2H_SECRET_INPUT_NO_ECHO'
    Assert-Validation ($source.Contains('len(os.Args) != 1') -and -not $source.Contains('os.Args[') -and -not $owner.Contains('ArgumentList.Add')) 'R6R2H_SECRET_NOT_IN_ARGS'
    Assert-Validation ($owner.Contains('$startInfo.Environment.Clear()') -and $owner.Contains('$startInfo.Environment[''BAIDUPCS_GO_CONFIG_DIR''] = $configPath') -and -not $owner.Contains('cookie')) 'R6R2H_SECRET_NOT_IN_ENV'
    Assert-Validation (-not $source.Contains('liner.') -and -not $source.Contains('Read-Host') -and -not $source.Contains('history')) 'R6R2H_SECRET_NOT_IN_COMMAND_HISTORY'
    Assert-Validation ($source.Contains('os.Stdout, os.Stderr = sink, sink') -and $source.Contains('log.SetOutput(io.Discard)') -and $source.Contains('pcsverbose.Outputs = []io.Writer{io.Discard}') -and -not $source.Contains('err.Error()')) 'R6R2H_SECRET_NOT_LOGGED_OR_PRINTED'
    Assert-Validation (-not $source.Contains('Sum(') -and -not $source.Contains('sha256') -and -not $source.Contains('Hash(')) 'R6R2H_SECRET_NOT_HASHED_FOR_EVIDENCE'
    Assert-Validation (-not $source.Contains('-cookies') -and -not $source.Contains('-bduss') -and -not $source.Contains('-username') -and -not $source.Contains('-password') -and -not $owner.Contains('ArgumentList.Add')) 'R6R2H_STOCK_COOKIE_CLI_ARGS_FORBIDDEN'
    Assert-Validation (-not $owner.Contains('login') -and $source.Contains('SetupUserByBDUSS')) 'R6R2H_USERNAME_PASSWORD_ROUTE_RETIRED'
    Assert-Validation ($source.Contains('len(cookie) == 0') -and $testSource.Contains('{}')) 'R6R2H_COOKIE_EMPTY_REJECTED'
    Assert-Validation ($source.Contains('bytes.ContainsAny(cookie, "\r\n")') -and $testSource.Contains('\r\n')) 'R6R2H_COOKIE_CRLF_REJECTED'
    Assert-Validation ($source.Contains('bytes.HasPrefix(field, []byte("BDUSS="))') -and $source.Contains('return count == 1')) 'R6R2H_COOKIE_BDUSS_SHAPE_VALIDATED'
    Assert-Validation ($source.Contains('pcsconfig.Config.SetupUserByBDUSS("", "", "", cookie)')) 'R6R2H_SETUPUSERBYBDUSS_DIRECT_PATH'
    Assert-Validation (-not $source.Contains('.UID') -and -not $source.Contains('.Name') -and $source.Contains('BAIDU_COOKIE_AUTH_UID_EMITTED=NO')) 'R6R2H_ACCOUNT_NAME_UID_NOT_EMITTED'
    Assert-Validation ($source.Contains('os.Exit(run())') -and $source.Contains('return 2')) 'R6R2H_FAILURE_NATIVE_EXIT_NONZERO'
    $setupIndex = $source.IndexOf('pcsconfig.Config.SetupUserByBDUSS("", "", "", cookie)', [StringComparison]::Ordinal)
    $saveIndex = $source.IndexOf('pcsconfig.Config.Save()', [StringComparison]::Ordinal)
    $initIndex = $source.IndexOf('pcsconfig.Config.Init()', [StringComparison]::Ordinal)
    Assert-Validation ($setupIndex -ge 0 -and $saveIndex -gt $setupIndex -and $initIndex -lt 0 -and $source.Contains('pcsconfig.Config.InitDefaultConfig()')) 'R6R2H_CONFIG_SAVE_ONLY_AFTER_SETUP_SUCCESS'

    Assert-Validation ($build.Contains($upstreamCommit) -and $build.Contains('0d07b9b27b989319a65c3c8979d896e02cabc340') -and $build.Contains('ac5ace05fc860bc3f47fdaf9ddec126d06890630') -and $build.Contains('8865962ac126053632beee750310b099e6b89e1d') -and $build.Contains('2ab8f56647d70a903786db351c57308ee8bee69d') -and $build.Contains('edefc8e422dc15938668935de06c4da34c377cbe') -and $build.Contains('GOOS = ''windows''') -and $build.Contains('GOARCH = ''amd64''') -and $build.Contains('-mod=readonly')) 'R6R2H_PINNED_UPSTREAM_SOURCE'
    Assert-Validation ($build.Contains('Remove-Item -LiteralPath $resolvedTempRoot -Recurse -Force') -and $build.Contains('TEMP_BUILD_CLEANUP=PASS') -and $build.Contains('finally')) 'R6R2H_TEMP_BUILD_CLEANUP'
    Assert-Validation ($build.Contains('[switch]$RetainBinary') -and $build.Contains('[IO.FileMode]::CreateNew') -and $build.Contains('Set-OwnerOnlyAcl') -and $owner.Contains('5c6ad2fdbcb9bee1b3b2fdc789b07e061bd89cc64350c750298b682b717e7955')) 'R6R2H_BUILD_BINARY_HASH_PIN'
    Assert-Validation ((Get-FileHash -LiteralPath $aclPath -Algorithm SHA256).Hash -ceq $aclHelperSha256 -and $owner.Contains('. $aclHelper') -and $owner.Contains('Assert-SafeBaiduConfigDirectory') -and $owner.Contains('New-OwnerOnlyAcl') -and $owner.Contains('Assert-OwnerOnlyAcl')) 'R6R2H_EXISTING_R6R1_ACL_BOUNDARY_REUSED'
    Assert-Validation ($owner.Contains("Join-Path `$env:APPDATA 'BaiduPCS-Go'") -and $owner.Contains('$process.WaitForExit()') -and -not $owner.Contains('RedirectStandardInput = $true') -and -not $owner.Contains('RedirectStandardOutput = $true') -and -not $owner.Contains('RedirectStandardError = $true')) 'R6R2H_OWNER_CONSOLE_AND_CONFIG_BOUNDARY'

    $secretPatterns = @(
        '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----',
        '(?i)(?:password|cookie|bduss|stoken|ptoken|api[_-]?key)\s*[:=]\s*["'']?[A-Za-z0-9_./+=-]{24,}',
        '(?i)eyJ[A-Za-z0-9_-]{24,}\.[A-Za-z0-9_-]{12,}\.[A-Za-z0-9_-]{12,}'
    )
    $secretScanPass = $true
    foreach ($file in $allFiles) {
        $text = Get-Content -LiteralPath $file -Raw
        foreach ($pattern in $secretPatterns) {
            if ([regex]::IsMatch($text, $pattern)) { $secretScanPass = $false }
        }
    }
    Assert-Validation $secretScanPass 'SECRET_SCAN'

    Write-Output 'GO_SOURCE_STATIC_VALIDATION=PASS'
    Write-Output 'SECRET_SCAN=PASS'
    Write-Output 'REAL_COOKIE_VALUES_USED=0'
    Write-Output 'REAL_BAIDU_AUTH_ACTIONS=0'
    Write-Output 'OWNER_CONFIG_READ=NO'
    Write-Output 'OWNER_CONFIG_WRITE=NO'
    Write-Output 'STOP_AT_REVIEWER=YES'
} catch {
    Write-Output 'VALIDATION=RETURN'
    if ($_.Exception.Message -match '^[A-Z0-9_]+$') {
        Write-Output ('FAILURE_CODE=' + $_.Exception.Message)
    } else {
        Write-Output 'FAILURE_CODE=STATIC_VALIDATION_FAILED'
    }
    exit 1
}
