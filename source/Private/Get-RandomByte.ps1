function Get-RandomByte {
    <#
    .SYNOPSIS
    A Function to leverage the .NET Random Number Generator
    .DESCRIPTION
    A Function to leverage the .NET Random Number Generator
    .PARAMETER Bytes
    Byte array to have random bytes created within
    .EXAMPLE
    Get-RandomByte -Bytes $ByteArray
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [byte[]]$Bytes
    )

    $RNG = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $RNG.GetBytes($Bytes)
}