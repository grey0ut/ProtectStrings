function Clear-MasterPassword {
    <#
    .SYNOPSIS
    Removes the Master Password stored in the current session
    .DESCRIPTION
    The Master Password is stored as a Secure String object in memory for the current session. Should you wish to clear it manually you can do so with this function.
    .EXAMPLE
    PS C:\> Clear-MasterPassword

    This will erase the currently saved master password.
    #>
    [cmdletbinding()]
    param (
    )

    Write-Verbose "Removing master password from current session"
    Clear-AESMPVariable
}