#Requires -Version 7.0
[CmdletBinding()]
param(
    [string]$Frontend = 'http://127.0.0.1:3000',
    [string]$Backend = 'http://127.0.0.1:3001'
)

$ErrorActionPreference = 'Stop'

function ConvertTo-StableValue($Value) {
    if ($Value -is [System.Collections.IDictionary]) {
        $result = [ordered]@{}
        foreach ($key in ($Value.Keys | Sort-Object)) {
            if ($key -match '^request[_-]?id$') { continue }
            $result[$key] = ConvertTo-StableValue $Value[$key]
        }
        return $result
    }
    if ($Value -is [array]) {
        $items = [System.Collections.Generic.List[object]]::new()
        foreach ($item in $Value) { $items.Add((ConvertTo-StableValue $item)) }
        return ,$items.ToArray()
    }
    if ($Value -is [string]) {
        return [regex]::Replace($Value, '(?i)\s*\(request id:\s*[^)]+\)', '')
    }
    return $Value
}

function Get-ResponseSummary([string]$BaseUrl, [string]$Method, [string]$Path) {
    $request = [System.Net.Http.HttpRequestMessage]::new(
        [System.Net.Http.HttpMethod]::new($Method),
        $BaseUrl.TrimEnd('/') + $Path
    )
    $response = $null
    try {
        if ($Method -eq 'POST') {
            $request.Content = [System.Net.Http.StringContent]::new(
                '{}', [System.Text.Encoding]::UTF8, 'application/json'
            )
        }
        $response = $client.SendAsync($request).GetAwaiter().GetResult()
        $body = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        $contentType = ''
        if ($response.Content.Headers.ContentType) {
            $contentType = ($response.Content.Headers.ContentType.ToString().ToLowerInvariant() -replace '\s', '')
        }
        if ($contentType -match 'json') {
            $parsed = ConvertFrom-Json -InputObject $body -AsHashtable -Depth 64
            $normalized = ConvertTo-StableValue $parsed
            $body = ConvertTo-Json -InputObject $normalized -Depth 64 -Compress
        } else {
            $body = $body.Trim()
        }
        $sha = [System.Security.Cryptography.SHA256]::Create()
        try {
            $digest = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($body))
            $hash = [System.BitConverter]::ToString($digest).Replace('-', '').ToLowerInvariant()
        } finally { $sha.Dispose() }
        return [ordered]@{
            status = [int]$response.StatusCode
            contentType = $contentType
            bodySha256 = $hash
        }
    } finally {
        if ($response) { $response.Dispose() }
        $request.Dispose()
    }
}

$cases = @(
    @{ method = 'GET'; path = '/api/status' }
    @{ method = 'GET'; path = '/api/setup' }
    @{ method = 'GET'; path = '/api/user/self' }
    @{ method = 'GET'; path = '/v1/models' }
    @{ method = 'POST'; path = '/v1/chat/completions' }
    @{ method = 'POST'; path = '/v1/responses' }
    @{ method = 'POST'; path = '/v1beta/models/spw-verification:generateContent' }
    @{ method = 'POST'; path = '/mj/submit/imagine' }
    @{ method = 'POST'; path = '/spw-verification/mj/submit/imagine' }
    @{ method = 'POST'; path = '/pg/chat/completions' }
    @{ method = 'POST'; path = '/kling/v1/videos/text2video'; rejectFrontendIndex = $true }
    @{ method = 'POST'; path = '/keys'; rejectFrontendIndex = $true }
    @{ method = 'POST'; path = '/pricing'; rejectFrontendIndex = $true }
)

$handler = [System.Net.Http.HttpClientHandler]::new()
$handler.AllowAutoRedirect = $false
$handler.UseCookies = $false
$client = [System.Net.Http.HttpClient]::new($handler)
$client.Timeout = [TimeSpan]::FromSeconds(15)
$results = [System.Collections.Generic.List[object]]::new()
$index = $null
$startupError = $null
try {
    try { $index = Get-ResponseSummary $Frontend 'GET' '/' }
    catch { $startupError = $_.Exception.Message }

    foreach ($case in $cases) {
        $entry = [ordered]@{ method = $case.method; path = $case.path; passed = $false }
        try {
            $direct = Get-ResponseSummary $Backend $case.method $case.path
            $proxied = Get-ResponseSummary $Frontend $case.method $case.path
            $differences = [System.Collections.Generic.List[string]]::new()
            foreach ($field in @('status', 'contentType', 'bodySha256')) {
                if ($direct[$field] -cne $proxied[$field]) { $differences.Add($field) }
            }
            if ($case.rejectFrontendIndex) {
                if (-not $index) { $differences.Add('frontend-index-unavailable') }
                elseif ($proxied.bodySha256 -eq $index.bodySha256) {
                    $differences.Add('unexpected-frontend-index')
                }
            }
            $entry.backend = $direct
            $entry.frontend = $proxied
            $entry.differences = $differences.ToArray()
            $entry.passed = $differences.Count -eq 0
        } catch {
            $entry.error = $_.Exception.Message
        }
        $results.Add($entry)
        $label = if ($entry.passed) { 'PASS' } else { 'FAIL' }
        Write-Host "$label $($case.method) $($case.path)"
    }
} finally {
    $client.Dispose()
}

$failed = @($results | Where-Object { -not $_.passed }).Count
$report = [ordered]@{
    verifiedAtUtc = [DateTime]::UtcNow.ToString('o')
    frontend = $Frontend
    backend = $Backend
    mode = 'Anonymous requests only; POST bodies are empty JSON; redirects and cookies disabled'
    comparison = 'Status, complete content type, normalized JSON or exact trimmed body SHA-256; request IDs removed'
    frontendIndex = $index
    startupError = $startupError
    passed = $failed -eq 0
    total = $results.Count
    failed = $failed
    cases = $results.ToArray()
}
$reportDirectory = Join-Path $PSScriptRoot 'verification'
New-Item -ItemType Directory -Force -Path $reportDirectory | Out-Null
$reportPath = Join-Path $reportDirectory 'proxy-report.json'
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $reportPath -Encoding utf8
Write-Host "$($results.Count - $failed)/$($results.Count) passed. Report: $reportPath"
if ($failed) { exit 1 }
exit 0
