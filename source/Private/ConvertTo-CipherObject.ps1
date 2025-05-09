function ConvertTo-CipherObject {
    <#
    .SYNOPSIS
    Convert output from Protect-String in to a Cipher Object
    .DESCRIPTION
    Convert output from Protect-String in to a Cipher Object. This is a private function that won't be exposed to the session.
    .PARAMETER B64String
    The base64 string to instantiate in to a cipher object
    .EXAMPLE
    ConvertTo-CipherObject -B64String VQ==
    #>
    [cmdletbinding()]
    param (
        [string]$B64String
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
            $DPAPIIdentity = [System.Text.Encoding]::UTF8.GetString($DPAPIIdBytes)
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