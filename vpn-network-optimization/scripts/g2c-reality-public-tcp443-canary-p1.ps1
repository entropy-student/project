param([switch]$CanonicalSourceOnly, [switch]$LocalPreflightOnly)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:phase = 'INITIALIZE'
$script:resultPhase = 'INITIALIZE'
$script:roundStartedAt = [DateTime]::UtcNow
$script:integrityRid = $null
$script:administratorRoleVerified = $false
$script:highIntegrityVerified = $false
$script:failureCode = $null
$script:cleanupFailures = [Collections.Generic.List[string]]::new()
$script:runId = $null
$script:ownerSid = $null
$script:identityPath = $null
$script:knownHostsPath = $null
$script:gitPath = $null
$script:gitCwd = $null
$script:repoRoot = $null
$script:projectRoot = $null
$script:sourceHead = $null
$script:canonicalSourceVerified = $false
$script:sshPath = $null
$script:mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
$script:serverHost = 'root@10.66.21.1'
$script:serverTunnelIp = '10.66.21.1'
$script:expectedHostname = 'ubuntu-s-1vcpu-512mb-10gb-sfo3'
$script:serverPublicIp = '24.199.118.137'
$script:serverPort = 443
$script:routePrefix = '24.199.118.137/32'
$script:localProxyPort = 17990
$script:endpoint = 'https://api.openai.com/v1/models'
$script:runtimeRoot = $null
$script:runtimeDirectory = $null
$script:runtimeConfigPath = $null
$script:runtimeDirectoryCreated = $false
$script:runtimeConfigCreated = $false
$script:preflightPassed = $false
$script:routeMutationAttempted = $false
$script:routeAdded = $false
$script:routeRemoved = $false
$script:requestBudgetConsumed = $false
$script:physicalEgress = $null
$script:routeBefore = $null
$script:routeAfter = $null
$script:clientProcess = $null
$script:clientCapture = $null
$script:remoteProcess = $null
$script:remoteStderrTask = $null
$script:remoteStarted = $false
$script:remoteConfigured = $false
$script:requestCount = 0
$script:curlProcess = $null
$script:curlExit = $null
$script:httpStatus = $null
$script:curlTotal = $null
$script:curlConnect = $null
$script:curlAppConnect = $null
$script:clientErrorClass = 'NOT_RUN'
$script:serverErrorClass = 'NOT_OBSERVED'
$script:implementationResult = 'UNKNOWN'
$script:remoteCleanup = $null
$script:localBefore = $null
$script:localAfter = $null
$script:remoteBefore = $null
$script:remoteAfter = $null
$script:publicKey = $null
$script:assetHashPass = $false
$script:publicListenerTcpPassed = $false
$script:publicListenerTcpAttempted = $false
$script:clientProxyReady = $false
$script:clientConfigCheckPassed = $false
$script:serverRssAtReady = $null
$script:readyRecord = $null
$script:uuid = $null
$script:shortId = $null
$script:shortIdBytes = $null
$script:curlErrorText = $null
$script:clientLogText = $null

function Assert-R3 {
    param([Parameter(Mandatory = $true)][bool]$Condition, [Parameter(Mandatory = $true)][string]$Code)
    if (-not $Condition) { throw $Code }
}

function Get-P1IntegrityRid {
    $groups = @(& whoami.exe /groups 2>$null)
    $nativeExit = $LASTEXITCODE
    Assert-R3 ($nativeExit -eq 0) 'INTEGRITY_QUERY_FAILED'
    $matches = [regex]::Matches(($groups -join "`n"), 'S-1-16-(\d+)')
    Assert-R3 ($matches.Count -eq 1) 'INTEGRITY_LEVEL_AMBIGUOUS'
    return [int]$matches[0].Groups[1].Value
}

function Assert-P1ExecutionToken {
    Assert-R3 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $script:administratorRoleVerified = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Assert-R3 $script:administratorRoleVerified 'ADMINISTRATOR_TOKEN_REQUIRED'
    $integrityRid = Get-P1IntegrityRid
    $script:integrityRid = $integrityRid
    $script:highIntegrityVerified = ($integrityRid -ge 12288)
    Assert-R3 $script:highIntegrityVerified 'HIGH_INTEGRITY_TOKEN_REQUIRED'
    return $integrityRid
}

function Invoke-P1GitRead {
    param([Parameter(Mandatory = $true)][string[]]$Arguments)
    $output = @(& $script:gitPath -C $script:gitCwd @Arguments 2>$null)
    Assert-R3 ($LASTEXITCODE -eq 0) 'CANONICAL_GIT_READ_FAILED'
    return ,$output
}

function Assert-P1CanonicalSourceFacts {
    param(
        [Parameter(Mandatory = $true)][string]$Origin,
        [Parameter(Mandatory = $true)][string]$Head,
        [Parameter(Mandatory = $true)][bool]$AcceptedBaseIsAncestor,
        [Parameter(Mandatory = $true)][bool]$RunnerTracked,
        [Parameter(Mandatory = $true)][bool]$ReviewerTracked,
        [Parameter(Mandatory = $true)][bool]$RunnerClean,
        [Parameter(Mandatory = $true)][bool]$ReviewerClean,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$GateText
    )
    Assert-R3 ($Origin -in @(
        'https://github.com/entropy-student/project.git',
        'git@github.com:entropy-student/project.git',
        'ssh://git@github.com/entropy-student/project.git'
    )) 'CANONICAL_GITHUB_ORIGIN_MISMATCH'
    Assert-R3 ($Head -match '^[0-9a-fA-F]{40}$') 'CANONICAL_GIT_HEAD_INVALID'
    Assert-R3 $AcceptedBaseIsAncestor 'CANONICAL_ACCEPTED_BASE_NOT_ANCESTOR'
    Assert-R3 $RunnerTracked 'CANONICAL_RUNNER_NOT_TRACKED'
    Assert-R3 $ReviewerTracked 'CANONICAL_REVIEWER_HANDOFF_NOT_TRACKED'
    Assert-R3 ($RunnerClean -and $ReviewerClean) 'CANONICAL_GATE_SOURCE_DIRTY'
    $requiredGateFields = [ordered]@{
        GATE_ID = 'G2C_REALITY_PUBLIC_TCP443_CANARY_P1'
        STATE = 'AUTHORIZED'
        REAL_OPENAI_REQUEST_BUDGET_CONSUMED = '0_OF_1'
    }
    foreach ($field in $requiredGateFields.Keys) {
        $fieldPrefix = "$field="
        $fieldLines = @($GateText -split '\r?\n' | Where-Object { $_.StartsWith($fieldPrefix, [StringComparison]::Ordinal) })
        Assert-R3 ($fieldLines.Count -eq 1 -and
            $fieldLines[0].Substring($fieldPrefix.Length) -ceq $requiredGateFields[$field]) 'CURRENT_GATE_NOT_AUTHORIZED_OR_BUDGET_NOT_FRESH'
    }
}

