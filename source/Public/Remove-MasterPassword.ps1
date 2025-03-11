Function Remove-MasterPassword {
    <#
    .Synopsis
    Removes the Master Password stored in the current session
    .Description
    The Master Password is stored as a Secure String object in memory for the current session. Should you wish to clear it manually you can do so with this function.
    .EXAMPLE
    PS C:\> Remove-MasterPassword

    This will erase the currently saved master password.
    .NOTES
    Version:        1.0
    Author:         C. Bodett
    Creation Date:  3/28/2022
    Purpose/Change: Initial function development
    #>
    [cmdletbinding()]
    Param (
    )
    Write-Verbose "Removing master password from current session"
    Clear-AESMPVariable

}