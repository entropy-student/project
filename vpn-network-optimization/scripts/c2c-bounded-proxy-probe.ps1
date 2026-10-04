[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidateRange(1024,65535)][int]$ProxyPort
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$openAiEndpoint = 'https://api.openai.com/v1/models'
$exitEndpoint = 'https://api.ipify.org'
$expectedExit = '24.199.118.137'
$curl = (Get-Command curl.exe -ErrorAction Stop).Source

$writeOut = '%{http_code}|%{time_total}|%{time_connect}|%{time_appconnect}|%{proxy_used}'
$output = & $curl -sS -o NUL --connect-timeout 10 --max-time 20 --noproxy '' --proxy "socks5h://127.0.0.1:$ProxyPort" -w $writeOut $openAiEndpoint 2>$null
$curlExit = $LASTEXITCODE
$parts = ([string]$output).Trim().Split('|')

if ($parts.Count -ne 5) { throw 'C2C_OPENAI_RESULT_SHAPE_INVALID' }
if ($curlExit -ne 0) { throw 'C2C_OPENAI_CURL_FAILED' }
if ($parts[0] -cne '401') { throw 'C2C_OPENAI_HTTP_STATUS_INVALID' }
if ($parts[4] -cne '1') { throw 'C2C_OPENAI_PROXY_NOT_USED' }

Write-Output 'C2C_OPENAI_CURL_EXIT=0'
Write-Output 'C2C_OPENAI_HTTP_STATUS=401'
Write-Output 'C2C_OPENAI_PROXY_USED=1'
Write-Output ('C2C_OPENAI_TIME_TOTAL=' + $parts[1])
Write-Output ('C2C_OPENAI_TIME_CONNECT=' + $parts[2])
Write-Output ('C2C_OPENAI_TIME_APPCONNECT=' + $parts[3])

$exitValue = & $curl -fsS --connect-timeout 10 --max-time 20 --noproxy '' --proxy "socks5h://127.0.0.1:$ProxyPort" $exitEndpoint 2>$null
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) { throw 'C2C_EXIT_QUERY_FAILED' }
if (([string]$exitValue).Trim() -cne $expectedExit) { throw 'C2C_EXIT_IP_MISMATCH' }

Write-Output 'C2C_PUBLIC_EXIT=EXPECTED_SFO3'
Write-Output 'REAL_CANARY_REQUEST_COUNT=2'
Write-Output 'C2C_BOUNDED_PROXY_PROBE=PASS'