function Assert-P1CanonicalSource {
    $scriptPath = [IO.Path]::GetFullPath($PSCommandPath)
    $script:projectRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
    Assert-R3 ((Split-Path -Leaf $script:projectRoot) -ceq 'vpn-network-optimization') 'PROJECT_PATH_INVALID'
    Assert-R3 ((Split-Path -Leaf $scriptPath) -ceq 'g2c-reality-public-tcp443-canary-p1.ps1') 'RUNNER_PATH_INVALID'
    $script:gitPath = (Get-Command git.exe -ErrorAction Stop).Source
    $script:gitCwd = $script:projectRoot

    $insideLines = @(& $script:gitPath -C $script:gitCwd rev-parse --is-inside-work-tree 2>$null)
    Assert-R3 ($LASTEXITCODE -eq 0 -and $insideLines.Count -eq 1 -and ([string]$insideLines[0]).Trim() -ceq 'true') 'CANONICAL_GIT_WORKTREE_QUERY_FAILED'

    # Do not consume --show-toplevel here. On this Windows host Git's UTF-8 absolute path
    # can be decoded through the native-process boundary into mojibake (e.g. VPS搭建 -> VPS鎼缓).
    # --show-prefix is repository-relative and ASCII for this canonical project path.
    $prefixLines = @(& $script:gitPath -C $script:gitCwd rev-parse --show-prefix 2>$null)
    Assert-R3 ($LASTEXITCODE -eq 0 -and $prefixLines.Count -eq 1) 'CANONICAL_GIT_PREFIX_QUERY_FAILED'
    $projectPrefix = ([string]$prefixLines[0]).Trim().Replace('\', '/')
    Assert-R3 ($projectPrefix -ceq 'vpn-network-optimization/') 'CANONICAL_GIT_PROJECT_PREFIX_MISMATCH'
    $script:trackedProjectPath = $projectPrefix.TrimEnd('/')

    # All remaining Git checks run from the already-resolved project directory, so target
    # paths are ASCII project-local paths and do not depend on decoding a Unicode repo root.
    $runnerRelativePath = 'scripts/g2c-reality-public-tcp443-canary-p1.ps1'
    $reviewerRelativePath = 'REVIEWER_HANDOFF.md'
    $origin = [string]((Invoke-P1GitRead -Arguments @('remote','get-url','origin')) -join "`n").Trim()
    $head = [string]((Invoke-P1GitRead -Arguments @('rev-parse','HEAD')) -join "`n").Trim()
    $script:sourceHead = $head
    $acceptedBase = '496f464029fad4a5747465ce441613104ed8ce06'
    $null = & $script:gitPath -C $script:gitCwd merge-base --is-ancestor $acceptedBase HEAD 2>$null
    $acceptedBaseIsAncestor = ($LASTEXITCODE -eq 0)
    $null = & $script:gitPath -C $script:gitCwd ls-files --error-unmatch -- $runnerRelativePath 2>$null
    $runnerTracked = ($LASTEXITCODE -eq 0)
    $null = & $script:gitPath -C $script:gitCwd ls-files --error-unmatch -- $reviewerRelativePath 2>$null
    $reviewerTracked = ($LASTEXITCODE -eq 0)
    $runnerStatus = @(& $script:gitPath -C $script:gitCwd status --porcelain --untracked-files=all -- $runnerRelativePath 2>$null)
    $runnerStatusExit = $LASTEXITCODE
    $reviewerStatus = @(& $script:gitPath -C $script:gitCwd status --porcelain --untracked-files=all -- $reviewerRelativePath 2>$null)
    $reviewerStatusExit = $LASTEXITCODE
    $runnerClean = ($runnerStatusExit -eq 0 -and $runnerStatus.Count -eq 0)
    $reviewerClean = ($reviewerStatusExit -eq 0 -and $reviewerStatus.Count -eq 0)
    $reviewerPath = Join-Path $script:projectRoot 'REVIEWER_HANDOFF.md'
    $reviewerText = [IO.File]::ReadAllText($reviewerPath)
    $gateMatch = [regex]::Match($reviewerText, '(?s)## CURRENT_GATE\s*```text\s*(?<gate>.*?)\s*```')
    $gateText = if ($gateMatch.Success) { $gateMatch.Groups['gate'].Value } else { '' }
    Assert-P1CanonicalSourceFacts -Origin $origin -Head $head `
        -AcceptedBaseIsAncestor $acceptedBaseIsAncestor -RunnerTracked $runnerTracked `
        -ReviewerTracked $reviewerTracked -RunnerClean $runnerClean `
        -ReviewerClean $reviewerClean -GateText $gateText
    $script:canonicalSourceVerified = $true
}
function Resolve-P1PhysicalEgress {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Candidates)
    $valid = [Collections.Generic.List[object]]::new()
    foreach ($candidate in $Candidates) {
        foreach ($required in @('Physical','Alias','InterfaceDescription','Status','InterfaceIndex','Gateway','SourceIPv4','DefaultRouteMatch')) {
            Assert-R3 ($candidate.PSObject.Properties.Name -contains $required) 'PHYSICAL_EGRESS_CANDIDATE_SHAPE_INVALID'
        }
        $sourceAddress = $null
        $gatewayAddress = $null
        $validSource = [Net.IPAddress]::TryParse([string]$candidate.SourceIPv4, [ref]$sourceAddress) -and
            $sourceAddress.AddressFamily -eq [Net.Sockets.AddressFamily]::InterNetwork -and
            -not [Net.IPAddress]::IsLoopback($sourceAddress) -and
            -not ([string]$candidate.SourceIPv4).StartsWith('169.254.') -and
            [string]$candidate.SourceIPv4 -ne '0.0.0.0'
        $validGateway = [Net.IPAddress]::TryParse([string]$candidate.Gateway, [ref]$gatewayAddress) -and
            $gatewayAddress.AddressFamily -eq [Net.Sockets.AddressFamily]::InterNetwork -and
            -not [Net.IPAddress]::IsLoopback($gatewayAddress) -and
            [string]$candidate.Gateway -ne '0.0.0.0'
        $description = [string]$candidate.InterfaceDescription
        $name = [string]$candidate.Alias
        $virtualName = ($name + ' ' + $description) -match '(?i)(wireguard|wintun|\btap\b|\btun\b|mihomo|clash|hyper-v|vmware|virtualbox|loopback|teredo|isatap)'
        if ($candidate.Physical -eq $true -and $candidate.Status -eq 'Up' -and
            [int]$candidate.InterfaceIndex -gt 0 -and $name -cne 'SFO2-A' -and
            -not $virtualName -and $validSource -and $validGateway -and $candidate.DefaultRouteMatch -eq $true) {
            $valid.Add($candidate)
        }
    }
    Assert-R3 ($valid.Count -eq 1) $(if ($valid.Count -eq 0) { 'PHYSICAL_EGRESS_NOT_UNIQUE_OR_MISSING' } else { 'PHYSICAL_EGRESS_AMBIGUOUS' })
    return $valid[0]
}

function Test-P1RouteMatchesEgress {
    param(
        [Parameter(Mandatory = $true)][object]$Route,
        [Parameter(Mandatory = $true)][object]$Egress,
        [Parameter(Mandatory = $true)][string]$DestinationPrefix
    )
    foreach ($required in @('DestinationPrefix','InterfaceAlias','InterfaceIndex','NextHop')) {
        if ($Route.PSObject.Properties.Name -notcontains $required) { return $false }
    }
    return ([string]$Route.DestinationPrefix -ceq $DestinationPrefix -and
        [string]$Route.InterfaceAlias -ceq [string]$Egress.Alias -and
        [int]$Route.InterfaceIndex -eq [int]$Egress.InterfaceIndex -and
        [string]$Route.NextHop -ceq [string]$Egress.Gateway)
}

function Get-P1ExactActiveRoute {
    try {
        $items = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix $script:routePrefix -ErrorAction Stop)
        return ,$items
    }
    catch {
        if ($_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -eq 'CmdletizationQuery_NotFound,Get-NetRoute') { return ,@() }
        throw
    }
}

function Get-P1ExactPersistentRoute {
    try {
        $items = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore PersistentStore -DestinationPrefix $script:routePrefix -ErrorAction Stop)
        return ,$items
    }
    catch {
        if ($_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -eq 'CmdletizationQuery_NotFound,Get-NetRoute') { return ,@() }
        throw
    }
}

function Get-P1SelectedPublicRoute {
    $rows = @(Find-NetRoute -RemoteIPAddress $script:serverPublicIp -ErrorAction Stop | Where-Object {
        $null -ne $_ -and $_.PSObject.Properties.Name -contains 'DestinationPrefix' -and
        $_.PSObject.Properties.Name -contains 'InterfaceAlias' -and
        $_.PSObject.Properties.Name -contains 'InterfaceIndex' -and
        $_.PSObject.Properties.Name -contains 'NextHop'
    })
    Assert-R3 ($rows.Count -eq 1) 'PUBLIC_ROUTE_SELECTION_INVALID'
    return [pscustomobject]@{
        DestinationPrefix = [string]$rows[0].DestinationPrefix
        InterfaceAlias = [string]$rows[0].InterfaceAlias
        InterfaceIndex = [int]$rows[0].InterfaceIndex
        NextHop = [string]$rows[0].NextHop
    }
}

function Assert-P1PhysicalPublicRoute {
    $route = Get-P1SelectedPublicRoute
    Assert-R3 (Test-P1RouteMatchesEgress -Route $route -Egress $script:physicalEgress -DestinationPrefix $script:routePrefix) 'VPS_OUTER_ROUTE_NOT_PHYSICAL_DIRECT'
    $script:routeAfter = $route
    return $route
}

function Get-P1PhysicalEgress {
    $adapters = @(Get-NetAdapter -Physical -ErrorAction Stop)
    Assert-R3 ($adapters.Count -gt 0) 'PHYSICAL_ADAPTER_QUERY_EMPTY'
    $candidates = [Collections.Generic.List[object]]::new()
    foreach ($adapter in $adapters) {
        $name = [string]$adapter.Name
        $ifIndex = [int]$adapter.InterfaceIndex
        if ($adapter.Status -ne 'Up' -or $ifIndex -le 0 -or $name -ceq 'SFO2-A') { continue }
        $configurations = @(Get-NetIPConfiguration -InterfaceIndex $ifIndex -ErrorAction Stop)
        Assert-R3 ($configurations.Count -eq 1) 'PHYSICAL_EGRESS_IP_CONFIGURATION_INVALID'
        $configuration = $configurations[0]
        $addressProperty = $configuration.PSObject.Properties['IPv4Address']
        $gatewayProperty = $configuration.PSObject.Properties['IPv4DefaultGateway']
        $addressObjects = if ($null -ne $addressProperty -and $null -ne $addressProperty.Value) { @($addressProperty.Value) } else { @() }
        $gatewayObjects = if ($null -ne $gatewayProperty -and $null -ne $gatewayProperty.Value) { @($gatewayProperty.Value) } else { @() }
        if ($gatewayObjects.Count -eq 0 -or $addressObjects.Count -eq 0) { continue }
        Assert-R3 ($gatewayObjects.Count -eq 1) 'PHYSICAL_EGRESS_GATEWAY_AMBIGUOUS'
        Assert-R3 ($addressObjects.Count -eq 1) 'PHYSICAL_EGRESS_SOURCE_IPV4_AMBIGUOUS'
        $gateway = [string]$gatewayObjects[0].NextHop
        $sourceIPv4 = [string]$addressObjects[0].IPAddress
        $defaultRoutes = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix '0.0.0.0/0' -ErrorAction Stop | Where-Object {
            [int]$_.InterfaceIndex -eq $ifIndex -and [string]$_.NextHop -ceq $gateway
        })
        if ($defaultRoutes.Count -eq 0) { continue }
        Assert-R3 ($defaultRoutes.Count -eq 1) 'PHYSICAL_EGRESS_DEFAULT_ROUTE_AMBIGUOUS'
        $candidates.Add([pscustomobject]@{
            Physical = $true
            Alias = $name
            InterfaceDescription = [string]$adapter.InterfaceDescription
            Status = [string]$adapter.Status
            InterfaceIndex = $ifIndex
            Gateway = $gateway
            SourceIPv4 = $sourceIPv4
            DefaultRouteMatch = $true
        })
    }
    return Resolve-P1PhysicalEgress -Candidates @($candidates)
}

function Add-P1TemporaryRoute {
    Assert-R3 $script:preflightPassed 'TEMP_ROUTE_BEFORE_PREFLIGHT'
    Assert-R3 ($null -ne $script:physicalEgress) 'PHYSICAL_EGRESS_NOT_CAPTURED'
    Assert-R3 ((Get-P1ExactActiveRoute).Count -eq 0) 'EXACT_PUBLIC_ROUTE_APPEARED_BEFORE_ADD'
    Assert-R3 ((Get-P1ExactPersistentRoute).Count -eq 0) 'PERSISTENT_PUBLIC_ROUTE_UNEXPECTED'
    $script:routeMutationAttempted = $true
    New-NetRoute -AddressFamily IPv4 -DestinationPrefix $script:routePrefix `
        -InterfaceIndex ([int]$script:physicalEgress.InterfaceIndex) `
        -NextHop ([string]$script:physicalEgress.Gateway) -RouteMetric 1 `
        -PolicyStore ActiveStore -Confirm:$false -ErrorAction Stop | Out-Null
    $script:routeAdded = $true
    $routes = Get-P1ExactActiveRoute
    Assert-R3 ($routes.Count -eq 1) 'OWNER_ROUTE_CREATE_CARDINALITY_INVALID'
    Assert-R3 (Test-P1RouteMatchesEgress -Route $routes[0] -Egress $script:physicalEgress -DestinationPrefix $script:routePrefix) 'OWNER_ROUTE_CREATE_READBACK_INVALID'
    Assert-R3 ((Get-P1ExactPersistentRoute).Count -eq 0) 'PERSISTENT_OWNER_ROUTE_UNEXPECTED'
    $null = Assert-P1PhysicalPublicRoute
}

function Remove-P1TemporaryRouteExact {
    if (-not $script:routeMutationAttempted) { return }
    $routes = $null
    try { $routes = Get-P1ExactActiveRoute }
    catch { $script:cleanupFailures.Add('OWNER_ROUTE_QUERY_FAILED'); return }
    if ($routes.Count -gt 0) {
        if ($routes.Count -ne 1 -or -not (Test-P1RouteMatchesEgress -Route $routes[0] -Egress $script:physicalEgress -DestinationPrefix $script:routePrefix)) {
            $script:cleanupFailures.Add('OWNER_ROUTE_STATE_INVALID')
            return
        }
        try { Remove-NetRoute -InputObject $routes[0] -Confirm:$false -ErrorAction Stop }
        catch { $script:cleanupFailures.Add('OWNER_ROUTE_REMOVE_FAILED'); return }
    }
    $remaining = $null
    try { $remaining = Get-P1ExactActiveRoute }
    catch { $script:cleanupFailures.Add('OWNER_ROUTE_POSTREMOVE_VERIFY_FAILED'); return }
    if ($remaining.Count -ne 0) {
        $script:cleanupFailures.Add('OWNER_ROUTE_POSTREMOVE_VERIFY_FAILED')
        return
    }
    $script:routeRemoved = $true
}

function Resolve-R3FailureCode {
    param([AllowNull()][object]$Record)
    try {
        $exception = $null
        $fullyQualifiedErrorId = ''
        if ($Record -is [System.Management.Automation.ErrorRecord]) {
            $exception = $Record.Exception
            $fullyQualifiedErrorId = [string]$Record.FullyQualifiedErrorId
        }
        elseif ($Record -is [System.Exception]) {
            $exception = $Record
        }

        $runtimeTypeName = ''
        $message = ''
        if ($null -ne $exception) {
            $runtimeTypeName = [string]$exception.GetType().Name
            $message = [string]$exception.Message
        }

        $isParameterBindingException = $runtimeTypeName -in @('ParameterBindingValidationException', 'ParameterBindingException')
        $isSuppressedProcessArgumentBinding = $fullyQualifiedErrorId -match '^(?:ParameterArgumentValidationError(?:EmptyArrayNotAllowed|EmptyCollectionNotAllowed|EmptyStringNotAllowed)|MissingMandatoryParameter),Start-R3SuppressedProcess$'
        if ($isParameterBindingException -and $isSuppressedProcessArgumentBinding) {
            return 'LOCAL_PROCESS_ARGUMENT_BINDING_FAILED'
        }
        if ($message -match '^[A-Z][A-Z0-9_]{1,79}$') { return $message }
        return 'UNEXPECTED_LOCAL_FAILURE'
    }
    catch {
        return 'UNEXPECTED_LOCAL_FAILURE'
    }
}

function Get-R3OptionalProperty {
    param([Parameter(Mandatory = $true)][object]$Object, [Parameter(Mandatory = $true)][string]$Name)
    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return '' }
    return [string]$property.Value
}

function Get-P1WinHttpState {
    if (-not ('P1WinHttpNative' -as [type])) {
        Add-Type @'
using System;
using System.Runtime.InteropServices;

public static class P1WinHttpNative
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct WINHTTP_PROXY_INFO
    {
        public uint dwAccessType;
        public IntPtr lpszProxy;
        public IntPtr lpszProxyBypass;
    }

    [DllImport("winhttp.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern bool WinHttpGetDefaultProxyConfiguration(out WINHTTP_PROXY_INFO pProxyInfo);

    [DllImport("kernel32.dll")]
    public static extern IntPtr GlobalFree(IntPtr hMem);
}
'@
    }

    $info = New-Object P1WinHttpNative+WINHTTP_PROXY_INFO
    $ok = [P1WinHttpNative]::WinHttpGetDefaultProxyConfiguration([ref]$info)
    Assert-R3 $ok 'LOCAL_WINHTTP_QUERY_FAILED'
    $proxyPresent = ($info.lpszProxy -ne [IntPtr]::Zero)
    $bypassPresent = ($info.lpszProxyBypass -ne [IntPtr]::Zero)
    try {
        $accessType = [int]$info.dwAccessType
        return [pscustomobject]@{
            AccessType = $accessType
            Direct = ($accessType -eq 1)
            Summary = ('ACCESS_TYPE={0};PROXY_PRESENT={1};BYPASS_PRESENT={2}' -f
                $accessType,
                $(if ($proxyPresent) { 'YES' } else { 'NO' }),
                $(if ($bypassPresent) { 'YES' } else { 'NO' }))
        }
    }
    finally {
        if ($info.lpszProxy -ne [IntPtr]::Zero) { [void][P1WinHttpNative]::GlobalFree($info.lpszProxy) }
        if ($info.lpszProxyBypass -ne [IntPtr]::Zero) { [void][P1WinHttpNative]::GlobalFree($info.lpszProxyBypass) }
    }
}

function Get-R3LocalSnapshot {
    $manager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $tunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $adapter = Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
    $wireGuardIfIndex = [int]$adapter.ifIndex
    Assert-R3 ($adapter.Name -ceq 'SFO2-A' -and $adapter.Status -eq 'Up' -and $wireGuardIfIndex -gt 0) 'LOCAL_WIREGUARD_ADAPTER_INVALID'
    $route = @(Find-NetRoute -RemoteIPAddress $script:serverTunnelIp -ErrorAction Stop)
    Assert-R3 ($route.Count -gt 0) 'LOCAL_CONTROL_ROUTE_MISSING'
    $selectedRoute = $route[0]
    $physicalEgress = Get-P1PhysicalEgress
    $publicRoute = Get-P1SelectedPublicRoute
    $activeOwnerRoutes = Get-P1ExactActiveRoute
    $persistentOwnerRoutes = Get-P1ExactPersistentRoute
    $splitRoutes = [Collections.Generic.List[string]]::new()
    foreach ($prefix in @('0.0.0.0/1','128.0.0.0/1')) {
        $items = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix $prefix -ErrorAction Stop)
        Assert-R3 ($items.Count -eq 1) 'LOCAL_WIREGUARD_SPLIT_ROUTE_INVALID'
        Assert-R3 ([int]$items[0].InterfaceIndex -eq $wireGuardIfIndex -and [string]$items[0].InterfaceAlias -ceq 'SFO2-A') 'LOCAL_WIREGUARD_SPLIT_ROUTE_NOT_WIREGUARD'
        $splitRoutes.Add(('{0}|{1}|{2}|{3}|{4}' -f $prefix, $items[0].InterfaceAlias, $items[0].InterfaceIndex, $items[0].NextHop, $items[0].RouteMetric))
    }
    $proxy = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    Assert-R3 ($null -ne $proxy.PSObject.Properties['ProxyEnable']) 'LOCAL_PROXYENABLE_MISSING'
    $proxyState = [ordered]@{
        ProxyEnable = [string]$proxy.ProxyEnable
        ProxyServer = Get-R3OptionalProperty -Object $proxy -Name 'ProxyServer'
        ProxyOverride = Get-R3OptionalProperty -Object $proxy -Name 'ProxyOverride'
        AutoConfigURL = Get-R3OptionalProperty -Object $proxy -Name 'AutoConfigURL'
    }
    $winHttpState = Get-P1WinHttpState
    $winHttpExit = 0
    $winHttpText = [string]$winHttpState.Summary
    $winHttpDirect = [bool]$winHttpState.Direct
    $tunMatches = @(Get-CimInstance -ClassName Win32_NetworkAdapter -ErrorAction Stop | Where-Object {
        $_.Name -match '(?i)(mihomo|clash|meta.?tun|tun.*clash)' -or
        $_.NetConnectionID -match '(?i)(mihomo|clash|meta.?tun|tun.*clash)' -or
        $_.Description -match '(?i)(mihomo|clash|meta.?tun|wintun)'
    } | ForEach-Object { '{0}|{1}|{2}' -f $_.Name, $_.NetConnectionID, $_.InterfaceIndex } | Sort-Object)
    $processObjects = @(Get-Process -Name 'verge-mihomo', 'mihomo' -ErrorAction SilentlyContinue)
    $processes = @($processObjects | ForEach-Object {
        $processPath = ''
        try { $processPath = [string]$_.Path } catch { $processPath = '' }
        '{0}|{1}|{2}' -f $_.ProcessName, $_.Id, $processPath
    } | Sort-Object)
    $testBinaryProcessCount = @($processObjects | Where-Object {
        try {
            -not [string]::IsNullOrWhiteSpace([string]$_.Path) -and
            ([IO.Path]::GetFullPath([string]$_.Path) -ieq [IO.Path]::GetFullPath($script:mihomoPath))
        }
        catch { $false }
    }).Count
    $tcpListeners = @(Get-NetTCPConnection -State Listen -ErrorAction Stop | Where-Object { [int]$_.LocalPort -eq $script:localProxyPort })
    $udpListeners = @(Get-NetUDPEndpoint -ErrorAction Stop | Where-Object { [int]$_.LocalPort -eq $script:localProxyPort })
    $runtimeResidue = @()
    if (Test-Path -LiteralPath $script:runtimeRoot -PathType Container) {
        $runtimeResidue = @(Get-ChildItem -LiteralPath $script:runtimeRoot -Force -ErrorAction Stop |
            Where-Object { $_.Name -like 'g2c-reality-public-p1-*' -or $_.Name -like 'g2c-reality-mihomo-r3-*' } |
            ForEach-Object Name | Sort-Object)
    }
    $versionLines = @(& $script:mihomoPath -v 2>&1)
    $versionExit = $LASTEXITCODE
    $versionText = ($versionLines -join ' ').Trim()
    return [pscustomobject]@{
        PowerShell = $PSVersionTable.PSVersion.ToString()
        WireGuardManager = $manager.Status.ToString()
        WireGuardTunnel = $tunnel.Status.ToString()
        WireGuardAdapter = $adapter.Name
        WireGuardAdapterStatus = $adapter.Status.ToString()
        WireGuardIfIndex = $wireGuardIfIndex
        ControlRouteAdapter = [string]$selectedRoute.InterfaceAlias
        ControlRouteIfIndex = [int]$selectedRoute.InterfaceIndex
        PhysicalEgress = $physicalEgress
        PublicRoute = $publicRoute
        ActiveOwnerRouteCount = $activeOwnerRoutes.Count
        PersistentOwnerRouteCount = $persistentOwnerRoutes.Count
        WireGuardSplitRoutes = @($splitRoutes | Sort-Object)
        ProxyState = ($proxyState | ConvertTo-Json -Compress)
        ProxyEnabled = ([int]$proxy.ProxyEnable -ne 0)
        WinHttpExit = [int]$winHttpExit
        WinHttpText = $winHttpText
        WinHttpAccessType = [int]$winHttpState.AccessType
        WinHttpDirect = [bool]$winHttpDirect
        TunMatches = $tunMatches
        MihomoProcesses = $processes
        TestMihomoBinaryProcessCount = [int]$testBinaryProcessCount
        LocalProxyTcpListeners = $tcpListeners.Count
        LocalProxyUdpListeners = $udpListeners.Count
        RuntimeResidue = $runtimeResidue
        ClientVersionExit = [int]$versionExit
        ClientVersionText = $versionText
    }
}

