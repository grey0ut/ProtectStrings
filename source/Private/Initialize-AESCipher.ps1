function Initialize-AESCipher {
    <#
    .SYNOPSIS
    A Function to initiate the .NET AESCryptoServiceProvider
    .DESCRIPTION
    A Function to initiate the .NET AESCryptoServiceProvider. This is a private function and won't be exposed to the session.
    .PARAMETER Key
    Byte array containing the key used to create the AES service provider
    .EXAMPLE
    Initialize-AESCipher -Key $Key
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [byte[]]$Key
    )

    $AESServiceProvider = New-Object System.Security.Cryptography.AesCryptoServiceProvider
    $AESServiceProvider.Key = $Key
    $AESServiceProvider
}