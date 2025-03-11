<#
.Synopsis
Get the current username and computer name
#>
Function Get-DPAPIIdentity {
    [cmdletbinding()]
    Param (
    )
    
    Write-Verbose "Current ENV:COMPUTERNAME : $ENV:COMPUTERNAME"
    Write-Verbose "Current ENV:USERNAME : $ENV:USERNAME"
    Write-Verbose "Creating DPAPI Identity information"
    $Output = '{0}\{1}' -f $ENV:COMPUTERNAME,$ENV:USERNAME
    $Output
}