function Assert-R3LocalBaseline {
    param([Parameter(Mandatory = $true)][object]$Snapshot, [Parameter(Mandatory = $true)][string]$Prefix)
    Assert-R3 ($Snapshot.WireGuardManager -eq 'Running') "${Prefix}_WIREGUARD_MANAGER_INVALID"
    Assert-R3 ($Snapshot.WireGuardTunnel -eq 'Running') "${Prefix}_WIREGUARD_TUNNEL_INVALID"
    Assert-R3 ($Snapshot.WireGuardAdapter -eq 'SFO2-A' -and $Snapshot.WireGuardAdapterStatus -eq 'Up' -and $Snapshot.WireGuardIfIndex -gt 0) "${Prefix}_WIREGUARD_ADAPTER_INVALID"
    Assert-R3 ($Snapshot.ControlRouteAdapter -eq 'SFO2-A' -and $Snapshot.ControlRouteIfIndex -eq $Snapshot.WireGuardIfIndex) "${Prefix}_CONTROL_ROUTE_NOT_WIREGUARD"
    Assert-R3 ($Snapshot.PublicRoute.InterfaceAlias -ceq 'SFO2-A' -and $Snapshot.PublicRoute.InterfaceIndex -eq $Snapshot.WireGuardIfIndex) "${Prefix}_PUBLIC_ROUTE_BASELINE_NOT_WIREGUARD"
    Assert-R3 ($Snapshot.ActiveOwnerRouteCount -eq 0 -and $Snapshot.PersistentOwnerRouteCount -eq 0) "${Prefix}_EXACT_PUBLIC_ROUTE_ALREADY_PRESENT"
    Assert-R3 ($Snapshot.PhysicalEgress.InterfaceIndex -gt 0 -and $Snapshot.PhysicalEgress.InterfaceAlias -cne 'SFO2-A') "${Prefix}_PHYSICAL_EGRESS_INVALID"
    Assert-R3 ($Snapshot.WireGuardSplitRoutes.Count -eq 2) "${Prefix}_WIREGUARD_SPLIT_DEFAULTS_INVALID"
    Assert-R3 (-not $Snapshot.ProxyEnabled -and $Snapshot.WinHttpExit -eq 0) "${Prefix}_SYSTEM_PROXY_INVALID"
    Assert-R3 $Snapshot.WinHttpDirect "${Prefix}_WINHTTP_NOT_DIRECT"
    Assert-R3 ($Snapshot.TunMatches.Count -eq 0) "${Prefix}_TUN_PRESENT"
    Assert-R3 ($Snapshot.TestMihomoBinaryProcessCount -eq 0) "${Prefix}_P1_MIHOMO_BINARY_ALREADY_RUNNING"
    Assert-R3 ($Snapshot.LocalProxyTcpListeners -eq 0 -and $Snapshot.LocalProxyUdpListeners -eq 0) "${Prefix}_LOCAL_PROXY_PORT_OCCUPIED"
    Assert-R3 ($Snapshot.RuntimeResidue.Count -eq 0) "${Prefix}_RUNTIME_RESIDUE_PRESENT"
    Assert-R3 ($Snapshot.ClientVersionExit -eq 0 -and $Snapshot.ClientVersionText -match 'v1\.19\.31') "${Prefix}_CLIENT_VERSION_INVALID"
}

function Get-R3RemotePreflightCommand {
    return @'
set -eu
printf 'HOSTNAME=%s\n' "$(hostname)"
printf 'OS=%s\n' "$(. /etc/os-release; printf '%s' "$PRETTY_NAME")"
printf 'KERNEL=%s\n' "$(uname -r)"
printf 'PUBLIC_IP_MATCH_COUNT=%s\n' "$(ip -o -4 addr show | awk '$4 ~ /^24\.199\.118\.137\// {n++} END {print n+0}')"
printf 'WG_ADDR_MATCH=%s\n' "$(ip -o -4 addr show dev wg0 | awk '$4 ~ /^10\.66\.21\.1\// {f=1} END {print f ? "YES" : "NO"}')"
printf 'WG_SERVICE=%s\n' "$(systemctl is-active wg-quick@wg0 || true)"
printf 'HY2_SERVICE=%s\n' "$(systemctl is-active hysteria2-vpn-network-optimization.service || true)"
ss -H -lun | awk '$4 ~ /:51820$/ {a++} $4 ~ /:8443$/ {b++} END {printf "UDP_51820=%d\nUDP_8443=%d\n",a+0,b+0}'
ss -H -ltn | awk '$4 ~ /:14443$/ {a++} $4 ~ /:443$/ {b++} END {printf "TCP_14443=%d\nTCP_443=%d\n",a+0,b+0}'
printf 'DEFAULT_ROUTE=%s\n' "$(ip -4 route show default | head -n 1 | sed 's/[[:space:]]*$//')"
printf 'WG_ROUTE_COUNT=%s\n' "$(ip -4 route show dev wg0 | wc -l | tr -d ' ')"
printf 'IP_FORWARD=%s\n' "$(sysctl -n net.ipv4.ip_forward)"
printf 'MEM_AVAILABLE_KIB=%s\n' "$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)"
printf 'TMP_FREE_KIB=%s\n' "$(df -Pk /tmp | awk 'NR==2 {print $4}')"
printf 'MIHOMO_PROCESS_COUNT=%s\n' "$(pgrep -xc mihomo 2>/dev/null || true)"
printf 'SING_BOX_PROCESS_COUNT=%s\n' "$(pgrep -xc sing-box 2>/dev/null || true)"
printf 'G2C_RUNTIME_RESIDUE=%s\n' "$(find /run /tmp -maxdepth 1 \( -name 'vpn-network-optimization-g2c-r3-*' -o -name 'vpn-network-optimization-g2c-p1-*' \) -print -quit 2>/dev/null | wc -l | tr -d ' ')"
if command -v ufw >/dev/null 2>&1; then
  UFW_STATUS="$(ufw status 2>/dev/null | sed -n 's/^Status: //p' | head -n 1)"
  if [ "$UFW_STATUS" = active ]; then
    UFW_443_ALLOWED="$(ufw status 2>/dev/null | awk 'tolower($1)=="443/tcp" && toupper($2)=="ALLOW" && toupper($3)=="IN" {ok=1} END {print ok ? "YES" : "NO"}')"
  else
    UFW_443_ALLOWED=NA
  fi
else
  UFW_STATUS=not-installed
  UFW_443_ALLOWED=NA
fi
printf 'UFW_STATUS=%s\nUFW_TCP443_ALLOWED=%s\n' "$UFW_STATUS" "$UFW_443_ALLOWED"
if command -v iptables >/dev/null 2>&1; then
  IPTABLES_VERSION="$(iptables --version 2>/dev/null)" || exit 32
  case "$IPTABLES_VERSION" in
    *nf_tables*) IPTABLES_BACKEND=nf_tables ;;
    *legacy*) IPTABLES_BACKEND=legacy ;;
    *) IPTABLES_BACKEND=unknown ;;
  esac
else
  IPTABLES_BACKEND=not-installed
fi
printf 'IPTABLES_BACKEND=%s\n' "$IPTABLES_BACKEND"
if command -v nft >/dev/null 2>&1; then
  NFT_TEXT="$(nft -a list ruleset 2>/dev/null)" || exit 31
  if [ -z "$NFT_TEXT" ]; then
    NFT_INPUT_POLICY=EMPTY
    NFT_TCP443_BLOCK_COUNT=0
  else
    NFT_INPUT_POLICY="$(printf '%s\n' "$NFT_TEXT" | awk '/hook input/ {seen=1; if ($0 ~ /policy drop/) drop=1; else if ($0 ~ /policy reject/) reject=1; else if ($0 ~ /policy accept/) accept=1; else unknown=1} END {if (drop) print "DROP"; else if (reject) print "REJECT"; else if (unknown) print "UNKNOWN"; else if (accept) print "ACCEPT"; else if (seen) print "UNKNOWN"; else print "NO_INPUT_HOOK"}')"
    NFT_TCP443_BLOCK_COUNT="$(printf '%s\n' "$NFT_TEXT" | awk '/(^|[^0-9])443([^0-9]|$)/' | grep -Eic '(drop|reject)' || true)"
  fi
else
  NFT_INPUT_POLICY=not-installed
  NFT_TCP443_BLOCK_COUNT=0
fi
printf 'NFT_INPUT_POLICY=%s\nNFT_TCP443_BLOCK_COUNT=%s\n' "$NFT_INPUT_POLICY" "$NFT_TCP443_BLOCK_COUNT"
'@
}

function New-R3SshStartInfo {
    param([Parameter(Mandatory = $true)][string]$RemoteCommand)
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $script:sshPath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    foreach ($arg in @(
        '-T', '-i', $script:identityPath,
        '-o', 'BatchMode=yes', '-o', 'IdentitiesOnly=yes',
        '-o', 'StrictHostKeyChecking=yes', '-o', 'UpdateHostKeys=no',
        '-o', "UserKnownHostsFile=$($script:knownHostsPath)",
        '-o', 'HostKeyAlias=24.199.118.137', '-o', 'HostName=10.66.21.1',
        '-o', 'CheckHostIP=no', '-o', 'ControlMaster=no', '-o', 'ControlPath=none',
        '-o', 'ForwardAgent=no', '-o', 'ConnectTimeout=15',
        $script:serverHost, $RemoteCommand
    )) { [void]$psi.ArgumentList.Add([string]$arg) }
    return $psi
}

function Invoke-R3RemoteReadOnlyProbe {
    param([Parameter(Mandatory = $true)][string]$Command)
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = New-R3SshStartInfo -RemoteCommand $Command
    [void]$process.Start()
    $process.StandardInput.Close()
    $outTask = $process.StandardOutput.ReadToEndAsync()
    $errTask = $process.StandardError.ReadToEndAsync()
    if (-not $process.WaitForExit(30000)) {
        $process.Kill()
        [void]$process.WaitForExit(5000)
        throw 'STRICT_SSH_PREFLIGHT_TIMEOUT'
    }
    $stdout = $outTask.GetAwaiter().GetResult()
    $stderr = $errTask.GetAwaiter().GetResult()
    Assert-R3 ($process.ExitCode -eq 0) 'STRICT_SSH_PREFLIGHT_FAILED'
    $null = $stderr
    $values = @{}
    foreach ($line in ($stdout -split "\r?\n")) {
        if ($line -match '^([A-Z0-9_]+)=(.*)$') { $values[$Matches[1]] = $Matches[2] }
    }
    return $values
}

