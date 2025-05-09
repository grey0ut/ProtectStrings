function Clear-AESMPVariable {
    <#
    .SYNOPSIS
    Clear the global variable of the previously stored master password/key
    .DESCRIPTION
    Clear the global variable of the previously stored master password/key. This is a private function that won't be exposed to the session
    .EXAMPLE
    Clear-AESMPVariable
    #>
    [cmdletbinding()]
    param (
    )

    process {
        Write-Verbose "Clearing global variable where AES key is stored"
        Remove-Variable -Name "AESMP" -Force -Scope Global -ErrorAction SilentlyContinue
    }
}
