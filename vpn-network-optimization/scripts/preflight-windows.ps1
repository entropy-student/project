$ErrorActionPreference = 'Continue'

# Read-only G1 inspection. No profile import, proxy, route, VPN, TUN, or service changes.

Write-Output '===== WINDOWS_TARGET_IDENTITY ====='
[Environment]::MachineName
[Security.Principal.WindowsIdentity]::GetCurrent().Name
$PSVersionTable.PSVersion.ToString()
Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, LastBootUpTime | Format-List

Write-Output '===== CLASH_AND_WIREGUARD_INSTALL_METADATA ====='
$regPaths = @(
  'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)
foreach ($regPath in $regPaths) {
  Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -match 'Clash|Mihomo|WireGuard' } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallLocation |
    Format-List
}

Write-Output '===== PROCESSES ====='
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.ProcessName -match 'clash|mihomo|wireguard|wintun' } |
  Select-Object ProcessName, Id, Path |
  Format-List

Write-Output '===== TUN_AND_WIREGUARD_ADAPTERS ====='
Get-NetAdapter -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -match 'Clash|WireGuard|Wintun|Mihomo|TAP' -or $_.InterfaceDescription -match 'Clash|WireGuard|Wintun|Mihomo|TAP' } |
  Select-Object Name, InterfaceDescription, ifIndex, Status, LinkSpeed |
  Format-List

Write-Output '===== SYSTEM_PROXY ====='
netsh winhttp show proxy
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable, ProxyServer, AutoConfigURL -ErrorAction SilentlyContinue |
  Select-Object ProxyEnable, ProxyServer, AutoConfigURL |
  Format-List

Write-Output '===== WIREGUARD_SERVICES ====='
Get-Service -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -match 'WireGuard|Wintun' -or $_.DisplayName -match 'WireGuard|Wintun' } |
  Select-Object Name, DisplayName, Status, StartType |
  Format-List

Write-Output '===== ROUTES ====='
Get-NetRoute -AddressFamily IPv4 -ErrorAction SilentlyContinue |
  Where-Object { $_.DestinationPrefix -in @('0.0.0.0/0', '10.66.21.0/24') } |
  Select-Object DestinationPrefix, NextHop, InterfaceAlias, ifIndex, RouteMetric, PolicyStore |
  Sort-Object DestinationPrefix, RouteMetric |
  Format-Table -AutoSize

Write-Output 'PREFLIGHT_READ_ONLY=YES'
Write-Output 'PRIVATE_KEYS_READ=NO'
Write-Output 'LIVE_TUNING_APPLIED=NO'