function Assert-R3RemoteBaseline {
    param([Parameter(Mandatory = $true)][hashtable]$Values)
    Assert-R3 ($Values['HOSTNAME'] -eq $script:expectedHostname) 'VPS_HOST_IDENTITY_MISMATCH'
    Assert-R3 ($Values['OS'] -like 'Ubuntu 24.04*' -and -not [string]::IsNullOrWhiteSpace($Values['KERNEL'])) 'VPS_OS_OR_KERNEL_IDENTITY_INVALID'
    Assert-R3 ([int]$Values['PUBLIC_IP_MATCH_COUNT'] -eq 1) 'VPS_PUBLIC_IP_IDENTITY_MISMATCH'
    Assert-R3 (-not [string]::IsNullOrWhiteSpace($Values['DEFAULT_ROUTE'])) 'VPS_DEFAULT_ROUTE_MISSING'
    Assert-R3 ($Values['WG_ADDR_MATCH'] -eq 'YES') 'VPS_WG_CONTROL_ADDRESS_INVALID'
    Assert-R3 ($Values['WG_SERVICE'] -eq 'active') 'VPS_WG_SERVICE_INVALID'
    Assert-R3 ($Values['HY2_SERVICE'] -eq 'active') 'VPS_HY2_SERVICE_INVALID'
    Assert-R3 ([int]$Values['UDP_51820'] -ge 1) 'VPS_UDP_51820_LISTENER_MISSING'
    Assert-R3 ([int]$Values['UDP_8443'] -ge 1) 'VPS_UDP_8443_LISTENER_MISSING'
    Assert-R3 ([int]$Values['TCP_14443'] -eq 0) 'VPS_TCP_14443_NOT_FREE'
    Assert-R3 ([int]$Values['TCP_443'] -eq 0) 'VPS_TCP_443_NOT_FREE'
    Assert-R3 ([int]$Values['MIHOMO_PROCESS_COUNT'] -eq 0) 'VPS_MIHOMO_PROCESS_PRESENT'
    Assert-R3 ([int]$Values['SING_BOX_PROCESS_COUNT'] -eq 0) 'VPS_SING_BOX_PROCESS_PRESENT'
    Assert-R3 ([int]$Values['G2C_RUNTIME_RESIDUE'] -eq 0) 'VPS_G2C_RUNTIME_RESIDUE_PRESENT'
    Assert-R3 ([int]$Values['MEM_AVAILABLE_KIB'] -ge 131072) 'VPS_MEMORY_HEADROOM_INSUFFICIENT'
    Assert-R3 ([int]$Values['TMP_FREE_KIB'] -ge 131072) 'VPS_TMP_SPACE_INSUFFICIENT'
    Assert-R3 ($Values['UFW_STATUS'] -in @('inactive','not-installed') -or
               ($Values['UFW_STATUS'] -eq 'active' -and $Values['UFW_TCP443_ALLOWED'] -eq 'YES')) 'VPS_UFW_TCP443_NOT_PREAUTHORIZED'
    Assert-R3 ($Values['IPTABLES_BACKEND'] -in @('nf_tables','not-installed')) 'VPS_IPTABLES_BACKEND_REQUIRES_FIREWALL_REVIEW'
    Assert-R3 ($Values['NFT_INPUT_POLICY'] -ne 'not-installed') 'VPS_NFT_FIREWALL_READBACK_UNAVAILABLE'
    Assert-R3 ([int]$Values['NFT_TCP443_BLOCK_COUNT'] -eq 0) 'VPS_NFT_TCP443_BLOCK_RULE_PRESENT'
    Assert-R3 ($Values['NFT_INPUT_POLICY'] -in @('EMPTY','ACCEPT','NO_INPUT_HOOK','not-installed') -or
               ($Values['NFT_INPUT_POLICY'] -in @('DROP','REJECT') -and $Values['UFW_STATUS'] -eq 'active' -and $Values['UFW_TCP443_ALLOWED'] -eq 'YES')) 'VPS_NFT_INPUT_POLICY_REQUIRES_FIREWALL_REVIEW'
}

