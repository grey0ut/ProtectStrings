Function Get-AESKeyConfig {
    <#
    .Synopsis
    Function to retrieve settings for use with PBKDF2 to create an AES Key
    .NOTES
    Version:        3.0
    Author:         C. Bodett
    Creation Date:  4/12/2024
    Purpose/Change: Overhaul for storing defaults in function, and retrieving custom settings from ENV variable
    #>
    [cmdletbinding()]
    Param (
        # No Parameters
    )

    if ($EnvConfig = [System.Environment]::GetEnvironmentVariable("ProtectStrings","User")) {
        try {
            $Settings = $EnvConfig | ConvertFrom-Json -ErrorAction Stop
        } catch {
            throw $Error[0]
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