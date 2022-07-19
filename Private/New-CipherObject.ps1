<#
.Synopsis
Create a new CipherObject
#>
Function New-CipherObject {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet("DPAPI","AES")]
        [String]$Encryption,
        [Parameter(Mandatory = $true, Position = 1)]
        [String]$CipherText
    )
 
    [CipherObject]::New($Encryption,$CipherText)
    
}