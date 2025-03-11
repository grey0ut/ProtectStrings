<#
.Synopsis
A Function to leverage the .NET Random Number Generator
#>
Function Get-RandomBytes {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [Byte[]]$Bytes
    )

    $RNG = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $RNG.GetBytes($Bytes)

}