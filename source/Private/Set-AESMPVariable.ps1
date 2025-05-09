function Set-AESMPVariable {
    <#
    .SYNOPSIS
    set the password derived key to a global session variable for future use.
    .DESCRIPTION
    set the password derived key to a global session variable for future use. This is a private function and won't be exposed to the session.
    .PARAMETER MPKey
    The SecureString object containing the 256-bit key derived from the master password.
    .EXAMPLE
    Set-AESMPVariable -MPKey $Key
    #>
    [cmdletbinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','',Justification='Does not actually change system state')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [SecureString]$MPKey
    )

    Write-Verbose "Creating new variable globally to store AES Key"
    New-Variable -Name "AESMP" -Value $MPKey -Option AllScope -Scope Global -Force
}