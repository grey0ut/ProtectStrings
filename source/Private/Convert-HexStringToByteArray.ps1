function Convert-HexStringToByteArray {
    <#
    .SYNOPSIS
    converts a hexidecimal string in to an array of bytes
    .DESCRIPTION
    converts a hexidecimal string in to an array of bytes. This is a private function that won't be exposed to the session.
    .PARAMETER HexString
    The hexadecimal string to convert in to a byte array

    Any of the following is valid input

    0x41,0x42,0x43,0x44
    \x41\x42\x43\x44
    41-42-43-44
    41424344
    .EXAMPLE
    Convert-HexStringToByteArray -HexString 41-42-43-44
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true,ValueFromPipeline = $true,Position = 0)]
        [string]$HexString
    )

    process {
        $Regex1 = '\b0x\B|\\\x78|-|,|:'
        # convert to lowercase and remove all possible deliminating characters
        $String = $HexString.ToLower() -replace $Regex1,''

        # Remove beginning and ending colons, and other detritus.
        $Regex2 = '^:+|:+$|x|\\'
        $String = $String -replace $Regex2,''

        $ByteArray = if ($String.Length -eq 1) {
                        [System.Convert]::ToByte($String,16)
                    } else {
                        $String -Split '(..)' -ne '' | foreach-object {
                            [System.Convert]::ToByte($_,16)
                        }
                    }
        Write-Output $ByteArray -NoEnumerate
    }
}