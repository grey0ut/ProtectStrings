<#
.Synopsis
Convert input AES Cipher text to plain text
#>
Function ConvertFrom-AESCipherText {
        [cmdletbinding()]
        param(
            [Parameter(ValueFromPipeline = $true,Position = 0,Mandatory = $true)]
            [string]$InputCipherText,
            [Parameter(Position = 1,Mandatory = $true)]
            [Byte[]]$Key
        )
    
        Process {
            Write-Verbose "Creating new AES Cipher object with supplied key"
            $AESCipher = Initialize-AESCipher -Key $Key
            Write-Verbose "Convert input text from Base64"
            $EncryptedBytes = [System.Convert]::FromBase64String($InputCipherText)
            Write-Verbose "Using the first 16 bytes as the initialization vector"
            $AESCipher.IV = $EncryptedBytes[0..15]
            Write-Verbose "Decrypting AES cipher text"
            $Decryptor = $AESCipher.CreateDecryptor()
            $UnencryptedBytes = $Decryptor.TransformFinalBlock($EncryptedBytes, 16, $EncryptedBytes.Length - 16)
            $ConvertedString = ConvertFrom-Bytes -InputBytes $UnencryptedBytes -Encoding UTF8
            $ConvertedString
        }
        End {
            Write-Verbose "Disposing of AES Cipher object"
            $AESCipher.Dispose()
        }

}