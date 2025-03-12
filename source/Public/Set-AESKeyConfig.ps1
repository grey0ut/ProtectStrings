Function Set-AESKeyConfig {
    <#
    .Synopsis
    Control the settings for use with PBKDF2 to create an AES Key
    .Description
    Allows custom configuration of the parameters associated with the PBKDF2 key generation. User can dictate the Salt, Iterations and Hash algorithm. 
    If called with no parameters the default settings are saved to an Environment variable named ProtectStrings.
    .Parameter SaltString
    Provide a custom string to be used as the Salt bytes in PBKDF2 generation. Must be at least 16 bytes in length.
    .Parameter SaltBytes
    A byte array of at least 16 bytes can be provided for a custom salt value.
    .Parameter Iterations
    Specify the number of iterations PBKDF2 should use. 600000 is the default.
    .Parameter Hash
    Specify the Hash type used with PBKDF2. Accetable values are: 'MD5','SHA1','SHA256','SHA384','SHA512'.
    .Parameter Defaults
    Removes the Environment variable containing config. 
    .NOTES
    Version:        4.0
    Author:         C. Bodett
    Creation Date:  3/10/2025
    Purpose/Change: Switched save method to file on disk since Environment variables didn't work on Linux/MacOS
    #>
    [cmdletbinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = "SaltString")]
        [ValidateScript({
            if ([System.Text.Encoding]::UTF8.GetBytes($_).Count -lt 16) {
                Throw "Salt must be at least 16 bytes in length"
            } else {
                return $true
            }
        })]
        [String]$SaltString,
        [Parameter(Mandatory = $false, ParameterSetName = "SaltBytes")]
        [ValidateCount(16,256)]
        [Byte[]]$SaltBytes,
        [Parameter(Mandatory = $false)]
        [Int32]$Iterations,
        [Parameter(Mandatory = $false)]
        [ValidateSet('MD5','SHA1','SHA256','SHA384','SHA512')]
        [String]$Hash,
        [Switch]$Defaults
    )

    $Settings = Get-AESKeyConfig

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

    if (-not($Defaults)) {
        Switch ($PSBoundParameters.Keys) {
            'SaltString' {
                try {
                    $Settings.Salt = ConvertTo-Base64 -TextString $SaltString
                } catch {
                    Throw $_
                }
            }
            'SaltBytes' {
                try {
                    $Settings.Salt = ConvertTo-Base64 -Bytes $SaltBytes
                } catch {
                    Throw $_
                }
            }
            'Iterations'    { 
                $Settings.Iterations = $Iterations
            }
            'Hash'          { 
                $Settings.Hash = $Hash
            }
        }
$VMsg = @"
`r`n    Saving settings to $SettingsPath
        Salt........: $($Settings.Salt)
        Iterations..: $($Settings.Iterations)
        Hash........: $($Settings.Hash)
"@
        Write-Verbose $VMsg
        try {
            if (Test-Path $SettingsPath) {
                $Settings | ConvertTo-Json | Out-File -FilePath $SettingsPath -Force
                } else {
                    New-Item -Path $SettingsPath -Force | Out-Null
                    $Settings | ConvertTo-Json | Out-File -FilePath $SettingsPath
                }
        } catch {
            throw $_
            }
    } else {
        try {
            Write-Verbose "Removing settings file at $($SettingsPath)"
            Remove-Item -Path $SettingsPath -Force -ErrorAction Stop
        } catch [System.Management.Automation.ItemNotFoundException] {
            Write-Warning "No settings file found"
        } catch {
            throw $_
        }
    }
}
