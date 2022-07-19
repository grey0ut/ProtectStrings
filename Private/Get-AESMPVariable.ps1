<#
.Synopsis
Get the password derived key to a global session variable for future use.
.NOTES
Version:        1.0
Author:         C. Bodett
Creation Date:  03/27/2022
Purpose/Change: Initial function development
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

        <#
        If (-not ($SecureAESKey) -and -not ($Boolean)) {
            Set-MasterPassword
            $SecureAESKey = Get-AESMPVariable
        } ElseIf (-not ($SecureAESKey) -and $Boolean) {
            Write-Verbose "No Master Password key found"
            return $false
        }
        #>
        Switch ('{0}{1}' -f [int][bool]$SecureAESKey,[int][bool]$Boolean) {
            "10" {
                Write-Debug "Master Password key found"
            }
            "11" {
                Write-Debug "Master Password key found"
                return $true
            }
            "01" {
                Write-Debug "No Master Password key found"
                return $false
            }
            "00" {
                Write-Debug "No Master Password key found"
                Set-MasterPassword
                $SecureAESKey = Get-AESMPVariable
            }
        }
        
        return $SecureAESKey

    }
}
