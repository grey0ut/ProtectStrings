function Get-AESMPVariable {
    <#
    .SYNOPSIS
    Get the password derived key to a global session variable for future use.
    .DESCRIPTION
    Get the password derived key to a global session variable for future use. This is a private function and won't be exposed to the session
    .PARAMETER Boolean
    Switch to return a true/false instead
    .EXAMPLE
    Get-AESMPVariable
    #>
    [cmdletbinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars','',Justification='Required for QoL')]
    [OutputType([bool])]
    param (
        [switch]$Boolean
    )

    $SecureAESKey = $Global:AESMP

    switch ('{0}{1}' -f [int][bool]$SecureAESKey,[int][bool]$Boolean) {
        "10" {
            Write-Verbose "Master Password key found"
        }
        "11" {
            Write-Verbose "Master Password key found"
            return $true
        }
        "01" {
            Write-Verbose "No Master Password key found"
            return $false
        }
        "00" {
            Write-Verbose "No Master Password key found"
            Set-MasterPassword
            $SecureAESKey = Get-AESMPVariable
        }
    }
    $SecureAESKey
}