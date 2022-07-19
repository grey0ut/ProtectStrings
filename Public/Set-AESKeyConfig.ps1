Function Set-AESKeyConfig {
    <#
    .Synopsis
    Function to write settings for use with PBKDF2 to create an AES Key
    .Description
    Allows custom configuration of the parameters associated with the PBKDF2 generation. Namely the Salt, number of Iterations, and Hash type.
    .Parameter Salt
    Provide a custom string to be used as the Salt bytes in PBKDF2 generation. Must be at least 8 characters in length.
    .Parameter Iterations
    Specify the number of iterations PBKDF2 should use. 1000 is the default.
    .Parameter Hash
    Specify the Hash type used with PBKDF2. Accetable values are: 'MD5','SHA1','SHA256','SHA384','SHA512'.
    .Parameter Defaults
    Switch parameter that resets the AES Key Config file to default values.
    .NOTES
    Version:        1.0
    Author:         C. Bodett
    Creation Date:  06/09/2022
    Purpose/Change: initial function development
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [ValidateScript({
            if ($_.Length -lt 8) {
                Throw "Salt must be at least 8 bytes in length"
            } else {
                return $true
            }
        })]
        [String]$Salt,
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
    Salt = '|½ÁôøwÚ♀å>~I©k◄=ýñíî'
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