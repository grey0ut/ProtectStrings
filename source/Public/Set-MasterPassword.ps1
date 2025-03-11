Function Set-MasterPassword {
    <#
    .Synopsis
    Securely retrieves from console the desired master password and saves it for the current session.
    .Description
    Takes a user provided master password as a secure string object and creates a unique AES 256 bit key from it and stores that as a SecureString object in memory for the current session.
    .Parameter MasterPassword
    If you already have a password in a variable as a SecureString object you can pass it to this function.
    .EXAMPLE
    PS C:\> Set-MasterPassword
    Enter Master Password: ********

    In this example you will be prompted to provide a password. It will then be silently stored in the current session.
    .EXAMPLE
    PS C:\> $Pass = Read-Host -AsSecureString
    *****************
    PS C:\> Set-MasterPassword -MasterPassword $Pass


    Here the desired master password is saved beforehand in the variable $Pass and then passed to the Set-MasterPassword function.
    .NOTES
    Version:        1.0
    Author:         C. Bodett
    Creation Date:  3/28/2022
    Purpose/Change: Initial function development
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [SecureString]$MasterPassword 
    )

    If (-not ($MasterPassword)) {
        $MasterPassword = Read-Host -Prompt "Enter Master Password" -AsSecureString
    }

    Try {
        Write-Verbose "Generating a 256-bit AES key from provided password"
        $SecureAESKey = ConvertTo-AESKey $MasterPassword
    } Catch {
        throw $_
    }
    Write-Verbose "Storing key for use within this session. Can be removed with Remove-MasterPassword"
    Set-AESMPVariable -MPKey $SecureAESKey
}