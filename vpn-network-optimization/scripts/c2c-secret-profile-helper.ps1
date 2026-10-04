[CmdletBinding(DefaultParameterSetName='Prepare')]
param(
    [Parameter(Mandatory=$true, ParameterSetName='Prepare')][switch]$Prepare,
    [Parameter(Mandatory=$true, ParameterSetName='VerifyCleanup')][switch]$VerifyCleanup,
    [Parameter(Mandatory=$true, ParameterSetName='VerifyCleanup')][string]$ProfilePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
Add-Type -AssemblyName System.IO.FileSystem.AccessControl

$projectRoot = Split-Path -Parent $PSScriptRoot
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$recoveryPath = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\hy2-g2a.dpapi'
$templatePath = Join-Path $projectRoot 'templates\clash\c2c-real-hy2-canary.yaml.template'
$mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User

$protectedBytes = $null
$bundleBytes = $null
$recoveryFiles = $null
$authBytes = $null
$profileBytes = $null
$createdDirectory = $null
$createdProfile = $null
$prepareSucceeded = $false

function Assert-C2CSecret {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-HighIntegrity {
    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    $match = [regex]::Match($groups, 'S-1-16-(\d+)')
    return ($match.Success -and [int]$match.Groups[1].Value -ge 12288)
}

function New-OwnerAcl {
    param([switch]$Directory)

    if ($Directory) {
        $acl = [Security.AccessControl.DirectorySecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    }
    else {
        $acl = [Security.AccessControl.FileSecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::None
    }

    $acl.SetAccessRuleProtection($true, $false)
    $acl.SetOwner($ownerSid)
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $ownerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-OwnerAcl {
    param([string]$Path)

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-C2CSecret $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'

    $owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    Assert-C2CSecret ($owner -ceq $ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'

    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    Assert-C2CSecret ($rules.Count -gt 0) 'OWNER_ACL_RULES_MISSING'

    $direct = [long]0
    $container = [long]0
    $object = [long]0
    foreach ($rule in $rules) {
        Assert-C2CSecret (-not $rule.IsInherited) 'OWNER_ACL_INHERITED_RULE_PRESENT'
        Assert-C2CSecret ($rule.IdentityReference.Value -ceq $ownerSid.Value) 'OWNER_ACL_UNAUTHORIZED_PRINCIPAL'
        Assert-C2CSecret ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'OWNER_ACL_DENY_RULE_PRESENT'

        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $direct = $direct -bor $rights
        }
        if ($item.PSIsContainer) {
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) { $container = $container -bor $rights }
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) { $object = $object -bor $rights }
        }
    }

    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-C2CSecret (($direct -band $full) -eq $full) 'OWNER_ACL_FULLCONTROL_MISSING'
    if ($item.PSIsContainer) {
        Assert-C2CSecret ((($container -band $full) -eq $full) -and (($object -band $full) -eq $full)) 'OWNER_ACL_CHILD_INHERITANCE_MISSING'
    }
}

function Resolve-ProfileStoreRoot {
    $roamingRoot = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    $roots = @(Get-ChildItem -LiteralPath $roamingRoot -Directory -Force -ErrorAction Stop |
        Where-Object { $_.Name -match '(?i)(?:clash.*verge|verge.*clash)' })
    $stores = @($roots | ForEach-Object { Join-Path $_.FullName 'profiles' } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Container })
    Assert-C2CSecret ($stores.Count -eq 1) 'CLASH_PROFILE_STORE_AMBIGUOUS'
    return (Resolve-Path -LiteralPath $stores[0] -ErrorAction Stop).Path
}

function New-KmpTable {
    param([byte[]]$Pattern)
    $table = [int[]]::new($Pattern.Length)
    $length = 0
    $i = 1
    while ($i -lt $Pattern.Length) {
        if ($Pattern[$i] -eq $Pattern[$length]) {
            $length++
            $table[$i] = $length
            $i++
        }
        elseif ($length -gt 0) {
            $length = $table[$length - 1]
        }
        else {
            $i++
        }
    }
    return ,$table
}

function Test-FilePattern {
    param([string]$Path, [byte[]]$Pattern)

    $table = New-KmpTable -Pattern $Pattern
    $stream = [IO.FileStream]::new(
        $Path,
        [IO.FileMode]::Open,
        [IO.FileAccess]::Read,
        ([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete)
    )

    try {
        $buffer = [byte[]]::new(65536)
        $matched = 0
        while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            for ($i = 0; $i -lt $read; $i++) {
                while ($matched -gt 0 -and $buffer[$i] -ne $Pattern[$matched]) {
                    $matched = $table[$matched - 1]
                }
                if ($buffer[$i] -eq $Pattern[$matched]) {
                    $matched++
                    if ($matched -eq $Pattern.Length) { return $true }
                }
            }
        }
        return $false
    }
    finally {
        $stream.Dispose()
    }
}

function Get-PatternFileCount {
    param([string]$Root, [byte[]]$Pattern)

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { return 0 }

    $count = 0
    $stack = [Collections.Generic.Stack[string]]::new()
    $stack.Push($Root)

    while ($stack.Count -gt 0) {
        $directory = $stack.Pop()
        foreach ($item in @(Get-ChildItem -LiteralPath $directory -Force -ErrorAction Stop)) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw 'SECRET_SCAN_REPARSE_POINT_PRESENT'
            }

            if ($item.PSIsContainer) {
                $stack.Push($item.FullName)
            }
            else {
                try {
                    if (Test-FilePattern -Path $item.FullName -Pattern $Pattern) { $count++ }
                }
                catch {
                    throw 'SECRET_SCAN_READ_FAILED'
                }
            }
        }
    }

    return $count
}

