$ErrorActionPreference = 'Continue'
Set-Location (Split-Path $PSScriptRoot -Parent)
$report = 'acceptance/G1_RUNTIME_READBACK.txt'
'' | Set-Content $report
$fail = 0

function Log-Line([string]$line) {
  $line | Tee-Object -FilePath $report -Append
}

function Run-WpCheck([string]$name, [string[]]$args) {
  $output = & docker compose -f docker-compose.local.yml --profile tools run --rm wpcli @args 2>&1
  if ($LASTEXITCODE -eq 0) {
    Log-Line "PASS $name $($output -join ' ')"
  } else {
    Log-Line "FAIL $name $($output -join ' ')"
    $script:fail++
  }
}

Run-WpCheck 'wordpress_version' @('core','version')
Run-WpCheck 'parent_theme_version' @('theme','get','saaslauncher','--field=version')
Run-WpCheck 'child_theme_active' @('theme','status','conversion-leak-audit-child','--status=active')
foreach ($slug in @('home','how-it-works','demo','pricing','faq','blog')) {
  Run-WpCheck "page_$slug" @('post','list','--post_type=page',"--name=$slug",'--post_status=publish','--field=ID')
}
Run-WpCheck 'home_front_page' @('eval','echo get_option("show_on_front").":".get_option("page_on_front");')

$port = if ($env:WP_PORT) { $env:WP_PORT } else { '8080' }
try {
  $html = (Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:$port/" -TimeoutSec 15).Content
  Log-Line 'PASS home_http'
} catch {
  Log-Line "FAIL home_http $($_.Exception.Message)"
  $fail++
  $html = ''
}

if ($html -match 'data-cla-g1-placeholder="true"' -and $html -match 'aria-disabled="true"') {
  Log-Line 'PASS placeholder_rendered_disabled'
} else {
  Log-Line 'FAIL placeholder_rendered_disabled'
  $fail++
}

if ($html -match 'scanner.{0,20}(connected|running)' -or $html -match 'checkout.{0,20}(pay|purchase)') {
  Log-Line 'FAIL no_scanner_or_payment_activation'
  $fail++
} else {
  Log-Line 'PASS no_scanner_or_payment_activation'
}

if ($fail -eq 0) {
  Log-Line 'PASS_CANDIDATE_G1_WORDPRESS_LOCAL_BASELINE'
  exit 0
}
Log-Line "RETURN_G1_RUNTIME_READBACK_FAILED count=$fail"
exit 1
