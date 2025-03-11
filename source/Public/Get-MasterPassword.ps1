Function Get-MasterPassword {
    <#
    .Synopsis
    Returns the saved MasterPassword derived key.
    .Description
    This function is mostly used to verify that a MasterPassword is currently stored. It returns a SecureString object with the current stored AES key.
    .EXAMPLE
    PS C:\> Get-MasterPassword

    does stuff
    .NOTES
    Version:        1.0
    Author:         C. Bodett
    Creation Date:  3/28/2022
    Purpose/Change: Initial function development
    #>
    [cmdletbinding()]
    Param (
        [Switch]$Boolean
    )
    Write-Verbose "Checking for stored AES key"

    if ($Boolean) {
        Get-AESMPVariable -Boolean
    } else {
        Get-AESMPVariable
    }

}