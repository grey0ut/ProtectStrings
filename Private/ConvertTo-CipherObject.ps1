<#
.Synopsis
Convert output from Protect-String in to a Cipher Object
#>
Function ConvertTo-CipherObject {
    [cmdletbinding()]
    Param (
        [String]$B64String
    )

    switch ($B64String[0]) {
        'A' {
            $Encryption = "AES"
            $CipherText = $B64String.SubString(1)
        }
        'D' {
            $Encryption = "DPAPI"
            $CipherText = $B64String.SubString(1,$B64String.IndexOf('?')-1)
            $DPAPIIdB64 = $B64String.SubString($B64String.IndexOf('?')+1)
            $DPAPIIdBytes = [System.Convert]::FromBase64String($DPAPIIdB64)
            $DPAPIIdentity = ConvertFrom-Bytes -InputBytes $DPAPIIdBytes -Encoding UTF8
        }
        default {
            Write-Verbose "Does not appear to be ProtectStrings module ciphertext"
            throw
        }
    }

    $CipherObject = try {
        New-CipherObject -Encryption $Encryption -CipherText $CipherText
    } catch {
        Write-Verbose "Unable to create Cipher Object"
        throw
    }

    if ($Encryption -eq "DPAPI") {
        $CipherObject.DPAPIIdentity = $DPAPIIdentity
    }
    
    $CipherObject
}