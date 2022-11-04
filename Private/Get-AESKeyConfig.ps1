<#
.Synopsis
Function to retrieve settings for use with PBKDF2 to create an AES Key
.NOTES
Version:        2.0
Author:         C. Bodett
Creation Date:  11/03/2022
Purpose/Change: Changed Salt storage method to Base64 encoding for more reliable operation
#>
Function Get-AESKeyConfig {
    [cmdletbinding()]
    Param (
        # No Parameters
    )

    Process {
        $ConfigFileName = "ProtectStringsConfig.psd1"
        $ConfigFilePath = Join-Path -Path $Env:LOCALAPPDATA  -ChildPath $ConfigFileName

        if (-not (Test-Path  $ConfigFilePath)) {
            $DefaultConfigData = @"
@{
    Salt = 'fMK9w4HDtMO4d8Oa4pmAw6U+fknCqWvil4Q9w73DscOtw64='
    Iterations = 310000
    Hash = 'SHA256'
}
"@
            Try {
                $DefaultConfigData | Out-File -FilePath $ConfigFilePath -ErrorAction Stop
            } Catch {
                Write-Verbose "Failed to create configuration file for PBKDF2 settings. Temporarily loading defaults for this session."
                $Settings = Invoke-Expression $DefaultConfigData
                return $Settings
            }
        }

        if ($($PSVersionTable.PSVersion.Major) -lt 5) {
            $Settings = Import-LocalizedData -BaseDirectory $ENV:LOCALAPPDATA -FileName $ConfigFileName
        } else {
            $Settings = Import-PowerShellDataFile -Path $ConfigFilePath
        }

        return $Settings
    }
}