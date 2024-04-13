<#
.Synopsis
A Function to initiate the .NET AESCryptoServiceProvider
#>
Function Initialize-AESCipher {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [Byte[]]$Key
    )

    $AESServiceProvider = New-Object System.Security.Cryptography.AesCryptoServiceProvider
    $AESServiceProvider.Key = $Key
    $AESServiceProvider

}