Function Set-AESKeyConfig {
    <#
    .Synopsis
    Function to write settings for use with PBKDF2 to create an AES Key
    .Description
    Allows custom configuration of the parameters associated with the PBKDF2 generation. Namely the Salt, number of Iterations, and Hash type.
    .Parameter Salt
    Provide a custom string to be used as the Salt bytes in PBKDF2 generation. Must be at least 8 bytes in length. Alternatively you can also provide a base64 encoded string.
    .Parameter SaltBytes
    A byte array of at least 8 bytes can be provided  for a custom salt value.
    .Parameter Iterations
    Specify the number of iterations PBKDF2 should use. 1000 is the default.
    .Parameter Hash
    Specify the Hash type used with PBKDF2. Accetable values are: 'MD5','SHA1','SHA256','SHA384','SHA512'.
    .Parameter Defaults
    Switch parameter that resets the AES Key Config file to default values.
    .NOTES
    Version:        2.0
    Author:         C. Bodett
    Creation Date:  11/03/2022
    Purpose/Change: Changed Salt storage method to Base64 encoding for more reliable operation
    #>
    [cmdletbinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = "SaltString")]
        [ValidateScript({
            if ([System.Text.Encoding]::UTF8.GetBytes($_).Count -lt 8) {
                Throw "Salt must be at least 8 bytes in length"
            } else {
                return $true
            }
        })]
        [String]$Salt,
        [Parameter(Mandatory = $false, ParameterSetName = "SaltBytes")]
        [Byte[]]$SaltBytes,
        [Parameter(Mandatory = $false)]
        [Int32]$Iterations,
        [Parameter(Mandatory = $false)]
        [ValidateSet('MD5','SHA1','SHA256','SHA384','SHA512')]
        [String]$Hash,
        [Switch]$Defaults
    )

    Process {
        $ConfigFileName = "ProtectStringsConfig.psd1"
        $ConfigFilePath = Join-Path -Path $Env:LOCALAPPDATA  -ChildPath $ConfigFileName
        Write-Verbose "Config file path: $($ConfigFilePath)"
        if (-not (Test-Path  $ConfigFilePath) -or $Defaults) {
            Write-verbose "Defaults parameter provided or no config file present. Creating defaults"
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
                Throw $_
            }
        }

        Switch ($PSBoundParameters.Keys) {
            'Salt' {
                try { 
                    $Null = [System.Convert]::FromBase64String($Salt)
                } catch {
                    # suppress errors
                }
                if (-not ($?)) {
                    try {
                        $Salt = ConvertTo-Base64 -TextString $Salt
                    } catch {
                        Throw $_
                    }
                }
            }
            'SaltBytes' {
                if ($SaltBytes.Count -lt 8) {
                    Throw "Salt must be at least 8 bytes. Provided byte array is only $($SaltBytes.Count) bytes"
                }
                $Salt = ConvertTo-Base64 -Bytes $SaltBytes
            }
        }

        if ($($PSVersionTable.PSVersion.Major) -lt 5) {
            $Settings = Import-LocalizedData -BaseDirectory $ENV:LOCALAPPDATA -FileName $ConfigFileName
        } else {
            $Settings = Import-PowerShellDataFile -Path $ConfigFilePath
        }

        Switch ($PSBoundParameters.Keys) {
            'Salt' {$Settings.Salt = $Salt}
            'Iterations' {$Settings.Iterations = $Iterations}
            'Hash' {$Settings.Hash = $Hash}
        }

        $VMsg = @"
`r`n        Saving settings...
        Salt........: $($Settings.Salt)
        Iterations..: $($Settings.Iterations)
        Hash........: $($Settings.Hash)
"@
        Write-Verbose $VMsg

        $OutString = "@{{`n{0}`n}}" -f ($(
                        ForEach ($Key in @($Settings.Keys)) {
                            If ($Settings[$Key] -is [Int32]) {
                                "   $Key = " + ($Settings[$Key])
                            } Else {
                                    "   $Key = " + "'{0}'" -f ($Settings[$Key])
                                }
                        }) -split "`n" -join "`n")
        $OutString | Out-File -FilePath $ConfigFilePath -ErrorAction Stop
    }
}