function Get-R3RemoteSupervisorSource {
    return @'
import ctypes, gzip, hashlib, json, os, pathlib, re, shutil, signal, subprocess, sys, time, urllib.request

RUN_ID = sys.argv[1]
MODE = sys.argv[2] if len(sys.argv) > 2 else "run"
ASSET_URL = "https://github.com/MetaCubeX/mihomo/releases/download/v1.19.31/mihomo-linux-amd64-compatible-v1.19.31.gz"
ASSET_NAME = "mihomo-linux-amd64-compatible-v1.19.31.gz"
EXPECTED_SHA = "04cf9f09671704f839ddbee2e93069dc831a4123a75281e725d1d96ab9ac1afc"
RUNTIME = pathlib.Path("/run") / ("vpn-network-optimization-g2c-p1-" + RUN_ID)
WORKSPACE = pathlib.Path("/tmp") / ("vpn-network-optimization-g2c-p1-" + RUN_ID)
CONFIG = RUNTIME / "mihomo.yaml"
PID_FILE = RUNTIME / "mihomo.pid"
MARKER = "G2C-MIHOMO-P1:" + RUN_ID + "\n"
BINARY = WORKSPACE / "mihomo"
ARCHIVE = WORKSPACE / ASSET_NAME
LOG = RUNTIME / "mihomo.log"
SERVER = None
LOG_HANDLE = None
PRIVATE_KEY = None
PUBLIC_KEY = None
CLIENT_UUID = None
SHORT_ID = None
RUNTIME_CREATED = False
WORKSPACE_CREATED = False

class GateFailure(Exception):
    pass

def emit(obj):
    sys.stdout.write(json.dumps(obj, separators=(",", ":")) + "\n")
    sys.stdout.flush()

def exclusive_write(path, data, mode):
    fd = os.open(str(path), os.O_WRONLY | os.O_CREAT | os.O_EXCL, mode)
    try:
        os.fchmod(fd, mode)
        with os.fdopen(fd, "wb", closefd=False) as handle:
            handle.write(data)
            handle.flush()
            os.fsync(handle.fileno())
    finally:
        if isinstance(data, bytearray):
            data[:] = b"\x00" * len(data)
        os.close(fd)

def create_marked_dir(path):
    global RUNTIME_CREATED, WORKSPACE_CREATED
    path.mkdir(mode=0o700)
    os.chmod(path, 0o700)
    if path == RUNTIME:
        RUNTIME_CREATED = True
    if path == WORKSPACE:
        WORKSPACE_CREATED = True
    exclusive_write(path / ".g2c-p1-marker", MARKER.encode("ascii"), 0o600)

def verify_marked_dir(path):
    if path.is_symlink() or not path.is_dir():
        raise GateFailure("RUNTIME_PATH_INVALID")
    marker = path / ".g2c-p1-marker"
    if marker.is_symlink() or not marker.is_file() or marker.read_text("ascii") != MARKER:
        raise GateFailure("RUNTIME_MARKER_INVALID")

def exact_server_argv(pid):
    try:
        raw = pathlib.Path("/proc") / str(pid) / "cmdline"
        argv = [part.decode("utf-8", "strict") for part in raw.read_bytes().split(b"\0") if part]
        return argv == [str(BINARY), "-d", str(WORKSPACE), "-f", str(CONFIG)]
    except Exception:
        return False

def stop_exact_server(pid):
    if not exact_server_argv(pid):
        return False
    try:
        os.kill(pid, signal.SIGTERM)
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            if not pathlib.Path("/proc", str(pid)).exists():
                return True
            time.sleep(0.1)
        if exact_server_argv(pid):
            os.kill(pid, signal.SIGKILL)
        deadline = time.monotonic() + 2
        while time.monotonic() < deadline:
            if not pathlib.Path("/proc", str(pid)).exists():
                return True
            time.sleep(0.1)
    except ProcessLookupError:
        return True
    except Exception:
        return False
    return not pathlib.Path("/proc", str(pid)).exists()

def listener_state():
    result = subprocess.run(["ss", "-H", "-ltn"], stdout=subprocess.PIPE,
                            stderr=subprocess.DEVNULL, text=True, timeout=5, check=True)
    endpoints = []
    for line in result.stdout.splitlines():
        fields = line.split()
        if len(fields) >= 4:
            endpoints.append(fields[3])
    p14443 = [item for item in endpoints if item.endswith(":14443")]
    p443 = [item for item in endpoints if item.endswith(":443")]
    return p14443, p443

def server_owned_listener_state(pid):
    result = subprocess.run(["ss", "-H", "-lntup"], stdout=subprocess.PIPE,
                            stderr=subprocess.DEVNULL, text=True, timeout=5, check=True)
    owned = []
    for line in result.stdout.splitlines():
        if "pid=" + str(pid) + "," not in line:
            continue
        fields = line.split()
        if len(fields) >= 6 and fields[0] in ("tcp", "udp"):
            owned.append(fields[0].upper() + "|" + fields[4])
    return sorted(owned)

def mem_available_kib():
    for line in pathlib.Path("/proc/meminfo").read_text("ascii").splitlines():
        if line.startswith("MemAvailable:"):
            return int(line.split()[1])
    return -1

def read_rss_kib(pid):
    try:
        for line in pathlib.Path("/proc", str(pid), "status").read_text("ascii").splitlines():
            if line.startswith("VmRSS:"):
                return int(line.split()[1])
    except Exception:
        pass
    return -1

def classify_server_log():
    try:
        text = LOG.read_text("utf-8", errors="replace").lower()[-200000:]
    except Exception:
        return "SERVER_LOG_UNAVAILABLE"
    if re.search(r"(invalid|unknown|reject|fail).{0,50}(reality|short.?id|uuid|auth)|(reality|short.?id|uuid|auth).{0,50}(invalid|unknown|reject|fail)", text):
        return "REALITY_AUTH_OR_VERIFICATION_FAILED"
    if re.search(r"(vless|vision|flow).{0,50}(invalid|unknown|reject|fail|unsupported)", text):
        return "VLESS_OR_VISION_REJECTED"
    if re.search(r"(www\.microsoft\.com|handshake target).{0,60}(timeout|unreachable|refused|fail)", text):
        return "HANDSHAKE_TARGET_UNREACHABLE"
    if re.search(r"(connection reset|reset by peer|broken pipe|unexpected eof)", text):
        return "CONNECTION_RESET_OR_EOF"
    if re.search(r"(bind|listen).{0,60}(address already in use|cannot assign|failed|error)", text):
        return "SERVER_BIND_OR_LISTENER_FAILURE"
    if re.search(r"(timeout|timed out|deadline exceeded)", text):
        return "TIMEOUT"
    if not text.strip():
        return "NO_SERVER_ERROR_OBSERVED"
    if "error" not in text and "fatal" not in text:
        return "NO_SERVER_ERROR_OBSERVED"
    return "UNKNOWN_SERVER_ERROR"

def safe_remove(path, allow_unmarked=False):
    if not path.exists() and not path.is_symlink():
        return True
    if path.is_symlink() or not path.is_dir():
        raise GateFailure("RUNTIME_PATH_INVALID")
    marker = path / ".g2c-p1-marker"
    if not marker.exists() and allow_unmarked:
        path.rmdir()
        return not path.exists()
    verify_marked_dir(path)
    shutil.rmtree(path)
    return not path.exists() and not path.is_symlink()

def cleanup():
    failures = []
    if SERVER is not None and SERVER.poll() is None:
        try:
            if exact_server_argv(SERVER.pid):
                SERVER.terminate()
                try:
                    SERVER.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    if exact_server_argv(SERVER.pid):
                        SERVER.kill()
                    SERVER.wait(timeout=3)
            if SERVER.poll() is None:
                failures.append("SERVER_PROCESS_REMAINS")
        except Exception:
            failures.append("SERVER_PROCESS_STOP_FAILED")
    try:
        p14443, p443 = listener_state()
        if p14443:
            failures.append("TCP14443_LISTENER_REMAINS")
        if p443:
            failures.append("TCP443_LISTENER_PRESENT")
    except Exception:
        failures.append("POSTSTOP_LISTENER_READBACK_FAILED")
    server_stopped = SERVER is None or SERVER.poll() is not None
    server_error_class = classify_server_log() if LOG.exists() else "NO_SERVER_ERROR_OBSERVED"
    if RUNTIME_CREATED:
        try:
            if not safe_remove(RUNTIME, allow_unmarked=True):
                failures.append("RUNTIME_DIRECTORY_REMAINS")
        except Exception:
            failures.append("RUNTIME_DIRECTORY_DELETE_FAILED")
    if WORKSPACE_CREATED:
        try:
            if not safe_remove(WORKSPACE, allow_unmarked=True):
                failures.append("WORKSPACE_DIRECTORY_REMAINS")
        except Exception:
            failures.append("WORKSPACE_DIRECTORY_DELETE_FAILED")
    runtime_absent = not RUNTIME.exists() and not RUNTIME.is_symlink()
    workspace_absent = not WORKSPACE.exists() and not WORKSPACE.is_symlink()
    try:
        p14443, p443 = listener_state()
        tcp14443_absent = not p14443
        tcp443_free = not p443
    except Exception:
        tcp14443_absent = False
        tcp443_free = False
    if LOG_HANDLE is not None:
        try:
            LOG_HANDLE.close()
        except Exception:
            failures.append("LOG_HANDLE_CLOSE_FAILED")
    return {
        "status": "cleaned" if not failures else "cleanup_failed",
        "server_process_stopped": server_stopped,
        "tcp14443_absent": tcp14443_absent,
        "tcp443_free": tcp443_free,
        "runtime_absent": runtime_absent,
        "workspace_absent": workspace_absent,
        "server_rss_kib": read_rss_kib(SERVER.pid) if SERVER is not None and SERVER.poll() is None else -1,
        "mem_available_kib_after": mem_available_kib(),
        "server_error_class": server_error_class,
        "cleanup_failures": failures,
    }

def cleanup_stale_exact():
    failures = []
    for path, pid_path in ((RUNTIME, PID_FILE), (WORKSPACE, None)):
        if not path.exists() and not path.is_symlink():
            continue
        try:
            verify_marked_dir(path)
            if path == RUNTIME and pid_path.exists():
                raw = pid_path.read_text("ascii").strip()
                if not raw.isdigit():
                    raise GateFailure("PID_FILE_INVALID")
                pid = int(raw)
                if pathlib.Path("/proc", str(pid)).exists() and not stop_exact_server(pid):
                    raise GateFailure("SERVER_PROCESS_STOP_FAILED")
            if not safe_remove(path):
                raise GateFailure("RUNTIME_REMOVE_FAILED")
        except Exception as exc:
            failures.append(str(exc) if isinstance(exc, GateFailure) else "EXACT_CLEANUP_FAILED")
    try:
        p14443, p443 = listener_state()
    except Exception:
        p14443, p443 = ["unknown"], ["unknown"]
    return {
        "status": "cleaned" if not failures and not p14443 and not p443 else "cleanup_failed",
        "tcp14443_absent": not bool(p14443),
        "tcp443_free": not bool(p443),
        "runtime_absent": not RUNTIME.exists() and not RUNTIME.is_symlink(),
        "workspace_absent": not WORKSPACE.exists() and not WORKSPACE.is_symlink(),
        "cleanup_failures": failures,
    }

def prctl_parent_death():
    libc = ctypes.CDLL(None)
    if libc.prctl(1, signal.SIGTERM, 0, 0, 0) != 0:
        raise OSError("PDEATHSIG_FAILED")
    if os.getppid() == 1:
        os.kill(os.getpid(), signal.SIGTERM)

def main_run():
    global SERVER, LOG_HANDLE, PRIVATE_KEY, PUBLIC_KEY, CLIENT_UUID, SHORT_ID
    global RUNTIME_CREATED, WORKSPACE_CREATED
    if RUNTIME.exists() or RUNTIME.is_symlink() or WORKSPACE.exists() or WORKSPACE.is_symlink():
        raise GateFailure("RUNTIME_PATH_ALREADY_EXISTS")
    create_marked_dir(RUNTIME)
    RUNTIME_CREATED = True
    create_marked_dir(WORKSPACE)
    WORKSPACE_CREATED = True
    os.umask(0o077)
    digest = hashlib.sha256()
    total = 0
    with urllib.request.urlopen(ASSET_URL, timeout=90) as response, open(ARCHIVE, "xb") as output:
        while True:
            chunk = response.read(1024 * 1024)
            if not chunk:
                break
            total += len(chunk)
            if total > 100 * 1024 * 1024:
                raise GateFailure("PINNED_ASSET_SIZE_LIMIT")
            digest.update(chunk)
            output.write(chunk)
        output.flush()
        os.fsync(output.fileno())
    os.chmod(ARCHIVE, 0o600)
    if digest.hexdigest() != EXPECTED_SHA:
        raise GateFailure("PINNED_ASSET_SHA256_MISMATCH")
    extracted = 0
    with gzip.open(ARCHIVE, "rb") as source, open(BINARY, "xb") as output:
        while True:
            chunk = source.read(1024 * 1024)
            if not chunk:
                break
            extracted += len(chunk)
            if extracted > 200 * 1024 * 1024:
                raise GateFailure("PINNED_ASSET_EXPANDED_SIZE_LIMIT")
            output.write(chunk)
        output.flush()
        os.fsync(output.fileno())
    os.chmod(BINARY, 0o700)
    version = subprocess.run([str(BINARY), "-v"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                             text=True, timeout=15, check=False)
    if version.returncode != 0 or "v1.19.31" not in version.stdout:
        raise GateFailure("PINNED_MIHOMO_VERSION_INVALID")
    keypair = subprocess.run([str(BINARY), "generate", "reality-keypair"], stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, text=True, timeout=15, check=False)
    if keypair.returncode != 0:
        raise GateFailure("MIHOMO_REALITY_KEYPAIR_GENERATION_FAILED")
    private_match = re.search(r"(?im)^PrivateKey:\s*([A-Za-z0-9_-]{40,64})\s*$", keypair.stdout)
    public_match = re.search(r"(?im)^PublicKey:\s*([A-Za-z0-9_-]{40,64})\s*$", keypair.stdout)
    keypair_stdout = None
    keypair_stderr = None
    if not private_match or not public_match:
        raise GateFailure("MIHOMO_REALITY_KEYPAIR_OUTPUT_INVALID")
    PRIVATE_KEY = private_match.group(1)
    PUBLIC_KEY = public_match.group(1)
    private_match = None
    public_match = None
    keypair.stdout = None
    keypair.stderr = None
    keypair = None
    emit({"status": "asset_ready", "version": "v1.19.31", "asset_sha256": "PASS", "public_key": PUBLIC_KEY})
    client_line = bytearray(sys.stdin.buffer.readline(4096))
    if not client_line or len(client_line) >= 4096:
        raise GateFailure("CLIENT_PARAMETERS_MISSING")
    client_data = json.loads(client_line.decode("ascii"))
    if set(client_data) != {"uuid", "short_id"}:
        raise GateFailure("CLIENT_PARAMETERS_ALLOWLIST_INVALID")
    CLIENT_UUID = client_data["uuid"]
    SHORT_ID = client_data["short_id"]
    client_data = None
    client_line[:] = b"\x00" * len(client_line)
    client_line = None
    if not re.fullmatch(r"[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}", CLIENT_UUID):
        raise GateFailure("CLIENT_UUID_FORMAT_INVALID")
    if not re.fullmatch(r"[0-9a-f]{16}", SHORT_ID):
        raise GateFailure("CLIENT_SHORT_ID_FORMAT_INVALID")
    config_text = """mode: rule
log-level: warning
ipv6: false
rules:
  - MATCH,DIRECT
listeners:
  - name: g2c-p1-vless-reality
    type: vless
    listen: 24.199.118.137
    port: 443
    users:
      - uuid: {uuid}
        username: r3
        flow: xtls-rprx-vision
    reality-config:
      dest: www.microsoft.com:443
      private-key: {private_key}
      short-id:
        - {short_id}
      server-names:
        - www.microsoft.com
    """.format(uuid=json.dumps(CLIENT_UUID), private_key=json.dumps(PRIVATE_KEY), short_id=json.dumps(SHORT_ID))
    config_bytes = bytearray(config_text.encode("utf-8"))
    exclusive_write(CONFIG, config_bytes, 0o600)
    config_bytes = None
    config_text = None
    PRIVATE_KEY = None
    CLIENT_UUID = None
    SHORT_ID = None
    check = subprocess.run([str(BINARY), "-t", "-d", str(WORKSPACE), "-f", str(CONFIG)],
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=20, check=False)
    config_check_exit = check.returncode
    check.stdout = None
    check.stderr = None
    check = None
    if config_check_exit != 0:
        raise GateFailure("SERVER_CONFIG_CHECK_FAILED")
    LOG_HANDLE = open(LOG, "xb")
    os.chmod(LOG, 0o600)
    SERVER = subprocess.Popen([str(BINARY), "-d", str(WORKSPACE), "-f", str(CONFIG)],
                              stdin=subprocess.DEVNULL, stdout=LOG_HANDLE, stderr=subprocess.STDOUT,
                              close_fds=True, cwd=str(WORKSPACE), preexec_fn=prctl_parent_death)
    exclusive_write(PID_FILE, (str(SERVER.pid) + "\n").encode("ascii"), 0o600)
    ready = False
    deadline = time.monotonic() + 15
    while time.monotonic() < deadline:
        if SERVER.poll() is not None:
            raise GateFailure("MIHOMO_SERVER_EXITED_BEFORE_LISTEN")
        p14443, p443 = listener_state()
        if not p14443 and p443 == ["24.199.118.137:443"]:
            ready = True
            break
        time.sleep(0.2)
    if not ready:
        raise GateFailure("PUBLIC_LISTENER_BOUNDARY_INVALID")
    owned_listeners = server_owned_listener_state(SERVER.pid)
    if owned_listeners != ["TCP|24.199.118.137:443"]:
        raise GateFailure("SERVER_LISTENER_SCOPE_INVALID")
    emit({"status": "ready", "server_config_check": "PASS", "public_listener": "24.199.118.137:443",
          "tcp_14443_listeners": 0, "server_owned_listener_count": len(owned_listeners),
          "public_tcp443_listener": "YES", "server_rss_kib": read_rss_kib(SERVER.pid)})
    for line in sys.stdin:
        if line.strip() == "CLEANUP":
            break
    record = cleanup()
    emit(record)
    return 0 if record["status"] == "cleaned" else 4

def main():
    if not re.fullmatch(r"[0-9a-f]{32}", RUN_ID):
        emit({"status": "failed", "phase": "RUN_ID_INVALID"})
        return 2
    if MODE == "cleanup":
        emit(cleanup_stale_exact())
        return 0
    try:
        main_run()
        return 0
    except GateFailure as exc:
        cleanup_record = cleanup()
        emit({"status": "failed", "phase": str(exc), "cleanup": cleanup_record})
        return 3
    except Exception:
        cleanup_record = cleanup()
        emit({"status": "failed", "phase": "UNEXPECTED_REMOTE_FAILURE", "cleanup": cleanup_record})
        return 3

if __name__ == "__main__":
    sys.exit(main())
'@
}

function New-R3RemoteCommand {
    param([Parameter(Mandatory = $true)][ValidateSet('run', 'cleanup')][string]$Mode)
    $sourceBytes = [Text.UTF8Encoding]::new($false).GetBytes((Get-R3RemoteSupervisorSource))
    try { $encoded = [Convert]::ToBase64String($sourceBytes) }
    finally { [Array]::Clear($sourceBytes, 0, $sourceBytes.Length) }
    return "python3 -c `"exec(__import__('base64').b64decode('$encoded'))`" $($script:runId) $Mode"
}

function Start-R3RemoteSupervisor {
    $psi = New-R3SshStartInfo -RemoteCommand (New-R3RemoteCommand -Mode 'run')
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $psi
    [void]$process.Start()
    $script:remoteStarted = $true
    $script:remoteStderrTask = $process.StandardError.ReadToEndAsync()
    $script:remoteProcess = $process
    return $process
}

function Read-R3RemoteJsonLine {
    param([Parameter(Mandatory = $true)][Diagnostics.Process]$Process, [int]$TimeoutSeconds = 120)
    $task = $Process.StandardOutput.ReadLineAsync()
    if (-not $task.Wait([TimeSpan]::FromSeconds($TimeoutSeconds))) { throw 'REMOTE_SUPERVISOR_RESPONSE_TIMEOUT' }
    $line = $task.GetAwaiter().GetResult()
    Assert-R3 (-not [string]::IsNullOrWhiteSpace($line)) 'REMOTE_SUPERVISOR_RESPONSE_MISSING'
    try { return ($line | ConvertFrom-Json -AsHashtable -ErrorAction Stop) }
    catch { throw 'REMOTE_SUPERVISOR_RESPONSE_INVALID' }
}

function New-R3OwnerOnlyAcl {
    param([switch]$Directory)
    if ($Directory) { $acl = [Security.AccessControl.DirectorySecurity]::new() }
    else { $acl = [Security.AccessControl.FileSecurity]::new() }
    $acl.SetOwner($script:ownerSid)
    $acl.SetAccessRuleProtection($true, $false)
    $inheritance = if ($Directory) {
        [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    } else { [Security.AccessControl.InheritanceFlags]::None }
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid, [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance, [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-R3OwnerOnlyAcl {
    param([Parameter(Mandatory = $true)][string]$Path, [switch]$Directory)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R3 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'CLIENT_RUNTIME_REPARSE_POINT'
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-R3 $acl.AreAccessRulesProtected 'CLIENT_RUNTIME_ACL_INHERITANCE_ENABLED'
    $actualOwner = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate([Security.Principal.SecurityIdentifier]).Value
    Assert-R3 ($actualOwner -eq $script:ownerSid.Value) 'CLIENT_RUNTIME_ACL_OWNER_INVALID'
    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    Assert-R3 ($rules.Count -gt 0) 'CLIENT_RUNTIME_ACL_RULES_MISSING'
    $rights = [long]0
    foreach ($rule in $rules) {
        Assert-R3 (-not $rule.IsInherited) 'CLIENT_RUNTIME_ACL_INHERITED_RULE_PRESENT'
        Assert-R3 ($rule.IdentityReference.Value -eq $script:ownerSid.Value) 'CLIENT_RUNTIME_ACL_ALLOWLIST_INVALID'
        Assert-R3 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'CLIENT_RUNTIME_ACL_DENY_RULE_PRESENT'
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $rights = $rights -bor [long]$rule.FileSystemRights
        }
        if (-not $Directory) {
            Assert-R3 ($rule.InheritanceFlags -eq [Security.AccessControl.InheritanceFlags]::None -and
                       $rule.PropagationFlags -eq [Security.AccessControl.PropagationFlags]::None) 'CLIENT_RUNTIME_FILE_INHERITANCE_FLAGS_INVALID'
        }
    }
    $fullControl = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-R3 (($rights -band $fullControl) -eq $fullControl) 'CLIENT_RUNTIME_OWNER_FULLCONTROL_MISSING'
}

function New-R3ClientRuntime {
    param([Parameter(Mandatory = $true)][string]$Uuid, [Parameter(Mandatory = $true)][string]$PublicKey,
          [Parameter(Mandatory = $true)][string]$ShortId)
    if (-not ('G2cR3Native' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class G2cR3Native {
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool CreateDirectory(string path, IntPtr securityAttributes);
}
'@
    }
    [void][IO.Directory]::CreateDirectory($script:runtimeRoot)
    $runtimeRootItem = Get-Item -LiteralPath $script:runtimeRoot -Force -ErrorAction Stop
    Assert-R3 (($runtimeRootItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'CLIENT_RUNTIME_ROOT_REPARSE_POINT'
    if (-not [G2cR3Native]::CreateDirectory($script:runtimeDirectory, [IntPtr]::Zero)) {
        throw 'CLIENT_RUNTIME_DIRECTORY_CREATE_EXCLUSIVE_FAILED'
    }
    $script:runtimeDirectoryCreated = $true
    Set-Acl -LiteralPath $script:runtimeDirectory -AclObject (New-R3OwnerOnlyAcl -Directory) -ErrorAction Stop
    Assert-R3OwnerOnlyAcl -Path $script:runtimeDirectory -Directory
    $yaml = @"
port: $($script:localProxyPort)
allow-lan: false
bind-address: 127.0.0.1
mode: rule
log-level: warning
tun:
  enable: false
proxies:
  - name: G2C-P1-REALITY
    type: vless
    server: $($script:serverPublicIp)
    port: 443
    uuid: $Uuid
    udp: false
    flow: xtls-rprx-vision
    network: tcp
    tls: true
    servername: www.microsoft.com
    client-fingerprint: chrome
    reality-opts:
      public-key: $PublicKey
      short-id: $ShortId
proxy-groups:
  - name: G2C-P1-TEST
    type: select
    proxies:
      - G2C-P1-REALITY
rules:
  - MATCH,G2C-P1-TEST
"@
    $stream = [IO.File]::Open($script:runtimeConfigPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    $stream.Dispose()
    $script:runtimeConfigCreated = $true
    Set-Acl -LiteralPath $script:runtimeConfigPath -AclObject (New-R3OwnerOnlyAcl) -ErrorAction Stop
    Assert-R3OwnerOnlyAcl -Path $script:runtimeConfigPath
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($yaml)
    try {
        $stream = [IO.File]::Open($script:runtimeConfigPath, [IO.FileMode]::Open, [IO.FileAccess]::Write, [IO.FileShare]::None)
        try { $stream.Write($bytes, 0, $bytes.Length); $stream.Flush($true) }
        finally { $stream.Dispose() }
    }
    finally {
        [Array]::Clear($bytes, 0, $bytes.Length)
        $bytes = $null
        $yaml = $null
    }
    Assert-R3OwnerOnlyAcl -Path $script:runtimeConfigPath
}

function Start-R3SuppressedProcess {
    param([Parameter(Mandatory = $true)][string]$FilePath,
          [Parameter(Mandatory = $true)][AllowEmptyString()][string[]]$Arguments)
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $FilePath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    foreach ($arg in $Arguments) { [void]$psi.ArgumentList.Add($arg) }
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $psi
    [void]$process.Start()
    return [pscustomobject]@{
        Process = $process
        StdoutTask = $process.StandardOutput.ReadToEndAsync()
        StderrTask = $process.StandardError.ReadToEndAsync()
    }
}

function Test-R3PublicListenerTcp {
    $client = [Net.Sockets.TcpClient]::new()
    try {
        $async = $client.BeginConnect($script:serverPublicIp, $script:serverPort, $null, $null)
        if (-not $async.AsyncWaitHandle.WaitOne(5000)) { return $false }
        $client.EndConnect($async)
        return $client.Connected
    }
    catch { return $false }
    finally { $client.Dispose() }
}

function Start-R3ClientMihomo {
    $script:clientCapture = Start-R3SuppressedProcess -FilePath $script:mihomoPath -Arguments @('-d', $script:runtimeDirectory, '-f', $script:runtimeConfigPath)
    $script:clientProcess = $script:clientCapture.Process
    $deadline = [DateTime]::UtcNow.AddSeconds(12)
    while ([DateTime]::UtcNow -lt $deadline) {
        if ($script:clientProcess.HasExited) { throw 'CLIENT_MIHOMO_EXITED_BEFORE_PROXY_READY' }
        $listeners = @(Get-NetTCPConnection -State Listen -ErrorAction Stop | Where-Object { [int]$_.OwningProcess -eq $script:clientProcess.Id })
        $udp = @(Get-NetUDPEndpoint -ErrorAction Stop | Where-Object { [int]$_.OwningProcess -eq $script:clientProcess.Id })
        if ($listeners.Count -gt 0) {
            Assert-R3 ($listeners.Count -eq 1 -and [int]$listeners[0].LocalPort -eq $script:localProxyPort -and
                       $listeners[0].LocalAddress -eq '127.0.0.1' -and
                       [int]$listeners[0].OwningProcess -eq $script:clientProcess.Id) 'CLIENT_PROXY_BINDING_INVALID'
            Assert-R3 ($udp.Count -eq 0) 'CLIENT_UDP_LISTENER_UNEXPECTED'
            $script:clientProxyReady = $true
            return
        }
        Start-Sleep -Milliseconds 200
    }
    throw 'CLIENT_PROXY_NOT_READY'
}

function Invoke-R3SingleRequest {
    Assert-R3 ($script:preflightPassed -and $script:routeAdded) 'OPENAI_REQUEST_PRECONDITIONS_NOT_MET'
    $currentOuterRoute = Assert-P1PhysicalPublicRoute
    Assert-R3 ($script:publicListenerTcpPassed -and $script:clientConfigCheckPassed -and
               $script:clientProxyReady -and $null -ne $currentOuterRoute) 'OPENAI_REQUEST_PRECONDITIONS_NOT_MET'
    Assert-R3 (-not $script:requestBudgetConsumed -and $script:requestCount -eq 0) 'OPENAI_REQUEST_BUDGET_ALREADY_CONSUMED'
    $args = @(
        '--ipv4', '--http1.1', '--proxy', "http://127.0.0.1:$($script:localProxyPort)", '--noproxy', '',
        '--connect-timeout', '10', '--max-time', '30', '--silent', '--show-error',
        '--output', 'NUL', '--write-out', '%{http_code}|%{time_total}|%{time_connect}|%{time_appconnect}',
        $script:endpoint
    )
    $curlPath = (Get-Command curl.exe -ErrorAction Stop).Source
    $startInfo = [Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $curlPath
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    foreach ($arg in $args) { [void]$startInfo.ArgumentList.Add([string]$arg) }
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    try { [void]$process.Start() }
    catch { $process.Dispose(); throw 'CURL_PROCESS_START_FAILED' }
    $script:requestBudgetConsumed = $true
    $script:requestCount = 1
    $script:curlProcess = [pscustomobject]@{
        Process = $process
        StdoutTask = $null
        StderrTask = $null
    }
    $script:curlProcess.StdoutTask = $process.StandardOutput.ReadToEndAsync()
    $script:curlProcess.StderrTask = $process.StandardError.ReadToEndAsync()
    if (-not $script:curlProcess.Process.WaitForExit(35000)) {
        $script:curlProcess.Process.Kill()
        [void]$script:curlProcess.Process.WaitForExit(5000)
        throw 'OPENAI_CANARY_REQUEST_TIMEOUT'
    }
    $curlText = $script:curlProcess.StdoutTask.GetAwaiter().GetResult().Trim()
    $script:curlErrorText = $script:curlProcess.StderrTask.GetAwaiter().GetResult()
    $script:curlExit = [int]$script:curlProcess.Process.ExitCode
    if ($curlText -match '^(?<status>\d{3})\|(?<total>[0-9.]+)\|(?<connect>[0-9.]+)\|(?<appconnect>[0-9.]+)$') {
        $script:httpStatus = [int]$Matches.status
        $script:curlTotal = $Matches.total
        $script:curlConnect = $Matches.connect
        $script:curlAppConnect = $Matches.appconnect
    }
    $curlText = $null
    $script:clientErrorClass = Get-R3ClientErrorClass -Text $script:curlErrorText -ExitCode $script:curlExit
    $script:curlErrorText = $null
}

function Get-R3ClientErrorClass {
    param([AllowEmptyString()][string]$Text, [int]$ExitCode)
    $value = if ($null -eq $Text) { '' } else { $Text.ToLowerInvariant() }
    if ($ExitCode -eq 0 -and $script:httpStatus -eq 401) { return 'NONE_OBSERVED' }
    if ($ExitCode -eq 28 -or $value -match '(timeout|timed out|deadline exceeded)') { return 'TIMEOUT' }
    if ($value -match '(connection reset|reset by peer|unexpected eof|broken pipe)') { return 'CONNECTION_RESET_OR_EOF' }
    if ($value -match '(failed to connect|could not connect|proxy.*connect|connection refused)') { return 'CLIENT_PROXY_OR_SERVER_CONNECT_FAILED' }
    if ($ExitCode -eq 35 -or $value -match '(tls.{0,20}handshake|ssl_connect|handshake failure)') { return 'TLS_HANDSHAKE_FAILURE' }
    return 'UNKNOWN_CLIENT_FAILURE'
}

function Stop-R3ClientProcess {
    if ($null -eq $script:clientProcess) { return }
    try {
        if (-not $script:clientProcess.HasExited) {
            $live = Get-Process -Id $script:clientProcess.Id -ErrorAction Stop
            Assert-R3 ($live.Path -eq $script:mihomoPath) 'CLIENT_MIHOMO_PROCESS_IDENTITY_CHANGED'
            $script:clientProcess.Kill()
            if (-not $script:clientProcess.WaitForExit(10000)) { throw 'CLIENT_MIHOMO_STOP_TIMEOUT' }
        }
        Assert-R3 $script:clientProcess.HasExited 'CLIENT_MIHOMO_PROCESS_REMAINS'
        if ($null -ne $script:clientCapture) {
            $stdout = $script:clientCapture.StdoutTask.GetAwaiter().GetResult()
            $stderr = $script:clientCapture.StderrTask.GetAwaiter().GetResult()
            $script:clientLogText = [string]$stdout + "`n" + [string]$stderr
            if ($script:clientErrorClass -eq 'NOT_RUN' -and $script:requestCount -eq 1) {
                $script:clientErrorClass = Get-R3ClientErrorClass -Text $script:clientLogText -ExitCode $script:clientProcess.ExitCode
            }
            $stdout = $null
            $stderr = $null
            $script:clientLogText = $null
            $script:clientCapture = $null
        }
    }
    catch { $script:cleanupFailures.Add('CLIENT_MIHOMO_STOP_FAILED') }
}

