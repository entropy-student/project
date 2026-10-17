#requires -Version 7.0
# Paymenter disposable preview. Only the dedicated Windows user folder is owned.
param([int]$Port = 8187)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$projectName = 'paymenter_local_lab'
$email = 'demo-admin@paymenter.local'
$root = Join-Path $env:USERPROFILE 'Documents\ChatGPT\Paymenter-Local-Lab'
$manifest = Join-Path $root 'docker-compose.yml'
$marker = Join-Path $root '.paymenter-preview-owned'
$sourceCommit = '1d4c0b92dac0f93f28998b04c4c0e282bf436177'
$url = 'http://127.0.0.1:' + $Port
function Check-Docker([string]$step) {
    if ($LASTEXITCODE -ne 0) { throw "Docker failed at $step (exit=$LASTEXITCODE)" }
}
function RandomHex([int]$n) {
    return [Convert]::ToHexString([System.Security.Cryptography.RandomNumberGenerator]::GetBytes($n))
}
Write-Host '[P0] Checking real Windows Docker target ...'
if (-not $IsWindows) { throw 'Only run on Owner real Windows PC.' }
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw 'Start Docker Desktop before running.' }
& docker info --format '{{.ServerVersion}}' | Out-Null
Check-Docker 'engine preflight'
& docker compose version | Out-Null
Check-Docker 'compose preflight'
if (Test-Path $root) {
    if (@(Get-ChildItem $root -Force).Count -gt 0 -and -not (Test-Path $marker)) {
        throw "Unowned nonempty directory: $root"
    }
}
if (-not (Test-Path $manifest)) {
    if (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue) {
        throw "Port $Port already in use: choose a free port with -Port N."
    }
    Write-Host '[P1] Preparing project-isolated Compose ...'
    New-Item -Path $root -ItemType Directory -Force | Out-Null
    $raw = "https://raw.githubusercontent.com/Paymenter/Paymenter/$sourceCommit/docker-compose.example.yml"
    $yaml = (Invoke-WebRequest -Uri $raw -TimeoutSec 40 -ErrorAction Stop).Content
    if (-not $yaml.Contains('MYSQL_PASSWORD: &db-password "CHANGE_ME"') -or
        -not $yaml.Contains('MYSQL_ROOT_PASSWORD: "CHANGE_ME_TOO"') -or
        -not $yaml.Contains('      - "80:80"') -or
        -not $yaml.Contains('      - "./database:/var/lib/mysql"') -or
        -not $yaml.Contains('APP_ENV: "production"') -or
        -not [regex]::IsMatch($yaml, '(?m)^volumes:\r?\n  app:')) {
        throw 'Upstream Compose differs from reviewed layout; no start.'
    }
    $yaml = $yaml.Replace('MYSQL_PASSWORD: &db-password "CHANGE_ME"',
                          ('MYSQL_PASSWORD: &db-password "' + (RandomHex 20) + '"'))
    $yaml = $yaml.Replace('MYSQL_ROOT_PASSWORD: "CHANGE_ME_TOO"',
                          ('MYSQL_ROOT_PASSWORD: "' + (RandomHex 20) + '"'))
    $yaml = $yaml.Replace('      - "80:80"', ('      - "127.0.0.1:' + $Port + ':80"'))
    $yaml = $yaml.Replace('      - "./database:/var/lib/mysql"', '      - "database:/var/lib/mysql"')
    $newline = [Environment]::NewLine
    $yaml = [regex]::Replace($yaml, '(?m)^volumes:\r?\n  app:',
                             ('volumes:' + $newline + '  app:' + $newline + '  database:'), 1)
    $yaml = $yaml.Replace('APP_ENV: "production"',
                          ('APP_ENV: "production"' + [Environment]::NewLine + '      APP_LOCALE: "zh"'))
    $yaml | Set-Content -LiteralPath $manifest -Encoding utf8
    "Paymenter local preview; upstream=$sourceCommit; port=$Port" |
        Set-Content -LiteralPath $marker -Encoding utf8
} else {
    if (-not (Test-Path $marker)) { throw 'Existing Compose is not owned by this trial.' }
    $yaml = Get-Content -LiteralPath $manifest -Raw
    if (-not $yaml.Contains(('127.0.0.1:' + $Port + ':80'))) { throw 'Port differs from existing trial config.' }
    Write-Host '[P1] Reusing owned project without overwriting data.'
}
# Keep Laravel encryption key in the project-owned local .env rather than container logs.
$appEnvPath = Join-Path $root '.env'
if (-not (Test-Path -LiteralPath $appEnvPath)) {
    $appKey = 'base64:' + [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    ('APP_KEY=' + $appKey) | Set-Content -LiteralPath $appEnvPath -Encoding utf8
}
Write-Host '[P2] Validating and starting three containers ...'
& docker compose -p $projectName -f $manifest config --quiet
Check-Docker 'compose config'
& docker compose -p $projectName -f $manifest up -d
Check-Docker 'compose up'
Write-Host '[P3] Waiting for app database migrations ...'
$ready = $false
$migrationStatus = ''
$migrationExit = 1
for ($i = 0; $i -lt 36; $i++) {
    $migrationStatus = (& docker compose -p $projectName -f $manifest exec -T paymenter php artisan migrate:status --no-interaction 2>&1 | Out-String)
    $migrationExit = $LASTEXITCODE
    if ($migrationExit -eq 0 -and $migrationStatus -notmatch '\bPending\b') { $ready = $true; break }
    Start-Sleep -Seconds 5
}
if (-not $ready) {
    $pendingCount = [regex]::Matches($migrationStatus, '\bPending\b').Count
    throw "Migrations not ready (exit=$migrationExit, pending=$pendingCount); preserve project data and inspect project-scoped logs."
}
& docker compose -p $projectName -f $manifest exec -T paymenter php artisan app:init 'Paymenter 本机试用' $url
Check-Docker 'app init'
& docker compose -p $projectName -f $manifest exec -T paymenter php artisan db:seed --class=CustomPropertySeeder --force
Check-Docker 'custom property seed'
Write-Host '[P4] Creating random-password disposable local admin ...'
$pw = RandomHex 12
$php = @'
<?php
require '/app/vendor/autoload.php';
$app = require '/app/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
$adminRole = App\Models\Role::where('name', 'admin')->firstOrFail();
$user = App\Models\User::where('email', '__EMAIL__')->first();
if ($user) {
    if ((int)$user->role_id !== (int)$adminRole->id) { throw new RuntimeException('Demo email conflict'); }
    echo "ACCOUNT_ALREADY_EXISTS\n";
    exit(0);
}
App\Models\User::create([
    'first_name' => 'Demo',
    'last_name' => 'Admin',
    'email' => '__EMAIL__',
    'password' => '__PASSWORD__',
    'role_id' => $adminRole->id,
    'email_verified_at' => now(),
]);
echo "ACCOUNT_CREATED\n";
'@
$php = $php.Replace('__EMAIL__', $email).Replace('__PASSWORD__', $pw)
$result = ($php | & docker compose -p $projectName -f $manifest exec -T paymenter php) | Out-String
Check-Docker 'admin creation/readback'
if ($result.Contains('ACCOUNT_CREATED')) {
    Write-Host "LOGIN_EMAIL: $email"
    Write-Host "LOGIN_PASSWORD: $pw"
} elseif ($result.Contains('ACCOUNT_ALREADY_EXISTS')) {
    Write-Host "LOGIN_EMAIL: $email"
    Write-Host 'LOGIN_PASSWORD: existing account preserved; use first-run output.'
} else {
    throw 'No verified create/readback indicator. Do not assume an admin exists.'
}
Write-Host '[P5] Checking HTTP frontend ...'
$webOK = $false
for ($i = 0; $i -lt 12; $i++) {
    try {
        $resp = Invoke-WebRequest -Uri $url -NoProxy -MaximumRedirection 5 -TimeoutSec 10
        if ([int]$resp.StatusCode -ge 200 -and [int]$resp.StatusCode -lt 400) { $webOK = $true; break }
    } catch { Start-Sleep -Seconds 3 }
}
if (-not $webOK) { throw "Web route not verified at $url; preserve containers for diagnosis." }
Write-Host "RESULT: PASS_CANDIDATE_LOCAL_PREVIEW"
Write-Host "SITE: $url"
Write-Host "ADMIN_UI: $url/admin"
Write-Host 'LOCALE_REQUESTED: zh (visually confirm the actual UI).'
Write-Host "OWNED_DATA: $root"
Write-Host 'NO Stripe Live, payment, public networking, or paid referral add-on enabled.'
Start-Process $url
