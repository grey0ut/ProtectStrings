function Get-MasterPassword {
    <#
    .SYNOPSIS
    Returns the saved MasterPassword derived key.
    .DESCRIPTION
    This function is mostly used to verify that a MasterPassword is currently stored. It returns a SecureString object with the current stored AES key.
    .PARAMETER Boolean
    Will return true/false instead of returning a SecureString object
    .EXAMPLE
    PS C:\> Get-MasterPassword
    System.Security.SecureString

    #>
    [cmdletbinding()]
    [OutputType([System.Security.SecureString], [bool])]
    param (
        [Switch]$Boolean
    )
    Write-Verbose "Checking for stored AES key"

    if ($Boolean) {
        Get-AESMPVariable -Boolean
    } else {
        Get-AESMPVariable
    }
}