<#
.Synopsis
Clear the global variable of the previously stored master password/key
.NOTES
Version:        1.0
Author:         C. Bodett
Creation Date:  03/28/2022
Purpose/Change: Initial function development
#>
Function Clear-AESMPVariable {
    [cmdletbinding()]
    Param (
    )

    Process {
        Write-Verbose "Clearing global variable where AES key is stored"
        Remove-Variable -Name "AESMP" -Force -Scope Global -ErrorAction SilentlyContinue
    }
}