function Invoke-R3RemoteCleanup {
    if ($null -eq $script:remoteProcess -or -not $script:remoteStarted) { return }
    try {
        if (-not $script:remoteProcess.HasExited) {
            if ($script:remoteConfigured) {
                $cleanupBytes = [Text.Encoding]::ASCII.GetBytes("CLEANUP`n")
                $script:remoteProcess.StandardInput.BaseStream.Write($cleanupBytes, 0, $cleanupBytes.Length)
                $script:remoteProcess.StandardInput.BaseStream.Flush()
                [Array]::Clear($cleanupBytes, 0, $cleanupBytes.Length)
            }
            $script:remoteProcess.StandardInput.Close()
            if (-not $script:remoteProcess.WaitForExit(25000)) {
                $script:remoteProcess.Kill()
                [void]$script:remoteProcess.WaitForExit(5000)
                throw 'REMOTE_SUPERVISOR_STOP_TIMEOUT'
            }
        }
        $stdout = $script:remoteProcess.StandardOutput.ReadToEnd()
        $stderr = if ($null -ne $script:remoteStderrTask) { $script:remoteStderrTask.GetAwaiter().GetResult() } else { '' }
        $null = $stderr
        foreach ($line in ($stdout -split "\r?\n")) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            try {
                $record = $line | ConvertFrom-Json -AsHashtable -ErrorAction Stop
                if ($record['server_error_class']) { $script:serverErrorClass = [string]$record['server_error_class'] }
                if ($record['status'] -in @('cleaned', 'cleanup_failed')) { $script:remoteCleanup = $record }
                if ($record['cleanup'] -and $record['cleanup']['status']) { $script:remoteCleanup = $record['cleanup'] }
            }
            catch { }
        }
        Assert-R3 ($script:remoteProcess.HasExited) 'REMOTE_SUPERVISOR_PROCESS_REMAINS'
        Assert-R3 ($script:remoteProcess.ExitCode -eq 0) 'REMOTE_SUPERVISOR_EXIT_INVALID'
        Assert-R3 ($null -ne $script:remoteCleanup -and $script:remoteCleanup['status'] -eq 'cleaned' -and
                   $script:remoteCleanup['server_process_stopped'] -and $script:remoteCleanup['tcp14443_absent'] -and
                   $script:remoteCleanup['tcp443_free'] -and $script:remoteCleanup['runtime_absent'] -and
                   $script:remoteCleanup['workspace_absent'] -and @($script:remoteCleanup['cleanup_failures']).Count -eq 0) 'REMOTE_CLEANUP_NOT_PROVEN'
    }
    catch { $script:cleanupFailures.Add('REMOTE_CLEANUP_NOT_PROVEN') }
}

function Remove-R3LocalRuntimeExact {
    if (-not $script:runtimeDirectoryCreated) { return }
    try {
        if ($script:runtimeConfigCreated -and (Test-Path -LiteralPath $script:runtimeConfigPath)) {
            [IO.File]::Delete($script:runtimeConfigPath)
        }
        if ($script:runtimeDirectoryCreated -and (Test-Path -LiteralPath $script:runtimeDirectory)) {
            $item = Get-Item -LiteralPath $script:runtimeDirectory -Force -ErrorAction Stop
            Assert-R3 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'CLIENT_RUNTIME_CLEANUP_REPARSE_POINT'
            [IO.Directory]::Delete($script:runtimeDirectory, $true)
        }
        Assert-R3 (-not (Test-Path -LiteralPath $script:runtimeDirectory)) 'CLIENT_RUNTIME_PATH_REMAINS'
    }
    catch { $script:cleanupFailures.Add('CLIENT_RUNTIME_DELETE_FAILED') }
}

function Get-P1InteropResult {
    param([Parameter(Mandatory = $true)][bool]$CleanupPass)
    if (-not $CleanupPass) { return 'UNKNOWN' }
    if ($script:requestCount -eq 1 -and $script:curlExit -eq 0 -and $script:httpStatus -eq 401) { return 'PASS' }
    if ($script:publicListenerTcpAttempted -and -not $script:publicListenerTcpPassed) { return 'FAIL' }
    if ($script:requestCount -eq 1 -and $script:clientErrorClass -in @('TIMEOUT','CONNECTION_RESET_OR_EOF','CLIENT_PROXY_OR_SERVER_CONNECT_FAILED','TLS_HANDSHAKE_FAILURE')) { return 'FAIL' }
    return 'UNKNOWN'
}

function Invoke-R3EmergencyRemoteCleanup {
    try {
        $command = New-R3RemoteCommand -Mode cleanup
        $process = [Diagnostics.Process]::new()
        $process.StartInfo = New-R3SshStartInfo -RemoteCommand $command
        [void]$process.Start()
        $process.StandardInput.Close()
        $outTask = $process.StandardOutput.ReadToEndAsync()
        $errTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(20000)) { $process.Kill(); [void]$process.WaitForExit(3000); return $false }
        $stdout = $outTask.GetAwaiter().GetResult()
        $stderr = $errTask.GetAwaiter().GetResult()
        $null = $stderr
        $record = $stdout | ConvertFrom-Json -AsHashtable -ErrorAction Stop
        return ($process.ExitCode -eq 0 -and $record['status'] -eq 'cleaned' -and
                $record['tcp14443_absent'] -and $record['tcp443_free'] -and
                $record['runtime_absent'] -and $record['workspace_absent'])
    }
    catch { return $false }
}

