Function Get-AESKeyConfig {
    <#
    .Synopsis
    Function to retrieve settings for use with PBKDF2 to create an AES Key
    .NOTES
    Version:        4.0
    Author:         C. Bodett
    Creation Date:  3/10/2025
    Purpose/Change: Switched save method to file on disk since Environment variables didn't work on Linux/MacOS
    #>
    [cmdletbinding()]
    Param (
        # No Parameters
    )

    # check to see if we're on Windows or not
    if ($IsWindows -or $ENV:OS) {
        $Windows = $true
    } else {
        $Windows = $false
    }
    if ($Windows) {
        $SettingsPath = Join-Path -Path $Env:APPDATA -ChildPath "ProtectStrings" -AdditionalChildPath Settings.json
    } else {
        $SettingsPath = Join-Path -Path ([Environment]::GetEnvironmentVariable("HOME")) -ChildPath ".local" -AdditionalChildPath "share","powershell","Modules","ProtectStrings",Settings.json
    }

    if (Test-Path $SettingsPath) {
        try {
            $Settings = Get-Content -Path $SettingsPath | ConvertFrom-Json -AsHashtable
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
