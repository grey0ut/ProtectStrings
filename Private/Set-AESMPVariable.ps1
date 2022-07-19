<#
.Synopsis
Set the password derived key to a global session variable for future use.
.NOTES
Version:        1.0
Author:         C. Bodett
Creation Date:  03/27/2022
Purpose/Change: Initial function development
#>
Function Set-AESMPVariable {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [SecureString]$MPKey
    )

    Process {
        Write-Verbose "Creating new variable globally to store AES Key"
        New-Variable -Name "AESMP" -Value $MPKey -Option AllScope -Scope Global -Force
    }
}