try {
    $script:phase = 'PRECHECK_OWNER_TOKEN'
    $script:integrityRid = Assert-P1ExecutionToken
    $script:phase = 'PRECHECK_CANONICAL_SOURCE'
    Assert-P1CanonicalSource
    if ($CanonicalSourceOnly) {
        $script:phase = 'CANONICAL_SOURCE_ONLY_PASS'
    } else {
    $script:ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
    $script:runId = [Guid]::NewGuid().ToString('N')
    $script:identityPath = Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'
    $script:knownHostsPath = Join-Path $env:USERPROFILE '.ssh\known_hosts'
    $script:runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
    $script:runtimeDirectory = Join-Path $script:runtimeRoot ('g2c-reality-public-p1-' + $script:runId)
    $script:runtimeConfigPath = Join-Path $script:runtimeDirectory 'mihomo.yaml'
    $script:sshPath = (Get-Command ssh.exe -ErrorAction Stop).Source
    $script:phase = 'PRECHECK_WINDOWS'
    Assert-R3 (Test-Path -LiteralPath $script:identityPath -PathType Leaf) 'SSH_IDENTITY_MISSING'
    Assert-R3 (Test-Path -LiteralPath $script:knownHostsPath -PathType Leaf) 'SSH_KNOWN_HOSTS_MISSING'
    Assert-R3 (Test-Path -LiteralPath $script:mihomoPath -PathType Leaf) 'WINDOWS_MIHOMO_BINARY_MISSING'
    $script:localBefore = Get-R3LocalSnapshot
    Assert-R3LocalBaseline -Snapshot $script:localBefore -Prefix 'PRECHECK'
    $script:physicalEgress = $script:localBefore.PhysicalEgress
    $script:routeBefore = $script:localBefore.PublicRoute
    if ($LocalPreflightOnly) {
        $script:phase = 'LOCAL_PREFLIGHT_ONLY_PASS'
    } else {
    $script:phase = 'PRECHECK_VPS'
    $script:remoteBefore = Invoke-R3RemoteReadOnlyProbe -Command (Get-R3RemotePreflightCommand)
    Assert-R3RemoteBaseline -Values $script:remoteBefore
    $script:preflightPassed = $true
    $script:phase = 'CREATE_EXACT_PHYSICAL_EGRESS_ROUTE'
    Add-P1TemporaryRoute
    $script:phase = 'REMOTE_ASSET_AND_KEYPAIR'
    $script:remoteProcess = Start-R3RemoteSupervisor
    $assetRecord = Read-R3RemoteJsonLine -Process $script:remoteProcess -TimeoutSeconds 150
    Assert-R3 ($assetRecord['status'] -eq 'asset_ready' -and $assetRecord['version'] -eq 'v1.19.31' -and
               $assetRecord['asset_sha256'] -eq 'PASS') 'PINNED_MIHOMO_ASSET_NOT_VERIFIED'
    $script:assetHashPass = $true
    $script:publicKey = [string]$assetRecord['public_key']
    Assert-R3 ($script:publicKey -match '^[A-Za-z0-9_-]{40,64}$') 'REALITY_PUBLIC_KEY_FORMAT_INVALID'
    $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
    $script:shortIdBytes = [byte[]]::new(8)
    $rng.GetBytes($script:shortIdBytes)
    $rng.Dispose()
    $script:uuid = [Guid]::NewGuid().ToString()
    $script:shortId = [Convert]::ToHexString($script:shortIdBytes).ToLowerInvariant()
    [Array]::Clear($script:shortIdBytes, 0, $script:shortIdBytes.Length)
    $script:shortIdBytes = $null
    $clientPayload = [ordered]@{ uuid = $script:uuid; short_id = $script:shortId } | ConvertTo-Json -Compress
    $payloadBytes = [Text.UTF8Encoding]::new($false).GetBytes($clientPayload + "`n")
    try {
        $script:remoteProcess.StandardInput.BaseStream.Write($payloadBytes, 0, $payloadBytes.Length)
        $script:remoteProcess.StandardInput.BaseStream.Flush()
        $script:remoteConfigured = $true
    }
    finally {
        [Array]::Clear($payloadBytes, 0, $payloadBytes.Length)
        $payloadBytes = $null
        $clientPayload = $null
    }
    $script:phase = 'SERVER_CONFIG_AND_LISTENER'
    $readyRecord = Read-R3RemoteJsonLine -Process $script:remoteProcess -TimeoutSeconds 25
    Assert-R3 ($readyRecord['status'] -eq 'ready' -and $readyRecord['server_config_check'] -eq 'PASS' -and
               $readyRecord['public_listener'] -eq '24.199.118.137:443' -and $readyRecord['public_tcp443_listener'] -eq 'YES' -and
               [int]$readyRecord['server_owned_listener_count'] -eq 1 -and
               [int]$readyRecord['tcp_14443_listeners'] -eq 0) 'MIHOMO_PUBLIC_SERVER_READY_NOT_PROVEN'
    $script:readyRecord = $readyRecord
    $script:serverRssAtReady = [int]$readyRecord['server_rss_kib']
    $script:phase = 'PUBLIC_TCP443_REACHABILITY'
    $null = Assert-P1PhysicalPublicRoute
    $script:publicListenerTcpAttempted = $true
    $script:publicListenerTcpPassed = Test-R3PublicListenerTcp
    Assert-R3 $script:publicListenerTcpPassed 'WINDOWS_PUBLIC_TCP443_UNREACHABLE'
    $script:phase = 'CLIENT_RUNTIME_AND_CONFIG'
    New-R3ClientRuntime -Uuid $script:uuid -PublicKey $script:publicKey -ShortId $script:shortId
    $script:uuid = $null
    $script:shortId = $null
    $configCheck = Start-R3SuppressedProcess -FilePath $script:mihomoPath -Arguments @('-t', '-d', $script:runtimeDirectory, '-f', $script:runtimeConfigPath)
    if (-not $configCheck.Process.WaitForExit(20000)) {
        $configCheck.Process.Kill()
        [void]$configCheck.Process.WaitForExit(5000)
        throw 'CLIENT_MIHOMO_CONFIG_CHECK_TIMEOUT'
    }
    $configCheckOut = $configCheck.StdoutTask.GetAwaiter().GetResult()
    $configCheckErr = $configCheck.StderrTask.GetAwaiter().GetResult()
    Assert-R3 ($configCheck.Process.ExitCode -eq 0) 'CLIENT_MIHOMO_CONFIG_CHECK_FAILED'
    $script:clientConfigCheckPassed = $true
    $configCheckOut = $null
    $configCheckErr = $null
    $script:phase = 'CLIENT_MIHOMO_START_AND_PROXY_READY'
    Start-R3ClientMihomo
    $script:phase = 'ONE_OPENAI_REQUEST'
    Invoke-R3SingleRequest
    $script:implementationResult = 'UNKNOWN'
    }
    }
}
catch {
    $script:failureCode = Resolve-R3FailureCode -Record $_
}
finally {
    $script:resultPhase = $script:phase
    $script:phase = 'CLEANUP'
    if ($null -ne $script:curlProcess -and $null -ne $script:curlProcess.Process) {
        try {
            if (-not $script:curlProcess.Process.HasExited) {
                $script:curlProcess.Process.Kill()
                [void]$script:curlProcess.Process.WaitForExit(5000)
            }
        } catch { $script:cleanupFailures.Add('CURL_PROCESS_STOP_FAILED') }
    }
    Stop-R3ClientProcess
    Invoke-R3RemoteCleanup
    if ($script:remoteStarted -and ($null -eq $script:remoteCleanup -or $script:remoteCleanup['status'] -ne 'cleaned')) {
        if (Invoke-R3EmergencyRemoteCleanup) { $script:remoteCleanup = @{ status='cleaned'; server_process_stopped=$true; tcp14443_absent=$true; tcp443_free=$true; runtime_absent=$true; workspace_absent=$true; cleanup_failures=@() } }
    }
    Remove-R3LocalRuntimeExact
    Remove-P1TemporaryRouteExact
    $script:uuid = $null
    $script:shortId = $null
    $script:publicKey = $null
    $script:curlErrorText = $null
    $script:clientLogText = $null
    if ($null -ne $script:shortIdBytes) { [Array]::Clear($script:shortIdBytes, 0, $script:shortIdBytes.Length); $script:shortIdBytes = $null }
    if ($script:preflightPassed) {
        try { $script:localAfter = Get-R3LocalSnapshot } catch { $script:cleanupFailures.Add('LOCAL_POSTCLEANUP_READBACK_FAILED') }
        if ($null -ne $script:remoteBefore) {
            try { $script:remoteAfter = Invoke-R3RemoteReadOnlyProbe -Command (Get-R3RemotePreflightCommand) }
            catch { $script:cleanupFailures.Add('VPS_POSTCLEANUP_READBACK_FAILED') }
        }
    }
}

$script:roundFinishedAt = [DateTime]::UtcNow
$script:implementationResult = 'UNKNOWN'
$localBaselineUnchanged = $false
if ($null -ne $script:localBefore -and $null -ne $script:localAfter) {
    $localBaselineUnchanged = ($script:localBefore.WireGuardManager -eq $script:localAfter.WireGuardManager -and
        $script:localBefore.WireGuardTunnel -eq $script:localAfter.WireGuardTunnel -and
        $script:localBefore.WireGuardAdapterStatus -eq $script:localAfter.WireGuardAdapterStatus -and
        $script:localBefore.WireGuardIfIndex -eq $script:localAfter.WireGuardIfIndex -and
        $script:localBefore.ControlRouteAdapter -eq $script:localAfter.ControlRouteAdapter -and
        $script:localBefore.ControlRouteIfIndex -eq $script:localAfter.ControlRouteIfIndex -and
        $script:localBefore.PublicRoute.InterfaceAlias -ceq $script:localAfter.PublicRoute.InterfaceAlias -and
        $script:localBefore.PublicRoute.InterfaceIndex -eq $script:localAfter.PublicRoute.InterfaceIndex -and
        $script:localBefore.PublicRoute.NextHop -ceq $script:localAfter.PublicRoute.NextHop -and
        $script:localBefore.PhysicalEgress.InterfaceAlias -ceq $script:localAfter.PhysicalEgress.InterfaceAlias -and
        $script:localBefore.PhysicalEgress.InterfaceIndex -eq $script:localAfter.PhysicalEgress.InterfaceIndex -and
        $script:localBefore.PhysicalEgress.Gateway -ceq $script:localAfter.PhysicalEgress.Gateway -and
        $script:localBefore.PhysicalEgress.SourceIPv4 -ceq $script:localAfter.PhysicalEgress.SourceIPv4 -and
        $script:localAfter.ActiveOwnerRouteCount -eq 0 -and $script:localAfter.PersistentOwnerRouteCount -eq 0 -and
        (($script:localBefore.WireGuardSplitRoutes -join ';') -ceq ($script:localAfter.WireGuardSplitRoutes -join ';')) -and
        $script:localBefore.ProxyState -ceq $script:localAfter.ProxyState -and
        $script:localBefore.WinHttpText -ceq $script:localAfter.WinHttpText -and
        $script:localBefore.WinHttpDirect -eq $script:localAfter.WinHttpDirect -and
        (($script:localBefore.TunMatches -join ';') -ceq ($script:localAfter.TunMatches -join ';')) -and
        $script:localAfter.RuntimeResidue.Count -eq 0 -and
        (($script:localBefore.MihomoProcesses -join ';') -ceq ($script:localAfter.MihomoProcesses -join ';')) -and
        $script:localAfter.TestMihomoBinaryProcessCount -eq 0 -and
        $script:localAfter.LocalProxyTcpListeners -eq 0 -and $script:localAfter.LocalProxyUdpListeners -eq 0)
}
$remoteProductionPreserved = $false
if ($null -ne $script:remoteBefore -and $null -ne $script:remoteAfter) {
    $remoteProductionPreserved = ($script:remoteAfter['HOSTNAME'] -eq $script:expectedHostname -and
        $script:remoteAfter['WG_SERVICE'] -eq 'active' -and $script:remoteAfter['HY2_SERVICE'] -eq 'active' -and
        [int]$script:remoteAfter['PUBLIC_IP_MATCH_COUNT'] -eq [int]$script:remoteBefore['PUBLIC_IP_MATCH_COUNT'] -and
        [int]$script:remoteAfter['UDP_51820'] -ge 1 -and [int]$script:remoteAfter['UDP_8443'] -ge 1 -and
        $script:remoteAfter['DEFAULT_ROUTE'] -ceq $script:remoteBefore['DEFAULT_ROUTE'] -and
        $script:remoteAfter['WG_ROUTE_COUNT'] -eq $script:remoteBefore['WG_ROUTE_COUNT'] -and
        $script:remoteAfter['IP_FORWARD'] -eq $script:remoteBefore['IP_FORWARD'] -and
        [int]$script:remoteAfter['TCP_14443'] -eq 0 -and [int]$script:remoteAfter['TCP_443'] -eq 0 -and
        [int]$script:remoteAfter['G2C_RUNTIME_RESIDUE'] -eq 0 -and
        $script:remoteAfter['UFW_STATUS'] -ceq $script:remoteBefore['UFW_STATUS'] -and
        $script:remoteAfter['UFW_TCP443_ALLOWED'] -ceq $script:remoteBefore['UFW_TCP443_ALLOWED'] -and
        $script:remoteAfter['IPTABLES_BACKEND'] -ceq $script:remoteBefore['IPTABLES_BACKEND'] -and
        $script:remoteAfter['NFT_INPUT_POLICY'] -ceq $script:remoteBefore['NFT_INPUT_POLICY'] -and
        [int]$script:remoteAfter['NFT_TCP443_BLOCK_COUNT'] -eq [int]$script:remoteBefore['NFT_TCP443_BLOCK_COUNT'])
}
$remoteCleanupPass = ($null -ne $script:remoteCleanup -and $script:remoteCleanup['status'] -eq 'cleaned' -and
    $script:remoteCleanup['server_process_stopped'] -and $script:remoteCleanup['tcp14443_absent'] -and
    $script:remoteCleanup['tcp443_free'] -and $script:remoteCleanup['runtime_absent'] -and
    $script:remoteCleanup['workspace_absent'] -and @($script:remoteCleanup['cleanup_failures']).Count -eq 0)
$clientStopped = ($null -eq $script:clientProcess -or $script:clientProcess.HasExited)
$localRuntimeDeleted = ($null -eq $script:runtimeDirectory -or -not (Test-Path -LiteralPath $script:runtimeDirectory))
if ($script:preflightPassed -and -not $script:remoteStarted) { $remoteCleanupPass = $true }
$mutationStarted = ($script:routeMutationAttempted -or $script:remoteStarted -or $script:runtimeDirectoryCreated)
$cleanupPass = if (-not $mutationStarted) {
    $true
} else {
    ($script:cleanupFailures.Count -eq 0 -and $clientStopped -and $localRuntimeDeleted -and $remoteCleanupPass -and
     $script:routeRemoved -and $localBaselineUnchanged -and $remoteProductionPreserved)
}
if (-not $cleanupPass -and $null -eq $script:failureCode) { $script:failureCode = 'CLEANUP_OR_BASELINE_READBACK_FAILED' }
$script:implementationResult = Get-P1InteropResult -CleanupPass $cleanupPass
$elapsed = $script:roundFinishedAt - $script:roundStartedAt
$localReadbackAvailable = ($null -ne $script:localBefore -and $null -ne $script:localAfter)
$remoteReadbackAvailable = ($null -ne $script:remoteBefore -and $null -ne $script:remoteAfter)
$proxyUnchanged = 'NOT_READ'
$winHttpUnchanged = 'NOT_READ'
$tunUnchanged = 'NOT_READ'
$wgHy2Preserved = 'NOT_READ'
if ($localReadbackAvailable) {
    $proxyUnchanged = (($script:localBefore.ProxyState -ceq $script:localAfter.ProxyState) -and
        ($script:localBefore.ProxyEnabled -eq $script:localAfter.ProxyEnabled)).ToString().ToUpperInvariant()
    $winHttpUnchanged = (($script:localBefore.WinHttpExit -eq $script:localAfter.WinHttpExit) -and
        ($script:localBefore.WinHttpText -ceq $script:localAfter.WinHttpText) -and
        ($script:localBefore.WinHttpDirect -eq $script:localAfter.WinHttpDirect)).ToString().ToUpperInvariant()
    $tunUnchanged = ((($script:localBefore.TunMatches -join ';') -ceq ($script:localAfter.TunMatches -join ';')) -and
        $script:localAfter.TunMatches.Count -eq 0).ToString().ToUpperInvariant()
}
if ($localReadbackAvailable -and $remoteReadbackAvailable) {
    $wgHy2Preserved = ($localBaselineUnchanged -and $remoteProductionPreserved).ToString().ToUpperInvariant()
}
$clientStopState = if ($null -eq $script:clientProcess) { 'NOT_STARTED' } elseif ($clientStopped) { 'YES' } else { 'NO' }
$serverStopState = if (-not $script:remoteStarted) { 'NOT_STARTED' } elseif ($remoteCleanupPass) { 'YES' } else { 'NO' }
$clientRuntimeState = if (-not $script:runtimeDirectoryCreated) { 'NOT_CREATED' } elseif ($localRuntimeDeleted) { 'YES' } else { 'NO' }
$remoteRuntimeState = if (-not $script:remoteStarted) { 'NOT_CREATED' } elseif ($remoteCleanupPass -and $script:remoteCleanup['runtime_absent'] -and $script:remoteCleanup['workspace_absent']) { 'YES' } else { 'NO' }
$routeRemovalState = if (-not $script:routeMutationAttempted) { 'NOT_CREATED' } elseif ($script:routeRemoved) { 'YES' } else { 'NO' }
$publicReachabilityState = if (-not $script:publicListenerTcpAttempted) { 'NOT_ATTEMPTED' } elseif ($script:publicListenerTcpPassed) { 'PASS' } else { 'FAIL' }
$tempRouteBeforeState = if ($null -eq $script:localBefore) { 'NOT_READ' } else { 'ACTIVE_MATCHES={0}|PERSISTENT_MATCHES={1}' -f $script:localBefore.ActiveOwnerRouteCount,$script:localBefore.PersistentOwnerRouteCount }
$localBaselineState = if ($localReadbackAvailable) { $localBaselineUnchanged.ToString().ToUpperInvariant() } else { 'NOT_READ' }
$remoteProductionState = if ($remoteReadbackAvailable) { $remoteProductionPreserved.ToString().ToUpperInvariant() } else { 'NOT_READ' }
$remoteCleanupState = if (-not $script:remoteStarted) { 'NOT_REQUIRED_NOT_STARTED' } elseif ($remoteCleanupPass) { 'PASS' } else { 'FAIL' }
$roundStartedIso = $script:roundStartedAt.ToString("yyyy-MM-dd'T'HH:mm:ss'Z'")
$roundFinishedIso = $script:roundFinishedAt.ToString("yyyy-MM-dd'T'HH:mm:ss'Z'")

"GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1"
"RUNNER_PHASE=$script:resultPhase"
"CLEANUP_PHASE=$script:phase"
"FAILURE_CODE=$(if ($script:failureCode) { $script:failureCode } else { 'NONE' })"
"POWERSHELL_RUNTIME=$($PSVersionTable.PSVersion)"
"ADMINISTRATOR_TOKEN=$($script:administratorRoleVerified.ToString().ToUpperInvariant())"
"INTEGRITY_RID=$(if ($null -ne $script:integrityRid) { $script:integrityRid } else { 'NA' })"
"HIGH_INTEGRITY_TOKEN=$($script:highIntegrityVerified.ToString().ToUpperInvariant())"
"CANONICAL_SOURCE_VERIFIED=$($script:canonicalSourceVerified.ToString().ToUpperInvariant())"
"SOURCE_HEAD=$(if ($script:sourceHead) { $script:sourceHead } else { 'NOT_VERIFIED' })"
"CURRENT_GATE_PREFLIGHT=$(if ($script:canonicalSourceVerified) { 'AUTHORIZED_BUDGET_0_OF_1' } else { 'NOT_VERIFIED' })"
"SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE"
"TARGET_HOSTNAME=$(if ($script:remoteBefore) { $script:remoteBefore['HOSTNAME'] } else { 'UNVERIFIED' })"
"VPS_OS=$(if ($script:remoteBefore) { $script:remoteBefore['OS'] } else { 'NOT_READ' })"
"VPS_KERNEL=$(if ($script:remoteBefore) { $script:remoteBefore['KERNEL'] } else { 'NOT_READ' })"
"VPS_PUBLIC_IP_MATCH_COUNT=$(if ($script:remoteBefore) { $script:remoteBefore['PUBLIC_IP_MATCH_COUNT'] } else { 'NOT_READ' })"
"STRICT_SSH_HOST_KEY_TRUST=$(if ($script:remoteBefore) { 'PASS' } else { 'NOT_READ' })"
"WG_SERVICE=$(if ($script:remoteBefore) { $script:remoteBefore['WG_SERVICE'] } else { 'NOT_READ' })"
"HY2_SERVICE=$(if ($script:remoteBefore) { $script:remoteBefore['HY2_SERVICE'] } else { 'NOT_READ' })"
"UDP_51820=$(if ($script:remoteBefore) { $script:remoteBefore['UDP_51820'] } else { 'NOT_READ' })"
"UDP_8443=$(if ($script:remoteBefore) { $script:remoteBefore['UDP_8443'] } else { 'NOT_READ' })"
"VPS_DEFAULT_ROUTE=$(if ($script:remoteBefore) { $script:remoteBefore['DEFAULT_ROUTE'] } else { 'NOT_READ' })"
"VPS_WG_ROUTE_COUNT=$(if ($script:remoteBefore) { $script:remoteBefore['WG_ROUTE_COUNT'] } else { 'NOT_READ' })"
"VPS_IP_FORWARD=$(if ($script:remoteBefore) { $script:remoteBefore['IP_FORWARD'] } else { 'NOT_READ' })"
"VPS_MEM_AVAILABLE_KIB=$(if ($script:remoteBefore) { $script:remoteBefore['MEM_AVAILABLE_KIB'] } else { 'NOT_READ' })"
"VPS_TMP_FREE_KIB=$(if ($script:remoteBefore) { $script:remoteBefore['TMP_FREE_KIB'] } else { 'NOT_READ' })"
"VPS_UFW_STATUS=$(if ($script:remoteBefore) { $script:remoteBefore['UFW_STATUS'] } else { 'NOT_READ' })"
"VPS_UFW_TCP443_ALLOWED=$(if ($script:remoteBefore) { $script:remoteBefore['UFW_TCP443_ALLOWED'] } else { 'NOT_READ' })"
"VPS_IPTABLES_BACKEND=$(if ($script:remoteBefore) { $script:remoteBefore['IPTABLES_BACKEND'] } else { 'NOT_READ' })"
"VPS_NFT_INPUT_POLICY=$(if ($script:remoteBefore) { $script:remoteBefore['NFT_INPUT_POLICY'] } else { 'NOT_READ' })"
"VPS_NFT_TCP443_BLOCK_COUNT=$(if ($script:remoteBefore) { $script:remoteBefore['NFT_TCP443_BLOCK_COUNT'] } else { 'NOT_READ' })"
"SERVER_BINARY_VERSION=$(if ($script:assetHashPass) { 'v1.19.31' } else { 'NOT_VERIFIED' })"
"SERVER_ASSET_SHA256=$(if ($script:assetHashPass) { 'PASS' } else { 'NOT_PROVEN' })"
"SERVER_CONFIG_CHECK=$(if ($null -ne $script:readyRecord -and $script:readyRecord['server_config_check'] -eq 'PASS') { 'PASS' } else { 'NOT_PROVEN' })"
"PUBLIC_TCP443_LISTENER=$(if ($null -ne $script:readyRecord -and $script:readyRecord['public_tcp443_listener'] -eq 'YES' -and [int]$script:readyRecord['server_owned_listener_count'] -eq 1) { 'YES' } else { 'NOT_PROVEN' })"
"SERVER_OWNED_LISTENER_COUNT=$(if ($script:readyRecord) { $script:readyRecord['server_owned_listener_count'] } else { 'NOT_READ' })"
"TCP443_BEFORE=$(if ($script:remoteBefore) { $script:remoteBefore['TCP_443'] } else { 'NOT_READ' })"
"TCP14443_BEFORE=$(if ($script:remoteBefore) { $script:remoteBefore['TCP_14443'] } else { 'NOT_READ' })"
"PHYSICAL_EGRESS_DISCOVERY=$(if ($script:physicalEgress) { '{0}|{1}|{2}|{3}' -f $script:physicalEgress.InterfaceAlias,$script:physicalEgress.InterfaceIndex,$script:physicalEgress.Gateway,$script:physicalEgress.SourceIPv4 } else { 'NOT_RUN' })"
"WIREGUARD_ADAPTER=$(if ($script:localBefore) { '{0}|{1}|{2}' -f $script:localBefore.WireGuardAdapter,$script:localBefore.WireGuardIfIndex,$script:localBefore.WireGuardAdapterStatus } else { 'NOT_READ' })"
"CONTROL_ROUTE=$(if ($script:localBefore) { '{0}|{1}' -f $script:localBefore.ControlRouteAdapter,$script:localBefore.ControlRouteIfIndex } else { 'NOT_READ' })"
"WIREGUARD_SPLIT_ROUTES=$(if ($script:localBefore) { $script:localBefore.WireGuardSplitRoutes -join ';' } else { 'NOT_READ' })"
"SYSTEM_PROXY_ENABLED_BEFORE=$(if ($script:localBefore) { $script:localBefore.ProxyEnabled.ToString().ToUpperInvariant() } else { 'NOT_READ' })"
"WINHTTP_DIRECT_BEFORE=$(if ($script:localBefore) { $script:localBefore.WinHttpDirect.ToString().ToUpperInvariant() } else { 'NOT_READ' })"
"WINHTTP_ACCESS_TYPE_BEFORE=$(if ($script:localBefore) { $script:localBefore.WinHttpAccessType } else { 'NOT_READ' })"
"TUN_ADAPTER_COUNT_BEFORE=$(if ($script:localBefore) { $script:localBefore.TunMatches.Count } else { 'NOT_READ' })"
"MIHOMO_PROCESS_COUNT_BEFORE=$(if ($script:localBefore) { $script:localBefore.MihomoProcesses.Count } else { 'NOT_READ' })"
"P1_TEST_MIHOMO_PROCESS_COUNT_BEFORE=$(if ($script:localBefore) { $script:localBefore.TestMihomoBinaryProcessCount } else { 'NOT_READ' })"
"TEMP_ROUTE_BEFORE=$tempRouteBeforeState"
"PUBLIC_ROUTE_BEFORE=$(if ($script:routeBefore) { '{0}|{1}|{2}|{3}' -f $script:routeBefore.DestinationPrefix,$script:routeBefore.InterfaceAlias,$script:routeBefore.InterfaceIndex,$script:routeBefore.NextHop } else { 'NOT_READ' })"
"TEMP_ROUTE_ADDED=$($script:routeAdded.ToString().ToUpperInvariant())"
"TEMP_ROUTE_SELECTED=$(if ($script:routeAfter) { '{0}|{1}|{2}|{3}' -f $script:routeAfter.DestinationPrefix,$script:routeAfter.InterfaceAlias,$script:routeAfter.InterfaceIndex,$script:routeAfter.NextHop } else { 'NOT_PROVEN' })"
"PUBLIC_TCP_REACHABILITY=$publicReachabilityState"
"WINDOWS_CLIENT_CONFIG=$(if ($script:runtimeConfigCreated) { 'CREATED' } else { 'NOT_CREATED' })"
"CLIENT_CONFIG_CHECK=$(if ($script:clientConfigCheckPassed) { 'PASS' } else { 'NOT_PROVEN' })"
"CLIENT_PROXY_PROCESS=$(if ($script:clientProxyReady) { 'READY' } else { 'NOT_READY' })"
"REQUEST_COUNT=$script:requestCount"
"CURL_EXIT=$(if ($null -ne $script:curlExit) { $script:curlExit } else { 'NA' })"
"HTTP_STATUS=$(if ($null -ne $script:httpStatus) { $script:httpStatus } else { 'NA' })"
"CURL_TIME_TOTAL=$(if ($script:curlTotal) { $script:curlTotal } else { 'NA' })"
"CURL_TIME_CONNECT=$(if ($script:curlConnect) { $script:curlConnect } else { 'NA' })"
"CURL_TIME_APPCONNECT=$(if ($script:curlAppConnect) { $script:curlAppConnect } else { 'NA' })"
"CLIENT_ERROR_CLASS=$script:clientErrorClass"
"SERVER_ERROR_CLASS=$script:serverErrorClass"
"PUBLIC_REALITY_INTEROPERABILITY=$script:implementationResult"
"SERVER_RSS_KIB_AT_READY=$(if ($null -ne $script:serverRssAtReady) { $script:serverRssAtReady } else { 'NA' })"
"MEM_AVAILABLE_KIB_AFTER_CLEANUP=$(if ($script:remoteCleanup -and $script:remoteCleanup['mem_available_kib_after']) { $script:remoteCleanup['mem_available_kib_after'] } else { 'NA' })"
"CLIENT_MIHOMO_STOPPED=$clientStopState"
"SERVER_MIHOMO_STOPPED=$serverStopState"
"CLIENT_RUNTIME_DELETED=$clientRuntimeState"
"REMOTE_RUNTIME_DELETED=$remoteRuntimeState"
"TEMP_ROUTE_REMOVED=$routeRemovalState"
"TCP443_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['TCP_443'] } else { 'NOT_READ' })"
"TCP14443_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['TCP_14443'] } else { 'NOT_READ' })"
"WG_SERVICE_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['WG_SERVICE'] } else { 'NOT_READ' })"
"HY2_SERVICE_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['HY2_SERVICE'] } else { 'NOT_READ' })"
"UDP_51820_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['UDP_51820'] } else { 'NOT_READ' })"
"UDP_8443_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['UDP_8443'] } else { 'NOT_READ' })"
"VPS_UFW_STATUS_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['UFW_STATUS'] } else { 'NOT_READ' })"
"VPS_IPTABLES_BACKEND_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['IPTABLES_BACKEND'] } else { 'NOT_READ' })"
"VPS_NFT_INPUT_POLICY_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['NFT_INPUT_POLICY'] } else { 'NOT_READ' })"
"VPS_NFT_TCP443_BLOCK_COUNT_AFTER=$(if ($script:remoteAfter) { $script:remoteAfter['NFT_TCP443_BLOCK_COUNT'] } else { 'NOT_READ' })"
"LOCAL_BASELINE_UNCHANGED=$localBaselineState"
"WG_HY2_PRESERVED=$wgHy2Preserved"
"SYSTEM_PROXY_UNCHANGED=$proxyUnchanged"
"WINHTTP_UNCHANGED=$winHttpUnchanged"
"TUN_UNCHANGED=$tunUnchanged"
"PERMANENT_FIREWALL_CHANGED=NO"
"PERMANENT_ROUTE_CHANGED=NO"
"CLEANUP_READBACK=$(if (-not $mutationStarted) { 'NOT_REQUIRED_NO_MUTATION' } elseif ($cleanupPass) { 'PASS' } else { 'FAIL' })"
"ROUND_STARTED_AT=$roundStartedIso"
"ROUND_FINISHED_AT=$roundFinishedIso"
"ACTUAL_ELAPSED=$($elapsed.ToString())"
"REQUEST_BUDGET_REMAINING=$(if ($script:requestBudgetConsumed) { 0 } else { 1 })"
"SECRET_VALUES_EMITTED=0"
"SECRET_VALUES_COMMITTED=0"
"CANONICAL_SOURCE_ONLY_MODE=$($CanonicalSourceOnly.ToString().ToUpperInvariant())"
"LOCAL_PREFLIGHT_ONLY_MODE=$($LocalPreflightOnly.ToString().ToUpperInvariant())"

if ($CanonicalSourceOnly) {
    if ($script:canonicalSourceVerified -and -not $script:failureCode -and -not $mutationStarted -and $script:requestCount -eq 0) { exit 0 }
    exit 1
}

if ($LocalPreflightOnly) {
    if ($script:canonicalSourceVerified -and $null -ne $script:localBefore -and -not $script:failureCode -and -not $mutationStarted -and $script:requestCount -eq 0) { exit 0 }
    exit 1
}

if ($script:implementationResult -ne 'PASS' -or -not $cleanupPass -or $script:requestCount -ne 1) { exit 1 }
exit 0