function Read-ExactBytes {
    param([IO.BinaryReader]$Reader, [int]$Count)
    $bytes = $Reader.ReadBytes($Count)
    if ($bytes.Length -ne $Count) { throw 'RECOVERY_FRAME_TRUNCATED' }
    return ,$bytes
}

function Read-RecoveryBundle {
    param([byte[]]$Bytes)

    if ($Bytes.Length -gt 131072) { throw 'RECOVERY_FRAME_TOO_LARGE' }
    $stream = [IO.MemoryStream]::new($Bytes, $false)
    $reader = [IO.BinaryReader]::new($stream, [Text.Encoding]::UTF8, $true)
    $files = @{}

    try {
        $magic = [Text.Encoding]::ASCII.GetString((Read-ExactBytes -Reader $reader -Count 8))
        if ($magic -ne 'VPNHY2R1') { throw 'RECOVERY_FRAME_MAGIC_INVALID' }

        while ($stream.Position -lt $stream.Length) {
            $nameLength = [int]$reader.ReadByte()
            if ($nameLength -lt 1 -or $nameLength -gt 32) { throw 'RECOVERY_FRAME_NAME_LENGTH_INVALID' }

            $lengthBytes = Read-ExactBytes -Reader $reader -Count 4
            $dataLength = ([uint32]$lengthBytes[0] -shl 24) -bor
                          ([uint32]$lengthBytes[1] -shl 16) -bor
                          ([uint32]$lengthBytes[2] -shl 8) -bor
                          [uint32]$lengthBytes[3]
            if ($dataLength -lt 1 -or $dataLength -gt 65536) { throw 'RECOVERY_FRAME_DATA_LENGTH_INVALID' }

            $name = [Text.Encoding]::UTF8.GetString((Read-ExactBytes -Reader $reader -Count $nameLength))
            if ($name -notin @('hy2-auth', 'server.key', 'server.crt') -or $files.ContainsKey($name)) {
                throw 'RECOVERY_FRAME_ALLOWLIST_INVALID'
            }
            $files[$name] = Read-ExactBytes -Reader $reader -Count ([int]$dataLength)
        }

        if ($files.Count -ne 3) { throw 'RECOVERY_FRAME_CARDINALITY_INVALID' }

        $auth = [byte[]]$files['hy2-auth']
        if ($auth.Length -ne 64 -or
            @($auth | Where-Object { $_ -notin 48..57 -and $_ -notin 97..102 }).Count -gt 0) {
            throw 'RECOVERY_AUTH_FORMAT_INVALID'
        }

        $certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$files['server.crt'])
        try {
            $sanExtension = $certificate.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.17' } | Select-Object -First 1
            if ($null -eq $sanExtension) { throw 'RECOVERY_CERTIFICATE_SAN_MISSING' }
            $san = [Security.Cryptography.X509Certificates.X509SubjectAlternativeNameExtension]::new($sanExtension.RawData)
            $names = @($san.EnumerateDnsNames())
            if ($names.Count -ne 1 -or $names[0] -ne 'hy2.sfo3-a.invalid') { throw 'RECOVERY_CERTIFICATE_SAN_INVALID' }

            $hex = [Convert]::ToHexString($certificate.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256))
            $fingerprint = [string]::Join(':', [regex]::Matches($hex, '..').Value)
        }
        finally {
            $certificate.Dispose()
        }

        return [pscustomobject]@{ Files = $files; Fingerprint = $fingerprint }
    }
    catch {
        foreach ($value in $files.Values) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value)
        }
        throw
    }
    finally {
        $reader.Dispose()
        $stream.Dispose()
    }
}

