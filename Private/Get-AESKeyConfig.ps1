<#
.Synopsis
Function to retrieve settings for use with PBKDF2 to create an AES Key
.NOTES
Version:        1.0
Author:         C. Bodett
Creation Date:  06/09/2022
Purpose/Change: initial function development
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
    Salt = '|½ÁôøwÚ♀å>~I©k◄=ýñíî'
    Iterations = 1000
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