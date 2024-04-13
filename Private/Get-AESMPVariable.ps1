<#
.Synopsis
Get the password derived key to a global session variable for future use.
.NOTES
Version:        1.1
Author:         C. Bodett
Creation Date:  05/12/2022
Purpose/Change: changed logic from if/ifelse to switch statement
#>
Function Get-AESMPVariable {
    [cmdletbinding()]
    Param (
        [Switch]$Boolean
    )

    Process {
        $SecureAESKey = Try {
            $Global:AESMP
        } Catch {
            # do nothing
        }
        Switch ('{0}{1}' -f [int][bool]$SecureAESKey,[int][bool]$Boolean) {
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
}
