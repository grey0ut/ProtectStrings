<#
.Synopsis
Convert output from Protect-String in to a Cipher Object
#>
Function ConvertTo-CipherObject {
    [cmdletbinding()]
    Param (
        [String]$B64String
    )

    $JSONBytes = Try {
        [System.Convert]::FromBase64String($B64String)
    } Catch {
        Write-Verbose "Unable to decode Input String. Expecting Base64"
        throw
    }

    $JSON = Try {
        ConvertFrom-Bytes -InputBytes $JSONBytes -Encoding UTF8
    } Catch {
        Write-Verbose "Unable to convert bytes with UTF8 encoding"
        throw
    }

    $ObjectData = Try {
        ConvertFrom-Json -InputObject $JSON -ErrorAction Stop
    } Catch {
        Write-Verbose "Unable to convert data from JSON"
        throw
    }
    $CipherObject = Try {
        New-CipherObject -Encryption $($ObjectData.Encryption) -CipherText $($ObjectData.CipherText)
    } Catch {
        Write-Verbose "Unable to create Cipher Object"
        throw
    }
    $CipherObject.DPAPIIdentity = $ObjectData.DPAPIIdentity
    $CipherObject
}