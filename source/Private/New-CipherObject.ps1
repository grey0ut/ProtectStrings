function New-CipherObject {
    <#
    .SYNOPSIS
    Create a new CipherObject
    .DESCRIPTION
    Create a new CipherObject. This is a private function and won't be exposed to the session.
    .PARAMETER Encryption
    The encryption type to use: DPAPI or AES
    .PARAMETER CipherText
    The cipher text to later be decrypted
    .EXAMPLE
    New-CipherObject -Encryption AES -CipherText "AQ=="
    #>
    [cmdletbinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','',Justification='Does not actually change system state')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet("DPAPI","AES")]
        [string]$Encryption,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$CipherText
    )

    [CipherObject]::New($Encryption,$CipherText)
}