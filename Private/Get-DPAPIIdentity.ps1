<#
.Synopsis
Get the current username and computer name
#>
Function Get-DPAPIIdentity {
    [cmdletbinding()]
    Param (
    )
    
    Write-Debug "Current ENV:Computername : $ENV:COMPUTERNAME"
    Write-Debug "Current ENV:Computername : $ENV:USERNAME"
    Write-Debug "Creating DPAPI Identity information"
    $Output = '{0}\{1}' -f $ENV:COMPUTERNAME,$ENV:USERNAME
    return $Output
}