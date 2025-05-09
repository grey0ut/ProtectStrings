function Get-DPAPIIdentity {
    <#
    .SYNOPSIS
    get the current username and computer name
    .DESCRIPTION
    get the current username and computer name. This is a private function and won't be exposed to the session.
    .EXAMPLE
    Get-DPAPIIdentity
    #>
    [cmdletbinding()]
    param (
    )

    Write-Verbose "Current ENV:COMPUTERNAME : $ENV:COMPUTERNAME"
    Write-Verbose "Current ENV:USERNAME : $ENV:USERNAME"
    Write-Verbose "Creating DPAPI Identity information"
    $Output = '{0}\{1}' -f $ENV:COMPUTERNAME,$ENV:USERNAME
    $Output
}