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
    Version:        3.0
    Author:         C. Bodett
    Creation Date:  4/12/2024
    Purpose/Change: Moved parameter validation to Param Block and changed storage method from file to ENV variable
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

    if (-not($Defaults)) {
        Switch ($PSBoundParameters.Keys) {
            'SaltString' {
                try {
                    $Settings.Salt = ConvertTo-Base64 -TextString $SaltString
                } catch {
                    Throw $Error[0]
                }
            }
            'SaltBytes' {
                try {
                    $Settings.Salt = ConvertTo-Base64 -Bytes $SaltBytes
                } catch {
                    Throw $Error[0]
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
`r`n    Saving settings to ENV:ProtectStrings
        Salt........: $($Settings.Salt)
        Iterations..: $($Settings.Iterations)
        Hash........: $($Settings.Hash)
"@
        Write-Verbose $VMsg
        [Environment]::SetEnvironmentVariable("ProtectStrings", ($Settings | ConvertTo-Json -Compress), "User")
    } else {
        [System.Environment]::SetEnvironmentVariable("ProtectStrings", $null, "User")
    }
}