function Get-TemplateInfo {
    $text = [IO.File]::ReadAllText($templatePath, [Text.Encoding]::UTF8)
    foreach ($ch in $text.ToCharArray()) {
        if ([int][char]$ch -gt 127) { throw 'C2C_TEMPLATE_NON_ASCII' }
    }

    $fingerprint = [regex]::Match($text, '(?m)^\s+fingerprint:\s*(?<v>[0-9A-F]{2}(?::[0-9A-F]{2}){31})\s*$')
    if (-not $fingerprint.Success) { throw 'C2C_TEMPLATE_FINGERPRINT_INVALID' }
    if (([regex]::Matches($text, '__C2C_REAL_HY2_AUTH_INJECTION_ONLY__')).Count -ne 1) {
        throw 'C2C_TEMPLATE_SECRET_PLACEHOLDER_INVALID'
    }

    return [pscustomobject]@{ Text = $text; Fingerprint = $fingerprint.Groups['v'].Value }
}

function New-ProfileBytes {
    param([string]$TemplateText, [byte[]]$AuthBytes)

    $placeholder = '__C2C_REAL_HY2_AUTH_INJECTION_ONLY__'
    $index = $TemplateText.IndexOf($placeholder, [StringComparison]::Ordinal)
    if ($index -lt 0 -or $TemplateText.LastIndexOf($placeholder, [StringComparison]::Ordinal) -ne $index) {
        throw 'C2C_TEMPLATE_SECRET_PLACEHOLDER_INVALID'
    }

    $prefix = [Text.Encoding]::ASCII.GetBytes($TemplateText.Substring(0, $index))
    $suffix = [Text.Encoding]::ASCII.GetBytes($TemplateText.Substring($index + $placeholder.Length))
    $bytes = [byte[]]::new($prefix.Length + $AuthBytes.Length + $suffix.Length)

    try {
        [Buffer]::BlockCopy($prefix, 0, $bytes, 0, $prefix.Length)
        [Buffer]::BlockCopy($AuthBytes, 0, $bytes, $prefix.Length, $AuthBytes.Length)
        [Buffer]::BlockCopy($suffix, 0, $bytes, $prefix.Length + $AuthBytes.Length, $suffix.Length)
        return ,$bytes
    }
    finally {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($prefix)
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($suffix)
    }
}

function Invoke-MihomoParse {
    param([string]$ConfigPath)

    $process = [Diagnostics.Process]::new()
    try {
        $process.StartInfo.FileName = $mihomoPath
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.RedirectStandardError = $true
        [void]$process.StartInfo.ArgumentList.Add('-t')
        [void]$process.StartInfo.ArgumentList.Add('-f')
        [void]$process.StartInfo.ArgumentList.Add($ConfigPath)

        if (-not $process.Start()) { throw 'MIHOMO_PARSE_START_FAILED' }
        $outTask = $process.StandardOutput.ReadToEndAsync()
        $errTask = $process.StandardError.ReadToEndAsync()

        if (-not $process.WaitForExit(30000)) {
            try { $process.Kill($true) } catch { }
            throw 'MIHOMO_PARSE_TIMEOUT'
        }

        [void]$outTask.GetAwaiter().GetResult()
        [void]$errTask.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) { throw 'MIHOMO_REAL_PROFILE_PARSE_FAILED' }
    }
    finally {
        $process.Dispose()
    }
}

