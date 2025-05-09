function Get-AESKeyConfig {
    <#
    .SYNOPSIS
    Function to retrieve settings for use with PBKDF2 to create an AES Key
    .DESCRIPTION
    Function to retrieve the PBKDF2 parameters that are currently set.  These parameters control the strength of the derived key.  Ships with OWASP recommended defaults but can be
    changed using the Set-AESKeyConfig function.  Use Get-AESKeyconfig to confirm current settings.
    .EXAMPLE
    PS> Get-AESKeyConfig

    Hash   Iterations Salt
    ----   ---------- ----
    SHA384    1000000 fMK9w4HDtMO4d8Oa4pmAw6U+fknCqWvil4Q9w73DscOtw64=
    #>
    [cmdletbinding()]
    param (
    )

    # check to see if we're on Windows or not
    if ($IsWindows -or $ENV:OS) {
        $Windows = $true
    } else {
        $Windows = $false
    }
    if ($Windows) {
        $SettingsPath = Join-Path -Path $Env:APPDATA -ChildPath "ProtectStrings\Settings.json"
    } else {
        $SettingsPath = Join-Path -Path ([Environment]::GetEnvironmentVariable("HOME")) -ChildPath ".local/share/powershell/Modules/ProtectStrings/Settings.json"
    }

    if (Test-Path $SettingsPath) {
        try {
            $Settings = Get-Content -Path $SettingsPath | ConvertFrom-Json
        } catch {
            throw $_
        }
    } else {
        # Default settings
        $Settings = @{
            Salt = 'fMK9w4HDtMO4d8Oa4pmAw6U+fknCqWvil4Q9w73DscOtw64='
            Iterations = 600000
            Hash = 'SHA256'
        }
    }
    $Settings
}