function Get-SecretContext {
    Assert-C2CSecret (Test-Path -LiteralPath $recoveryPath -PathType Leaf) 'HY2_RECOVERY_MISSING'
    Assert-OwnerAcl -Path (Split-Path -Parent $recoveryPath)
    Assert-OwnerAcl -Path $recoveryPath

    $script:protectedBytes = [IO.File]::ReadAllBytes($recoveryPath)
    $script:bundleBytes = [Security.Cryptography.ProtectedData]::Unprotect(
        $script:protectedBytes,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:protectedBytes)
    $script:protectedBytes = $null

    $script:recoveryFiles = Read-RecoveryBundle -Bytes $script:bundleBytes
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:bundleBytes)
    $script:bundleBytes = $null

    $templateInfo = Get-TemplateInfo
    Assert-C2CSecret ($script:recoveryFiles.Fingerprint -ceq $templateInfo.Fingerprint) 'CERTIFICATE_FINGERPRINT_MISMATCH'

    $script:authBytes = [byte[]]$script:recoveryFiles.Files['hy2-auth'].Clone()
    foreach ($name in @('hy2-auth', 'server.key', 'server.crt')) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$script:recoveryFiles.Files[$name])
    }
    $script:recoveryFiles = $null

    return $templateInfo
}

try {
    Assert-C2CSecret ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-C2CSecret (Test-HighIntegrity) 'HIGH_INTEGRITY_REQUIRED'
    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-C2CSecret ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
    Assert-C2CSecret ($null -ne $ownerSid) 'OWNER_SID_UNAVAILABLE'
    Assert-C2CSecret (Test-Path -LiteralPath $templatePath -PathType Leaf) 'C2C_TEMPLATE_MISSING'
    Assert-C2CSecret (Test-Path -LiteralPath $mihomoPath -PathType Leaf) 'MIHOMO_BINARY_MISSING'

    if (Test-Path -LiteralPath $runtimeRoot -PathType Container) {
        Assert-OwnerAcl -Path $runtimeRoot
    }
    else {
        [void][System.IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory), $runtimeRoot)
        Assert-OwnerAcl -Path $runtimeRoot
    }

    $profileStoreRoot = Resolve-ProfileStoreRoot
    $clashAppRoot = Split-Path -Parent $profileStoreRoot
    $templateInfo = Get-SecretContext

    if ($Prepare) {
        Assert-C2CSecret ((Get-PatternFileCount -Root $clashAppRoot -Pattern $authBytes) -eq 0) 'REAL_AUTH_ALREADY_PRESENT_IN_CLASH_STORAGE'
        Assert-C2CSecret ((Get-PatternFileCount -Root $runtimeRoot -Pattern $authBytes) -eq 0) 'REAL_AUTH_ALREADY_PRESENT_IN_PROJECT_RUNTIME'

        $createdDirectory = Join-Path $runtimeRoot ('c2c-' + [Guid]::NewGuid().ToString('N'))
        [void][System.IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory), $createdDirectory)
        Assert-OwnerAcl -Path $createdDirectory

        $shortId = [Guid]::NewGuid().ToString('N').Substring(0, 8)
        $createdProfile = Join-Path $createdDirectory ('c2c-real-hy2-canary-' + $shortId + '.yaml')
        $profileBytes = New-ProfileBytes -TemplateText $templateInfo.Text -AuthBytes $authBytes

        $stream = [IO.File]::Open($createdProfile, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
        try {
            $stream.Write($profileBytes, 0, $profileBytes.Length)
            $stream.Flush($true)
        }
        finally {
            $stream.Dispose()
        }

        Set-Acl -LiteralPath $createdProfile -AclObject (New-OwnerAcl) -ErrorAction Stop
        Assert-OwnerAcl -Path $createdProfile
        Invoke-MihomoParse -ConfigPath $createdProfile

        $prepareSucceeded = $true
        Write-Output 'DPAPI_UNPROTECT=PASS'
        Write-Output 'REAL_HY2_AUTH_FORMAT=PASS'
        Write-Output 'CERTIFICATE_FINGERPRINT_MATCH=PASS'
        Write-Output 'CLASH_REAL_AUTH_PREEXISTING=NO'
        Write-Output 'OWNER_ONLY_REAL_PROFILE=PASS'
        Write-Output 'MIHOMO_REAL_PROFILE_PARSE=PASS'
        Write-Output ('TEMP_REAL_PROFILE_PATH=' + $createdProfile)
        Write-Output 'C2C_SECRET_PREPARE=PASS'
    }
    else {
        $fullProfile = [IO.Path]::GetFullPath($ProfilePath)
        $fullRuntime = [IO.Path]::GetFullPath($runtimeRoot).TrimEnd('\') + '\'
        Assert-C2CSecret ($fullProfile.StartsWith($fullRuntime, [StringComparison]::OrdinalIgnoreCase)) 'PROFILE_PATH_OUTSIDE_RUNTIME_ROOT'
        Assert-C2CSecret ((Split-Path -Leaf $fullProfile) -match '^c2c-real-hy2-canary-[0-9a-f]{8}\.yaml$') 'PROFILE_FILENAME_INVALID'

        $appResidue = Get-PatternFileCount -Root $clashAppRoot -Pattern $authBytes

        if (Test-Path -LiteralPath $fullProfile -PathType Leaf) {
            Assert-OwnerAcl -Path $fullProfile
            Remove-Item -LiteralPath $fullProfile -Force -ErrorAction Stop
        }

        $profileDirectory = Split-Path -Parent $fullProfile
        if (Test-Path -LiteralPath $profileDirectory -PathType Container) {
            Assert-OwnerAcl -Path $profileDirectory
            Assert-C2CSecret (@(Get-ChildItem -LiteralPath $profileDirectory -Force -ErrorAction Stop).Count -eq 0) 'PROFILE_RUNTIME_DIRECTORY_NOT_EMPTY'
            Remove-Item -LiteralPath $profileDirectory -ErrorAction Stop
        }

        $runtimeResidue = Get-PatternFileCount -Root $runtimeRoot -Pattern $authBytes

        Write-Output ('CLASH_REAL_AUTH_RESIDUE=' + $(if ($appResidue -eq 0) { 'ABSENT' } else { 'PRESENT' }))
        Write-Output ('PROJECT_RUNTIME_REAL_AUTH_RESIDUE=' + $(if ($runtimeResidue -eq 0) { 'ABSENT' } else { 'PRESENT' }))
        Write-Output 'REAL_PROFILE_RUNTIME_CLEANUP=PASS'

        Assert-C2CSecret ($appResidue -eq 0) 'CLASH_REAL_AUTH_RESIDUE_PRESENT'
        Assert-C2CSecret ($runtimeResidue -eq 0) 'PROJECT_RUNTIME_REAL_AUTH_RESIDUE_PRESENT'

        Write-Output 'C2C_SECRET_CLEANUP_VERIFY=PASS'
    }
}
catch {
    if ($Prepare -and -not $prepareSucceeded) {
        try {
            if ($null -ne $createdProfile -and (Test-Path -LiteralPath $createdProfile -PathType Leaf)) {
                Remove-Item -LiteralPath $createdProfile -Force -ErrorAction SilentlyContinue
            }
            if ($null -ne $createdDirectory -and (Test-Path -LiteralPath $createdDirectory -PathType Container) -and
                @(Get-ChildItem -LiteralPath $createdDirectory -Force -ErrorAction SilentlyContinue).Count -eq 0) {
                Remove-Item -LiteralPath $createdDirectory -ErrorAction SilentlyContinue
            }
        }
        catch { }
    }

    $code = [string]$_.Exception.Message
    Write-Output ('C2C_SECRET_HELPER_RESULT=RETURN')
    if ($code -cmatch '^[A-Z][A-Z0-9_]{1,95}$') {
        Write-Output ('FAILURE_CODE=' + $code)
    }
    else {
        Write-Output 'FAILURE_CODE=UNCLASSIFIED'
    }
    exit 1
}
finally {
    if ($null -ne $profileBytes) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($profileBytes)
    }
    if ($null -ne $recoveryFiles) {
        foreach ($value in $recoveryFiles.Files.Values) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value)
        }
    }
    if ($null -ne $bundleBytes) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($bundleBytes)
    }
    if ($null -ne $protectedBytes) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($protectedBytes)
    }
    if ($null -ne $authBytes) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($authBytes)
    }
    Write-Output 'SECRET_VALUES_EMITTED=0'
}

Write-Output 'C2C_SECRET_HELPER_RESULT=PASS'
exit 0
